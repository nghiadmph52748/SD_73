package org.example.be_sp.repository;

import org.example.be_sp.entity.PhieuGiamGia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PhieuGiamGiaRepository extends JpaRepository<PhieuGiamGia, Integer> {
    PhieuGiamGia getById(Integer id);
}
