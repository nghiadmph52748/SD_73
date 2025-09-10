package org.example.be_sp.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.example.be_sp.entity.ChiTietSanPham;
import org.example.be_sp.entity.HoaDon;
import org.example.be_sp.exception.ApiException;
import org.example.be_sp.model.request.BanHangTaiQuayRequest;
import org.example.be_sp.model.request.HoaDonChiTietRequest;
import org.example.be_sp.model.response.HoaDonResponse;
import org.example.be_sp.model.response.PagingResponse;
import org.example.be_sp.repository.ChiTietSanPhamRepository;
import org.example.be_sp.repository.HoaDonRepository;
import org.example.be_sp.repository.KhachHangRepository;
import org.example.be_sp.repository.NhanVienRepository;
import org.example.be_sp.util.MapperUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class HoaDonService {
    @Autowired
    private HoaDonRepository hoaDonRepository;
    @Autowired
    KhachHangRepository khachHangRepository;
    @Autowired
    NhanVienRepository nhanVienRepository;
    @Autowired
    PhieuGiamGiaService phieuGiamGiaService;
    @Autowired
    HoaDonChiTietService hoaDonChiTietService;
    @Autowired
    ChiTietSanPhamRepository chiTietSanPhamRepository;



    public List<HoaDonResponse> getAll() {
        return hoaDonRepository.findAll().stream().map(HoaDonResponse::new).toList();
    }
    public PagingResponse<HoaDonResponse> phanTrang(Integer no, Integer size) {
        Pageable page = PageRequest.of(no, size);
        return new PagingResponse<>(hoaDonRepository.findAll(page).map(HoaDonResponse::new), no);
    }

    public HoaDonResponse getByid(Integer id) {
        HoaDon hoaDon = hoaDonRepository.findById(id).orElseThrow(() -> new ApiException("Không tìm thấy hóa đơn","404"));
        return new HoaDonResponse(hoaDon);
    }
    public void add(BanHangTaiQuayRequest request) {
        System.out.println("🔄 === BẮT ĐẦU TẠO HÓA ĐƠN ===");
        System.out.println("📋 Danh sách sản phẩm: " + request.getDanhSachSanPham());

        HoaDon hd = MapperUtils.map(request, HoaDon.class);

        // Set loại đơn mặc định là 0 (bán hàng tại quầy) nếu không được truyền
        if (request.getLoaiDon() == null) {
            hd.setLoaiDon(false); // 0 = bán hàng tại quầy
        }

        hd.setIdKhachHang(khachHangRepository.findKhachHangById(request.getIdKhachHang()));
        hd.setIdPhieuGiamGia(phieuGiamGiaService.getById(request.getIdPhieuGiamGia()));
        hd.setIdNhanVien(nhanVienRepository.getById(request.getIdNhanVien()));
        hd.setDiaChiNguoiNhan(request.getDiaChiNhanHang());
        hd.setCreateAt(LocalDate.now());

        // Lưu hóa đơn trước
        System.out.println("💾 Đang lưu hóa đơn...");
        HoaDon savedHoaDon = hoaDonRepository.save(hd);
        System.out.println("✅ Đã lưu hóa đơn thành công với ID: " + savedHoaDon.getId());

        // Lưu chi tiết sản phẩm
        if (request.getDanhSachSanPham() != null && !request.getDanhSachSanPham().isEmpty()) {
            System.out.println("🛒 Bắt đầu xử lý " + request.getDanhSachSanPham().size() + " sản phẩm chi tiết...");

            for (Integer idChiTietSanPham : request.getDanhSachSanPham().keySet()) {
                System.out.println("📦 Đang xử lý sản phẩm ID: " + idChiTietSanPham);
                Integer soLuong = request.getDanhSachSanPham().get(idChiTietSanPham);

                // Lấy thông tin chi tiết sản phẩm để tính giá và kiểm tra số lượng
                ChiTietSanPham chiTietSanPham = chiTietSanPhamRepository.findChiTietSanPhamById(idChiTietSanPham);
                if (chiTietSanPham == null) {
                    throw new ApiException("Không tìm thấy chi tiết sản phẩm với ID: " + idChiTietSanPham, "404");
                }

                // Kiểm tra số lượng có đủ không
                if (chiTietSanPham.getSoLuong() == null || chiTietSanPham.getSoLuong() < soLuong) {
                    throw new ApiException(
                        "Không đủ số lượng sản phẩm " + chiTietSanPham.getIdSanPham().getTenSanPham() +
                        ". Còn lại: " + (chiTietSanPham.getSoLuong() != null ? chiTietSanPham.getSoLuong() : 0) +
                        ", yêu cầu: " + soLuong,
                        "400"
                    );
                }

                // Kiểm tra sản phẩm có trạng thái active không
                if (!Boolean.TRUE.equals(chiTietSanPham.getTrangThai())) {
                    throw new ApiException("Sản phẩm " + chiTietSanPham.getIdSanPham().getTenSanPham() + " hiện không khả dụng", "400");
                }

                // Tạo request cho chi tiết hóa đơn
                HoaDonChiTietRequest chiTietRequest = new HoaDonChiTietRequest();
                chiTietRequest.setIdHoaDon(savedHoaDon.getId());
                chiTietRequest.setIdChiTietSanPham(idChiTietSanPham);
                chiTietRequest.setSoLuong(soLuong);
                chiTietRequest.setGiaBan(chiTietSanPham.getGiaBan());
                chiTietRequest.setThanhTien(chiTietSanPham.getGiaBan().multiply(BigDecimal.valueOf(soLuong)));
                chiTietRequest.setTrangThai(true);
                chiTietRequest.setDeleted(false);

                // Lưu chi tiết hóa đơn
                hoaDonChiTietService.add(chiTietRequest);

                // Giảm số lượng trong kho
                Integer soLuongCu = chiTietSanPham.getSoLuong();
                Integer soLuongMoi = soLuongCu - soLuong;
                System.out.println("📦 Giảm số lượng sản phẩm '" + chiTietSanPham.getIdSanPham().getTenSanPham() +
                    "' từ " + soLuongCu + " xuống " + soLuongMoi + " (bán: " + soLuong + ")");

                chiTietSanPham.setSoLuong(soLuongMoi);
                chiTietSanPham.setUpdateAt(LocalDate.now());
                chiTietSanPhamRepository.save(chiTietSanPham);

                System.out.println("✅ Đã cập nhật số lượng sản phẩm trong kho thành công");
            }
        } else {
            System.out.println("⚠️ Không có sản phẩm nào trong danh sách");
        }

        System.out.println("🎉 === HOÀN THÀNH TẠO HÓA ĐƠN ===");
        System.out.println("📄 Hóa đơn ID: " + savedHoaDon.getId());
        System.out.println("💰 Tổng tiền: " + savedHoaDon.getTongTien());
        System.out.println("💸 Tổng tiền sau giảm: " + savedHoaDon.getTongTienSauGiam());
        System.out.println("=====================================");
    }
    public HoaDonResponse update(Integer id, BanHangTaiQuayRequest request) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new ApiException("Không tìm thấy hóa đơn","404"));

        // Cập nhật thủ công từng field
        if (request.getTenNguoiNhan() != null) {
            hd.setTenNguoiNhan(request.getTenNguoiNhan());
        }
        if (request.getDiaChiNhanHang() != null) {
            hd.setDiaChiNguoiNhan(request.getDiaChiNhanHang());
        }
        if (request.getSoDienThoaiNguoiNhan() != null) {
            hd.setSoDienThoaiNguoiNhan(request.getSoDienThoaiNguoiNhan());
        }
        if (request.getEmailNguoiNhan() != null) {
            hd.setEmailNguoiNhan(request.getEmailNguoiNhan());
        }
        if (request.getTongTien() != null) {
            hd.setTongTien(request.getTongTien());
        }
        if (request.getTongTienSauGiam() != null) {
            hd.setTongTienSauGiam(request.getTongTienSauGiam());
        }
        if (request.getPhiVanChuyen() != null) {
            hd.setPhiVanChuyen(request.getPhiVanChuyen());
        }
        if (request.getLoaiDon() != null) {
            hd.setLoaiDon(request.getLoaiDon());   // ✅ update loại đơn
        }
        if (request.getTrangThai() != null) {
            hd.setTrangThai(request.getTrangThai());
        }
        if (request.getNgayTao() != null) {
            hd.setNgayTao(request.getNgayTao());
        }
        if (request.getNgayThanhToan() != null) {
            hd.setNgayThanhToan(request.getNgayThanhToan());
        }
        if (request.getGhiChu() != null) {
            hd.setGhiChu(request.getGhiChu());
        }

        // Gán lại các quan hệ
        if (request.getIdKhachHang() != null) {
            hd.setIdKhachHang(khachHangRepository.findKhachHangById(request.getIdKhachHang()));
        }
        if (request.getIdPhieuGiamGia() != null) {
            hd.setIdPhieuGiamGia(phieuGiamGiaService.getById(request.getIdPhieuGiamGia()));
        }
        if (request.getIdNhanVien() != null) {
            hd.setIdNhanVien(nhanVienRepository.getById(request.getIdNhanVien()));
        }

        hd.setUpdateAt(LocalDate.now());

        HoaDon saved = hoaDonRepository.save(hd);
        return new HoaDonResponse(saved);
    }



    public void delete(Integer id) {
        HoaDon hd = hoaDonRepository.findById(id).orElseThrow(() -> new ApiException("Không tìm thấy hóa đơn","404"));
        hd.setDeleted(true);
        hoaDonRepository.save(hd);
    }



}
