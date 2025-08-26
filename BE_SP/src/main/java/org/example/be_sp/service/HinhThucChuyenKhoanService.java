package org.example.be_sp.service;

import org.example.be_sp.entity.HinhThucThanhToan;
import org.example.be_sp.exception.ApiException;
import org.example.be_sp.model.request.HinhThucThanhToanRequest;
import org.example.be_sp.model.response.HinhThucThanhToanReponse;
import org.example.be_sp.model.response.PagingResponse;
import org.example.be_sp.repository.HinhThucChuyenKhoanRepository;
import org.example.be_sp.repository.HoaDonRepository;
import org.example.be_sp.repository.PhuongThucThanhToanRepository;
import org.example.be_sp.util.MapperUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HinhThucChuyenKhoanService {
    @Autowired
    private HinhThucChuyenKhoanRepository hinhThucChuyenKhoanRepository;
    @Autowired
    private HoaDonRepository hoaDonService;
    @Autowired
    private PhuongThucThanhToanRepository phuongThucThanhToanRepository;

    public List<HinhThucThanhToanReponse> getAll() {
        return hinhThucChuyenKhoanRepository.findAll().stream().map(HinhThucThanhToanReponse::new).toList();
    }
    public PagingResponse<HinhThucThanhToanReponse> phanTrang(Integer no, Integer size) {
        Pageable page = PageRequest.of(no,size);
        return new PagingResponse<>(hinhThucChuyenKhoanRepository.findAll(page).map(HinhThucThanhToanReponse::new),no);
    }
    public HinhThucThanhToanReponse getByid(Integer id) {
        return hinhThucChuyenKhoanRepository.findById(id).map(HinhThucThanhToanReponse::new).orElseThrow(()-> new ApiException("Không tìm thấy hình thức chuyển khoản với id: " + id,"404"));
    }
    public void add(HinhThucThanhToanRequest hinhThucThanhToanRequest) {
        HinhThucThanhToan ht = MapperUtils.map( hinhThucThanhToanRequest, HinhThucThanhToan.class);
        ht.setIdHoaDon(hoaDonService.getById(hinhThucThanhToanRequest.getIdHoaDon()));
        ht.setIdPhuongThucThanhToan(phuongThucThanhToanRepository.getById(hinhThucThanhToanRequest.getIdPhuongThucThanhToan()));
        hinhThucChuyenKhoanRepository.save(ht);
    }
    public void update(Integer id, HinhThucThanhToanRequest hinhThucThanhToanRequest) {
        HinhThucThanhToan ht = hinhThucChuyenKhoanRepository.findById(id).orElseThrow(()-> new ApiException("Không tìm thấy hình thức chuyển khoản với id: " + id,"404"));
        MapperUtils.mapToExisting(hinhThucThanhToanRequest,ht);
        ht.setIdHoaDon(hoaDonService.getById(hinhThucThanhToanRequest.getIdHoaDon()));
        ht.setIdPhuongThucThanhToan(phuongThucThanhToanRepository.getById(hinhThucThanhToanRequest.getIdPhuongThucThanhToan()));
        hinhThucChuyenKhoanRepository.save(ht);
    }
    public void trangThai(Integer id) {
        HinhThucThanhToan ht = hinhThucChuyenKhoanRepository.findById(id).orElseThrow(()-> new ApiException("Không tìm thấy hình thức chuyển khoản với id: " + id,"404"));
        ht.setDeleted(true);
        hinhThucChuyenKhoanRepository.save(ht);
    }


}
