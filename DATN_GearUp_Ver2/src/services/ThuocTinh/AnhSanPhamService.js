const API = "http://localhost:8080/api/anh-san-pham-management";

export const fetchAllAnhSanPham = async () => {
  const res = await fetch(`${API}/playlist`);

  if (!res.ok) {
    const errorText = await res.text();
    throw new Error(`Failed to fetch product images: ${res.status} - ${errorText}`);
  }

  const responseData = await res.json();

  // Backend trả về format: { data: [...], message: "..." }
  if (responseData && responseData.data !== undefined) {
    return responseData.data;
  }

  // Nếu response trực tiếp là array
  if (Array.isArray(responseData)) {
    return responseData;
  }

  // Fallback
  return responseData;
}

export const fetchOneAnhSanPham = async (id) => {
  const res = await fetch(`${API}/detail/${id}`);
  if (!res.ok) {
    throw new Error("Failed to fetch product image");
  }
  return res.json();
}

export const fetchPagingAnhSanPham = async (page, size) => {
  const res = await fetch(`${API}/paging?page=${page}&limit=${size}`);
  if (!res.ok) {
    throw new Error("Failed to fetch paginated product images");
  }
  return res.json();
}

export const fetchCreateAnhSanPham = async (formData) => {
  // Kiểm tra nếu formData là FormData (upload file) hoặc object thường
  if (formData instanceof FormData) {
    // Upload file - không cần set Content-Type, browser sẽ tự động set
    console.log("1");
    const res = await fetch(`${API}/add`, {
      method: "POST",
      body: formData
    });
    if (!res.ok) {
      const errorData = await res.json();
      throw new Error(errorData.message || "Failed to create product image");
    }
    return res.json();
  } else {
    console.log("2");
    // Tạo ảnh với dữ liệu JSON thông thường - cần chuyển thành FormData
    const formDataForUpload = new FormData();

    // Tạo file ảnh từ đường dẫn (nếu có)
    if (formData.duongDanAnh) {
      // Nếu có đường dẫn ảnh, tạo file từ đó
      try {
        const response = await fetch(formData.duongDanAnh);
        const blob = await response.blob();
        const file = new File([blob], formData.duongDanAnh.split('/').pop(), { type: 'image/*' });
        formDataForUpload.append("file", file);
      } catch (error) {
        console.error("Error creating file from URL:", error);
        throw new Error("Không thể tạo file từ đường dẫn ảnh");
      }
    }

    formDataForUpload.append("loaiAnh", formData.loaiAnh || "PRODUCT");
    if (formData.moTa) {
      formDataForUpload.append("moTa", formData.moTa);
    }
    if (formData.deleted !== undefined) {
      formDataForUpload.append("deleted", formData.deleted);
    }

    const res = await fetch(`${API}/add`, {
      method: "POST",
      body: formDataForUpload
    });
    if (!res.ok) {
      const errorData = await res.json();
      throw new Error(errorData.message || "Failed to create product image");
    }
    return res.json();
  }
}

export const fetchCreateAnhSanPhamFromCloud = async (formData, options = {}) => {
  const { signal, retryCount = 0 } = options;
  const maxRetries = 2;
  const timeout = 30000; // 30 seconds timeout

  try {
    console.log(`🔄 Upload attempt ${retryCount + 1}/${maxRetries + 1}`);

    // Use provided signal or create new AbortController for timeout
    const controller = signal ? null : new AbortController();
    const timeoutId = signal ? null : setTimeout(() => controller?.abort(), timeout);

    const res = await fetch(`${API}/add-multi-image/cloud`, {
      method: "POST",
      body: formData,
      signal: signal || controller?.signal
    });

    if (timeoutId) clearTimeout(timeoutId);

    if (!res.ok) {
      const errorData = await res.json();
      throw new Error(errorData.message || `HTTP ${res.status}: Failed to create product image`);
    }

    const responseData = await res.json();
    console.log("✅ Upload response received:", responseData);
    return responseData;

  } catch (error) {
    console.error(`❌ Upload attempt ${retryCount + 1} failed:`, error.message);

    if (error.name === 'AbortError') {
      console.warn("⏰ Upload timeout, retrying...");
    }

    // Retry logic
    if (retryCount < maxRetries) {
      console.log(`🔄 Retrying upload in ${retryCount + 1} seconds...`);
      await new Promise(resolve => setTimeout(resolve, (retryCount + 1) * 1000));
      return fetchCreateAnhSanPhamFromCloud(formData, { signal, retryCount: retryCount + 1 });
    }

    // Final failure
    throw new Error(`Upload failed after ${maxRetries + 1} attempts: ${error.message}`);
  }
}

export const fetchUpdateAnhSanPhamFromCloud = async (id, formData) => {
  const res = await fetch(`${API}/update/multi-image/cloud/${id}`, {
    method: "PUT",
    body: formData
  });
  if (!res.ok) {
    const errorData = await res.json();
    throw new Error(errorData.message || "Failed to update product image");
  }
  return res.json();
}

export const fetchUpdateAnhSanPham = async (id, updateData) => {
  // Gửi FormData để backend nhận @RequestParam
  const formData = new FormData();
  formData.append("duongDanAnh", updateData.duongDanAnh || "");
  formData.append("loaiAnh", updateData.loaiAnh || "");
  formData.append("moTa", updateData.moTa || "");
  formData.append("trangThai", updateData.trangThai ? "true" : "false");
  formData.append("deleted", updateData.deleted ? "true" : "false");
  formData.append("updateBy", (updateData.updateBy || 1).toString());

  const res = await fetch(`${API}/update/${id}`, {
    method: "PUT",
    body: formData // Không cần Content-Type header
  });

  if (!res.ok) {
    const errorData = await res.json();
    throw new Error(errorData.message || "Failed to update product image");
  }
  return res.json();
}

export const fetchUpdateStatusAnhSanPham = async (id) => {
  const res = await fetch(`${API}/update/status/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json"
    }
  });
  if (!res.ok) {
    const errorData = await res.json();
    throw new Error(errorData.message || "Failed to update product image status");
  }
  return res.json();
}
