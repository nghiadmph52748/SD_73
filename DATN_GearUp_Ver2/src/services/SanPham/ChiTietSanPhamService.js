const API = "http://localhost:8080/api/chi-tiet-san-pham-management";

export const fetchAllChiTietSanPham = async () => {
  const res = await fetch(`${API}/playlist`);
  if (!res.ok) {
    throw new Error("Failed to fetch product details");
  }
  return res.json();
}

export const fetchAllChiTietSanPhamBySanPhamId = async (id) => {
  const res = await fetch(`${API}/list/${id}`);
  if (!res.ok) {
    throw new Error("Failed to fetch product details");
  }
  return res.json();
}

export const fetchOneChiTietSanPham = async (id) => {
  const res = await fetch(`${API}/detail/${id}`);
  if (!res.ok) {
    throw new Error("Failed to fetch product detail");
  }
  return res.json();
}

export const fetchChiTietSanPhamWithInventory = async (id) => {
  const res = await fetch(`${API}/detail/${id}`);
  if (!res.ok) {
    throw new Error("Failed to fetch product detail with inventory");
  }
  const data = await res.json();
  // Kiểm tra xem có data không
  if (!data || !data.data) {
    throw new Error("Invalid response format");
  }
  return data.data; // Trả về object chi tiết sản phẩm với thông tin số lượng
}

export const fetchPagingChiTietSanPham = async (page, size) => {
  const res = await fetch(`${API}/paging?page=${page}&size=${size}`);
  if (!res.ok) {
    throw new Error("Failed to fetch paginated product details");
  }
  return res.json();
}

export const fetchCreateChiTietSanPham = async (data) => {
  // Chuẩn bị dữ liệu theo backend entity
  const requestData = {
    idSanPham: data.idSanPham,
    idMauSac: data.idMauSac,
    idKichThuoc: data.idKichThuoc,
    idDeGiay: data.idDeGiay,
    idChatLieu: data.idChatLieu,
    idTrongLuong: data.idTrongLuong,
    soLuong: data.soLuong,
    giaBan: data.giaBan,
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
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestData),
  });


  if (!res.ok) {
    const errorText = await res.text();
    console.error(`❌ API Error ${res.status}:`, errorText);
    throw new Error(`Failed to create product detail: ${res.status} - ${errorText}`);
  }

  const responseData = await res.json();

  // Kiểm tra format response từ backend
  if (responseData && typeof responseData === 'object') {
    // Backend trả về format: { data: id, message: "..." }
    if (responseData.data !== undefined) {

      // Nếu data là ID (number)
      if (typeof responseData.data === 'number' && responseData.data > 0) {
        // Trả về object chứa ID để tương thích với frontend
        return {
          id: responseData.data,
          message: responseData.message
        };
      }

      // Nếu data là null hoặc không phải ID
      if (responseData.data === null || responseData.data === 0) {
        console.error(`❌ Backend trả về ID null hoặc 0:`, responseData);
        return null;
      }

      // Nếu data là object khác
      return responseData.data;
    }

    // Nếu response trực tiếp là object chứa ID
    if (responseData.id) {
      return responseData;
    }
  }

  // Fallback: trả về response gốc
  return responseData;
}

export const fetchUpdateChiTietSanPham = async (id, data) => {
  // Chuẩn bị dữ liệu theo backend entity
  const requestData = {
    idSanPham: data.idSanPham,
    idMauSac: data.idMauSac,
    idKichThuoc: data.idKichThuoc,
    idDeGiay: data.idDeGiay,
    idChatLieu: data.idChatLieu,
    idTrongLuong: data.idTrongLuong,
    soLuong: data.soLuong,
    giaBan: data.giaBan,
    trangThai: data.trangThai,
    deleted: data.deleted,
    updateAt: new Date().toISOString().split('T')[0],
    updateBy: data.updateBy || 1
  };


  try {
    const res = await fetch(`${API}/update/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestData),
    });


    if (!res.ok) {
      const errorText = await res.text();
      console.error(`❌ API Error ${res.status}:`, errorText);
      throw new Error(`Failed to update product detail: ${res.status} - ${errorText}`);
    }

    const responseData = await res.json();
    return responseData;
  } catch (error) {
    console.error("❌ Error in fetchUpdateChiTietSanPham:", error);
    throw error;
  }
}

export const fetchUpdateStatusChiTietSanPham = async (id) => {
  const res = await fetch(`${API}/update/status/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json"
    }
  });
  if (!res.ok) {
    const errorText = await res.text();
    console.error("API Error:", errorText);
    throw new Error("Failed to update product detail status");
  }
  return res.json();
}

export const fetchRestoreStatusChiTietSanPham = async (id) => {
  const res = await fetch(`${API}/restore/status/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json"
    }
  });
  if (!res.ok) {
    const errorText = await res.text();
    console.error("API Error:", errorText);
    throw new Error("Failed to restore product detail status");
  }
  return res.json();
}
