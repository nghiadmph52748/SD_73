<template>
  <div class="anh-san-pham-page">
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
      <router-link :to="`/products/anh-san-pham`" class="product-link">
        <span class="product-text">Ảnh sản phẩm</span>
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
            placeholder="Tìm theo loại ảnh hoặc mô tả..."
            @input="handleSearch"
          />
        </div>
        <div class="action-group">
          <button @click="showAddForm = true" class="btn btn-primary">
            <img src="../../../assets/Plus.svg" alt="Add" class="icon-svg" />
            Thêm Hình Ảnh Mới
          </button>
        </div>
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
              value="false"
              v-model="statusFilter"
              @change="handleFilter"
            />
            <span>Hoạt động</span>
          </label>
          <label class="radio-label">
            <input
              type="radio"
              name="statusFilter"
              value="true"
              v-model="statusFilter"
              @change="handleFilter"
            />
            <span>Không hoạt động</span>
          </label>
        </div>
      </div>
    </div>

    <!-- Modal thêm mới -->
    <div v-if="showAddForm" class="modal-overlay" @click="closeAddForm">
      <div class="modal-content add-modal" @click.stop>
        <div class="modal-header add-header">
          <h3>
            <img src="../../../assets/Plus.svg" alt="Add" class="icon-svg" />
            Thêm Hình Ảnh Sản Phẩm Mới
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
              <div class="detail-label">Chọn ảnh từ máy:</div>
              <div class="detail-value">
                <input
                  type="file"
                  ref="fileInput"
                  @change="handleFileChange"
                  accept="image/*"
                  required
                  class="detail-file-input"
                />
                <img
                  v-if="previewUrl"
                  :src="previewUrl"
                  alt="Preview ảnh"
                  class="detail-preview-image"
                />
              </div>
            </div>
            <div class="detail-row">
              <div class="detail-label">Loại ảnh:</div>
              <div class="detail-value">
                <input
                  v-model="newAnhSanPham.loaiAnh"
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
                      :value="false"
                      v-model="newAnhSanPham.deleted"
                    />
                    <span>Hoạt động</span>
                  </label>
                  <label class="radio-label">
                    <input
                      type="radio"
                      name="Trạng thái"
                      :value="true"
                      v-model="newAnhSanPham.deleted"
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
    <!-- Form chỉnh sửa (mới thêm) -->
    <div class="edit-form" v-if="showEditForm">
      <h3>Chỉnh Sửa Hình Ảnh Sản Phẩm</h3>
      <form @submit.prevent="fetchUpdate">
        <div>
          <label>Ảnh hiện tại:</label>
          <img
            v-if="selectedAnhSanPham.duongDanAnh"
            :src="getImageUrl(selectedAnhSanPham.duongDanAnh)"
            alt="Ảnh hiện tại"
            style="width: 100px; height: auto"
            @error="handleImageError"
          />
        </div>
        <div>
          <label>Chọn ảnh mới (nếu muốn thay đổi):</label>
          <input
            type="file"
            ref="editFileInput"
            @change="handleEditFileChange"
            accept="image/*"
          />
          <img
            v-if="editPreviewUrl"
            :src="editPreviewUrl"
            alt="Preview mới"
            style="width: 100px; height: auto; margin-top: 10px"
          />
        </div>
        <div>
          <label>Loại ảnh:</label>
          <input v-model="selectedAnhSanPham.loaiAnh" type="text" required />
        </div>
        <div>
          <label for="">Trạng thái</label>
          <div class="radio-group">
            <label class="radio-label">
              <input
                type="radio"
                name="editTrạng thái"
                :value="true"
                v-model="selectedAnhSanPham.trangThai"
              />
              <span>Hoạt động</span>
            </label>
            <label class="radio-label">
              <input
                type="radio"
                name="editTrạng thái"
                :value="false"
                v-model="selectedAnhSanPham.trangThai"
              />
              <span>Không hoạt động</span>
            </label>
          </div>
        </div>
        <div class="edit-popup-actions">
          <button type="submit" :disabled="uploading" class="btn btn-success">
            <img src="../../../assets/Save.svg" alt="Save" class="icon-svg" />
            {{ uploading ? "Đang cập nhật..." : "Cập Nhật" }}
          </button>
          <button
            type="button"
            @click="closeEditForm"
            class="btn btn-secondary"
          >
            <img
              src="../../../assets/Cancel.svg"
              alt="Close"
              class="icon-svg"
            />
            Đóng
          </button>
        </div>
        <p v-if="editErrorMessage" style="color: red">{{ editErrorMessage }}</p>
        <p v-if="editSuccessMessage" style="color: green">
          {{ editSuccessMessage }}
        </p>
      </form>
    </div>
    <!-- Product Image Table -->
    <div class="card">
      <div class="card-header">
        <div class="table-header-content">
          <h3 class="table-title">Danh sách ảnh sản phẩm</h3>
        </div>
      </div>
      <div class="card-body">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>STT</th>
              <th>Ảnh</th>
              <th>Loại ảnh</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <!-- Hiển thị message khi không có dữ liệu -->
            <tr v-if="paginatedAnhSanPhams.length === 0">
              <td
                colspan="5"
                style="text-align: center; padding: 40px; color: #666"
              >
                <i
                  class="fas fa-info-circle"
                  style="font-size: 24px; margin-bottom: 10px"
                ></i>
                <br />
                <strong>Không có dữ liệu</strong>
                <br />
                <small>Chưa có ảnh sản phẩm nào được tải lên</small>
              </td>
            </tr>
            <tr v-for="(value, i) in paginatedAnhSanPhams" :key="value.id">
              <td>{{ startIndex + i + 1 }}</td>
              <td>
                <img
                  :src="getImageUrl(value.duongDanAnh)"
                  alt="Ảnh sản phẩm"
                  style="width: 100px; height: auto"
                  @error="handleImageError"
                />
              </td>
              <td>{{ value.loaiAnh }}</td>
              <td>{{ value.trangThai ? "Hoạt động" : "Không hoạt động" }}</td>
              <td>
                <div class="table-actions">
                  <button
                    v-on:click="fetchDetail(value)"
                    class="btn btn-secondary btn-sm"
                    title="Cập nhật"
                  >
                    Chi tiết
                  </button>
                  <button
                    v-on:click="fetchDelete(value.id)"
                    class="btn btn-danger btn-sm"
                    :disabled="uploading"
                    title="Xóa"
                  >
                    Xóa
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
            {{ totalItems }} ảnh sản phẩm
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
          v-else-if="filteredAnhSanPhams.length > 0"
          class="pagination-wrapper"
        >
          <div class="pagination-info">
            Hiển thị tất cả {{ filteredAnhSanPhams.length }} ảnh sản phẩm
          </div>
        </div>
      </div>
    </div>

    <!-- Popup Detail Modal -->
    <div v-if="showDetailModal" class="modal-overlay" @click="closeDetailModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Chỉnh Sửa Hình Ảnh Sản Phẩm</h3>
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
              <div class="detail-label">Ảnh hiện tại:</div>
              <div class="detail-value">
                <img
                  :src="getImageUrl(selectedAnhSanPham.duongDanAnh)"
                  alt="Ảnh hiện tại"
                  class="detail-image"
                  @error="handleImageError"
                />
              </div>
            </div>
            <div class="detail-row">
              <div class="detail-label">Chọn ảnh mới:</div>
              <div class="detail-value">
                <input
                  type="file"
                  ref="editFileInput"
                  @change="handleEditFileChange"
                  accept="image/*"
                  class="detail-file-input"
                />
                <img
                  v-if="editPreviewUrl"
                  :src="editPreviewUrl"
                  alt="Preview mới"
                  class="detail-preview-image"
                />
              </div>
            </div>
            <div class="detail-row">
              <div class="detail-label">Loại ảnh:</div>
              <div class="detail-value">
                <input
                  v-model="selectedAnhSanPham.loaiAnh"
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
                      v-model="selectedAnhSanPham.trangThai"
                    />
                    <span>Hoạt động</span>
                  </label>
                  <label class="radio-label">
                    <input
                      type="radio"
                      name="detailTrạng thái"
                      :value="false"
                      v-model="selectedAnhSanPham.trangThai"
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
              Bạn sắp xóa 1 ảnh. Hành động này không thể hoàn tác.
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
          <button
            class="btn btn-danger"
            @click="confirmDelete"
            :disabled="uploading"
          >
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

    <!-- Popup thông báo bên phải màn hình -->
    <div class="notification-container">
      <div 
        v-if="showNotification" 
        :class="['notification-popup', notificationType, showNotification ? 'show' : '']"
      >
        <div class="notification-header">
          <h4 class="notification-title">{{ notificationTitle }}</h4>
        </div>
        <p class="notification-message">{{ notificationMessage }}</p>
        <div class="notification-progress"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import {
  fetchAllAnhSanPham,
  fetchCreateAnhSanPhamFromCloud,
  fetchUpdateAnhSanPhamFromCloud,
  fetchUpdateAnhSanPham,
  fetchUpdateStatusAnhSanPham,
} from "../../../services/ThuocTinh/AnhSanPhamService";

const AnhSanPhams = ref([]);
const newAnhSanPham = ref({
  loaiAnh: "",
  moTa: "",
  deleted: false,
  trangThai: true,
});
const showDetailModal = ref(false);
const selectedAnhSanPham = ref({});
const file = ref(null);
const previewUrl = ref(null);
const editFile = ref(null);
const editPreviewUrl = ref(null);
const showEditForm = ref(false);
const uploading = ref(false);
const errorMessage = ref(null);
const editErrorMessage = ref(null);
const successMessage = ref(null);
const editSuccessMessage = ref(null);
const isEditing = ref(false);
const originalData = ref({});

// Biến cho modal xóa
const showDeleteModal = ref(false);
const deleteItemId = ref(null);
const deleteItemName = ref("");

// Biến cho popup thông báo
const showNotification = ref(false);
const notificationType = ref('success');
const notificationTitle = ref('');
const notificationMessage = ref('');

// Biến cho form thêm mới
const showAddForm = ref(false);

// Biến cho tìm kiếm và lọc
const searchQuery = ref("");
const statusFilter = ref("");

// Pagination variables
const currentPage = ref(1);
const pageSize = ref(10);

// Refs cho file input
const fileInput = ref(null);
const editFileInput = ref(null);

const filteredAnhSanPhams = computed(() => {
  let filtered = Array.isArray(AnhSanPhams.value) ? [...AnhSanPhams.value] : [];
  if (statusFilter.value === "false") {
    filtered = filtered.filter((item) => item.trangThai === true);
  } else if (statusFilter.value === "true") {
    filtered = filtered.filter((item) => item.trangThai === false);
  }
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(
      (item) =>
        item.loaiAnh?.toLowerCase().includes(query) ||
        item.moTa?.toLowerCase().includes(query)
    );
  }

  return filtered;
});

const totalItems = computed(() => filteredAnhSanPhams.value.length);
const totalPages = computed(() => Math.ceil(totalItems.value / pageSize.value));
const startIndex = computed(() => (currentPage.value - 1) * pageSize.value);
const endIndex = computed(() => startIndex.value + pageSize.value);
const paginatedAnhSanPhams = computed(() => {
  const result = filteredAnhSanPhams.value.slice(
    startIndex.value,
    endIndex.value
  );
  return result;
});

const handleFileChange = (event) => {
  const selectedFile = event.target.files[0];
  if (selectedFile) {
    if (!selectedFile.type.startsWith("image/")) {
      errorMessage.value = "Vui lòng chọn file ảnh (jpg, png, etc.)";
      return;
    }
    if (selectedFile.size > 5 * 1024 * 1024) {
      // 5MB limit
      errorMessage.value = "File quá lớn (tối đa 5MB)";
      return;
    }
    file.value = selectedFile;
    previewUrl.value = URL.createObjectURL(selectedFile);
    errorMessage.value = null;
  }
};

const handleEditFileChange = (event) => {
  const selectedFile = event.target.files[0];
  if (selectedFile) {
    if (!selectedFile.type.startsWith("image/")) {
      editErrorMessage.value = "Vui lòng chọn file ảnh (jpg, png, etc.)";
      return;
    }
    if (selectedFile.size > 5 * 1024 * 1024) {
      editErrorMessage.value = "File quá lớn (tối đa 5MB)";
      return;
    }
    editFile.value = selectedFile;
    editPreviewUrl.value = URL.createObjectURL(selectedFile);
    editErrorMessage.value = null;
  }
};

const fetchAll = async () => {
  try {
    const response = await fetchAllAnhSanPham();
    // Service đã return data trực tiếp, không cần .data
    AnhSanPhams.value = Array.isArray(response) ? response : [];
  } catch (error) {
    console.error("Error fetching AnhSanPham:", error);
    // Đặt lại array rỗng khi có lỗi
    AnhSanPhams.value = [];
  }
};

const fetchCreate = async () => {
  if (!file.value) {
    showNotificationPopup('error', 'Lỗi', 'Vui lòng chọn file ảnh');
    return;
  }

  if (!newAnhSanPham.value.loaiAnh || newAnhSanPham.value.loaiAnh.trim() === '') {
    showNotificationPopup('error', 'Lỗi', 'Vui lòng nhập loại ảnh');
    return;
  }

  uploading.value = true;
  errorMessage.value = null;

  try {
    // Tạo FormData để gửi file
    const formData = new FormData();
    formData.append("file", file.value);
    formData.append("loaiAnh", newAnhSanPham.value.loaiAnh);
    formData.append("moTa", newAnhSanPham.value.moTa || "");
    formData.append("deleted", newAnhSanPham.value.deleted || false);
    formData.append("trangThai", newAnhSanPham.value.trangThai || true);

    await fetchCreateAnhSanPhamFromCloud(formData);

    // Reset form
    newAnhSanPham.value = {
      loaiAnh: "",
      moTa: "",
      deleted: false,
      trangThai: true,
    };
    file.value = null;
    previewUrl.value = null;

    // Reset file input
    if (fileInput.value) {
      fileInput.value.value = "";
    }

    await fetchAll();
    closeAddForm();
    showNotificationPopup('success', 'Thành công', 'Ảnh sản phẩm đã được thêm thành công!');
  } catch (error) {
    console.error("Error creating:", error);
    showNotificationPopup('error', 'Lỗi', error.message || "Không thể tạo ảnh sản phẩm");
  } finally {
    uploading.value = false;
  }
};

const fetchDetail = (value) => {
  selectedAnhSanPham.value = { ...value };
  originalData.value = { ...value };
  isEditing.value = true; // Mặc định hiển thị form edit luôn
  editFile.value = null;
  editPreviewUrl.value = null;
  showDetailModal.value = true;
};

const saveChanges = async () => {
  uploading.value = true;
  editErrorMessage.value = null;

  try {
    // Nếu có file mới được chọn thì gửi FormData
    if (editFile.value) {
      const formData = new FormData();
      formData.append("file", editFile.value);
      formData.append("loaiAnh", selectedAnhSanPham.value.loaiAnh);
      formData.append("moTa", selectedAnhSanPham.value.moTa || "");
      formData.append("deleted", selectedAnhSanPham.value.deleted || false);
      formData.append("trangThai", selectedAnhSanPham.value.trangThai);
      console.log(formData);
      await fetchUpdateAnhSanPhamFromCloud(
        selectedAnhSanPham.value.id,
        formData
      );
    } else {
      console.log(selectedAnhSanPham.value);
      // Nếu không có file mới, chỉ cập nhật thông tin bằng JSON
      const updateData = {
        duongDanAnh: selectedAnhSanPham.value.duongDanAnh,
        loaiAnh: selectedAnhSanPham.value.loaiAnh,
        moTa: selectedAnhSanPham.value.moTa || "",
        deleted: selectedAnhSanPham.value.deleted || false,
        trangThai: selectedAnhSanPham.value.trangThai,
        updateBy: 1,
      };
      console.log(updateData);
      await fetchUpdateAnhSanPham(selectedAnhSanPham.value.id, updateData);
    }

    await fetchAll();
    closeDetailModal();
    editSuccessMessage.value = "Ảnh sản phẩm đã được cập nhật thành công!";
    clearEditSuccessMessage();
  } catch (error) {
    console.error("Error updating:", error);
    editErrorMessage.value =
      "Lỗi khi cập nhật: " +
      (error.message || "Không thể cập nhật ảnh sản phẩm");
  } finally {
    uploading.value = false;
  }
};

const fetchUpdate = async () => {
  uploading.value = true;
  editErrorMessage.value = null;

  try {
    // Nếu có file mới được chọn thì gửi FormData
    if (editFile.value) {
      const formData = new FormData();
      formData.append("file", editFile.value);
      formData.append("loaiAnh", selectedAnhSanPham.value.loaiAnh);
      formData.append("moTa", selectedAnhSanPham.value.moTa || "");
      formData.append("deleted", selectedAnhSanPham.value.deleted || false);
      formData.append("trangThai", selectedAnhSanPham.value.trangThai || true);

      await fetchUpdateAnhSanPhamFromCloud(
        selectedAnhSanPham.value.id,
        formData
      );
    } else {
      // Nếu không có file mới, chỉ cập nhật thông tin bằng JSON
      const updateData = {
        duongDanAnh: selectedAnhSanPham.value.duongDanAnh,
        loaiAnh: selectedAnhSanPham.value.loaiAnh,
        moTa: selectedAnhSanPham.value.moTa || "",
        deleted: selectedAnhSanPham.value.deleted || false,
        trangThai: selectedAnhSanPham.value.trangThai || true,
        updateBy: 1,
      };

      await fetchUpdateAnhSanPham(selectedAnhSanPham.value.id, updateData);
    }

    await fetchAll();
    closeEditForm();
    showNotificationPopup('success', 'Thành công', 'Ảnh sản phẩm đã được cập nhật thành công!');
  } catch (error) {
    console.error("Error updating:", error);
    showNotificationPopup('error', 'Lỗi', error.message || "Không thể cập nhật ảnh sản phẩm");
  } finally {
    uploading.value = false;
  }
};

const fetchDelete = async (id) => {
  // Hiển thị modal xác nhận xóa
  showDeleteModal.value = true;
  deleteItemId.value = id;

  // Lấy tên ảnh để hiển thị trong thông báo
  if (Array.isArray(AnhSanPhams.value)) {
    const item = AnhSanPhams.value.find((item) => item.id === id);
    if (item) {
      deleteItemName.value = item.loaiAnh || "Ảnh sản phẩm";
    }
  }
};

const confirmDelete = async () => {
  if (!deleteItemId.value) return;

  try {
    uploading.value = true;
    await fetchUpdateStatusAnhSanPham(deleteItemId.value);
    await fetchAll();
    closeDeleteModal();
    showNotificationPopup('success', 'Thành công', 'Ảnh sản phẩm đã được xóa thành công!');
  } catch (error) {
    console.error("There has been a problem with your fetch operation:", error);
    showNotificationPopup('error', 'Lỗi', error.message || "Không thể xóa ảnh sản phẩm");
  } finally {
    uploading.value = false;
  }
};

const closeDeleteModal = () => {
  showDeleteModal.value = false;
  deleteItemId.value = null;
  deleteItemName.value = "";
};

// Methods cho popup thông báo
const showNotificationPopup = (type, title, message) => {
  notificationType.value = type;
  notificationTitle.value = title;
  notificationMessage.value = message;
  showNotification.value = true;
  
  // Tự động ẩn sau 3 giây
  setTimeout(() => {
    closeNotification();
  }, 3000);
};

const closeNotification = () => {
  showNotification.value = false;
};

const closeAddForm = () => {
  showAddForm.value = false;
  // Reset form
  newAnhSanPham.value = {
    loaiAnh: "",
    moTa: "",
    deleted: false,
    trangThai: true,
  };
  file.value = null;
  previewUrl.value = null;
  errorMessage.value = null;
  successMessage.value = null;

  // Reset file input
  if (fileInput.value) {
    fileInput.value.value = "";
  }
};

// Hàm xử lý tìm kiếm
const handleSearch = () => {
  currentPage.value = 1; // Reset về trang đầu tiên
};

// Hàm xử lý lọc
const handleFilter = () => {
  currentPage.value = 1; // Reset về trang đầu tiên
};

const closeEditForm = () => {
  showEditForm.value = false;
  editFile.value = null;
  editPreviewUrl.value = null;
  editErrorMessage.value = null;
  selectedAnhSanPham.value = {};

  // Reset edit file input
  if (editFileInput.value) {
    editFileInput.value.value = "";
  }
};

const closeDetailModal = () => {
  showDetailModal.value = false;
  isEditing.value = false;
  selectedAnhSanPham.value = {};
  originalData.value = {};
  editFile.value = null;
  editPreviewUrl.value = null;
  editErrorMessage.value = null;
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

// Pagination methods
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

// Method để tạo URL đầy đủ cho ảnh
const getImageUrl = (imagePath) => {
  if (!imagePath) return "";

  // Nếu đã là URL đầy đủ thì trả về nguyên
  if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
    return imagePath;
  }

  // Nếu là đường dẫn tương đối, thêm base URL của backend
  if (imagePath.startsWith("uploads/")) {
    return `http://localhost:8080/${imagePath}`;
  }

  // Nếu bắt đầu bằng / thì thêm base URL
  if (imagePath.startsWith("/")) {
    return `http://localhost:8080${imagePath}`;
  }

  return imagePath;
};

// Method xử lý lỗi khi ảnh không load được
const handleImageError = (event) => {
  console.error("Không thể load ảnh:", event.target.src);
  // Có thể set một ảnh mặc định
  event.target.src =
    "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgdmlld0JveD0iMCAwIDEwMCAxMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIxMDAiIGhlaWdodD0iMTAwIiBmaWxsPSIjRjNGNEY2Ii8+CjxwYXRoIGQ9Ik0zMCAzMEg3MFY3MEgzMFYzMFoiIGZpbGw9IiNEN0Q5RDEiLz4KPHN2ZyB4PSIzNSIgeT0iMzUiIHdpZHRoPSIzMCIgaGVpZ2h0PSIzMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8cGF0aCBkPSJNMTIgMkM2LjQ4IDIgMiA2LjQ4IDIgMTJzNC40OCAxMCAxMCAxMCAxMC00LjQ4IDEwLTEwUzE3LjUyIDIgMTIgMnptMCAxOGMtNC40MSAwLTgtMy41OS04LTggczMuNTktOCA4LTggOCAzLjU5IDggOC0zLjU5IDgtOCA4eiIgZmlsbD0iI0E5QUFCRCIvPgo8cGF0aCBkPSJNMTIgNkM5Ljc5IDYgOCA3Ljc5IDggMTBzMS43OSA0IDQgNCA0LTEuNzkgNC00LTEuNzktNC00LTR6bTAgNmMtMS4xIDAtMi0uOS0yLTIgMC0xLjEuOS0yIDItMiAxLjEgMCAyIC45IDIgMiAwIDEuMS0uOSAyLTIgMnoiIGZpbGw9IiNBOUFBQkQiLz4KPC9zdmc+Cjwvc3ZnPgo=";
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

/* Font size 12px cho các button trong cột thao tác */
.table-actions .btn {
  font-size: 12px !important;
  padding: 1.15rem 2rem !important;
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

