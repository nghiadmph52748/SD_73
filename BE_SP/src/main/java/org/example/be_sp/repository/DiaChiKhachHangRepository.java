package org.example.be_sp.repository;

import java.util.List;

import org.example.be_sp.entity.DiaChiKhachHang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DiaChiKhachHangRepository extends JpaRepository<DiaChiKhachHang, Integer> {
    // Find all addresses by customer id (id_khach_hang)
    List<DiaChiKhachHang> findAllByIdKhachHang_Id(Integer idKhachHang);
}
