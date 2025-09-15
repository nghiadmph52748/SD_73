const API = "http://localhost:8080/api/xuat-xu-management";

export const fetchAllXuatXu = async () => {
    const res = await fetch(`${API}/playlist`);
    if (!res.ok) {
        throw new Error("Failed to fetch origins");
    }
    return res.json();
}

export const fetchOneXuatXu = async (id) => {
    const res = await fetch(`${API}/detail/${id}`);
    if (!res.ok) {
        throw new Error("Failed to fetch origin details");
    }
    return res.json();
}

export const fetchPagingXuatXu = async (page, size) => {
    const res = await fetch(`${API}/paging?page=${page}&size=${size}`);
    if (!res.ok) {
        throw new Error("Failed to fetch paginated origins");
    }
    return res.json();
}

export const fetchCreateXuatXu = async (data) => {
    console.log('API URL:', `${API}/add`);
    console.log('Request data:', data);
    
    const res = await fetch(`${API}/add`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
    });
    
    console.log('Response status:', res.status);
    console.log('Response ok:', res.ok);
    
    const result = await res.json();
    console.log('Response data:', result);
    
    // Luôn trả về result, không throw error
    // Để component có thể xử lý response
    return result;
}

export const fetchUpdateXuatXu = async (id, data) => {
    const res = await fetch(`${API}/update/${id}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
    });
    if (!res.ok) {
        throw new Error("Failed to update origin");
    }
}

export const fetchUpdateStatusXuatXu = async (id) => {
    const res = await fetch(`${API}/update/status/${id}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json"
        }
    });
    if (!res.ok) {
        throw new Error("Failed to update origin status");
    }
    return res.json();
}