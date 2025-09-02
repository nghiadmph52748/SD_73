package org.example.be_sp.service;

import org.example.be_sp.entity.DotGiamGia;
import org.example.be_sp.entity.HoaDon;
import org.example.be_sp.entity.HoaDonChiTiet;
import org.example.be_sp.exception.ApiException;
import org.example.be_sp.model.request.BanHangTaiQuayRequest;
import org.example.be_sp.model.response.HoaDonResponse;
import org.example.be_sp.model.response.PagingResponse;
import org.example.be_sp.repository.*;
import org.example.be_sp.util.MapperUtils;
import org.hibernate.annotations.Array;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.List;

@Service
public class HoaDonService {
    @Autowired
    private HoaDonRepository hoaDonRepository;
    @Autowired
    private HoaDonChiTietRepository hoaDonChiTietRepository;
    @Autowired
    private ChiTietSanPhamRepository chiTietSanPhamRepository;
    @Autowired
    KhachHangRepository khachHangRepository;
    @Autowired
    NhanVienRepository nhanVienRepository;
    @Autowired
    PhieuGiamGiaService phieuGiamGiaService;
    @Autowired
    DotGiamGiaRepository dotGiamGiaRepository;


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
        HoaDon hd = MapperUtils.map(request, HoaDon.class);
        hd.setIdKhachHang(khachHangRepository.findKhachHangById(request.getIdKhachHang()));
        hd.setIdPhieuGiamGia(phieuGiamGiaService.getById(request.getIdPhieuGiamGia()));
        hd.setIdNhanVien(nhanVienRepository.getById(request.getIdNhanVien()));
        hd.setDiaChiNguoiNhan(request.getDiaChiNhanHang());
        hd.setLoaiDon(true); // bán tại quầy
        HoaDon saved = hoaDonRepository.save(hd);
        for (Integer idSanPham : request.getDanhSachSanPham().keySet()) {
            HoaDonChiTiet hdct = new HoaDonChiTiet();
            hdct.setIdHoaDon(saved);
            var chiTiet = chiTietSanPhamRepository.getById(idSanPham);
            hdct.setIdChiTietSanPham(chiTiet);
            Integer soLuong = request.getDanhSachSanPham().get(idSanPham);
            hdct.setSoLuong(soLuong);
            java.math.BigDecimal giaGoc = chiTiet.getGiaBan();
            Integer phanTramGiam = dotGiamGiaRepository.findById(idSanPham)
                    .map(DotGiamGia::getGiaTriGiamGia)
                    .orElse(0);
            if (phanTramGiam < 0) phanTramGiam = 0;
            if (phanTramGiam > 100) phanTramGiam = 100;
            BigDecimal discountMultiplier = BigDecimal.valueOf(100 - phanTramGiam)
                    .divide(BigDecimal.valueOf(100), MathContext.DECIMAL64);
            BigDecimal giaSauGiam = giaGoc.multiply(discountMultiplier)
                    .setScale(2, RoundingMode.HALF_UP);
            hdct.setGiaBan(giaSauGiam);
            hdct.setThanhTien(giaSauGiam.multiply(BigDecimal.valueOf(soLuong))
                    .setScale(2, RoundingMode.HALF_UP));
            hdct.setTrangThai(true);
            hdct.setDeleted(false);
            hoaDonChiTietRepository.save(hdct);
        }
    }
    public void update(Integer id, BanHangTaiQuayRequest request) {
        HoaDon hd = hoaDonRepository.findById(id).orElseThrow(() -> new ApiException("Không tìm thấy hóa đơn","404"));
        MapperUtils.mapToExisting(request, hd);
        hd.setIdKhachHang(khachHangRepository.findKhachHangById(request.getIdKhachHang()));
        hd.setIdPhieuGiamGia(phieuGiamGiaService.getById(request.getIdPhieuGiamGia()));
        hd.setIdNhanVien(nhanVienRepository.getById(request.getIdNhanVien()));
        hoaDonRepository.save(hd);
    }
    public void delete(Integer id) {
        HoaDon hd = hoaDonRepository.findById(id).orElseThrow(() -> new ApiException("Không tìm thấy hóa đơn","404"));
        hd.setDeleted(true);
        hoaDonRepository.save(hd);
    }

}
