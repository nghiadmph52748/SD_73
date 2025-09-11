<template>
  <div class="discount-coupons-container">
    <!-- Filter Section -->
    <div class="filter-section">
      <!-- Search Bar Row -->
      <div class="search-row">
        <div class="search-box">
            <input
              v-model="searchQuery"
              type="text"
            placeholder="Tìm kiếm tên phiếu giảm giá, mã hoặc tên phiếu giảm giá..."
            class="search-input"
            />
          </div>
        </div>

      <!-- Filter Controls -->
      <div class="filter-controls">
        <div class="filter-row">
          <div class="filter-item">
            <label class="filter-label">Kiểu giảm giá</label>
            <select v-model="selectedType" class="filter-select">
              <option value="">Tất cả kiểu</option>
              <option value="percent">Phần trăm (%)</option>
              <option value="fixed">Số tiền cố định</option>
            </select>
          </div>

          <div class="filter-item">
            <label class="filter-label">Đối tượng</label>
            <select v-model="selectedType2" class="filter-select">
              <option value="">Tất cả đối tượng</option>
              <option value="public">Mọi người</option>
              <option value="private">Khách hàng cụ thể</option>
            </select>
          </div>

          <div class="filter-item">
            <label class="filter-label">Hiện trạng</label>
            <select v-model="selectedStatus" class="filter-select">
              <option value="">Tất cả hiện trạng</option>
              <option value="active">Đang diễn ra</option>
              <option value="expired">Hết hạn</option>
              <option value="upcoming">Sắp diễn ra</option>
              <option value="deleted">Đã xóa</option>
            </select>
          </div>

          <div class="filter-item">
            <label class="filter-label">Trạng thái hoạt động</label>
            <select v-model="selectedActiveStatus" class="filter-select">
              <option value="">Tất cả trạng thái</option>
              <option value="active">Hoạt động</option>
              <option value="inactive">Ngừng hoạt động</option>
            </select>
          </div>

          <div class="filter-item">
            <label class="filter-label">Từ ngày</label>
            <input
              type="date"
              v-model="fromDate"
              class="filter-select"
            />
          </div>

          <div class="filter-item">
            <label class="filter-label">Đến ngày</label>
            <input
              type="date"
              v-model="toDate"
              class="filter-select"
            />
          </div>
          </div>
        </div>

      <!-- Action Buttons Row -->
      <div class="action-buttons-row">
        <button class="reset-btn" @click="clearFilters">
            Đặt lại
          </button>
        <button class="export-btn" @click="exportData">
            Xuất báo cáo
          </button>
        <button class="create-btn" @click="openAddModal">
            Tạo mới
          </button>
      </div>
    </div>

    <!-- Table Section -->
    <div class="table-container">
      <div class="table-wrapper">
        <table class="coupons-table">
          <thead>
            <tr>
              <th>STT</th>
              <th>TÊN</th>
              <th>ĐỐI TƯỢNG</th>
              <th>LOẠI GIẢM</th>
              <th>GIÁ TRỊ GIẢM</th>
              <th>SỐ TIỀN TỐI THIỂU</th>
              <th>SỐ TIỀN GIẢM TỐI ĐA</th>
              <th>THỜI GIAN</th>
              <th>SỐ LƯỢNG DÙNG</th>
              <th>MÔ TẢ</th>
              <th>HIỆN TRẠNG</th>
              <th>TRẠNG THÁI</th>
              <th>THAO TÁC</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(coupon, index) in filteredCoupons" :key="coupon.id">
              <td>{{ index + 1 }}</td>
              <td class="coupon-name">{{ coupon.tenPhieuGiamGia }}</td>
              <td>
                {{
                  getCustomerCountForCoupon(coupon.id) > 0
                    ? `${getCustomerCountForCoupon(coupon.id)} khách hàng`
                    : "Mọi người"
                }}
              </td>
              <td>
                {{ !coupon.loaiPhieuGiamGia ? "%" : "VND" }}
              </td>
              <td class="discount-value">
                {{
                  !coupon.loaiPhieuGiamGia
                    ? coupon.giaTriGiamGia + "%"
                    : formatCurrency(coupon.giaTriGiamGia)
                }}
              </td>
              <td>{{ formatCurrency(coupon.hoaDonToiThieu || 0) }}</td>
              <td>{{ formatCurrency(coupon.soTienToiDa || 0) }}</td>
              <td class="date-range">
                {{ formatDate(coupon.ngayBatDau) }} -
                {{ formatDate(coupon.ngayKetThuc) }}
              </td>
              <td>{{ coupon.soLuongDung }}</td>
              <td class="description">{{ coupon.moTa }}</td>
              <td>
                <span
                :class="[
                    'status-badge',
                    coupon.deleted ? 'status-deleted' : 
                    (getDetailedStatus(coupon) === 'Đang diễn ra' ? 'status-active' : 
                    (getDetailedStatus(coupon) === 'Sắp diễn ra' ? 'status-upcoming' : 'status-expired')),
                ]"
              >
                {{ getDetailedStatus(coupon) }}
                </span>
              </td>
              <td>
                <span
                :class="[
                    'status-badge',
                    coupon.deleted ? 'status-deleted' : (coupon.trangThai ? 'status-active' : 'status-inactive'),
                ]"
              >
                {{ getSimpleStatus(coupon) }}
                </span>
              </td>
              <td>
                <div class="action-buttons">
                  <button
                    class="action-btn view-btn"
                    @click="viewCoupon(coupon)"
                    title="Xem chi tiết"
                  >
                    <img :src="ViewIcon" alt="View" class="action-icon" />
                  </button>
                  <button
                    class="action-btn edit-btn"
                    @click="editCoupon(coupon)"
                    title="Chỉnh sửa"
                  >
                    <img :src="EditIcon" alt="Edit" class="action-icon" />
                  </button>
                  <button
                    class="action-btn delete-btn"
                    @click="fetchUpdateStatusPGG(coupon.id)"
                    title="Xóa"
                    :disabled="coupon.deleted"
                    :style="{ opacity: coupon.deleted ? 0.3 : 1 }"
                  >
                    <img :src="TrashIcon" alt="Delete" class="action-icon" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Pagination Section -->
    <div class="pagination-container">
      <div class="pagination-info">
        Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của
        {{ totalCoupons }} phiếu giảm giá
      </div>
      <div class="pagination-controls">
        <button
          class="pagination-btn"
          @click="previousPage"
          :disabled="currentPage === 1"
        >
          ❮ Trước
        </button>
        <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
        <button
          class="pagination-btn"
          @click="nextPage"
          :disabled="currentPage === totalPages"
        >
          Sau ❯
        </button>
      </div>
    </div>

    <!-- Add/Edit Modal -->
    <div
      v-if="showAddModal || showEditModal"
      class="modal-overlay-new"
      @click="closeModals"
    >
      <div class="modal-content-new modal-form-minimal" @click.stop>
        <!-- Minimal Header -->
        <div class="form-header-minimal">
          <div class="header-info-minimal">
            <div class="form-icon-minimal">
              <img :src="showAddModal ? PlusIcon : EditIcon" alt="Form" class="header-icon" />
            </div>
            <div class="form-title-minimal">
              <h3>
                {{
                  showAddModal
                    ? "Tạo phiếu giảm giá"
                    : "Cập nhật phiếu giảm giá"
                }}
              </h3>
              <div class="form-status-minimal" v-if="showEditModal">
                <img :src="EditIcon" alt="Edit" class="status-icon-minimal" />
                <span class="status-text-minimal">CHỈNH SỬA</span>
              </div>
            </div>
          </div>
          <button class="close-btn-minimal" @click="closeModals">
            <span>×</span>
          </button>
        </div>

        <!-- Minimal Body -->
        <div class="form-body-minimal">
          <form @submit.prevent="saveCoupon" class="coupon-form-minimal">
            <!-- Basic Information Section -->
            <div class="form-section-minimal">
              <div class="section-title-minimal">
                <img :src="ClipboardIcon" alt="Basic Info" class="section-icon-minimal" />
                <span>Thông tin cơ bản</span>
              </div>
              <div class="form-content-minimal">
                <div class="form-rows-minimal">
                  <div class="form-row-minimal">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Tên phiếu giảm giá</label>
                      <input
                        type="text"
                        v-model="couponForm.tenPhieuGiamGia"
                        class="form-input-minimal"
                        placeholder="Nhập tên phiếu giảm giá"
                        required
                      />
                    </div>
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Kiểu giảm giá</label>
                      <select
                        v-model="couponForm.loaiPhieuGiamGia"
                        class="form-select-minimal"
                        required
                      >
                        <option :value="false">Phần trăm (%)</option>
                        <option :value="true">Số tiền cố định (VND)</option>
                      </select>
                    </div>
                  </div>
                  <div class="form-row-minimal">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Giá trị giảm</label>
                      <input
                        type="number"
                        v-model="couponForm.giaTriGiamGia"
                        class="form-input-minimal"
                        :class="{ 'form-error': showDiscountError }"
                        :placeholder="
                          !couponForm.loaiPhieuGiamGia
                            ? 'Nhập % giảm (1-100)'
                            : 'Nhập số tiền'
                        "
                        :min="!couponForm.loaiPhieuGiamGia ? 1 : 1000"
                        :max="!couponForm.loaiPhieuGiamGia ? 100 : undefined"
                        @input="validateDiscountValue"
                        required
                      />
                      <div v-if="showDiscountError" class="error-message-minimal">
                        Giảm giá phần trăm không được vượt quá 100%
                      </div>
                    </div>
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Số lượng sử dụng</label>
                      <input
                        type="number"
                        v-model="couponForm.soLuongDung"
                        class="form-input-minimal"
                        placeholder="Nhập số lượng"
                        min="1"
                        required
                      />
                    </div>
                  </div>
                  <div class="form-row-minimal single-column">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal">Mô tả</label>
                      <textarea
                        v-model="couponForm.moTa"
                        class="form-textarea-minimal"
                        rows="3"
                        placeholder="Nhập mô tả phiếu giảm giá"
                      ></textarea>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Discount Conditions Section -->
            <div class="form-section-minimal">
              <div class="section-title-minimal">
                <img :src="MoneyIcon" alt="Discount Info" class="section-icon-minimal" />
                <span>Điều kiện áp dụng</span>
              </div>
              <div class="form-content-minimal">
                <div class="form-rows-minimal">
                  <div class="form-row-minimal">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Ngày bắt đầu</label>
                      <input
                        type="date"
                        v-model="couponForm.ngayBatDau"
                        class="form-input-minimal"
                        required
                      />
                    </div>
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Ngày kết thúc</label>
                      <input
                        type="date"
                        v-model="couponForm.ngayKetThuc"
                        class="form-input-minimal"
                        required
                      />
                    </div>
                  </div>
                  <div class="form-row-minimal">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal">Hóa đơn tối thiểu</label>
                      <input
                        type="number"
                        v-model="couponForm.hoaDonToiThieu"
                        class="form-input-minimal"
                        placeholder="Nhập giá trị đơn hàng tối thiểu"
                        min="0"
                      />
                    </div>
                    <div class="form-group-minimal" v-if="!couponForm.loaiPhieuGiamGia">
                      <label class="form-label-minimal">Giảm tối đa</label>
                      <input
                        type="number"
                        v-model="couponForm.soTienToiDa"
                        class="form-input-minimal"
                        placeholder="Số tiền giảm tối đa"
                        min="0"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Customer Selection Section -->
            <div class="form-section-minimal">
              <div class="section-title-minimal">
                <img :src="UsersIcon" alt="Customer Selection" class="section-icon-minimal" />
                <span>Đối tượng áp dụng</span>
              </div>
              <div class="form-content-minimal">
                <div class="form-rows-minimal">
                  <div class="form-row-minimal single-column">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Loại phiếu</label>
                      <select
                        v-model="couponForm.idKhachHang"
                        class="form-select-minimal"
                      >
                        <option :value="null">
                          Công khai (tất cả khách hàng)
                        </option>
                        <option value="personal">
                          Áp dụng cho khách hàng cụ thể
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <!-- Customer Selection -->
                <div
                  v-if="couponForm.idKhachHang === 'personal'"
                  class="customer-selection-minimal"
                >
                  <div class="customer-header-minimal">Chọn khách hàng áp dụng</div>
                  <div class="customer-content-minimal">
                    <div class="customer-search-minimal">
                      <input
                        type="text"
                        placeholder="Tìm kiếm khách hàng..."
                        v-model="searchCustomerQuery"
                      />
                    </div>
                    <div class="customer-actions-minimal">
                      <button type="button" class="customer-action-btn" @click="selectAllCustomers">
                        Chọn hết
                      </button>
                      <button type="button" class="customer-action-btn" @click="clearAllCustomers">
                        Bỏ chọn hết
                      </button>
                    </div>
                    <div class="customer-list-minimal">
                      <div
                        v-for="customer in availableCustomers"
                        :key="customer.id"
                        class="customer-item-minimal"
                        @click="toggleCustomerSelection(customer.id)"
                      >
                        <input
                          type="checkbox"
                          class="customer-checkbox-minimal"
                          :checked="selectedCustomers.includes(customer.id)"
                          @click.stop
                        />
                        <div class="customer-info-minimal">
                          <div class="customer-name-minimal">{{ customer.tenKhachHang }}</div>
                          <div class="customer-details-minimal">
                            <strong>EMAIL:</strong> {{ customer.email }} |
                            <strong>SĐT:</strong> {{ customer.soDienThoai }} |
                            <strong>GIỚI TÍNH:</strong> {{ customer.gioiTinh ? 'Nam' : 'Nữ' }}
                          </div>
                        </div>
                      </div>
                    </div>
                    <div v-if="selectedCustomers.length > 0" class="customer-summary-minimal">
                      Đã chọn {{ selectedCustomers.length }} khách hàng
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>

        <!-- Minimal Footer -->
        <div class="form-footer-minimal">
          <button 
            class="save-btn-minimal" 
            @click="openConfirmSaveModal"
            :disabled="!hasFormChanges"
            :class="{ 'btn-disabled': !hasFormChanges }"
          >
            <img :src="showAddModal ? PlusIcon : EditIcon" alt="Save" class="btn-icon-minimal" />
            <span>{{ showAddModal ? "Tạo phiếu giảm giá" : "Cập nhật" }}</span>
          </button>
          <button class="cancel-btn-minimal" @click="closeModals">
            <img :src="CancelIcon" alt="Cancel" class="btn-icon-minimal" />
            <span>Hủy</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Coupon Detail Modal -->
    <div
      v-if="showDetailModal"
      class="modal-overlay-new"
      @click="showDetailModal = false"
    >
      <div class="modal-content-new detail-modal-minimal" @click.stop>
        <!-- Minimal Header -->
        <div class="detail-header-minimal">
          <div class="header-info-minimal">
            <div class="coupon-icon-minimal">
              <img :src="TagIcon" alt="Coupon" class="header-icon" />
            </div>
            <div class="coupon-title-minimal">
              <h3>{{ selectedCoupon?.tenPhieuGiamGia }}</h3>
              <div class="coupon-status-minimal" v-if="selectedCoupon">
                <img 
                  :src="getDetailedStatus(selectedCoupon) === 'Đang diễn ra' ? SuccessIcon : CancelIcon" 
                  alt="Status" 
                  class="status-icon-minimal" 
                />
                <span class="status-text-minimal">{{ getDetailedStatus(selectedCoupon) }}</span>
              </div>
            </div>
          </div>
          <button class="close-btn-minimal" @click="showDetailModal = false">
            <span>×</span>
          </button>
        </div>

        <!-- Minimal Body -->
        <div class="detail-body-minimal" v-if="selectedCoupon">
          <!-- Key Information Cards -->
          <div class="info-cards-minimal">
            <!-- Discount Value Card -->
            <div class="info-card-minimal primary-card">
              <div class="card-icon-minimal">
                <img :src="MoneyIcon" alt="Discount" class="card-icon" />
              </div>
              <div class="card-content-minimal">
                <div class="card-label-minimal">Giá trị giảm</div>
                <div class="card-value-minimal primary-value">
                  {{
                    !selectedCoupon.loaiPhieuGiamGia
                      ? selectedCoupon.giaTriGiamGia + "%"
                      : formatCurrency(selectedCoupon.giaTriGiamGia)
                  }}
                </div>
                <div class="card-subtitle-minimal">
                  {{ !selectedCoupon.loaiPhieuGiamGia ? "Phần trăm" : "Số tiền cố định" }}
                </div>
              </div>
            </div>

            <!-- Usage Card -->
            <div class="info-card-minimal">
              <div class="card-icon-minimal">
                <img :src="StatisticsIcon" alt="Usage" class="card-icon" />
              </div>
              <div class="card-content-minimal">
                <div class="card-label-minimal">Đã sử dụng</div>
                <div class="card-value-minimal">
                  {{ selectedCoupon.soLuongDaDung || 0 }}/{{ selectedCoupon.soLuongDung }}
                </div>
                <div class="card-subtitle-minimal">
                  {{ selectedCoupon.soLuongDung ? Math.round(((selectedCoupon.soLuongDaDung || 0) / selectedCoupon.soLuongDung) * 100) : 0 }}% sử dụng
                </div>
              </div>
            </div>

            <!-- Time Card -->
            <div class="info-card-minimal">
              <div class="card-icon-minimal">
                <img :src="ClockIcon" alt="Time" class="card-icon" />
              </div>
              <div class="card-content-minimal">
                <div class="card-label-minimal">Thời gian còn lại</div>
                <div class="card-value-minimal">
                  {{ getTimeRemaining(selectedCoupon.ngayKetThuc) }}
                </div>
                <div class="card-subtitle-minimal">
                  {{ formatDate(selectedCoupon.ngayKetThuc) }}
                </div>
              </div>
            </div>
          </div>

          <!-- Detailed Information -->
          <div class="detail-sections-minimal">
            <!-- Basic Details -->
            <div class="detail-section-minimal">
              <div class="section-title-minimal">
                <img :src="ClipboardIcon" alt="Details" class="section-icon-minimal" />
                <span>Chi tiết</span>
              </div>
              <div class="detail-rows-minimal">
                <div class="detail-row-minimal" v-if="selectedCoupon.maPhieuGiamGia">
                  <span class="row-label-minimal">Mã phiếu:</span>
                  <span class="row-value-minimal">{{ selectedCoupon.maPhieuGiamGia }}</span>
                </div>
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Hóa đơn tối thiểu:</span>
                  <span class="row-value-minimal">{{ formatCurrency(selectedCoupon.hoaDonToiThieu || 0) }}</span>
                </div>
                <div class="detail-row-minimal" v-if="selectedCoupon.soTienToiDa">
                  <span class="row-label-minimal">Giảm tối đa:</span>
                  <span class="row-value-minimal">{{ formatCurrency(selectedCoupon.soTienToiDa) }}</span>
                </div>
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Loại phiếu:</span>
                  <span class="row-value-minimal">{{ getCouponTypeText(selectedCoupon) }}</span>
                </div>
              </div>
            </div>

            <!-- Time Information -->
            <div class="detail-section-minimal">
              <div class="section-title-minimal">
                <img :src="DateIcon" alt="Dates" class="section-icon-minimal" />
                <span>Thời gian áp dụng</span>
              </div>
              <div class="detail-rows-minimal">
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Bắt đầu:</span>
                  <span class="row-value-minimal">{{ formatDateTime(selectedCoupon.ngayBatDau) }}</span>
                </div>
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Kết thúc:</span>
                  <span class="row-value-minimal">{{ formatDateTime(selectedCoupon.ngayKetThuc) }}</span>
                </div>
              </div>
            </div>

            <!-- Customer Information (if applicable) -->
            <div class="detail-section-minimal" v-if="getCustomerCountForCoupon(selectedCoupon.id) > 0">
              <div class="section-title-minimal">
                <img :src="UsersIcon" alt="Customers" class="section-icon-minimal" />
                <span>Khách hàng áp dụng</span>
              </div>
              <div class="detail-rows-minimal">
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Số lượng:</span>
                  <span class="row-value-minimal">{{ getCustomerCountForCoupon(selectedCoupon.id) }} khách hàng</span>
                </div>
              </div>
            </div>

            <!-- Description (if available) -->
            <div class="detail-section-minimal" v-if="selectedCoupon.moTa">
              <div class="section-title-minimal">
                <img :src="ClipboardIcon" alt="Description" class="section-icon-minimal" />
                <span>Mô tả</span>
              </div>
              <div class="description-content-minimal">
                {{ selectedCoupon.moTa }}
              </div>
            </div>
          </div>
        </div>

        <!-- Minimal Footer -->
        <div class="detail-footer-minimal">
          <button class="edit-btn-minimal" @click="editFromDetail(selectedCoupon)">
            <img :src="EditIcon" alt="Edit" class="btn-icon-minimal" />
            <span>Chỉnh sửa</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Simple Notification Modal -->
    <div
      v-if="showNotificationModal"
      class="modal-overlay-new"
      @click="closeNotificationModal"
    >
      <div class="notification-modal-minimal" @click.stop>
        <!-- Icon -->
        <div class="notification-icon-container" :class="notificationData.type">
          <div class="notification-icon">
            <img 
              :src="notificationData.type === 'success' ? SuccessIcon : CancelIcon" 
              alt="Notification" 
              class="notification-icon-img"
            />
          </div>
        </div>

        <!-- Content -->
        <div class="notification-content-minimal">
          <h3 class="notification-title-minimal">{{ notificationData.title }}</h3>
          <p class="notification-message-minimal">{{ notificationData.message }}</p>
        </div>

        <!-- Action Button -->
        <div class="notification-action-minimal">
          <button class="notification-btn-minimal" :class="notificationData.type" @click="closeNotificationModal">
            <span>{{ notificationData.type === 'success' ? 'Tiếp tục' : 'Thử lại' }}</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div
      v-if="showDeleteModal"
      class="modal-overlay-new"
      @click="closeDeleteModal"
    >
      <div class="modal-content-new delete-modal-minimal" @click.stop>
        <!-- Minimal Header -->
        <div class="delete-header-minimal">
          <div class="header-info-minimal">
            <div class="delete-icon-minimal">
              <img :src="WarningIcon" alt="Warning" class="header-icon" />
            </div>
            <div class="delete-title-minimal">
              <h3>Xác nhận xóa phiếu giảm giá</h3>
              <div class="delete-status-minimal">
                <img :src="TrashIcon" alt="Delete" class="status-icon-minimal" />
                <span class="status-text-minimal">XÓA VĨNH VIỄN</span>
              </div>
            </div>
          </div>
          <button class="close-btn-minimal" @click="closeDeleteModal">
            <span>×</span>
          </button>
        </div>

        <!-- Minimal Body -->
        <div class="delete-body-minimal" v-if="deleteCouponData">
          <!-- Warning Card -->
          <div class="warning-card-minimal">
            <div class="warning-content-minimal">
              <p class="warning-text-minimal">
                Bạn có chắc chắn muốn xóa phiếu giảm giá
                <strong>"{{ deleteCouponData?.tenPhieuGiamGia }}"</strong>?
              </p>
            </div>
          </div>

          <!-- Coupon Info Card -->
          <div class="coupon-info-card-minimal">
            <div class="info-header-minimal">
              <img :src="TagIcon" alt="Coupon" class="info-icon-minimal" />
              <span>Thông tin phiếu giảm giá</span>
            </div>
            <div class="info-content-minimal">
              <div class="info-row-minimal">
                <span class="info-label-minimal">Mã phiếu:</span>
                <span class="info-value-minimal">{{ deleteCouponData.maPhieuGiamGia || "N/A" }}</span>
              </div>
              <div class="info-row-minimal">
                <span class="info-label-minimal">Giá trị:</span>
                <span class="info-value-minimal">
                  {{
                    !deleteCouponData.loaiPhieuGiamGia
                      ? deleteCouponData.giaTriGiamGia + "%"
                      : formatCurrency(deleteCouponData.giaTriGiamGia)
                  }}
                </span>
              </div>
              <div class="info-row-minimal">
                <span class="info-label-minimal">Thời gian:</span>
                <span class="info-value-minimal">
                  {{ formatDate(deleteCouponData.ngayBatDau) }} - {{ formatDate(deleteCouponData.ngayKetThuc) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Minimal Footer -->
        <div class="delete-footer-minimal">
          <button class="cancel-btn-minimal" @click="closeDeleteModal">
            <img :src="CancelIcon" alt="Cancel" class="btn-icon-minimal" />
            <span>Hủy bỏ</span>
          </button>
          <button class="delete-btn-minimal" @click="confirmDelete">
            <img :src="TrashIcon" alt="Delete" class="btn-icon-minimal" />
            <span>Xác nhận xóa</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Save Confirmation Modal -->
    <div
      v-if="showConfirmSaveModal"
      class="modal-overlay-new"
      @click="closeConfirmSaveModal"
    >
      <div class="modal-content-new confirm-save-modal-minimal" @click.stop>
        <!-- Minimal Header -->
        <div class="confirm-header-minimal">
          <div class="header-info-minimal">
            <div class="confirm-icon-minimal">
              <img :src="SuccessIcon" alt="Confirm" class="header-icon" />
            </div>
            <div class="confirm-title-minimal">
              <h3>{{ showAddModal ? 'Xác nhận tạo phiếu giảm giá' : 'Xác nhận cập nhật' }}</h3>
              <div class="confirm-status-minimal">
                <img :src="showAddModal ? PlusIcon : EditIcon" alt="Action" class="status-icon-minimal" />
                <span class="status-text-minimal">{{ showAddModal ? 'TẠO MỚI' : 'CẬP NHẬT' }}</span>
              </div>
            </div>
          </div>
          <button class="close-btn-minimal" @click="closeConfirmSaveModal">
            <span>×</span>
          </button>
        </div>

        <!-- Minimal Body -->
        <div class="confirm-body-minimal">
          <!-- Confirmation Card -->
          <div class="confirm-card-minimal">
            <div class="confirm-content-minimal">
              <p class="confirm-text-minimal">
                {{ showAddModal 
                  ? `Bạn có chắc chắn muốn tạo phiếu giảm giá "${couponForm.tenPhieuGiamGia}"?`
                  : `Bạn có chắc chắn muốn cập nhật phiếu giảm giá "${couponForm.tenPhieuGiamGia}"?`
                }}
              </p>
            </div>
          </div>

          <!-- Coupon Summary Card -->
          <div class="coupon-summary-card-minimal">
            <div class="summary-header-minimal">
              <img :src="TagIcon" alt="Coupon" class="summary-icon-minimal" />
              <span>Thông tin tóm tắt</span>
            </div>
            <div class="summary-content-minimal">
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Tên phiếu:</span>
                <span class="summary-value-minimal">{{ couponForm.tenPhieuGiamGia }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Loại giảm:</span>
                <span class="summary-value-minimal">{{ couponForm.loaiPhieuGiamGia ? 'Số tiền cố định' : 'Phần trăm (%)' }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Giá trị giảm:</span>
                <span class="summary-value-minimal">{{ couponForm.giaTriGiamGia }}{{ couponForm.loaiPhieuGiamGia ? ' VNĐ' : '%' }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Thời gian:</span>
                <span class="summary-value-minimal">{{ formatDate(couponForm.ngayBatDau) }} - {{ formatDate(couponForm.ngayKetThuc) }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Đối tượng:</span>
                <span class="summary-value-minimal">{{ couponForm.idKhachHang === 'personal' ? `${selectedCustomers.length} khách hàng cụ thể` : 'Công khai' }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Minimal Footer -->
        <div class="confirm-footer-minimal">
          <button class="cancel-btn-minimal" @click="closeConfirmSaveModal">
            <img :src="CancelIcon" alt="Cancel" class="btn-icon-minimal" />
            <span>Hủy bỏ</span>
          </button>
          <button class="confirm-btn-minimal" @click="confirmSave">
            <img :src="SuccessIcon" alt="Confirm" class="btn-icon-minimal" />
            <span>{{ showAddModal ? 'Xác nhận tạo' : 'Xác nhận cập nhật' }}</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from "vue";
import { dichVuPhieuGiamGia } from "../../services/GiamGia/dichVuPhieuGiamGia.js";
import { fetchAllPhieuGiamGiaCaNhan } from "../../services/GiamGia/PhieuGiamGiaCaNhanService.js";
import {
  fetchCreatePhieuGiamGia,
  fetchDeletePhieuGiamGia,
  fetchUpdatePhieuGiamGia,
  fetchUpdateStatusPhieuGiamGia
} from "../../services/GiamGia/PhieuGiamGiaService.js";
import { fetchAllKhachHang } from "../../services/KhachHang/KhachHangService.js";
import { exportToExcel, formatDataForExcel } from "../../utils/xuatExcel.js";

// Import icons
import CancelIcon from "@/assets/Cancel.svg";
import ClipboardIcon from "@/assets/Clipboard.svg";
import ClockIcon from "@/assets/Clock.svg";
import DateIcon from "@/assets/Date.svg";
import EditIcon from "@/assets/Edit.svg";
import MoneyIcon from "@/assets/Money.svg";
import PlusIcon from "@/assets/Plus.svg";
import StatisticsIcon from "@/assets/Statistics.svg";
import SuccessIcon from "@/assets/Success.svg";
import TagIcon from "@/assets/TagLabel.svg";
import TrashIcon from "@/assets/Trash.svg";
import UsersIcon from "@/assets/Users.svg";
import ViewIcon from "@/assets/View.svg";
import WarningIcon from "@/assets/Warning.svg";

// ===== REACTIVE DATA =====
// Search and filter data
const searchQuery = ref("");
const fromDate = ref("");
const toDate = ref("");
const selectedType = ref("");
const selectedType2 = ref("");
const selectedStatus = ref("");
const selectedActiveStatus = ref("");

// Modal control data
const showAddModal = ref(false);
const showEditModal = ref(false);
const showDetailModal = ref(false);
const showNotificationModal = ref(false);
const showDeleteModal = ref(false);
const showConfirmSaveModal = ref(false);

// Selected data
const selectedCoupon = ref(null);
const editingCoupon = ref(null);
const deleteCouponData = ref(null);

// Notification data
const notificationData = ref({
  type: "success",
  title: "",
  message: "",
  details: null,
});

// Validation data
const showDiscountError = ref(false);

// Pagination data
const currentPage = ref(1);
const itemsPerPage = ref(10);

// ===== FORM DATA =====
const couponForm = ref({
  maPhieuGiamGia: "",
  tenPhieuGiamGia: "",
  moTa: "",
  loaiPhieuGiamGia: false, // false = %, true = VND
  giaTriGiamGia: 0,
  hoaDonToiThieu: 0,
  soTienToiDa: 0,
  soLuongDung: 1,
  ngayBatDau: "",
  ngayKetThuc: "",
  trangThai: true,
  deleted: false,
  idKhachHang: [],
});

// ===== ORIGINAL FORM DATA FOR CHANGE DETECTION =====
const originalCouponForm = ref({
  maPhieuGiamGia: "",
  tenPhieuGiamGia: "",
  moTa: "",
  loaiPhieuGiamGia: false,
  giaTriGiamGia: 0,
  hoaDonToiThieu: 0,
  soTienToiDa: 0,
  soLuongDung: 1,
  ngayBatDau: "",
  ngayKetThuc: "",
  trangThai: true,
  deleted: false,
  idKhachHang: [],
});

const originalSelectedCustomers = ref([]);

// ===== DATA ARRAYS =====
const coupons = ref([]);
const personalCoupons = ref([]);
const customers = ref([]);

// ===== CUSTOMER SELECTION =====
const searchCustomerQuery = ref("");
const selectedCustomers = ref([]);
// fetch data
// ===== FETCH FUNCTIONS =====
const fetchPGG = async () => {
  try {
    console.log("<!-- icon: refresh --> Fetching fresh coupon data from backend...");
    console.log("Before fetch - coupons.value:", JSON.parse(JSON.stringify(coupons.value)));
    
    // Use the working version's approach
    const response = await dichVuPhieuGiamGia.layTatCa();
    console.log("<!-- icon: import --> Received raw coupon data:", response);
    console.log("<!-- icon: clipboard --> Sample item structure:", response[0]);
    console.log("<!-- icon: search --> Debug trangThai field:", response[0]?.trangThai, typeof response[0]?.trangThai);
    console.log("<!-- icon: search --> All fields with 'trang' in name:", Object.keys(response[0] || {}).filter(key => key.toLowerCase().includes('trang')));
    
    // Convert trangThai to proper boolean if it's coming as 0/1
    const processedResponse = response.map(coupon => ({
      ...coupon,
      trangThai: Boolean(coupon.trangThai) // This will convert 0 -> false, 1 -> true
    }));
    
    coupons.value = [...processedResponse];
    console.log("After assignment - coupons.value:", JSON.parse(JSON.stringify(coupons.value)));
    console.log("Vue reactive state changed:", coupons.value.length, "items");
    
    // Validate và cập nhật trạng thái sau khi fetch dữ liệu
    await validateAllCoupons();
    console.log("<!-- icon: check --> Coupons data updated successfully");
  } catch (error) {
    console.error("<!-- icon: close --> Error fetching phieu giam gia: ", error);
  }
};

const fetchCustomers = async () => {
  try {
    const res = await fetchAllKhachHang();
    customers.value = res.data;
  } catch (error) {
    console.error("Error fetching customers: ", error);
  }
};

const fetchPersonalPGG = async () => {
  try {
    const res = await fetchAllPhieuGiamGiaCaNhan();
    personalCoupons.value = res.data;
  } catch (error) {
    console.error("Error fetching phieu giam gia ca nhan: ", error);
  }
};

const fetchAll = async () => {
  await fetchPGG();
  await fetchCustomers();
  await fetchPersonalPGG();
};
// ===== UTILITY FUNCTIONS =====
/**
 * Get detailed status text based on dates and trangThai
 */
const getDetailedStatus = (coupon) => {
  if (coupon.deleted) return "Đã xóa";
  
  const now = new Date();
  const startDate = new Date(coupon.ngayBatDau);
  const endDate = new Date(coupon.ngayKetThuc);
  
  // Get today's date without time for comparison
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const endDateOnly = new Date(coupon.ngayKetThuc);
  endDateOnly.setHours(0, 0, 0, 0);
  
  if (now < startDate) {
    return "Sắp diễn ra";
  } else if (today > endDateOnly) {
    return "Hết hạn";
  } else if (coupon.trangThai === true) {
    return "Đang diễn ra";
  } else {
    return "Tạm dừng";
  }
};

/**
 * Get simple status text based on trangThai only
 */
const getSimpleStatus = (coupon) => {
  if (coupon.deleted) return "Đã xóa";
  return coupon.trangThai === true ? "Hoạt động" : "Ngừng hoạt động";
};

// ===== COMPUTED PROPERTIES =====
// Apply all filters first
const allFilteredCoupons = computed(() => {
  console.log("<!-- icon: refresh --> Computing allFilteredCoupons...");
  console.log("coupons.value in computed:", coupons.value.length, "items");
  
  let filtered = coupons.value;

  // Filter by search query
  if (searchQuery.value) {
    filtered = filtered.filter((coupon) =>
      coupon.tenPhieuGiamGia
        ?.toLowerCase()
        .includes(searchQuery.value.toLowerCase())
    );
  }

  // Filter by discount type (Kiểu giảm giá)
  if (selectedType.value) {
    filtered = filtered.filter((coupon) => {
      if (selectedType.value === "percent") {
        return !coupon.loaiPhieuGiamGia; // false = Phần trăm (%)
      } else if (selectedType.value === "fixed") {
        return coupon.loaiPhieuGiamGia; // true = VND
      }
      return true;
    });
  }

  // Filter by target audience (Đối tượng)
  if (selectedType2.value) {
    filtered = filtered.filter((coupon) => {
      const customerCount = getAppliedCustomers(coupon.id).length;
      const isPublic = customerCount === 0;
      const isPrivate = customerCount > 0;
      
      if (selectedType2.value === "public") {
        return isPublic; // Mọi người
      } else if (selectedType2.value === "private") {
        return isPrivate; // Khách hàng cụ thể
      }
      return true;
    });
  }

  // Filter by detailed status (Hiện trạng)
  if (selectedStatus.value) {
    filtered = filtered.filter((coupon) => {
      const detailedStatus = getDetailedStatus(coupon);
      const matches = selectedStatus.value === "deleted" ? detailedStatus === "Đã xóa" :
                     selectedStatus.value === "active" ? detailedStatus === "Đang diễn ra" :
                     selectedStatus.value === "expired" ? detailedStatus === "Hết hạn" :
                     selectedStatus.value === "upcoming" ? detailedStatus === "Sắp diễn ra" : true;
      
      return matches;
    });
  }

  // Filter by active status (Trạng thái hoạt động)
  if (selectedActiveStatus.value) {
    filtered = filtered.filter((coupon) => {
      const simpleStatus = getSimpleStatus(coupon);
      const matches = selectedActiveStatus.value === "active" ? simpleStatus === "Hoạt động" :
                     selectedActiveStatus.value === "inactive" ? simpleStatus === "Ngừng hoạt động" : true;
      
      return matches;
    });
  }

  // Filter by date range
  if (fromDate.value || toDate.value) {
    filtered = filtered.filter((coupon) => {
      const couponStartDate = new Date(coupon.ngayBatDau);
      const couponEndDate = new Date(coupon.ngayKetThuc);
      
      let passesDateFilter = true;
      
      if (fromDate.value) {
        const filterFromDate = new Date(fromDate.value);
        passesDateFilter = passesDateFilter && couponEndDate >= filterFromDate;
      }
      
      if (toDate.value) {
        const filterToDate = new Date(toDate.value);
        passesDateFilter = passesDateFilter && couponStartDate <= filterToDate;
      }
      
      return passesDateFilter;
    });
  }

  // Sort by ID in descending order (newest first), then by discount type
  filtered.sort((a, b) => {
    // First, sort by ID descending (newest vouchers first)
    const idComparison = (b.id || 0) - (a.id || 0);
    if (idComparison !== 0) {
      return idComparison;
    }
    
    // If IDs are the same, sort by discount type: Phần trăm (%) first, then VND
    if (a.loaiPhieuGiamGia === b.loaiPhieuGiamGia) {
      return 0; // Same type, maintain order
    }
    // Put Phần trăm (%) first (false), then VND (true)
    return a.loaiPhieuGiamGia ? 1 : -1;
  });

  console.log("<!-- icon: target --> Computed allFilteredCoupons result:", filtered.length, "items");
  return filtered;
});

// Paginated results from filtered data
const filteredCoupons = computed(() => {
  console.log("<!-- icon: refresh --> Computing filteredCoupons...");
  const result = allFilteredCoupons.value.slice(startIndex.value, endIndex.value);
  console.log("<!-- icon: target --> Final filteredCoupons for table:", result.length, "items");
  return result;
});

// Total coupons after filtering (for pagination)
const totalCoupons = computed(() => {
  return allFilteredCoupons.value.length;
});

// Pagination computed properties
const totalPages = computed(() =>
  Math.ceil(totalCoupons.value / itemsPerPage.value)
);

const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value);

const endIndex = computed(() =>
  Math.min(startIndex.value + itemsPerPage.value, totalCoupons.value)
);

// Customer selection computed properties
const availableCustomers = computed(() => {
  let filtered = customers.value;

  if (searchCustomerQuery.value) {
    filtered = filtered.filter(
      (customer) =>
        customer.tenKhachHang
          ?.toLowerCase()
          .includes(searchCustomerQuery.value.toLowerCase()) ||
        customer.email
          ?.toLowerCase()
          .includes(searchCustomerQuery.value.toLowerCase()) ||
        customer.soDienThoai?.includes(searchCustomerQuery.value)
    );
  }

  return filtered;
});

// Computed property to get customer count for each coupon (for table display)
const getCustomerCountForCoupon = (couponId) => {
  return getAppliedCustomers(couponId).length;
};

// ===== UTILITY METHODS =====
const formatCurrency = (amount) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    minimumFractionDigits: 0,
  })
    .format(amount)
    .replace("₫", " đ");
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("vi-VN");
};

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString("vi-VN");
};

// ===== STATUS METHODS =====
const getCouponStatus = (coupon) => {
  const now = new Date();
  const startDate = new Date(coupon.ngayBatDau);
  const endDate = new Date(coupon.ngayKetThuc);

  // Get today's date without time for comparison
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const endDateOnly = new Date(coupon.ngayKetThuc);
  endDateOnly.setHours(0, 0, 0, 0);

  if (now < startDate) {
    return "upcoming";
  } else if (today > endDateOnly) {
    return "expired";
  } else {
    return "active";
  }
};

const getStatusClass = (coupon) => {
  const status = getCouponStatus(coupon);
  const statusClasses = {
    active: "badge-success",
    expired: "badge-danger",
    upcoming: "badge-warning",
  };
  return statusClasses[status] || "badge-secondary";
};

const getStatusText = (coupon) => {
  const status = getCouponStatus(coupon);
  const statusTexts = {
    active: "Đang diễn ra",
    expired: "Hết hạn",
    upcoming: "Sắp diễn ra",
  };
  return statusTexts[status] || "Không xác định";
};

const getTimeRemaining = (endDate) => {
  if (!endDate) return "Không xác định";

  const now = new Date();
  const end = new Date(endDate);
  const diff = end - now;

  if (diff <= 0) return "Đã hết hạn";

  const days = Math.floor(diff / (1000 * 60 * 60 * 24));
  const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));

  if (days > 0) {
    return `${days} ngày ${hours} giờ`;
  } else if (hours > 0) {
    return `${hours} giờ ${minutes} phút`;
  } else {
    return `${minutes} phút`;
  }
};

// ===== VALIDATION METHODS =====
/**
 * Validate ngày và cập nhật trạng thái phiếu giảm giá
 * @param {Object} coupon - Phiếu giảm giá cần validate
 * @returns {Promise<boolean>} - True nếu có cập nhật, false nếu không
 */
const validateAndUpdateStatus = async (coupon) => {
  const now = new Date();
  const startDate = new Date(coupon.ngayBatDau);
  const endDate = new Date(coupon.ngayKetThuc);

  // Get today's date without time for comparison
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const endDateOnly = new Date(coupon.ngayKetThuc);
  endDateOnly.setHours(0, 0, 0, 0);

  // Kiểm tra nếu ngày hiện tại không nằm trong khoảng ngayBatDau và ngayKetThuc
  // Only mark as expired if today is AFTER the end date (not on the same day)
  if (now < startDate || today > endDateOnly) {
    // Cập nhật trạng thái thành false nếu không còn trong thời gian hiệu lực
    if (coupon.trangThai !== false) {
      try {
        // Gọi API cập nhật trạng thái
        await fetchUpdateStatusPhieuGiamGia(coupon.id);
        // Cập nhật trạng thái ở frontend sau khi API thành công
        coupon.trangThai = false;
        return true; // Trả về true nếu có cập nhật
      } catch (error) {
        console.error("Lỗi khi cập nhật trạng thái phiếu giảm giá:", error);
        return false; // Trả về false nếu có lỗi
      }
    }
  }
  return false; // Trả về false nếu không có cập nhật
};

/**
 * Validate tất cả phiếu giảm giá và cập nhật trạng thái
 * @returns {Promise<void>}
 */
const validateAllCoupons = async () => {
  let updatedCount = 0;

  // Sử dụng Promise.all để xử lý song song tất cả các API calls
  const updatePromises = coupons.value.map(async (coupon) => {
    const beforeStatus = coupon.trangThai;
    const wasUpdated = await validateAndUpdateStatus(coupon);
    if (wasUpdated) {
      updatedCount++;
    }
    return wasUpdated;
  });

  try {
    await Promise.all(updatePromises);

    // Log kết quả validate thay vì hiển thị notification
    if (updatedCount > 0) {
      console.log(`Đã cập nhật trạng thái ${updatedCount} phiếu giảm giá!`);
    } else {
      console.log("Validate hoàn tất! Tất cả phiếu giảm giá đều có trạng thái chính xác");
    }
  } catch (error) {
    console.error("Lỗi khi validate phiếu giảm giá:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi validate phiếu giảm giá",
      error.message
    );
  }
};

/**
 * Validate một phiếu giảm giá cụ thể
 * @param {number} couponId - ID của phiếu giảm giá
 * @returns {Promise<void>}
 */
const validateSingleCoupon = async (couponId) => {
  const coupon = coupons.value.find((c) => c.id === couponId);
  if (coupon) {
    try {
      const wasUpdated = await validateAndUpdateStatus(coupon);
      if (wasUpdated) {
        console.log(`Cập nhật trạng thái thành công cho phiếu giảm giá: ${coupon.tenPhieuGiamGia}`);
      }
    } catch (error) {
      console.error("Lỗi khi validate phiếu giảm giá:", error);
      showErrorNotification(
        "Có lỗi xảy ra khi validate phiếu giảm giá",
        error.message
      );
    }
  }
};

// ===== ACTION METHODS =====
/**
 * Xem chi tiết phiếu giảm giá
 * @param {Object} coupon - Phiếu giảm giá cần xem
 */
const viewCoupon = (coupon) => {
  selectedCoupon.value = coupon;
  showDetailModal.value = true;
};

/**
 * Toggle trạng thái của phiếu giảm giá
 * @param {Object} coupon - Phiếu giảm giá cần thay đổi trạng thái
 */
const toggleCouponStatus = async (coupon) => {
  try {
    await fetchUpdateStatusPhieuGiamGia(coupon.id);
    // Refresh data from server to ensure we have the latest state
    await fetchAll();
    console.log(`Đã cập nhật trạng thái phiếu giảm giá: ${coupon.tenPhieuGiamGia}`);
  } catch (error) {
    console.error("Lỗi khi cập nhật trạng thái:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi cập nhật trạng thái phiếu giảm giá",
      error.message
    );
  }
};

/**
 * Chỉnh sửa phiếu giảm giá
 * @param {Object} coupon - Phiếu giảm giá cần chỉnh sửa
 */
const editCoupon = (coupon) => {
  // Ensure customers data is loaded
  if (customers.value.length === 0) {
    console.warn("Customers data not loaded yet, loading...");
    fetchCustomers().then(() => {
      editCoupon(coupon); // Retry after loading
    });
    return;
  }

  editingCoupon.value = coupon;

  // Tái sử dụng hàm resetForm và cập nhật với dữ liệu mới
  resetForm();
  // Reset selectedCustomers first
  selectedCustomers.value = [];

  // Determine if this is a personal coupon (has specific customers)
  let isPersonalCoupon = false;
  let customerIds = [];

  if (coupon.idKhachHang && coupon.idKhachHang.length > 0) {
    // Primary: Has specific customers in idKhachHang array
    isPersonalCoupon = true;
    customerIds = [...coupon.idKhachHang];
  } else {
    // Check legacy personal coupons table
    const appliedCustomers = personalCoupons.value
      .filter((pc) => pc.idPhieuGiamGia === coupon.id && !pc.deleted)
      .map((pc) => pc.idKhachHang);
    
    if (appliedCustomers.length > 0) {
      isPersonalCoupon = true;
      customerIds = appliedCustomers;
    }
  }

  // Set form values
  couponForm.value = {
    ...couponForm.value, // Giữ lại cấu trúc form
    maPhieuGiamGia: coupon.maPhieuGiamGia || "",
    tenPhieuGiamGia: coupon.tenPhieuGiamGia || "",
    moTa: coupon.moTa || "",
    loaiPhieuGiamGia: coupon.loaiPhieuGiamGia || false,
    giaTriGiamGia: coupon.giaTriGiamGia || 0,
    hoaDonToiThieu: coupon.hoaDonToiThieu || 0,
    soTienToiDa: coupon.soTienToiDa || 0,
    soLuongDung: coupon.soLuongDung || 1,
    ngayBatDau: coupon.ngayBatDau ? coupon.ngayBatDau.split("T")[0] : "",
    ngayKetThuc: coupon.ngayKetThuc ? coupon.ngayKetThuc.split("T")[0] : "",
    trangThai: coupon.trangThai !== undefined ? coupon.trangThai : true,
    deleted: false, // Always set to false for edits - we don't want to soft delete when editing
    idKhachHang: isPersonalCoupon ? "personal" : null, // Set dropdown value correctly
  };

  // Set selected customers if personal coupon
  if (isPersonalCoupon) {
    selectedCustomers.value = customerIds;
  }

  // Store original form data for change detection
  originalCouponForm.value = { ...couponForm.value };
  originalSelectedCustomers.value = [...selectedCustomers.value];

  searchCustomerQuery.value = "";

  // Debug logging
  console.log("Edit Coupon Debug:", {
    originalCoupon: coupon,
    couponIdKhachHang: coupon.idKhachHang,
    formType: couponForm.value.idKhachHang,
    isPersonalCoupon: isPersonalCoupon,
    customerIds: customerIds,
    selectedCustomers: selectedCustomers.value,
    customersData: customers.value.filter((c) =>
      selectedCustomers.value.includes(c.id)
    ),
  });


  showEditModal.value = true;
};

/**
 * Chỉnh sửa phiếu giảm giá từ popup chi tiết
 * @param {Object} coupon - Phiếu giảm giá cần chỉnh sửa
 */
const editFromDetail = (coupon) => {
  // Đóng popup xem chi tiết
  showDetailModal.value = false;

  // Gọi function editCoupon để mở popup chỉnh sửa
  editCoupon(coupon);
};

/**
 * Mở popup xác nhận xóa phiếu giảm giá
 * @param {number} id - ID của phiếu giảm giá cần xóa
 */
const fetchUpdateStatusPGG = async (id) => {
  // Tìm thông tin phiếu giảm giá để hiển thị trong popup
  const coupon = coupons.value.find((c) => c.id === id);
  if (coupon) {
    // Prevent deleting already deleted coupons
    if (coupon.deleted) {
      showErrorNotification(
        "Không thể xóa phiếu giảm giá",
        "Phiếu giảm giá này đã được xóa trước đó"
      );
      return;
    }
    deleteCouponData.value = coupon;
    showDeleteModal.value = true;
  }
};

/**
 * Xác nhận xóa phiếu giảm giá
 * @returns {Promise<void>}
 */
const confirmDelete = async () => {
  if (!deleteCouponData.value) return;

  // Store coupon data before closing modal to avoid null reference
  const couponToDelete = { ...deleteCouponData.value };

  try {
    await fetchDeletePhieuGiamGia(couponToDelete.id);
    await fetchPGG(); // Reload data after delete
    closeDeleteModal();

    // Validate và cập nhật trạng thái sau khi xóa
    await validateAllCoupons();

    showSuccessNotification("Xóa phiếu giảm giá thành công!", {
      message: "Phiếu giảm giá đã được xóa khỏi hệ thống",
      tenPhieuGiamGia: couponToDelete.tenPhieuGiamGia,
      loaiPhieuGiamGia: !couponToDelete.loaiPhieuGiamGia
        ? "Phần trăm"
        : "Số tiền cố định",
      giaTriGiamGia: couponToDelete.giaTriGiamGia,
      ngayBatDau: couponToDelete.ngayBatDau,
      ngayKetThuc: couponToDelete.ngayKetThuc,
    });
  } catch (error) {
    console.error("Lỗi khi xóa phiếu giảm giá:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi xóa phiếu giảm giá",
      error.message
    );
  }
};

/**
 * Đóng popup xác nhận xóa
 */
const closeDeleteModal = () => {
  showDeleteModal.value = false;
  deleteCouponData.value = null;
};

/**
 * Mở popup xác nhận lưu
 */
const openConfirmSaveModal = () => {
  // Validate form before showing confirmation
  if (!couponForm.value.tenPhieuGiamGia.trim()) {
    showErrorNotification("Vui lòng nhập tên phiếu giảm giá!");
    return;
  }

  if (couponForm.value.giaTriGiamGia <= 0) {
    showErrorNotification("Giá trị giảm giá phải lớn hơn 0!");
    return;
  }

  // Validate percentage discount maximum 100%
  if (!couponForm.value.loaiPhieuGiamGia && couponForm.value.giaTriGiamGia > 100) {
    showErrorNotification("Giá trị giảm giá theo phần trăm không được vượt quá 100%!");
    return;
  }

  if (!couponForm.value.ngayBatDau || !couponForm.value.ngayKetThuc) {
    showErrorNotification("Vui lòng chọn ngày bắt đầu và ngày kết thúc!");
    return;
  }

  if (new Date(couponForm.value.ngayKetThuc) <= new Date(couponForm.value.ngayBatDau)) {
    showErrorNotification("Ngày kết thúc phải sau ngày bắt đầu!");
    return;
  }

  // Validate personal coupon must have customers selected
  if (couponForm.value.idKhachHang === "personal" && selectedCustomers.value.length === 0) {
    showErrorNotification("Vui lòng chọn ít nhất một khách hàng cho phiếu giảm giá cá nhân!");
    return;
  }

  showConfirmSaveModal.value = true;
};

/**
 * Đóng popup xác nhận lưu
 */
const closeConfirmSaveModal = () => {
  showConfirmSaveModal.value = false;
};

/**
 * Xác nhận lưu phiếu giảm giá
 */
const confirmSave = async () => {
  try {
    closeConfirmSaveModal();
    await saveCoupon();
  } catch (error) {
    console.error("Lỗi khi xác nhận lưu:", error);
  }
};

/**
 * Tạo phiếu giảm giá mới
 * @returns {Promise<void>}
 */
const fetchCreatePGG = async () => {
  try {
    const couponData = { ...couponForm.value };

    // Handle idKhachHang based on type
    if (couponData.idKhachHang === "personal") {
      // Set as array of selected customers
      couponData.idKhachHang =
        selectedCustomers.value.length > 0 ? selectedCustomers.value : [];
    } else {
      // Public coupon
      couponData.idKhachHang = [];
    }

    await fetchCreatePhieuGiamGia(couponData);
  } catch (error) {
    console.error("Error creating phieu giam gia: ", error);
    throw error; // Re-throw to handle in saveCoupon
  }
};
/**
 * Cập nhật phiếu giảm giá
 * @param {number} id - ID của phiếu giảm giá cần cập nhật
 * @returns {Promise<void>}
 */
const fetchUpdatePGG = async (id) => {
  try {
    const couponData = { ...couponForm.value };

    // Handle idKhachHang based on type
    if (couponData.idKhachHang === "personal") {
      // Set as array of selected customers
      couponData.idKhachHang =
        selectedCustomers.value.length > 0 ? selectedCustomers.value : [];
    } else {
      // Public coupon
      couponData.idKhachHang = [];
    }

    // CRITICAL FIX: Ensure deleted is always false for updates
    couponData.deleted = false;
    
    console.log("<!-- icon: refresh --> Updating coupon ID:", id);
    console.log("<!-- icon: export --> Sending coupon data to backend:", JSON.stringify(couponData, null, 2));
    
    await fetchUpdatePhieuGiamGia(id, couponData);
    console.log("<!-- icon: check --> Backend update API call successful");
    
    // Add a small delay to ensure database transaction completes
    await new Promise(resolve => setTimeout(resolve, 500));
    console.log("<!-- icon: timer --> Waited 500ms for database transaction");
  } catch (error) {
    console.error("Error updating phieu giam gia: ", error);
    throw error; // Re-throw to handle in saveCoupon
  }
};
/**
 * Lưu phiếu giảm giá (tạo mới hoặc cập nhật)
 * @returns {Promise<void>}
 */
const saveCoupon = async () => {
  try {
    // ===== VALIDATION =====
    if (!couponForm.value.tenPhieuGiamGia.trim()) {
      showErrorNotification("Thông tin thiếu", "Vui lòng nhập tên phiếu giảm giá");
      return;
    }

    if (
      !couponForm.value.giaTriGiamGia ||
      couponForm.value.giaTriGiamGia <= 0
    ) {
      showErrorNotification("Thông tin thiếu", "Vui lòng nhập giá trị giảm giá hợp lệ");
      return;
    }

    // Validate percentage discount maximum 100%
    if (!couponForm.value.loaiPhieuGiamGia && couponForm.value.giaTriGiamGia > 100) {
      showErrorNotification("Giá trị giảm giá không hợp lệ", "Giảm giá phần trăm không được vượt quá 100%");
      return;
    }

    if (!couponForm.value.ngayBatDau || !couponForm.value.ngayKetThuc) {
      showErrorNotification("Thông tin thiếu", "Vui lòng chọn ngày bắt đầu và kết thúc");
      return;
    }

    if (
      new Date(couponForm.value.ngayBatDau) >=
      new Date(couponForm.value.ngayKetThuc)
    ) {
      showErrorNotification("Ngày không hợp lệ", "Ngày kết thúc phải sau ngày bắt đầu");
      return;
    }

    // Validate personal coupon must have customers selected
    if (
      couponForm.value.idKhachHang === "personal" &&
      selectedCustomers.value.length === 0
    ) {
      showErrorNotification("Thông tin thiếu", "Vui lòng chọn ít nhất một khách hàng cho phiếu giảm giá cá nhân");
      return;
    }

    if (showAddModal.value) {
      // Calculate customer count for notification BEFORE closing modals
      const customerCount = couponForm.value.idKhachHang === "personal" 
        ? selectedCustomers.value.length 
        : 0;

      console.log("<!-- icon: target --> Customer count for notification:", customerCount);
      console.log("<!-- icon: target --> Form idKhachHang:", couponForm.value.idKhachHang);
      console.log("<!-- icon: target --> Selected customers length:", selectedCustomers.value.length);

      // Store form data for notification BEFORE closing modals
      const formDataForNotification = {
        tenPhieuGiamGia: couponForm.value.tenPhieuGiamGia,
        loaiPhieuGiamGia: !couponForm.value.loaiPhieuGiamGia
          ? "Phần trăm"
          : "Số tiền cố định",
        giaTriGiamGia: couponForm.value.giaTriGiamGia,
        ngayBatDau: couponForm.value.ngayBatDau,
        ngayKetThuc: couponForm.value.ngayKetThuc,
        appliedCustomers: customerCount,
      };

      // Call create API
      await fetchCreatePGG();
      currentPage.value = 1; // Reset to first page
      // Close modals and reset form
      closeModals();
      await fetchAll(); // Refresh data

      // Validate và cập nhật trạng thái sau khi tạo mới
      await validateAllCoupons();

      // Show success notification with preserved data
      showSuccessNotification("Thêm phiếu giảm giá thành công!", formDataForNotification);
    } else if (showEditModal.value && editingCoupon.value) {
      // Calculate customer count for notification BEFORE closing modals
      const customerCount = couponForm.value.idKhachHang === "personal" 
        ? selectedCustomers.value.length 
        : 0;

      // Store form data for notification BEFORE closing modals
      const formDataForNotification = {
        tenPhieuGiamGia: couponForm.value.tenPhieuGiamGia,
        loaiPhieuGiamGia: !couponForm.value.loaiPhieuGiamGia
          ? "Phần trăm"
          : "Số tiền cố định",
        giaTriGiamGia: couponForm.value.giaTriGiamGia,
        ngayBatDau: couponForm.value.ngayBatDau,
        ngayKetThuc: couponForm.value.ngayKetThuc,
        trangThai: couponForm.value.trangThai ? "Đang hoạt động" : "Tạm dừng",
        appliedCustomers: customerCount,
      };

      // Call update API using the original approach with new API
      console.log("<!-- icon: refresh --> Starting coupon update process...");
      console.log("Editing coupon:", editingCoupon.value);
      console.log("Form data:", couponForm.value);
      
      await fetchUpdatePGG(editingCoupon.value.id);
      console.log("<!-- icon: check --> Update API call completed");
      
      // Store current selected coupon ID for refresh
      const selectedCouponId = selectedCoupon.value ? selectedCoupon.value.id : null;
      const wasDetailModalOpen = showDetailModal.value;
      
      // Close modals and reset form
      closeModals();
      
      // Force refresh data
      console.log("<!-- icon: refresh --> Refreshing all data after update...");
      await fetchAll(); // Refresh all data consistently

      // Refresh selectedCoupon if view modal was open
      if (selectedCouponId && wasDetailModalOpen) {
        const updatedCoupon = coupons.value.find(c => c.id === selectedCouponId);
        if (updatedCoupon) {
          selectedCoupon.value = updatedCoupon;
          showDetailModal.value = true; // Reopen the detail modal
          console.log("<!-- icon: refresh --> Updated selectedCoupon with fresh data:", updatedCoupon);
        }
      }

      // Validate và cập nhật trạng thái sau khi cập nhật
      await validateAllCoupons();
      console.log("<!-- icon: check --> All data refreshed and validated");

      // Show success notification with preserved data
      showSuccessNotification("Cập nhật phiếu giảm giá thành công!", formDataForNotification);
    }
  } catch (error) {
    console.error("Lỗi khi lưu phiếu giảm giá:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi lưu thông tin phiếu giảm giá",
      error.message
    );
  }
};

/**
 * Đóng tất cả modal và reset form
 */
const closeModals = () => {
  showAddModal.value = false;
  showEditModal.value = false;
  showDetailModal.value = false;
  showDeleteModal.value = false;
  showConfirmSaveModal.value = false;
  editingCoupon.value = null;
  selectedCoupon.value = null;
  deleteCouponData.value = null;
  selectedCustomers.value = [];
  originalSelectedCustomers.value = [];
  searchCustomerQuery.value = "";
  showDiscountError.value = false; // Reset validation error
  resetForm();
};

// ===== NOTIFICATION METHODS =====
/**
 * Hiển thị thông báo thành công
 * @param {string} message - Nội dung thông báo
 * @param {Object} details - Chi tiết bổ sung
 */
const showSuccessNotification = (message, details = null) => {
  console.log('Showing success notification:', message, details);
  notificationData.value = {
    type: "success",
    title: "Thành công!",
    message: message,
    details: details,
  };
  showNotificationModal.value = true;
  console.log('Notification modal should be visible:', showNotificationModal.value);

  // Auto close after 5 seconds
  setTimeout(() => {
    showNotificationModal.value = false;
  }, 5000);
};

/**
 * Hiển thị thông báo lỗi
 * @param {string} message - Nội dung thông báo lỗi
 * @param {Object} errorDetails - Chi tiết lỗi
 */
const showErrorNotification = (message, errorDetails = null) => {
  console.log('Showing error notification:', message, errorDetails);
  notificationData.value = {
    type: "error",
    title: "Có lỗi xảy ra!",
    message: message,
    details: errorDetails,
  };
  showNotificationModal.value = true;
  console.log('Notification modal should be visible:', showNotificationModal.value);

  // Auto close after 8 seconds for errors
  setTimeout(() => {
    showNotificationModal.value = false;
  }, 8000);
};

/**
 * Đóng modal thông báo
 */
const closeNotificationModal = () => {
  showNotificationModal.value = false;
};

/**
 * Mở modal tạo mới phiếu giảm giá
 */
const openAddModal = () => {
  resetForm();
  selectedCustomers.value = [];
  originalSelectedCustomers.value = [];
  searchCustomerQuery.value = "";
  showAddModal.value = true;
};

// ===== CUSTOMER SELECTION METHODS =====
/**
 * Toggle chọn/bỏ chọn khách hàng
 * @param {number} customerId - ID của khách hàng
 */
const toggleCustomerSelection = (customerId) => {
  const index = selectedCustomers.value.indexOf(customerId);
  if (index > -1) {
    selectedCustomers.value.splice(index, 1);
  } else {
    selectedCustomers.value.push(customerId);
  }
};

/**
 * Chọn tất cả khách hàng
 */
const selectAllCustomers = () => {
  selectedCustomers.value = availableCustomers.value.map(
    (customer) => customer.id
  );
};

/**
 * Bỏ chọn tất cả khách hàng
 */
const clearAllCustomers = () => {
  selectedCustomers.value = [];
};

// ===== PAGINATION METHODS =====
/**
 * Reset về trang đầu tiên khi thay đổi filter
 */
const resetPagination = () => {
  currentPage.value = 1;
};

/**
 * Lấy số lượng khách hàng cá nhân của phiếu giảm giá
 * @param {number} couponId - ID của phiếu giảm giá
 * @returns {number} - Số lượng khách hàng
 */
const getPersonalCustomerCount = (couponId) => {
  return personalCoupons.value.filter(
    (pc) => pc.idPhieuGiamGia === couponId && !pc.deleted
  ).length;
};

// ===== COUPON TYPE METHODS =====
/**
 * Lấy text hiển thị loại phiếu giảm giá
 * @param {Object} coupon - Phiếu giảm giá
 * @returns {string} - Text hiển thị
 */
const getCouponTypeText = (coupon) => {
  if (coupon.idKhachHang && coupon.idKhachHang.length > 0) {
    if (coupon.idKhachHang.length === 1) {
      const customer = customers.value.find(
        (c) => c.id === coupon.idKhachHang[0]
      );
      return customer
        ? `Cá nhân: ${customer.tenKhachHang}`
        : "Khách hàng cụ thể";
    } else {
      return `Cá nhân: ${coupon.idKhachHang.length} khách hàng`;
    }
  }

  return "Công khai";
};

/**
 * Lấy CSS class cho loại phiếu giảm giá
 * @param {Object} coupon - Phiếu giảm giá
 * @returns {string} - CSS class
 */
const getCouponTypeClass = (coupon) => {
  if (coupon.idKhachHang && coupon.idKhachHang.length > 0) {
    return "badge-warning";
  }
  return "badge-success";
};

/**
 * Lấy danh sách khách hàng áp dụng phiếu giảm giá
 * @param {number} couponId - ID của phiếu giảm giá
 * @returns {Array} - Danh sách khách hàng
 */
const getAppliedCustomers = (couponId) => {
  // Find the coupon first
  const coupon = coupons.value.find((c) => c.id === couponId);

  let appliedCustomerIds = [];

  // If coupon has idKhachHang array, use that
  if (coupon && coupon.idKhachHang && coupon.idKhachHang.length > 0) {
    appliedCustomerIds = [...coupon.idKhachHang];
  }

  // Also check personal coupons table (for legacy data)
  const personalCustomerIds = personalCoupons.value
    .filter((pc) => pc.idPhieuGiamGia === couponId && !pc.deleted)
    .map((pc) => pc.idKhachHang)
    .filter((id) => id !== null);

  // Combine and deduplicate
  appliedCustomerIds = [
    ...new Set([...appliedCustomerIds, ...personalCustomerIds]),
  ];

  return customers.value.filter((customer) =>
    appliedCustomerIds.includes(customer.id)
  );
};

// Computed property to check if any filter is active
const shouldShowCustomerSelection = computed(() => {
  return couponForm.value.idKhachHang === "personal";
});

// Computed property to detect if form has changes
const hasFormChanges = computed(() => {
  // For add modal, always allow save if form is valid
  if (showAddModal.value) {
    return couponForm.value.tenPhieuGiamGia.trim() !== "" && 
           couponForm.value.giaTriGiamGia > 0 && 
           couponForm.value.ngayBatDau !== "" && 
           couponForm.value.ngayKetThuc !== "";
  }

  // For edit modal, check if any field has changed
  if (showEditModal.value && editingCoupon.value) {
    // Check form fields
    const formChanged = JSON.stringify(couponForm.value) !== JSON.stringify(originalCouponForm.value);
    
    // Check selected customers
    const customersChanged = JSON.stringify(selectedCustomers.value.sort()) !== JSON.stringify(originalSelectedCustomers.value.sort());
    
    return formChanged || customersChanged;
  }

  return false;
});

// Debug computed for form state
const formDebugInfo = computed(() => {
  return {
    formType: couponForm.value.idKhachHang,
    selectedCustomersCount: selectedCustomers.value.length,
    selectedCustomerNames: customers.value
      .filter((c) => selectedCustomers.value.includes(c.id))
      .map((c) => c.tenKhachHang),
  };
});

// Minimum start date (today)
const minStartDate = computed(() => {
  const today = new Date();
  return today.toISOString().split('T')[0];
});

// Minimum end date (day after start date)
const minEndDate = computed(() => {
  if (!couponForm.value.ngayBatDau) {
    return minStartDate.value;
  }
  const startDate = new Date(couponForm.value.ngayBatDau);
  const minEnd = new Date(startDate);
  minEnd.setDate(startDate.getDate() + 1);
  return minEnd.toISOString().split('T')[0];
});

/**
 * Reset form về trạng thái ban đầu
 */
const resetForm = () => {
  const today = new Date();
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);
  
  couponForm.value = {
    maPhieuGiamGia: "",
    tenPhieuGiamGia: "",
    moTa: "",
    loaiPhieuGiamGia: false,
    giaTriGiamGia: 0,
    hoaDonToiThieu: 0,
    soTienToiDa: 0,
    soLuongDung: 1,
    ngayBatDau: today.toISOString().split('T')[0], // Set to today
    ngayKetThuc: tomorrow.toISOString().split('T')[0], // Set to tomorrow
    trangThai: true,
    deleted: false,
    idKhachHang: null, // This will be set to array in API calls
  };

  // Reset original form data
  originalCouponForm.value = { ...couponForm.value };
};

/**
 * Chuyển về trang trước
 */
const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

/**
 * Chuyển đến trang tiếp theo
 */
const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

/**
 * Xóa tất cả filter
 */
const clearFilters = () => {
  searchQuery.value = "";
  selectedType.value = "";
  selectedType2.value = "";
  selectedStatus.value = "";
  selectedActiveStatus.value = "";
  fromDate.value = "";
  toDate.value = "";
};

/**
 * Áp dụng filter (đã được xử lý qua computed property)
 */
const applyFilters = () => {
  // Filters are already applied through computed property
};

/**
 * Làm mới dữ liệu
 */
const refreshData = () => {
  // Simulate data refresh
};

/**
 * Validate discount value in real-time
 */
const validateDiscountValue = () => {
  if (!couponForm.value.loaiPhieuGiamGia && couponForm.value.giaTriGiamGia > 100) {
    showDiscountError.value = true;
  } else {
    showDiscountError.value = false;
  }
};

/**
 * Xuất báo cáo phiếu giảm giá ra file Excel
 */
const exportData = () => {
  try {
    const headerMapping = {
      id: "ID",
      tenPhieuGiamGia: "Tên phiếu giảm giá",
      maPhieuGiamGia: "Mã phiếu",
      loaiPhieuGiamGia: "Loại giảm giá",
      giaTriGiamGia: "Giá trị giảm",
      hoaDonToiThieu: "Hóa đơn tối thiểu",
      soTienToiDa: "Số tiền tối đa",
      soLuongDung: "Số lượng",
      soLuongDaDung: "Đã sử dụng",
      ngayBatDau: "Ngày bắt đầu",
      ngayKetThuc: "Ngày kết thúc",
      trangThai: "Trạng thái",
      moTa: "Mô tả",
    };

    // Get all filtered coupons data
    const exportData = allFilteredCoupons.value.map((item) => ({
      id: item.id || "N/A",
      tenPhieuGiamGia: item.tenPhieuGiamGia || "N/A",
      maPhieuGiamGia: item.maPhieuGiamGia || "N/A",
      loaiPhieuGiamGia: !item.loaiPhieuGiamGia ? "Phần trăm (%)" : "Số tiền cố định (VND)",
      giaTriGiamGia: !item.loaiPhieuGiamGia 
        ? `${item.giaTriGiamGia}%` 
        : formatCurrency(item.giaTriGiamGia),
      hoaDonToiThieu: formatCurrency(item.hoaDonToiThieu || 0),
      soTienToiDa: formatCurrency(item.soTienToiDa || 0),
      soLuongDung: item.soLuongDung || 0,
      soLuongDaDung: item.soLuongDaDung || 0,
      ngayBatDau: item.ngayBatDau || "N/A",
      ngayKetThuc: item.ngayKetThuc || "N/A",
      trangThai: getSimpleStatus(item),
      moTa: item.moTa || "",
    }));

    // Format data for Excel with proper headers
    const formattedData = formatDataForExcel(exportData, headerMapping);

    // Export to Excel using the utility function
    const result = exportToExcel(
      formattedData,
      "PhieuGiamGia_BaoCao",
      "Danh sách phiếu giảm giá"
    );

    if (result && result.success) {
      showSuccessNotification("Xuất báo cáo Excel thành công!", {
        message: `Đã xuất ${exportData.length} phiếu giảm giá`,
        fileName: result.fileName
      });
    } else {
      showErrorNotification(
        "Có lỗi xảy ra khi xuất file Excel",
        result ? result.message : "Lỗi không xác định"
      );
    }
  } catch (error) {
    console.error("Error exporting data:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi xuất báo cáo", 
      error.message
    );
  }
};

// ===== WATCHERS =====
/**
 * Theo dõi thay đổi filter và reset pagination
 */
watch(
  [searchQuery, selectedType, selectedType2, selectedStatus, fromDate, toDate],
  () => {
    resetPagination();
  }
);

/**
 * Theo dõi thay đổi ngày bắt đầu để cập nhật ngày kết thúc tự động
 */
watch(
  () => couponForm.value.ngayBatDau,
  (newStartDate) => {
    if (newStartDate && couponForm.value.ngayKetThuc) {
      const startDate = new Date(newStartDate);
      const endDate = new Date(couponForm.value.ngayKetThuc);
      
      // If end date is before or same as start date, update it to be one day after
      if (endDate <= startDate) {
        const newEndDate = new Date(startDate);
        newEndDate.setDate(startDate.getDate() + 1);
        couponForm.value.ngayKetThuc = newEndDate.toISOString().split('T')[0];
      }
    }
  }
);

/**
 * Theo dõi thay đổi loại phiếu giảm giá để reset validation error
 */
watch(
  () => couponForm.value.loaiPhieuGiamGia,
  () => {
    showDiscountError.value = false; // Reset error when discount type changes
  }
);

// ===== LIFECYCLE HOOKS =====
onMounted(() => {
  // Don't set default date filters to avoid filtering out expired coupons
  // Users can set their own date ranges if needed
  fromDate.value = "";
  toDate.value = "";

  // Fetch initial data
  fetchPGG();
  fetchPersonalPGG();
  fetchCustomers();

  // Thiết lập interval để tự động validate trạng thái mỗi phút
  const validateInterval = setInterval(async () => {
    await validateAllCoupons();
  }, 60000); // 60000ms = 1 phút

  // Cleanup interval khi component unmount
  onUnmounted(() => {
    clearInterval(validateInterval);
  });
});
</script>

<style>
@import '@/styles/cssGiamGia/phieuGiamGia.css';
</style>

