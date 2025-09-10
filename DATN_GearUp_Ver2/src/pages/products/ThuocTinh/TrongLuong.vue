<template>
  <div class="trong-luong-page">
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
        <label><i class="fas fa-search"></i> Tìm kiếm:</label>
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Tìm theo tên trọng lượng..."
          @input="handleSearch"
        />
      </div>
      <div class="action-group">
        <button @click="showAddForm = true" class="btn-export">
          <img src="../../../assets/Plus.svg" alt="Add" class="icon-svg" /> Thêm Trọng Lượng Mới
        </button>
      </div>
      <div class="filter-group">
        <label><i class="fas fa-filter"></i> Lọc theo trạng thái:</label>
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
        <h3><img src="../../../assets/Plus.svg" alt="Add" class="icon-svg" /> Thêm Trọng Lượng Mới</h3>
        <button @click="closeAddForm" class="modal-close">
          <img src="../../../assets/Cancel.svg" alt="Close" class="icon-svg" />
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
          <img src="../../../assets/Cancel.svg" alt="Close" class="icon-svg" /> Hủy bỏ
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
          <button
            v-on:click="fetchDetail(value)"
            class="btn btn-detail btn-icon btn-sm"
            title="Xem chi tiết"
          >
            Chi tiết
          </button>
          <button
            v-on:click="fetchDelete(value.id)"
            class="btn btn-delete btn-icon btn-sm"
            :disabled="uploading"
            title="Xóa"
          >
            Xóa
          </button>
        </td>
      </tr>
    </tbody>
  </table>

  <!-- Pagination -->
  <div class="pagination-wrapper">
    <div class="pagination-info">
      Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của {{ totalItems }} trọng
      lượng
    </div>
    <div class="pagination">
      <button
        class="pagination-btn"
        @click="goToPreviousPage"
        :disabled="currentPage === 1"
      >
        <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
        class="pagination-btn"
        @click="goToNextPage"
        :disabled="currentPage === totalPages"
      >
        Sau
        <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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

  <!-- Popup Detail Modal -->
  <div v-if="showDetailModal" class="modal-overlay" @click="closeDetailModal">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3>Chỉnh Sửa Trọng Lượng</h3>
        <button class="modal-close" @click="closeDetailModal">
          <img src="../../../assets/Cancel.svg" alt="Close" class="icon-svg" />
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
        <h3><img src="../../../assets/Warning.svg" alt="Warning" class="icon-svg" /> Xác nhận xóa</h3>
        <button class="modal-close" @click="closeDeleteModal">
          <img src="../../../assets/Cancel.svg" alt="Close" class="icon-svg" />
        </button>
      </div>
      <div class="modal-body">
        <div class="delete-content">
          <div class="delete-icon">
            <img src="../../../assets/Trash.svg" alt="Delete" class="icon-svg" />
          </div>
          <h4>Bạn có chắc chắn muốn xóa?</h4>
          <p class="delete-message">
            Bạn sắp xóa <strong>"{{ deleteItemName }}"</strong>. Hành động này
            không thể hoàn tác.
          </p>
        </div>
      </div>
      <div class="modal-footer delete-footer">
        <button
          class="btn btn-secondary"
          @click="closeDeleteModal"
          :disabled="uploading"
        >
          <img src="../../../assets/Cancel.svg" alt="Close" class="icon-svg" /> Hủy bỏ
        </button>
        <button
          class="btn btn-delete"
          @click="confirmDelete"
          :disabled="uploading"
        >
          <img src="../../../assets/Trash.svg" alt="Delete" class="icon-svg" /> {{ uploading ? "Đang xóa..." : "Xóa" }}
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
    await fetchCreateTrongLuong(newTrongLuong.value);

    // Reset form
    newTrongLuong.value = {
      tenTrongLuong: "",
      trangThai: true,
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
</style>
