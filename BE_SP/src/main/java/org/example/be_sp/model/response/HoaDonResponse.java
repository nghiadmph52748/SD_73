package org.example.be_sp.model.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.example.be_sp.entity.HoaDon;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class HoaDonResponse {
    private Integer id;
    private String maKhachHang;
    private String tenKhachHang;
    private String email;
    private String soDienThoai;
    private String maPhieuGiamGia;
    private String tenPhieuGiamGia;
    private Boolean loaiPhieuGiamGia;
    private BigDecimal giaTriGiamGia;
    private BigDecimal soTienToiDa;
    private String tenNhanVien;
    private String tenHoaDon;
    private Boolean loaiDon;
    private BigDecimal phiVanChuyen;
    private BigDecimal tongTien;
    private BigDecimal tongTienSauGiam;
    private String ghiChu;
    private String tenNguoiNhan;
    private String diaChiNhanHang;
    private String soDienThoaiNguoiNhan;
    private String emailNguoiNhan;
    private LocalDate ngayTao;
    private LocalDate ngayThanhToan;
    private Boolean trangThai;
    private Boolean deleted;
    private LocalDate createAt;
    private Integer createBy;
    private LocalDate updateAt;
    private Integer updateBy;
    private List<String> tenSanPhams;
    private List<HinhThucThanhToanReponse> lichSuThanhToan;
    private List<HoaDonChiTietResponse> chiTietSanPham;
    private Integer idNhanVien;
    private List<String> ghiChus;
    private List<HoaDonChiTietResponse> items;
    public HoaDonResponse(HoaDon hd) {
        this.id = hd.getId();

        // Khách hàng
        if (hd.getIdKhachHang() != null) {
            this.maKhachHang = hd.getIdKhachHang().getMaKhachHang();
            this.tenKhachHang = hd.getIdKhachHang().getTenKhachHang();
            this.email = hd.getIdKhachHang().getEmail();
            this.soDienThoai = hd.getIdKhachHang().getSoDienThoai();
        }

        // Phiếu giảm giá
        if (hd.getIdPhieuGiamGia() != null) {
            this.maPhieuGiamGia = hd.getIdPhieuGiamGia().getMaPhieuGiamGia();
            this.tenPhieuGiamGia = hd.getIdPhieuGiamGia().getTenPhieuGiamGia();
            this.loaiPhieuGiamGia = hd.getIdPhieuGiamGia().getLoaiPhieuGiamGia();
            this.giaTriGiamGia = hd.getIdPhieuGiamGia().getGiaTriGiamGia();
            this.soTienToiDa = hd.getIdPhieuGiamGia().getSoTienToiDa();
        }



        this.tenHoaDon = hd.getTenHoaDon();
        this.loaiDon = hd.getLoaiDon();
        this.phiVanChuyen = hd.getPhiVanChuyen();
        this.tongTien = hd.getTongTien();
        this.tongTienSauGiam = hd.getTongTienSauGiam();
        this.ghiChu = hd.getGhiChu();
        this.tenNguoiNhan = hd.getTenNguoiNhan();
        this.diaChiNhanHang = hd.getDiaChiNguoiNhan();
        this.soDienThoaiNguoiNhan = hd.getSoDienThoaiNguoiNhan();
        this.emailNguoiNhan = hd.getEmailNguoiNhan();
        this.ngayTao = hd.getNgayTao();
        this.ngayThanhToan = hd.getNgayThanhToan();
        this.trangThai = hd.getTrangThai();
        this.deleted = hd.getDeleted();
        this.createAt = hd.getCreateAt();
        this.createBy = hd.getCreateBy();
        this.updateAt = hd.getUpdateAt();
        this.updateBy = hd.getUpdateBy();

        // Mapping chi tiết sản phẩm
        // Mapping danh sách sản phẩm (items cho frontend)
//        if (hd.getHoaDonChiTiets() != null) {
////            this.items = hd.getHoaDonChiTiets()
////                    .stream()
////                    .map(HoaDonChiTietResponse::new)  // map sang response chi tiết
////                    .toList();
//
////            // Nếu vẫn muốn có list tên sản phẩm riêng
//            this.tenSanPhams = hd.getHoaDonChiTiets()
//                    .stream()
//                    .map(ct -> ct.getIdChiTietSanPham()
//                            .getIdSanPham()
//                            .getTenSanPham())
//                    .toList();
//        }
        if (hd.getHoaDonChiTiets() != null) {
            this.items = hd.getHoaDonChiTiets()
                    .stream()
                    .map(HoaDonChiTietResponse::new)
                    .toList();
        }

        // Mapping lịch sử thanh toán
        if (hd.getHinhThucThanhToans() != null) {
            this.lichSuThanhToan = hd.getHinhThucThanhToans()
                    .stream()
                    .map(HinhThucThanhToanReponse::new)
                    .toList();
        }
        this.ghiChus = hd.getHoaDonChiTiets()
                .stream()
                .map(ct -> ct.getGhiChu())
                .toList();
        // Nhân viên
        if (hd.getIdNhanVien() != null) {
            this.tenNhanVien = hd.getIdNhanVien().getTenNhanVien();
            this.idNhanVien = hd.getIdNhanVien().getId();
        }
        // Mapping chi tiết sản phẩm


    }




}
