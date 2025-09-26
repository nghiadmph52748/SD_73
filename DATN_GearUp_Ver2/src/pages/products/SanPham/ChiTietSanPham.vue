<template>
  <div class="chi-tiet-san-pham-page">
    <div class="product-management">
      <div class="breadcrumb-nav">
        <RouterLink :to="`/products`" class="product-link">
          <span class="product-text">Sản phẩm</span>
        </RouterLink>
        <span class="breadcrumb-separator">/</span>
        <span class="current-breadcrumb">{{
          currentProductName ? currentProductName : "Chi tiết sản phẩm"
        }}</span>
      </div>
    </div>

    <!-- Modern Filter Section -->
    <div class="filter-section">
      <div class="filter-card">
        <div class="filter-content">
          <div class="search-section">
            <div class="input-group">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Tìm kiếm tên sản phẩm, màu sắc, kích thước..."
                class="form-control search-input"
              />
              <button
                v-if="searchQuery"
                @click="searchQuery = ''"
                class="clear-btn"
              >
                <span>✕</span>
              </button>
            </div>
          </div>

          <div class="filters-grid">
            <div class="filter-group">
              <label class="filter-label">Màu sắc</label>
              <select v-model="selectedMauSac" class="form-select">
                <option value="">Tất cả màu sắc</option>
                <option
                  v-for="color in mauSacs"
                  :key="color.id"
                  :value="color.id"
                >
                  {{ color.tenMauSac }}
                </option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">Kích thước</label>
              <select v-model="selectedKichThuoc" class="form-select">
                <option value="">Tất cả kích thước</option>
                <option
                  v-for="size in kichThuocs"
                  :key="size.id"
                  :value="size.id"
                >
                  {{ size.tenKichThuoc }}
                </option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">Chất liệu</label>
              <select v-model="selectedChatLieu" class="form-select">
                <option value="">Tất cả chất liệu</option>
                <option
                  v-for="material in chatLieus"
                  :key="material.id"
                  :value="material.id"
                >
                  {{ material.tenChatLieu }}
                </option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">Đế giày</label>
              <select v-model="selectedDeGiay" class="form-select">
                <option value="">Tất cả đế giày</option>
                <option v-for="sole in deGiays" :key="sole.id" :value="sole.id">
                  {{ sole.tenDeGiay }}
                </option>
              </select>
            </div>
          </div>

          <div class="filters-grid-2">
            <div class="filter-group">
              <label class="filter-label">Trọng lượng</label>
              <select v-model="selectedTrongLuong" class="form-select">
                <option value="">Tất cả trọng lượng</option>
                <option
                  v-for="weight in trongLuongs"
                  :key="weight.id"
                  :value="weight.id"
                >
                  {{ weight.tenTrongLuong }}
                </option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">Trạng thái</label>
              <select v-model="statusFilter" class="form-select">
                <option value="">Tất cả trạng thái</option>
                <option value="false">Hoạt động</option>
                <option value="true">Ngừng hoạt động</option>
              </select>
            </div>

            <div class="filter-actions">
              <button
                @click="clearFiltersForEdit"
                class="btn btn-outline btn-sm"
              >
                Đặt lại
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Product Details Table -->
    <div class="card">
      <div class="card-header">
        <div class="table-header-content">
          <h3 class="table-title">Danh sách biến thể sản phẩm</h3>
          <div class="table-actions">
            <button
              v-if="hasCheckedChiTietSanPhams"
              @click="saveAllCheckedChiTietSanPhamsFromPopup"
              class="btn-save-all"
              title="Cập nhật tất cả chi tiết sản phẩm đã chọn"
            >
              Hoàn thành cập nhật ({{ checkedChiTietSanPhamsCount }})
            </button>
            <button
              v-if="currentProductName"
              @click="toggleShowAllVariants"
              :class="[
                'btn-toggle-variants',
                { 'showing-all': showAllVariants },
              ]"
              :title="
                showAllVariants
                  ? 'Hiển thị biến thể sản phẩm hiện tại'
                  : 'Hiển thị toàn bộ biến thể sản phẩm'
              "
            >
              {{ toggleVariantsButtonText }}
            </button>
          </div>
        </div>
      </div>
      <div class="card-body">
        <TableContainer>
          <thead>
            <tr>
              <th class="stt-col">
                <input
                  type="checkbox"
                  :checked="isAllSelected"
                  :indeterminate="isIndeterminate"
                  @change="toggleSelectAll"
                  title="Chọn tất cả chi tiết sản phẩm"
                />
              </th>
              <th class="ma-col">Mã</th>
              <th class="image-col">Ảnh sản phẩm</th>
              <th class="nha-san-xuat-col">Nhà SX</th>
              <th class="xuat-xu-col">Xuất xứ</th>
              <th class="color-col">Màu sắc</th>
              <th class="size-col">Kích thước</th>
              <th class="sole-col">Đế giày</th>
              <th class="material-col">Chất liệu</th>
              <th class="weight-col">Trọng lượng</th>
              <th class="quantity-col">Số lượng</th>
              <th class="price-col">Giá bán</th>
              <th class="giam-gia-col">Giảm giá</th>
              <th class="gia-sau-giam-col">Giá sau giảm</th>
              <th class="status-col">Trạng thái</th>
              <th class="action-col sticky-right">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="detail in paginatedDetails"
              :key="detail.id"
              :class="{ 'editing-row': editingChiTietSanPhams.has(detail.id) }"
            >
              <td class="stt-col">
                <input
                  type="checkbox"
                  :checked="selectedChiTietSanPhams.includes(detail.id)"
                  @change="toggleChiTietSanPhamSelection(detail.id)"
                  @click.stop
                />
              </td>
              <td class="ma-col">
                {{ detail.maChiTietSanPham }}
              </td>
              <td
                class="image-col"
                :key="`image-${detail.id}-${imageDataKey.timestamp}`"
              >
                <div
                  v-if="getImagesForChiTietSanPhamForEdit(detail.id).length > 0"
                  class="image-preview"
                  :key="`image-preview-${detail.id}-${imageDataKey.timestamp}`"
                >
                  <img
                    :src="
                      getImageUrlForEdit(
                        getImagesForChiTietSanPhamForEdit(detail.id)[0]
                          ?.duongDanAnh
                      )
                    "
                    :alt="detail.tenSanPham || detail.sanPham?.tenSanPham"
                    class="product-image"
                    style="width: 60px; height: 60px"
                    :key="`image-${detail.id}-${imageDataKey.timestamp}`"
                  />
                  <span
                    v-if="
                      getImagesForChiTietSanPhamForEdit(detail.id).length > 1
                    "
                    class="image-count"
                    :key="`count-${detail.id}-${imageDataKey.timestamp}`"
                  >
                    +{{
                      getImagesForChiTietSanPhamForEdit(detail.id).length - 1
                    }}
                  </span>
                </div>
                <span v-else class="no-image">Không có ảnh</span>
              </td>
              <td class="nha-san-xuat-col">
                <span class="nha-san-xuat-text">{{
                  detail.tenNhaSanXuat || "N/A"
                }}</span>
              </td>
              <td class="xuat-xu-col">
                <span class="xuat-xu-text">{{
                  detail.tenXuatXu || "N/A"
                }}</span>
              </td>
              <td class="color-col">
                <span class="color-badge">
                  {{ detail.tenMauSac || "N/A" }}
                </span>
              </td>
              <td class="size-col">
                <span class="size-badge">{{
                  detail.tenKichThuoc || "N/A"
                }}</span>
              </td>
              <td class="sole-col">
                <span class="attribute-text">{{
                  detail.tenDeGiay || "N/A"
                }}</span>
              </td>
              <td class="material-col">
                <span class="attribute-text">{{
                  detail.tenChatLieu || "N/A"
                }}</span>
              </td>
              <td class="weight-col">
                <span class="attribute-text">{{
                  detail.tenTrongLuong || "N/A"
                }}</span>
              </td>
              <td class="quantity-col">
                <div
                  v-if="editingChiTietSanPhams.has(detail.id)"
                  class="inline-edit"
                >
                  <input
                    v-model="editingChiTietSanPhams.get(detail.id).soLuong"
                    type="number"
                    class="edit-mode-input edit-input-soLuong"
                    min="0"
                    @keyup.enter="saveInlineEdit(detail.id)"
                    @keyup.esc="cancelInlineEdit(detail.id)"
                  />
                </div>
                <div
                  v-else
                  class="stock-badge"
                  :class="{ 'low-stock': detail.soLuong < 10 }"
                >
                  {{ detail.soLuong }}
                </div>
              </td>
              <td class="price-col">
                <div
                  v-if="editingChiTietSanPhams.has(detail.id)"
                  class="inline-edit"
                >
                  <input
                    v-model="editingChiTietSanPhams.get(detail.id).giaBan"
                    type="number"
                    class="edit-mode-input edit-input-giaBan"
                    min="0"
                    step="1000"
                    @keyup.enter="saveInlineEdit(detail.id)"
                    @keyup.esc="cancelInlineEdit(detail.id)"
                  />
                </div>
                <div v-else class="price-text">
                  {{ formatCurrency(detail.giaBan) }}
                </div>
              </td>
              <td class="giam-gia-col">
                <span v-if="detail.giaTriGiamGia > 0" class="giam-gia-value">
                  {{ detail.giaTriGiamGia }}%
                </span>
                <span v-else class="giam-gia-text">-</span>
              </td>
              <td class="gia-sau-giam-col">
                <span class="gia-sau-giam-text">{{
                  formatCurrency(
                    (detail.giaBan / 100) * (100 - detail.giaTriGiamGia)
                  )
                }}</span>
              </td>
              <td class="status-col">
                <div
                  v-if="editingChiTietSanPhams.has(detail.id)"
                  class="inline-edit"
                >
                  <select
                    v-model="editingChiTietSanPhams.get(detail.id).trangThai"
                    class="edit-mode-select"
                  >
                    <option :value="true">Hoạt động</option>
                    <option :value="false">Ngừng hoạt động</option>
                  </select>
                </div>
                <span
                  v-else
                  class="status-badge"
                  :class="
                    detail.trangThai ? 'status-active' : 'status-inactive'
                  "
                >
                  {{ detail.trangThai ? "Hoạt động" : "Tạm ngưng bán" }}
                </span>
              </td>
              <td class="action-col sticky-right">
                <div class="action-buttons">
                  <div class="action-buttons">
                    <button
                      @click="startEdit(detail)"
                      class="btn btn-secondary btn-sm"
                      title="Cập nhật"
                    >
                      Chi tiết
                    </button>
                    <button
                      @click="deleteChiTietSanPham(detail)"
                      class="btn btn-danger btn-sm"
                      title="Xóa biến thể"
                    >
                      Xoá
                    </button>
                  </div>
                </div>
              </td>
            </tr>
            <tr v-if="paginatedDetails.length === 0">
              <td colspan="15" class="no-data">Không có dữ liệu</td>
            </tr>
          </tbody>
        </TableContainer>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của
            {{ filteredDetails.length }} chi tiết sản phẩm ({{ pageSize }}
            dòng/trang)
          </div>
          <div class="pagination">
            <button
              @click="previousPageForEdit"
              :disabled="currentPage === 1"
              class="btn btn-outline btn-sm"
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
              @click="nextPageForEdit"
              :disabled="currentPage === totalPages"
              class="btn btn-outline btn-sm"
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
        <div v-else-if="filteredDetails.length > 0" class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị tất cả {{ filteredDetails.length }} chi tiết sản phẩm
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Popup xác nhận xóa -->
  <div
    v-if="showDeletePopup"
    class="delete-popup-overlay"
    @click="closeDeletePopup"
  >
    <div class="delete-popup" @click.stop>
      <div class="delete-popup-header">
        <h3>Xác nhận xóa</h3>
        <button @click="closeDeletePopup" class="close-btn">×</button>
      </div>
      <div class="delete-popup-content">
        <p>Bạn có chắc chắn muốn xóa biến thể này?</p>
        <div class="delete-details" v-if="deleteDetail">
          <div class="detail-row">
            <span class="detail-label">Sản phẩm:</span>
            <span class="detail-value">{{
              deleteDetail.tenSanPham || "N/A"
            }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Màu sắc:</span>
            <span class="detail-value">{{
              deleteDetail.tenMauSac || "N/A"
            }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Kích thước:</span>
            <span class="detail-value">{{
              deleteDetail.tenKichThuoc || "N/A"
            }}</span>
          </div>
        </div>
        <div class="delete-warning">
          ⚠️ Lưu ý: Chỉ biến thể này sẽ bị xóa, các biến thể khác của sản phẩm
          sẽ được giữ nguyên.
        </div>
        <div class="delete-popup-actions">
          <button @click="closeDeletePopup" class="btn-delete-cancel">
            Hủy
          </button>
          <button @click="confirmDelete" class="btn-delete-confirm">
            Xóa biến thể
          </button>
        </div>
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

  <!-- Popup thông báo thành công - Không còn sử dụng, thay bằng popup thông báo bên phải -->
  <!--
  <div
    v-if="showSuccessPopup"
    class="success-popup-overlay"
    @click="closeSuccessPopupForEdit"
  >
    <div class="success-popup" @click.stop>
      <div class="success-popup-content">
        <h3 class="success-title">Thành công!</h3>
        <p class="success-message">{{ successMessage }}</p>
        <button class="success-btn" @click="closeSuccessPopupForEdit">
          Đóng
        </button>
      </div>
    </div>
  </div>
  -->

  <!-- Popup Edit Chi Tiết Sản Phẩm -->
  <div v-if="showEditPopup" class="edit-popup-overlay" @click="closeEditPopup">
    <div class="edit-popup" @click.stop>
      <div class="edit-popup-header">
        <h3>Chỉnh sửa chi tiết sản phẩm</h3>
        <button @click="closeEditPopup" class="close-btn">×</button>
      </div>
      <div class="edit-popup-content">
        <div class="form-row">
          <div class="form-group">
            <label>Nhà sản xuất:</label>
            <select
              v-model="currentEditingDetail.tenNhaSanXuat"
              class="form-select"
            >
              <option value="">Chọn nhà sản xuất</option>
              <option
                v-for="nhaSanXuat in nhaSanXuats"
                :key="nhaSanXuat.id"
                :value="nhaSanXuat.tenNhaSanXuat"
              >
                {{ nhaSanXuat.tenNhaSanXuat }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>Xuất xứ:</label>
            <select
              v-model="currentEditingDetail.tenXuatXu"
              class="form-select"
            >
              <option value="">Chọn xuất xứ</option>
              <option
                v-for="xuatXu in xuatXus"
                :key="xuatXu.id"
                :value="xuatXu.tenXuatXu"
              >
                {{ xuatXu.tenXuatXu }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>Màu sắc:</label>
            <select
              v-model="currentEditingDetail.tenMauSac"
              class="form-select"
            >
              <option value="">Chọn màu sắc</option>
              <option
                v-for="mauSac in mauSacs"
                :key="mauSac.id"
                :value="mauSac.tenMauSac"
              >
                {{ mauSac.tenMauSac }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>Kích thước:</label>
            <select
              v-model="currentEditingDetail.tenKichThuoc"
              class="form-select"
            >
              <option value="">Chọn kích thước</option>
              <option
                v-for="kichThuoc in kichThuocs"
                :key="kichThuoc.id"
                :value="kichThuoc.tenKichThuoc"
              >
                {{ kichThuoc.tenKichThuoc }}
              </option>
            </select>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Chất liệu:</label>
            <select
              v-model="currentEditingDetail.tenChatLieu"
              class="form-select"
            >
              <option value="">Chọn chất liệu</option>
              <option
                v-for="chatLieu in chatLieus"
                :key="chatLieu.id"
                :value="chatLieu.tenChatLieu"
              >
                {{ chatLieu.tenChatLieu }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>Đế giày:</label>
            <select
              v-model="currentEditingDetail.tenDeGiay"
              class="form-select"
            >
              <option value="">Chọn đế giày</option>
              <option
                v-for="deGiay in deGiays"
                :key="deGiay.id"
                :value="deGiay.tenDeGiay"
              >
                {{ deGiay.tenDeGiay }}
              </option>
            </select>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Trọng lượng:</label>
            <select
              v-model="currentEditingDetail.tenTrongLuong"
              class="form-select"
            >
              <option value="">Chọn trọng lượng</option>
              <option
                v-for="trongLuong in trongLuongs"
                :key="trongLuong.id"
                :value="trongLuong.tenTrongLuong"
              >
                {{ trongLuong.tenTrongLuong }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>Đợt giảm giá:</label>
            <input
              v-model="currentEditingDetail.tenDotGiamGia"
              type="text"
              class="form-input"
              readonly
              placeholder="Đợt giảm giá hiện tại"
            />
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Số lượng:</label>
            <input
              v-model="currentEditingDetail.soLuong"
              type="number"
              min="0"
              class="form-input"
            />
          </div>
          <div class="form-group">
            <label>Giá bán:</label>
            <input
              v-model="currentEditingDetail.giaBan"
              type="number"
              min="0"
              step="1000"
              class="form-input"
            />
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Trạng thái:</label>
            <select
              v-model="currentEditingDetail.trangThai"
              class="form-select"
            >
              <option :value="true">Hoạt động</option>
              <option :value="false">Ngừng hoạt động</option>
            </select>
          </div>
          <div class="form-group">
            <label>Ảnh sản phẩm:</label>
            <div class="image-selector-section">
              <div class="current-images">
                <div
                  v-for="(image, index) in currentEditingDetail.images"
                  :key="index"
                  class="image-item"
                >
                  <img
                    :src="getImageDisplayUrl(image)"
                    :alt="`Ảnh ${index + 1}`"
                    class="thumbnail"
                  />
                  <button
                    @click="removeImageFromPopup(index)"
                    class="remove-image-btn"
                    type="button"
                  >
                    ×
                  </button>
                </div>
              </div>
              <div class="image-actions">
                <button
                  @click="openImageSelectorForEdit"
                  class="btn btn-outline btn-sm"
                  type="button"
                  :disabled="
                    currentEditingDetail.images &&
                    currentEditingDetail.images.length >= 5
                  "
                >
                  Chọn ảnh có sẵn
                </button>
                <div class="upload-section">
                  <input
                    ref="fileInput"
                    type="file"
                    accept="image/*"
                    multiple
                    @change="handleFileUploadForEdit"
                    class="file-input"
                    :disabled="
                      currentEditingDetail.images &&
                      currentEditingDetail.images.length >= 5
                    "
                  />
                  <button
                    @click="triggerFileUploadForEdit"
                    class="btn btn-outline btn-sm"
                    type="button"
                    :disabled="
                      currentEditingDetail.images &&
                      currentEditingDetail.images.length >= 5
                    "
                  >
                    Upload ảnh mới
                  </button>
                </div>
              </div>
              <span
                v-if="
                  currentEditingDetail.images &&
                  currentEditingDetail.images.length >= 5
                "
                class="image-limit-info"
              >
                Tối đa 5 ảnh
              </span>
            </div>
          </div>
        </div>

        <!-- Upload Progress Section -->
        <div
          v-if="isUploadingImages || Object.keys(uploadProgress).length > 0"
          class="upload-progress-section"
        >
          <div class="upload-progress-header">
            <h4>📤 Trạng thái upload ảnh</h4>
            <button
              @click="clearUploadProgress"
              class="btn-clear-progress"
              title="Xóa trạng thái upload"
            >
              🗑️
            </button>
          </div>
          <div class="upload-progress-list">
            <div
              v-for="(progress, fileName) in uploadProgress"
              :key="fileName"
              class="upload-progress-item"
              :class="progress.status"
            >
              <div class="progress-info">
                <span class="file-name">{{ fileName }}</span>
                <span class="attempt-count">Lần {{ progress.attempt }}</span>
              </div>
              <div class="progress-bar">
                <div
                  class="progress-fill"
                  :style="{ width: progress.progress + '%' }"
                ></div>
              </div>
              <div class="progress-status">
                <span
                  v-if="progress.status === 'uploading'"
                  class="status-uploading"
                >
                  ⏳ Đang upload...
                </span>
                <span
                  v-else-if="progress.status === 'success'"
                  class="status-success"
                >
                  ✅ Thành công
                </span>
                <span
                  v-else-if="progress.status === 'error'"
                  class="status-error"
                >
                  ❌ Lỗi: {{ progress.error }}
                </span>
                <span
                  v-else-if="progress.status === 'timeout'"
                  class="status-timeout"
                >
                  ⏰ Timeout
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Upload warning message -->
        <div v-if="isSaveDisabled" class="upload-warning-message">
          ⚠️ {{ saveButtonTooltip }}
        </div>

        <div class="edit-popup-actions">
          <button @click="closeEditPopup" class="btn btn-outline btn-sm">
            Hủy
          </button>
          <button
            @click="saveEditPopupFromPopup"
            class="btn btn-primary"
            :disabled="isSaveDisabled"
            :title="saveButtonTooltip"
          >
            <span v-if="isSaveDisabled" class="btn-loading-icon">⏳</span>
            {{
              isRefreshingData
                ? "Đang cập nhật..."
                : isSaveDisabled
                ? "Đang upload..."
                : "Lưu"
            }}
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Popup chọn ảnh cho edit -->
  <div
    v-if="showImageSelectorForEdit"
    class="image-selector-overlay"
    @click="closeImageSelectorForEdit"
  >
    <div class="image-selector-popup" @click.stop>
      <div class="image-selector-header">
        <h3>Chọn ảnh sản phẩm</h3>
        <button @click="closeImageSelectorForEdit" class="close-btn">×</button>
      </div>
      <div class="image-selector-content">
        <div class="selected-images-preview">
          <h4>Ảnh đã chọn ({{ selectedImagesForEdit.length }}/5):</h4>
          <div class="selected-images-grid">
            <div
              v-for="(image, index) in selectedImagesForEdit"
              :key="index"
              class="selected-image-item"
            >
              <img
                :src="getImageUrlForEdit(image.duongDanAnh)"
                :alt="`Ảnh ${index + 1}`"
                class="preview-image"
              />
              <button
                @click="removeSelectedImageForEditPopup(index)"
                class="remove-selected-btn"
                type="button"
              >
                ×
              </button>
            </div>
          </div>
        </div>
        <div class="available-images-section">
          <h4>Ảnh có sẵn:</h4>
          <div class="available-images-grid">
            <div
              v-for="image in availableImagesForEdit"
              :key="image.id"
              class="available-image-item"
              :class="{ selected: isImageSelectedForEdit(image.id) }"
              @click="toggleImageSelectionForEdit(image)"
            >
              <img
                :src="getImageUrlForEdit(image.duongDanAnh)"
                :alt="image.moTa || 'Ảnh sản phẩm'"
                class="available-image"
              />
              <div class="image-overlay">
                <span
                  v-if="isImageSelectedForEdit(image.id)"
                  class="selected-indicator"
                  ><!-- icon: checkmark --></span
                >
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="image-selector-actions">
        <button
          @click="closeImageSelectorForEdit"
          class="btn btn-outline btn-sm"
        >
          Hủy
        </button>
        <button
          @click="confirmImageSelectionForEditPopup"
          class="btn btn-primary"
        >
          Xác nhận
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";
import { useRoute } from "vue-router";
import {
  fetchAllChiTietDotGiamGia,
  fetchUpdateChiTietDotGiamGia,
} from "../../../services/GiamGia/ChiTietDotGiamGiaService";
import { fetchAllDotGiamGia } from "../../../services/GiamGia/DotGiamGiaService";
import {
  fetchAllChiTietSanPham,
  fetchAllChiTietSanPhamBySanPhamId,
  fetchCreateChiTietSanPham,
  fetchUpdateChiTietSanPham,
  fetchUpdateStatusChiTietSanPham,
} from "../../../services/SanPham/ChiTietSanPhamService";
import {
  fetchAllSanPham,
  fetchUpdateSanPham,
} from "../../../services/SanPham/SanPhamService";
import {
  fetchAllAnhSanPham,
  fetchCreateAnhSanPhamFromCloud,
  fetchOneAnhSanPham,
  fetchUpdateAnhSanPham,
  fetchUpdateStatusAnhSanPham,
} from "../../../services/ThuocTinh/AnhSanPhamService";
import { fetchAllChatLieu } from "../../../services/ThuocTinh/ChatLieuService";
import {
  fetchAllChiTietSanPhamAnh,
  fetchCreateMultipleChiTietSanPhamAnh,
  fetchDeleteChiTietSanPhamAnh,
  fetchUpdateStatusChiTietSanPhamAnh,
  fetchUpdateStatusMultipleChiTietSanPhamAnh,
} from "../../../services/ThuocTinh/ChiTietSanPhamAnhService";
import { fetchAllDeGiay } from "../../../services/ThuocTinh/DeGiayService";
import { fetchAllKichThuoc } from "../../../services/ThuocTinh/KichThuocService";
import { fetchAllMauSac } from "../../../services/ThuocTinh/MauSacService";
import { fetchAllNhaSanXuat } from "../../../services/ThuocTinh/NhaSanXuatService";
import { fetchAllTrongLuong } from "../../../services/ThuocTinh/TrongLuongService";
import { fetchAllXuatXu } from "../../../services/ThuocTinh/XuatXuService";
import TableContainer from "@/components/common/TableContainer.vue";
// Hàm tìm ID từ tên thuộc tính
const findIdByName = async (type, name) => {
  try {
    if (!name || name.trim() === "") return 1; // Default ID

    let data = [];

    switch (type) {
      case "sanPham":
        if (sanPhams.value.length === 0) {
          const response = await fetchAllSanPham();
          sanPhams.value = response.data || [];
        }
        data = sanPhams.value;
        break;
      case "mauSac":
        if (mauSacs.value.length === 0) {
          const response = await fetchAllMauSac();
          mauSacs.value = response.data || [];
        }
        data = mauSacs.value;
        break;
      case "kichThuoc":
        if (kichThuocs.value.length === 0) {
          const response = await fetchAllKichThuoc();
          kichThuocs.value = response.data || [];
        }
        data = kichThuocs.value;
        break;
      case "chatLieu":
        if (chatLieus.value.length === 0) {
          const response = await fetchAllChatLieu();
          chatLieus.value = response.data || [];
        }
        data = chatLieus.value;
        break;
      case "deGiay":
        if (deGiays.value.length === 0) {
          const response = await fetchAllDeGiay();
          deGiays.value = response.data || [];
        }
        data = deGiays.value;
        break;
      case "trongLuong":
        if (trongLuongs.value.length === 0) {
          const response = await fetchAllTrongLuong();
          trongLuongs.value = response.data || [];
        }
        data = trongLuongs.value;
        break;
      default:
        return 1; // Default ID
    }

    // Tìm item có tên trùng khớp
    const foundItem = data.find((item) => {
      const itemName =
        item.tenSanPham ||
        item.tenMauSac ||
        item.tenKichThuoc ||
        item.tenChatLieu ||
        item.tenDeGiay ||
        item.tenTrongLuong;
      return (
        itemName && itemName.trim().toLowerCase() === name.trim().toLowerCase()
      );
    });

    return foundItem ? foundItem.id : 1; // Trả về ID nếu tìm thấy, ngược lại trả về 1
  } catch (error) {
    console.error(`Lỗi khi tìm ID cho ${type} với tên "${name}":`, error);
    return 1; // Default ID nếu có lỗi
  }
};

// Hàm xóa chi tiết sản phẩm an toàn
const deleteChiTietSanPham = async (detail) => {
  if (!detail || !detail.id) {
    console.error("❌ Không tìm thấy chi tiết sản phẩm để xóa");
    return;
  }

  // Hiển thị popup xác nhận
  deleteDetail.value = detail;
  showDeletePopup.value = true;
};

// Hàm xác nhận xóa
const confirmDelete = async () => {
  const detail = deleteDetail.value;
  if (!detail || !detail.id) {
    console.error("❌ Không tìm thấy chi tiết sản phẩm để xóa");
    return;
  }

  try {
    // Cập nhật trạng thái deleted = true thay vì xóa hoàn toàn
    const response = await fetchUpdateStatusChiTietSanPham(detail.id);

    if (response && response.success !== false) {
      console.log("✅ Đã xóa thành công biến thể:", detail.id);

      // Refresh dữ liệu chỉ của sản phẩm hiện tại
      if (currentProduct.value?.id) {
        await refreshImageData();
      }

      // Hiển thị popup thông báo thành công bên phải
      showNotificationPopup("success", "Thành công", "Đã xóa biến thể thành công!");
    } else {
      throw new Error("API trả về kết quả không thành công");
    }
  } catch (error) {
    console.error("❌ Lỗi khi xóa biến thể:", error);
    alert(`Lỗi khi xóa biến thể: ${error.message || "Lỗi không xác định"}`);
  } finally {
    // Đóng popup xác nhận
    closeDeletePopup();
  }
};

// Hàm đóng popup xóa
const closeDeletePopup = () => {
  showDeletePopup.value = false;
  deleteDetail.value = null;
};

// Reactive data
const searchQuery = ref("");
const selectedSanPham = ref("");
const selectedMauSac = ref("");
const selectedKichThuoc = ref("");
const selectedChatLieu = ref("");
const selectedDeGiay = ref("");
const selectedTrongLuong = ref("");
const selectedDotGiamGia = ref("");
const statusFilter = ref("");
const showAddModal = ref(false);
const showAllVariants = ref(false); // Biến để kiểm soát hiển thị tất cả biến thể hay chỉ biến thể của sản phẩm hiện tại
const showEditModal = ref(false);
const showImageSelector = ref(false);
const currentPage = ref(1);
const pageSize = ref(10);
const selectedImages = ref([]);
const selectedImageIds = ref([]);
const availableImages = ref([]);
// Biến cho popup thông báo
const showNotification = ref(false);
const notificationType = ref('success');
const notificationTitle = ref('');
const notificationMessage = ref('');

// Loading states cho upload
const isUploadingImages = ref(false);
const uploadProgress = ref({});
const uploadTimeout = 30000; // 30 giây timeout
const maxRetries = 2;

// Loading state cho refresh data
const isRefreshingData = ref(false);

// Computed property để kiểm tra trạng thái upload và refresh
const isSaveDisabled = computed(() => {
  // Disable nếu đang upload ảnh
  if (isUploadingImages.value) {
    return true;
  }

  // Disable nếu đang refresh data
  if (isRefreshingData.value) {
    return true;
  }

  // Disable nếu có file đang upload nhưng chưa hoàn thành
  const uploadingFiles = Object.values(uploadProgress.value).filter(
    (progress) => progress.status === "uploading"
  );

  return uploadingFiles.length > 0;
});

// Computed property để lấy tooltip cho nút lưu
const saveButtonTooltip = computed(() => {
  if (isSaveDisabled.value) {
    // Kiểm tra trạng thái refresh data trước
    if (isRefreshingData.value) {
      return "Đang cập nhật dữ liệu, vui lòng đợi hoàn thành";
    }

    // Sau đó kiểm tra upload
    const uploadingCount = Object.values(uploadProgress.value).filter(
      (progress) => progress.status === "uploading"
    ).length;

    if (uploadingCount > 0) {
      return `Đang upload ${uploadingCount} ảnh, vui lòng đợi hoàn thành`;
    }

    return "Đang xử lý upload ảnh, vui lòng đợi";
  }

  return "Lưu thay đổi";
});

// Biến lưu trữ trạng thái ban đầu của ảnh để so sánh
const initialImageIds = ref([]);
const initialImages = ref([]);
// const successMessage = ref(""); // Không còn sử dụng, thay bằng popup thông báo bên phải

// Hàm upload với timeout và retry
const uploadImageWithRetry = async (formData, fileName, retryCount = 0) => {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), uploadTimeout);

  try {
    // Cập nhật progress
    uploadProgress.value[fileName] = {
      status: "uploading",
      progress: 50,
      attempt: retryCount + 1,
    };

    const response = await fetchCreateAnhSanPhamFromCloud(formData, {
      signal: controller.signal,
      retryCount,
    });

    clearTimeout(timeoutId);

    // Cập nhật progress thành công
    uploadProgress.value[fileName] = {
      status: "success",
      progress: 100,
      attempt: retryCount + 1,
    };

    return response;
  } catch (error) {
    clearTimeout(timeoutId);

    if (error.name === "AbortError") {
      console.warn(
        `⏰ Upload timeout cho file: ${fileName} (attempt ${retryCount + 1})`
      );

      // Cập nhật progress timeout
      uploadProgress.value[fileName] = {
        status: "timeout",
        progress: 0,
        attempt: retryCount + 1,
        error: "Timeout",
      };
    } else {
      console.error(
        `❌ Upload failed cho file: ${fileName} (attempt ${retryCount + 1}):`,
        error
      );

      // Cập nhật progress lỗi
      uploadProgress.value[fileName] = {
        status: "error",
        progress: 0,
        attempt: retryCount + 1,
        error: error.message,
      };
    }

    // Retry logic
    if (retryCount < maxRetries) {
      await new Promise((resolve) => setTimeout(resolve, 2000)); // Đợi 2 giây trước retry

      return uploadImageWithRetry(formData, fileName, retryCount + 1);
    }

    // Nếu hết retry thì throw error
    throw new Error(
      `Upload failed after ${maxRetries + 1} attempts: ${error.message}`
    );
  }
};
const sanPhams = ref([]);

// Inline editing variables
const editingChiTietSanPhams = ref(new Map()); // Map để lưu nhiều chi tiết sản phẩm đang edit
const selectedChiTietSanPhams = ref([]);
const originalChiTietSanPhams = ref(new Map()); // Map để lưu dữ liệu gốc
const isEditing = ref(false); // Biến để kiểm tra trạng thái edit

// Biến cho popup edit
const showEditPopup = ref(false);
const currentEditingDetail = ref({});

// Biến cho popup chọn ảnh edit
const showImageSelectorForEdit = ref(false);
const selectedImagesForEdit = ref([]);
const availableImagesForEdit = ref([]);

// Biến cho popup xóa
const showDeletePopup = ref(false);
const deleteDetail = ref(null);

// Biến cho file upload
const fileInput = ref(null);
const newChiTietSanPham = ref({
  id: 0,
  idSanPham: 0,
  idMauSac: 0,
  idKichThuoc: 0,
  idDeGiay: 0,
  idChatLieu: 0,
  idTrongLuong: 0,
  idDotGiamGia: 0,
  soLuong: 0,
  giaBan: 0,
  trangThai: false,
  deleted: false,
  createdAt: "",
  createBy: 0,
  updatedAt: "",
  updateBy: 0,
});

// Data for dropdowns
const anhSanPhams = ref([]);
const chiTietSanPhams = ref([]);
const chiTietSanPhamAnhs = ref([]);
const mauSacs = ref([]);
const kichThuocs = ref([]);
const chatLieus = ref([]);
const deGiays = ref([]);
const trongLuongs = ref([]);
const nhaSanXuats = ref([]);
const xuatXus = ref([]);
const dotGiamGias = ref([]);
const chiTietDotGiamGias = ref([]);

// ========================================
// SETUP & LIFECYCLE
// ========================================


// Hàm xử lý keyboard shortcuts
const handleKeydown = (event) => {
  // Ctrl+R hoặc F5 để refresh all data
  if ((event.ctrlKey && event.key === "r") || event.key === "F5") {
    event.preventDefault();
    console.log("🔄 Keyboard shortcut detected: Refreshing all data...");
    refreshAllData();
  }
};

onMounted(async () => {
  // Add keyboard shortcut listener
  window.addEventListener("keydown", handleKeydown);

  const id = route.params.id ? route.params.id : null;
  console.log("id", id);

  try {
    // 1. Fetch sản phẩm và các thuộc tính cơ bản
    await fetchSanPham();
    await fetchAnhSanPham();
    await fetchChiTietSanPhamAnh();
    await fetchMauSac();
    await fetchKichThuoc();
    await fetchDeGiay();
    await fetchChatLieu();
    await fetchTrongLuong();
    await fetchNhaSanXuat();
    await fetchXuatXu();
    await fetchDotGiamGia();

    // 2. Fetch chi tiết sản phẩm TRƯỚC
    if (id != null) {
      await fetchChiTietSanPham(id);
    } else {
      await fetchChiTietSanPham();
    }

    // 3. Fetch chi tiết đợt giảm giá SAU khi đã có chi tiết sản phẩm
    await fetchChiTietDotGiamGia();
  } catch (error) {
    alert("Có lỗi xảy ra khi tải dữ liệu ban đầu!");
  }
});

// Cleanup event listeners
onUnmounted(() => {
  window.removeEventListener("keydown", handleKeydown);
});

// ========================================
// COMPUTED PROPERTIES
// ========================================

const currentProduct = computed(() => {
  const routeId = parseInt(route.params.id);
  const foundProduct = sanPhams.value.find((sanPham) => sanPham.id === routeId);

  return foundProduct;
});

const currentEditingDetailImages = computed(() => {
  return currentEditingDetail.value?.images || [];
});

const currentEditingDetailImagesCount = computed(() => {
  return currentEditingDetailImages.value.length;
});

const imageLimitReached = computed(() => {
  return currentEditingDetailImagesCount.value >= 5;
});


// ========================================
// DATA FETCHING FUNCTIONS
// ========================================

const fetchSanPham = async () => {
  try {
    const response = await fetchAllSanPham();
    sanPhams.value = response.data || [];
  } catch (error) {}
};

const fetchAnhSanPham = async () => {
  try {
    const response = await fetchAllAnhSanPham();

    // Xử lý nhiều format response khác nhau
    let anhData = [];
    if (response && response.data) {
      anhData = response.data;
    } else if (Array.isArray(response)) {
      anhData = response;
    } else if (response && Array.isArray(response.data)) {
      anhData = response.data;
    }

    anhSanPhams.value = anhData;
  } catch (error) {
    console.error("❌ Lỗi trong fetchAnhSanPham:", error);
  }
};

const fetchChiTietSanPhamAnh = async () => {
  try {
    const response = await fetchAllChiTietSanPhamAnh();

    // Xử lý nhiều format response khác nhau
    let anhData = [];
    if (response && response.data) {
      anhData = response.data;
    } else if (Array.isArray(response)) {
      anhData = response;
    } else if (response && Array.isArray(response.data)) {
      anhData = response.data;
    }

    chiTietSanPhamAnhs.value = anhData;
  } catch (error) {
    console.error("❌ Lỗi trong fetchChiTietSanPhamAnh:", error);
  }
};

const fetchMauSac = async () => {
  try {
    const response = await fetchAllMauSac();
    mauSacs.value = response.data || [];
  } catch (error) {}
};

const fetchKichThuoc = async () => {
  try {
    const response = await fetchAllKichThuoc();
    kichThuocs.value = response.data || [];
  } catch (error) {}
};

const fetchDeGiay = async () => {
  try {
    const response = await fetchAllDeGiay();
    deGiays.value = response.data || [];
  } catch (error) {}
};

const fetchChatLieu = async () => {
  try {
    const response = await fetchAllChatLieu();
    chatLieus.value = response.data || [];
  } catch (error) {}
};

const fetchTrongLuong = async () => {
  try {
    const response = await fetchAllTrongLuong();
    trongLuongs.value = response.data || [];
  } catch (error) {}
};

const fetchNhaSanXuat = async () => {
  try {
    const response = await fetchAllNhaSanXuat();
    nhaSanXuats.value = response.data || [];
  } catch (error) {}
};

const fetchXuatXu = async () => {
  try {
    const response = await fetchAllXuatXu();
    xuatXus.value = response.data || [];
  } catch (error) {}
};

const fetchDotGiamGia = async () => {
  try {
    const response = await fetchAllDotGiamGia();
    dotGiamGias.value = response.data || [];
  } catch (error) {}
};

const fetchChiTietSanPham = async (id) => {
  try {
    if (id) {
      // Fetch all chi tiet san pham by san pham ID
      const response = await fetchAllChiTietSanPhamBySanPhamId(id);
      if (response.data) {
        chiTietSanPhams.value = response.data || [];
      }
    } else {
      // Fetch all chi tiet san pham
      const response = await fetchAllChiTietSanPham();
      chiTietSanPhams.value = response.data || [];
    }
  } catch (error) {
    console.error("❌ Lỗi trong fetchChiTietSanPham:", error);
  }
};

const fetchChiTietDotGiamGia = async () => {
  try {
    const response = await fetchAllChiTietDotGiamGia();
    chiTietDotGiamGias.value = response.data || [];
  } catch (error) {}
};

const toggleShowAllVariants = async () => {
  showAllVariants.value = !showAllVariants.value;
  const id = route.params.id;

  if (showAllVariants.value) {
    // Hiển thị tất cả biến thể
    await fetchChiTietSanPham(); // Không truyền id để fetch tất cả
  } else {
    // Hiển thị biến thể của sản phẩm hiện tại
    await fetchChiTietSanPham(id); // Truyền id để fetch theo sản phẩm
  }
};

// Computed để tạo text động cho nút
const toggleVariantsButtonText = computed(() => {
  return showAllVariants.value
    ? "Hiển thị biến thể sản phẩm hiện tại"
    : "Hiển thị toàn bộ biến thể";
});
const fetchAll = async () => {
  try {
    await Promise.all([
      fetchSanPham(),
      fetchAnhSanPham(),
      fetchChiTietSanPhamAnh(),
      fetchMauSac(),
      fetchKichThuoc(),
      fetchDeGiay(),
      fetchChatLieu(),
      fetchTrongLuong(),
      fetchNhaSanXuat(),
      fetchXuatXu(),
      fetchDotGiamGia(),
      fetchChiTietDotGiamGia(),
    ]);
  } catch (error) {}
};

const fetchAllThuocTinh = async () => {
  try {
    await Promise.all([
      fetchAnhSanPham(),
      fetchChiTietSanPhamAnh(),
      fetchMauSac(),
      fetchKichThuoc(),
      fetchDeGiay(),
      fetchChatLieu(),
      fetchTrongLuong(),
      fetchNhaSanXuat(),
      fetchXuatXu(),
    ]);
  } catch (error) {}
};

// ========================================
// IMAGE HANDLING FUNCTIONS
// ========================================

const uploadNewImagesForPopup = async (imageFiles, chiTietSanPhamId) => {
  const uploadedImages = [];

  for (const file of imageFiles) {
    try {
      if (!validateImageFile(file)) {
        continue;
      }

      const formData = new FormData();
      formData.append("file", file);
      formData.append("loaiAnh", file.name.split(".").pop());

      const response = await fetchCreateAnhSanPhamFromCloud(formData);

      if (
        response &&
        response.message &&
        response.message.includes("thành công")
      ) {
        // Backend trả về list ID (multiple images)
        let imageIds = [];
        if (
          response.data &&
          Array.isArray(response.data) &&
          response.data.length > 0
        ) {
          imageIds = response.data;
        } else {
          // Fallback: tạo temp ID nếu không có ID thực
          console.warn("⚠️ Backend không trả về ID, tạo temp ID");
        }

        // Sử dụng ID đầu tiên cho ảnh này
        const imageId = imageIds[0];

        // Tự động tạo liên kết trong ChiTietSanPhamAnh
        try {
          // Chỉ gửi ID thực (số nguyên), loại bỏ temp ID string
          const realImageIds = imageIds.filter(
            (id) =>
              typeof id === "number" ||
              (typeof id === "string" && !id.startsWith("temp_"))
          );

          if (realImageIds.length === 0) {
            console.warn(
              "⚠️ Không có ID thực để tạo liên kết, bỏ qua bước này"
            );
            return;
          }

          const linkData = {
            idChiTietSanPham: chiTietSanPhamId,
            idAnhSanPhamList: realImageIds, // Chỉ gửi ID thực
            trangThai: true,
            deleted: false,
          };

          const linkResponse = await fetchCreateMultipleChiTietSanPhamAnh(
            linkData
          );

          if (linkResponse.success) {
            uploadedImages.push({
              id: imageId,
              file: file,
              url: URL.createObjectURL(file),
            });
          } else {
            // Failed to create link for image ID
          }
        } catch (linkError) {
          // Error creating link for image ID
        }
      } else {
        // Upload failed
      }
    } catch (error) {
      // Error uploading image
    }
  }

  return uploadedImages;
};

const validateImageFile = (file) => {
  // Kiểm tra file có tồn tại không
  if (!file) {
    // File is undefined or null
    return false;
  }

  // Kiểm tra xem file có phải là File object không
  if (!(file instanceof File)) {
    console.error("File is not a valid File object:", file);
    return false;
  }

  const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "image/webp"];
  const maxSize = 5 * 1024 * 1024; // 5MB

  if (!file.type || !allowedTypes.includes(file.type)) {
    console.error("Invalid file type:", file.type);
    return false;
  }

  if (!file.size || file.size > maxSize) {
    console.error("File too large:", file.size);
    return false;
  }

  return true;
};

// Hàm refresh toàn bộ dữ liệu (bao gồm tất cả thuộc tính và dữ liệu sản phẩm)
const refreshAllData = async () => {
  if (isRefreshingData.value) {
    console.log("⏳ Refresh already in progress, skipping...");
    return;
  }

  try {
    isRefreshingData.value = true;
    console.log("🔄 Starting full data refresh...");

    // Refresh tất cả thuộc tính song song
    const thuocTinhPromises = [
      fetchMauSac(),
      fetchKichThuoc(),
      fetchDeGiay(),
      fetchChatLieu(),
      fetchTrongLuong(),
      fetchNhaSanXuat(),
      fetchXuatXu(),
      fetchDotGiamGia(),
    ];

    // Refresh dữ liệu sản phẩm và ảnh song song
    const productPromises = [
      fetchSanPham(),
      fetchAnhSanPham(),
      fetchChiTietSanPhamAnh(),
    ];

    // Thực hiện tất cả API calls song song
    await Promise.all([...thuocTinhPromises, ...productPromises]);

    // Refresh chi tiết sản phẩm của sản phẩm hiện tại (nếu có)
    const id = route.params.id ? route.params.id : null;
    if (id) {
      await fetchChiTietSanPham(id);
    } else {
      await fetchChiTietSanPham();
    }

    // Refresh chi tiết đợt giảm giá
    await fetchChiTietDotGiamGia();

    console.log("✅ Full data refresh completed successfully");
  } catch (error) {
    console.error("❌ Error refreshing all data:", error);
  } finally {
    isRefreshingData.value = false;
  }
};

const refreshImageData = async () => {
  if (isRefreshingData.value) {
    console.log("⏳ Refresh already in progress, skipping...");
    return;
  }

  try {
    isRefreshingData.value = true;
    console.log("🔄 Starting data refresh...");

    // Chạy các API calls song song để tăng tốc độ
    const promises = [fetchChiTietSanPhamAnh(), fetchAnhSanPham()];

    // Chỉ thêm fetchChiTietSanPham nếu có currentProduct.id
    if (currentProduct.value?.id) {
      promises.push(fetchChiTietSanPham(currentProduct.value.id));
    }

    await Promise.all(promises);
    console.log("✅ Refresh image data completed successfully");
  } catch (error) {
    console.error("❌ Error refreshing image data:", error);
  } finally {
    isRefreshingData.value = false;
  }
};

// Hàm helper để lấy danh sách ID ảnh hiện tại của chi tiết sản phẩm

// Hàm helper để lọc ra các ID ảnh hợp lệ (chỉ số nguyên, không phải string giả)
const getValidImageIds = (images) => {
  if (!Array.isArray(images)) {
    return [];
  }

  const validImages = images.filter((image) => {
    // Kiểm tra ID có tồn tại và là số nguyên hợp lệ
    const id = image.id;
    const isValid =
      id && typeof id === "number" && Number.isInteger(id) && id > 0;
    return isValid;
  });

  const result = validImages.map((image) => image.id);

  return result;
};

// Hàm đồng bộ hóa selectedImageIds với currentEditingDetail.images
const syncSelectedImageIdsWithCurrentImages = () => {
  if (!currentEditingDetail.value || !currentEditingDetail.value.images) {
    return;
  }

  // Lấy tất cả ID hợp lệ từ currentEditingDetail.images
  const currentImageIds = getValidImageIds(currentEditingDetail.value.images);

  // Cập nhật selectedImageIds để khớp với currentEditingDetail.images
  selectedImageIds.value = [...currentImageIds];
};

// Hàm so sánh trạng thái ảnh ban đầu vs hiện tại
const compareImageStates = () => {
  const currentImageIds = selectedImageIds.value; // Chỉ chứa ID hợp lệ (số nguyên)
  const initialIds = initialImageIds.value; // Chứa tất cả ID ban đầu (bao gồm ID giả)

  // Tìm ảnh bị xóa: có trong ban đầu nhưng không có trong hiện tại
  // Chỉ xét những ID hợp lệ trong ban đầu
  const initialValidIds = initialIds.filter(
    (id) => typeof id === "number" && Number.isInteger(id) && id > 0
  );

  const deletedImageIds = initialValidIds.filter(
    (id) => !currentImageIds.includes(id)
  );

  // Tìm ảnh mới được thêm: có trong hiện tại nhưng không có trong ban đầu
  const addedImageIds = currentImageIds.filter(
    (id) => !initialValidIds.includes(id)
  );

  // Tìm ảnh không thay đổi: có trong cả hai và đều hợp lệ
  const unchangedImageIds = initialValidIds.filter((id) =>
    currentImageIds.includes(id)
  );

  return {
    deletedImageIds,
    addedImageIds,
    unchangedImageIds,
    hasChanges: deletedImageIds.length > 0 || addedImageIds.length > 0,
    initialCount: initialIds.length,
    currentCount: currentImageIds.length,
  };
};

// Hàm xử lý cập nhật trạng thái ảnh đã xóa
const handleDeletedImages = async (chiTietSanPhamId, deletedImageIds) => {
  if (deletedImageIds.length === 0) {
    return;
  }

  try {
    // Tìm các bản ghi ChiTietSanPhamAnh cần cập nhật
    const allChiTietAnhRecords = await fetchAllChiTietSanPhamAnh();
    const recordsToUpdate =
      allChiTietAnhRecords.data?.filter(
        (record) =>
          record.idChiTietSanPham === chiTietSanPhamId &&
          deletedImageIds.includes(record.idAnhSanPham) &&
          !record.deleted
      ) || [];

    if (recordsToUpdate.length === 0) {
      return;
    }

    // Lấy danh sách ID của các bản ghi cần cập nhật
    const recordIdsToUpdate = recordsToUpdate.map((record) => record.id);

    // Sử dụng hàm batch update để cập nhật nhiều bản ghi cùng lúc
    const batchResult = await fetchUpdateStatusMultipleChiTietSanPhamAnh(
      recordIdsToUpdate
    );

    if (batchResult.errorCount > 0) {
      console.warn("⚠️ Một số bản ghi cập nhật thất bại:", batchResult.errors);
    }
  } catch (error) {
    console.error("❌ Lỗi khi cập nhật trạng thái ảnh đã xóa:", error);
    throw error;
  }
};

// Hàm kiểm tra và xử lý ảnh trùng lặp
const checkAndHandleDuplicateImages = async (imageIds) => {
  const uniqueImageIds = [];
  const duplicateImageIds = [];

  for (const imageId of imageIds) {
    // Kiểm tra xem ảnh đã tồn tại trong database chưa
    const existingAnhSanPham = anhSanPhams.value.find(
      (img) => img.id === imageId
    );
    if (existingAnhSanPham) {
      // Ảnh đã tồn tại, không cần tạo mới
      uniqueImageIds.push(imageId);
    } else {
      // Ảnh chưa tồn tại, có thể là ảnh mới từ upload
      uniqueImageIds.push(imageId);
    }
  }

  return {
    uniqueImageIds,
    duplicateImageIds,
  };
};

// Hàm xử lý logic cập nhật ảnh thông minh
const handleSmartImageUpdate = async (chiTietSanPhamId) => {
  try {
    // So sánh trạng thái
    const comparison = compareImageStates();

    // 1. Xử lý ảnh đã xóa
    if (comparison.deletedImageIds.length > 0) {
      await handleDeletedImages(chiTietSanPhamId, comparison.deletedImageIds);
    }

    // 2. Xử lý ảnh mới được thêm (chỉ tạo liên kết cho ảnh thực sự mới)
    if (comparison.addedImageIds.length > 0) {
      // Kiểm tra trùng lặp và chỉ tạo liên kết cho ảnh mới thực sự
      const { uniqueImageIds } = await checkAndHandleDuplicateImages(
        comparison.addedImageIds
      );

      // Chỉ thêm những ảnh mới thực sự (không có liên kết nào trước đó)
      if (uniqueImageIds.length > 0) {
        // Kiểm tra xem ảnh đã có liên kết chưa
        const existingLinks = await fetchAllChiTietSanPhamAnh();
        const existingImageIds =
          existingLinks.data
            ?.filter(
              (link) =>
                link.idChiTietSanPham === chiTietSanPhamId && !link.deleted
            )
            ?.map((link) => link.idAnhSanPham) || [];

        // Chỉ tạo liên kết cho ảnh chưa có liên kết
        const trulyNewImageIds = uniqueImageIds.filter(
          (id) => !existingImageIds.includes(id)
        );

        if (trulyNewImageIds.length > 0) {
          const requestData = {
            idChiTietSanPham: chiTietSanPhamId,
            idAnhSanPhamList: trulyNewImageIds,
            trangThai: true,
            deleted: false,
          };

          const response = await fetchCreateMultipleChiTietSanPhamAnh(
            requestData
          );

          if (!response.success) {
            throw new Error(response.message || "Failed to create image links");
          }
        }
      }
    }

    // 3. Đảm bảo ảnh không thay đổi vẫn có liên kết active
    // (Bỏ qua bước này vì API hiện tại chỉ hỗ trợ deactivate)

    // Refresh dữ liệu ảnh
    await refreshImageData();
    return true;
  } catch (error) {
    console.error("❌ Lỗi trong handleSmartImageUpdate:", error);
    throw error;
  }
};

const handleProductImagesForPopup = async (
  chiTietSanPhamId,
  existingImages,
  newImageFiles
) => {
  try {
    const imageIds = [];

    // Xử lý ảnh có sẵn - chỉ lấy ID hợp lệ (số nguyên)
    if (existingImages && existingImages.length > 0) {
      const validExistingIds = getValidImageIds(existingImages);
      imageIds.push(...validExistingIds);
    }

    // Upload ảnh mới
    if (newImageFiles && newImageFiles.length > 0) {
      // Validate tất cả files trước khi upload
      const validFiles = newImageFiles.filter((file) => {
        if (!file || !file.file) {
          return false;
        }
        return true;
      });

      if (validFiles.length > 0) {
        const uploadedImages = await uploadNewImagesForPopup(
          validFiles,
          chiTietSanPhamId
        );

        for (const uploadedImage of uploadedImages) {
          if (uploadedImage.id) {
            imageIds.push(uploadedImage.id);
          }
        }
      }
    }

    // Cập nhật liên kết ảnh thông minh (xử lý cả thêm và xóa)

    // Cập nhật selectedImageIds để đồng bộ với imageIds cuối cùng
    selectedImageIds.value = [...imageIds];

    if (imageIds.length > 0 || (existingImages && existingImages.length > 0)) {
      await handleSmartImageUpdate(chiTietSanPhamId, selectedImageIds.value);
    } else {
    }

    return imageIds;
  } catch (error) {
    console.error("Error handling product images:", error);
    throw error;
  }
};

// ========================================
// CRUD OPERATIONS
// ========================================

const saveEditPopupFromPopup = async () => {
  if (!currentEditingDetail.value) {
    alert("Không tìm thấy chi tiết sản phẩm để cập nhật!");
    return;
  }

  // Kiểm tra trạng thái upload trước khi lưu
  if (isSaveDisabled.value) {
    const uploadingCount = Object.values(uploadProgress.value).filter(
      (progress) => progress.status === "uploading"
    ).length;

    if (uploadingCount > 0) {
      alert(
        `Vui lòng đợi ${uploadingCount} ảnh đang upload hoàn thành trước khi lưu!`
      );
    } else {
      alert("Vui lòng đợi quá trình upload ảnh hoàn thành trước khi lưu!");
    }
    return;
  }

  try {
    // Lấy thông tin nhà sản xuất và xuất xứ từ chi tiết sản phẩm
    // Tìm dựa trên tên nếu không có id

    const nhaSanXuat =
      nhaSanXuats.value.find(
        (nsx) => nsx.id === currentEditingDetail.value.idNhaSanXuat?.id
      ) ||
      nhaSanXuats.value.find(
        (nsx) => nsx.tenNhaSanXuat === currentEditingDetail.value.tenNhaSanXuat
      );

    const xuatXu =
      xuatXus.value.find(
        (xx) => xx.id === currentEditingDetail.value.idXuatXu?.id
      ) ||
      xuatXus.value.find(
        (xx) => xx.tenXuatXu === currentEditingDetail.value.tenXuatXu
      ) ||
      // Fallback: nếu không tìm thấy, thử tìm tên không dấu
      xuatXus.value.find(
        (xx) =>
          xx.tenXuatXu ===
          currentEditingDetail.value.tenXuatXu
            ?.normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
      ) ||
      // Fallback cuối: chọn xuất xứ đầu tiên có sẵn
      xuatXus.value[0];

    // Tìm thông tin chất liệu dựa trên tên nếu không có id
    const chatLieu =
      chatLieus.value.find(
        (cl) => cl.id === currentEditingDetail.value.idChatLieu?.id
      ) ||
      chatLieus.value.find(
        (cl) => cl.tenChatLieu === currentEditingDetail.value.tenChatLieu
      );

    // Tìm thông tin đế giày dựa trên tên nếu không có id
    const deGiay =
      deGiays.value.find(
        (dg) => dg.id === currentEditingDetail.value.idDeGiay?.id
      ) ||
      deGiays.value.find(
        (dg) => dg.tenDeGiay === currentEditingDetail.value.tenDeGiay
      );

    // Tìm thông tin kích thước dựa trên tên nếu không có id
    const kichThuoc =
      kichThuocs.value.find(
        (kt) => kt.id === currentEditingDetail.value.idKichThuoc?.id
      ) ||
      kichThuocs.value.find(
        (kt) => kt.tenKichThuoc === currentEditingDetail.value.tenKichThuoc
      );

    // Tìm thông tin màu sắc dựa trên tên nếu không có id
    const mauSac =
      mauSacs.value.find(
        (ms) => ms.id === currentEditingDetail.value.idMauSac?.id
      ) ||
      mauSacs.value.find(
        (ms) => ms.tenMauSac === currentEditingDetail.value.tenMauSac
      );

    // Tìm thông tin trọng lượng dựa trên tên nếu không có id
    const trongLuong =
      trongLuongs.value.find(
        (tl) => tl.id === currentEditingDetail.value.idTrongLuong?.id
      ) ||
      trongLuongs.value.find(
        (tl) => tl.tenTrongLuong === currentEditingDetail.value.tenTrongLuong
      );

    // Chuẩn bị dữ liệu sản phẩm với fallback logic
    const sanPhamData = {
      id: currentProduct.value?.id,
      tenSanPham: currentProduct.value?.tenSanPham || "Sản phẩm",
      moTa: currentProduct.value?.moTa || "",
      giaBan: currentProduct.value?.giaBan || 0,
      idNhaSanXuat:
        currentProduct.value?.idNhaSanXuat?.id ||
        currentEditingDetail.value?.idNhaSanXuat?.id ||
        nhaSanXuat?.id ||
        null,
      idXuatXu:
        currentProduct.value?.idXuatXu?.id ||
        currentEditingDetail.value?.idXuatXu?.id ||
        xuatXu?.id ||
        null,
      trangThai: currentProduct.value?.trangThai || 1,
      deleted: currentProduct.value?.deleted || false,
    };

    // Kiểm tra dữ liệu trước khi update
    if (!sanPhamData.idNhaSanXuat) {
      console.error(
        "❌ Thiếu thông tin nhà sản xuất trong sanPhamData:",
        sanPhamData
      );
      alert("Không thể cập nhật sản phẩm: Thiếu thông tin nhà sản xuất!");
      return;
    }

    if (!sanPhamData.idXuatXu) {
      console.error(
        "❌ Thiếu thông tin xuất xứ trong sanPhamData:",
        sanPhamData
      );
      alert("Không thể cập nhật sản phẩm: Thiếu thông tin xuất xứ!");
      return;
    }

    // Kiểm tra chất liệu
    if (!chatLieu?.id) {
      console.error("❌ Thiếu thông tin chất liệu:", chatLieu);
      alert("Không thể cập nhật chi tiết sản phẩm: Thiếu thông tin chất liệu!");
      return;
    }

    // Kiểm tra đế giày
    if (!deGiay?.id) {
      console.error("❌ Thiếu thông tin đế giày:", deGiay);
      alert("Không thể cập nhật chi tiết sản phẩm: Thiếu thông tin đế giày!");
      return;
    }

    // Kiểm tra kích thước
    if (!kichThuoc?.id) {
      console.error("❌ Thiếu thông tin kích thước:", kichThuoc);
      alert(
        "Không thể cập nhật chi tiết sản phẩm: Thiếu thông tin kích thước!"
      );
      return;
    }

    // Kiểm tra màu sắc
    if (!mauSac?.id) {
      console.error("❌ Thiếu thông tin màu sắc:", mauSac);
      alert("Không thể cập nhật chi tiết sản phẩm: Thiếu thông tin màu sắc!");
      return;
    }

    // Kiểm tra trọng lượng
    if (!trongLuong?.id) {
      console.error("❌ Thiếu thông tin trọng lượng:", trongLuong);
      alert(
        "Không thể cập nhật chi tiết sản phẩm: Thiếu thông tin trọng lượng!"
      );
      return;
    }

    // Log trước khi cập nhật
    // Cập nhật sản phẩm - nếu id = null thì tìm id từ tên sản phẩm
    let productIdToUpdate = sanPhamData.id;

    if (!productIdToUpdate) {
      // Tìm ID sản phẩm dựa vào tên sản phẩm
      productIdToUpdate = await findIdByName("sanPham", sanPhamData.tenSanPham);
      console.log(
        `🔍 Tìm thấy ID sản phẩm cho "${sanPhamData.tenSanPham}":`,
        productIdToUpdate
      );

      if (!productIdToUpdate) {
        console.error(
          "❌ Không tìm thấy ID sản phẩm để cập nhật:",
          sanPhamData.tenSanPham
        );
        alert(
          "Không thể cập nhật sản phẩm: Không tìm thấy sản phẩm trong hệ thống!"
        );
        return;
      }
    }

    await fetchUpdateSanPham(productIdToUpdate, sanPhamData);

    // Chuẩn bị dữ liệu chi tiết sản phẩm
    const chiTietSanPhamData = {
      id: currentEditingDetail.value.id,
      idSanPham: productIdToUpdate, // Sử dụng ID đã tìm được
      idMauSac: mauSac?.id || null,
      idKichThuoc: kichThuoc?.id || null,
      idDeGiay: deGiay?.id || null,
      idChatLieu: chatLieu?.id || null,
      idTrongLuong: trongLuong?.id || null,
      giaBan: currentEditingDetail.value.giaBan || 0,
      soLuong: currentEditingDetail.value.soLuong || 0,
      trangThai: currentEditingDetail.value.trangThai || 1,
      deleted: currentEditingDetail.value.deleted || false,
    };

    // Cập nhật chi tiết sản phẩm
    await fetchUpdateChiTietSanPham(chiTietSanPhamData.id, chiTietSanPhamData);

    if (
      currentEditingDetail.value.images &&
      currentEditingDetail.value.images.length > 0
    ) {
      // Lọc ảnh có sẵn (có id và duongDanAnh) và ảnh mới (có file)
      const existingImages = currentEditingDetail.value.images.filter(
        (img) => img.id && img.duongDanAnh && !img.file
      );
      const newImageFiles = currentEditingDetail.value.images.filter(
        (img) => img.file
      );

      await handleProductImagesForPopup(
        currentEditingDetail.value.id,
        existingImages,
        newImageFiles
      );
    } // <-- Added this closing brace for the images if

    // Xử lý đợt giảm giá
    if (currentEditingDetail.value.idDotGiamGia) {
      const dotGiamGia = dotGiamGias.value.find(
        (dg) => dg.id === currentEditingDetail.value.idDotGiamGia
      );

      if (dotGiamGia) {
        // Tìm chi tiết đợt giảm giá

        const chiTietDotGiamGia = chiTietDotGiamGias.value.find(
          (chiTietDotGiamGia) =>
            chiTietDotGiamGia.idChiTietSanPham ===
              currentEditingDetail.value.id &&
            chiTietDotGiamGia.idDotGiamGia ===
              currentEditingDetail.value.idDotGiamGia
        );

        // Nếu không tìm thấy, thử tìm chỉ với idChiTietSanPham
        let fallbackChiTietDotGiamGia = null;
        if (!chiTietDotGiamGia) {
          fallbackChiTietDotGiamGia = chiTietDotGiamGias.value.find(
            (item) => item.idChiTietSanPham === currentEditingDetail.value.id
          );
        }

        // Sử dụng fallback nếu cần
        const finalChiTietDotGiamGia =
          chiTietDotGiamGia || fallbackChiTietDotGiamGia;

        // Chỉ kiểm tra chiTietDotGiamGia nếu có đợt giảm giá
        if (finalChiTietDotGiamGia) {
          const dotGiamGiaData = {
            id: finalChiTietDotGiamGia.id,
            idDotGiamGia: dotGiamGia.id,
            idChiTietSanPham: currentEditingDetail.value.id,
            trangThai: finalChiTietDotGiamGia.trangThai || 1,
            deleted: finalChiTietDotGiamGia.deleted || false,
            createdAt:
              finalChiTietDotGiamGia.createdAt || new Date().toISOString(),
            updatedAt: new Date().toISOString(),
          };

          // Chỉ cập nhật dotGiamGia nếu có dữ liệu
          if (dotGiamGiaData) {
            await fetchUpdateChiTietDotGiamGia(
              dotGiamGiaData.id,
              dotGiamGiaData
            );
          }
        }
      }
    }

    // Refresh dữ liệu - chỉ lấy chi tiết sản phẩm của sản phẩm hiện tại
    await refreshImageData();

    // Reset trạng thái ban đầu sau khi edit thành công
    initialImageIds.value = [];
    initialImages.value = [];

    // Hiển thị popup thông báo thành công bên phải
    showNotificationPopup("success", "Thành công", "Cập nhật chi tiết sản phẩm thành công!");

    // Đóng popup
    closeEditPopup();
  } catch (error) {
    console.error(
      "❌ LỖI: Có lỗi xảy ra khi cập nhật chi tiết sản phẩm:",
      error
    );
    console.error("🔍 Chi tiết lỗi:", error.message);
    console.error("📊 Stack trace:", error.stack);
    alert("Có lỗi xảy ra khi cập nhật: " + error.message);
  }
};
const saveAllCheckedChiTietSanPhamsFromPopup = async () => {
  try {
    // Kiểm tra xem có item nào được chọn không
    if (
      !selectedChiTietSanPhams.value ||
      selectedChiTietSanPhams.value.length === 0
    ) {
      showNotificationPopup("error", "Cảnh báo", "Vui lòng chọn ít nhất một chi tiết sản phẩm để cập nhật!");
      return;
    }

    // Hiển thị popup confirm
    const confirmDialog = document.createElement("div");
    confirmDialog.className = "custom-confirm-dialog";
    confirmDialog.style.cssText = `
      position: fixed !important;
      top: 0 !important;
      left: 0 !important;
      width: 100vw !important;
      height: 100vh !important;
      z-index: 999999 !important;
      display: flex !important;
      justify-content: center !important;
      align-items: center !important;
    `;

    confirmDialog.innerHTML = `
            <div class="confirm-content" style="
              position: relative !important;
              z-index: 1000000 !important;
              transform: translateZ(0) !important;
              will-change: transform !important;
              background: linear-gradient(135deg, #ffffff, #ffffff);
              padding: 2.5rem;
              border-radius: 20px;
              // box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.1);
              text-align: center;
              max-width: 450px;
              width: 90%;
              border: 1px solid rgba(255, 255, 255, 0.2);
            ">
                <h3>Xác nhận cập nhật</h3>
                <p>Bạn có chắc chắn muốn cập nhật ${selectedChiTietSanPhams.value.length} chi tiết sản phẩm đã chọn?</p>
                <div class="confirm-buttons">
                    <button class="btn btn-secondary" id="cancelUpdate">Hủy</button>
                    <button class="btn btn-primary" id="confirmUpdate">Xác nhận</button>
                </div>
            </div>
        `;

    // Đảm bảo popup được append vào body và hiển thị đúng vị trí
    document.body.appendChild(confirmDialog);

    // Force reflow để đảm bảo styles được áp dụng
    confirmDialog.offsetHeight;

    // Xử lý sự kiện confirm
    return new Promise((resolve) => {
      document
        .getElementById("confirmUpdate")
        .addEventListener("click", async () => {
          document.body.removeChild(confirmDialog);

          try {
            // Bước 1: Chuẩn bị dữ liệu cho tất cả các item đã chọn
            const updatePromises = [];
            const itemsToUpdate = [];

            for (const selectedId of selectedChiTietSanPhams.value) {
              // Tìm item trong editingChiTietSanPhams (sử dụng Map.get)
              const editingItem = editingChiTietSanPhams.value.get(selectedId);
              const originalItem =
                originalChiTietSanPhams.value.get(selectedId);
              if (editingItem && originalItem) {
                // Tìm ID từ tên các thuộc tính
                const idSanPham = await findIdByName(
                  "sanPham",
                  originalItem.tenSanPham
                );
                const idMauSac = await findIdByName(
                  "mauSac",
                  originalItem.tenMauSac
                );
                const idKichThuoc = await findIdByName(
                  "kichThuoc",
                  originalItem.tenKichThuoc
                );
                const idDeGiay = await findIdByName(
                  "deGiay",
                  originalItem.tenDeGiay
                );
                const idChatLieu = await findIdByName(
                  "chatLieu",
                  originalItem.tenChatLieu
                );
                const idTrongLuong = await findIdByName(
                  "trongLuong",
                  originalItem.tenTrongLuong
                );

                // Chỉ cập nhật 3 trường: soLuong, giaBan, trangThai
                // Các trường khác giữ nguyên từ dữ liệu gốc
                const updatedData = {
                  idSanPham: idSanPham,
                  idMauSac: idMauSac,
                  idKichThuoc: idKichThuoc,
                  idDeGiay: idDeGiay,
                  idChatLieu: idChatLieu,
                  idTrongLuong: idTrongLuong,
                  soLuong: editingItem.soLuong || originalItem.soLuong || 0,
                  giaBan: editingItem.giaBan || originalItem.giaBan || 0,
                  trangThai:
                    editingItem.trangThai !== undefined
                      ? editingItem.trangThai
                      : originalItem.trangThai !== undefined
                      ? originalItem.trangThai
                      : true,
                  ghiChu: originalItem.ghiChu || "",
                  deleted:
                    originalItem.deleted !== undefined
                      ? originalItem.deleted
                      : false,
                  createdAt: originalItem.createdAt || new Date(),
                  createBy: originalItem.createBy || 1,
                  updatedAt: new Date(),
                  updateBy: 1,
                };

                // Xử lý ảnh sản phẩm nếu có
                if (
                  editingItem.chiTietSanPhamAnhs &&
                  editingItem.chiTietSanPhamAnhs.length > 0
                ) {
                  try {
                    await handleProductImagesForInline(editingItem);
                  } catch (imageError) {
                    console.error(
                      `Lỗi xử lý ảnh cho item ${selectedId}:`,
                      imageError
                    );
                  }
                }

                itemsToUpdate.push({
                  id: selectedId,
                  data: updatedData,
                });

                // Tạo promise cập nhật
                updatePromises.push(
                  fetchUpdateChiTietSanPham(selectedId, updatedData)
                    .then((response) => {
                      return { id: selectedId, success: true, response };
                    })
                    .catch((error) => {
                      console.error(
                        `<!-- icon: close --> Lỗi cập nhật item ${selectedId}:`,
                        error
                      );
                      return { id: selectedId, success: false, error };
                    })
                );
              }
            }

            if (itemsToUpdate.length === 0) {
              showNotificationPopup("error", "Cảnh báo", "Không có dữ liệu nào để cập nhật!");
              resolve();
              return;
            }

            // Bước 2: Thực hiện cập nhật tất cả items
            const results = await Promise.all(updatePromises);

            // Bước 3: Xử lý kết quả
            const successfulUpdates = results.filter(
              (result) => result.success
            );
            const failedUpdates = results.filter((result) => !result.success);

            if (failedUpdates.length > 0) {
              showNotificationPopup(
                successfulUpdates.length === itemsToUpdate.length ? "success" : "error",
                "Kết quả cập nhật",
                `Cập nhật ${successfulUpdates.length}/${itemsToUpdate.length} items thành công. ${failedUpdates.length} items thất bại.`
              );
            } else {
              showNotificationPopup("success", "Thành công", `Cập nhật thành công ${successfulUpdates.length} chi tiết sản phẩm!`);
            }

            // Bước 4: Refresh dữ liệu và reset trạng thái
            await refreshImageData();
            refreshAllData();
            // Reset các trạng thái
            editingChiTietSanPhams.value.clear();
            originalChiTietSanPhams.value.clear();
            selectedChiTietSanPhams.value = [];

            // Thoát khỏi edit mode
            isEditing.value = false;
          } catch (error) {
            console.error(
              "<!-- icon: close --> Lỗi trong quá trình cập nhật hàng loạt:",
              error
            );
            showNotificationPopup("error", "Lỗi", "Có lỗi xảy ra trong quá trình cập nhật!");
          }

          resolve();
        });

      document.getElementById("cancelUpdate").addEventListener("click", () => {
        document.body.removeChild(confirmDialog);
        resolve();
      });
    });
  } catch (error) {
    console.error(
      "<!-- icon: close --> Lỗi trong saveAllCheckedChiTietSanPhamsFromPopup:",
      error
    );
    showNotificationPopup("error", "Lỗi", "Có lỗi xảy ra!");
  }
};

// ========================================
// UI HELPER FUNCTIONS
// ========================================

// Function cũ - không còn sử dụng, thay bằng popup thông báo bên phải
// const showSuccessPopupForEdit = (message) => {
//   successMessage.value = message;
//   showSuccessPopup.value = true;

//   setTimeout(() => {
//     showSuccessPopup.value = false;
//   }, 3000);
// };

const getCheckedCountForEdit = () => {
  return chiTietSanPhams.value.filter((chiTiet) => chiTiet.checked).length;
};

const getTotalCountForEdit = () => {
  return chiTietSanPhams.value.length;
};

// ========================================
// IMAGE UI FUNCTIONS
// ========================================

const handleImageSelectionForEdit = (event) => {
  const selectedFiles = Array.from(event.target.files);

  if (currentEditingDetailImagesCount.value + selectedFiles.length > 5) {
    alert("Chỉ được chọn tối đa 5 ảnh!");
    return;
  }

  selectedFiles.forEach((file) => {
    if (validateImageFile(file)) {
      const newImage = {
        id: null,
        file: file,
        url: URL.createObjectURL(file),
        isNew: true,
      };

      if (currentEditingDetail.value) {
        if (!currentEditingDetail.value.images) {
          currentEditingDetail.value.images = [];
        }
        currentEditingDetail.value.images.push(newImage);
      }
    }
  });

  event.target.value = "";
};

const handleImageUploadForEdit = (event) => {
  const uploadedFiles = Array.from(event.target.files);

  if (currentEditingDetailImagesCount.value + uploadedFiles.length > 5) {
    alert("Chỉ được upload tối đa 5 ảnh!");
    return;
  }

  uploadedFiles.forEach((file) => {
    if (validateImageFile(file)) {
      const newImage = {
        id: null,
        file: file,
        url: URL.createObjectURL(file),
        isNew: true,
      };

      if (currentEditingDetail.value) {
        if (!currentEditingDetail.value.images) {
          currentEditingDetail.value.images = [];
        }
        currentEditingDetail.value.images.push(newImage);
      }
    }
  });

  event.target.value = "";
};

// ========================================
// EVENT HANDLERS
// ========================================

// ========================================
// UTILITY FUNCTIONS
// ========================================

const formatCurrency = (amount) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(amount);
};

const route = useRoute();

const filteredDetails = computed(() => {
  const filtered = chiTietSanPhams.value.filter((detail) => {
    const matchesSearch =
      !searchQuery.value ||
      (detail.tenSanPham || detail.sanPham?.tenSanPham || "")
        ?.toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      (detail.tenMauSac || detail.mauSac?.tenMauSac || "")
        ?.toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      (detail.tenKichThuoc || detail.kichThuoc?.tenKichThuoc || "")
        ?.toLowerCase()
        .includes(searchQuery.value.toLowerCase());

    // Sử dụng logic tìm kiếm dựa trên tên thay vì ID để nhất quán với hiển thị
    const matchesProduct =
      !selectedSanPham.value ||
      detail.tenSanPham ===
        sanPhams.value.find((p) => p.id === selectedSanPham.value)
          ?.tenSanPham ||
      detail.sanPham?.tenSanPham ===
        sanPhams.value.find((p) => p.id === selectedSanPham.value)?.tenSanPham;

    const matchesColor =
      !selectedMauSac.value ||
      detail.tenMauSac ===
        mauSacs.value.find((m) => m.id === selectedMauSac.value)?.tenMauSac ||
      detail.mauSac?.tenMauSac ===
        mauSacs.value.find((m) => m.id === selectedMauSac.value)?.tenMauSac;

    const matchesSize =
      !selectedKichThuoc.value ||
      detail.tenKichThuoc ===
        kichThuocs.value.find((k) => k.id === selectedKichThuoc.value)
          ?.tenKichThuoc ||
      detail.kichThuoc?.tenKichThuoc ===
        kichThuocs.value.find((k) => k.id === selectedKichThuoc.value)
          ?.tenKichThuoc;

    const matchesChatLieu =
      !selectedChatLieu.value ||
      detail.tenChatLieu ===
        chatLieus.value.find((c) => c.id === selectedChatLieu.value)
          ?.tenChatLieu ||
      detail.chatLieu?.tenChatLieu ===
        chatLieus.value.find((c) => c.id === selectedChatLieu.value)
          ?.tenChatLieu;

    const matchesDeGiay =
      !selectedDeGiay.value ||
      detail.tenDeGiay ===
        deGiays.value.find((d) => d.id === selectedDeGiay.value)?.tenDeGiay ||
      detail.deGiay?.tenDeGiay ===
        deGiays.value.find((d) => d.id === selectedDeGiay.value)?.tenDeGiay;

    const matchesTrongLuong =
      !selectedTrongLuong.value ||
      detail.tenTrongLuong ===
        trongLuongs.value.find((t) => t.id === selectedTrongLuong.value)
          ?.tenTrongLuong ||
      detail.trongLuong?.tenTrongLuong ===
        trongLuongs.value.find((t) => t.id === selectedTrongLuong.value)
          ?.tenTrongLuong;

    const matchesStatus =
      statusFilter.value === "" || detail.trangThai == statusFilter.value;

    const result =
      matchesSearch &&
      matchesProduct &&
      matchesColor &&
      matchesSize &&
      matchesChatLieu &&
      matchesDeGiay &&
      matchesTrongLuong &&
      matchesStatus;

    return result;
  });

  return filtered;
});

const totalPages = computed(() =>
  Math.ceil(filteredDetails.value.length / pageSize.value)
);
const startIndex = computed(() => (currentPage.value - 1) * pageSize.value);
const endIndex = computed(() =>
  Math.min(startIndex.value + pageSize.value, filteredDetails.value.length)
);

const paginatedDetails = computed(() => {
  const paginated = filteredDetails.value.slice(
    startIndex.value,
    startIndex.value + pageSize.value
  );
  return paginated;
});

// Checkbox selection computed
const hasCheckedChiTietSanPhams = computed(() => {
  return selectedChiTietSanPhams.value.length > 0;
});

const checkedChiTietSanPhamsCount = computed(() => {
  return selectedChiTietSanPhams.value.length;
});

const isAllSelected = computed(() => {
  return (
    paginatedDetails.value.length > 0 &&
    paginatedDetails.value.every((detail) =>
      selectedChiTietSanPhams.value.includes(detail.id)
    )
  );
});

const isIndeterminate = computed(() => {
  const selectedCount = paginatedDetails.value.filter((detail) =>
    selectedChiTietSanPhams.value.includes(detail.id)
  ).length;
  return selectedCount > 0 && selectedCount < paginatedDetails.value.length;
});

// Computed để lấy thông tin sản phẩm hiện tại
const currentProductName = computed(() => {
  return currentProduct.value?.tenSanPham || null;
});

// Ref để theo dõi thay đổi dữ liệu ảnh và đảm bảo table re-render
const imageDataKey = ref({
  chiTietSanPhamAnhsLength: 0,
  anhSanPhamsLength: 0,
  chiTietSanPhamsLength: 0,
  timestamp: Date.now(),
});

// Methods

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

const clearFiltersForEdit = () => {
  searchQuery.value = "";
  selectedSanPham.value = "";
  selectedMauSac.value = "";
  selectedKichThuoc.value = "";
  selectedChatLieu.value = "";
  selectedDeGiay.value = "";
  selectedTrongLuong.value = "";
  selectedDotGiamGia.value = "";
  statusFilter.value = "";
  currentPage.value = 1;
};

const previousPageForEdit = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const nextPageForEdit = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

// Hàm xử lý ảnh cho edit
const openImageSelectorForEdit = async () => {
  try {
    // Đảm bảo dữ liệu ảnh đã được load
    if (!anhSanPhams.value || anhSanPhams.value.length === 0) {
      await fetchAnhSanPham();
    }

    if (!chiTietSanPhamAnhs.value || chiTietSanPhamAnhs.value.length === 0) {
      await fetchChiTietSanPhamAnh();
    }

    // Lấy ảnh hiện tại từ currentEditingDetail (đã được chỉnh sửa)
    // thay vì từ database để phản ánh những thay đổi chưa lưu
    const currentImages = currentEditingDetail.value.images || [];
    selectedImagesForEdit.value = [...currentImages];

    // Cập nhật selectedImageIds để khớp với currentImages
    selectedImageIds.value = getValidImageIds(currentImages);

    // Lọc ra những ảnh chưa được sử dụng hoặc chưa bị xóa
    availableImagesForEdit.value = anhSanPhams.value.filter(
      (img) =>
        !img.deleted &&
        img.duongDanAnh &&
        !selectedImageIds.value.includes(img.id)
    );

    showImageSelectorForEdit.value = true;
  } catch (error) {
    alert("Có lỗi khi mở image selector: " + error.message);
  }
};

const closeImageSelectorForEdit = () => {
  showImageSelectorForEdit.value = false;
};

const toggleImageSelectionForEdit = (image) => {
  const index = selectedImagesForEdit.value.findIndex(
    (img) => img.id === image.id
  );

  if (index > -1) {
    // Bỏ chọn ảnh
    selectedImagesForEdit.value.splice(index, 1);
  } else {
    // Chọn ảnh mới (kiểm tra giới hạn 5 ảnh)
    if (selectedImagesForEdit.value.length < 5) {
      selectedImagesForEdit.value.push(image);
    } else {
      alert("Chỉ được chọn tối đa 5 ảnh!");
    }
  }
};

const isImageSelectedForEdit = (imageId) => {
  return selectedImagesForEdit.value.some((img) => img.id === imageId);
};

const removeSelectedImageForEditPopup = (index) => {
  selectedImagesForEdit.value.splice(index, 1);
};

const confirmImageSelectionForEditPopup = () => {
  // Cập nhật ảnh trong currentEditingDetail
  currentEditingDetail.value.images = [...selectedImagesForEdit.value];
  closeImageSelectorForEdit();
};

// Hàm xử lý file upload
const triggerFileUploadForEdit = () => {
  fileInput.value?.click();
};

const handleFileUploadForEdit = async (event) => {
  const files = event.target.files;
  if (!files || files.length === 0) return;

  // Kiểm tra số lượng ảnh hiện tại
  const currentImageCount = currentEditingDetail.value.images?.length || 0;
  const remainingSlots = 5 - currentImageCount;

  if (remainingSlots <= 0) {
    alert("Đã đủ 5 ảnh, không thể thêm ảnh mới!");
    return;
  }

  // Giới hạn số lượng file có thể upload
  const filesToProcess = Array.from(files).slice(0, remainingSlots);

  // Set loading state
  isUploadingImages.value = true;

  for (const file of filesToProcess) {
    try {
      // Validate file trước khi xử lý
      validateImageFileForInline(file);

      // Tạo URL preview ngay lập tức để hiển thị
      const imageUrl = URL.createObjectURL(file);

      // Tạo object ảnh tạm thời để hiển thị ngay
      const tempImage = {
        duongDanAnh: file.name,
        loaiAnh: "product",
        url: imageUrl,
        isNew: true, // Đánh dấu là ảnh mới
        file: file,
      };

      // Thêm vào danh sách ảnh hiện tại ngay lập tức để hiển thị
      if (!currentEditingDetail.value.images) {
        currentEditingDetail.value.images = [];
      }
      currentEditingDetail.value.images.push(tempImage);

      // Upload ảnh lên server với timeout và retry
      const formData = new FormData();
      formData.append("file", file);
      formData.append("loaiAnh", file.name.split(".").pop());
      const uploadResponse = await uploadImageWithRetry(formData, file.name);

      if (
        uploadResponse &&
        uploadResponse.message &&
        uploadResponse.message.includes("thành công")
      ) {
        // Backend trả về list ID (multiple images)
        let imageIds = [];
        if (
          uploadResponse.data &&
          Array.isArray(uploadResponse.data) &&
          uploadResponse.data.length > 0
        ) {
          imageIds = uploadResponse.data;
        } else {
          // Fallback: tạo temp ID nếu không có ID thực
          console.warn("⚠️ Backend không trả về ID, tạo temp ID");
        }

        // Sử dụng ID đầu tiên cho ảnh này
        const imageId = imageIds[0];

        // Tự động tạo liên kết trong ChiTietSanPhamAnh
        try {
          // Chỉ gửi ID thực (số nguyên), loại bỏ temp ID string
          const realImageIds = imageIds.filter(
            (id) =>
              typeof id === "number" ||
              (typeof id === "string" && !id.startsWith("temp_"))
          );

          if (realImageIds.length === 0) {
            console.warn(
              "⚠️ Không có ID thực để tạo liên kết, bỏ qua bước này"
            );
            // Vẫn cập nhật UI để hiển thị ảnh đã upload
            if (
              currentEditingDetail.value.images &&
              Array.isArray(currentEditingDetail.value.images)
            ) {
              const imageIndex = currentEditingDetail.value.images.findIndex(
                (img) => img.id === tempImage.id
              );
              if (imageIndex !== -1) {
                currentEditingDetail.value.images[imageIndex] = {
                  ...tempImage,
                  id: imageIds[0], // Dùng ID đầu tiên (có thể là temp)
                  isNew: false,
                };
              }
            }
            return;
          }

          const linkData = {
            idChiTietSanPham: currentEditingDetail.value.id,
            idAnhSanPhamList: realImageIds, // Chỉ gửi ID thực
            trangThai: true,
            deleted: false,
            createAt: new Date().toISOString().split("T")[0],
          };

          const linkResponse = await fetchCreateMultipleChiTietSanPhamAnh(
            linkData
          );

          if (linkResponse.success) {
            // Cập nhật ảnh tạm thành ảnh thật
            if (
              currentEditingDetail.value.images &&
              Array.isArray(currentEditingDetail.value.images)
            ) {
              const imageIndex = currentEditingDetail.value.images.findIndex(
                (img) => img.id === tempImage.id
              );
              if (imageIndex !== -1) {
                currentEditingDetail.value.images[imageIndex] = {
                  ...tempImage,
                  id: imageId,
                  isNew: false, // Không phải ảnh tạm nữa
                };

                // Thêm ID thực vào selectedImageIds
                if (!selectedImageIds.value.includes(imageId)) {
                  selectedImageIds.value.push(imageId);
                }
              }
            }
          } else {
            console.error(
              "Failed to create link in edit popup for image ID:",
              imageId
            );
            // Nếu tạo link thất bại, xóa ảnh tạm
            if (
              currentEditingDetail.value.images &&
              Array.isArray(currentEditingDetail.value.images)
            ) {
              const imageIndex = currentEditingDetail.value.images.findIndex(
                (img) => img.id === tempImage.id
              );
              if (imageIndex !== -1) {
                currentEditingDetail.value.images.splice(imageIndex, 1);
              }
            }
            URL.revokeObjectURL(imageUrl);
          }
        } catch (linkError) {
          console.error(
            "Error creating link in edit popup for image ID:",
            imageId,
            linkError
          );
          // Nếu có lỗi, xóa ảnh tạm
          if (
            currentEditingDetail.value.images &&
            Array.isArray(currentEditingDetail.value.images)
          ) {
            const imageIndex = currentEditingDetail.value.images.findIndex(
              (img) => img.id === tempImage.id
            );
            if (imageIndex !== -1) {
              currentEditingDetail.value.images.splice(imageIndex, 1);
            }
          }
          URL.revokeObjectURL(imageUrl);
        }
      } else {
        console.error(
          "Upload failed in edit popup - response:",
          uploadResponse
        );
        // Nếu upload thất bại, xóa ảnh tạm
        if (
          currentEditingDetail.value.images &&
          Array.isArray(currentEditingDetail.value.images)
        ) {
          const imageIndex = currentEditingDetail.value.images.findIndex(
            (img) => img.id === tempImage.id
          );
          if (imageIndex !== -1) {
            currentEditingDetail.value.images.splice(imageIndex, 1);
          }
        }
        URL.revokeObjectURL(imageUrl);
      }
    } catch (error) {
      console.error("Error processing file in edit popup:", error);
      handleImageUploadErrorForInline(error, file.name);
    }
  }

  // Cleanup loading state
  isUploadingImages.value = false;

  // Clear upload progress after 5 seconds if all successful
  const allSuccessful = Object.values(uploadProgress.value).every(
    (p) => p.status === "success"
  );
  if (allSuccessful && Object.keys(uploadProgress.value).length > 0) {
    setTimeout(() => {
      uploadProgress.value = {};
    }, 5000);
  }

  // Reset input file
  event.target.value = "";
};

// Hàm xóa ảnh (cả ảnh có sẵn và ảnh mới upload)
const removeImageFromPopup = async (index) => {
  if (currentEditingDetail.value.images) {
    const imageToRemove = currentEditingDetail.value.images[index];

    // Nếu là ảnh mới upload, giải phóng URL object
    if (imageToRemove.isNew && imageToRemove.url) {
      URL.revokeObjectURL(imageToRemove.url);
    }

    // Update status deleted cho bản ghi ChiTietSanPhamAnh nếu ảnh đã tồn tại trong database
    if (imageToRemove.id && !imageToRemove.isNew) {
      try {
        // Tìm bản ghi ChiTietSanPhamAnh tương ứng
        const allChiTietAnhRecords = await fetchAllChiTietSanPhamAnh();

        if (
          !allChiTietAnhRecords.data ||
          !Array.isArray(allChiTietAnhRecords.data)
        ) {
          console.error("❌ Không thể lấy danh sách ChiTietSanPhamAnh");
          return;
        }

        const recordToDelete = allChiTietAnhRecords.data.find(
          (record) =>
            record.idChiTietSanPham == currentEditingDetail.value.id &&
            record.idAnhSanPham == imageToRemove.id &&
            !record.deleted
        );

        if (recordToDelete) {
          // Update status deleted = true
          const updateResult = await fetchUpdateStatusChiTietSanPhamAnh(
            recordToDelete.id
          );

          // Refresh dữ liệu để cập nhật UI
          await fetchChiTietSanPhamAnh();

          // Force Vue re-render để cập nhật UI ngay lập tức
          imageDataKey.value = {
            chiTietSanPhamAnhsLength: chiTietSanPhamAnhs.value?.length || 0,
            anhSanPhamsLength: anhSanPhams.value?.length || 0,
            chiTietSanPhamsLength: chiTietSanPhams.value?.length || 0,
            timestamp: Date.now(),
          };
        }
      } catch (error) {
        console.error("❌ Lỗi khi cập nhật status deleted:", error);
        // Vẫn tiếp tục xóa ảnh khỏi UI dù có lỗi API
      }
    }

    // Xóa ID ảnh khỏi selectedImageIds nếu tồn tại
    if (imageToRemove.id) {
      const idIndex = selectedImageIds.value.indexOf(imageToRemove.id);
      if (idIndex > -1) {
        selectedImageIds.value.splice(idIndex, 1);
        // Cũng xóa khỏi selectedImages để đồng bộ
        if (selectedImages.value && selectedImages.value[idIndex]) {
          selectedImages.value.splice(idIndex, 1);
        }
      }
    }

    // Xóa ảnh khỏi danh sách hiển thị
    currentEditingDetail.value.images.splice(index, 1);

    // Đồng bộ hóa selectedImageIds với currentEditingDetail.images
    syncSelectedImageIdsWithCurrentImages();

    // Cập nhật initialImages để phản ánh thay đổi
    if (initialImages.value && initialImages.value.length > 0) {
      const imageIndex = initialImages.value.findIndex(
        (img) => img.id === imageToRemove.id
      );
      if (imageIndex > -1) {
        initialImages.value.splice(imageIndex, 1);
      }
    }
  }
};

// Hàm xóa ảnh sản phẩm hoàn chỉnh (bao gồm cả server)

// Hàm xóa trạng thái upload progress
const clearUploadProgress = () => {
  uploadProgress.value = {};
};

// Method để lấy ảnh cho một chi tiết sản phẩm
const getImagesForChiTietSanPhamForEdit = (chiTietSanPhamId) => {
  try {
    // Đảm bảo dữ liệu đã được load
    if (!chiTietSanPhams.value) {
      return [];
    }

    // Tìm chi tiết sản phẩm trong danh sách đã fetch
    const chiTietSanPham = chiTietSanPhams.value.find(
      (item) => item.id === chiTietSanPhamId
    );

    if (!chiTietSanPham) {
      return [];
    }

    // Backend đã filter anhSanPham theo trangThai=true & deleted=false, sử dụng trực tiếp
    if (chiTietSanPham.anhSanPham && Array.isArray(chiTietSanPham.anhSanPham)) {
      // Sử dụng trực tiếp anhSanPham từ backend (đã được filter)
      const images = chiTietSanPham.anhSanPham.map((duongDanAnh, index) => {
        // Tìm ảnh trong anhSanPhams dựa trên duongDanAnh
        let realId = null;
        let anhSanPhamData = null;

        if (anhSanPhams.value && Array.isArray(anhSanPhams.value)) {
          anhSanPhamData = anhSanPhams.value.find(
            (anh) => anh.duongDanAnh === duongDanAnh
          );
          if (anhSanPhamData && anhSanPhamData.id) {
            realId = anhSanPhamData.id;
          }
        }

        // Nếu không tìm thấy ID thực, tạo ID giả
        if (!realId) {
          realId = `direct_${chiTietSanPhamId}_${index}`;
        }

        return {
          id: realId,
          duongDanAnh: duongDanAnh,
          loaiAnh: anhSanPhamData ? anhSanPhamData.loaiAnh : "product",
          moTa: anhSanPhamData
            ? anhSanPhamData.moTa
            : `Ảnh ${index + 1} của chi tiết sản phẩm ${chiTietSanPhamId}`,
          file: null,
          url: null,
          isNew: false,
        };
      });

      return images;
    }
    if (!chiTietSanPhamAnhs.value || !anhSanPhams.value) {
      return [];
    }

    // Lọc các liên kết ảnh active cho chi tiết sản phẩm này (theo backend logic)
    const imageLinks = chiTietSanPhamAnhs.value.filter(
      (item) =>
        item.idChiTietSanPham === chiTietSanPhamId &&
        item.trangThai === true &&
        item.deleted === false
    );

    // Map để lấy thông tin ảnh đầy đủ
    const images = imageLinks
      .map((item) => {
        const anhSanPham = anhSanPhams.value.find(
          (anh) => anh.id === item.idAnhSanPham
        );

        if (anhSanPham && anhSanPham.duongDanAnh) {
          return {
            id: anhSanPham.id,
            duongDanAnh: anhSanPham.duongDanAnh,
            loaiAnh: anhSanPham.loaiAnh,
            moTa: anhSanPham.moTa,
            file: null,
            url: null,
            isNew: false,
          };
        }
        return null;
      })
      .filter((img) => img !== null);

    return images;
  } catch (error) {
    console.error("Error getting images for chi tiet san pham:", error);
    return [];
  }
};

// Method để tạo URL đầy đủ cho ảnh
const getImageUrlForEdit = (imagePath) => {
  try {
    if (!imagePath) {
      return "";
    }

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
  } catch (error) {
    console.error("Error getting image URL:", error);
    return "";
  }
};

// Method để lấy URL hiển thị ảnh trong form edit (ưu tiên url trước, sau đó mới đến duongDanAnh)
const getImageDisplayUrl = (image) => {
  try {
    if (!image) {
      return "";
    }

    // Ưu tiên url (object URL) trước - dành cho ảnh mới upload
    if (image.url) {
      return image.url;
    }

    // Nếu không có url thì dùng duongDanAnh (ảnh có sẵn)
    if (image.duongDanAnh) {
      return getImageUrlForEdit(image.duongDanAnh);
    }

    return "";
  } catch (error) {
    console.error("Error getting image display URL:", error);
    return "";
  }
};

// Method để force refresh dữ liệu ảnh

// Hàm xử lý upload ảnh mới lên server
const uploadNewImagesForInline = async (imageFiles) => {
  try {
    const uploadPromises = imageFiles.map(async (file) => {
      const formData = new FormData();
      formData.append("file", file);
      formData.append("loaiAnh", "product");
      formData.append("moTa", file.name || "Ảnh sản phẩm");

      const response = await fetchCreateAnhSanPhamFromCloud(formData);

      // Đảm bảo trả về đúng ID từ response
      if (
        response &&
        response.message &&
        response.message.includes("thành công")
      ) {
        // Backend trả về list ID (multiple images)
        let imageId;
        if (
          response.data &&
          Array.isArray(response.data) &&
          response.data.length > 0
        ) {
          imageId = response.data[0]; // Sử dụng ID đầu tiên
        } else {
          // Fallback: tạo temp ID nếu không có ID thực
          console.warn("⚠️ Backend không trả về ID, tạo temp ID");
          imageId = `temp_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
        }

        return { id: imageId, file: file };
      } else {
        throw new Error(
          `Không nhận được ID ảnh từ server: ${JSON.stringify(response)}`
        );
      }
    });

    const uploadedImages = await Promise.all(uploadPromises);
    return uploadedImages;
  } catch (error) {
    console.error("Error uploading new images:", error);
    throw new Error("Không thể upload ảnh mới lên server");
  }
};

// Hàm xử lý cập nhật ảnh sản phẩm

// Hàm xử lý xóa ảnh sản phẩm (soft delete)

// Hàm xử lý ảnh sản phẩm hoàn chỉnh sử dụng API mới
const handleProductImagesForInline = async (
  chiTietSanPhamId,
  currentImages,
  newImageFiles
) => {
  try {
    // 1. Upload ảnh mới lên server
    let uploadedImageIds = [];
    if (newImageFiles && newImageFiles.length > 0) {
      const uploadedImages = await uploadNewImagesForInline(newImageFiles);
      uploadedImageIds = uploadedImages.map((img) => img.id);
    }

    // 2. Lấy danh sách ID ảnh cuối cùng (ảnh có sẵn + ảnh mới upload)
    // Lọc ra chỉ ảnh có sẵn với ID hợp lệ (không phải ID giả)
    const existingImagesValid = currentImages.filter((img) => !img.isNewUpload);
    const existingImageIds = getValidImageIds(existingImagesValid);

    const finalImageIds = [...existingImageIds, ...uploadedImageIds];

    // 3. Sử dụng API mới để cập nhật toàn bộ ảnh
    if (finalImageIds.length > 0) {
      await fetchUpdateAllChiTietSanPhamAnh(chiTietSanPhamId, finalImageIds);
    } else {
      // Nếu không có ảnh nào, xóa tất cả liên kết cũ
      await fetchDeleteAllChiTietSanPhamAnhByChiTietSanPhamId(chiTietSanPhamId);
    }

    // 4. Refresh dữ liệu ảnh để đảm bảo UI được cập nhật
    await refreshImageDataForInline();

    // 5. Kiểm tra trạng thái liên kết ảnh sau khi xử lý

    return true;
  } catch (error) {
    console.error("❌ Error handling product images:", error);
    throw error;
  }
};

// Hàm kiểm tra và validate ảnh trước khi upload
const validateImageFileForInline = (file) => {
  // Kiểm tra file có tồn tại không
  if (!file) {
    throw new Error("File không tồn tại!");
  }

  // Kiểm tra xem file có phải là File object không
  if (!(file instanceof File)) {
    throw new Error("File không hợp lệ!");
  }

  // Kiểm tra loại file
  if (!file.type || !file.type.startsWith("image/")) {
    throw new Error(`File ${file.name} không phải là ảnh!`);
  }

  // Kiểm tra kích thước file (giới hạn 5MB)
  if (!file.size || file.size > 5 * 1024 * 1024) {
    throw new Error(
      `File ${file.name} quá lớn! Vui lòng chọn file nhỏ hơn 5MB.`
    );
  }

  // Kiểm tra tên file
  if (!file.name || file.name.length > 250) {
    throw new Error(
      `Tên file ${file.name} quá dài! Vui lòng đổi tên file ngắn hơn.`
    );
  }

  return true;
};

// Hàm xử lý lỗi upload ảnh
const handleImageUploadErrorForInline = (error, fileName) => {
  const errorMessage = error.message || "Lỗi không xác định";
  alert(`Không thể upload ảnh ${fileName}: ${errorMessage}`);
};

// Hàm refresh dữ liệu ảnh sau khi xử lý

// Hàm kiểm tra trạng thái ảnh của chi tiết sản phẩm
const checkImageStatusForInline = async (chiTietSanPhamId) => {
  try {
    const status = await fetchCheckChiTietSanPhamAnhStatus(chiTietSanPhamId);
    return status;
  } catch (error) {
    console.error("Error checking image status:", error);
    return null;
  }
};

// Hàm xóa tất cả ảnh của một chi tiết sản phẩm

// Hàm cập nhật ảnh cho chi tiết sản phẩm (wrapper function)
const refreshImageDataForInline = async () => {
  try {
    console.log("🔄 Starting inline data refresh...");

    // Chạy các API calls song song để tăng tốc độ
    const promises = [fetchAnhSanPham(), fetchChiTietSanPhamAnh()];

    // Chỉ thêm fetchChiTietSanPham nếu có currentProduct.id
    if (currentProduct.value?.id) {
      promises.push(fetchChiTietSanPham(currentProduct.value.id));
    }

    await Promise.all(promises);

    // Force Vue re-render
    imageDataKey.value = {
      chiTietSanPhamAnhsLength: chiTietSanPhamAnhs.value?.length || 0,
      anhSanPhamsLength: anhSanPhams.value?.length || 0,
      timestamp: Date.now(),
    };

    console.log("✅ Inline data refresh completed successfully");
  } catch (error) {
    console.error("❌ Error refreshing inline image data:", error);
  }
};

// Inline editing functions

const startEdit = async (detail) => {
  // Chỉ mở popup edit, không kích hoạt inline edit
  showEditPopup.value = true;

  await fetchAnhSanPham();
  await fetchChiTietSanPhamAnh();

  // Kiểm tra chi tiết sản phẩm trong danh sách
  const chiTietSanPham = chiTietSanPhams.value?.find(
    (item) => item.id === detail.id
  );

  // Lấy ảnh hiện tại của chi tiết sản phẩm
  const currentImages = getImagesForChiTietSanPhamForEdit(detail.id);

  currentEditingDetail.value = {
    ...detail,
    images: currentImages,
  };

  // Đảm bảo images luôn là array
  if (!currentEditingDetail.value.images) {
    currentEditingDetail.value.images = [];
  }

  // Đảm bảo mỗi image có cấu trúc đúng
  if (currentEditingDetail.value.images.length > 0) {
    currentEditingDetail.value.images = currentEditingDetail.value.images
      .map((img) => {
        if (img && typeof img === "object") {
          return {
            id: img.id || null,
            duongDanAnh: img.duongDanAnh || null,
            file: img.file || null,
            url: img.url || null,
            isNew: img.isNew || false,
          };
        }
        return null;
      })
      .filter((img) => img !== null);
  }
};

// Hàm đóng popup edit
const closeEditPopup = () => {
  showEditPopup.value = false;
  currentEditingDetail.value = {};

  // Reset trạng thái ban đầu khi đóng popup
  initialImageIds.value = [];
  initialImages.value = [];
};

// Hàm lưu từ popup edit

// Hàm lưu inline edit
const saveInlineEdit = async (detailId) => {
  const editingDetail = editingChiTietSanPhams.value.get(detailId);
  if (!editingDetail) return;

  try {
    // Lấy dữ liệu gốc để có đầy đủ thông tin
    const originalDetail = originalChiTietSanPhams.value.get(detailId);

    // Chỉ cập nhật 3 trường: soLuong, giaBan, trangThai
    // Các trường khác giữ nguyên từ dữ liệu gốc
    const updatedData = {
      idSanPham: currentProduct.value?.id,
      idMauSac: originalDetail?.idMauSac || 1,
      idKichThuoc: originalDetail?.idKichThuoc || 1,
      idDeGiay: originalDetail?.idDeGiay || 1,
      idChatLieu: originalDetail?.idChatLieu || 1,
      idTrongLuong: originalDetail?.idTrongLuong || 1,
      soLuong: editingDetail.soLuong || originalDetail?.soLuong || 0,
      giaBan: editingDetail.giaBan || originalDetail?.giaBan || 0,
      trangThai:
        editingDetail.trangThai !== undefined
          ? editingDetail.trangThai
          : originalDetail?.trangThai !== undefined
          ? originalDetail?.trangThai
          : true,
      ghiChu: originalDetail?.ghiChu || "",
      deleted: originalDetail?.deleted || false,
      createdAt: originalDetail?.createdAt || new Date().toISOString(),
      createBy: originalDetail?.createBy || 1,
      updatedAt: new Date().toISOString(),
      updateBy: 1,
    };

    // Reset editing state cho chi tiết sản phẩm này
    editingChiTietSanPhams.value.delete(detailId);
    originalChiTietSanPhams.value.delete(detailId);

    // Refresh data
    await refreshImageData();

    showNotificationPopup("success", "Thành công", "Cập nhật chi tiết sản phẩm thành công!");
  } catch (error) {
    alert("Có lỗi xảy ra khi cập nhật!");
  }
};

// Hàm hủy inline edit
const cancelInlineEdit = (detailId) => {
  // Khôi phục dữ liệu gốc
  const originalDetail = originalChiTietSanPhams.value.get(detailId);
  if (originalDetail) {
    editingChiTietSanPhams.value.set(detailId, { ...originalDetail });
  }

  // Tắt edit mode
  editingChiTietSanPhams.value.delete(detailId);
  originalChiTietSanPhams.value.delete(detailId);
};

// Function để hủy tất cả chỉnh sửa

// Function để lưu tất cả các thay đổi đã chọn
const saveAllCheckedChiTietSanPhamsFromInline = async () => {
  // Kiểm tra xem có chi tiết nào được chọn không
  if (selectedChiTietSanPhams.value.length === 0) {
    alert("Vui lòng chọn ít nhất một chi tiết sản phẩm để cập nhật!");
    return;
  }

  // Hiển thị popup confirm
  const confirmMessage = `Bạn có chắc chắn muốn cập nhật ${selectedChiTietSanPhams.value.length} chi tiết sản phẩm đã chọn?`;
  if (!confirm(confirmMessage)) {
    return; // Người dùng hủy
  }

  try {
    const promises = [];

    // Lưu từng chi tiết sản phẩm đã chọn
    for (const detailId of selectedChiTietSanPhams.value) {
      const editingDetail = editingChiTietSanPhams.value.get(detailId);
      if (editingDetail) {
        // Lấy dữ liệu gốc để có đầy đủ thông tin
        const originalDetail = originalChiTietSanPhams.value.get(detailId);

        // Chỉ cập nhật 3 trường: soLuong, giaBan, trangThai
        // Các trường khác giữ nguyên từ dữ liệu gốc
        const chiTietSanPhamData = {
          id: editingDetail.id,
          idSanPham: currentProduct.value?.id,
          idMauSac: originalDetail?.idMauSac || 1,
          idKichThuoc: originalDetail?.idKichThuoc || 1,
          idChatLieu: originalDetail?.idChatLieu || 1,
          idDeGiay: originalDetail?.idDeGiay || 1,
          idTrongLuong: originalDetail?.idTrongLuong || 1,
          idDotGiamGia: originalDetail?.idDotGiamGia,
          soLuong: editingDetail.soLuong || originalDetail?.soLuong || 0,
          giaBan: editingDetail.giaBan || originalDetail?.giaBan || 0,
          trangThai:
            editingDetail.trangThai !== undefined
              ? editingDetail.trangThai
              : originalDetail?.trangThai !== undefined
              ? originalDetail?.trangThai
              : true,
          deleted: false,
          createdAt: originalDetail?.createdAt || new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        };
        // Tìm chi tiết đợt giảm giá
        const chiTietDotGiamGia = chiTietDotGiamGias.value.find(
          (chiTietDotGiamGia) =>
            chiTietDotGiamGia.idChiTietSanPham === editingDetail.id &&
            chiTietDotGiamGia.idDotGiamGia === editingDetail.idDotGiamGia
        );

        if (!chiTietDotGiamGia) {
          continue; // Bỏ qua chi tiết sản phẩm này
        }

        // Tìm nhà sản xuất
        const nhaSanXuat = nhaSanXuats.value.find(
          (nhaSanXuat) =>
            nhaSanXuat.tenNhaSanXuat ===
            currentEditingDetail.value.tenNhaSanXuat
        );

        if (!nhaSanXuat) {
          alert("Không tìm thấy nhà sản xuất!");
          return;
        }

        // Tìm xuất xứ
        const xuatXu = xuatXus.value.find(
          (xuatXu) => xuatXu.tenXuatXu === currentEditingDetail.value.tenXuatXu
        );

        if (!xuatXu) {
          alert("Không tìm thấy xuất xứ!");
          return;
        }

        // Chỉ cập nhật dotGiamGiaData nếu có đợt giảm giá
        let dotGiamGiaData = null;
        if (dotGiamGia && chiTietDotGiamGia) {
          dotGiamGiaData = {
            id: chiTietDotGiamGia.id,
            idDotGiamGia: dotGiamGia.id,
            idChiTietSanPham: currentEditingDetail.value.id,
            trangThai: currentEditingDetail.value.trangThai,
            deleted: false,
            createdAt: currentEditingDetail.value.createdAt,
            updatedAt: new Date().toISOString(),
          };
        }

        const sanPhamData = {
          id: currentProduct.value?.id,
          idNhaSanXuat: nhaSanXuat.id,
          idXuatXu: xuatXu.id,
          tenSanPham: currentProductName.value,
          trangThai: currentEditingDetail.value.trangThai,
          deleted: false,
          createdAt: currentEditingDetail.value.createdAt,
          updatedAt: new Date().toISOString(),
        };

        promises.push(fetchUpdateChiTietSanPham(detailId, chiTietSanPhamData));
        promises.push(
          fetchUpdateChiTietDotGiamGia(dotGiamGiaData.id, dotGiamGiaData)
        );
        promises.push(fetchUpdateSanPham(sanPhamData.id, sanPhamData));
      }
    }

    // Chờ tất cả API calls hoàn thành
    await Promise.all(promises);

    // Reset tất cả trạng thái
    editingChiTietSanPhams.value.clear();
    originalChiTietSanPhams.value.clear();
    selectedChiTietSanPhams.value = []; // Xóa toàn bộ checkbox đã tích

    // Refresh data
    await refreshImageData();

    showNotificationPopup("success", "Thành công", "Cập nhật tất cả chi tiết sản phẩm đã chọn thành công!");
  } catch (error) {
    console.error(
      "Error saving all checked chi tiết sản phẩms from inline:",
      error
    );
    alert("Có lỗi xảy ra khi cập nhật!");
  }
};

// Checkbox selection functions
const toggleChiTietSanPhamSelection = (detailId) => {
  const index = selectedChiTietSanPhams.value.indexOf(detailId);
  if (index > -1) {
    // Bỏ chọn - xóa khỏi selectedChiTietSanPhams và tắt edit mode
    selectedChiTietSanPhams.value.splice(index, 1);
    editingChiTietSanPhams.value.delete(detailId);
    originalChiTietSanPhams.value.delete(detailId);
  } else {
    // Chọn - thêm vào selectedChiTietSanPhams và bật edit mode cho 3 trường
    selectedChiTietSanPhams.value.push(detailId);
    const detail = chiTietSanPhams.value.find((d) => d.id === detailId);
    if (detail) {
      editingChiTietSanPhams.value.set(detailId, { ...detail });
      originalChiTietSanPhams.value.set(detailId, { ...detail });
    }
  }
};

const toggleSelectAll = () => {
  if (selectedChiTietSanPhams.value.length === paginatedDetails.value.length) {
    // Bỏ chọn tất cả
    selectedChiTietSanPhams.value = [];
    editingChiTietSanPhams.value.clear();
    originalChiTietSanPhams.value.clear();
  } else {
    // Chọn tất cả
    selectedChiTietSanPhams.value = paginatedDetails.value.map(
      (detail) => detail.id
    );
    // Đưa tất cả chi tiết sản phẩm vào chế độ edit
    paginatedDetails.value.forEach((detail) => {
      editingChiTietSanPhams.value.set(detail.id, { ...detail });
      originalChiTietSanPhams.value.set(detail.id, { ...detail });
    });
  }
};

// Hàm load ảnh cho chi tiết sản phẩm
</script>

<style scoped>
/* CSS đã được chuyển vào productsUnified.css */
@import "../../../styles/cssSanPham/productsUnified.css";
@import "../../../styles/cssSanPham/quanLySanPham.css";
@import "../../../styles/cssSanPham/productManagement.css";
@import "../../../styles/cssSanPham/popupAttributes.css";

/* Compact the columns and cells for the product detail table only */
:deep(.chi-tiet-san-pham-page .coupons-table thead th) {
  font-size: 0.7rem;
  padding: 6px 6px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  box-sizing: border-box;
}

:deep(.chi-tiet-san-pham-page .coupons-table td) {
  font-size: 0.78rem;
  padding: 6px 6px;
  line-height: 1.2;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  box-sizing: border-box;
}

/* Column width tweaks */
:deep(.chi-tiet-san-pham-page .coupons-table th.stt-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.stt-col) {
  width: 40px;
  min-width: 40px;
  max-width: 40px;
  text-align: center;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.ma-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.ma-col) {
  width: 100px;
  min-width: 100px;
  max-width: 110px;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.image-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.image-col) {
  width: 72px;
  min-width: 72px;
  max-width: 72px;
  text-align: center;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.nha-san-xuat-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.nha-san-xuat-col) {
  width: 110px;
  min-width: 110px;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.xuat-xu-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.xuat-xu-col) {
  width: 90px;
  min-width: 90px;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.color-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.color-col),
:deep(.chi-tiet-san-pham-page .coupons-table th.size-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.size-col),
:deep(.chi-tiet-san-pham-page .coupons-table th.sole-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.sole-col),
:deep(.chi-tiet-san-pham-page .coupons-table th.material-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.material-col),
:deep(.chi-tiet-san-pham-page .coupons-table th.weight-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.weight-col) {
  width: 90px;
  min-width: 90px;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.quantity-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.quantity-col) {
  width: 80px;
  min-width: 80px;
  text-align: center;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.price-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.price-col) {
  width: 120px;
  min-width: 120px;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.giam-gia-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.giam-gia-col) {
  width: 80px;
  min-width: 80px;
  text-align: center;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.gia-sau-giam-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.gia-sau-giam-col) {
  width: 140px;
  min-width: 140px;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.status-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.status-col) {
  width: 130px;
  min-width: 130px;
  text-align: center;
}

:deep(.chi-tiet-san-pham-page .coupons-table th.action-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.action-col) {
  width: 180px;
  min-width: 180px;
  text-align: center;
}

/* Ensure status badge itself does not expand the column */
:deep(.chi-tiet-san-pham-page .status-badge) {
  white-space: nowrap;
  display: inline-block;
  max-width: 100%;
}

/* Keep action column visible and compact */
:deep(.chi-tiet-san-pham-page .coupons-table th.action-col),
:deep(.chi-tiet-san-pham-page .coupons-table td.action-col) {
  min-width: 110px;
  width: auto;
  text-align: center;
}

/* Make action buttons compact so they fit the smaller column */
:deep(.chi-tiet-san-pham-page .action-buttons) {
  gap: 6px;
  flex-wrap: nowrap;
}

:deep(.chi-tiet-san-pham-page .action-buttons .btn) {
  padding: 4px 8px;
  height: 28px;
  min-width: auto;
  font-size: 12px;
}

/* CSS cho chức năng chọn ảnh edit */
.image-selector-section {
  margin-top: 10px;
}

.image-actions {
  display: flex;
  flex-direction: row;
  gap: 10px;
  margin-bottom: 10px;
  align-items: center;
}

.upload-section {
  display: flex;
  align-items: center;
  gap: 10px;
}

.file-input {
  display: none;
}

.upload-section .btn {
  flex: 1;
  max-width: 150px;
}

.current-images {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 10px;
}

.image-item {
  position: relative;
  display: inline-block;
}

.thumbnail {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
  border: 2px solid #e5e7eb;
}

.remove-image-btn {
  position: absolute;
  top: -5px;
  right: -5px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #ef4444;
  color: white;
  border: none;
  cursor: pointer;
  font-size: 14px;
  line-height: 1;
}

.image-limit-info {
  font-size: 12px;
  color: #6b7280;
  margin-left: 10px;
}

.image-selector-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.image-selector-popup {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
}

.image-selector-header {
  padding: 20px;
  border-bottom: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.image-selector-content {
  padding: 20px;
}

.selected-images-preview {
  margin-bottom: 20px;
}

.selected-images-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
}

.selected-image-item {
  position: relative;
  display: inline-block;
}

.preview-image {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
  border: 2px solid #10b981;
}

.remove-selected-btn {
  position: absolute;
  top: -5px;
  right: -5px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #ef4444;
  color: white;
  border: none;
  cursor: pointer;
  font-size: 14px;
  line-height: 1;
}

.action-buttons {
  display: flex;
  gap: 10px;
  align-items: center;
}

.action-buttons .btn {
  padding: 4px 8px;
  font-size: 12px;
  border-radius: 4px;
  border: 1px solid transparent;
  cursor: pointer;
  transition: all 0.2s;
}

.action-buttons .btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.action-buttons .btn-danger {
  background-color: #dc3545;
  color: white;
  border-color: #dc3545;
}

.action-buttons .btn-danger:hover {
  background-color: #c82333;
  border-color: #bd2130;
}

.action-buttons .btn-secondary {
  background-color: var(--accent-color);
  color: white;
  border-color: var(--accent-color);
}

.action-buttons .btn-secondary:hover {
  background-color: var(--accent-color);
  border-color: var(--accent-color);
}

.available-images-section h4 {
  margin-bottom: 10px;
}

.available-images-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 10px;
  max-height: 300px;
  overflow-y: auto;
}

.available-image-item {
  position: relative;
  cursor: pointer;
  border-radius: 4px;
  overflow: hidden;
  transition: transform 0.2s;
}

.available-image-item.selected {
  border: 3px solid #10b981;
}

.available-image {
  width: 100%;
  height: 100px;
  object-fit: cover;
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  opacity: 0;
  transition: opacity 0.2s;
}

.available-image-item.selected .image-overlay {
  opacity: 1;
}

.selected-indicator {
  color: white;
  font-size: 24px;
  font-weight: bold;
}

.image-selector-actions {
  padding: 20px;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

/* CSS cho popup thông báo thành công */
.success-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.success-popup {
  background: white;
  border-radius: 12px;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
    0 10px 10px -5px rgba(0, 0, 0, 0.04);
  max-width: 400px;
  width: 90%;
  overflow: hidden;
  animation: slideIn 0.3s ease-out;
}

.success-popup-content {
  padding: 30px;
  text-align: center;
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

.success-btn {
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

.success-btn:hover {
  background: #047857;
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

/* CSS để căn giữa dòng 2 của filter - hiển thị 3 cột ngang hàng */
.filter-row-2 {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  gap: 2rem;
  width: 100%;
  margin-top: 1.5rem;
  padding: 1.5rem;
  background: linear-gradient(135deg, #ffffff, #ffffff);
  border-radius: 12px;
  border: 2px solid #e2e8f0;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1),
    0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.filter-row-2 .filter-group {
  margin: 0;
  width: 200px;
  text-align: center;
}

.filter-row-2 .filter-actions {
  margin: 0;
  width: 200px;
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.filter-row-2 .filter-label {
  display: block;
  margin-bottom: 0.75rem;
  font-weight: 600;
  color: #1f2937;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.filter-row-2 .form-select {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  background: white;
  font-size: 14px;
  transition: border-color 0.2s ease;
}

.filter-row-2 .form-select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.filter-row-2 .btn {
  width: 100%;
  padding: 0.75rem 1rem;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s ease;
}

/* CSS cho popup confirm đã được chuyển vào productsUnified.css */

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

.custom-confirm-dialog h3::before {
  content: "<!-- icon: warning -->";
  font-size: 1.75rem;
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

.custom-confirm-dialog .btn-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
}

.custom-confirm-dialog .btn-primary:hover {
  background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(59, 130, 246, 0.5);
}

.custom-confirm-dialog .btn-secondary {
  background: linear-gradient(135deg, #64748b 0%, #475569 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(100, 116, 139, 0.4);
}

.custom-confirm-dialog .btn-secondary:hover {
  /* background: linear-gradient(135deg, #475569 0%, #334155 100%); */
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(100, 116, 139, 0.5);
}

/* Animations */
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px) scale(0.9);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* Responsive design */
@media (max-width: 480px) {
  .custom-confirm-dialog .confirm-content {
    padding: 2rem 1.5rem;
    margin: 1rem;
    border-radius: 16px;
  }

  .custom-confirm-dialog h3 {
    font-size: 1.25rem;
  }

  .custom-confirm-dialog p {
    font-size: 0.9rem;
    padding: 0.875rem;
  }

  .custom-confirm-dialog .btn {
    padding: 0.75rem 1.5rem;
    min-width: 100px;
    font-size: 0.9rem;
  }

  .custom-confirm-dialog .confirm-buttons {
    flex-direction: row !important;
    gap: 0.75rem !important;
  }
}

/* CSS bổ sung để đảm bảo popup luôn hiển thị ở giữa trang web */
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
  pointer-events: auto !important;
}

.custom-confirm-dialog .confirm-content {
  position: relative !important;
  z-index: 1000000 !important;
  transform: translateZ(0) !important;
  will-change: transform !important;
  background: linear-gradient(135deg, #ffffff, #ffffff) !important;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15),
    0 0 0 1px rgba(255, 255, 255, 0.1) !important;
}

/* Đảm bảo không có element nào che khuất popup */
.custom-confirm-dialog * {
  position: relative !important;
  z-index: inherit !important;
}

/* Đảm bảo popup luôn ở trên cùng */
body {
  overflow: hidden !important;
}

.custom-confirm-dialog {
  overflow: visible !important;
}

/* Đảm bảo popup luôn ở giữa màn hình */
.custom-confirm-dialog {
  position: fixed !important;
  top: 50% !important;
  left: 50% !important;
  transform: translate(-50%, -50%) !important;
  width: 100vw !important;
  height: 100vh !important;
}

.custom-confirm-dialog .confirm-content {
  position: absolute !important;
  top: 50% !important;
  left: 50% !important;
  transform: translate(-50%, -50%) !important;
  z-index: 1000000 !important;
}

/* CSS cho table - xóa border và background, giảm font size */
.table {
  border: none !important;
  background: transparent !important;
  font-size: 12px !important;
}

.table thead th {
  border: none !important;
  background: transparent !important;
  font-size: 12px !important;
  font-weight: 600 !important;
  color: #374151 !important;
}

.table tbody td {
  border: none !important;
  background: transparent !important;
  font-size: 12px !important;
  color: #4b5563 !important;
}

.table tbody tr {
  border: none !important;
  /* background: transparent !important; */
}

/* Xóa border và background của tất cả elements trong table */
.table .edit-mode-input,
.table .edit-mode-select,
.table .stock-badge,
.table .price-text,
.table .giam-gia-value,
.table .gia-sau-giam-text,
.table .status-badge,
.table .color-badge,
.table .size-badge,
.table .attribute-text,
.table .nha-san-xuat-text,
.table .xuat-xu-text,
.table .image-preview,
.table .action-buttons,
.table .inline-edit,
.table .no-image,
.table .form-control,
.table .form-select,
.table input,
.table select,
.table textarea {
  border: none !important;
  background: transparent !important;
  font-size: 12px !important;
  box-shadow: none !important;
  outline: none !important;
}

/* Xóa background của các badge và text elements */
.table .stock-badge,
.table .price-text,
.table .giam-gia-value,
.table .gia-sau-giam-text,
.table .status-badge,
.table .color-badge,
.table .size-badge,
.table .attribute-text,
.table .nha-san-xuat-text,
.table .xuat-xu-text,
.table .no-image {
  background: transparent !important;
  padding: 0 !important;
  margin: 0 !important;
}

/* Xóa border và background của inline edit containers */
.table .inline-edit {
  border: none !important;
  background: transparent !important;
  padding: 0 !important;
  margin: 0 !important;
}

/* Xóa background của action buttons container */
.table .action-buttons {
  background: transparent !important;
  padding: 0 !important;
  margin: 0 !important;
}

/* Xóa background của image preview */
.table .image-preview {
  background: transparent !important;
  border: none !important;
}
/* Giảm width tất cả các cột trong table - tối ưu siêu cực đại */
.table .stt-col {
  width: 12px !important;
  min-width: 12px !important;
  max-width: 12px !important;
}

.table .ma-col {
  width: 30px !important;
  min-width: 30px !important;
  max-width: 30px !important;
}

.table .image-col {
  width: 30px !important;
  min-width: 30px !important;
  max-width: 30px !important;
}

.table .nha-san-xuat-col {
  width: 20px !important;
  min-width: 20px !important;
  max-width: 20px !important;
}

.table .xuat-xu-col {
  width: 20px !important;
  min-width: 20px !important;
  max-width: 20px !important;
}

.table .color-col {
  width: 20px !important;
  min-width: 20px !important;
  max-width: 20px !important;
}

.table .size-col {
  width: 22px !important;
  min-width: 22px !important;
  max-width: 22px !important;
}

.table .sole-col {
  width: 20px !important;
  min-width: 20px !important;
  max-width: 20px !important;
}

.table .material-col {
  width: 20px !important;
  min-width: 20px !important;
  max-width: 20px !important;
}

.table .weight-col {
  width: 22px !important;
  min-width: 22px !important;
  max-width: 22px !important;
}

.table .quantity-col {
  width: 22px !important;
  min-width: 22px !important;
  max-width: 22px !important;
}

.table .price-col {
  width: 30px !important;
  min-width: 30px !important;
  max-width: 30px !important;
}

.table .giam-gia-col {
  width: 15px !important;
  min-width: 15px !important;
  max-width: 15px !important;
}

.table .gia-sau-giam-col {
  width: 30px !important;
  min-width: 30px !important;
  max-width: 30px !important;
}

.table .status-col {
  width: 30px !important;
  min-width: 30px !important;
  max-width: 30px !important;
}

.table .action-col {
  width: 68px !important;
  min-width: 68px !important;
  max-width: 68px !important;
}

/* Cho phép thead text wrap và giảm padding */
.table thead th {
  white-space: normal !important;
  word-wrap: break-word !important;
  overflow-wrap: break-word !important;
  hyphens: auto !important;
  padding-left: 2px !important;
  padding-right: 2px !important;
  padding-top: 8px !important;
  padding-bottom: 8px !important;
  line-height: 1.2 !important;
  font-weight: 600 !important;
  color: #1f2937 !important; /* Màu tối hơn cho header */
}

.table tbody td {
  padding-left: 2px !important;
  padding-right: 2px !important;
  padding-top: 6px !important;
  padding-bottom: 6px !important;
  white-space: normal !important;
  word-wrap: break-word !important;
  line-height: 1.3 !important;
  color: #374151 !important; /* Màu thống nhất cho tất cả trường dữ liệu */
}

/* Không cho phép xuống dòng cho các cột giá cả */
.table .price-col,
.table .giam-gia-col,
.table .gia-sau-giam-col {
  white-space: nowrap !important;
  word-wrap: normal !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

/* Màu riêng cho cột giảm giá trong tbody - đã xóa để đồng bộ màu */

/* Đảm bảo header của cột giảm giá có màu thống nhất với các header khác */
.table thead .giam-gia-col {
  color: #1f2937 !important; /* Màu header thống nhất */
}

/* Đảm bảo các cột giá bán, giá sau giảm và trạng thái có màu thống nhất trong tbody */
.table tbody .price-col,
.table tbody .gia-sau-giam-col,
.table tbody .status-col {
  color: #374151 !important; /* Màu dữ liệu thống nhất */
}

/* Cho phép xuống dòng ở thead cho cột giảm giá và giá sau giảm */
.table thead .giam-gia-col,
.table thead .gia-sau-giam-col {
  white-space: normal !important;
  word-wrap: break-word !important;
  overflow-wrap: break-word !important;
  hyphens: auto !important;
  line-height: 1.2 !important;
}

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

.btn-success {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
  box-shadow: 0 2px 4px rgba(16, 185, 129, 0.3);
}

.btn-success:hover {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  box-shadow: 0 4px 8px rgba(16, 185, 129, 0.4);
}

.btn-danger {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  box-shadow: 0 2px 4px rgba(239, 68, 68, 0.3);
}

.btn-danger:hover {
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  box-shadow: 0 4px 8px rgba(239, 68, 68, 0.4);
}

.btn-secondary {
  /* background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%); */
  color: white !important;
  /* box-shadow: 0 2px 4px rgba(107, 114, 128, 0.3); */
  white-space: nowrap;
}

.btn-secondary:hover {
  /* background: linear-gradient(135deg, #4b5563 0%, #374151 100%); */
  box-shadow: 0 4px 8px rgba(107, 114, 128, 0.4);
}

.btn-outline {
  background: transparent;
  border: 1px solid #d1d5db;
  color: #ffffff !important;
}

.btn-outline:hover {
  background: #ffffff;
  border-color: #9ca3af;
  color: #374151;
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

/* CSS cho nút toggle hiển thị biến thể */
.btn-toggle-variants {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: var(
    --accent-color
  ); /* Sử dụng màu chủ đạo như nút hoàn thành cập nhật */
  color: white !important;
  border: 2px solid var(--accent-color);
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(74, 222, 128, 0.1);
  min-width: 220px;
  justify-content: center;
}

.btn-toggle-variants:hover {
  background: #22c55e; /* Màu hover xanh lục đậm hơn */
  border-color: #22c55e;
  box-shadow: 0 4px 12px rgba(74, 222, 128, 0.2);
}

.btn-toggle-variants:active {
  transform: translateY(0);
  box-shadow: 0 2px 6px rgba(74, 222, 128, 0.2);
}

/* Trạng thái hiển thị tất cả biến thể - thay đổi màu sắc để phân biệt */
.btn-toggle-variants.showing-all {
  background: #f59e0b; /* Màu cam vàng khi đang hiển thị tất cả */
  border-color: #f59e0b;
  box-shadow: 0 2px 8px rgba(245, 158, 11, 0.1);
}

.btn-toggle-variants.showing-all:hover {
  background: #d97706; /* Màu cam vàng đậm hơn khi hover */
  border-color: #d97706;
  box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);
}

.btn-toggle-variants.showing-all:active {
  box-shadow: 0 2px 6px rgba(245, 158, 11, 0.2);
}

/* CSS cho nút refresh all data */
.btn-refresh-all {
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
  border: none;
  padding: 10px 16px;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 4px rgba(59, 130, 246, 0.3);
  margin-left: 8px;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-refresh-all:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(59, 130, 246, 0.4);
}

.btn-refresh-all:active {
  transform: translateY(0);
}

.btn-refresh-all:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
  background: linear-gradient(135deg, #9ca3af 0%, #6b7280 100%);
}

/* CSS cho popup xác nhận xóa */
.delete-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
  z-index: 1000;
}

.delete-popup {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 500px;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
    0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

.delete-popup-header {
  padding: 20px;
  border-bottom: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.delete-popup-header h3 {
  margin: 0;
  color: #dc2626;
  font-size: 18px;
  font-weight: 600;
}

.delete-popup-header .close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #6b7280;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background-color 0.2s;
}

.delete-popup-header .close-btn:hover {
  background: #f3f4f6;
}

.delete-popup-content {
  padding: 20px;
}

.delete-popup-content p {
  margin: 0 0 15px 0;
  color: #374151;
  font-size: 16px;
  line-height: 1.5;
}

.delete-details {
  background: #f9fafb;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  border-left: 4px solid #4ade80;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.detail-row:last-child {
  margin-bottom: 0;
}

.detail-label {
  font-weight: 500;
  color: #4b5563;
  font-size: 14px;
}

.detail-value {
  color: #1f2937;
  font-size: 14px;
  font-weight: 600;
}

.delete-warning {
  background: #fef3c7;
  border: 1px solid #f59e0b;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 20px;
  color: #92400e;
  font-size: 14px;
  line-height: 1.4;
}

.delete-popup-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

.btn-delete-cancel {
  padding: 10px 20px;
  border: 1px solid #d1d5db;
  background: white;
  color: #6b7280;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s ease;
}

.btn-delete-cancel:hover {
  background: #f9fafb;
  border-color: #9ca3af;
}

.btn-delete-confirm {
  padding: 10px 20px;
  border: none;
  background: #dc2626;
  color: white;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s ease;
}

.btn-delete-confirm:hover {
  background: #b91c1c;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(220, 38, 38, 0.3);
}

.btn-delete-confirm:active {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(220, 38, 38, 0.3);
}


/* ===== CSS CHO POPUP THÔNG BÁO BÊN PHẢI MÀN HÌNH ===== */
/* Container cho popup thông báo */
.notification-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 10001;
  max-width: 400px;
  width: 100%;
}

/* Popup thông báo */
.notification-popup {
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  border-left: 4px solid #22c55e;
  padding: 20px;
  margin-bottom: 16px;
  transform: translateX(100%);
  opacity: 0;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

/* Animation hiển thị popup */
.notification-popup.show {
  transform: translateX(0);
  opacity: 1;
}

/* Animation ẩn popup */
.notification-popup.hide {
  transform: translateX(100%);
  opacity: 0;
}

/* Header popup thông báo */
.notification-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

/* Tiêu đề popup thông báo */
.notification-title {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  margin: 0;
  flex: 1;
}

/* Nội dung popup thông báo */
.notification-message {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
  line-height: 1.5;
}

/* Thanh tiến trình popup thông báo */
.notification-progress {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  background: #22c55e;
  border-radius: 0 0 12px 12px;
  animation: progressBar 3s linear forwards;
}

@keyframes progressBar {
  from {
    width: 100%;
  }
  to {
    width: 0%;
  }
}

/* Các loại thông báo khác nhau */
.notification-popup.success {
  border-left-color: #22c55e;
}

.notification-popup.success .notification-progress {
  background: #22c55e;
}

.notification-popup.error {
  border-left-color: #ef4444;
}

.notification-popup.error .notification-progress {
  background: #ef4444;
}

.notification-popup.warning {
  border-left-color: #f59e0b;
}

.notification-popup.warning .notification-progress {
  background: #f59e0b;
}

.notification-popup.info {
  border-left-color: #3b82f6;
}

.notification-popup.info .notification-progress {
  background: #3b82f6;
}

/* CSS cho Upload Progress Section */
.upload-progress-section {
  margin-top: 20px;
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  border: 1px solid #cbd5e1;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  animation: slideInUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.upload-progress-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 2px solid #e2e8f0;
}

.upload-progress-header h4 {
  margin: 0;
  color: #1e293b;
  font-size: 16px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.btn-clear-progress {
  background: #f1f5f9;
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  width: 32px;
  height: 32px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  transition: all 0.2s ease;
  color: #64748b;
}

.btn-clear-progress:hover {
  background: #dc2626;
  color: white;
  transform: scale(1.05);
  box-shadow: 0 2px 8px rgba(220, 38, 38, 0.3);
}

.btn-clear-progress:active {
  transform: scale(0.95);
}

.upload-progress-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.upload-progress-item {
  background: white;
  border-radius: 8px;
  padding: 16px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.upload-progress-item:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.upload-progress-item.uploading {
  border-left: 4px solid #3b82f6;
}

.upload-progress-item.success {
  border-left: 4px solid #10b981;
}

.upload-progress-item.error {
  border-left: 4px solid #ef4444;
}

.upload-progress-item.timeout {
  border-left: 4px solid #f59e0b;
}

.progress-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.file-name {
  font-weight: 500;
  color: #1e293b;
  font-size: 14px;
  flex: 1;
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
  margin-right: 12px;
}

.attempt-count {
  font-size: 12px;
  color: #64748b;
  background: #f1f5f9;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 500;
}

.progress-bar {
  width: 100%;
  height: 8px;
  background: #e2e8f0;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 8px;
  position: relative;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #3b82f6 0%, #1d4ed8 100%);
  border-radius: 4px;
  transition: width 0.3s ease;
  position: relative;
}

.progress-fill::after {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 255, 255, 0.4) 50%,
    transparent 100%
  );
  animation: progressShimmer 2s infinite;
}

.upload-progress-item.success .progress-fill {
  background: linear-gradient(90deg, #10b981 0%, #059669 100%);
}

.upload-progress-item.error .progress-fill {
  background: linear-gradient(90deg, #ef4444 0%, #dc2626 100%);
}

.upload-progress-item.timeout .progress-fill {
  background: linear-gradient(90deg, #f59e0b 0%, #d97706 100%);
}

.progress-status {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  font-weight: 500;
}

.status-uploading {
  color: #3b82f6;
  display: flex;
  align-items: center;
  gap: 4px;
}

.status-uploading::before {
  content: "";
  width: 12px;
  height: 12px;
  border: 2px solid #3b82f6;
  border-top: 2px solid transparent;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.status-success {
  color: #10b981;
  display: flex;
  align-items: center;
  gap: 4px;
}

.status-success::before {
  content: "✓";
  color: #10b981;
  font-weight: bold;
  font-size: 14px;
}

.status-error {
  color: #ef4444;
  display: flex;
  align-items: center;
  gap: 4px;
}

.status-error::before {
  content: "✕";
  color: #ef4444;
  font-weight: bold;
  font-size: 14px;
}

.status-timeout {
  color: #f59e0b;
  display: flex;
  align-items: center;
  gap: 4px;
}

.status-timeout::before {
  content: "⏱";
  color: #f59e0b;
  font-size: 14px;
}

/* Animations */
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes progressShimmer {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* Responsive for upload progress */
@media (max-width: 768px) {
  .upload-progress-section {
    margin-top: 16px;
    padding: 16px;
  }

  .upload-progress-header {
    flex-direction: column;
    gap: 8px;
    align-items: flex-start;
  }

  .upload-progress-header h4 {
    font-size: 14px;
  }

  .progress-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .file-name {
    margin-right: 0;
    max-width: 100%;
  }
}

@media (max-width: 480px) {
  .upload-progress-section {
    padding: 12px;
  }

  .upload-progress-item {
    padding: 12px;
  }

  .upload-progress-list {
    gap: 8px;
  }
}
</style>

