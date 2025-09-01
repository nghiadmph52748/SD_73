package org.example.be_sp.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/thong-ke")
public class ThongKeController {

    @GetMapping("/order-status-distribution")
    public ResponseEntity<Map<String, Object>> getOrderStatusDistribution() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", new HashMap<String, Integer>() {{
            put("pending", 12);
            put("processing", 8);
            put("shipped", 25);
            put("delivered", 45);
            put("cancelled", 3);
        }});
        return ResponseEntity.ok(response);
    }

    @GetMapping("/top-products")
    public ResponseEntity<Map<String, Object>> getTopProducts(@RequestParam(defaultValue = "5") int limit) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", new java.util.ArrayList<Map<String, Object>>() {{
            add(new HashMap<String, Object>() {{ 
                put("name", "Giày Nike Air Max");
                put("sales", 156);
                put("revenue", 12500000);
            }});
            add(new HashMap<String, Object>() {{ 
                put("name", "Áo Adidas Classic");
                put("sales", 134);
                put("revenue", 8900000);
            }});
            add(new HashMap<String, Object>() {{ 
                put("name", "Quần Puma Training");
                put("sales", 98);
                put("revenue", 6700000);
            }});
        }});
        return ResponseEntity.ok(response);
    }

    @GetMapping("/quick-stats")
    public ResponseEntity<Map<String, Object>> getQuickStats() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", new HashMap<String, Object>() {{
            put("totalOrders", 1247);
            put("totalRevenue", 89450000);
            put("totalCustomers", 856);
            put("totalProducts", 234);
            put("pendingOrders", 23);
            put("lowStockProducts", 12);
        }});
        return ResponseEntity.ok(response);
    }

    @GetMapping("/key-metrics")
    public ResponseEntity<Map<String, Object>> getKeyMetrics() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", new HashMap<String, Object>() {{
            put("salesGrowth", 15.6);
            put("customerGrowth", 8.3);
            put("orderGrowth", 12.1);
            put("revenueGrowth", 18.9);
        }});
        return ResponseEntity.ok(response);
    }

    @GetMapping("/time-based-stats")
    public ResponseEntity<Map<String, Object>> getTimeBasedStats() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", new HashMap<String, Object>() {{
            put("daily", new java.util.ArrayList<Map<String, Object>>() {{
                add(new HashMap<String, Object>() {{ 
                    put("date", "2024-01-01");
                    put("orders", 23);
                    put("revenue", 1250000);
                }});
                add(new HashMap<String, Object>() {{ 
                    put("date", "2024-01-02");
                    put("orders", 31);
                    put("revenue", 1890000);
                }});
            }});
            put("weekly", new HashMap<String, Integer>() {{
                put("week1", 145);
                put("week2", 167);
                put("week3", 189);
                put("week4", 201);
            }});
            put("monthly", new HashMap<String, Integer>() {{
                put("jan", 1456);
                put("feb", 1678);
                put("mar", 1892);
            }});
        }});
        return ResponseEntity.ok(response);
    }

    @GetMapping("/chart-data")
    public ResponseEntity<Map<String, Object>> getChartData(@RequestParam(defaultValue = "THANG") String period) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        
        if ("THANG".equals(period)) {
            response.put("data", new HashMap<String, Object>() {{
                put("labels", new String[]{"T1", "T2", "T3", "T4", "T5", "T6"});
                put("datasets", new java.util.ArrayList<Map<String, Object>>() {{
                    add(new HashMap<String, Object>() {{
                        put("label", "Doanh thu");
                        put("data", new int[]{12500000, 15600000, 18900000, 22100000, 19800000, 25400000});
                        put("backgroundColor", "#3B82F6");
                    }});
                    add(new HashMap<String, Object>() {{
                        put("label", "Đơn hàng");
                        put("data", new int[]{145, 189, 234, 267, 245, 298});
                        put("backgroundColor", "#10B981");
                    }});
                }});
            }});
        }
        
        return ResponseEntity.ok(response);
    }
}
