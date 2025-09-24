package org.example.be_sp.model.request;

import lombok.Data;

@Data
public class VnpayCreatePaymentRequest {
    private Long amount;         // VND
    private String orderId;      // your order code
    private String orderInfo;    // description (non-accented)
    private String bankCode;     // optional: VNPAYQR, VNBANK, INTCARD or specific bank code
    private String locale;       // vn or en (optional)
}
