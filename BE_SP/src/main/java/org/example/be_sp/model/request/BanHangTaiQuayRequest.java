package org.example.be_sp.model.request;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BanHangTaiQuayRequest {
    private Integer idKhachHang;
    private Integer idPhieuGiamGia;
    private Integer idNhanVien;
    private Integer idPhuongThucThanhToan;
    private Integer idTrangThaiDonHang;
    private HashMap<Integer, Integer> danhSachSanPham; // key: idSanPham, value: soLuong
    private BigDecimal phiVanChuyen;
    private BigDecimal tongTien;
    private BigDecimal tongTienSauGiam;
    private String tenNguoiNhan;
    private String diaChiNhanHang;
    private String soDienThoaiNguoiNhan;
    private String emailNguoiNhan;
    private LocalDate ngayTao;
    private LocalDate ngayThanhToan;
    private Boolean trangThai;
    private Boolean deleted;
}
