<template>
  <!-- Breadcrumb Navigation -->
  <div class="breadcrumb-nav">
    <RouterLink :to="`/products`" class="product-link">
      <span class="product-text">Sản phẩm</span>
    </RouterLink>
    <span class="breadcrumb-separator"> / </span>
    <router-link to="/products/add" class="product-link">
      <span class="product-text">Thêm sản phẩm</span>
    </router-link>
  </div>
  <div class="them-san-pham-page">
    <!-- Form Container -->
    <div class="form-container">
      <div class="form-card">
        <!-- Basic Information Section -->
        <div class="form-section">
          <div class="section-header">
            <h3>Thông tin cơ bản</h3>
          </div>
          <div class="section-content">
            <div class="product-form-grid">
              <div class="product-form-field ten-san-pham">
                <label class="modern-label">Tên sản phẩm *</label>
                <div class="input-with-dropdown">
                  <input
                    type="text"
                    v-model="productForm.tenSanPham"
                    class="modern-input"
                    placeholder="Nhập hoặc chọn tên sản phẩm"
                    @input="filterTenSanPham"
                    @focus="showTenSanPhamDropdown = true"
                    required
                  />
                  <div v-if="showTenSanPhamDropdown" class="dropdown-list">
                    <div
                      v-for="tenSanPham in filteredTenSanPhams"
                      :key="tenSanPham.id"
                      class="dropdown-item"
                      @click="selectTenSanPham(tenSanPham)"
                    >
                      {{ tenSanPham.tenSanPham }}
                    </div>
                    <div
                      v-if="
                        productForm.tenSanPham &&
                        !filteredTenSanPhams.find(
                          (item) =>
                            item.tenSanPham.toLowerCase() ===
                            productForm.tenSanPham.toLowerCase()
                        )
                      "
                      class="dropdown-item create-new"
                      @click="createNewTenSanPham"
                    >
                      Thêm mới "{{ productForm.tenSanPham }}"
                    </div>
                  </div>
                </div>
              </div>

              <!-- Các trường khác chia thành 2 cột -->
              <div class="other-fields">
                <div class="product-form-field nha-san-xuat">
                  <label class="modern-label">Nhà sản xuất *</label>
                  <div class="input-with-dropdown">
                    <input
                      type="text"
                      v-model="productForm.tenNhaSanXuat"
                      class="modern-input"
                      placeholder="Nhập hoặc chọn nhà sản xuất"
                      @input="filterNhaSanXuat"
                      @focus="showNhaSanXuatDropdown = true"
                    />
                    <div v-if="showNhaSanXuatDropdown" class="dropdown-list">
                      <div
                        v-for="nhaSanXuat in filteredNhaSanXuats"
                        :key="nhaSanXuat.id"
                        class="dropdown-item"
                        @click="selectNhaSanXuat(nhaSanXuat)"
                      >
                        {{ nhaSanXuat.tenNhaSanXuat }}
                      </div>
                      <div
                        v-if="
                          productForm.tenNhaSanXuat &&
                          !filteredNhaSanXuats.find(
                            (item) =>
                              item.tenNhaSanXuat.toLowerCase() ===
                              productForm.tenNhaSanXuat.toLowerCase()
                          )
                        "
                        class="dropdown-item create-new"
                        @click="createNewNhaSanXuat"
                      >
                        Thêm mới "{{ productForm.tenNhaSanXuat }}"
                      </div>
                    </div>
                  </div>
                </div>

                <div class="product-form-field xuat-xu">
                  <label class="modern-label">Xuất xứ *</label>
                  <div class="input-with-dropdown">
                    <input
                      type="text"
                      v-model="productForm.tenXuatXu"
                      class="modern-input"
                      placeholder="Nhập hoặc chọn xuất xứ"
                      @input="filterXuatXu"
                      @focus="showXuatXuDropdown = true"
                    />
                    <div v-if="showXuatXuDropdown" class="dropdown-list">
                      <div
                        v-for="xuatXu in filteredXuatXus"
                        :key="xuatXu.id"
                        class="dropdown-item"
                        @click="selectXuatXu(xuatXu)"
                      >
                        {{ xuatXu.tenXuatXu }}
                      </div>
                      <div
                        v-if="
                          productForm.tenXuatXu &&
                          !filteredXuatXus.find(
                            (item) =>
                              item.tenXuatXu.toLowerCase() ===
                              productForm.tenXuatXu.toLowerCase()
                          )
                        "
                        class="dropdown-item create-new"
                        @click="createNewXuatXu"
                      >
                        Thêm mới "{{ productForm.tenXuatXu }}"
                      </div>
                    </div>
                  </div>
                </div>

                <div class="product-form-field chat-lieu">
                  <label class="modern-label">Chất liệu *</label>
                  <div class="input-with-dropdown">
                    <input
                      type="text"
                      v-model="productForm.tenChatLieu"
                      class="modern-input"
                      placeholder="Nhập hoặc chọn chất liệu"
                      @input="filterChatLieu"
                      @focus="showChatLieuDropdown = true"
                    />
                    <div v-if="showChatLieuDropdown" class="dropdown-list">
                      <div
                        v-for="chatLieu in filteredChatLieus"
                        :key="chatLieu.id"
                        class="dropdown-item"
                        @click="selectChatLieu(chatLieu)"
                      >
                        {{ chatLieu.tenChatLieu }}
                      </div>
                      <div
                        v-if="
                          productForm.tenChatLieu &&
                          !filteredChatLieus.find(
                            (item) =>
                              item.tenChatLieu.toLowerCase() ===
                              productForm.tenChatLieu.toLowerCase()
                          )
                        "
                        class="dropdown-item create-new"
                        @click="createNewChatLieu"
                      >
                        Thêm mới "{{ productForm.tenChatLieu }}"
                      </div>
                    </div>
                  </div>
                </div>

                <div class="product-form-field de-giay">
                  <label class="modern-label">Đế giày *</label>
                  <div class="input-with-dropdown">
                    <input
                      type="text"
                      v-model="productForm.tenDeGiay"
                      class="modern-input"
                      placeholder="Nhập hoặc chọn đế giày"
                      @input="filterDeGiay"
                      @focus="showDeGiayDropdown = true"
                    />
                    <div v-if="showDeGiayDropdown" class="dropdown-list">
                      <div
                        v-for="deGiay in filteredDeGiays"
                        :key="deGiay.id"
                        class="dropdown-item"
                        @click="selectDeGiay(deGiay)"
                      >
                        {{ deGiay.tenDeGiay }}
                      </div>
                      <div
                        v-if="
                          productForm.tenDeGiay &&
                          !filteredDeGiays.find(
                            (item) =>
                              item.tenDeGiay.toLowerCase() ===
                              productForm.tenDeGiay.toLowerCase()
                          )
                        "
                        class="dropdown-item create-new"
                        @click="createNewDeGiay"
                      >
                        Thêm mới "{{ productForm.tenDeGiay }}"
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- Đóng div other-fields -->
            </div>
          </div>
        </div>

        <!-- Product Attributes Section -->
        <div class="form-section">
          <div class="section-header">
            <h3>Thuộc tính sản phẩm</h3>
          </div>
          <div class="section-content">
            <div class="product-form-grid">
              <div class="product-form-field">
                <div class="attribute-row">
                  <label class="modern-label">Màu sắc: *</label>
                  <span class="selected-attributes">
                    <span
                      v-for="(mauSac, index) in selectedMauSacs"
                      :key="index"
                      class="selected-attribute-tag color-tag"
                    >
                      <div class="color-preview" :style="{ backgroundColor: mauSac.maMau || '#000000' }"></div>
                      <div class="color-info">
                        <span class="color-name">{{ mauSac.tenMauSac }}</span>
                        <span class="color-hex">{{ mauSac.maMau || '#000000' }}</span>
                      </div>
                      <button
                        @click="removeMauSac(index)"
                        class="remove-attribute-btn"
                      >
                        ×
                      </button>
                    </span>
                  </span>
                  <button
                    @click="showMauSacPopup = true"
                    class="add-attribute-btn"
                    type="button"
                  >
                    <span class="add-icon">+</span>
                    Thêm màu sắc
                  </button>
                </div>
              </div>

              <div class="product-form-field">
                <div class="attribute-row">
                  <label class="modern-label">Kích thước: *</label>
                  <span class="selected-attributes">
                    <span
                      v-for="(kichThuoc, index) in selectedKichThuocs"
                      :key="index"
                      class="selected-attribute-tag"
                    >
                      {{ kichThuoc.tenKichThuoc }}
                      <button
                        @click="removeKichThuoc(index)"
                        class="remove-attribute-btn"
                      >
                        ×
                      </button>
                    </span>
                  </span>
                  <button
                    @click="showKichThuocPopup = true"
                    class="add-attribute-btn"
                    type="button"
                  >
                    <span class="add-icon">+</span>
                    Thêm kích thước
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product Variants Section -->
        <div class="form-section">
          <div class="section-header">
            <h3>Biến thể sản phẩm</h3>
          </div>
          <div class="section-content">
            <div class="variant-table-container">
              <div class="variant-header">
                <h4 class="variant-table-title">Biến thể sản phẩm</h4>
                <button
                  @click="showQuickAddPopup()"
                  class="btn-primary"
                  type="button"
                >
                  Thêm nhanh
                </button>
              </div>
              <div class="variant-table">
                <table>
                  <thead>
                    <tr>
                      <th width="20%">Màu sắc</th>
                      <th width="18%">Tên sản phẩm</th>
                      <th width="6%">Kích thước</th>
                      <th width="7%">Trọng lượng</th>
                      <th width="7%">Số lượng</th>
                      <th width="12%">Giá bán</th>
                      <th width="17%">Ảnh (0/5)</th>
                      <th width="11%">Thao tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    <!-- Hiển thị tất cả variants của tất cả màu -->
                    <template
                      v-for="(mauSac, mauIndex) in selectedMauSacs"
                      :key="`mau-${mauIndex}`"
                    >
                      <tr
                        v-for="(variant, variantIndex) in productVariants[
                          mauIndex
                        ] || []"
                        :key="`variant-${mauIndex}-${variantIndex}`"
                      >
                        <!-- Cột màu sắc -->
                        <td>
                          <span class="color-display" :title="mauSac.tenMauSac">
                            <div
                              class="color-indicator"
                              :style="{
                                backgroundColor: mauSac.maMau || '#000000',
                              }"
                              :title="`Màu: ${mauSac.tenMauSac}`"
                            ></div>
                            {{ mauSac.tenMauSac }}
                          </span>
                        </td>
                        <!-- Cột tên sản phẩm -->
                        <td>
                          <input
                            :value="
                              variant.tenSanPham || productForm.tenSanPham
                            "
                            type="text"
                            class="variant-input-s"
                            placeholder="Nhập tên sản phẩm"
                            readonly
                          />
                        </td>
                        <td>
                          <input
                            :value="variant.kichThuoc"
                            type="text"
                            class="variant-input-s"
                            placeholder="Nhập kích thước"
                            readonly
                          />
                        </td>
                        <td>
                          <input
                            :value="variant.trongLuong || ''"
                            @input="
                              updateVariantField(
                                mauIndex,
                                variantIndex,
                                'trongLuong',
                                $event.target.value
                              )
                            "
                            type="text"
                            class="variant-input"
                            placeholder="0"
                          />
                        </td>
                        <td>
                          <input
                            :value="variant.soLuong || 0"
                            @input="
                              updateVariantField(
                                mauIndex,
                                variantIndex,
                                'soLuong',
                                parseInt($event.target.value) || 0
                              )
                            "
                            type="number"
                            min="0"
                            class="variant-input"
                            placeholder="0"
                          />
                        </td>
                        <td>
                          <input
                            :value="variant.giaBan || 0"
                            @input="
                              updateVariantField(
                                mauIndex,
                                variantIndex,
                                'giaBan',
                                parseInt($event.target.value) || 0
                              )
                            "
                            type="number"
                            min="0"
                            step="1000"
                            class="variant-input"
                            placeholder="0"
                          />
                        </td>
                        <td>
                          <div class="variant-image-section">
                            <div class="image-preview-grid">
                              <div
                                v-for="(anh, anhIndex) in variant.anh || []"
                                :key="anhIndex"
                                class="image-preview-item"
                              >
                                <img
                                  :src="anh.url || getAnhUrl(anh)"
                                  alt="Ảnh sản phẩm"
                                  class="variant-thumbnail"
                                  @error="handleImageError($event, anh)"
                                />
                                <button
                                  @click="
                                    removeVariantImage(
                                      mauIndex,
                                      variantIndex,
                                      anhIndex
                                    )
                                  "
                                  class="remove-image-btn"
                                  type="button"
                                >
                                  ×
                                </button>
                              </div>
                              <div class="image-selection-info">
                                <span
                                  v-if="(variant.anh || []).length > 0"
                                  class="image-count-badge"
                                >
                                  {{ (variant.anh || []).length }}/5 ảnh
                                </span>
                                <button
                                  v-if="(variant.anh || []).length < 5"
                                  @click="
                                    selectVariantImage(mauIndex, variantIndex)
                                  "
                                  class="add-image-btn"
                                  type="button"
                                >
                                  <span class="add-icon">+</span>
                                  {{
                                    (variant.anh || []).length > 0
                                      ? "Thêm ảnh"
                                      : "Chọn ảnh"
                                  }}
                                </button>
                              </div>
                            </div>
                          </div>
                        </td>
                        <td>
                          <button
                            @click="removeVariant(mauIndex, variantIndex)"
                            class="remove-variant-btn"
                            type="button"
                          >
                            Xóa
                          </button>
                        </td>
                      </tr>
                    </template>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Form Actions -->
        <div class="form-actions">
          <button
            type="button"
            class="btn-outline"
            @click="confirmCreateProduct"
          >
            Tạo sản phẩm
          </button>
        </div>
      </div>
    </div>

    <!-- Confirm Modal -->
    <div
      v-if="showConfirmModal"
      class="confirm-modal-overlay"
      @click="closeConfirmModal"
    >
      <div class="confirm-modal-content" @click.stop>
        <div class="confirm-header">
          <h3>{{ confirmTitle }}</h3>
        </div>
        <div class="confirm-body">
          <p>{{ confirmMessage }}</p>
        </div>
        <div class="confirm-actions">
          <button class="btn-outline" @click="closeConfirmModal">Hủy</button>
          <button class="btn-primary" @click="confirmAction">Xác nhận</button>
        </div>
      </div>
    </div>

    <!-- Success Notification - Không còn sử dụng, thay bằng popup thông báo bên phải -->
    <!--
    <div
      v-if="showSuccessModal"
      class="success-modal-overlay"
      @click="closeSuccessModal"
    >
      <div class="success-modal-content" @click.stop>
        <div class="success-icon">
          <svg width="64" height="64" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
          </svg>
        </div>
        <div class="success-content">
          <h2 class="success-title">Thành công!</h2>
          <p class="success-message">{{ successMessage }}</p>
        </div>
        <div class="success-actions">
          <div class="auto-redirect-notice">
            <div class="redirect-spinner"></div>
            <span>Đang chuyển hướng đến trang chi tiết sản phẩm...</span>
          </div>
        </div>
      </div>
    </div>
    -->

    <!-- Popup chọn màu sắc -->
    <div
      v-if="showMauSacPopup"
      class="attribute-popup-overlay"
      @click="closeMauSacPopup"
    >
      <div class="attribute-popup-content" @click.stop>
        <div class="attribute-popup-header">
          <h3>Chọn màu sắc</h3>
          <button @click="closeMauSacPopup" class="attribute-close-btn">
            ×
          </button>
        </div>
        <div class="attribute-popup-body">
          <div class="attribute-search-section">
            <input
              v-model="mauSacSearch"
              type="text"
              placeholder="Tìm kiếm màu sắc..."
              class="attribute-search-input"
            />
          </div>
          <div class="attribute-existing-attributes">
            <h4>Màu sắc có sẵn</h4>
            <div class="attribute-list">
              <div
                v-for="mauSac in filteredMauSacsForPopup"
                :key="mauSac.id"
                class="attribute-item color-attribute-item"
                :class="{ selected: isMauSacSelected(mauSac) }"
                @click="selectMauSacFromPopup(mauSac)"
              >
                <div class="color-preview" :style="{ backgroundColor: mauSac.maMau || '#000000' }"></div>
                <span class="color-name">{{ mauSac.tenMauSac }}</span>
                <span
                  v-if="isMauSacSelected(mauSac)"
                  class="attribute-checkmark"
                  ><!-- icon: checkmark --></span
                >
              </div>
            </div>
          </div>
          <div class="attribute-create-new-section">
            <h4>Tạo màu sắc mới</h4>
            <div class="attribute-create-new-form">
              <div class="form-row">
                <div class="form-group">
                  <label>Tên màu sắc:</label>
                  <input
                    v-model="newMauSacName"
                    type="text"
                    placeholder="Nhập tên màu sắc mới"
                    class="attribute-create-new-input"
                  />
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label>Mã màu HEX:</label>
                  <div class="color-input-group">
                    <input
                      v-model="newMauSacColor"
                      type="color"
                      class="color-picker"
                      @input="updateNewMauSacName"
                    />
                    <input
                      v-model="newMauSacColor"
                      type="text"
                      placeholder="#000000"
                      class="attribute-create-new-input color-text-input"
                      @input="updateNewMauSacColor"
                    />
                  </div>
                </div>
              </div>
              <div class="form-actions">
                <button
                  @click="createNewMauSacFromPopup"
                  class="attribute-create-new-btn"
                  type="button"
                >
                  Tạo mới
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Popup chọn kích thước -->
    <div
      v-if="showKichThuocPopup"
      class="attribute-popup-overlay"
      @click="closeKichThuocPopup"
    >
      <div class="attribute-popup-content" @click.stop>
        <div class="attribute-popup-header">
          <h3>Chọn kích thước</h3>
          <button @click="closeKichThuocPopup" class="attribute-close-btn">
            ×
          </button>
        </div>
        <div class="attribute-popup-body">
          <div class="attribute-search-section">
            <input
              v-model="kichThuocSearch"
              type="text"
              placeholder="Tìm kiếm kích thước..."
              class="attribute-search-input"
            />
          </div>
          <div class="attribute-existing-attributes">
            <h4>Kích thước có sẵn</h4>
            <div class="attribute-list">
              <div
                v-for="kichThuoc in filteredKichThuocsForPopup"
                :key="kichThuoc.id"
                class="attribute-item"
                :class="{ selected: isKichThuocSelected(kichThuoc) }"
                @click="selectKichThuocFromPopup(kichThuoc)"
              >
                <span
                  v-if="isKichThuocSelected(kichThuoc)"
                  class="attribute-checkmark"
                  ><!-- icon: checkmark --></span
                >
                {{ kichThuoc.tenKichThuoc }}
              </div>
            </div>
          </div>
          <div class="attribute-create-new-section">
            <h4>Tạo kích thước mới</h4>
            <div class="attribute-create-new-form">
              <input
                v-model="newKichThuocName"
                type="text"
                placeholder="Nhập tên kích thước mới"
                class="attribute-create-new-input"
              />
              <button
                @click="createNewKichThuocFromPopup"
                class="attribute-create-new-btn"
                type="button"
              >
                Tạo mới
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Popup thêm nhanh biến thể -->
    <div
      v-if="showQuickAddModal"
      class="popup-overlay"
      @click="closeQuickAddModal"
    >
      <div class="popup-content quick-edit-popup" @click.stop>
        <div class="popup-header">
          <h3>Thêm nhanh cho tất cả biến thể</h3>
          <button @click="closeQuickAddModal" class="close-btn">×</button>
        </div>
        <div class="popup-body">
          <div class="quick-edit-form">
            <div class="form-field">
              <label class="form-label">Trọng lượng:</label>
              <input
                v-model="quickAddForm.trongLuong"
                type="text"
                class="form-input"
                placeholder="Nhập trọng lượng"
              />
            </div>
            <div class="form-field">
              <label class="form-label">Số lượng:</label>
              <input
                v-model="quickAddForm.soLuong"
                type="number"
                min="0"
                class="form-input"
                placeholder="0"
              />
            </div>
            <div class="form-field">
              <label class="form-label">Giá bán:</label>
              <input
                v-model="quickAddForm.giaBan"
                type="number"
                min="0"
                step="1000"
                class="form-input"
                placeholder="0"
              />
            </div>
          </div>
        </div>
        <div class="popup-footer">
          <button @click="closeQuickAddModal" class="btn-outline">Đóng</button>
          <button @click="applyQuickAdd" class="btn-primary">Áp dụng</button>
        </div>
      </div>
    </div>

    <!-- Popup confirm xóa biến thể -->
    <div
      v-if="showDeleteConfirmModal"
      class="popup-overlay"
      @click="closeDeleteConfirmModal"
    >
      <div class="popup-content delete-confirm-popup" @click.stop>
        <div class="popup-header">
          <h3>Xác nhận xóa</h3>
          <button @click="closeDeleteConfirmModal" class="close-btn">×</button>
        </div>
        <div class="popup-body">
          <p class="confirm-message">
            Bạn có chắc muốn xóa biến thể sản phẩm này không?
          </p>
          <p class="variant-info">
            {{ deleteConfirmInfo }}
          </p>
        </div>
        <div class="popup-footer">
          <button @click="closeDeleteConfirmModal" class="btn-outline">
            Hủy
          </button>
          <button @click="confirmDeleteVariant" class="btn-danger">Xóa</button>
        </div>
      </div>
    </div>

    <!-- Popup thông báo bên phải - hỗ trợ nhiều thông báo -->
    <div
      v-if="notificationPositions.length > 0"
      class="notification-popup-overlay"
    >
      <div
        v-for="notification in notificationPositions"
        :key="notification.id"
        class="notification-popup-content"
        :class="[
          `notification-${notification.type}`,
          { 'notification-closing': notification.isClosing },
          { 'clickable': notification.productId }
        ]"
        :style="{ top: `${notification.top}px`, transition: 'top 0.3s ease' }"
        @click="notification.productId ? goToProductDetail(notification.productId) : null"
      >
        <div class="notification-header">
          <h4>{{ notification.title }}</h4>
          <button
            @click="closeNotificationPopup(notification.id)"
            class="notification-close-btn"
          >
            ×
          </button>
        </div>
        <div class="notification-body">
          <p>{{ notification.message }}</p>
          <p v-if="notification.productId" class="click-hint">
            👆 Click để xem chi tiết sản phẩm
          </p>
        </div>
      </div>
    </div>

    <!-- Loading Popup -->
    <div v-if="isCreatingProduct" class="loading-popup-overlay">
      <div class="loading-popup-content">
        <div class="loading-spinner"></div>
        <h3>Vui lòng chờ hệ thống xử lý</h3>
        <p>Đang tạo sản phẩm và các biến thể...</p>
      </div>
    </div>

    <!-- Popup chọn ảnh -->
    <div v-if="showAnhPopup" class="popup-overlay" @click="closeAnhPopup">
      <div class="popup-content anh-popup" @click.stop>
        <div class="popup-header">
          <h3>Thêm ảnh sản phẩm</h3>
          <div class="popup-header-actions">
            <button @click="closeAnhPopup" class="close-btn">×</button>
          </div>
        </div>
        <div class="popup-body">
          <!-- Title row -->
          <div class="anh-title-row">
            <h4>Ảnh có sẵn</h4>
            <button
              @click="$refs.fileInput.click()"
              class="btn-outline"
              type="button"
            >
              Thêm ảnh
            </button>
          </div>

          <!-- Content row -->
          <div class="anh-content-row">
            <!-- Phần ảnh từ database -->
            <div class="anh-database-section">
              <div class="anh-grid">
                <div
                  v-for="anh in filteredAnhSanPhams"
                  :key="anh.id"
                  class="anh-item"
                  :class="{ selected: isAnhSelected(anh) }"
                  @click="selectAnhFromDatabase(anh)"
                >
                  <img
                    :src="getAnhUrl(anh)"
                    :alt="getAnhName(anh)"
                    class="anh-thumbnail"
                    @error="handleImageError($event, anh)"
                  />
                  <div class="anh-overlay">
                    <span v-if="isAnhSelected(anh)" class="checkmark"
                      ><!-- icon: checkmark --></span
                    >
                  </div>
                  <div class="anh-name">{{ getAnhName(anh) }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Hidden file input -->
          <input
            ref="fileInput"
            type="file"
            multiple
            accept="image/*"
            @change="handleFileSelect"
            class="file-input"
          />

          <!-- Hiển thị ảnh đã chọn -->
          <div class="selected-anh-display">
            <h4>Ảnh đã chọn:</h4>
            <div class="selected-anh-grid">
              <!-- Ảnh từ database -->
              <div
                v-for="anh in selectedAnhFromDatabase"
                :key="anh.id"
                class="selected-anh-item"
              >
                <img
                  :src="getAnhUrl(anh)"
                  :alt="getAnhName(anh)"
                  class="selected-anh-thumbnail"
                  @error="handleImageError($event, anh)"
                />
                <span class="selected-anh-name">{{ getAnhName(anh) }}</span>
              </div>
              <!-- Ảnh từ file -->
              <div
                v-for="(file, index) in selectedAnhFromFile"
                :key="`file-${index}`"
                class="selected-anh-item"
              >
                <img
                  :src="getFileUrl(file)"
                  :alt="file.name"
                  class="selected-anh-thumbnail"
                />
                <span class="selected-anh-name">{{ file.name }}</span>
              </div>
            </div>
          </div>
        </div>
        <div class="popup-footer">
          <!-- Thông tin ảnh đã chọn -->
          <div class="selected-anh-info">
            <h4>Ảnh đã chọn ({{ getTotalSelectedAnhCount() }}/5)</h4>
            <div class="selected-anh-summary">
              <span v-if="selectedAnhFromDatabase.length > 0">
                Từ database: {{ selectedAnhFromDatabase.length }} ảnh
              </span>
              <span v-if="selectedAnhFromFile.length > 0">
                Từ máy: {{ selectedAnhFromFile.length }} ảnh
              </span>
            </div>
          </div>
          <button @click="cancelAnhSelection" class="btn-outline">Hủy</button>
          <button @click="closeAnhPopup" class="btn-outline">Đóng</button>
          <button @click="applyAnhSelection" class="btn-primary">
            Áp dụng
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { fetchCreateChiTietSanPham } from "../../../services/SanPham/ChiTietSanPhamService";
import {
  fetchAllSanPham,
  fetchCreateSanPham,
} from "../../../services/SanPham/SanPhamService";
import {
  fetchAllAnhSanPham,
  fetchCreateAnhSanPhamFromCloud,
} from "../../../services/ThuocTinh/AnhSanPhamService";
import {
  fetchAllChatLieu,
  fetchCreateChatLieu,
} from "../../../services/ThuocTinh/ChatLieuService";
import { fetchCreateMultipleChiTietSanPhamAnh } from "../../../services/ThuocTinh/ChiTietSanPhamAnhService";
import {
  fetchAllDeGiay,
  fetchCreateDeGiay,
} from "../../../services/ThuocTinh/DeGiayService";
import {
  fetchAllKichThuoc,
  fetchCreateKichThuoc,
} from "../../../services/ThuocTinh/KichThuocService";
import {
  fetchAllMauSac,
  fetchCreateMauSac,
} from "../../../services/ThuocTinh/MauSacService";
import {
  fetchAllNhaSanXuat,
  fetchCreateNhaSanXuat,
} from "../../../services/ThuocTinh/NhaSanXuatService";
import {
  fetchAllTrongLuong,
  fetchCreateTrongLuong,
} from "../../../services/ThuocTinh/TrongLuongService";
import {
  fetchAllXuatXu,
  fetchCreateXuatXu,
} from "../../../services/ThuocTinh/XuatXuService";

const router = useRouter();
// Success modal - Không còn sử dụng, thay bằng popup thông báo bên phải
// const showSuccessModal = ref(false);
// const successMessage = ref("");
const createdProductId = ref(null);

// Confirm modal variables
const showConfirmModal = ref(false);
const confirmTitle = ref("");
const confirmMessage = ref("");
const onConfirmCallback = ref(null);
const productForm = ref({
  tenSanPham: "",
  tenNhaSanXuat: "",
  tenXuatXu: "",
  tenChatLieu: "",
  tenDeGiay: "",
  trangThai: true,
  deleted: false,
});

// Data cho các thuộc tính
const nhaSanXuats = ref([]);
const xuatXus = ref([]);
const chatLieus = ref([]);
const deGiays = ref([]);
const mauSacs = ref([]);
const kichThuocs = ref([]);
const tenSanPhams = ref([]);
const anhSanPhams = ref([]);
const trongLuongs = ref([]);

// Dropdown states
const showNhaSanXuatDropdown = ref(false);
const showXuatXuDropdown = ref(false);
const showChatLieuDropdown = ref(false);
const showDeGiayDropdown = ref(false);
const showTenSanPhamDropdown = ref(false);

// Popup states
const showMauSacPopup = ref(false);
const showKichThuocPopup = ref(false);
const showAnhPopup = ref(false);

// Selected attributes
const selectedMauSacs = ref([]);
const selectedKichThuocs = ref([]);

// Selected product from dropdown (for adding variants to existing product)
const selectedProductFromDropdown = ref(null);

// Data cho ảnh sản phẩm
const currentEditingVariant = ref({ mauIndex: -1, kichIndex: -1 });
const selectedAnhFromDatabase = ref([]);
const selectedAnhFromFile = ref([]);

// Lưu trữ trạng thái ảnh đã chọn cho từng biến thể
const variantImageSelections = ref(new Map()); // key: "mauIndex-kichIndex", value: {database: [], files: []}

// Function to update variant field safely
const updateVariantField = (mauIndex, variantIndex, field, value) => {
  const variant = productVariants.value[mauIndex]?.[variantIndex];
  if (variant) {
    variant[field] = value;
  }
};

// Search for popups
const mauSacSearch = ref("");
const kichThuocSearch = ref("");
const anhSearch = ref("");

// Input values for attributes
const mauSacInput = ref("");
const kichThuocInput = ref("");

// New attribute names
const newMauSacName = ref("");
const newMauSacColor = ref("#000000");
const newKichThuocName = ref("");
const newAnhName = ref("");

// Functions để xóa thuộc tính
const removeMauSac = (index) => {
  selectedMauSacs.value.splice(index, 1);
};

const removeKichThuoc = (index) => {
  selectedKichThuocs.value.splice(index, 1);
};

// Functions để kiểm tra thuộc tính đã chọn
const isMauSacSelected = (mauSac) => {
  return selectedMauSacs.value.some((item) => item.id === mauSac.id);
};

const isKichThuocSelected = (kichThuoc) => {
  return selectedKichThuocs.value.some((item) => item.id === kichThuoc.id);
};

// Function kiểm tra ảnh đã chọn
const isAnhSelected = (anh) => {
  return selectedAnhFromDatabase.value.some((item) => item.id === anh.id);
};

// Function chọn ảnh từ database (alias cho toggleAnhFromDatabase)
const selectAnhFromDatabase = (anh) => {
  toggleAnhFromDatabase(anh);
};

// Product variants
const productVariants = ref([]);
const editingVariants = ref(new Set());

const resetForm = () => {
  productForm.value = {
    tenSanPham: "",
    tenNhaSanXuat: "",
    tenXuatXu: "",
    tenChatLieu: "",
    tenDeGiay: "",
    trangThai: true,
    deleted: false,
  };

  // Reset dropdown states
  showTenSanPhamDropdown.value = false;
  showNhaSanXuatDropdown.value = false;
  showXuatXuDropdown.value = false;
  showChatLieuDropdown.value = false;
  showDeGiayDropdown.value = false;

  // Reset selected product from dropdown
  selectedProductFromDropdown.value = null;

  selectedMauSacs.value = [];
  selectedKichThuocs.value = [];
  productVariants.value = [];

  // Reset quick add modal
  showQuickAddModal.value = false;
  currentEditingMauIndex.value = null;
  quickAddForm.value = {
    trongLuong: "",
    soLuong: 0,
    giaBan: 0,
  };

  mauSacSearch.value = "";
  kichThuocSearch.value = "";
  anhSearch.value = "";
  newMauSacName.value = "";
  newKichThuocName.value = "";
  newAnhName.value = "";
};

// Computed properties cho việc filter
const filteredTenSanPhams = computed(() => {
  if (!productForm.value.tenSanPham) return tenSanPhams.value;
  return tenSanPhams.value.filter((item) =>
    item.tenSanPham
      .toLowerCase()
      .includes(productForm.value.tenSanPham.toLowerCase())
  );
});

const filteredNhaSanXuats = computed(() => {
  if (!productForm.value.tenNhaSanXuat) return nhaSanXuats.value;
  return nhaSanXuats.value.filter((item) =>
    item.tenNhaSanXuat
      .toLowerCase()
      .includes(productForm.value.tenNhaSanXuat.toLowerCase())
  );
});

const filteredXuatXus = computed(() => {
  if (!productForm.value.tenXuatXu) return xuatXus.value;
  return xuatXus.value.filter((item) =>
    item.tenXuatXu
      .toLowerCase()
      .includes(productForm.value.tenXuatXu.toLowerCase())
  );
});

const filteredChatLieus = computed(() => {
  if (!productForm.value.tenChatLieu) return chatLieus.value;
  return chatLieus.value.filter((item) =>
    item.tenChatLieu
      .toLowerCase()
      .includes(productForm.value.tenChatLieu.toLowerCase())
  );
});

const filteredDeGiays = computed(() => {
  if (!productForm.value.tenDeGiay) return deGiays.value;
  return deGiays.value.filter((item) =>
    item.tenDeGiay
      .toLowerCase()
      .includes(productForm.value.tenDeGiay.toLowerCase())
  );
});

// Computed properties cho popup
const filteredMauSacsForPopup = computed(() => {
  if (!mauSacSearch.value) return mauSacs.value;
  return mauSacs.value.filter((item) =>
    item.tenMauSac.toLowerCase().includes(mauSacSearch.value.toLowerCase())
  );
});

const filteredKichThuocsForPopup = computed(() => {
  if (!kichThuocSearch.value) return kichThuocs.value;
  return kichThuocs.value.filter((item) =>
    item.tenKichThuoc
      .toLowerCase()
      .includes(kichThuocSearch.value.toLowerCase())
  );
});

const filteredAnhSanPhams = computed(() => {
  if (!anhSearch.value) return anhSanPhams.value;
  return anhSanPhams.value.filter((item) =>
    item.tenAnh.toLowerCase().includes(anhSearch.value.toLowerCase())
  );
});

// Fetch data cho các thuộc tính
const fetchTenSanPham = async () => {
  try {
    const response = await fetchAllSanPham();
    tenSanPhams.value = response.data || [];
  } catch (error) {
    console.error("Error fetching ten san pham:", error);
  }
};

const fetchNhaSanXuat = async () => {
  try {
    const response = await fetchAllNhaSanXuat();
    nhaSanXuats.value = response.data || [];
  } catch (error) {
    console.error("Error fetching nha san xuat:", error);
  }
};

const fetchXuatXu = async () => {
  try {
    const response = await fetchAllXuatXu();
    xuatXus.value = response.data || [];
  } catch (error) {
    console.error("Error fetching xuat xu:", error);
  }
};

const fetchMauSac = async () => {
  try {
    const response = await fetchAllMauSac();
    mauSacs.value = response.data || [];
  } catch (error) {
    console.error("Error fetching mau sac:", error);
  }
};

const fetchKichThuoc = async () => {
  try {
    const response = await fetchAllKichThuoc();
    kichThuocs.value = response.data || [];
  } catch (error) {
    console.error("Error fetching kich thuoc:", error);
  }
};

const fetchChatLieu = async () => {
  try {
    const response = await fetchAllChatLieu();
    chatLieus.value = response.data || [];
  } catch (error) {
    console.error("Error fetching chat lieu:", error);
  }
};

const fetchDeGiay = async () => {
  try {
    const response = await fetchAllDeGiay();
    deGiays.value = response.data || [];
  } catch (error) {
    console.error("Error fetching de giay:", error);
  }
};

const fetchTrongLuong = async () => {
  try {
    const response = await fetchAllTrongLuong();
    trongLuongs.value = response.data || [];
  } catch (error) {
    console.error("Error fetching trong luong:", error);
  }
};

const fetchAnhSanPham = async () => {
  try {
    const response = await fetchAllAnhSanPham();

    // Xử lý response format
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
    console.error("Error fetching anh san pham:", error);
  }
};

// Initialize product variants when attributes change
const initializeProductVariants = () => {
  productVariants.value = [];

  for (let i = 0; i < selectedMauSacs.value.length; i++) {
    productVariants.value[i] = [];
    for (let j = 0; j < selectedKichThuocs.value.length; j++) {
      productVariants.value[i][j] = {
        tenSanPham: productForm.value.tenSanPham,
        kichThuoc: selectedKichThuocs.value[j].tenKichThuoc,
        trongLuong: "",
        soLuong: 0,
        giaBan: 0,
        anh: [],
        trangThai: true,
        deleted: false,
      };
    }
  }
};

// Watch for changes in selected attributes
watch(
  [selectedMauSacs, selectedKichThuocs],
  () => {
    initializeProductVariants();
  },
  { deep: true }
);

// Filter functions
const filterTenSanPham = () => {
  showTenSanPhamDropdown.value = true;
};

const filterNhaSanXuat = () => {
  showNhaSanXuatDropdown.value = true;
};

const filterXuatXu = () => {
  showXuatXuDropdown.value = true;
};

const filterChatLieu = () => {
  showChatLieuDropdown.value = true;
};

const filterDeGiay = () => {
  showDeGiayDropdown.value = true;
};

// Select functions
const selectTenSanPham = (tenSanPham) => {
  productForm.value.tenSanPham = tenSanPham.tenSanPham;
  selectedProductFromDropdown.value = { ...tenSanPham }; // Lưu toàn bộ thông tin sản phẩm được chọn
  showTenSanPhamDropdown.value = false;
};

const selectNhaSanXuat = (nhaSanXuat) => {
  productForm.value.tenNhaSanXuat = nhaSanXuat.tenNhaSanXuat;
  showNhaSanXuatDropdown.value = false;
};

const selectXuatXu = (xuatXu) => {
  productForm.value.tenXuatXu = xuatXu.tenXuatXu;
  showXuatXuDropdown.value = false;
};

const selectChatLieu = (chatLieu) => {
  productForm.value.tenChatLieu = chatLieu.tenChatLieu;
  showChatLieuDropdown.value = false;
};

const selectDeGiay = (deGiay) => {
  productForm.value.tenDeGiay = deGiay.tenDeGiay;
  showDeGiayDropdown.value = false;
};

// Create new functions
const createNewTenSanPham = async () => {
  // Chỉ đóng dropdown và để tên sản phẩm trong form
  // Việc tạo sản phẩm mới sẽ được xử lý khi nhấn nút "Thêm sản phẩm"
  selectedProductFromDropdown.value = null; // Reset vì tạo sản phẩm mới
  showTenSanPhamDropdown.value = false;
};

const createNewNhaSanXuat = async () => {
  // Chỉ đóng dropdown và để tên nhà sản xuất trong form
  // Việc tạo nhà sản xuất mới sẽ được xử lý khi nhấn nút "Thêm sản phẩm"
  showNhaSanXuatDropdown.value = false;
};

const createNewXuatXu = async () => {
  // Chỉ đóng dropdown và để tên xuất xứ trong form
  // Việc tạo xuất xứ mới sẽ được xử lý khi nhấn nút "Thêm sản phẩm"
  showXuatXuDropdown.value = false;
};

const createNewChatLieu = async () => {
  // Chỉ đóng dropdown và để tên chất liệu trong form
  // Việc tạo chất liệu mới sẽ được xử lý khi nhấn nút "Thêm sản phẩm"
  showChatLieuDropdown.value = false;
};

const createNewDeGiay = async () => {
  // Chỉ đóng dropdown và để tên đế giày trong form
  // Việc tạo đế giày mới sẽ được xử lý khi nhấn nút "Thêm sản phẩm"
  showDeGiayDropdown.value = false;
};

// Popup functions
const closeMauSacPopup = () => {
  showMauSacPopup.value = false;
  mauSacSearch.value = "";
  newMauSacName.value = "";
  newMauSacColor.value = "#000000";
};

const closeKichThuocPopup = () => {
  showKichThuocPopup.value = false;
  kichThuocSearch.value = "";
  newKichThuocName.value = "";
};

const selectMauSacFromPopup = (mauSac) => {
  const existingIndex = selectedMauSacs.value.findIndex(
    (item) => item.id === mauSac.id
  );
  if (existingIndex === -1) {
    // Nếu chưa có thì thêm vào với mã HEX tự động
    const mauSacWithHex = {
      ...mauSac,
      maMau: mauSac.maMau || getColorFromName(mauSac.tenMauSac)
    };
    selectedMauSacs.value.push(mauSacWithHex);
  } else {
    // Nếu đã có thì xóa khỏi danh sách (bỏ tích)
    selectedMauSacs.value.splice(existingIndex, 1);
  }
  // Không đóng popup để có thể chọn/bỏ chọn nhiều
};

const selectKichThuocFromPopup = (kichThuoc) => {
  const existingIndex = selectedKichThuocs.value.findIndex(
    (item) => item.id === kichThuoc.id
  );
  if (existingIndex === -1) {
    // Nếu chưa có thì thêm vào
    selectedKichThuocs.value.push(kichThuoc);
  } else {
    // Nếu đã có thì xóa khỏi danh sách (bỏ tích)
    selectedKichThuocs.value.splice(existingIndex, 1);
  }
  // Không đóng popup để có thể chọn/bỏ chọn nhiều
};

// Hàm cập nhật tên màu khi chọn màu từ color picker
const updateNewMauSacName = () => {
  // Có thể thêm logic để tự động đặt tên màu dựa trên mã hex
  // Ví dụ: #FF0000 -> "Đỏ", #000000 -> "Đen"
};

// Hàm cập nhật color picker khi nhập mã màu
const updateNewMauSacColor = () => {
  // Validate mã màu hex
  if (!newMauSacColor.value.startsWith('#')) {
    newMauSacColor.value = '#' + newMauSacColor.value;
  }
};

const createNewMauSacFromPopup = async () => {
  if (!newMauSacName.value.trim()) {
    showAlert("Thiếu thông tin", "Vui lòng nhập tên màu sắc!", "error");
    return;
  }

  if (!newMauSacColor.value.trim()) {
    showAlert("Thiếu thông tin", "Vui lòng chọn hoặc nhập mã màu!", "error");
    return;
  }

  // Tạo màu sắc mới tạm thời chỉ để sử dụng trong form
  // Việc tạo thực sự sẽ được xử lý khi nhấn nút "Thêm sản phẩm"
  const newMauSac = {
    id: null, // Chưa có ID vì chưa tạo trong DB
    tenMauSac: newMauSacName.value,
    maMau: newMauSacColor.value,
    trangThai: true,
    deleted: false,
  };

  // Thêm vào danh sách đã chọn
  if (
    !selectedMauSacs.value.find(
      (item) => item.tenMauSac === newMauSac.tenMauSac
    )
  ) {
    selectedMauSacs.value.push(newMauSac);
  }
  closeMauSacPopup();
};

const createNewKichThuocFromPopup = async () => {
  if (!newKichThuocName.value.trim()) {
    showAlert("Thiếu thông tin", "Vui lòng nhập tên kích thước!", "error");
    return;
  }

  // Tạo kích thước mới tạm thời chỉ để sử dụng trong form
  // Việc tạo thực sự sẽ được xử lý khi nhấn nút "Thêm sản phẩm"
  const newKichThuoc = {
    id: null, // Chưa có ID vì chưa tạo trong DB
    tenKichThuoc: newKichThuocName.value,
    trangThai: true,
    deleted: false,
  };

  // Thêm vào danh sách đã chọn
  if (
    !selectedKichThuocs.value.find(
      (item) => item.tenKichThuoc === newKichThuoc.tenKichThuoc
    )
  ) {
    selectedKichThuocs.value.push(newKichThuoc);
  }
  closeKichThuocPopup();
};

// Quick add modal state
const showQuickAddModal = ref(false);
const showDeleteConfirmModal = ref(false);
const currentEditingMauIndex = ref(null);

// Notification popup state - multiple notifications support
const notifications = ref([]);
let notificationId = 0;
const windowWidth = ref(
  typeof window !== "undefined" ? window.innerWidth : 1024
);

// Computed để tính vị trí cho mỗi thông báo
const notificationPositions = computed(() => {
  return notifications.value.map((notification, index) => {
    // Lấy baseTop dựa trên screen size
    let baseTop = 90; // Desktop default
    if (windowWidth.value <= 480) {
      baseTop = 80;
    } else if (windowWidth.value <= 768) {
      baseTop = 100;
    }
    return {
      ...notification,
      top: baseTop + index * 120,
    };
  });
});
const quickAddForm = ref({
  trongLuong: "",
  soLuong: 0,
  giaBan: 0,
});

// Data cho popup confirm xóa
const deleteConfirmInfo = ref("");
const deleteConfirmData = ref({ mauIndex: -1, kichIndex: -1 });

// Loading state cho việc thêm sản phẩm
const isCreatingProduct = ref(false);

// Variant management functions

// Quick add functions
const showQuickAddPopup = () => {
  currentEditingMauIndex.value = null; // Không cần mauIndex cụ thể

  // Reset form về giá trị trống để user nhập mới
  quickAddForm.value = {
    trongLuong: "",
    soLuong: 0,
    giaBan: 0,
  };

  showQuickAddModal.value = true;
};

// Function để map tên màu sang màu CSS
const getColorFromName = (tenMau) => {
  if (!tenMau) return "#6b7280"; // Màu xám mặc định

  const mauLower = tenMau.toLowerCase().trim();

  // Map màu phổ biến - mở rộng danh sách
  const colorMap = {
    // Màu cơ bản
    "đỏ": "#FF0000",
    "red": "#FF0000",
    "xanh": "#0000FF", 
    "blue": "#0000FF",
    "xanh dương": "#0000FF",
    "đen": "#000000",
    "black": "#000000",
    "trắng": "#FFFFFF",
    "white": "#FFFFFF",
    "vàng": "#FFFF00",
    "yellow": "#FFFF00",
    "tím": "#800080",
    "purple": "#800080",
    "hồng": "#FFC0CB",
    "pink": "#FFC0CB",
    "cam": "#FFA500",
    "orange": "#FFA500",
    "xám": "#808080",
    "gray": "#808080",
    "grey": "#808080",
    "nâu": "#A52A2A",
    "brown": "#A52A2A",
    
    // Màu bổ sung
    "xanh lá": "#00FF00",
    "green": "#00FF00",
    "xanh lá cây": "#00FF00",
    "xanh mint": "#98FB98",
    "mint": "#98FB98",
    "xanh navy": "#000080",
    "navy": "#000080",
    "bạc": "#C0C0C0",
    "silver": "#C0C0C0",
    "vàng gold": "#FFD700",
    "gold": "#FFD700",
    "be": "#F5F5DC",
    "cream": "#F5F5DC",
    "kem": "#F5F5DC",
    
    // Màu pastel
    "hồng pastel": "#FFB6C1",
    "xanh pastel": "#87CEEB",
    "vàng pastel": "#FFFFE0",
    "tím pastel": "#DDA0DD",
    
    // Màu khác
    "xanh ngọc": "#00CED1",
    "turquoise": "#00CED1",
    "xanh rêu": "#8FBC8F",
    "olive": "#808000",
    "xanh olive": "#808000",
    "đỏ đậm": "#8B0000",
    "maroon": "#8B0000",
    "tím đậm": "#4B0082",
    "indigo": "#4B0082",
  };

  return colorMap[mauLower] || "#6b7280"; // Trả về màu xám nếu không tìm thấy
};

const closeQuickAddModal = () => {
  showQuickAddModal.value = false;
  currentEditingMauIndex.value = null;
  quickAddForm.value = {
    trongLuong: "",
    soLuong: 0,
    giaBan: 0,
  };
};

const applyQuickAdd = () => {
  // Áp dụng giá trị cho TẤT CẢ biến thể của TẤT CẢ màu sắc
  for (let mauIndex = 0; mauIndex < selectedMauSacs.value.length; mauIndex++) {
    const variants = productVariants.value[mauIndex] || [];
    for (let variantIndex = 0; variantIndex < variants.length; variantIndex++) {
      const variant = variants[variantIndex];
      if (variant) {
        // Chỉ cập nhật nếu user đã nhập giá trị (không để trống)
        if (quickAddForm.value.trongLuong.trim()) {
          variant.trongLuong = quickAddForm.value.trongLuong;
        }
        if (quickAddForm.value.soLuong > 0) {
          variant.soLuong = quickAddForm.value.soLuong;
        }
        if (quickAddForm.value.giaBan > 0) {
          variant.giaBan = quickAddForm.value.giaBan;
        }
      }
    }
  }

  closeQuickAddModal();
};

// Image management functions
const selectVariantImage = (mauIndex, variantIndex) => {
  const variant = productVariants.value[mauIndex]?.[variantIndex];

  if (!variant) {
    console.log("❌ Không tìm thấy variant để chọn ảnh");
    return;
  }

  // Tìm kichIndex tương ứng trong selectedKichThuocs
  const kichIndex = selectedKichThuocs.value.findIndex(
    (kichThuoc) => kichThuoc?.tenKichThuoc === variant.kichThuoc
  );

  if (kichIndex === -1) {
    console.log("❌ Không tìm thấy kích thước trong selectedKichThuocs");
    return;
  }

  currentEditingVariant.value = { mauIndex, kichIndex };

  // Khôi phục trạng thái đã chọn trước đó cho biến thể này
  const variantKey = `${mauIndex}-${kichIndex}`;
  const savedSelection = variantImageSelections.value.get(variantKey);

  if (savedSelection) {
    selectedAnhFromDatabase.value = [...savedSelection.database];
    selectedAnhFromFile.value = [...savedSelection.files];
  } else {
    selectedAnhFromDatabase.value = [];
    selectedAnhFromFile.value = [];
  }

  // Kiểm tra xem đã load dữ liệu ảnh chưa
  if (anhSanPhams.value.length === 0) {
    fetchAnhSanPham();
  }

  showAnhPopup.value = true;
};

const removeVariantImage = (mauIndex, variantIndex, anhIndex) => {
  const variant = productVariants.value[mauIndex]?.[variantIndex];
  if (
    variant &&
    variant.anh &&
    anhIndex >= 0 &&
    anhIndex < variant.anh.length
  ) {
    variant.anh.splice(anhIndex, 1);
  }
};

// Function xóa biến thể sản phẩm
const removeVariant = (mauIndex, variantIndex) => {
  const variant = productVariants.value[mauIndex]?.[variantIndex];

  if (!variant) {
    console.log("❌ Không tìm thấy variant để xóa");
    return;
  }

  // Tìm kichIndex tương ứng trong selectedKichThuocs
  const kichIndex = selectedKichThuocs.value.findIndex(
    (kichThuoc) => kichThuoc?.tenKichThuoc === variant.kichThuoc
  );

  if (kichIndex === -1) {
    console.log("❌ Không tìm thấy kích thước trong selectedKichThuocs");
    return;
  }

  // Hiển thị popup confirm
  deleteConfirmInfo.value = `Màu: ${
    selectedMauSacs.value[mauIndex]?.tenMauSac || "N/A"
  } - Kích thước: ${variant.kichThuoc}`;
  deleteConfirmData.value = { mauIndex, kichIndex };
  showDeleteConfirmModal.value = true;
};

// Function đóng popup confirm xóa
const closeDeleteConfirmModal = () => {
  showDeleteConfirmModal.value = false;
  deleteConfirmInfo.value = "";
  deleteConfirmData.value = { mauIndex: -1, kichIndex: -1 };
};

// Function xác nhận xóa biến thể
const confirmDeleteVariant = () => {
  const { mauIndex, kichIndex } = deleteConfirmData.value;
  console.log("🚀 Bắt đầu xóa biến thể:", { mauIndex, kichIndex });

  if (mauIndex >= 0 && kichIndex >= 0) {
    // Lấy thông tin kích thước cần xóa
    const kichThuocToDelete = selectedKichThuocs.value[kichIndex];
    const mauSacToDeleteFrom = selectedMauSacs.value[mauIndex];

    console.log("📋 Thông tin cần xóa:", {
      kichThuocToDelete: kichThuocToDelete?.tenKichThuoc,
      mauSacToDeleteFrom: mauSacToDeleteFrom?.tenMauSac,
      selectedKichThuocs: selectedKichThuocs.value.map((k) => k?.tenKichThuoc),
      selectedMauSacs: selectedMauSacs.value.map((m) => m?.tenMauSac),
    });

    if (!kichThuocToDelete || !mauSacToDeleteFrom) {
      console.log("❌ Lỗi: Không tìm thấy thông tin biến thể cần xóa");
      closeDeleteConfirmModal();
      setTimeout(() => {
        showAlert("Lỗi", "Không tìm thấy thông tin biến thể cần xóa", "error");
      }, 100);
      return;
    }

    // 1. Xóa biến thể khỏi mảng productVariants của màu hiện tại
    console.log("🔍 Trước khi xóa:", {
      mauIndex,
      kichThuocToDelete: kichThuocToDelete.tenKichThuoc,
      productVariantsTruoc:
        productVariants.value[mauIndex]?.map((v) => v?.kichThuoc) || [],
    });

    productVariants.value[mauIndex] = productVariants.value[mauIndex].filter(
      (variant) =>
        variant && variant.kichThuoc !== kichThuocToDelete.tenKichThuoc
    );

    console.log("✅ Sau khi xóa biến thể:", {
      productVariantsSau:
        productVariants.value[mauIndex]?.map((v) => v?.kichThuoc) || [],
    });

    // 2. Kiểm tra xem màu này còn biến thể nào không
    console.log("🔍 Kiểm tra màu còn biến thể:", {
      mauIndex,
      length: productVariants.value[mauIndex].length,
    });

    if (productVariants.value[mauIndex].length === 0) {
      console.log("🗑️ Xóa toàn bộ màu vì không còn biến thể");

      // Nếu màu này không còn biến thể nào, xóa màu này khỏi danh sách
      selectedMauSacs.value.splice(mauIndex, 1);
      productVariants.value.splice(mauIndex, 1);

      console.log("✅ Đã xóa màu khỏi danh sách");

      // Đóng popup trước
      closeDeleteConfirmModal();

      // Thông báo xóa thành công sau khi UI đã cập nhật
      setTimeout(() => {
        showAlert(
          "Thành công",
          `Đã xóa toàn bộ biến thể của màu ${mauSacToDeleteFrom.tenMauSac}`,
          "success"
        );
      }, 100);
    } else {
      // 3. Kiểm tra xem kích thước này còn được sử dụng bởi màu nào khác không
      let isUsedByOtherColors = false;
      console.log(
        "🔍 Kiểm tra kích thước còn dùng ở màu khác:",
        kichThuocToDelete.tenKichThuoc
      );

      // Duyệt qua tất cả các màu còn lại (không bao gồm màu hiện tại)
      for (let i = 0; i < productVariants.value.length; i++) {
        if (i !== mauIndex && productVariants.value[i]) {
          console.log(
            `   Kiểm tra màu ${i}:`,
            productVariants.value[i].map((v) => v?.kichThuoc)
          );

          // Kiểm tra xem màu này có biến thể với kích thước cần xóa không
          const hasThisSize = productVariants.value[i].some(
            (variant) =>
              variant && variant.kichThuoc === kichThuocToDelete.tenKichThuoc
          );

          if (hasThisSize) {
            isUsedByOtherColors = true;
            console.log(`   ✅ Màu ${i} vẫn dùng kích thước này`);
            break;
          }
        }
      }

      console.log("📊 Kết quả kiểm tra:", { isUsedByOtherColors });

      // 4. Nếu kích thước này không còn được sử dụng bởi màu nào khác, xóa khỏi selectedKichThuocs
      if (!isUsedByOtherColors) {
        console.log("🗑️ Xóa kích thước khỏi selectedKichThuocs");

        // Tìm và xóa kích thước khỏi selectedKichThuocs
        console.log("🔍 Tìm kích thước trong selectedKichThuocs:", {
          tenKichThuoc: kichThuocToDelete.tenKichThuoc,
          selectedKichThuocs: selectedKichThuocs.value.map(
            (k) => k?.tenKichThuoc
          ),
        });

        const sizeIndexInList = selectedKichThuocs.value.findIndex(
          (kichThuoc) =>
            kichThuoc &&
            kichThuoc.tenKichThuoc === kichThuocToDelete.tenKichThuoc
        );

        console.log("📍 Vị trí tìm được:", sizeIndexInList);

        if (sizeIndexInList >= 0) {
          // Lưu tên kích thước trước khi xóa để thông báo
          const deletedSizeName =
            selectedKichThuocs.value[sizeIndexInList].tenKichThuoc;

          console.log("🗑️ Xóa kích thước:", deletedSizeName);

          selectedKichThuocs.value.splice(sizeIndexInList, 1);

          console.log("✅ Đã xóa khỏi selectedKichThuocs, danh sách còn:", {
            selectedKichThuocs: selectedKichThuocs.value.map(
              (k) => k?.tenKichThuoc
            ),
          });

          // Đóng popup trước
          closeDeleteConfirmModal();

          // Thông báo xóa thành công sau khi UI đã cập nhật
          setTimeout(() => {
            showAlert(
              "Thành công",
              `Đã xóa kích thước ${deletedSizeName} khỏi màu ${mauSacToDeleteFrom.tenMauSac}`,
              "success"
            );
          }, 100);
        } else {
          console.log(
            "❌ Không tìm thấy kích thước trong selectedKichThuocs để xóa"
          );
        }
      } else {
        console.log(
          "📋 Kích thước vẫn còn dùng ở màu khác, không xóa khỏi selectedKichThuocs"
        );

        // Đóng popup trước
        closeDeleteConfirmModal();

        // Thông báo xóa thành công nhưng kích thước vẫn còn trong các màu khác
        setTimeout(() => {
          showAlert(
            "Thành công",
            `Đã xóa kích thước ${kichThuocToDelete.tenKichThuoc} khỏi màu ${mauSacToDeleteFrom.tenMauSac}. Kích thước này vẫn còn trong các màu khác.`,
            "success"
          );
        }, 100);
      }
    }
  }

  console.log("🎉 Kết thúc xóa biến thể, trạng thái cuối cùng:", {
    selectedMauSacs: selectedMauSacs.value.map((m) => m?.tenMauSac),
    selectedKichThuocs: selectedKichThuocs.value.map((k) => k?.tenKichThuoc),
    productVariants: productVariants.value.map((pv, i) => ({
      mauIndex: i,
      variants: pv?.map((v) => v?.kichThuoc) || [],
    })),
  });
};

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

// Hàm hiển thị alert thông tin - hỗ trợ nhiều thông báo
const showAlert = (title, message, type = "info", productId = null) => {
  const id = ++notificationId;
  const newNotification = {
    id,
    title,
    message,
    type,
    productId,
    isClosing: false,
    createdAt: Date.now(),
  };

  notifications.value.push(newNotification);

  // Tự động ẩn sau 5 giây
  setTimeout(() => {
    closeNotificationPopup(id);
  }, 5000);
};

// Function đóng popup thông báo cụ thể với animation
const closeNotificationPopup = (id) => {
  const notification = notifications.value.find((n) => n.id === id);
  if (notification) {
    notification.isClosing = true;

    // Đợi animation kết thúc rồi xóa khỏi mảng
    setTimeout(() => {
      notifications.value = notifications.value.filter((n) => n.id !== id);
    }, 300); // Thời gian animation slideOutRight
  }
};

// Function chuyển đến trang chi tiết sản phẩm
const goToProductDetail = (productId) => {
  if (productId) {
    // Chuyển đến trang chi tiết sản phẩm
    window.location.href = `/products/detail/${productId}`;
  }
};

// Helper functions để truy cập an toàn các thuộc tính variant
const getVariantAnh = (mauIndex, kichIndex) => {
  const variant = productVariants.value[mauIndex]?.[kichIndex];
  return variant?.anh || [];
};

const hasVariantAnh = (mauIndex, kichIndex) => {
  const anh = getVariantAnh(mauIndex, kichIndex);
  return anh.length > 0;
};

const getVariantAnhLength = (mauIndex, kichIndex) => {
  const anh = getVariantAnh(mauIndex, kichIndex);
  return anh.length;
};

// Helper functions để lấy ID từ tên
// Hàm kiểm tra sản phẩm đã tồn tại dựa trên tên và các thuộc tính (chỉ tìm kiếm, không tạo mới)
const getExistingSanPhamId = () => {
  if (!productForm.value.tenSanPham || !productForm.value.tenSanPham.trim())
    return null;

  try {
    // Tìm ID nhà sản xuất đã tồn tại (không tạo mới)
    const existingNhaSanXuat = nhaSanXuats.value.find(
      (item) =>
        item.tenNhaSanXuat.toLowerCase() ===
        productForm.value.tenNhaSanXuat.toLowerCase()
    );

    // Tìm ID xuất xứ đã tồn tại (không tạo mới)
    const existingXuatXu = xuatXus.value.find(
      (item) =>
        item.tenXuatXu.toLowerCase() ===
        productForm.value.tenXuatXu.toLowerCase()
    );

    // Nếu thiếu thông tin thuộc tính thì không thể tìm sản phẩm
    if (!existingNhaSanXuat || !existingXuatXu) {
      return null;
    }

    // Tìm sản phẩm đã tồn tại với tên và thuộc tính giống hệt
    const existingSanPham = tenSanPhams.value.find(
      (sanPham) =>
        sanPham.tenSanPham.toLowerCase() ===
          productForm.value.tenSanPham.toLowerCase() &&
        sanPham.idNhaSanXuat === existingNhaSanXuat.id &&
        sanPham.idXuatXu === existingXuatXu.id
    );

    if (existingSanPham) {
      return existingSanPham.id;
    }

    return null; // Không tìm thấy sản phẩm tồn tại
  } catch (error) {
    console.error("Lỗi khi kiểm tra sản phẩm tồn tại:", error);
    return null;
  }
};

const getNhaSanXuatId = async (tenNhaSanXuat) => {
  if (!tenNhaSanXuat || !tenNhaSanXuat.trim()) return null;

  // Tìm trong danh sách hiện có
  const existingNhaSanXuat = nhaSanXuats.value.find(
    (item) => item.tenNhaSanXuat.toLowerCase() === tenNhaSanXuat.toLowerCase()
  );

  if (existingNhaSanXuat) {
    return existingNhaSanXuat.id;
  }

  // Nếu chưa có thì tạo mới
  try {
    const newNhaSanXuat = {
      tenNhaSanXuat: tenNhaSanXuat,
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0],
      createBy: 1,
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1,
    };

    await fetchCreateNhaSanXuat(newNhaSanXuat);
    await fetchNhaSanXuat(); // Refresh danh sách

    return nhaSanXuats.value.find(
      (item) => item.tenNhaSanXuat.toLowerCase() === tenNhaSanXuat.toLowerCase()
    ).id;
  } catch (error) {
    console.error("Error creating nha san xuat:", error);
    return null;
  }
};

const getXuatXuId = async (tenXuatXu) => {
  if (!tenXuatXu || !tenXuatXu.trim()) return null;

  // Tìm trong danh sách hiện có
  const existingXuatXu = xuatXus.value.find(
    (item) => item.tenXuatXu.toLowerCase() === tenXuatXu.toLowerCase()
  );

  if (existingXuatXu) {
    return existingXuatXu.id;
  }

  // Nếu chưa có thì tạo mới
  try {
    const newXuatXu = {
      tenXuatXu: tenXuatXu,
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0],
      createBy: 1,
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1,
    };

    await fetchCreateXuatXu(newXuatXu);
    await fetchXuatXu(); // Refresh danh sách
    return xuatXus.value.find(
      (item) => item.tenXuatXu.toLowerCase() === tenXuatXu.toLowerCase()
    ).id;
  } catch (error) {
    console.error("Error creating xuat xu:", error);
    return null;
  }
};

const getChatLieuId = async (tenChatLieu) => {
  if (!tenChatLieu || !tenChatLieu.trim()) return null;

  // Tìm trong danh sách hiện có
  const existingChatLieu = chatLieus.value.find(
    (item) => item.tenChatLieu.toLowerCase() === tenChatLieu.toLowerCase()
  );

  if (existingChatLieu) {
    return existingChatLieu.id;
  }

  // Nếu chưa có thì tạo mới
  try {
    const newChatLieu = {
      tenChatLieu: tenChatLieu,
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0],
      createBy: 1,
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1,
    };

    await fetchCreateChatLieu(newChatLieu);
    await fetchChatLieu(); // Refresh danh sách

    return chatLieus.value.find(
      (item) => item.tenChatLieu.toLowerCase() === tenChatLieu.toLowerCase()
    ).id;
  } catch (error) {
    console.error("Error creating chat lieu:", error);
    return null;
  }
};

const getDeGiayId = async (tenDeGiay) => {
  if (!tenDeGiay || !tenDeGiay.trim()) return null;

  // Tìm trong danh sách hiện có
  const existingDeGiay = deGiays.value.find(
    (item) => item.tenDeGiay.toLowerCase() === tenDeGiay.toLowerCase()
  );

  if (existingDeGiay) {
    return existingDeGiay.id;
  }

  // Nếu chưa có thì tạo mới
  try {
    const newDeGiay = {
      tenDeGiay: tenDeGiay,
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0],
      createBy: 1,
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1,
    };

    await fetchCreateDeGiay(newDeGiay);
    await fetchDeGiay(); // Refresh danh sách

    return deGiays.value.find(
      (item) => item.tenDeGiay.toLowerCase() === tenDeGiay.toLowerCase()
    ).id;
  } catch (error) {
    console.error("Error creating de giay:", error);
    return null;
  }
};

// Helper functions để tạo màu sắc và kích thước mới
const getMauSacId = async (mauSac) => {
  // Nếu đã có ID thì trả về luôn
  if (mauSac.id) {
    return mauSac.id;
  }

  // Nếu chưa có ID thì tạo mới
  try {
    // Validate mã màu hex
    let maMau = mauSac.maMau || '#000000';
    if (!maMau.startsWith('#')) {
      maMau = '#' + maMau;
    }
    
    const newMauSac = {
      tenMauSac: mauSac.tenMauSac,
      maMau: maMau,
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0],
      createBy: 1,
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1,
    };

    await fetchCreateMauSac(newMauSac);
    await fetchMauSac(); // Refresh danh sách

    const createdMauSac = mauSacs.value.find(
      (item) => item.tenMauSac.toLowerCase() === mauSac.tenMauSac.toLowerCase()
    );
    
    if (!createdMauSac) {
      throw new Error(`Không thể tìm thấy màu sắc vừa tạo: ${mauSac.tenMauSac}`);
    }
    
    return createdMauSac.id;
  } catch (error) {
    console.error("Error creating mau sac:", error);
    throw new Error(`Không thể tạo màu sắc: ${mauSac.tenMauSac} - ${error.message}`);
  }
};

const getKichThuocId = async (kichThuoc) => {
  // Nếu đã có ID thì trả về luôn
  if (kichThuoc.id) {
    return kichThuoc.id;
  }

  // Nếu chưa có ID thì tạo mới
  try {
    const newKichThuoc = {
      tenKichThuoc: kichThuoc.tenKichThuoc,
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0],
      createBy: 1,
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1,
    };

    await fetchCreateKichThuoc(newKichThuoc);
    await fetchKichThuoc(); // Refresh danh sách

    return kichThuocs.value.find(
      (item) =>
        item.tenKichThuoc.toLowerCase() === kichThuoc.tenKichThuoc.toLowerCase()
    ).id;
  } catch (error) {
    console.error("Error creating kich thuoc:", error);
    return null;
  }
};

const getTrongLuongId = async (trongLuong) => {
  if (!trongLuong || !trongLuong.trim()) return null;

  // Tìm trong danh sách hiện có
  const existingTrongLuong = trongLuongs.value.find(
    (item) => item.tenTrongLuong.toLowerCase() === trongLuong.toLowerCase()
  );

  if (existingTrongLuong) {
    return existingTrongLuong.id;
  }

  // Nếu chưa có thì tạo mới
  try {
    const newTrongLuong = {
      tenTrongLuong: trongLuong,
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0],
      createBy: 1,
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1,
    };

    // Gọi API tạo trọng lượng mới (API không trả về dữ liệu, chỉ thông báo thành công)
    await fetchCreateTrongLuong(newTrongLuong);

    // Refresh danh sách để lấy trọng lượng vừa tạo
    await fetchTrongLuong();

    // Tìm lại trọng lượng vừa tạo trong danh sách đã refresh
    return trongLuongs.value.find(
      (item) => item.tenTrongLuong.toLowerCase() === trongLuong.toLowerCase()
    ).id;
  } catch (error) {
    console.error("Error creating trong luong:", error);
    throw new Error(
      `Không thể tạo trọng lượng: ${trongLuong} - ${error.message}`
    );
  }
};

// Helper function để đọc trọng lượng từ table và thêm vào nếu chưa có

// Đóng tất cả dropdown
const closeAllDropdowns = () => {
  showNhaSanXuatDropdown.value = false;
  showXuatXuDropdown.value = false;
  showChatLieuDropdown.value = false;
  showDeGiayDropdown.value = false;
  showTenSanPhamDropdown.value = false;
};

// Click outside để đóng dropdown
const handleClickOutside = (event) => {
  // Kiểm tra xem có phải click vào input hoặc dropdown của phần thông tin cơ bản không
  const isClickOnBasicInfoInput = event.target.closest(".input-with-dropdown");
  const isClickOnBasicInfoDropdown = event.target.closest(".dropdown-list");

  // Nếu click ra ngoài cả input và dropdown của phần thông tin cơ bản thì đóng tất cả dropdown
  if (!isClickOnBasicInfoInput && !isClickOnBasicInfoDropdown) {
    closeAllDropdowns();
    return;
  }

  // Nếu click vào input khác thì đóng dropdown hiện tại
  if (isClickOnBasicInfoInput && !isClickOnBasicInfoDropdown) {
    const clickedInput = event.target.closest(".input-with-dropdown");
    if (clickedInput && event.target.tagName === "INPUT") {
      // Kiểm tra xem input này có phải là input đang active không
      const isCurrentlyActive =
        (showTenSanPhamDropdown.value &&
          clickedInput.querySelector("input") === event.target) ||
        (showNhaSanXuatDropdown.value &&
          clickedInput.querySelector("input") === event.target) ||
        (showXuatXuDropdown.value &&
          clickedInput.querySelector("input") === event.target) ||
        (showChatLieuDropdown.value &&
          clickedInput.querySelector("input") === event.target) ||
        (showDeGiayDropdown.value &&
          clickedInput.querySelector("input") === event.target);

      // Nếu không phải input đang active thì đóng tất cả dropdown
      if (!isCurrentlyActive) {
        closeAllDropdowns();
      }
    }
  }
};

// Function to add variants to existing product
const addVariantsToExistingProduct = async (existingProductId) => {
  try {
    const idDeGiay = await getDeGiayId(productForm.value.tenDeGiay);
    const idChatLieu = await getChatLieuId(productForm.value.tenChatLieu);

    // Validate common data
    if (!idDeGiay) {
      throw new Error("Thiếu thông tin đế giày!");
    }
    if (!idChatLieu) {
      throw new Error("Thiếu thông tin chất liệu!");
    }

    // Tạo biến thể cho sản phẩm đã tồn tại
    for (let i = 0; i < selectedMauSacs.value.length; i++) {
      for (let j = 0; j < selectedKichThuocs.value.length; j++) {
        const variant = productVariants.value[i]?.[j];

        // Chỉ tạo variant nếu nó thực sự tồn tại
        if (!variant) {
          console.log(
            `⚠️ Bỏ qua variant không tồn tại khi thêm vào sản phẩm: màu ${i}, kích thước ${j}`
          );
          continue;
        }

        const trongLuongId = await getTrongLuongId(variant.trongLuong);

        if (!trongLuongId) {
          throw new Error(
            `Thiếu thông tin trọng lượng cho biến thể ${selectedMauSacs.value[i].tenMauSac} - ${selectedKichThuocs.value[j].tenKichThuoc}`
          );
        }

        // Lấy ID màu sắc và kích thước (tạo mới nếu chưa có)
        const idKichThuoc = await getKichThuocId(selectedKichThuocs.value[j]);
        const idMauSac = await getMauSacId(selectedMauSacs.value[i]);

        if (!idKichThuoc) {
          throw new Error(
            `Không thể tạo kích thước: ${selectedKichThuocs.value[j].tenKichThuoc}`
          );
        }
        if (!idMauSac) {
          throw new Error(
            `Không thể tạo màu sắc: ${selectedMauSacs.value[i].tenMauSac}`
          );
        }

        const variantData = {
          idSanPham: existingProductId,
          idKichThuoc: idKichThuoc,
          idMauSac: idMauSac,
          idDeGiay: idDeGiay,
          idChatLieu: idChatLieu,
          idTrongLuong: trongLuongId,
          soLuong: variant.soLuong,
          giaBan: variant.giaBan,
          trangThai: true,
          deleted: false,
          createAt: new Date().toISOString().split("T")[0],
          createBy: 1,
          updateAt: new Date().toISOString().split("T")[0],
          updateBy: 1,
        };

        // Gọi API tạo biến thể sản phẩm
        const createdVariant = await fetchCreateChiTietSanPham(variantData);

        if (!createdVariant || !createdVariant.id) {
          console.error(
            `Không thể tạo biến thể ${i}-${j}: Thiếu ID trong response`,
            createdVariant
          );
          continue;
        }

        // Xử lý ảnh cho biến thể nếu cần
        if (variant.anh && variant.anh.length > 0) {
          try {
            const uploadResults = await uploadMultipleImages(variant.anh);

            const anhIdsToLink = [];
            variant.anh.forEach((anh) => {
              if (anh.type === "database" && anh.id) {
                anhIdsToLink.push(anh.id);
              }
            });

            const failedUploads = [];
            uploadResults.forEach((result) => {
              if (result.success) {
                if (
                  result.anhSanPhamIds &&
                  Array.isArray(result.anhSanPhamIds)
                ) {
                  // Backend trả về list ID (multiple images)
                  result.anhSanPhamIds.forEach((id) => anhIdsToLink.push(id));
                } else if (result.anhSanPhamId) {
                  // Backward compatibility - single ID hoặc temp ID
                  anhIdsToLink.push(result.anhSanPhamId);
                } else {
                  console.warn(
                    `⚠️ Ảnh ${result.originalAnh.name} upload thành công nhưng không có ID`
                  );
                  failedUploads.push(result.originalAnh.name);
                }
              } else if (!result.success) {
                console.warn(
                  `⚠️ Ảnh ${result.originalAnh.name} upload thất bại: ${result.error}`
                );
                failedUploads.push(result.originalAnh.name);
              } else {
                console.warn(
                  `⚠️ Ảnh ${result.originalAnh.name} upload thành công nhưng không có ID để link`
                );
                failedUploads.push(result.originalAnh.name);
              }
            });

            // Thông báo cho user về ảnh upload thất bại
            if (failedUploads.length > 0) {
              console.warn(
                `🚨 ${failedUploads.length} ảnh không thể upload:`,
                failedUploads.join(", ")
              );
            }

            if (anhIdsToLink.length > 0) {
              // Chỉ gửi ID thực (số nguyên), loại bỏ temp ID string
              const realAnhIdsToLink = anhIdsToLink.filter(
                (id) =>
                  typeof id === "number" ||
                  (typeof id === "string" && !id.startsWith("temp_"))
              );

              if (realAnhIdsToLink.length === 0) {
                console.warn(
                  "⚠️ Không có ID thực để tạo liên kết, bỏ qua bước này"
                );
                return;
              }

              const chiTietSanPhamAnhData = {
                idChiTietSanPham: createdVariant.id,
                idAnhSanPhamList: realAnhIdsToLink, // Chỉ gửi ID thực
                trangThai: true,
                deleted: false,
                createAt: new Date().toISOString().split("T")[0],
                createBy: 1,
                updateAt: new Date().toISOString().split("T")[0],
                updateBy: 1,
              };

              await fetchCreateMultipleChiTietSanPhamAnh(chiTietSanPhamAnhData);
            }
          } catch (error) {
            console.error(`Lỗi khi xử lý ảnh cho biến thể ${i}-${j}:`, error);
          }
        }
      }
    }

    // Lưu ID sản phẩm đã chọn từ dropdown
    createdProductId.value = selectedProductFromDropdown.value.id;

    // Hiển thị popup thông báo thành công bên phải
    showAlert(
      "Thành công",
      `Đã thêm biến thể mới cho sản phẩm "${selectedProductFromDropdown.value.tenSanPham}" thành công!`,
      "success"
    );

    // Reset form after successful creation
    resetForm();
  } catch (error) {
    console.error("❌ Error adding variants to existing product:", error);
    let errorMessage = "Có lỗi xảy ra khi thêm biến thể!";
    if (error.message.includes("trọng lượng")) {
      errorMessage = error.message;
    }
    alert(errorMessage);
  }
};

// Confirm create product function
const confirmCreateProduct = () => {
  // Validate basic form before showing confirm
  if (!productForm.value.tenSanPham.trim()) {
    showAlert("Thiếu thông tin", "Vui lòng nhập tên sản phẩm!", "error");
    return;
  }

  if (!productForm.value.tenNhaSanXuat.trim()) {
    showAlert(
      "Thiếu thông tin",
      "Vui lòng nhập hoặc chọn nhà sản xuất!",
      "error"
    );
    return;
  }

  if (!productForm.value.tenXuatXu.trim()) {
    showAlert("Thiếu thông tin", "Vui lòng nhập hoặc chọn xuất xứ!", "error");
    return;
  }

  if (!productForm.value.tenChatLieu.trim()) {
    showAlert("Thiếu thông tin", "Vui lòng nhập hoặc chọn chất liệu!", "error");
    return;
  }

  if (!productForm.value.tenDeGiay.trim()) {
    showAlert("Thiếu thông tin", "Vui lòng nhập hoặc chọn đế giày!", "error");
    return;
  }

  if (selectedMauSacs.value.length === 0) {
    showAlert("Thiếu thông tin", "Vui lòng chọn ít nhất một màu sắc!", "error");
    return;
  }

  if (selectedKichThuocs.value.length === 0) {
    showAlert(
      "Thiếu thông tin",
      "Vui lòng chọn ít nhất một kích thước!",
      "error"
    );
    return;
  }

  // Validate variants
  for (let i = 0; i < selectedMauSacs.value.length; i++) {
    for (let j = 0; j < selectedKichThuocs.value.length; j++) {
      const variant = productVariants.value[i]?.[j];
      if (variant && (!variant.trongLuong || !variant.trongLuong.trim())) {
        showAlert(
          "Thiếu thông tin",
          `Vui lòng nhập trọng lượng cho biến thể ${selectedMauSacs.value[i].tenMauSac} - ${selectedKichThuocs.value[j].tenKichThuoc}!`,
          "error"
        );
        return;
      }
      if (variant && variant.soLuong <= 0) {
        showAlert(
          "Thiếu thông tin",
          `Vui lòng nhập số lượng > 0 cho biến thể ${selectedMauSacs.value[i].tenMauSac} - ${selectedKichThuocs.value[j].tenKichThuoc}!`,
          "error"
        );
        return;
      }
      if (variant && variant.giaBan <= 0) {
        showAlert(
          "Thiếu thông tin",
          `Vui lòng nhập giá bán > 0 cho biến thể ${selectedMauSacs.value[i].tenMauSac} - ${selectedKichThuocs.value[j].tenKichThuoc}!`,
          "error"
        );
        return;
      }
    }
  }

  // Kiểm tra xem có sản phẩm được chọn từ dropdown không
  if (selectedProductFromDropdown.value) {
    // Show confirm for adding variants to existing product
    const variantCount =
      selectedMauSacs.value.length * selectedKichThuocs.value.length;
    showConfirm(
      "Thêm biến thể cho sản phẩm hiện có",
      `Sản phẩm "${selectedProductFromDropdown.value.tenSanPham}" đã tồn tại. Bạn có muốn thêm ${variantCount} biến thể mới cho sản phẩm này không?`,
      () => {
        addVariantsToExistingProduct(selectedProductFromDropdown.value.id);
      }
    );
  } else {
    // Kiểm tra xem sản phẩm với tên và thuộc tính đã nhập có tồn tại không
    const existingProductId = getExistingSanPhamId();

    if (existingProductId) {
      // Sản phẩm đã tồn tại, thêm biến thể mới
      const variantCount =
        selectedMauSacs.value.length * selectedKichThuocs.value.length;
      showConfirm(
        "Thêm biến thể cho sản phẩm hiện có",
        `Sản phẩm "${productForm.value.tenSanPham}" với các thuộc tính đã nhập đã tồn tại. Bạn có muốn thêm ${variantCount} biến thể mới cho sản phẩm này không?`,
        () => {
          addVariantsToExistingProduct(existingProductId);
        }
      );
    } else {
      // Sản phẩm chưa tồn tại, tạo mới
      // Đếm số variant thực sự tồn tại (không phải tất cả combinations)
      let variantCount = 0;
      for (let i = 0; i < selectedMauSacs.value.length; i++) {
        for (let j = 0; j < selectedKichThuocs.value.length; j++) {
          if (productVariants.value[i]?.[j]) {
            variantCount++;
          }
        }
      }
      showConfirm(
        "Xác nhận tạo sản phẩm",
        `Bạn có muốn tạo sản phẩm "${productForm.value.tenSanPham}" với ${variantCount} biến thể không?`,
        () => {
          saveProduct();
        }
      );
    }
  }
};

// Save product function
const saveProduct = async () => {
  try {
    // Hiển thị popup loading
    isCreatingProduct.value = true;
    
    // Form validation has been moved to confirmCreateProduct function
    // This function now only handles creating NEW products (not existing ones)

    // Tạo dữ liệu sản phẩm chính trước
    const sanPhamData = {
      tenSanPham: productForm.value.tenSanPham,
      idNhaSanXuat: await getNhaSanXuatId(productForm.value.tenNhaSanXuat),
      idXuatXu: await getXuatXuId(productForm.value.tenXuatXu),
      trangThai: true,
      deleted: false,
      createAt: new Date().toISOString().split("T")[0], // Format: YYYY-MM-DD
      createBy: 1, // Default value
      updateAt: new Date().toISOString().split("T")[0],
      updateBy: 1, // Default value
    };

    // Kiểm tra dữ liệu trước khi gửi API
    if (!sanPhamData.idNhaSanXuat) {
      throw new Error("Không thể tạo sản phẩm: Thiếu thông tin nhà sản xuất!");
    }
    if (!sanPhamData.idXuatXu) {
      throw new Error("Không thể tạo sản phẩm: Thiếu thông tin xuất xứ!");
    }

    const createdSanPham = await fetchCreateSanPham(sanPhamData);

    // Kiểm tra response từ API
    if (!createdSanPham) {
      throw new Error("API không trả về dữ liệu");
    }

    // Kiểm tra success flag
    if (createdSanPham.success === false) {
      throw new Error(
        `API trả về lỗi: ${createdSanPham.message || "Không xác định"}`
      );
    }

    // Tìm sản phẩm vừa tạo bằng tên và các thuộc tính khác
    const allSanPhams = await fetchAllSanPham();
    const newlyCreatedSanPham = allSanPhams.data?.find(
      (sanPham) =>
        sanPham.tenSanPham === productForm.value.tenSanPham &&
        sanPham.idNhaSanXuat === sanPhamData.idNhaSanXuat &&
        sanPham.idXuatXu === sanPhamData.idXuatXu
    );

    if (!newlyCreatedSanPham || !newlyCreatedSanPham.id) {
      throw new Error("Không thể tìm thấy sản phẩm vừa tạo");
    }

    // Lấy dữ liệu từ sản phẩm vừa tạo
    const newSanPhamData = newlyCreatedSanPham;

    // Lấy ID từ response
    const sanPhamId = newSanPhamData.id;

    // Lưu ID sản phẩm vừa tạo ngay lập tức
    createdProductId.value = sanPhamId;
    for (let i = 0; i < selectedMauSacs.value.length; i++) {
      for (let j = 0; j < selectedKichThuocs.value.length; j++) {
        const variant = productVariants.value[i]?.[j];

        // Chỉ tạo variant nếu nó thực sự tồn tại
        if (!variant) {
          console.log(
            `⚠️ Bỏ qua variant không tồn tại: màu ${i}, kích thước ${j}`
          );
          continue;
        }

        const trongLuongId = await getTrongLuongId(variant.trongLuong);
        const idDeGiay = await getDeGiayId(productForm.value.tenDeGiay);
        const idChatLieu = await getChatLieuId(productForm.value.tenChatLieu);

        // Lấy ID màu sắc và kích thước (tạo mới nếu chưa có)
        const idKichThuoc = await getKichThuocId(selectedKichThuocs.value[j]);
        const idMauSac = await getMauSacId(selectedMauSacs.value[i]);

        if (!idKichThuoc) {
          throw new Error(
            `Không thể tạo kích thước: ${selectedKichThuocs.value[j].tenKichThuoc}`
          );
        }
        if (!idMauSac) {
          throw new Error(
            `Không thể tạo màu sắc: ${selectedMauSacs.value[i].tenMauSac}`
          );
        }

        const variantData = {
          idSanPham: sanPhamId,
          idKichThuoc: idKichThuoc,
          idMauSac: idMauSac,
          idDeGiay: idDeGiay,
          idChatLieu: idChatLieu,
          idTrongLuong: trongLuongId,
          soLuong: variant.soLuong,
          giaBan: variant.giaBan,
          trangThai: true,
          deleted: false,
          createAt: new Date().toISOString().split("T")[0], // Format: YYYY-MM-DD
          createBy: 1, // Default value
          updateAt: new Date().toISOString().split("T")[0],
          updateBy: 1, // Default value
        };

        // Kiểm tra dữ liệu biến thể trước khi gửi API
        if (!variantData.idDeGiay) {
          throw new Error(
            `Không thể tạo biến thể ${i}-${j}: Thiếu thông tin đế giày!`
          );
        }
        if (!variantData.idChatLieu) {
          throw new Error(
            `Không thể tạo biến thể ${i}-${j}: Thiếu thông tin chất liệu!`
          );
        }
        if (!variantData.idTrongLuong) {
          throw new Error(
            `Không thể tạo biến thể ${i}-${j}: Thiếu thông tin trọng lượng!`
          );
        }

        // Gọi API tạo biến thể sản phẩm
        const createdVariant = await fetchCreateChiTietSanPham(variantData);

        // Kiểm tra xem biến thể có được tạo thành công không
        if (!createdVariant || !createdVariant.id) {
          console.error(
            ` Không thể tạo biến thể ${i}-${j}: Thiếu ID trong response`,
            createdVariant
          );
          continue; // Bỏ qua biến thể này và tiếp tục với biến thể khác
        }

        // Xử lý ảnh cho biến thể nếu cần
        if (variant.anh && variant.anh.length > 0) {
          try {
            // Upload tất cả ảnh file cùng lúc
            const uploadResults = await uploadMultipleImages(variant.anh);

            // Tạo liên kết cho tất cả ảnh (cả database và uploaded)
            const anhIdsToLink = [];

            // Xử lý ảnh từ database
            variant.anh.forEach((anh) => {
              if (anh.type === "database" && anh.id) {
                anhIdsToLink.push(anh.id);
              }
            });

            // Xử lý kết quả upload
            const failedUploads = [];
            uploadResults.forEach((result) => {
              if (result.success) {
                if (
                  result.anhSanPhamIds &&
                  Array.isArray(result.anhSanPhamIds)
                ) {
                  // Backend trả về list ID (multiple images)
                  result.anhSanPhamIds.forEach((id) => anhIdsToLink.push(id));
                } else if (result.anhSanPhamId) {
                  // Backward compatibility - single ID hoặc temp ID
                  anhIdsToLink.push(result.anhSanPhamId);
                } else {
                  failedUploads.push(result.originalAnh.name);
                }
              } else if (!result.success) {
                failedUploads.push(result.originalAnh.name);
              } else {
                failedUploads.push(result.originalAnh.name);
              }
            });

            // Thông báo cho user về ảnh upload thất bại
            if (failedUploads.length > 0) {
              console.warn(
                `🚨 ${failedUploads.length} ảnh không thể upload:`,
                failedUploads.join(", ")
              );
              // Có thể hiển thị toast notification ở đây
            }

            // Tạo liên kết cho tất cả ảnh thành công
            if (anhIdsToLink.length > 0) {
              try {
                // Chỉ gửi ID thực (số nguyên), loại bỏ temp ID string
                const realAnhIdsToLink = anhIdsToLink.filter(
                  (id) =>
                    typeof id === "number" ||
                    (typeof id === "string" && !id.startsWith("temp_"))
                );

                if (realAnhIdsToLink.length === 0) {
                  console.warn(
                    "⚠️ Không có ID thực để tạo liên kết, bỏ qua bước này"
                  );
                  return;
                }

                // Validate dữ liệu trước khi gửi
                if (!createdVariant.id) {
                  throw new Error(
                    `ID chi tiết sản phẩm không hợp lệ: ${createdVariant.id}`
                  );
                }
                if (
                  !Array.isArray(realAnhIdsToLink) ||
                  realAnhIdsToLink.length === 0
                ) {
                  throw new Error(
                    `Danh sách ID ảnh không hợp lệ: ${JSON.stringify(
                      realAnhIdsToLink
                    )}`
                  );
                }

                const chiTietSanPhamAnhData = {
                  idChiTietSanPham: createdVariant.id,
                  idAnhSanPhamList: realAnhIdsToLink, // Chỉ gửi ID thực
                  trangThai: true,
                  deleted: false,
                  createAt: new Date().toISOString().split("T")[0],
                  createBy: 1,
                  updateAt: new Date().toISOString().split("T")[0],
                  updateBy: 1,
                };

                await fetchCreateMultipleChiTietSanPhamAnh(
                  chiTietSanPhamAnhData
                );
              } catch (linkError) {
                console.error(
                  `<!-- icon: close --> Lỗi khi tạo liên kết ảnh cho biến thể ${i}-${j}:`,
                  linkError
                );
                // Tiếp tục với biến thể khác
              }
            } else {
            }
          } catch (error) {
            console.error(
              `<!-- icon: close --> Lỗi khi xử lý ảnh cho biến thể ${i}-${j}:`,
              error
            );
            // Không throw error để tiếp tục tạo các biến thể khác
          }
        }
      }
    }

    // Hiển thị popup thông báo thành công bên phải với ID sản phẩm
    showAlert("Thành công", "Sản phẩm mới đã được tạo thành công!", "success", sanPhamId);

    // Reset form after successful creation
    resetForm();
  } catch (error) {
    console.error("<!-- icon: close --> Error creating product:", error);
    console.error("Error details:", {
      message: error.message,
      stack: error.stack,
      response: error.response,
    });

    // Hiển thị thông báo lỗi chi tiết hơn
    let errorMessage = "Có lỗi xảy ra khi tạo sản phẩm!";
    if (error.message.includes("trọng lượng")) {
      errorMessage = error.message;
    } else if (error.message.includes("Failed to create")) {
      errorMessage = "Lỗi kết nối API. Vui lòng kiểm tra lại!";
    }

    showConfirm("Lỗi", errorMessage, () => {});
  } finally {
    // Ẩn popup loading
    isCreatingProduct.value = false;
  }
};

// Success modal function - Không còn sử dụng
// const closeSuccessModal = () => {
//   showSuccessModal.value = false;
//   successMessage.value = "";
//   createdProductId.value = null;
// };

// Confirm modal functions
const showConfirm = (title, message, callback) => {
  confirmTitle.value = title;
  confirmMessage.value = message;
  onConfirmCallback.value = callback;
  showConfirmModal.value = true;
};

const closeConfirmModal = () => {
  showConfirmModal.value = false;
  confirmTitle.value = "";
  confirmMessage.value = "";
  onConfirmCallback.value = null;
};

const confirmAction = () => {
  if (onConfirmCallback.value) {
    onConfirmCallback.value();
  }
  closeConfirmModal();
};

// Window resize handler for notifications
const handleWindowResize = () => {
  windowWidth.value = window.innerWidth;
};

onMounted(async () => {
  // Add window resize listener
  window.addEventListener("resize", handleWindowResize);

  // Initialize form
  resetForm();

  // Fetch data cho các thuộc tính
  await Promise.all([
    fetchTenSanPham(),
    fetchNhaSanXuat(),
    fetchXuatXu(),
    fetchChatLieu(),
    fetchDeGiay(),
    fetchTrongLuong(),
    fetchMauSac(),
    fetchKichThuoc(),
    fetchAnhSanPham(),
  ]);

  // Add click outside listener
  document.addEventListener("click", handleClickOutside);
});

// Function cleanup blob URLs
const cleanupBlobUrls = () => {
  // Cleanup trong selectedAnhFromFile
  selectedAnhFromFile.value.forEach((fileData) => {
    if (fileData.url && fileData.url.startsWith("blob:")) {
      URL.revokeObjectURL(fileData.url);
    }
  });

  // Cleanup trong variantImageSelections
  variantImageSelections.value.forEach((selection) => {
    selection.files.forEach((fileData) => {
      if (fileData.url && fileData.url.startsWith("blob:")) {
        URL.revokeObjectURL(fileData.url);
      }
    });
  });

  // Cleanup trong productVariants
  if (productVariants.value) {
    productVariants.value.forEach((mauRow) => {
      if (mauRow) {
        mauRow.forEach((kichCol) => {
          if (kichCol && kichCol.anh) {
            kichCol.anh.forEach((anh) => {
              if (
                anh.url &&
                anh.url.startsWith("blob:") &&
                anh.type === "file"
              ) {
                URL.revokeObjectURL(anh.url);
              }
            });
          }
        });
      }
    });
  }
};

// Cleanup event listener và blob URLs
onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);
  window.removeEventListener("resize", handleWindowResize);
  cleanupBlobUrls();
});

// Popup functions cho ảnh
const closeAnhPopup = () => {
  showAnhPopup.value = false;
  currentEditingVariant.value = { mauIndex: -1, kichIndex: -1 };
  // Không reset selectedAnhFromDatabase và selectedAnhFromFile
  // để giữ trạng thái khi mở popup lại
};

const cancelAnhSelection = () => {
  const { mauIndex, kichIndex } = currentEditingVariant.value;

  // Khôi phục trạng thái đã lưu
  const variantKey = `${mauIndex}-${kichIndex}`;
  const savedSelection = variantImageSelections.value.get(variantKey);

  if (savedSelection) {
    selectedAnhFromDatabase.value = [...savedSelection.database];
    selectedAnhFromFile.value = [...savedSelection.files];
  } else {
    selectedAnhFromDatabase.value = [];
    selectedAnhFromFile.value = [];
  }

  closeAnhPopup();
};

const refreshAnhData = async () => {
  await fetchAnhSanPham();
};

const refreshAllDropdownData = async () => {
  try {
    await Promise.all([
      fetchNhaSanXuat(),
      fetchXuatXu(),
      fetchChatLieu(),
      fetchDeGiay(),
    ]);
  } catch (error) {
    console.error("Error refreshing dropdown data:", error);
  }
};

const toggleAnhFromDatabase = (anh) => {
  const index = selectedAnhFromDatabase.value.findIndex(
    (item) => item.id === anh.id
  );
  if (index === -1) {
    // Kiểm tra giới hạn 5 ảnh
    if (getTotalSelectedAnhCount() >= 5) {
      alert("Chỉ được chọn tối đa 5 ảnh!");
      return;
    }
    selectedAnhFromDatabase.value.push(anh);
  } else {
    selectedAnhFromDatabase.value.splice(index, 1);
  }
};

const handleFileSelect = async (event) => {
  const files = Array.from(event.target.files);
  const currentTotal = getTotalSelectedAnhCount();
  const maxFiles = 5 - currentTotal;

  if (files.length > maxFiles) {
    alert(`Chỉ được chọn tối đa ${maxFiles} ảnh từ máy!`);
    return;
  }

  // Validate từng file và convert sang base64
  const validFiles = [];
  const invalidFiles = [];

  for (const file of files) {
    if (validateImageFile(file)) {
      try {
        // Convert file sang base64 ngay lập tức
        const base64Url = await fileToBase64(file);
        validFiles.push({
          file: file,
          base64Url: base64Url,
          name: file.name,
          size: file.size,
          type: file.type,
        });
      } catch (error) {
        console.error(
          `<!-- icon: close --> Lỗi convert file ${file.name} sang base64:`,
          error
        );
        invalidFiles.push(file.name);
      }
    } else {
      invalidFiles.push(file.name);
    }
  }

  // Thông báo nếu có file không hợp lệ
  if (invalidFiles.length > 0) {
    alert(
      `Các file sau không hợp lệ và sẽ bị bỏ qua:\n${invalidFiles.join(
        "\n"
      )}\n\nChỉ chấp nhận ảnh JPEG, PNG, GIF, WebP và kích thước tối đa 5MB.`
    );
  }

  selectedAnhFromFile.value = validFiles;
};

const applyAnhSelection = () => {
  const { mauIndex, kichIndex } = currentEditingVariant.value;

  if (mauIndex >= 0 && kichIndex >= 0) {
    // Cập nhật ảnh cho biến thể với cả ảnh database và file
    const anhData = [
      // Ảnh từ database
      ...selectedAnhFromDatabase.value.map((anh) => ({
        type: "database",
        id: anh.id,
        url: getAnhUrl(anh),
        name: getAnhName(anh),
      })),
      // Ảnh từ file (sử dụng base64 URL để hiển thị)
      ...selectedAnhFromFile.value.map((fileData, index) => {
        return {
          type: "file",
          file: fileData.file,
          url: fileData.base64Url, // Sử dụng base64 URL đã tạo sẵn
          name: fileData.name,
          base64Url: fileData.base64Url, // Lưu để sử dụng sau
        };
      }),
    ];

    // Cập nhật ảnh cho biến thể
    const variant = productVariants.value[mauIndex]?.[kichIndex];
    if (variant) {
      variant.anh = anhData;
    }

    // Lưu trạng thái đã chọn cho biến thể này
    const variantKey = `${mauIndex}-${kichIndex}`;
    variantImageSelections.value.set(variantKey, {
      database: [...selectedAnhFromDatabase.value],
      files: [...selectedAnhFromFile.value], // Đã bao gồm base64Url
      timestamp: Date.now(),
    });

    closeAnhPopup();
  }
};

// Function xóa file đã chọn
const removeSelectedFile = (index) => {
  const fileToRemove = selectedAnhFromFile.value[index];
  if (fileToRemove) {
    // Nếu có blob URL, cleanup
    if (fileToRemove.url && fileToRemove.url.startsWith("blob:")) {
      URL.revokeObjectURL(fileToRemove.url);
    }
  }
  selectedAnhFromFile.value.splice(index, 1);
};

// Function đếm tổng số ảnh đã chọn
const getTotalSelectedAnhCount = () => {
  return (
    selectedAnhFromDatabase.value.length + selectedAnhFromFile.value.length
  );
};

// Function đếm số ảnh đã chọn cho một biến thể cụ thể
const getSelectedImageCount = (mauIndex, kichIndex) => {
  const variantKey = `${mauIndex}-${kichIndex}`;
  const savedSelection = variantImageSelections.value.get(variantKey);

  if (savedSelection) {
    return savedSelection.database.length + savedSelection.files.length;
  }

  // Nếu chưa có trạng thái lưu, đếm từ productVariants
  const anh = getVariantAnh(mauIndex, kichIndex);
  if (anh) {
    return anh.length;
  }

  return 0;
};

// Function validate file ảnh
const validateImageFile = (file) => {
  // Kiểm tra loại file
  const allowedTypes = [
    "image/jpeg",
    "image/jpg",
    "image/png",
    "image/gif",
    "image/webp",
  ];
  if (!allowedTypes.includes(file.type)) {
    console.warn(`Loại file không hợp lệ: ${file.type}`);
    return false;
  }

  // Kiểm tra kích thước file (max 5MB)
  const maxSize = 5 * 1024 * 1024; // 5MB
  if (file.size > maxSize) {
    console.warn(`File quá lớn: ${file.size} bytes`);
    return false;
  }

  return true;
};

// Function upload nhiều ảnh cùng lúc
const uploadMultipleImages = async (images) => {
  const uploadPromises = images
    .filter(
      (anh) => anh.type === "file" && anh.file && validateImageFile(anh.file)
    )
    .map(async (anh) => {
      try {
        const formData = new FormData();
        formData.append("file", anh.file);

        // Lấy phần mở rộng của file làm loaiAnh
        const fileExtension = anh.file.name.split(".").pop().toUpperCase();
        formData.append("loaiAnh", fileExtension);

        formData.append("moTa", anh.name || "Ảnh sản phẩm");

        const uploadResponse = await fetchCreateAnhSanPhamFromCloud(formData);

        // Kiểm tra response format từ API backend
        // Backend trả về: { data: [id1, id2, ...], message: "..." }
        if (
          uploadResponse &&
          uploadResponse.message &&
          uploadResponse.message.includes("thành công")
        ) {
          // Upload thành công, backend trả về list ID
          if (
            uploadResponse.data &&
            Array.isArray(uploadResponse.data) &&
            uploadResponse.data.length > 0
          ) {
            return {
              success: true,
              anhSanPhamIds: uploadResponse.data, // List ID từ backend
              originalAnh: anh,
            };
          } else {
            // Fallback: nếu không có data hoặc data rỗng, tạo temp ID
            const tempId = `temp_${Date.now()}_${Math.floor(
              Math.random() * 1000
            )}`;
            return {
              success: true,
              anhSanPhamId: tempId, // ID tạm thời
              originalAnh: anh,
            };
          }
        } else if (uploadResponse && uploadResponse.message) {
          // Có message nhưng không phải success
          console.error(
            "<!-- icon: close --> Upload ảnh thất bại:",
            uploadResponse.message
          );
          return {
            success: false,
            error: uploadResponse.message,
            originalAnh: anh,
          };
        } else if (uploadResponse && typeof uploadResponse === "object") {
          // Response object nhưng không có message
          console.warn("⚠️ Upload response không có message:", uploadResponse);
          return {
            success: false,
            error: "Response không có message",
            originalAnh: anh,
          };
        } else {
          console.error(
            "<!-- icon: close --> Upload ảnh thất bại - Response không hợp lệ:",
            uploadResponse
          );
          return {
            success: false,
            error: "Response không hợp lệ",
            originalAnh: anh,
          };
        }
      } catch (error) {
        console.error("<!-- icon: close --> Lỗi upload ảnh:", error);
        return {
          success: false,
          error: error.message,
          originalAnh: anh,
        };
      }
    });

  const results = await Promise.all(uploadPromises);
  return results;
};

// Function convert File sang base64
const fileToBase64 = (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
};

// Function tạo URL cho file (sử dụng base64 nếu có)
const getFileUrl = (file) => {
  // Nếu file đã có base64Url (từ handleFileSelect), sử dụng nó
  if (file.base64Url) {
    return file.base64Url;
  }

  // Nếu file đã có URL
  if (file.url) {
    return file.url;
  }

  // Nếu là File object thuần, tạo blob URL (fallback)
  if (file instanceof File) {
    return URL.createObjectURL(file);
  }

  // Fallback
  return file.duongDanAnh || file.src || "";
};

// Function tạo URL cho ảnh (database hoặc file)
const getAnhUrl = (anh) => {
  if (typeof anh === "string") {
    return anh; // Nếu anh là URL string
  }

  let url = "";

  if (anh && anh.duongDan) {
    url = anh.duongDan; // Nếu anh có duongDan
  } else if (anh && anh.duongDanAnh) {
    url = anh.duongDanAnh; // Nếu anh có duongDanAnh (theo backend entity)
  } else if (anh && anh.url) {
    url = anh.url; // Nếu anh có url
  } else if (anh && anh.src) {
    url = anh.src; // Nếu anh có src
  }

  // Nếu URL không có protocol (http/https), thêm base URL
  if (
    url &&
    !url.startsWith("http://") &&
    !url.startsWith("https://") &&
    !url.startsWith("data:")
  ) {
    // Xử lý trường hợp backend trả về tên file hoặc đường dẫn tương đối
    if (url.includes("/") || url.includes("\\")) {
      // Nếu đã có đường dẫn, chỉ thêm base URL
      url = `http://localhost:8080${url.startsWith("/") ? "" : "/"}${url}`;
    } else {
      // Nếu chỉ có tên file, giả sử nằm trong uploads/images
      url = `http://localhost:8080/uploads/images/${url}`;
    }
  }

  return url || ""; // Fallback
};

// Function lấy tên ảnh
const getAnhName = (anh) => {
  if (typeof anh === "string") {
    return "Ảnh sản phẩm"; // Fallback cho string
  }
  if (anh && anh.tenAnh) {
    return anh.tenAnh; // Nếu anh có tenAnh
  }
  if (anh && anh.moTa) {
    return anh.moTa; // Nếu anh có moTa
  }
  if (anh && anh.name) {
    return anh.name; // Nếu anh có name (file)
  }
  return "Ảnh sản phẩm"; // Fallback
};

// Function xử lý lỗi ảnh
const handleImageError = (event, anh) => {
  // Thay thế bằng ảnh placeholder
  const placeholder =
    "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iI2Y1ZjVmNSIvPjx0ZXh0IHg9IjUwIiB5PSI1NSIgZm9udC1mYW1pbHk9IkFyaWFsIiBmb250LXNpemU9IjEyIiBmaWxsPSIjOTk5IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIj5LaG9uZyBsb2FkPC90ZXh0Pjwvc3ZnPg==";
  event.target.src = placeholder;
  event.target.style.opacity = "0.5";
};

// Function kiểm tra URL ảnh có hợp lệ không
const isValidImageUrl = (url) => {
  return (
    url &&
    (url.startsWith("http://") ||
      url.startsWith("https://") ||
      url.startsWith("data:"))
  );
};
</script>

<style scoped>
/* CSS đã được chuyển vào productsUnified.css */
@import "../../../styles/cssSanPham/productsUnified.css";
@import "../../../styles/cssSanPham/quanLySanPham.css";

/* CSS cho dropdown */
.input-with-dropdown {
  position: relative;
}

.dropdown-list {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: white;
  border: 1px solid #ddd;
  z-index: 1000;
  max-height: 200px;
  overflow-y: auto;
}

.dropdown-item {
  padding: 8px 12px;
  cursor: pointer;
  border-bottom: 1px solid #eee;
  transition: background-color 0.2s;
}

.dropdown-item:hover {
  background-color: #f5f5f5;
}

.dropdown-item:last-child {
  border-bottom: none;
}

.dropdown-item.create-new {
  background-color: #e3f2fd;
  color: #1976d2;
  font-weight: 500;
}

.dropdown-item.create-new:hover {
  background-color: #bbdefb;
}

/* Đóng dropdown khi click ra ngoài */
.dropdown-list:focus-within {
  outline: none;
}

/* Click outside để đóng dropdown */
.click-outside {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 999;
}

/* CSS cho product form grid */
.product-form-grid {
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 70%;
  margin: 0 auto;
}

/* Layout cho các trường trong thông tin cơ bản */
.product-form-grid .product-form-field.ten-san-pham {
  width: 100%; /* Chiếm toàn bộ 70% container */
  padding: 20px;
  background: #ffffff;
  border-radius: 8px;
  border: 1px solid #e9ecef;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.product-form-grid .product-form-field.ten-san-pham .modern-label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
}

.product-form-grid .product-form-field.ten-san-pham .modern-input {
  display: block;
  width: 100%;
}

/* Layout cho các trường khác - chia thành 2 cột với input width 100% */
.product-form-grid .other-fields {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  width: 100%;
  margin: 0;
  align-items: start;
}

/* Đảm bảo các trường trong grid có width tối đa */
.other-fields .product-form-field {
  width: 100%;
}

.product-form-grid .product-form-field.nha-san-xuat,
.product-form-grid .product-form-field.xuat-xu,
.product-form-grid .product-form-field.chat-lieu,
.product-form-grid .product-form-field.de-giay {
  width: 100%;
}

/* CSS cho phần thuộc tính sản phẩm - căn thẳng với tên sản phẩm */
.product-form-grid:has(.attribute-selector) {
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 70%;
  margin: 0 auto;
  align-items: stretch;
}

/* CSS cho selected attributes */
.selected-attributes {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  min-height: 28px;
  align-items: center;
}

/* CSS riêng cho selected-attributes trong attribute-row */
.attribute-row .selected-attributes {
  margin: 0;
  min-height: auto;
}

/* Đảm bảo các input fields trong grid 2 cột có width 100% */
.other-fields .modern-input {
  width: 100%;
  box-sizing: border-box;
}

/* Đảm bảo input fields trong dropdown cũng có width 100% */
.other-fields .input-with-dropdown .modern-input {
  width: 100%;
  box-sizing: border-box;
}

/* Tối ưu hóa input fields trong grid 2 cột */
.other-fields .modern-input {
  padding: 10px 12px;
  margin: 0;
}

/* Đảm bảo dropdown list cũng có width phù hợp */
.other-fields .dropdown-list {
  width: 100%;
  box-sizing: border-box;
}

/* CSS cho phần thuộc tính sản phẩm */
.product-form-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 20px;
  width: 100%;
}

/* Row chứa label, selected attributes và button cùng hàng - căn trái */
.product-form-field .attribute-row {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  justify-content: flex-start;
}

/* Button Thêm căn trái cùng với các element khác */
.attribute-row .add-attribute-btn {
  margin-left: 0;
}

.product-form-field .modern-label {
  margin: 0;
  font-weight: 600;
  font-size: 14px;
  color: #333;
  flex-shrink: 0;
  min-width: 80px;
}

.selected-attribute-tag {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 4px 8px;
  background-color: #e3f2fd;
  color: #1976d2;
  font-size: 14px;
}

.remove-attribute-btn {
  background: none;
  border: none;
  color: #1976d2;
  cursor: pointer;
  font-size: 16px;
  padding: 0;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.remove-attribute-btn:hover {
  color: #d32f2f;
}

.add-attribute-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 0.75rem 1.5rem;
  border: 2px dashed #000000;
  border-radius: 8px;
  background: white;
  cursor: pointer;
  font-size: 0.875rem;
  font-weight: 500;
  height: 32px;
  flex-shrink: 0;
  order: 2;
  transition: all 0.2s ease;
  box-shadow: 0 2px 8px rgba(34, 197, 94, 0.1);
}

.add-attribute-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(34, 197, 94, 0.3);
}

.add-icon {
  font-size: 16px;
  font-weight: bold;
}

/* CSS cho popup */
.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.popup-content {
  background: white;
  border-radius: 4px;
  width: 90%;
  max-width: 500px;
  max-height: 80vh;
  overflow-y: auto;
  border: 1px solid #ddd;
}

.popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
}

.popup-header-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}

.refresh-btn {
  background: none;
  border: 1px solid #ddd;
  width: 30px;
  height: 30px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  transition: all 0.2s;
}

.refresh-btn:hover {
  background-color: #f5f5f5;
  border-color: #1976d2;
}

/* CSS cho dropdown refresh section */
.dropdown-refresh-section {
  padding: 10px 20px;
  border-bottom: 1px solid #eee;
  background-color: #ffffff;
}

.refresh-dropdown-btn {
  background: #1976d2;
  color: white;
  border: none;
  padding: 8px 16px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.2s;
}

.refresh-dropdown-btn:hover {
  background-color: #1565c0;
}

.popup-header h3 {
  margin: 0;
  color: #333;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #999;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  color: #333;
}

.popup-body {
  padding: 20px;
}

.search-section {
  margin-bottom: 20px;
}

.search-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.existing-attributes {
  margin-bottom: 20px;
}

.existing-attributes h4 {
  margin: 0 0 10px 0;
  color: #333;
  font-size: 16px;
}

.attribute-list {
  max-height: 200px;
  overflow-y: auto;
  border: 1px solid #eee;
}

.attribute-item {
  padding: 10px;
  cursor: pointer;
  border-bottom: 1px solid #f5f5f5;
  transition: background-color 0.2s;
}

.attribute-item:hover {
  background-color: #f5f5f5;
}

.attribute-item.selected {
  background-color: #e3f2fd;
  color: #1976d2;
  font-weight: 500;
}

.checkmark {
  color: #1976d2;
  font-weight: bold;
  margin-right: 8px;
}

.attribute-item:last-child {
  border-bottom: none;
}

.create-new-section h4 {
  margin: 0 0 10px 0;
  color: #333;
  font-size: 16px;
}

.create-new-form {
  display: flex;
  gap: 10px;
}

.attribute-create-new-form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-row {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.form-group label {
  font-size: 14px;
  font-weight: 500;
  color: #374151;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 10px;
}

.create-new-input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.create-new-btn {
  padding: 10px 16px;
  background-color: #1976d2;
  color: white;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.2s;
}

.create-new-btn:hover {
  background-color: #1565c0;
}

/* CSS cho variant table */
.variant-table-container {
  margin-bottom: 30px;
}

.variant-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.variant-table-title {
  margin: 0;
  color: #333;
  font-size: 18px;
  padding: 10px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.variant-table {
  overflow-x: auto;
}

.variant-table table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  table-layout: fixed;
}

.variant-table th,
.variant-table td {
  padding: 6px;
  text-align: center;
  border-bottom: 1px solid #eee;
  word-wrap: break-word;
}

.variant-table th {
  background-color: #ffffff;
  font-weight: 600;
  color: #333;
  text-align: center;
  font-size: 14px;
}

.variant-table td {
  font-size: 12px;
}

.variant-table tr:hover {
  background-color: #ffffff;
}

.variant-input {
  width: 100%;
  padding: 6px 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 12px;
  box-sizing: border-box;
}

/* CSS cho variant-input-s - hiển thị như text */
.variant-input-s {
  width: 100%;
  padding: 8px 12px;
  border: none;
  background-color: #ffffff;
  border-radius: 4px;
  font-size: 14px;
  color: #333;
  font-weight: 500;
  text-align: center;
  cursor: default;
  outline: none;
  box-sizing: border-box;
}

.variant-input-s:focus {
  outline: none;
  box-shadow: none;
}

/* CSS cho width của các cột */
.variant-table th:nth-child(1),
.variant-table td:nth-child(1) {
  width: 50px;
  text-align: center;
}

/* Căn giữa nội dung cột màu sắc */
.color-display {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.color-indicator {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  border: 2px solid #ddd;
}

.variant-table th:nth-child(2),
.variant-table td:nth-child(2) {
  width: 10%;
}

.variant-table th:nth-child(3),
.variant-table td:nth-child(3) {
  width: 10%;
}

.variant-table th:nth-child(4),
.variant-table td:nth-child(4) {
  width: 10%;
}

.variant-table th:nth-child(5),
.variant-table td:nth-child(5) {
  width: 10%;
}

.variant-table th:nth-child(6),
.variant-table td:nth-child(6) {
  width: 15%;
}

.variant-table th:nth-child(7),
.variant-table td:nth-child(7) {
  width: 35%;
  min-width: 180px;
}

.variant-table th:nth-child(8),
.variant-table td:nth-child(8) {
  width: 10%;
}

.variant-image-section {
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: center;
}

.image-preview-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
  justify-content: center;
}

.image-preview-item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.variant-thumbnail {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #ddd;
}

.remove-image-btn {
  position: absolute;
  top: -5px;
  right: -5px;
  background-color: #d32f2f;
  color: white;
  border: none;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s;
}

.remove-image-btn:hover {
  background-color: #b71c1c;
}

.add-image-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 8px 12px;
  background-color: #f5f5f5;
  border: 2px dashed #ddd;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  color: #666;
  transition: all 0.2s;
  min-width: 80px;
  justify-content: center;
}

.add-image-btn:hover {
  background-color: #e0e0e0;
  border-color: #999;
  color: #333;
}

.add-image-btn .add-icon {
  font-size: 14px;
  font-weight: bold;
}

/* CSS cho image selection info */
.image-selection-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.image-count-badge {
  background-color: #e3f2fd;
  color: #1976d2;
  padding: 2px 6px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 500;
  border: 1px solid #bbdefb;
}

/* CSS cho popup sửa nhanh */
.quick-edit-popup {
  max-width: 400px;
  background: white;
  border-radius: 4px;
  border: 1px solid #ddd;
}

.quick-edit-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label {
  font-weight: 500;
  color: #333;
  font-size: 14px;
}

.form-input {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-input:focus {
  outline: none;
  border-color: #1976d2;
  box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.2);
}

.popup-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-top: 1px solid #eee;
}

.btn-primary {
  padding: 12px 24px;
  border: none;
  border-radius: 4px;
  background: var(--accent-color);
  color: white;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(34, 197, 94, 0.2);
  white-space: nowrap;
  min-height: 32px;
}

.btn-primary:hover {
  /* background: var(--accent-color-dark); */
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(34, 197, 94, 0.4);
}

.btn-outline {
  padding: 12px 24px;
  border: 2px solid var(--accent-color);
  border-radius: 4px;
  background: white;
  color: var(--accent-color);
  font-size: 0.8rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(34, 197, 94, 0.1);
  white-space: nowrap;
  min-height: 32px;
}

.btn-outline:hover {
  background: var(--accent-color);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(34, 197, 94, 0.3);
}

/* CSS để tất cả button có size giống nhau */
.popup-footer .btn-outline {
  min-width: 60px;
  justify-content: center;
  padding: 0.2rem 0.6rem;
  font-size: 0.75rem;
  min-height: 28px;
}

/* CSS riêng cho các button trong popup-footer */
.popup-footer .btn-outline,
.popup-footer .btn-primary {
  height: 42px;
  border-radius: 3px;
  /* font-size: 0.7rem; */
}

.anh-title-row .btn-outline {
  min-width: 80px;
  justify-content: center;
  min-height: 28px;
}

/* CSS để hiển thị đơn vị bên trong input */
.variant-table td:nth-child(4) .variant-input {
  padding-right: 30px;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 20 20'%3E%3Ctext x='10' y='15' font-family='Arial' font-size='14' fill='%23666' text-anchor='middle'%3Eg%3C/text%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 8px center;
  background-size: 20px;
}

.variant-table td:nth-child(6) .variant-input {
  padding-right: 30px;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 20 20'%3E%3Ctext x='10' y='15' font-family='Arial' font-size='14' fill='%23666' text-anchor='middle'%3E₫%3C/text%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 8px center;
  background-size: 20px;
}

/* CSS cho popup sửa nhanh - thêm đơn vị */
.quick-edit-popup .form-field:nth-child(1) .form-input {
  padding-right: 30px;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 20 20'%3E%3Ctext x='10' y='15' font-family='Arial' font-size='14' fill='%23666' text-anchor='middle'%3Eg%3C/text%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 8px center;
  background-size: 20px;
}

.quick-edit-popup .form-field:nth-child(3) .form-input {
  padding-right: 30px;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 20 20'%3E%3Ctext x='10' y='15' font-family='Arial' font-size='14' fill='%23666' text-anchor='middle'%3E₫%3C/text%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 8px center;
  background-size: 20px;
}

/* CSS cho nút xóa biến thể */
.remove-variant-btn {
  width: 60px;
  height: 32px;
  background-color: #d32f2f;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s;
  margin: 0 auto;
}

.remove-variant-btn:hover {
  background-color: #b71c1c;
}

/* CSS cho popup confirm xóa */
.delete-confirm-popup {
  max-width: 400px;
  background: white;
  border-radius: 4px;
  border: 1px solid #ddd;
}

.confirm-message {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
  text-align: center;
}

.variant-info {
  font-size: 14px;
  color: #666;
  background-color: #ffffff;
  padding: 10px;
  border-radius: 4px;
  border: 1px solid #e9ecef;
  margin-bottom: 20px;
  text-align: center;
}

.btn-danger {
  background-color: #d32f2f;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.2s;
}

.btn-danger:hover {
  background-color: #b71c1c;
}

/* CSS cho popup ảnh */
.anh-popup {
  max-width: 900px;
  max-height: 90vh;
  background: white;
  border-radius: 4px;
  border: 1px solid #ddd;
}

/* Title row */
.anh-title-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 0 10px;
}

.anh-title-row h4 {
  margin: 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
  flex: 1;
  text-align: center;
}

.anh-title-row h4:first-child {
  text-align: left;
}

.anh-title-row h4:last-child {
  text-align: right;
}

/* Content row */
.anh-content-row {
  display: flex;
  gap: 30px;
  margin-bottom: 25px;
}

.anh-database-section,
.anh-file-section {
  flex: 1;
  margin-bottom: 0;
}

.anh-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 12px;
  max-height: 250px;
  overflow-y: auto;
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 15px;
  background-color: #ffffff;
}

.anh-item {
  position: relative;
  cursor: pointer;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.2s;
  border: 2px solid transparent;
}

.anh-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.anh-item.selected {
  border-color: #1976d2;
  box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.2);
}

.anh-thumbnail {
  width: 100%;
  height: 80px;
  object-fit: cover;
  display: block;
}

.anh-overlay {
  position: absolute;
  top: 5px;
  right: 5px;
  width: 24px;
  height: 24px;
  background-color: #1976d2;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  font-size: 14px;
}

.anh-name {
  padding: 8px;
  background-color: white;
  font-size: 12px;
  text-align: center;
  color: #333;
  border-top: 1px solid #eee;
  word-break: break-word;
}

.file-upload-area {
  border: 2px dashed #ddd;
  border-radius: 8px;
  padding: 30px;
  text-align: center;
  background-color: #ffffff;
  transition: all 0.2s;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.file-upload-area:hover {
  border-color: #1976d2;
  background-color: #e3f2fd;
}

.file-input {
  display: none;
}

.file-upload-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 15px 30px;
  background-color: #1976d2;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  font-weight: 500;
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(25, 118, 210, 0.3);
}

.file-upload-btn:hover {
  background-color: #1565c0;
}

.upload-icon {
  font-size: 18px;
}

.selected-files {
  margin-top: 15px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.selected-file {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}

.file-thumbnail {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #ddd;
}

.file-name {
  font-size: 11px;
  color: #666;
  text-align: center;
  max-width: 80px;
  word-break: break-word;
}

.remove-file-btn {
  position: absolute;
  top: -5px;
  right: -5px;
  background-color: #d32f2f;
  color: white;
  border: none;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s;
}

.remove-file-btn:hover {
  background-color: #b71c1c;
}

.selected-anh-info {
  justify-content: flex-start !important;
  margin-top: 20px;
  padding: 15px;
  background-color: transparent;
  border-radius: 0;
  border: none;
  box-shadow: none;
}

.selected-anh-info h4 {
  margin: 0 0 10px 0;
  color: #000;
  font-size: 14px;
  text-align: left;
}

.selected-anh-summary {
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #000;
  text-align: left;
}

.selected-anh-summary span {
  background-color: transparent;
  padding: 0;
  border-radius: 0;
  border: none;
  box-shadow: none;
}

/* CSS cho phần hiển thị ảnh đã chọn */
.selected-anh-display {
  margin-top: 20px;
  padding: 15px;
  background-color: #ffffff;
  border-radius: 8px;
  border: 1px solid #e9ecef;
}

.selected-anh-display h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
}

.selected-anh-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.selected-anh-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}

.selected-anh-thumbnail {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 6px;
  border: 2px solid #ddd;
}

.selected-anh-name {
  font-size: 11px;
  color: #333;
  text-align: center;
  max-width: 60px;
  word-break: break-word;
  font-weight: 500;
}

/* CSS đơn giản cho popup thuộc tính sản phẩm */
.attribute-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.attribute-popup-content {
  background: white;
  width: 90%;
  max-width: 500px;
  max-height: 80vh;
  overflow-y: auto;
  border-radius: 10px;
}

.attribute-popup-header {
  padding: 15px 20px;
  border-bottom: 1px solid #ddd;
}

.attribute-popup-body {
  padding: 20px;
}

/* CSS cho popup thông báo bên phải */
.notification-popup-overlay {
  position: fixed;
  top: 0;
  right: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 2000;
}

.notification-popup-content {
  position: fixed;
  right: 20px;
  width: 350px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  border-left: 4px solid #4ade80;
  pointer-events: auto;
  animation: slideInRight 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
  z-index: 2001;
  transform: translateX(0);
  opacity: 1;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.notification-popup-content.notification-closing {
  animation: slideOutRight 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

.notification-popup-content:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.notification-popup-content.notification-success {
  border-left-color: #4ade80;
}

.notification-popup-content.notification-error {
  border-left-color: #f44336;
}

.notification-popup-content.notification-info {
  border-left-color: #2196f3;
}

.notification-popup-content.clickable {
  cursor: pointer;
  transition: all 0.3s ease;
}

.notification-popup-content.clickable:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid #eee;
}

.notification-header h4 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.notification-close-btn {
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
  color: #999;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
}

.notification-close-btn:hover {
  background-color: #f5f5f5;
  color: #666;
  transform: scale(1.1);
  transition: all 0.2s ease;
}

.notification-close-btn:active {
  transform: scale(0.95);
}

.notification-body {
  padding: 12px 16px;
}

.notification-body p {
  margin: 0;
  font-size: 14px;
  color: #555;
  line-height: 1.4;
}

.click-hint {
  margin-top: 8px !important;
  font-size: 12px !important;
  color: #007bff !important;
  font-style: italic;
  opacity: 0.8;
}

@keyframes slideInRight {
  0% {
    transform: translateX(100%);
    opacity: 0;
  }
  60% {
    transform: translateX(-5%);
    opacity: 0.8;
  }
  100% {
    transform: translateX(0);
    opacity: 1;
  }
}

@keyframes slideOutRight {
  0% {
    transform: translateX(0);
    opacity: 1;
  }
  100% {
    transform: translateX(100%);
    opacity: 0;
  }
}

/* Responsive cho popup thông báo */
@media (max-width: 768px) {
  .notification-popup-content {
    right: 15px;
    left: 15px;
    width: auto;
    max-width: none;
  }
}

@media (max-width: 480px) {
  .notification-popup-content {
    right: 10px;
    left: 10px;
  }
}

/* CSS cho color input group */
.color-input-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.color-picker {
  width: 50px;
  height: 50px;
  border: 1px solid #d1d5db;
  border-radius: 0%;
  cursor: pointer;
  padding: 0;
  background: none;
}

.color-picker::-webkit-color-swatch-wrapper {
  padding: 0;
}

.color-picker::-webkit-color-swatch {
  border: none;
  border-radius: 0%;
}

.color-text-input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
  font-family: 'Courier New', monospace;
}

.color-text-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* CSS cho color tag trong selected attributes */
.color-tag {
  display: flex;
  align-items: center;
  gap: 8px;
  background: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 20px;
  padding: 6px 12px;
  margin: 4px;
}

.color-preview {
  width: 20px;
  height: 20px;
  border-radius: 0%;
  border: 2px solid #fff;
  box-shadow: 0 0 0 1px #d1d5db;
  flex-shrink: 0;
}

.color-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.color-name {
  font-size: 14px;
  color: #374151;
  font-weight: 500;
}

.color-hex {
  font-size: 11px;
  color: #6b7280;
  font-family: 'Courier New', monospace;
  background: #f3f4f6;
  padding: 1px 4px;
  border-radius: 3px;
}

/* CSS cho color attribute item trong popup */
.color-attribute-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.color-attribute-item:hover {
  background-color: #f9fafb;
  border-color: #d1d5db;
}

.color-attribute-item.selected {
  background-color: #eff6ff;
  border-color: #3b82f6;
}

.color-attribute-item .color-preview {
  width: 24px;
  height: 24px;
  border-radius: 0%;
  border: 2px solid #fff;
  box-shadow: 0 0 0 1px #d1d5db;
  flex-shrink: 0;
}

.color-attribute-item .color-name {
  flex: 1;
  font-size: 14px;
  color: #374151;
}

.color-attribute-item .attribute-checkmark {
  color: #3b82f6;
  font-weight: bold;
  font-size: 16px;
}

/* CSS cho loading popup */
.loading-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 3000;
}

.loading-popup-content {
  background: white;
  border-radius: 12px;
  padding: 40px;
  text-align: center;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  max-width: 400px;
  width: 90%;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-popup-content h3 {
  margin: 0 0 10px 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.loading-popup-content p {
  margin: 0;
  color: #666;
  font-size: 14px;
}

</style>

