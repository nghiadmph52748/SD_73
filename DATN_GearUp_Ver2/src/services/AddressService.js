// Service để gọi API địa chỉ Việt Nam từ GitHub
const API_BASE = "https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json";

// Cache dữ liệu địa chỉ
let addressData = null;

export const fetchAddressData = async () => {
  if (addressData) {
    return addressData;
  }

  try {
    const response = await fetch(API_BASE);
    if (!response.ok) {
      throw new Error("Failed to fetch address data");
    }
    addressData = await response.json();
    return addressData;
  } catch (error) {
    console.error("Error fetching address data:", error);
    throw error;
  }
};

export const getProvinces = async () => {
  const data = await fetchAddressData();
  return data.map(province => ({
    code: province.Id,
    name: province.Name,
    codeName: province.Code
  }));
};

export const getDistricts = async (provinceCode) => {
  const data = await fetchAddressData();
  const province = data.find(p => p.Id === provinceCode);
  if (!province) return [];

  return province.Districts.map(district => ({
    code: district.Id,
    name: district.Name,
    codeName: district.Code
  }));
};

export const getWards = async (provinceCode, districtCode) => {
  const data = await fetchAddressData();
  const province = data.find(p => p.Id === provinceCode);
  if (!province) return [];

  const district = province.Districts.find(d => d.Id === districtCode);
  if (!district) return [];

  return district.Wards.map(ward => ({
    code: ward.Id,
    name: ward.Name,
    codeName: ward.Code
  }));
};
