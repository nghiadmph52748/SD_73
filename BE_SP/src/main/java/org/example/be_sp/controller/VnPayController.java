package org.example.be_sp.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.Data;
import org.example.be_sp.model.request.VnpayCreatePaymentRequest;
import org.example.be_sp.model.response.ResponseObject;
import org.example.be_sp.model.response.VnpayCreatePaymentResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.core.env.Environment;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping("/api/payment/vnpay")
@CrossOrigin(origins = "*")
public class VnPayController {

    private final Environment env;

    public VnPayController(Environment env) {
        this.env = env;
    }

    @PostMapping("/create")
    public ResponseObject<VnpayCreatePaymentResponse> createPayment(@RequestBody VnpayCreatePaymentRequest req,
                                                                    HttpServletRequest http) {
        try {
            String vnpTmnCode = get("vnp.tmnCode", "");
            String vnpHashSecret = get("vnp.hashSecret", "");
            String vnpReturnUrl = get("vnp.returnUrl", "http://localhost:8080/api/payment/vnpay/return");
            String vnpPayUrl = get("vnp.payUrl", "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html");

            if (!StringUtils.hasText(vnpTmnCode) || !StringUtils.hasText(vnpHashSecret)) {
                return ResponseObject.error("VNPAY configuration is missing (tmnCode/hashSecret)");
            }

            long amount = Optional.ofNullable(req.getAmount()).orElse(0L);
            if (amount <= 0) {
                return ResponseObject.error("Invalid amount");
            }

            String locale = StringUtils.hasText(req.getLocale()) ? req.getLocale() : "vn";
            String orderInfoRaw = StringUtils.hasText(req.getOrderInfo()) ? req.getOrderInfo() : "Thanh toan don hang";
            String orderInfo = normalizeAscii(orderInfoRaw);

            // Always create a unique attempt reference to avoid "transaction exists" in VNPAY
            String baseId = StringUtils.hasText(req.getOrderId()) ? req.getOrderId() : "HD";
            String attempt = String.valueOf(System.currentTimeMillis() % 1_000_000L); // 6 digits
            String txnRef = (baseId + "-" + attempt).replaceAll("[^A-Za-z0-9_-]", "");
            if (txnRef.length() > 32) txnRef = txnRef.substring(0, 32);

            String ip = getClientIp(http);
            String createDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+7"));
            cal.add(Calendar.MINUTE, 15); // 15 minutes expiry
            String expireDate = new SimpleDateFormat("yyyyMMddHHmmss").format(cal.getTime());

            Map<String, String> vnp = new HashMap<>();
            vnp.put("vnp_Version", "2.1.0");
            vnp.put("vnp_Command", "pay");
            vnp.put("vnp_TmnCode", vnpTmnCode);
            vnp.put("vnp_Amount", String.valueOf(amount * 100));
            vnp.put("vnp_CurrCode", "VND");
            vnp.put("vnp_TxnRef", txnRef);
            vnp.put("vnp_OrderInfo", orderInfo);
            vnp.put("vnp_OrderType", "other");
            vnp.put("vnp_Locale", locale);
            vnp.put("vnp_ReturnUrl", vnpReturnUrl);
            vnp.put("vnp_IpAddr", ip);
            vnp.put("vnp_CreateDate", createDate);
            vnp.put("vnp_ExpireDate", expireDate);
            if (StringUtils.hasText(req.getBankCode())) {
                vnp.put("vnp_BankCode", req.getBankCode());
            }

            String query = buildQuery(vnp);
            String secureHash = hmacSHA512(vnpHashSecret, query);
            String payUrl = vnpPayUrl + "?" + query + "&vnp_SecureHash=" + secureHash;

            return new ResponseObject<>(new VnpayCreatePaymentResponse(payUrl, txnRef));
        } catch (Exception e) {
            return ResponseObject.error("VNPAY create error: " + e.getMessage());
        }
    }

    @GetMapping("/return")
    public ResponseEntity<?> handleReturn(HttpServletRequest req) throws Exception {
        String vnpHashSecret = get("vnp.hashSecret", "");
        Map<String, String> params = extractParams(req);
        String receivedHash = req.getParameter("vnp_SecureHash");
        String hashData = buildQuery(params);
        String calc = hmacSHA512(vnpHashSecret, hashData);

        String frontBase = get("app.frontendUrl", "http://localhost:5173");
        // Build redirect URL to frontend result page with summarized params
        StringBuilder redirect = new StringBuilder(frontBase);
        if (!frontBase.endsWith("/")) redirect.append('/');
        redirect.append("payment/vnpay/result?");

        String code;
        if (!calc.equalsIgnoreCase(receivedHash)) {
            code = "97"; // signature invalid
        } else {
            code = req.getParameter("vnp_ResponseCode");
        }

        Map<String, String> out = new LinkedHashMap<>();
        out.put("code", code);
        out.put("txnRef", req.getParameter("vnp_TxnRef"));
        out.put("amount", req.getParameter("vnp_Amount"));
        out.put("bankCode", req.getParameter("vnp_BankCode"));
        out.put("bankTranNo", req.getParameter("vnp_BankTranNo"));
        out.put("cardType", req.getParameter("vnp_CardType"));
        out.put("orderInfo", req.getParameter("vnp_OrderInfo"));
        out.put("payDate", req.getParameter("vnp_PayDate"));
        out.put("transactionNo", req.getParameter("vnp_TransactionNo"));

        // Append encoded params
        int i = 0;
        for (Map.Entry<String, String> e : out.entrySet()) {
            if (e.getValue() == null) continue;
            if (i++ > 0) redirect.append('&');
            redirect.append(e.getKey()).append('=')
                    .append(java.net.URLEncoder.encode(e.getValue(), java.nio.charset.StandardCharsets.UTF_8));
        }

        return ResponseEntity.status(302).location(java.net.URI.create(redirect.toString())).build();
    }

    @GetMapping("/ipn")
    public ResponseEntity<Map<String, String>> handleIpn(HttpServletRequest req) throws Exception {
        String vnpHashSecret = get("vnp.hashSecret", "");
        Map<String, String> params = extractParams(req);
        String receivedHash = req.getParameter("vnp_SecureHash");
        String hashData = buildQuery(params);
        String calc = hmacSHA512(vnpHashSecret, hashData);
        Map<String, String> resp = new HashMap<>();
        if (!calc.equalsIgnoreCase(receivedHash)) {
            resp.put("RspCode", "97"); // invalid signature
            resp.put("Message", "Invalid signature");
            return ResponseEntity.ok(resp);
        }
        // TODO: check order existence, amount matching and idempotency
        resp.put("RspCode", "00");
        resp.put("Message", "Confirm Success");
        return ResponseEntity.ok(resp);
    }

    private static String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        return (ip != null && !ip.isBlank()) ? ip.split(",")[0].trim() : req.getRemoteAddr();
    }

    private static Map<String, String> extractParams(HttpServletRequest req) {
        Map<String, String[]> raw = req.getParameterMap();
        Map<String, String> map = new HashMap<>();
        for (Map.Entry<String, String[]> e : raw.entrySet()) {
            String k = e.getKey();
            if ("vnp_SecureHash".equals(k) || "vnp_SecureHashType".equals(k)) continue;
            map.put(k, e.getValue()[0]);
        }
        return new TreeMap<>(map); // sorted by key
    }

    private static String buildQuery(Map<String, String> params) {
        // params must be sorted by key ASC
        SortedMap<String, String> sorted = new TreeMap<>(params);
        StringBuilder sb = new StringBuilder();
        int i = 0;
        for (Map.Entry<String, String> e : sorted.entrySet()) {
            if (i++ > 0) sb.append('&');
            sb.append(e.getKey()).append('=')
              .append(URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8));
        }
        return sb.toString();
    }

    private static String hmacSHA512(String secret, String data) throws Exception {
        javax.crypto.Mac hmac = javax.crypto.Mac.getInstance("HmacSHA512");
        javax.crypto.spec.SecretKeySpec sk = new javax.crypto.spec.SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
        hmac.init(sk);
        byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    private String get(String key, String defVal) {
        String v = env.getProperty(key);
        return (v == null || v.isBlank()) ? defVal : v;
    }

    private static String normalizeAscii(String input) {
        if (input == null) return "";
        String normalized = java.text.Normalizer.normalize(input, java.text.Normalizer.Form.NFD);
        normalized = normalized.replaceAll("[\\u0300-\\u036f]", ""); // strip accents
        // Remove any non-printable characters
        return normalized.replaceAll("[^\\x20-\\x7E]", "");
    }
}
