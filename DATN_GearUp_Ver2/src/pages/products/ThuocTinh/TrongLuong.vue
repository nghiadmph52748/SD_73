<template>
  <div class="trong-luong-page thuoc-tinh-page">
    <!-- Font Awesome for icons -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />

    <div class="breadcrumb-nav">
      <RouterLink :to="`/products`" class="product-link">
        <span class="product-text">Sản phẩm</span>
      </RouterLink>
      <span class="breadcrumb-separator"> / </span>
      <router-link :to="`/products/trong-luong`" class="product-link">
        <span class="product-text">Trọng lượng</span>
      </router-link>
    </div>

    <!-- Search và Filter -->
    <div class="search-filter-section">
      <div class="search-box">
        <div class="search-input-group">
          <label>Tìm kiếm:</label>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm theo tên trọng lượng..."
            @input="handleSearch"
          />
        </div>
        <div class="action-group">
          <button @click="showAddForm = true" class="btn btn-primary">
            <img src="../../../assets/Plus.svg" alt="Add" class="icon-svg" />
            Thêm Trọng Lượng Mới
          </button>
        </div>
        <div class="filter-group">
          <label>Lọc theo trạng thái:</label>
          <div class="radio-filter">
            <label class="radio-label">
              <input
                type="radio"
                name="statusFilter"
                value=""
                v-model="statusFilter"
                @change="handleFilter"
              />
              <span>Tất cả</span>
            </label>
            <label class="radio-label">
              <input
                type="radio"
                name="statusFilter"
                value="true"
                v-model="statusFilter"
                @change="handleFilter"
              />
              <span>Hoạt động</span>
            </label>
            <label class="radio-label">
              <input
                type="radio"
                name="statusFilter"
                value="false"
                v-model="statusFilter"
                @change="handleFilter"
              />
              <span>Không hoạt động</span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal thêm mới -->
    <div v-if="showAddForm" class="modal-overlay" @click="closeAddForm">
      <div class="modal-content add-modal" @click.stop>
        <div class="modal-header add-header">
          <h3>
            <img src="../../../assets/Plus.svg" alt="Add" class="icon-svg" />
            Thêm Trọng Lượng Mới
          </h3>
          <button @click="closeAddForm" class="modal-close">
            <img
              src="../../../assets/Cancel.svg"
              alt="Close"
              class="icon-svg"
            />
          </button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="fetchCreate">
            <div class="detail-row">
              <div class="detail-label">Tên trọng lượng:</div>
              <div class="detail-value">
                <input
                  v-model="newTrongLuong.tenTrongLuong"
                  type="text"
                  required
                  class="detail-input"
                />
              </div>
            </div>

            <div class="detail-row">
              <div class="detail-label">Trạng thái:</div>
              <div class="detail-value">
                <div class="radio-group">
                  <label class="radio-label">
                    <input
                      type="radio"
                      name="Trạng thái"
                      :value="true"
                      v-model="newTrongLuong.trangThai"
                    />
                    <span>Hoạt động</span>
                  </label>
                  <label class="radio-label">
                    <input
                      type="radio"
                      name="Trạng thái"
                      :value="false"
                      v-model="newTrongLuong.trangThai"
                    />
                    <span>Không hoạt động</span>
                  </label>
                </div>
              </div>
            </div>

            <!-- Error và Success Message -->
            <div v-if="errorMessage" class="detail-error">
              <p>{{ errorMessage }}</p>
            </div>
            <div v-if="successMessage" class="detail-success">
              <p>{{ successMessage }}</p>
            </div>
          </form>
        </div>
        <div class="modal-footer add-footer">
          <button type="button" @click="closeAddForm" class="btn btn-secondary">
            <img
              src="../../../assets/Cancel.svg"
              alt="Close"
              class="icon-svg"
            />
            Hủy bỏ
          </button>
          <button
            @click="fetchCreate"
            :disabled="uploading"
            class="btn btn-primary"
          >
            <img src="../../../assets/Plus.svg" alt="Add" class="icon-svg" />
            {{ uploading ? "Đang thêm..." : "Thêm Mới" }}
          </button>
        </div>
      </div>
    </div>

    <!-- Weight Table -->
    <div class="card">
      <div class="card-header">
        <div class="table-header-content">
          <h3 class="table-title">Danh sách trọng lượng</h3>
        </div>
      </div>
      <div class="card-body">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>STT</th>
              <th>Tên trọng lượng</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(value, i) in paginatedTrongLuongs" :key="value.id">
              <td>{{ startIndex + i + 1 }}</td>
              <td>{{ value.tenTrongLuong }}</td>
              <td>{{ value.trangThai ? "Hoạt động" : "Không hoạt động" }}</td>
              <td>
                <div class="action-buttons">
                  <button
                    v-on:click="fetchDetail(value)"
                    class="btn btn-secondary btn-sm"
                    title="Cập nhật"
                  >
                    Cập nhật
                  </button>
                  <button
                    v-on:click="fetchDelete(value.id)"
                    class="btn btn-danger btn-sm"
                    :disabled="uploading"
                    title="Xóa"
                  >
                    Xoá
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của
            {{ totalItems }} trọng lượng
          </div>
          <div class="pagination">
            <button
              class="btn btn-outline btn-sm"
              @click="goToPreviousPage"
              :disabled="currentPage === 1"
            >
              <svg
                class="icon"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15 19l-7-7 7-7"
                ></path>
              </svg>
              Trước
            </button>
            <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
            <button
              class="btn btn-outline btn-sm"
              @click="goToNextPage"
              :disabled="currentPage === totalPages"
            >
              Sau
              <svg
                class="icon"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5l7 7-7 7"
                ></path>
              </svg>
            </button>
          </div>
        </div>
        <!-- Pagination Info khi chỉ có 1 trang -->
        <div
          v-else-if="filteredTrongLuongs.length > 0"
          class="pagination-wrapper"
        >
          <div class="pagination-info">
            Hiển thị tất cả {{ filteredTrongLuongs.length }} trọng lượng
          </div>
        </div>
      </div>
    </div>

    <!-- Popup Detail Modal -->
    <div v-if="showDetailModal" class="modal-overlay" @click="closeDetailModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Chỉnh Sửa Trọng Lượng</h3>
          <button class="modal-close" @click="closeDetailModal">
            <img
              src="../../../assets/Cancel.svg"
              alt="Close"
              class="icon-svg"
            />
          </button>
        </div>
        <div class="modal-body">
          <!-- Edit Mode -->
          <div>
            <div class="detail-row">
              <div class="detail-label">Tên trọng lượng:</div>
              <div class="detail-value">
                <input
                  v-model="selectedTrongLuong.tenTrongLuong"
                  type="text"
                  required
                  class="detail-input"
                />
              </div>
            </div>

            <div class="detail-row">
              <div class="detail-label">Trạng thái:</div>
              <div class="detail-value">
                <div class="radio-group">
                  <label class="radio-label">
                    <input
                      type="radio"
                      name="detailTrạng thái"
                      :value="true"
                      v-model="selectedTrongLuong.trangThai"
                    />
                    <span>Hoạt động</span>
                  </label>
                  <label class="radio-label">
                    <input
                      type="radio"
                      name="detailTrạng thái"
                      :value="false"
                      v-model="selectedTrongLuong.trangThai"
                    />
                    <span>Không hoạt động</span>
                  </label>
                </div>
              </div>
            </div>

            <!-- Error Message -->
            <div v-if="editErrorMessage" class="detail-error">
              <p style="color: red">{{ editErrorMessage }}</p>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button
            class="btn btn-success"
            @click="saveChanges"
            :disabled="uploading"
          >
            <img src="../../../assets/Save.svg" alt="Save" class="icon-svg" />
            {{ uploading ? "Đang cập nhật..." : "Lưu thay đổi" }}
          </button>
        </div>
      </div>
    </div>

    <!-- Modal Xác nhận Xóa -->
    <div v-if="showDeleteModal" class="modal-overlay" @click="closeDeleteModal">
      <div class="modal-content delete-modal" @click.stop>
        <div class="modal-header delete-header">
          <h3>
            <img
              src="../../../assets/Warning.svg"
              alt="Warning"
              class="icon-svg"
            />
            Xác nhận xóa
          </h3>
          <button class="modal-close" @click="closeDeleteModal">
            <img
              src="../../../assets/Cancel.svg"
              alt="Close"
              class="icon-svg"
            />
          </button>
        </div>
        <div class="modal-body">
          <div class="delete-content">
            <div class="delete-icon">
              <img
                src="../../../assets/Trash.svg"
                alt="Delete"
                class="icon-svg"
              />
            </div>
            <h4>Bạn có chắc chắn muốn xóa?</h4>
            <p class="delete-message">
              Bạn sắp xóa trọng lượng <strong>"{{ deleteItemName }}"</strong>.
              Hành động này không thể hoàn tác.
            </p>
          </div>
        </div>
        <div class="modal-footer delete-footer">
          <button class="btn btn-secondary" @click="closeDeleteModal" :disabled="uploading">
            <img
              src="../../../assets/Cancel.svg"
              alt="Close"
              class="icon-svg"
            />
            Hủy bỏ
          </button>
          <button class="btn btn-danger" @click="confirmDelete" :disabled="uploading">
            <img
              src="../../../assets/Trash.svg"
              alt="Delete"
              class="icon-svg"
            />
            {{ uploading ? "Đang xóa..." : "Xóa" }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import {
  fetchAllTrongLuong,
  fetchCreateTrongLuong,
  fetchUpdateStatusTrongLuong,
  fetchUpdateTrongLuong,
} from "../../../services/ThuocTinh/TrongLuongService";

const TrongLuongs = ref([]);
const newTrongLuong = ref({
  tenTrongLuong: "",
  trangThai: true,
  deleted: false,
});
const selectedTrongLuong = ref({});

const showDetailModal = ref(false);
const uploading = ref(false);
const errorMessage = ref(null);
const editErrorMessage = ref(null);
const successMessage = ref(null);
const editSuccessMessage = ref(null);

// Biến cho modal xóa
const showDeleteModal = ref(false);
const deleteItemId = ref(null);
const deleteItemName = ref("");

// Biến cho form thêm mới
const showAddForm = ref(false);

// Biến cho tìm kiếm và lọc
const searchQuery = ref("");
const statusFilter = ref("");

// Pagination variables
const currentPage = ref(1);
const pageSize = ref(10);

// Computed properties cho tìm kiếm, lọc và phân trang
const filteredTrongLuongs = computed(() => {
  let filtered = [...TrongLuongs.value];

  // Tìm kiếm theo tên trọng lượng
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter((item) =>
      item.tenTrongLuong?.toLowerCase().includes(query)
    );
  }

  // Lọc theo trạng thái
  if (statusFilter.value !== "") {
    filtered = filtered.filter(
      (item) => item.trangThai === (statusFilter.value === "true")
    );
  }

  return filtered;
});

const totalItems = computed(() => filteredTrongLuongs.value.length);
const totalPages = computed(() => Math.ceil(totalItems.value / pageSize.value));
const startIndex = computed(() => (currentPage.value - 1) * pageSize.value);
const endIndex = computed(() => startIndex.value + pageSize.value);
const paginatedTrongLuongs = computed(() => {
  return filteredTrongLuongs.value.slice(startIndex.value, endIndex.value);
});

const fetchAll = async () => {
  try {
    const response = await fetchAllTrongLuong();
    TrongLuongs.value = response.data;
  } catch (error) {
    console.error("Error fetching:", error);
  }
};

const fetchCreate = async () => {
  if (!newTrongLuong.value.tenTrongLuong) {
    errorMessage.value = "Vui lòng nhập tên trọng lượng";
    return;
  }

  uploading.value = true;
  errorMessage.value = null;

  try {
    let res = await fetchCreateTrongLuong(newTrongLuong.value);
    if (res.status === "FAILED" && res.code === "410") {
      return (errorMessage.value = "Tên trọng lượng đã tồn tại");
    }

    // Reset form
    newTrongLuong.value = {
      tenTrongLuong: "",
      trangThai: true,
      deleted: false,
    };

    await fetchAll();
    successMessage.value = "Trọng lượng đã được thêm thành công!";
    clearSuccessMessage();
    closeAddForm(); // Đóng form sau khi thêm thành công
  } catch (error) {
    console.error("Error creating:", error);
    errorMessage.value =
      "Lỗi khi thêm: " + (error.message || "Không thể tạo trọng lượng");
  } finally {
    uploading.value = false;
  }
};

const fetchDetail = (value) => {
  selectedTrongLuong.value = { ...value };
  showDetailModal.value = true;
};

const fetchDelete = async (id) => {
  // Hiển thị modal xác nhận xóa
  showDeleteModal.value = true;
  deleteItemId.value = id;

  // Lấy tên trọng lượng để hiển thị trong thông báo
  const item = TrongLuongs.value.find((item) => item.id === id);
  if (item) {
    deleteItemName.value = item.tenTrongLuong || "Trọng lượng";
  }
};

const confirmDelete = async () => {
  if (!deleteItemId.value) return;

  try {
    uploading.value = true;
    await fetchUpdateStatusTrongLuong(deleteItemId.value);
    await fetchAll();
    successMessage.value = "Trọng lượng đã được xóa thành công!";
    clearSuccessMessage();
    closeDeleteModal();
  } catch (error) {
    console.error("There has been a problem with your fetch operation:", error);
    errorMessage.value =
      "Lỗi khi xóa: " + (error.message || "Không thể xóa trọng lượng");
    setTimeout(() => {
      errorMessage.value = null;
    }, 3000);
  } finally {
    uploading.value = false;
  }
};

const closeDeleteModal = () => {
  showDeleteModal.value = false;
  deleteItemId.value = null;
  deleteItemName.value = "";
};

const closeAddForm = () => {
  showAddForm.value = false;
  // Reset form
  newTrongLuong.value = {
    tenTrongLuong: "",
    trangThai: true,
    deleted: false,
  };
  errorMessage.value = null;
  successMessage.value = null;
};

// Hàm xử lý tìm kiếm
const handleSearch = () => {
  currentPage.value = 1; // Reset về trang đầu tiên
};

// Hàm xử lý lọc
const handleFilter = () => {
  currentPage.value = 1; // Reset về trang đầu tiên
};

const closeDetailModal = () => {
  showDetailModal.value = false;
  selectedTrongLuong.value = {};
};

const saveChanges = async () => {
  uploading.value = true;
  editErrorMessage.value = null;

  try {
    await fetchUpdateTrongLuong(
      selectedTrongLuong.value.id,
      selectedTrongLuong.value
    );

    await fetchAll();
    closeDetailModal();
    editSuccessMessage.value = "Trọng lượng đã được cập nhật thành công!";
    clearEditSuccessMessage();
  } catch (error) {
    console.error("Error updating:", error);
    editErrorMessage.value =
      "Lỗi khi cập nhật: " +
      (error.message || "Không thể cập nhật trọng lượng");
  } finally {
    uploading.value = false;
  }
};

// Format date function
const formatDate = (dateString) => {
  if (!dateString) return null;
  try {
    const date = new Date(dateString);
    return date.toLocaleDateString("vi-VN", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    });
  } catch (error) {
    return dateString;
  }
};

// Clear success messages after 3 seconds
const clearSuccessMessage = () => {
  setTimeout(() => {
    successMessage.value = null;
  }, 3000);
};

const clearEditSuccessMessage = () => {
  setTimeout(() => {
    editSuccessMessage.value = null;
  }, 3000);
};

const goToPreviousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const goToNextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

onMounted(fetchAll);
</script>

<style scoped>
/* CSS đã được chuyển vào productsUnified.css */
@import "../../../styles/cssSanPham/productsUnified.css";

/* CSS cho các nút cơ bản */
.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  transition: all 0.2s ease;
  line-height: 1.4;
}

.btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
  margin: 0 2px;
}
/* CSS cho action buttons trong inline edit */
.action-buttons {
  display: flex;
  gap: 10px;
  align-items: center;
  justify-content: center;
}

.action-buttons .btn {
  min-width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-outline {
  background: transparent;
  border: 1px solid #d1d5db;
  color: #6b7280;
}

.btn-outline:hover {
  background: #ffffff;
  border-color: #9ca3af;
  color: #374151;
}

/* CSS cho modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 12px;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
    0 10px 10px -5px rgba(0, 0, 0, 0.04);
  max-width: 500px;
  width: 90%;
  overflow: hidden;
  animation: slideIn 0.3s ease-out;
}

.modal-header {
  padding: 20px;
  border-bottom: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  color: #1f2937;
  font-size: 18px;
  font-weight: 600;
}

.modal-body {
  padding: 20px;
}

.modal-footer {
  padding: 20px;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* CSS cho success modal */
.success-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.success-modal-content {
  background: linear-gradient(135deg, #ffffff, #ffffff);
  padding: 2.5rem;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15),
    0 0 0 1px rgba(255, 255, 255, 0.1);
  text-align: center;
  max-width: 450px;
  width: 90%;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.success-icon {
  margin-bottom: 1.5rem;
}

.success-title {
  color: #059669;
  font-size: 24px;
  font-weight: 600;
  margin: 0 0 15px 0;
}

.success-message {
  color: #374151;
  font-size: 16px;
  margin: 0 0 25px 0;
  line-height: 1.5;
}

.success-close-btn {
  background: #059669;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.success-close-btn:hover {
  background: #047857;
}

/* CSS cho table */
.table {
  border: none !important;
  background: transparent !important;
  /* font-size: 12px !important; */
}

.table thead th {
  border: none !important;
  background: transparent !important;
  /* font-size: 12px !important; */
  font-weight: 600 !important;
  color: #374151 !important;
}

.table tbody td {
  border: none !important;
  background: transparent !important;
  /* font-size: 12px !important; */
  color: #4b5563 !important;
}

.table tbody tr:hover {
  /* background: rgba(74, 222, 128, 0.05) !important; */
}

/* CSS cho form elements */
.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #374151;
}

.form-input,
.form-select {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  background: white;
  font-size: 14px;
  transition: border-color 0.2s ease;
}

.form-input:focus,
.form-select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* CSS cho confirm dialog */
.custom-confirm-dialog {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  width: 100vw !important;
  height: 100vh !important;
  z-index: 999999 !important;
  display: flex !important;
  justify-content: center !important;
  align-items: center !important;
}

.custom-confirm-dialog .confirm-content {
  position: relative !important;
  z-index: 1000000 !important;
  transform: translateZ(0) !important;
  will-change: transform !important;
  background: linear-gradient(135deg, #ffffff, #ffffff) !important;
  padding: 2.5rem;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15),
    0 0 0 1px rgba(255, 255, 255, 0.1) !important;
  text-align: center;
  max-width: 450px;
  width: 90%;
  border: 2px solid #e2e8f0;
}

.custom-confirm-dialog h3 {
  margin: 0 0 1.5rem 0;
  color: #22c55e;
  font-size: 1.5rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.custom-confirm-dialog p {
  margin: 0 0 2rem 0;
  color: #475569;
  line-height: 1.6;
  font-size: 1rem;
  background: rgba(59, 130, 246, 0.05);
  padding: 1rem;
  border-radius: 12px;
  border-left: 4px solid #3b82f6;
}

.custom-confirm-dialog .confirm-buttons {
  display: flex !important;
  gap: 1rem !important;
  justify-content: center !important;
  flex-wrap: nowrap !important;
}

.custom-confirm-dialog .btn {
  padding: 0.875rem 2rem !important;
  border-radius: 12px !important;
  cursor: pointer !important;
  font-weight: 600 !important;
  border: none !important;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
  font-size: 0.95rem !important;
  min-width: 120px !important;
  position: relative !important;
  overflow: hidden !important;
}

.custom-confirm-dialog .btn::before {
  content: "";
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.2),
    transparent
  );
  transition: left 0.5s;
}

.custom-confirm-dialog .btn:hover::before {
  left: 100%;
}
</style>

