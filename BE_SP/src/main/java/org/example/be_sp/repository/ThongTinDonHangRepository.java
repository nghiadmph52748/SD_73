package org.example.be_sp.repository;

import org.example.be_sp.entity.ThongTinDonHang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ThongTinDonHangRepository extends JpaRepository<ThongTinDonHang, Integer> {
}
