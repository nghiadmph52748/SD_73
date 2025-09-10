const API = "http://localhost:8080/api/chi-tiet-san-pham-anh-management";

export const fetchAllChiTietSanPhamAnh = async () => {
  const res = await fetch(`${API}/playlist`);
  if (!res.ok) {
    throw new Error("Failed to fetch product image details");
  }
  return res.json();
}

export const fetchOneChiTietSanPhamAnh = async (id) => {
  const res = await fetch(`${API}/detail/${id}`);
  if (!res.ok) {
    throw new Error("Failed to fetch product image detail");
  }
  return res.json();
}

export const fetchPagingChiTietSanPhamAnh = async (page, size) => {
  const res = await fetch(`${API}/paging?page=${page}&size=${size}`);
  if (!res.ok) {
    throw new Error("Failed to fetch paginated product image details");
  }
  return res.json();
}

export const fetchCreateChiTietSanPhamAnh = async (data) => {
  // Chuẩn bị dữ liệu theo backend entity
  const requestData = {
    idChiTietSanPham: data.idChiTietSanPham,
    idAnhSanPham: data.idAnhSanPham,
    trangThai: data.trangThai || true,
    deleted: data.deleted || false,
    createAt: new Date().toISOString().split('T')[0], // Format: YYYY-MM-DD
    createBy: data.createBy || 1, // Default value
    updateAt: new Date().toISOString().split('T')[0],
    updateBy: data.updateBy || 1 // Default value
  };

  const res = await fetch(`${API}/add`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(requestData)
  });
  if (!res.ok) {
    const errorData = await res.json();
    throw new Error(errorData.message || "Failed to create product image detail");
  }
  return res.json();
}

export const fetchUpdateChiTietSanPhamAnh = async (id, data) => {
  // Chuẩn bị dữ liệu theo backend entity
  const requestData = {
    idChiTietSanPham: data.idChiTietSanPham,
    idAnhSanPham: data.idAnhSanPham,
    trangThai: data.trangThai,
    deleted: data.deleted,
    updateAt: new Date().toISOString().split('T')[0],
    updateBy: data.updateBy || 1
  };

  const res = await fetch(`${API}/update/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(requestData)
  });

  if (!res.ok) {
    const errorData = await res.json();
    throw new Error(errorData.message || "Failed to update product image detail");
  }
  return res.json();
}

export const fetchCreateMultipleChiTietSanPhamAnh = async (data) => {
  // Chuẩn bị dữ liệu theo backend entity
  const requestData = {
    idChiTietSanPham: data.idChiTietSanPham,
    idAnhSanPhamList: data.idAnhSanPhamList || [],
    trangThai: data.trangThai || true,
    deleted: data.deleted || false,
    createAt: new Date().toISOString().split('T')[0], // Format: YYYY-MM-DD
    createBy: data.createBy || 1, // Default value
    updateAt: new Date().toISOString().split('T')[0],
    updateBy: data.updateBy || 1 // Default value
  };

  const res = await fetch(`${API}/add-multiple`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(requestData)
  });

  if (!res.ok) {
    const errorText = await res.text();
    throw new Error(`Failed to create multiple product image details: ${res.status} - ${errorText}`);
  }

  const responseData = await res.json();

  // Backend trả về format: { success: true/false, message: "...", data: null }
  if (responseData && typeof responseData === 'object') {
    if (responseData.success === false) {
      throw new Error(responseData.message || "Backend returned error");
    }
    if (responseData.success === true) {
      return responseData;
    }
  }

  // Fallback
  return responseData;
}


export const fetchDeleteChiTietSanPhamAnh = async (id) => {
  // Backend không có endpoint DELETE, sử dụng update status để soft delete
  const res = await fetch(`${API}/update/status/${id}`, {
    method: "PUT"
  });
  if (!res.ok) {
    const errorData = await res.json();
    throw new Error(errorData.message || "Failed to delete product image detail");
  }
  return res.json();
}

export const fetchUpdateStatusChiTietSanPhamAnh = async (recordId) => {
  // Chuẩn bị dữ liệu để cập nhật trạng thái thành inactive
  // Gọi API update với ID bản ghi trực tiếp
  const res = await fetch(`${API}/update/status/${recordId}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json"
    },
  });

  if (!res.ok) {
    const errorData = await res.json();
    throw new Error(errorData.message || "Failed to update status product image detail");
  }

  return res.json();
};

// Hàm cập nhật trạng thái nhiều bản ghi cùng lúc
export const fetchUpdateStatusMultipleChiTietSanPhamAnh = async (recordIds) => {
  if (!Array.isArray(recordIds) || recordIds.length === 0) {
    throw new Error("Record IDs phải là mảng và không được rỗng");
  }

  console.log(`🔄 Bắt đầu cập nhật trạng thái ${recordIds.length} bản ghi...`);

  const results = [];
  const errors = [];

  // Sử dụng for để cập nhật từng bản ghi
  for (let i = 0; i < recordIds.length; i++) {
    const recordId = recordIds[i];
    try {
      console.log(`📝 Đang cập nhật bản ghi ${i + 1}/${recordIds.length}: ${recordId}`);
      const result = await fetchUpdateStatusChiTietSanPhamAnh(recordId);
      results.push({ id: recordId, success: true, result });
    } catch (error) {
      console.error(`❌ Lỗi cập nhật bản ghi ${recordId}:`, error.message);
      errors.push({ id: recordId, error: error.message });
      results.push({ id: recordId, success: false, error: error.message });
    }
  }

  const successCount = results.filter(r => r.success).length;
  const errorCount = errors.length;

  console.log(`✅ Hoàn thành: ${successCount} thành công, ${errorCount} thất bại`);

  return {
    total: recordIds.length,
    successCount,
    errorCount,
    results,
    errors: errorCount > 0 ? errors : undefined
  };
};
