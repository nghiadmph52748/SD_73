<template>
  <div class="discount-campaigns">
    <!-- Filter Section -->
    <div class="filter-section">
      <!-- Search Bar Row -->
      <div class="search-row">
        <div class="search-box">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm kiếm tên đợt giảm giá, mã hoặc tên đợt giảm giá..."
            class="search-input"
          />
        </div>
      </div>

      <!-- Filter Controls -->
      <div class="filter-controls">
        <div class="filter-row">
          <div class="filter-item">
            <label class="filter-label">Trạng thái</label>
            <select v-model="statusFilter" class="filter-select">
              <option value="">Tất cả trạng thái</option>
              <option value="upcoming">Sắp diễn ra</option>
              <option value="active">Đang diễn ra</option>
              <option value="expired">Đã kết thúc</option>
            </select>
          </div>

          <div class="filter-item">
            <label class="filter-label">Hiện trạng</label>
            <select v-model="hienTrangFilter" class="filter-select">
              <option value="">Tất cả hiện trạng</option>
              <option value="active">Hoạt động</option>
              <option value="inactive">Ngừng hoạt động</option>
            </select>
          </div>

          <div class="filter-item">
            <label class="filter-label">Từ ngày</label>
            <input 
              v-model="tuNgayFilter" 
              type="date" 
              class="filter-select"
              :max="denNgayFilter || undefined"
            />
          </div>

          <div class="filter-item">
            <label class="filter-label">Đến ngày</label>
            <input 
              v-model="denNgayFilter" 
              type="date" 
              class="filter-select"
              :min="tuNgayFilter || undefined"
            />
          </div>

          <div class="filter-item">
            <label class="filter-label">Giá trị giảm</label>
            <select v-model="giaTriGiamFilter" class="filter-select">
              <option value="">Tất cả giá trị</option>
              <option value="0-10">0% - 10%</option>
              <option value="10-20">10% - 20%</option>
              <option value="20-50">20% - 50%</option>
              <option value="50+">Trên 50%</option>
            </select>
          </div>

          <div class="filter-item">
            <label class="filter-label">Sắp xếp</label>
            <select v-model="sapXepFilter" class="filter-select">
              <option value="">Mặc định</option>
              <option value="name">Theo tên</option>
              <option value="date">Theo ngày</option>
              <option value="discount">Theo giá trị giảm</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Action Buttons Row -->
      <div class="action-buttons-row">
        <div class="filter-info" v-if="hasActiveFilters">
          <span class="filter-badge">
            {{ activeFiltersCount }} bộ lọc đang hoạt động
          </span>
        </div>
        <div class="action-buttons">
          <button class="reset-btn" @click="clearFilters" :disabled="!hasActiveFilters">
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
    </div>

    <!-- Table Section -->
    <div class="table-container">
      <div class="table-wrapper">
        <table class="coupons-table">
          <thead>
            <tr>
              <th>STT</th>
              <th>TÊN</th>
              <th>GIÁ TRỊ GIẢM</th>
              <th>THỜI GIAN</th>
              <th>HIỆN TRẠNG</th>
              <th>TRẠNG THÁI</th>
              <th>THAO TÁC</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(campaign, index) in filteredCampaigns" :key="campaign.id">
              <td>{{ startIndex + index + 1 }}</td>
              <td class="coupon-name">{{ campaign.tenDotGiamGia }}</td>
              <td class="discount-value">
                {{ formatDiscountValue(campaign.giaTriGiamGia) }}
              </td>
              <td class="date-range">
                {{ formatDateShort(campaign.ngayBatDau) }} -
                {{ formatDateShort(campaign.ngayKetThuc) }}
              </td>
              <td>
                <span
                  :class="[
                    'status-badge',
                    getCampaignStatusClass(campaign),
                  ]"
                >
                  {{ getCampaignStatusLabel(campaign) }}
                </span>
              </td>
              <td>
                <span
                  :class="[
                    'status-badge',
                    getCampaignTimeStatusClass(campaign),
                  ]"
                >
                  {{ getCampaignTimeStatus(campaign) }}
                </span>
              </td>
              <td>
                <div class="action-buttons">
                  <button
                    class="action-btn view-btn"
                    @click="viewCampaign(campaign)"
                    title="Xem chi tiết"
                  >
                    <img :src="ViewIcon" alt="View" class="action-icon" />
                  </button>
                  <button
                    class="action-btn edit-btn"
                    @click="editCampaign(campaign)"
                    title="Chỉnh sửa"
                  >
                    <img :src="EditIcon" alt="Edit" class="action-icon" />
                  </button>
                  <button
                    class="action-btn delete-btn"
                    @click="deleteCampaign(campaign.id)"
                    title="Xóa"
                    :disabled="campaign.deleted"
                    :style="{ opacity: campaign.deleted ? 0.3 : 1 }"
                  >
                    <img :src="TrashIcon" alt="Delete" class="action-icon" />
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="filteredCampaigns.length === 0">
              <td colspan="7" class="text-center empty-state">
                <div class="empty-message">
                  <span class="empty-icon"><!-- icon: empty-mailbox --></span>
                  <p>Không có dữ liệu chiến dịch</p>
                  <small>Hãy tạo chiến dịch đầu tiên để bắt đầu</small>
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
        {{ totalCampaigns }} đợt giảm giá
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
                    ? "Tạo đợt giảm giá"
                    : "Cập nhật đợt giảm giá"
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
          <form @submit.prevent="saveCampaign" class="coupon-form-minimal">
            <!-- Basic Information Section -->
            <div class="form-section-minimal">
              <div class="section-title-minimal">
                <img :src="ClipboardIcon" alt="Basic Info" class="section-icon-minimal" />
                <span>Thông tin cơ bản</span>
              </div>
              <div class="form-content-minimal">
                <div class="form-rows-minimal">
                  <div class="form-row-minimal single-column">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Tên đợt giảm giá</label>
                      <input
                        type="text"
                        v-model="formData.tenDotGiamGia"
                        class="form-input-minimal"
                        placeholder="Nhập tên đợt giảm giá"
                        required
                      />
                    </div>
                  </div>
                  <div class="form-row-minimal">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Giá trị giảm giá (%)</label>
                      <input
                        type="number"
                        v-model="formData.giaTriGiamGia"
                        class="form-input-minimal"
                        placeholder="Nhập % giảm (1-100)"
                        min="1"
                        max="100"
                        required
                      />
                    </div>
                    <div class="form-group-minimal" v-if="showEditModal">
                      <label class="form-label-minimal required">Trạng thái</label>
                      <select
                        v-model="formData.trangThai"
                        class="form-select-minimal"
                        :disabled="!isWithinCampaignPeriod"
                        required
                      >
                        <option :value="true">Đang hoạt động</option>
                        <option :value="false">Ngừng hoạt động</option>
                      </select>
                      <!-- Auto-update status notification -->
                      <div v-if="statusAutoUpdated" class="form-help-minimal auto-update-notification">
                        <img :src="SuccessIcon" alt="Auto Updated" class="help-icon-minimal" />
                        <span>{{ statusAutoUpdateMessage }}</span>
                      </div>
                    </div>
                  </div>
                  <!-- Auto-update notification for Add Modal -->
                  <div v-if="showAddModal && statusAutoUpdated" class="form-row-minimal single-column">
                    <div class="form-help-minimal auto-update-notification">
                      <img :src="SuccessIcon" alt="Auto Updated" class="help-icon-minimal" />
                      <span>{{ statusAutoUpdateMessage }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Schedule Section -->
            <div class="form-section-minimal">
              <div class="section-title-minimal">
                <img :src="DateIcon" alt="Schedule" class="section-icon-minimal" />
                <span>Lịch trình chiến dịch</span>
              </div>
              <div class="form-content-minimal">
                <div class="form-rows-minimal">
                  <div class="form-row-minimal">
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Ngày bắt đầu</label>
                      <input
                        type="date"
                        v-model="formData.ngayBatDau"
                        class="form-input-minimal"
                        :min="minStartDate"
                        required
                      />
                    </div>
                    <div class="form-group-minimal">
                      <label class="form-label-minimal required">Ngày kết thúc</label>
                      <input
                        type="date"
                        v-model="formData.ngayKetThuc"
                        class="form-input-minimal"
                        :min="minEndDate"
                        required
                      />
                    </div>
                  </div>
                  <div v-if="!isWithinCampaignPeriod && showEditModal" class="form-row-minimal single-column">
                    <div class="form-help-minimal warning">
                      <img :src="WarningIcon" alt="Warning" class="help-icon-minimal" />
                      <span>Chỉ có thể sửa trạng thái khi ngày hiện tại nằm trong thời gian đợt giảm giá</span>
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
            <span>{{ showAddModal ? "Tạo đợt giảm giá" : "Cập nhật" }}</span>
          </button>
          <button class="cancel-btn-minimal" @click="closeModals">
            <img :src="CancelIcon" alt="Cancel" class="btn-icon-minimal" />
            <span>Hủy</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Campaign Detail Modal -->
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
              <img :src="TagIcon" alt="Campaign" class="header-icon" />
            </div>
            <div class="coupon-title-minimal">
              <h3>{{ selectedCampaign?.tenDotGiamGia }}</h3>
              <div class="coupon-status-minimal" v-if="selectedCampaign">
                <img 
                  :src="getCampaignActualStatus(selectedCampaign) === 'active' ? SuccessIcon : CancelIcon" 
                  alt="Status" 
                  class="status-icon-minimal" 
                />
                <span class="status-text-minimal">
                  {{ getCampaignStatusLabel(selectedCampaign).toUpperCase() }}
                </span>
              </div>
            </div>
          </div>
          <button class="close-btn-minimal" @click="showDetailModal = false">
            <span>×</span>
          </button>
        </div>

        <!-- Minimal Body -->
        <div class="detail-body-minimal" v-if="selectedCampaign">
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
                  {{ selectedCampaign.giaTriGiamGia }}%
                </div>
                <div class="card-subtitle-minimal">Phần trăm giảm giá</div>
              </div>
            </div>

            <!-- Products Applied Card -->
            <div class="info-card-minimal">
              <div class="card-icon-minimal">
                <img :src="StatisticsIcon" alt="Products" class="card-icon" />
              </div>
              <div class="card-content-minimal">
                <div class="card-label-minimal">Sản phẩm áp dụng</div>
                <div class="card-value-minimal">
                  {{ getAppliedProductsCount(selectedCampaign.id) }}
                </div>
                <div class="card-subtitle-minimal">
                  {{ getActiveProductsCount(selectedCampaign.id) }} đang hoạt động
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
                  {{ getTimeRemaining(selectedCampaign) }}
                </div>
                <div class="card-subtitle-minimal">
                  {{ formatDate(selectedCampaign.ngayKetThuc) }}
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
                <span>Chi tiết chiến dịch</span>
              </div>
              <div class="detail-rows-minimal">
                <div class="detail-row-minimal" v-if="selectedCampaign.maDotGiamGia">
                  <span class="row-label-minimal">Mã đợt giảm giá:</span>
                  <span class="row-value-minimal">{{ selectedCampaign.maDotGiamGia }}</span>
                </div>
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Giá trị giảm giá:</span>
                  <span class="row-value-minimal primary-text">{{ selectedCampaign.giaTriGiamGia }}%</span>
                </div>
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Trạng thái:</span>
                  <span class="row-value-minimal" :class="getCampaignActualStatus(selectedCampaign) === 'active' ? 'success-text' : 'warning-text'">
                    {{ getCampaignStatusLabel(selectedCampaign) }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Schedule Details -->
            <div class="detail-section-minimal">
              <div class="section-title-minimal">
                <img :src="DateIcon" alt="Schedule" class="section-icon-minimal" />
                <span>Thời gian diễn ra</span>
              </div>
              <div class="detail-rows-minimal">
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Ngày bắt đầu:</span>
                  <span class="row-value-minimal">{{ formatDate(selectedCampaign.ngayBatDau) }}</span>
                </div>
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Ngày kết thúc:</span>
                  <span class="row-value-minimal">{{ formatDate(selectedCampaign.ngayKetThuc) }}</span>
                </div>
                <div class="detail-row-minimal">
                  <span class="row-label-minimal">Thời gian diễn ra:</span>
                  <span class="row-value-minimal">{{ getCampaignDuration(selectedCampaign) }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Action Section -->
          <div class="detail-actions-minimal">
            <button 
              v-if="selectedCampaign.trangThai && !selectedCampaign.deleted"
              class="action-btn-minimal primary-action" 
              @click="openApplyModal(selectedCampaign)"
            >
              <img :src="StatisticsIcon" alt="Manage" class="btn-icon-minimal" />
              <span>Quản lý sản phẩm</span>
            </button>
            <button 
              class="action-btn-minimal secondary-action" 
              @click="editCampaign(selectedCampaign)"
            >
              <img :src="EditIcon" alt="Edit" class="btn-icon-minimal" />
              <span>Chỉnh sửa</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Apply Discount Modal -->
    <!-- Apply Discount Modal - Redesigned -->
    <div v-if="showApplyModal" class="modal-overlay-new" @click="closeApplyModal">
      <div class="modal-content-new apply-modal-redesigned" @click.stop>
        <!-- Modal Header -->
        <div class="modal-header-redesigned">
          <div class="header-content-redesigned">
            <div class="header-left-redesigned">
              <div class="campaign-icon-redesigned">
                <img :src="TagIcon" alt="Campaign" class="tag-icon-redesigned" />
              </div>
              <div class="campaign-info-redesigned">
                <h2 class="campaign-title-redesigned" v-if="applyingCampaign">
                  {{ applyingCampaign.tenDotGiamGia }}
                </h2>
                <div class="campaign-status-redesigned">
                  <span class="status-badge-redesigned">HOẠT ĐỘNG</span>
                </div>
              </div>
            </div>
            <button class="close-btn-redesigned" @click="closeApplyModal">
              <img :src="CancelIcon" alt="Close" />
            </button>
          </div>
        </div>

        <!-- Modal Body - Unified Content -->
        <div class="modal-body-redesigned">
          <!-- Search and Selection Controls -->
          <div class="controls-section-redesigned">
            <div class="search-container-redesigned">
              <div class="search-input-container-redesigned">
                <img :src="SearchIcon" alt="Search" class="search-icon-redesigned" />
                <input
                  type="text"
                  placeholder="Tìm kiếm sản phẩm theo tên, màu sắc, kích thước..."
                  class="search-input-redesigned"
                  v-model="searchProductQuery"
                />
              </div>
            </div>
            
            <div class="selection-controls-redesigned">
              <div class="control-buttons-redesigned">
                <button
                  type="button"
                  class="control-btn-redesigned select-all-btn"
                  @click="selectAllAvailableProducts"
                  :disabled="availableProducts.length === 0"
                >
                  <img :src="ChecklistIcon" alt="Select All" />
                  <span>Chọn tất cả</span>
                </button>
                <button
                  type="button"
                  class="control-btn-redesigned clear-all-btn"
                  @click="clearAllProducts"
                  :disabled="selectedProducts.length === 0"
                >
                  <img :src="CancelIcon" alt="Clear All" />
                  <span>Bỏ chọn</span>
                </button>
              </div>
              
              <div class="selection-summary-redesigned">
                <div class="summary-badge-redesigned selected">
                  <span class="summary-count-redesigned">{{ selectedProducts.length }}</span>
                  <span class="summary-label-redesigned">đã chọn</span>
                </div>
                <div class="summary-badge-redesigned available">
                  <span class="summary-count-redesigned">{{ availableProducts.length }}</span>
                  <span class="summary-label-redesigned">có thể chọn</span>
                </div>
                <div class="summary-badge-redesigned unavailable" v-if="productsWithDiscount.length > 0">
                  <span class="summary-count-redesigned">{{ productsWithDiscount.length }}</span>
                  <span class="summary-label-redesigned">không khả dụng</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Products Display -->
          <div class="products-container-redesigned">
            <!-- Available Products -->
            <div v-if="availableProducts.length > 0" class="products-grid-redesigned">
              <div
                v-for="product in availableProducts"
                :key="product.id"
                class="product-card-redesigned"
                :class="{ 
                  'selected': selectedProducts.includes(product.id),
                  'applied': getProductCurrentCampaignStatus(product.id)
                }"
                @click="toggleProductSelection(product.id)"
              >
                <div class="product-selection-redesigned">
                  <div class="checkbox-container-redesigned">
                    <input
                      type="checkbox"
                      :checked="selectedProducts.includes(product.id)"
                      @click.stop="toggleProductSelection(product.id)"
                      class="product-checkbox-redesigned"
                    />
                    <div class="checkmark-redesigned"></div>
                  </div>
                </div>
                
                <div class="product-content-redesigned">
                  <div class="product-header-redesigned">
                    <h4 class="product-name-redesigned">{{ product.tenSanPham }}</h4>
                    <div class="product-status-redesigned" :class="getProductCurrentCampaignStatus(product.id) ? 'applied-status' : 'available-status'">
                      {{ getProductCurrentCampaignStatus(product.id) ? 'Đang áp dụng' : 'Sẵn sàng' }}
                    </div>
                  </div>
                  
                  <div class="product-details-redesigned">
                    <div class="product-specs-redesigned">
                      <div class="spec-item-redesigned color-spec">
                        <span class="spec-label-redesigned">{{ product.tenMauSac }}</span>
                      </div>
                      <div class="spec-item-redesigned size-spec">
                        <span class="spec-label-redesigned">{{ product.tenKichThuoc }}</span>
                      </div>
                    </div>
                    <div class="product-price-redesigned">
                      <span class="price-amount-redesigned">{{ new Intl.NumberFormat("vi-VN").format(product.giaBan) }}</span>
                      <span class="price-currency-redesigned">VNĐ</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Unavailable Products -->
            <div v-if="productsWithDiscount.length > 0" class="unavailable-section-redesigned">
              <div class="unavailable-header-redesigned">
                <img :src="WarningIcon" alt="Warning" class="warning-icon-redesigned" />
                <span class="unavailable-title-redesigned">Sản phẩm không thể áp dụng</span>
                <span class="unavailable-count-redesigned">({{ productsWithDiscount.length }})</span>
              </div>
              
              <div class="unavailable-products-redesigned">
                <div
                  v-for="product in productsWithDiscount"
                  :key="product.id"
                  class="product-card-redesigned unavailable-card"
                >
                  <div class="product-selection-redesigned">
                    <div class="checkbox-container-redesigned disabled">
                      <input type="checkbox" disabled class="product-checkbox-redesigned" />
                      <div class="checkmark-redesigned"></div>
                    </div>
                  </div>
                  
                  <div class="product-content-redesigned">
                    <div class="product-header-redesigned">
                      <h4 class="product-name-redesigned">{{ product.tenSanPham }}</h4>
                      <div class="product-status-redesigned unavailable-status">
                        Có giảm giá cao hơn
                      </div>
                    </div>
                    
                    <div class="product-details-redesigned">
                      <div class="product-specs-redesigned">
                        <div class="spec-item-redesigned color-spec">
                          <span class="spec-label-redesigned">{{ product.tenMauSac }}</span>
                        </div>
                        <div class="spec-item-redesigned size-spec">
                          <span class="spec-label-redesigned">{{ product.tenKichThuoc }}</span>
                        </div>
                      </div>
                      <div class="product-price-redesigned">
                        <span class="price-amount-redesigned">{{ new Intl.NumberFormat("vi-VN").format(product.giaBan) }}</span>
                        <span class="price-currency-redesigned">VNĐ</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Empty State -->
            <div v-if="availableProducts.length === 0 && productsWithDiscount.length === 0" class="empty-state-redesigned">
              <div class="empty-icon-redesigned">
                <img :src="WarningIcon" alt="No Products" />
              </div>
              <div class="empty-content-redesigned">
                <h3 class="empty-title-redesigned">Không có sản phẩm nào</h3>
                <p class="empty-description-redesigned">Hiện tại không có sản phẩm nào có thể áp dụng cho chiến dịch này.</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="modal-footer-redesigned">
          <div class="footer-info-redesigned">
            <span class="footer-text-redesigned">
              Đã chọn <strong>{{ selectedProducts.length }}</strong> sản phẩm để áp dụng chiến dịch
            </span>
          </div>
          <div class="footer-actions-redesigned">
            <button type="button" class="btn-cancel-redesigned" @click="closeApplyModal">
              <span>Hủy bỏ</span>
            </button>
            <button 
              type="button" 
              class="btn-confirm-redesigned" 
              @click="applyDiscountToCampaign"
              :disabled="selectedProducts.length === 0"
            >
              <img :src="SuccessIcon" alt="Confirm" />
              <span>Áp dụng chiến dịch</span>
            </button>
          </div>
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
              <h3>Xác nhận xóa đợt giảm giá</h3>
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
        <div class="delete-body-minimal" v-if="deleteCampaignData">
          <!-- Warning Card -->
          <div class="warning-card-minimal">
            <div class="warning-content-minimal">
              <p class="warning-text-minimal">
                Bạn có chắc chắn muốn xóa đợt giảm giá
                <strong>"{{ deleteCampaignData?.tenDotGiamGia }}"</strong>?
              </p>
            </div>
          </div>

          <!-- Campaign Info Card -->
          <div class="coupon-info-card-minimal">
            <div class="info-header-minimal">
              <img :src="TagIcon" alt="Campaign" class="info-icon-minimal" />
              <span>Thông tin đợt giảm giá</span>
            </div>
            <div class="info-content-minimal">
              <div class="info-row-minimal">
                <span class="info-label-minimal">Mã đợt giảm giá:</span>
                <span class="info-value-minimal">{{ deleteCampaignData.maDotGiamGia || "N/A" }}</span>
              </div>
              <div class="info-row-minimal">
                <span class="info-label-minimal">Giá trị giảm:</span>
                <span class="info-value-minimal">{{ deleteCampaignData.giaTriGiamGia }}%</span>
              </div>
              <div class="info-row-minimal">
                <span class="info-label-minimal">Thời gian:</span>
                <span class="info-value-minimal">
                  {{ formatDateShort(deleteCampaignData.ngayBatDau) }} - {{ formatDateShort(deleteCampaignData.ngayKetThuc) }}
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
              <h3>{{ showAddModal ? 'Xác nhận tạo đợt giảm giá' : 'Xác nhận cập nhật' }}</h3>
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
                  ? `Bạn có chắc chắn muốn tạo đợt giảm giá "${formData.tenDotGiamGia}"?`
                  : `Bạn có chắc chắn muốn cập nhật đợt giảm giá "${formData.tenDotGiamGia}"?`
                }}
              </p>
            </div>
          </div>

          <!-- Campaign Summary Card -->
          <div class="coupon-summary-card-minimal">
            <div class="summary-header-minimal">
              <img :src="TagIcon" alt="Campaign" class="summary-icon-minimal" />
              <span>Thông tin tóm tắt</span>
            </div>
            <div class="summary-content-minimal">
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Tên đợt giảm giá:</span>
                <span class="summary-value-minimal">{{ formData.tenDotGiamGia }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Giá trị giảm:</span>
                <span class="summary-value-minimal">{{ formatDiscountValue(formData.giaTriGiamGia) }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Ngày bắt đầu:</span>
                <span class="summary-value-minimal">{{ formatDateForDisplay(formData.ngayBatDau) }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Ngày kết thúc:</span>
                <span class="summary-value-minimal">{{ formatDateForDisplay(formData.ngayKetThuc) }}</span>
              </div>
              <div class="summary-row-minimal">
                <span class="summary-label-minimal">Trạng thái:</span>
                <span class="summary-value-minimal">{{ formData.trangThai ? 'Hoạt động' : 'Tạm dừng' }}</span>
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
import { computed, onMounted, ref, watch, nextTick } from "vue";
import {
    fetchAllChiTietDotGiamGia,
    fetchCreateChiTietDotGiamGia,
    fetchUpdateStatusChiTietDotGiamGia,
} from "../../services/GiamGia/ChiTietDotGiamGiaService";
import {
    fetchAllDotGiamGia,
    fetchCreateDotGiamGia,
    fetchDeleteDotGiamGia,
    fetchUpdateDotGiamGia
} from "../../services/GiamGia/DotGiamGiaService";
import { fetchAllChiTietSanPham } from "../../services/SanPham/ChiTietSanPhamService";
import { exportToExcel, formatDataForExcel } from "../../utils/xuatExcel";

// Import icons
import ViewIcon from "@/assets/View.svg";
import EditIcon from "@/assets/Edit.svg";
import TrashIcon from "@/assets/Trash.svg";
import CancelIcon from "@/assets/Cancel.svg";
import WarningIcon from "@/assets/Warning.svg";
import TagIcon from "@/assets/TagLabel.svg";
import SuccessIcon from "@/assets/Success.svg";
import MoneyIcon from "@/assets/Money.svg";
import StatisticsIcon from "@/assets/Statistics.svg";
import ClockIcon from "@/assets/Clock.svg";
import ClipboardIcon from "@/assets/Clipboard.svg";
import DateIcon from "@/assets/Date.svg";
import PlusIcon from "@/assets/Plus.svg";
import InfoIcon from "@/assets/Info.svg";
import ChecklistIcon from "@/assets/Checklist.svg";
import SearchIcon from "@/assets/Search.svg";

// Reactive data
const searchQuery = ref("");
const statusFilter = ref("");
const hienTrangFilter = ref("");
const tuNgayFilter = ref("");
const denNgayFilter = ref("");
const giaTriGiamFilter = ref("");
const sapXepFilter = ref("");
const showAddModal = ref(false);
const showEditModal = ref(false);
const showDetailModal = ref(false);
const showApplyModal = ref(false);
const showNotificationModal = ref(false);
const showDeleteModal = ref(false);
const showConfirmSaveModal = ref(false);
const editingCampaign = ref(null);
const selectedCampaign = ref(null);
const applyingCampaign = ref(null);
const selectedProducts = ref([]);
const deleteCampaignData = ref(null);

// Auto-update status indicators
const statusAutoUpdated = ref(false);
const statusAutoUpdateMessage = ref("");

// Notification data
const notificationData = ref({
  type: "success",
  title: "",
  message: "",
  details: null,
});

// Pagination data
const currentPage = ref(1);
const itemsPerPage = ref(10);

// Form data for campaign
const formData = ref({
  tenDotGiamGia: "",
  giaTriGiamGia: 0,
  ngayBatDau: "",
  ngayKetThuc: "",
  trangThai: true,
  deleted: false,
});

// Original form data for change detection
const originalFormData = ref({
  tenDotGiamGia: "",
  giaTriGiamGia: 0,
  ngayBatDau: "",
  ngayKetThuc: "",
  trangThai: true,
  deleted: false,
});

// Mock data
const campaigns = ref([]);
const campaignDetail = ref([]);
const productsDetails = ref([]);

// Apply form data
const applyFormData = ref({
  idDotGiamGia: null,
  selectedProductIds: [],
});
const fetchDGG = async () => {
  try {
    const res = await fetchAllDotGiamGia();
    
    // Validate and update status for all campaigns
    campaigns.value = res.data.map((campaign) =>
      validateCampaignStatus(campaign)
    );

    // After loading campaigns, validate inactive ones and update their details
    setTimeout(async () => {
      await validateInactiveCampaigns();
    }, 500); // Small delay to ensure campaign details are loaded
  } catch (error) {
    console.error("Error fetching dot giam gia:", error);
  }
};
const fetchChiTietDGG = async () => {
  try {
    const res = await fetchAllChiTietDotGiamGia();
    campaignDetail.value = res.data;
  } catch (error) {
    console.error("Error fetching chi tiet dot giam gia: ", error);
  }
};
const fetchProductsDetails = async () => {
  try {
    const res = await fetchAllChiTietSanPham();
    productsDetails.value = res.data;
  } catch (error) {
    console.error("Error fetching products details: ", error);
  }
};
// Computed
const filteredCampaigns = computed(() => {
  let filtered = campaigns.value;

  // Search filter
  if (searchQuery.value) {
    filtered = filtered.filter(
      (campaign) =>
        campaign.tenDotGiamGia
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        campaign.maDotGiamGia
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase())
    );
  }

  // Status filter
  if (statusFilter.value) {
    if (statusFilter.value === "active") {
      filtered = filtered.filter((campaign) => campaign.trangThai === true);
    } else if (statusFilter.value === "upcoming") {
      filtered = filtered.filter((campaign) => campaign.trangThai === false);
    } else if (statusFilter.value === "expired") {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      filtered = filtered.filter((campaign) => {
        const endDateOnly = new Date(campaign.ngayKetThuc);
        endDateOnly.setHours(0, 0, 0, 0);
        return today > endDateOnly;
      });
    }
  }

  // Hiện trạng filter
  if (hienTrangFilter.value) {
    if (hienTrangFilter.value === "active") {
      filtered = filtered.filter((campaign) => !campaign.deleted);
    } else if (hienTrangFilter.value === "inactive") {
      filtered = filtered.filter((campaign) => campaign.deleted);
    }
  }

  // Date range filter
  if (tuNgayFilter.value) {
    const fromDate = new Date(tuNgayFilter.value);
    filtered = filtered.filter((campaign) => {
      const startDate = new Date(campaign.ngayBatDau);
      return startDate >= fromDate;
    });
  }

  if (denNgayFilter.value) {
    const toDate = new Date(denNgayFilter.value);
    filtered = filtered.filter((campaign) => {
      const endDate = new Date(campaign.ngayKetThuc);
      return endDate <= toDate;
    });
  }

  // Giá trị giảm filter
  if (giaTriGiamFilter.value) {
    filtered = filtered.filter((campaign) => {
      const giaTri = campaign.giaTriGiamGia || 0;
      switch (giaTriGiamFilter.value) {
        case "0-10":
          return giaTri >= 0 && giaTri <= 10;
        case "10-20":
          return giaTri > 10 && giaTri <= 20;
        case "20-50":
          return giaTri > 20 && giaTri <= 50;
        case "50+":
          return giaTri > 50;
        default:
          return true;
      }
    });
  }

  // Sort filter
  if (sapXepFilter.value) {
    filtered = [...filtered].sort((a, b) => {
      switch (sapXepFilter.value) {
        case "name":
          return a.tenDotGiamGia.localeCompare(b.tenDotGiamGia);
        case "date":
          return new Date(a.ngayBatDau) - new Date(b.ngayBatDau);
        case "discount":
          return (b.giaTriGiamGia || 0) - (a.giaTriGiamGia || 0);
        default:
          return 0;
      }
    });
  } else {
    // Default sorting: newest campaigns first (by ID descending)
    filtered = [...filtered].sort((a, b) => {
      return (b.id || 0) - (a.id || 0);
    });
  }

  return filtered.slice(startIndex.value, endIndex.value);
});

// Total campaigns after filtering (for pagination)
const totalCampaigns = computed(() => {
  let filtered = campaigns.value;

  // Search filter
  if (searchQuery.value) {
    filtered = filtered.filter(
      (campaign) =>
        campaign.tenDotGiamGia
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        campaign.maDotGiamGia
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase())
    );
  }

  // Status filter
  if (statusFilter.value) {
    if (statusFilter.value === "active") {
      filtered = filtered.filter((campaign) => campaign.trangThai === true);
    } else if (statusFilter.value === "upcoming") {
      filtered = filtered.filter((campaign) => campaign.trangThai === false);
    } else if (statusFilter.value === "expired") {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      filtered = filtered.filter((campaign) => {
        const endDateOnly = new Date(campaign.ngayKetThuc);
        endDateOnly.setHours(0, 0, 0, 0);
        return today > endDateOnly;
      });
    }
  }

  // Hiện trạng filter
  if (hienTrangFilter.value) {
    if (hienTrangFilter.value === "active") {
      filtered = filtered.filter((campaign) => !campaign.deleted);
    } else if (hienTrangFilter.value === "inactive") {
      filtered = filtered.filter((campaign) => campaign.deleted);
    }
  }

  // Date range filter
  if (tuNgayFilter.value) {
    const fromDate = new Date(tuNgayFilter.value);
    filtered = filtered.filter((campaign) => {
      const startDate = new Date(campaign.ngayBatDau);
      return startDate >= fromDate;
    });
  }

  if (denNgayFilter.value) {
    const toDate = new Date(denNgayFilter.value);
    filtered = filtered.filter((campaign) => {
      const endDate = new Date(campaign.ngayKetThuc);
      return endDate <= toDate;
    });
  }

  // Giá trị giảm filter
  if (giaTriGiamFilter.value) {
    filtered = filtered.filter((campaign) => {
      const giaTri = campaign.giaTriGiamGia || 0;
      switch (giaTriGiamFilter.value) {
        case "0-10":
          return giaTri >= 0 && giaTri <= 10;
        case "10-20":
          return giaTri > 10 && giaTri <= 20;
        case "20-50":
          return giaTri > 20 && giaTri <= 50;
        case "50+":
          return giaTri > 50;
        default:
          return true;
      }
    });
  }

  return filtered.length;
});

// Pagination computed properties
const totalPages = computed(() =>
  Math.ceil(totalCampaigns.value / itemsPerPage.value)
);

const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value);

const endIndex = computed(() =>
  Math.min(startIndex.value + itemsPerPage.value, totalCampaigns.value)
);

// Computed property to check if any filter is active
const hasActiveFilters = computed(() => {
  return searchQuery.value || 
         statusFilter.value || 
         hienTrangFilter.value || 
         tuNgayFilter.value || 
         denNgayFilter.value || 
         giaTriGiamFilter.value || 
         sapXepFilter.value;
});

// Computed property to get active filters count
const activeFiltersCount = computed(() => {
  let count = 0;
  if (searchQuery.value) count++;
  if (statusFilter.value) count++;
  if (hienTrangFilter.value) count++;
  if (tuNgayFilter.value) count++;
  if (denNgayFilter.value) count++;
  if (giaTriGiamFilter.value) count++;
  if (sapXepFilter.value) count++;
  return count;
});

// Check if current date is within campaign period
const isWithinCampaignPeriod = computed(() => {
  if (!editingCampaign.value) return false;

  const now = new Date();
  const startDate = new Date(editingCampaign.value.ngayBatDau);
  const endDate = new Date(editingCampaign.value.ngayKetThuc);

  return now >= startDate && now <= endDate;
});

// Date validation computed properties
const minStartDate = computed(() => {
  const today = new Date();
  return today.toISOString().split('T')[0];
});

const minEndDate = computed(() => {
  if (!formData.value.ngayBatDau) {
    return minStartDate.value;
  }
  const startDate = new Date(formData.value.ngayBatDau);
  const minEnd = new Date(startDate);
  minEnd.setDate(startDate.getDate() + 1);
  return minEnd.toISOString().split('T')[0];
});

// Computed property to detect if form has changes
const hasFormChanges = computed(() => {
  // For add modal, always allow save if form is valid
  if (showAddModal.value) {
    return formData.value.tenDotGiamGia.trim() !== "" && 
           formData.value.giaTriGiamGia > 0 && 
           formData.value.ngayBatDau !== "" && 
           formData.value.ngayKetThuc !== "";
  }

  // For edit modal, check if any field has changed
  if (showEditModal.value && editingCampaign.value) {
    const hasChanged = JSON.stringify(formData.value) !== JSON.stringify(originalFormData.value);
    return hasChanged;
  }

  return false;
});

// Watch for start date changes and auto-adjust end date if needed
watch(
  () => formData.value.ngayBatDau,
  (newStartDate) => {
    if (newStartDate && formData.value.ngayKetThuc) {
      const startDate = new Date(newStartDate);
      const endDate = new Date(formData.value.ngayKetThuc);

      // If end date is before or same as start date, update it to be one day after
      if (endDate <= startDate) {
        const newEndDate = new Date(startDate);
        newEndDate.setDate(startDate.getDate() + 1);
        formData.value.ngayKetThuc = newEndDate.toISOString().split('T')[0];
      }
      
      // Also update status based on new start date
      const now = new Date();
      const originalStatus = formData.value.trangThai;
      // Set time to end of day for end date comparison
      const endDateWithTime = new Date(formData.value.ngayKetThuc);
      endDateWithTime.setHours(23, 59, 59, 999);
      
      // Get today's date without time for comparison
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const endDateOnly = new Date(formData.value.ngayKetThuc);
      endDateOnly.setHours(0, 0, 0, 0);
      
      if (today > endDateOnly) {
        // Campaign has ended - set to inactive (only after the end date has passed)
        formData.value.trangThai = false;
        if (originalStatus !== false) {
          statusAutoUpdated.value = true;
          statusAutoUpdateMessage.value = "Trạng thái đã được tự động chuyển thành 'Ngừng hoạt động' vì chiến dịch đã kết thúc";
          setTimeout(() => { statusAutoUpdated.value = false; }, 5000);
        }
      } else if (startDate <= now && now <= endDateWithTime) {
        // Campaign is currently active period - set to active
        formData.value.trangThai = true;
        if (originalStatus !== true) {
          statusAutoUpdated.value = true;
          statusAutoUpdateMessage.value = "Trạng thái đã được tự động chuyển thành 'Đang hoạt động' vì chiến dịch đang trong thời gian diễn ra";
          setTimeout(() => { statusAutoUpdated.value = false; }, 5000);
        }
      } else if (startDate > now) {
        // Campaign hasn't started yet - set to active (for upcoming campaigns)
        formData.value.trangThai = true;
        if (originalStatus !== true) {
          statusAutoUpdated.value = true;
          statusAutoUpdateMessage.value = "Trạng thái đã được tự động chuyển thành 'Đang hoạt động' cho chiến dịch sắp diễn ra";
          setTimeout(() => { statusAutoUpdated.value = false; }, 5000);
        }
      }
    }
  }
);

// Watch for end date changes and auto-update status based on campaign timeline
watch(
  () => formData.value.ngayKetThuc,
  (newEndDate) => {
    if (newEndDate && formData.value.ngayBatDau) {
      const now = new Date();
      const startDate = new Date(formData.value.ngayBatDau);
      const endDate = new Date(newEndDate);
      const originalStatus = formData.value.trangThai;
      
      // Set time to end of day for end date comparison
      endDate.setHours(23, 59, 59, 999);
      
      // Get today's date without time for comparison
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const endDateOnly = new Date(newEndDate);
      endDateOnly.setHours(0, 0, 0, 0);
      
      // Auto-update status based on campaign timeline
      if (today > endDateOnly) {
        // Campaign has ended - set to inactive (only after the end date has passed)
        formData.value.trangThai = false;
        if (originalStatus !== false) {
          statusAutoUpdated.value = true;
          statusAutoUpdateMessage.value = "Trạng thái đã được tự động chuyển thành 'Ngừng hoạt động' vì ngày kết thúc đã qua";
          setTimeout(() => { statusAutoUpdated.value = false; }, 5000);
        }
        console.log("Campaign end date has passed - automatically set to inactive");
      } else if (startDate <= now && now <= endDate) {
        // Campaign is currently active period - set to active (user can still change this)
        formData.value.trangThai = true;
        if (originalStatus !== true) {
          statusAutoUpdated.value = true;
          statusAutoUpdateMessage.value = "Trạng thái đã được tự động chuyển thành 'Đang hoạt động' vì chiến dịch đang trong thời gian diễn ra";
          setTimeout(() => { statusAutoUpdated.value = false; }, 5000);
        }
        console.log("Campaign is in active period - automatically set to active");
      } else if (startDate > now) {
        // Campaign hasn't started yet - set to active (for upcoming campaigns)
        formData.value.trangThai = true;
        if (originalStatus !== true) {
          statusAutoUpdated.value = true;
          statusAutoUpdateMessage.value = "Trạng thái đã được tự động chuyển thành 'Đang hoạt động' cho chiến dịch sắp diễn ra";
          setTimeout(() => { statusAutoUpdated.value = false; }, 5000);
        }
        console.log("Campaign is upcoming - set to active (will be upcoming status)");
      }
    }
  }
);

// Validate and auto-update campaign status based on dates
const validateCampaignStatus = (campaign) => {
  const now = new Date();
  const startDate = new Date(campaign.ngayBatDau);
  const endDate = new Date(campaign.ngayKetThuc);

  // Get today's date without time for comparison
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const endDateOnly = new Date(campaign.ngayKetThuc);
  endDateOnly.setHours(0, 0, 0, 0);

  // If campaign has ended (after end date has passed completely), force it to inactive
  if (today > endDateOnly) {
    campaign.trangThai = false;
  }
  
  return campaign;
};

// Update campaign detail status when campaign becomes inactive
const updateCampaignDetailsStatus = async (campaignId) => {
  try {
    // Find all campaign details for this campaign
    const relatedDetails = campaignDetail.value.filter(
      (detail) => detail.idDotGiamGia === campaignId && !detail.deleted
    );

    // Update status for each detail
    for (const detail of relatedDetails) {
      await fetchUpdateStatusChiTietDotGiamGia(detail.id);
    }
  } catch (error) {
    console.error("Error updating campaign details status:", error);
  }
};

// Validate inactive campaigns and update their details
const validateInactiveCampaigns = async () => {
  const inactiveCampaigns = campaigns.value.filter(
    (campaign) => !campaign.trangThai
  );

  for (const campaign of inactiveCampaigns) {
    await updateCampaignDetailsStatus(campaign.id);
  }

  if (inactiveCampaigns.length > 0) {
    console.log(`Validated and updated ${inactiveCampaigns.length} inactive campaigns`);
    // Refresh campaign details after updates
    await fetchChiTietDGG();
  }
};

// Auto-update discount priorities when campaigns end
const updateDiscountPriorities = async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const endedCampaigns = campaigns.value.filter(campaign => {
    const endDateOnly = new Date(campaign.ngayKetThuc);
    endDateOnly.setHours(0, 0, 0, 0);
    return today > endDateOnly && campaign.trangThai;
  });

  for (const endedCampaign of endedCampaigns) {
    // Set campaign as inactive
    endedCampaign.trangThai = false;
    
    // Update campaign details status
    await updateCampaignDetailsStatus(endedCampaign.id);
    
    console.log(`Campaign "${endedCampaign.tenDotGiamGia}" has ended and been deactivated`);
  }

  if (endedCampaigns.length > 0) {
    console.log(`Updated priorities for ${endedCampaigns.length} ended campaigns`);
    // Refresh data to reflect new priorities
    await fetchDGG();
    await fetchChiTietDGG();
  }
};

// Methods
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("vi-VN", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const formatDateShort = (dateString) => {
  return new Date(dateString).toLocaleDateString("vi-VN", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
};

// Function to format date for input fields
const formatDateForInput = (dateString) => {
  if (!dateString) return "";
  const date = new Date(dateString);
  return date.toISOString().split('T')[0];
};

// Function to parse date from input
const parseDateFromInput = (dateString) => {
  if (!dateString) return "";
  // Convert dd/mm/yyyy to yyyy-mm-dd for input
  if (dateString.includes('/')) {
    const parts = dateString.split('/');
    if (parts.length === 3) {
      return `${parts[2]}-${parts[1].padStart(2, '0')}-${parts[0].padStart(2, '0')}`;
    }
  }
  return dateString;
};

// Function to format date for display
const formatDateForDisplay = (dateString) => {
  if (!dateString) return "";
  const date = new Date(dateString);
  return date.toLocaleDateString("vi-VN", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
};

// Function to get today's date in YYYY-MM-DD format
const getTodayDate = () => {
  const today = new Date();
  return today.toISOString().split('T')[0];
};

// Watch for date input changes to ensure proper date range
watch(tuNgayFilter, (newValue) => {
  if (newValue && denNgayFilter.value && newValue > denNgayFilter.value) {
    denNgayFilter.value = newValue;
  }
});

watch(denNgayFilter, (newValue) => {
  if (newValue && tuNgayFilter.value && newValue < tuNgayFilter.value) {
    tuNgayFilter.value = newValue;
  }
});

const viewCampaign = (campaign) => {
  selectedCampaign.value = campaign;
  showDetailModal.value = true;
};

const editCampaign = (campaign) => {
  // Validate and auto-update campaign status before editing
  const validatedCampaign = validateCampaignStatus({ ...campaign });

  editingCampaign.value = validatedCampaign;
  formData.value = {
    tenDotGiamGia: validatedCampaign.tenDotGiamGia,
    giaTriGiamGia: validatedCampaign.giaTriGiamGia,
    ngayBatDau: validatedCampaign.ngayBatDau,
    ngayKetThuc: validatedCampaign.ngayKetThuc,
    trangThai: validatedCampaign.trangThai,
    deleted: false, // Always keep deleted as false during editing
  };
  
  // Store original form data for change detection - use shallow copy like PhieuGiamGia
  originalFormData.value = { ...formData.value };
  
  // Đóng popup chi tiết nếu đang mở
  if (showDetailModal.value) {
    showDetailModal.value = false;
  }
  
  // Mở popup chỉnh sửa
  showEditModal.value = true;
};

const deleteCampaign = (id) => {
  openDeleteModal(id);
};

const saveCampaign = async () => {
  try {
    // Validate form data
    if (!formData.value.tenDotGiamGia.trim()) {
      showErrorNotification("Thông tin thiếu", "Vui lòng nhập tên đợt giảm giá");
      return;
    }

    if (!formData.value.giaTriGiamGia || formData.value.giaTriGiamGia <= 0) {
      showErrorNotification("Thông tin thiếu", "Vui lòng nhập giá trị giảm giá hợp lệ");
      return;
    }

    if (!formData.value.ngayBatDau || !formData.value.ngayKetThuc) {
      showErrorNotification("Thông tin thiếu", "Vui lòng chọn ngày bắt đầu và kết thúc");
      return;
    }

    if (
      new Date(formData.value.ngayBatDau) >=
      new Date(formData.value.ngayKetThuc)
    ) {
      showErrorNotification("Ngày không hợp lệ", "Ngày kết thúc phải sau ngày bắt đầu");
      return;
    }

    if (showAddModal.value) {
      await fetchCreateDotGiamGia(formData.value);
      currentPage.value = 1; // Reset to first page
      
      showSuccessNotification("Thêm đợt giảm giá thành công!", {
        tenDotGiamGia: formData.value.tenDotGiamGia,
        giaTriGiamGia: formData.value.giaTriGiamGia,
        ngayBatDau: formData.value.ngayBatDau,
        ngayKetThuc: formData.value.ngayKetThuc,
      });
    } else if (showEditModal.value && editingCampaign.value) {
      const oldStatus = editingCampaign.value.trangThai;
      await fetchUpdateDotGiamGia(editingCampaign.value.id, formData.value);

      // If campaign status changed from true to false, update related details
      if (oldStatus && !formData.value.trangThai) {
        await updateCampaignDetailsStatus(editingCampaign.value.id);
        showSuccessNotification(
          "Cập nhật đợt giảm giá thành công!", 
          {
            message: "Các sản phẩm liên quan đã được vô hiệu hóa",
            tenDotGiamGia: formData.value.tenDotGiamGia,
            giaTriGiamGia: formData.value.giaTriGiamGia,
            ngayBatDau: formData.value.ngayBatDau,
            ngayKetThuc: formData.value.ngayKetThuc,
          }
        );
      } else {
        showSuccessNotification("Cập nhật đợt giảm giá thành công!", {
          tenDotGiamGia: formData.value.tenDotGiamGia,
          giaTriGiamGia: formData.value.giaTriGiamGia,
          ngayBatDau: formData.value.ngayBatDau,
          ngayKetThuc: formData.value.ngayKetThuc,
        });
      }
    }

    // Refresh data after save
    await fetchDGG();
    
    // Force reactivity update
    await nextTick();
    
    // If we're editing and the detail modal is open, update the selected campaign
    if (showEditModal.value && editingCampaign.value && selectedCampaign.value?.id === editingCampaign.value.id) {
      // Find the updated campaign in the campaigns array
      const updatedCampaign = campaigns.value.find(c => c.id === editingCampaign.value.id);
      if (updatedCampaign) {
        selectedCampaign.value = { ...updatedCampaign };
      }
    }
    
    closeModals();
  } catch (error) {
    console.error("Lỗi khi lưu đợt giảm giá:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi lưu thông tin đợt giảm giá",
      error.message
    );
  }
};

const closeModals = () => {
  showAddModal.value = false;
  showEditModal.value = false;
  showDetailModal.value = false;
  showConfirmSaveModal.value = false;
  editingCampaign.value = null;
  selectedCampaign.value = null;
  resetForm();
};

const resetForm = () => {
  const today = new Date();
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);

  formData.value = {
    tenDotGiamGia: "",
    giaTriGiamGia: 0,
    ngayBatDau: today.toISOString().split('T')[0], // Set to today
    ngayKetThuc: tomorrow.toISOString().split('T')[0], // Set to tomorrow
    trangThai: true,
    deleted: false,
  };

  // Reset original form data - use shallow copy like PhieuGiamGia
  originalFormData.value = { ...formData.value };
  
  // Reset auto-update status indicators
  statusAutoUpdated.value = false;
  statusAutoUpdateMessage.value = "";
};

// Search for products in apply modal
const searchProductQuery = ref("");

// Check if product already has active discount - returns the campaign with highest discount
const getProductDiscountStatus = (productId) => {
  const activeDiscounts = campaignDetail.value.filter(
    (detail) => detail.idChiTietSanPham === productId && !detail.deleted
  );
  
  if (activeDiscounts.length === 0) return null;
  
  // Find the campaign with highest discount value
  let highestDiscount = null;
  let maxDiscountValue = 0;
  
  for (const detail of activeDiscounts) {
    const campaign = campaigns.value.find(c => c.id === detail.idDotGiamGia);
    if (campaign && campaign.giaTriGiamGia > maxDiscountValue) {
      maxDiscountValue = campaign.giaTriGiamGia;
      highestDiscount = detail;
    }
  }
  
  return highestDiscount;
};

// Check if product belongs to current campaign
const getProductCurrentCampaignStatus = (productId) => {
  if (!applyingCampaign.value) return null;
  return campaignDetail.value.find(
    (detail) =>
      detail.idChiTietSanPham === productId &&
      detail.idDotGiamGia === applyingCampaign.value.id &&
      !detail.deleted
  );
};

// Get available products (can be in multiple campaigns, but current campaign should have highest discount)
const availableProducts = computed(() => {
  return productsDetails.value.filter((product) => {
    const discountStatus = getProductDiscountStatus(product.id);
    const currentCampaignStatus = getProductCurrentCampaignStatus(product.id);
    const currentCampaign = applyingCampaign.value;

    // Always allow if no active discounts
    if (!discountStatus) return true;
    
    // Allow if current campaign has the highest discount
    if (currentCampaignStatus && currentCampaign) {
      const currentDiscountValue = currentCampaign.giaTriGiamGia;
      const highestDiscountCampaign = campaigns.value.find(c => c.id === discountStatus.idDotGiamGia);
      
      // Allow if current campaign has higher or equal discount value
      return currentDiscountValue >= (highestDiscountCampaign?.giaTriGiamGia || 0);
    }
    
    // Allow if current campaign has higher discount than existing ones
    if (currentCampaign) {
      const currentDiscountValue = currentCampaign.giaTriGiamGia;
      const highestDiscountCampaign = campaigns.value.find(c => c.id === discountStatus.idDotGiamGia);
      
      return currentDiscountValue > (highestDiscountCampaign?.giaTriGiamGia || 0);
    }
    
    return false;
  });
});

// Get products with existing discount from OTHER campaigns (with higher discount value)
const productsWithDiscount = computed(() => {
  return productsDetails.value.filter((product) => {
    const discountStatus = getProductDiscountStatus(product.id);
    const currentCampaignStatus = getProductCurrentCampaignStatus(product.id);
    const currentCampaign = applyingCampaign.value;

    // Show as unavailable if has discount from other campaign with higher value
    if (discountStatus && currentCampaign) {
      const currentDiscountValue = currentCampaign.giaTriGiamGia;
      const highestDiscountCampaign = campaigns.value.find(c => c.id === discountStatus.idDotGiamGia);
      
      // Show as unavailable if existing discount is higher than current campaign
      return highestDiscountCampaign && highestDiscountCampaign.giaTriGiamGia > currentDiscountValue;
    }
    
    return false;
  });
});

// Get products already applied to current campaign
const currentCampaignProducts = computed(() => {
  return productsDetails.value.filter((product) =>
    getProductCurrentCampaignStatus(product.id)
  );
});

// Get all active campaigns for a product
const getProductActiveCampaigns = (productId) => {
  const activeDetails = campaignDetail.value.filter(
    (detail) => detail.idChiTietSanPham === productId && !detail.deleted
  );
  
  return activeDetails.map(detail => {
    const campaign = campaigns.value.find(c => c.id === detail.idDotGiamGia);
    return {
      ...detail,
      campaign: campaign,
      discountValue: campaign?.giaTriGiamGia || 0
    };
  }).sort((a, b) => b.discountValue - a.discountValue); // Sort by discount value descending
};

const clearFilters = () => {
  searchQuery.value = "";
  statusFilter.value = "";
  hienTrangFilter.value = "";
  tuNgayFilter.value = "";
  denNgayFilter.value = "";
  giaTriGiamFilter.value = "";
  sapXepFilter.value = "";
};

const applyFilters = () => {
  // Filters are already applied through computed property
};

const exportData = async () => {
  try {
    // Prepare data for Excel export
    const dataToExport = filteredCampaigns.value.map((campaign) => ({
      id: campaign.id,
      maDotGiamGia: campaign.maDotGiamGia,
      tenDotGiamGia: campaign.tenDotGiamGia,
      giaTriGiamGia: `${campaign.giaTriGiamGia}%`,
      ngayBatDau: formatDate(campaign.ngayBatDau),
      ngayKetThuc: formatDate(campaign.ngayKetThuc),
      trangThai: campaign.trangThai ? "Đang diễn ra" : "Sắp diễn ra",
      hienTrang: !campaign.deleted ? "Hoạt động" : "Đã xóa",
      soSanPhamApDung: getAppliedProductsCount(campaign.id),
    }));

    // Define headers for Vietnamese export
    const headers = {
      id: "ID",
      maDotGiamGia: "Mã đợt giảm giá",
      tenDotGiamGia: "Tên đợt giảm giá",
      giaTriGiamGia: "Giá trị giảm giá",
      ngayBatDau: "Ngày bắt đầu",
      ngayKetThuc: "Ngày kết thúc",
      trangThai: "Trạng thái",
      hienTrang: "Hiện trạng",
      soSanPhamApDung: "Số sản phẩm áp dụng",
    };

    // Format data for Excel
    const formattedData = formatDataForExcel(dataToExport, headers);

    // Export to Excel
    await exportToExcel(formattedData, "Bao_Cao_Chien_Dich_Giam_Gia");

    showSuccessNotification("Xuất báo cáo thành công!", {
      message: `Đã xuất ${dataToExport.length} đợt giảm giá ra file Excel`,
      tenDotGiamGia: "Báo cáo chiến dịch khuyến mãi",
      soLuong: dataToExport.length,
    });
  } catch (error) {
    console.error("Lỗi khi xuất báo cáo:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi xuất báo cáo",
      error.message
    );
  }
};



const refreshData = async () => {
  await fetchDGG();
  await fetchChiTietDGG();
  await fetchProductsDetails();
};

// Apply campaign methods
const openApplyModal = (campaign) => {
  applyingCampaign.value = campaign;
  applyFormData.value.idDotGiamGia = campaign.id;

  // Pre-select products already applied to this campaign
  const currentlyAppliedProducts = campaignDetail.value
    .filter((detail) => detail.idDotGiamGia === campaign.id && !detail.deleted)
    .map((detail) => detail.idChiTietSanPham);

  selectedProducts.value = [...currentlyAppliedProducts];
  showApplyModal.value = true;
};

const toggleProductSelection = (productId) => {
  const index = selectedProducts.value.indexOf(productId);
  if (index > -1) {
    selectedProducts.value.splice(index, 1);
  } else {
    selectedProducts.value.push(productId);
  }
};

const applyDiscountToCampaign = async () => {
  // Validate if any selected product already has discount from other campaigns with higher value
  const conflictProducts = validateProductSelection();
  if (conflictProducts.length > 0) {
    const conflictDetails = conflictProducts.map(conflict => 
      `• ${conflict.name}: ${conflict.existingDiscount}% (${conflict.campaignName}) > ${conflict.currentDiscount}% (hiện tại)`
    ).join('\n');
    
    showErrorNotification(
      "Xung đột sản phẩm có giảm giá cao hơn",
      `Các sản phẩm sau đã có đợt giảm giá với giá trị cao hơn:\n${conflictDetails}\n\nVui lòng bỏ chọn các sản phẩm này hoặc tăng giá trị giảm giá!`
    );
    return;
  }

  try {
    // Get currently applied products for this campaign
    const currentlyAppliedProducts = campaignDetail.value
      .filter(
        (detail) =>
          detail.idDotGiamGia === applyingCampaign.value.id && !detail.deleted
      )
      .map((detail) => detail.idChiTietSanPham);

    // Find products to add (selected but not currently applied)
    const productsToAdd = selectedProducts.value.filter(
      (productId) => !currentlyAppliedProducts.includes(productId)
    );

    // Find products to remove (currently applied but not selected)
    const productsToRemove = currentlyAppliedProducts.filter(
      (productId) => !selectedProducts.value.includes(productId)
    );

    // Add new products
    for (const productId of productsToAdd) {
      const chiTietData = {
        idDotGiamGia: applyFormData.value.idDotGiamGia,
        idChiTietSanPham: productId,
        deleted: false,
      };
      await fetchCreateChiTietDotGiamGia(chiTietData);
    }

    // Remove unselected products
    for (const productId of productsToRemove) {
      const detailToRemove = campaignDetail.value.find(
        (detail) =>
          detail.idDotGiamGia === applyingCampaign.value.id &&
          detail.idChiTietSanPham === productId &&
          !detail.deleted
      );
      if (detailToRemove) {
        await fetchUpdateStatusChiTietDotGiamGia(detailToRemove.id);
      }
    }

    // Check if campaign status is false and update if needed
    if (!applyingCampaign.value.trangThai) {
      await fetchUpdateStatusChiTietDotGiamGia(applyingCampaign.value.id);
    }

    const addedCount = productsToAdd.length;
    const removedCount = productsToRemove.length;
    let message = "Cập nhật đợt giảm giá thành công!";

    if (addedCount > 0 && removedCount > 0) {
      message += ` Đã thêm ${addedCount} và xóa ${removedCount} sản phẩm.`;
    } else if (addedCount > 0) {
      message += ` Đã thêm ${addedCount} sản phẩm.`;
    } else if (removedCount > 0) {
      message += ` Đã xóa ${removedCount} sản phẩm.`;
    }

    showSuccessNotification(message, {
      tenDotGiamGia: applyingCampaign.value.tenDotGiamGia,
      productsAdded: addedCount,
      productsRemoved: removedCount,
    });
    showApplyModal.value = false;
    await refreshData();
  } catch (error) {
    console.error("Lỗi khi áp dụng đợt giảm giá:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi áp dụng đợt giảm giá",
      error.message
    );
  }
};

const closeApplyModal = () => {
  showApplyModal.value = false;
  applyingCampaign.value = null;
  selectedProducts.value = [];
  applyFormData.value = {
    idDotGiamGia: null,
    selectedProductIds: [],
  };
};

// Select all products (only available ones)
const selectAllProducts = () => {
  selectedProducts.value = availableProducts.value.map((product) => product.id);
};

// Clear all selected products
const clearAllProducts = () => {
  selectedProducts.value = [];
};

// Select products by category
const selectCategoryProducts = (category) => {
  if (category === 'available') {
    // Select all available products that are not currently in campaign
    const availableProductIds = availableProducts.value
      .filter(p => !getProductCurrentCampaignStatus(p.id))
      .map(p => p.id);
    
    // Add to existing selection without duplicates
    const newSelection = [...new Set([...selectedProducts.value, ...availableProductIds])];
    selectedProducts.value = newSelection;
  } else if (category === 'current') {
    // Select all current campaign products
    const currentProductIds = currentCampaignProducts.value.map(p => p.id);
    
    // Add to existing selection without duplicates
    const newSelection = [...new Set([...selectedProducts.value, ...currentProductIds])];
    selectedProducts.value = newSelection;
  }
};

// Select all available products (combined section)
const selectAllAvailableProducts = () => {
  selectedProducts.value = availableProducts.value.map((product) => product.id);
};

// Validation before applying discount - check for conflicts with higher discount campaigns
const validateProductSelection = () => {
  const conflictProducts = [];
  const currentCampaign = applyingCampaign.value;

  if (!currentCampaign) return conflictProducts;

  for (const productId of selectedProducts.value) {
    const existingDiscount = getProductDiscountStatus(productId);
    const currentCampaignDiscount = getProductCurrentCampaignStatus(productId);

    // Check if product has discount from other campaign with higher value
    if (existingDiscount && !currentCampaignDiscount) {
      const highestDiscountCampaign = campaigns.value.find(c => c.id === existingDiscount.idDotGiamGia);
      
      if (highestDiscountCampaign && highestDiscountCampaign.giaTriGiamGia > currentCampaign.giaTriGiamGia) {
        const product = productsDetails.value.find((p) => p.id === productId);
        conflictProducts.push({
          name: product?.tenSanPham || `ID: ${productId}`,
          currentDiscount: currentCampaign.giaTriGiamGia,
          existingDiscount: highestDiscountCampaign.giaTriGiamGia,
          campaignName: highestDiscountCampaign.tenDotGiamGia
        });
      }
    }
  }

  return conflictProducts;
};

// Pagination methods
const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

const openAddModal = () => {
  resetForm();
  showAddModal.value = true;
};

// ===== NOTIFICATION METHODS =====
/**
 * Hiển thị thông báo thành công
 * @param {string} message - Nội dung thông báo
 * @param {Object} details - Chi tiết bổ sung
 */
const showSuccessNotification = (message, details = null) => {
  notificationData.value = {
    type: "success",
    title: "Thành công!",
    message: message,
    details: details,
  };
  showNotificationModal.value = true;

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
  notificationData.value = {
    type: "error",
    title: "Có lỗi xảy ra!",
    message: message,
    details: errorDetails,
  };
  showNotificationModal.value = true;

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
 * Mở popup xác nhận xóa đợt giảm giá
 * @param {number} id - ID của đợt giảm giá cần xóa
 */
const openDeleteModal = (id) => {
  const campaign = campaigns.value.find((c) => c.id === id);
  if (campaign) {
    deleteCampaignData.value = campaign;
    showDeleteModal.value = true;
  }
};

/**
 * Đóng popup xác nhận xóa
 */
const closeDeleteModal = () => {
  showDeleteModal.value = false;
  deleteCampaignData.value = null;
};

/**
 * Mở popup xác nhận lưu
 */
const openConfirmSaveModal = () => {
  // Validate form before showing confirmation
  if (!formData.value.tenDotGiamGia.trim()) {
    showErrorNotification("Vui lòng nhập tên đợt giảm giá!");
    return;
  }

  if (formData.value.giaTriGiamGia <= 0) {
    showErrorNotification("Giá trị giảm giá phải lớn hơn 0!");
    return;
  }

  if (formData.value.giaTriGiamGia > 100) {
    showErrorNotification("Giá trị giảm giá không được vượt quá 100%!");
    return;
  }

  if (!formData.value.ngayBatDau || !formData.value.ngayKetThuc) {
    showErrorNotification("Vui lòng chọn ngày bắt đầu và ngày kết thúc!");
    return;
  }

  if (new Date(formData.value.ngayKetThuc) <= new Date(formData.value.ngayBatDau)) {
    showErrorNotification("Ngày kết thúc phải sau ngày bắt đầu!");
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
 * Xác nhận lưu đợt giảm giá
 */
const confirmSave = async () => {
  try {
    closeConfirmSaveModal();
    await saveCampaign();
  } catch (error) {
    console.error("Lỗi khi xác nhận lưu:", error);
  }
};

/**
 * Xác nhận xóa đợt giảm giá
 * @returns {Promise<void>}
 */
const confirmDelete = async () => {
  if (!deleteCampaignData.value) return;

  // Store campaign data before closing modal to avoid null reference
  const campaignToDelete = { ...deleteCampaignData.value };

  try {
    await fetchDeleteDotGiamGia(campaignToDelete.id);
    await fetchDGG();
    closeDeleteModal();

    showSuccessNotification("Xóa đợt giảm giá thành công!", {
      tenDotGiamGia: campaignToDelete.tenDotGiamGia,
      giaTriGiamGia: campaignToDelete.giaTriGiamGia,
      ngayBatDau: campaignToDelete.ngayBatDau,
      ngayKetThuc: campaignToDelete.ngayKetThuc,
    });
  } catch (error) {
    console.error("Lỗi khi xóa đợt giảm giá:", error);
    showErrorNotification(
      "Có lỗi xảy ra khi xóa đợt giảm giá",
      error.message
    );
  }
};
onMounted(async () => {
  await fetchDGG();
  await fetchChiTietDGG();
  await fetchProductsDetails();

  // Run validation and priority updates after all data is loaded
  setTimeout(async () => {
    await validateInactiveCampaigns();
    await updateDiscountPriorities();
  }, 1000);
});

// Helper functions
const getCampaignActualStatus = (campaign) => {
  if (campaign.deleted) return "deleted";
  
  const now = new Date();
  const startDate = new Date(campaign.ngayBatDau);
  const endDate = new Date(campaign.ngayKetThuc);
  
  // Get today's date without time for comparison
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const endDateOnly = new Date(campaign.ngayKetThuc);
  endDateOnly.setHours(0, 0, 0, 0);
  
  // If campaign has ended (after end date has passed completely)
  if (today > endDateOnly) {
    return "expired";
  }
  
  // If campaign hasn't started yet
  if (now < startDate) {
    return campaign.trangThai ? "upcoming" : "inactive";
  }
  
  // Campaign is in progress
  return campaign.trangThai ? "active" : "inactive";
};

const getCampaignStatusLabel = (campaign) => {
  const status = getCampaignActualStatus(campaign);
  
  switch (status) {
    case "deleted": return "Đã xóa";
    case "expired": return "Đã kết thúc";
    case "active": return "Hoạt động";
    case "inactive": return "Ngừng hoạt động";
    case "upcoming": return "Sắp diễn ra";
    default: return "Ngừng hoạt động";
  }
};

const getCampaignStatusClass = (campaign) => {
  const status = getCampaignActualStatus(campaign);
  
  switch (status) {
    case "deleted": return "status-deleted";
    case "expired": return "status-expired";
    case "active": return "status-active";
    case "inactive": return "status-inactive";
    case "upcoming": return "status-upcoming";
    default: return "status-inactive";
  }
};

const getCampaignTimeStatus = (campaign) => {
  const status = getCampaignActualStatus(campaign);
  
  switch (status) {
    case "deleted": return "Đã xóa";
    case "expired": return "Đã kết thúc";
    case "active": return "Đang diễn ra";
    case "inactive": return "Tạm dừng";
    case "upcoming": return "Sắp diễn ra";
    default: return "Sắp diễn ra";
  }
};

const getCampaignTimeStatusClass = (campaign) => {
  const status = getCampaignActualStatus(campaign);
  
  switch (status) {
    case "deleted": return "status-deleted";
    case "expired": return "status-expired";
    case "active": return "status-active";
    case "inactive": return "status-inactive";
    case "upcoming": return "status-upcoming";
    default: return "status-upcoming";
  }
};

const getCampaignDuration = (campaign) => {
  const startDate = new Date(campaign.ngayBatDau);
  const endDate = new Date(campaign.ngayKetThuc);
  const duration = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
  return `${duration} ngày`;
};

const getAppliedProductsCount = (campaignId) => {
  return campaignDetail.value.filter(
    (detail) => detail.idDotGiamGia === campaignId && !detail.deleted
  ).length;
};

const getActiveProductsCount = (campaignId) => {
  return campaignDetail.value.filter(
    (detail) => detail.idDotGiamGia === campaignId && !detail.deleted && detail.trangThai
  ).length;
};

const getAppliedProducts = (campaignId) => {
  const appliedDetails = campaignDetail.value.filter(
    (detail) => detail.idDotGiamGia === campaignId && !detail.deleted
  );
  
  // Map to product details
  return appliedDetails.map(detail => {
    const product = productsDetails.value.find(p => p.id === detail.idChiTietSanPham);
    return {
      ...product,
      deleted: detail.deleted,
      trangThai: detail.trangThai
    };
  }).filter(Boolean);
};

const getTimeRemaining = (campaign) => {
  const endDate = new Date(campaign.ngayKetThuc);
  const now = new Date();
  const remainingTime = Math.ceil((endDate - now) / (1000 * 60 * 60 * 24));
  
  if (remainingTime <= 0) return "Hết hạn";
  if (remainingTime === 1) return "1 ngày";
  return `${remainingTime} ngày`;
};

const getCampaignProgress = (campaign) => {
  const startDate = new Date(campaign.ngayBatDau);
  const endDate = new Date(campaign.ngayKetThuc);
  const now = new Date();
  
  if (now < startDate) return 0;
  if (now > endDate) return 100;
  
  const totalDuration = endDate - startDate;
  const elapsedDuration = now - startDate;
  const progress = (elapsedDuration / totalDuration) * 100;
  
  return Math.round(progress);
};

const getDaysRemaining = (campaign) => {
  const endDate = new Date(campaign.ngayKetThuc);
  const now = new Date();
  const remainingDays = Math.ceil((endDate - now) / (1000 * 60 * 60 * 24));
  return Math.max(0, remainingDays);
};

const formatPrice = (price) => {
  if (!price) return "0 VNĐ";
  return new Intl.NumberFormat("vi-VN").format(price) + " VNĐ";
};

const getDiscountedPrice = (originalPrice, discountPercentage) => {
  if (!originalPrice || !discountPercentage) return originalPrice;
  return Math.round(originalPrice - (originalPrice * discountPercentage) / 100);
};

// Format discount value for display
const formatDiscountValue = (value) => {
  if (value === null || value === undefined || value === '') {
    return '0%';
  }
  
  // Handle string values that might contain '%'
  if (typeof value === 'string') {
    const numValue = parseFloat(value.replace('%', ''));
    if (isNaN(numValue)) {
      return '0%';
    }
    return `${numValue}%`;
  }
  
  // Handle numeric values
  const numValue = Number(value);
  if (isNaN(numValue)) {
    return '0%';
  }
  
  // Format with proper decimal places if needed
  if (numValue % 1 === 0) {
    return `${numValue}%`;
  } else {
    return `${numValue.toFixed(1)}%`;
  }
};
</script>

<style scoped>
/* Import unified discount styles */
@import '../../styles/cssGiamGia/discountsUnified.css';
@import '../../styles/cssGiamGia/campainGiamGia.css';
.discount-campaigns {
  max-width: 1400px;
  margin: 0 auto;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

/* page-header styles are now defined in globals.css */

/* Modern Filter Section */
.filter-section {
  margin-bottom: 2rem;
}

.filter-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(74, 222, 128, 0.1);
  transition: all 0.3s ease;
}

.filter-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.filter-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  background: linear-gradient(
    135deg,
    rgba(74, 222, 128, 0.05) 0%,
    rgba(34, 197, 94, 0.05) 100%
  );
  border-bottom: 1px solid rgba(74, 222, 128, 0.15);
}

.filter-title {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.filter-icon {
  font-size: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  border-radius: 10px;
}

.filter-title h3 {
  margin: 0;
  color: #374151;
  font-size: 1.25rem;
  font-weight: 600;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.filter-stats {
  padding: 0.5rem 1rem;
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 500;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.filter-content {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

/* Search Section */
.search-section {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid #e2e8f0;
}

.search-section .filter-group {
  max-width: 600px;
  margin: 0 auto;
}

.search-section .input-group {
  position: relative;
  display: flex;
  align-items: center;
}

.search-section .input-icon {
  position: absolute;
  left: 1rem;
  font-size: 1.25rem;
  z-index: 1;
  color: #6b7280;
}

.search-section .clear-btn {
  position: absolute;
  right: 1rem;
  background: #ef4444;
  border: none;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: white;
  font-size: 0.875rem;
  transition: all 0.2s ease;
  z-index: 1;
}

.search-section .clear-btn:hover {
  background: #dc2626;
  transform: scale(1.1);
}

.input-group {
  position: relative;
  display: flex;
  align-items: center;
}



.filters-grid {
  display: grid;
  grid-template-columns: 1fr auto auto auto;
  gap: 1.5rem;
  background: #ffffff;
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid #e2e8f0;
  align-items: end;
}



.search-input {
  width: 100%;
  padding: 0.75rem 3rem 0.75rem 3rem;
  border: 2px solid #e5e7eb;
  border-radius: 10px;
  font-size: 0.875rem;
  transition: all 0.3s ease;
  background: white;
  color: #374151;
}

.search-input:focus {
  outline: none;
  border-color: #4ade80;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1);
}

/* Action Buttons in Filters Grid */
.btn-action-primary,
.btn-action-secondary {
  padding: 0.75rem 1.5rem;
  border-radius: 10px;
  font-weight: 500;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  border: none;
  width: 100%;
  justify-content: center;
}

.btn-action-primary {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  border: 2px solid transparent;
}

.btn-action-primary:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
}

.btn-action-secondary {
  background: white;
  border: 2px solid #e5e7eb;
  color: #6b7280;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.btn-action-secondary:hover {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  border-color: #22c55e;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
}

.btn-action-secondary:active {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  min-height: 80px;
  justify-content: flex-end;
}

.button-group {
  min-height: auto;
  justify-content: center;
  align-items: center;
}

.filter-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: #6b7280;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.label-icon {
  font-size: 1rem;
}

.form-select {
  padding: 0.75rem 1rem;
  border: 2px solid #e5e7eb;
  border-radius: 10px;
  font-size: 0.875rem;
  transition: all 0.3s ease;
  background: white;
  color: #374151;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.form-select:focus {
  outline: none;
  border-color: #4ade80;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1);
  transform: translateY(-1px);
}



.btn {
  padding: 0.75rem 1.5rem;
  border-radius: 10px;
  font-weight: 500;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  border: none;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.btn-outline {
  background: white;
  border: 2px solid #e5e7eb;
  color: #6b7280;
}

.btn-outline:hover {
  background: #ffffff;
  border-color: #d1d5db;
  color: #374151;
  transform: translateY(-1px);
}

.btn-primary {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  border: 2px solid transparent;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
}

/* Enhanced Responsive Table Styles for CampainGiamGia */
.table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 12px 48px rgba(0, 0, 0, 0.12);
  border: 1px solid rgba(74, 222, 128, 0.15);
  font-family: "Inter", "Poppins", sans-serif;
  table-layout: auto; /* Allow adaptive column sizing */
}

.table th {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  font-weight: 700;
  padding: 1rem 1.25rem;
  text-align: center;
  font-size: clamp(0.75rem, 1.5vw, 0.875rem); /* Responsive font size */
  white-space: nowrap;
  position: sticky;
  top: 0;
  z-index: 10;
  font-family: "Inter", "Arial", sans-serif;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
  border-right: none;
  border-left: none;
  min-width: fit-content;
}

.table th:first-child {
  border-top-left-radius: 20px;
}

.table th:last-child {
  border-top-right-radius: 20px;
}

/* Optimized Adaptive Column Widths for CampainGiamGia */
.table th:nth-child(1) { /* STT */
  width: 70px;
  min-width: 60px;
}

.table th:nth-child(2) { /* Tên đợt giảm giá */
  width: 280px;
  min-width: 240px;
  max-width: 350px;
}

.table th:nth-child(3) { /* Giá trị giảm giá */
  width: 160px;
  min-width: 140px;
}

.table th:nth-child(4) { /* Thời gian */
  width: 200px;
  min-width: 180px;
}

.table th:nth-child(5) { /* Hiện trạng */
  width: 80px;
  min-width: 70px;
}

.table th:nth-child(6) { /* Trạng thái */
  width: 90px;
  min-width: 80px;
}

.table th:nth-child(7) { /* Thao tác */
  width: 220px;
  min-width: 200px;
}

/* Enhanced Table Cells */
.table td {
  padding: 1.5rem 1.25rem;
  text-align: center;
  vertical-align: middle;
  border-bottom: 1px solid rgba(74, 222, 128, 0.08);
  font-size: clamp(0.8rem, 1.2vw, 0.9rem); /* Responsive font size */
  font-family: "Inter", "Poppins", sans-serif;
  line-height: 1.5;
  word-wrap: break-word;
  overflow-wrap: break-word;
  transition: all 0.3s ease;
}

/* Apply same column widths to td cells */
.table td:nth-child(1) { /* STT */
  width: 70px;
  min-width: 60px;
  font-weight: 600;
  color: #6b7280;
}

.table td:nth-child(2) { /* Tên đợt giảm giá */
  width: 280px;
  min-width: 240px;
  max-width: 350px;
  text-align: left;
  overflow: hidden;
  text-overflow: ellipsis;
}

.table td:nth-child(2):hover {
  overflow: visible;
  white-space: normal;
  position: relative;
  z-index: 10;
  background: white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  border-radius: 8px;
}

.table td:nth-child(3) { /* Giá trị giảm giá */
  width: 160px;
  min-width: 140px;
}

.table td:nth-child(4) { /* Thời gian */
  width: 200px;
  min-width: 180px;
}

.table td:nth-child(5) { /* Hiện trạng */
  width: 80px;
  min-width: 70px;
}

.table td:nth-child(6) { /* Trạng thái */
  width: 90px;
  min-width: 80px;
}

.table td:nth-child(7) { /* Thao tác */
  width: 220px;
  min-width: 200px;
}

/* Enhanced Table Row Hover Effects */
.table tbody tr {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  position: relative;
}

.table tbody tr:hover {
  background: linear-gradient(
    135deg,
    rgba(74, 222, 128, 0.08) 0%,
    rgba(34, 197, 94, 0.08) 100%
  );
  transform: translateY(-3px) scale(1.002);
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.2);
  z-index: 5;
}

.table tbody tr:last-child td {
  border-bottom: none;
}

/* Enhanced Row Animation */
.table tbody tr:hover td {
  border-color: rgba(74, 222, 128, 0.2);
}

.table tbody tr:active {
  transform: translateY(-1px) scale(1.001);
  transition: all 0.1s ease;
}

/* Enhanced Action Buttons for CampainGiamGia */
.action-buttons {
  display: flex;
  gap: 0.75rem;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
  padding: 0.5rem;
}

.action-buttons .btn-action {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  border: 2px solid #e5e7eb;
  background: white;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 1.1rem;
  position: relative;
  overflow: hidden;
}

.action-buttons .btn-action::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  transition: left 0.5s;
}

.action-buttons .btn-action:hover::before {
  left: 100%;
}

.action-buttons .btn-action:hover {
  transform: translateY(-2px) scale(1.1);
  background: #ffffff;
  border-color: #4ade80;
  box-shadow: 0 8px 25px rgba(74, 222, 128, 0.3);
}

.action-buttons .btn-action:active {
  transform: translateY(0) scale(1.05);
  transition: all 0.1s ease;
}

/* Specific action button colors for CampainGiamGia */
.action-buttons .btn-detail {
  border-color: #3b82f6;
}

.action-buttons .btn-detail:hover {
  background: #dbeafe;
  border-color: #2563eb;
  box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
}

.action-buttons .btn-action[title="Chỉnh sửa"] {
  border-color: #f59e0b;
}

.action-buttons .btn-action[title="Chỉnh sửa"]:hover {
  background: #fef3c7;
  border-color: #d97706;
  box-shadow: 0 8px 25px rgba(245, 158, 11, 0.3);
}

.action-buttons .btn-delete {
  border-color: #ef4444;
}

.action-buttons .btn-delete:hover {
  background: #fef2f2;
  border-color: #dc2626;
  box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3);
}

.action-buttons .btn-apply {
  border-color: #10b981;
}

.action-buttons .btn-apply:hover {
  background: #ecfdf5;
  border-color: #059669;
  box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
}

/* Campaign Row Styles */
.campaign-row {
  transition: all 0.3s ease;
}

.campaign-row:hover {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.05) 0%, rgba(34, 197, 94, 0.05) 100%);
  transform: scale(1.01);
}

.stt-cell {
  font-weight: 600;
  color: #4ade80;
  font-size: 1rem;
}

/* CSS moved to external file */

.discount-type {
  color: #6b7280;
  font-size: 0.75rem;
  font-weight: 500;
}

.campaign-code {
  color: #6b7280;
  font-size: 0.75rem;
  font-weight: 500;
  margin-top: 0.25rem;
  font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', monospace;
}

/* Table Content Styles */
.campaign-name {
  text-align: left;
}

.campaign-name strong {
  color: #374151;
  font-size: 0.9375rem;
  font-weight: 600;
}

.campaign-description {
  color: #6b7280;
  font-size: 0.875rem;
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.value-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.min-order {
  color: #9ca3af;
  font-size: 0.75rem;
  display: block;
}

.date-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.875rem;
}

/* CSS moved to external file */

.date-separator {
  color: #22c55e;
  font-weight: bold;
  font-size: 0.75rem;
}

/* Action Buttons */
.action-buttons {
  display: flex;
  gap: 0.5rem;
  justify-content: center;
}

.btn-action {
  width: 32px;
  height: 32px;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
  background: white;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 1rem;
}

.btn-action:hover {
  transform: scale(1.1);
  background: #ffffff;
  border-color: #22c55e;
}

.btn-detail {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  color: white;
  border-color: #22c55e;
}

.btn-detail:hover {
  background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
  border-color: #16a34a;
  transform: scale(1.1);
}

.btn-apply {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
  border-color: #10b981;
}

.btn-apply:hover {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  border-color: #059669;
}

.btn-delete {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  border-color: #ef4444;
}

.btn-delete:hover {
  background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
  border-color: #dc2626;
}

/* Empty State */
.empty-state {
  padding: 2rem !important;
}

.empty-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.empty-icon {
  font-size: 2rem;
  opacity: 0.5;
}

.empty-message p {
  margin: 0;
  color: #6b7280;
  font-weight: 500;
}

.empty-message small {
  color: #9ca3af;
  font-size: 0.875rem;
}

/* Pagination */
.pagination-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--border-color);
}

.pagination {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.page-info {
  font-weight: 600;
  color: var(--secondary-color);
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 2rem;
  backdrop-filter: blur(4px);
}

.modal-content-new {
  background: white;
  border-radius: 16px;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  max-width: 800px;
  width: 90%;
  max-height: 85vh;
  overflow: hidden;
  animation: slideInUp 0.4s cubic-bezier(0.16, 1, 0.3, 1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-20px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid var(--border-color);
  background: linear-gradient(135deg, #ffffff, #ffffff);
}

.modal-header h3 {
  margin: 0;
  color: var(--secondary-color);
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  font-weight: 600;
}

.modal-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background-color 0.3s ease;
  color: #6b7280;
}

.modal-close:hover {
  background-color: var(--light-gray);
  color: #374151;
}

.modal-form-minimal {
  display: flex;
  flex-direction: column;
  max-height: 85vh;
}

.modal-form-minimal .form-body-minimal {
  flex: 1;
  overflow-y: auto;
  padding: 1rem;
}

.modal-form-minimal .form-footer-minimal {
  flex-shrink: 0;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  background: #ffffff;
}

.modal-body {
  padding: 1.5rem;
  flex: 1;
  overflow-y: auto;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 1.5rem;
  border-top: 1px solid var(--border-color);
  background: #ffffff;
  flex-shrink: 0;
}

.modal-footer .btn {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  border: none;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.modal-footer .btn-secondary {
  background: #6b7280;
  color: white;
}

.modal-footer .btn-secondary:hover {
  background: #4b5563;
  transform: translateY(-1px);
}

.modal-footer .btn-primary {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
}

.modal-footer .btn-primary:hover {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.modal-footer .btn-outline {
  background: white;
  border: 2px solid #e5e7eb;
  color: #6b7280;
}

.modal-footer .btn-outline:hover {
  background: #ffffff;
  border-color: #4ade80;
  color: #374151;
  transform: translateY(-1px);
}

/* Campaign Detail */
.campaign-detail {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.campaign-info h4 {
  text-align: center;
  margin: 0 0 2rem 0;
  color: var(--secondary-color);
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  font-weight: 600;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 1rem;
  background: #ffffff;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
}

.info-item label {
  font-weight: 500;
  color: var(--medium-gray);
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.info-item span {
  color: var(--secondary-color);
  font-weight: 500;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .discount-campaigns {
    padding: 0 1rem;
  }
}

/* Enhanced Responsive Design for Different Desktop Resolutions - CampainGiamGia */

/* Large Desktop (1920px+) */
@media (min-width: 1920px) {
  .table th {
    padding: 1.25rem 1.5rem;
    font-size: 0.95rem;
  }
  
  .table td {
    padding: 1.75rem 1.5rem;
    font-size: 1rem;
  }
  
  .action-buttons .btn-action {
    width: 45px;
    height: 45px;
    font-size: 1.25rem;
  }
  
  /* Increase column widths for large screens */
  .table th:nth-child(2) { width: 320px; min-width: 280px; }
  .table th:nth-child(7) { width: 250px; min-width: 230px; }
}

/* Standard Desktop (1440px - 1919px) */
@media (min-width: 1440px) and (max-width: 1919px) {
  .table th {
    padding: 1.1rem 1.3rem;
    font-size: 0.85rem;
  }
  
  .table td {
    padding: 1.6rem 1.3rem;
    font-size: 0.95rem;
  }
  
  .action-buttons .btn-action {
    width: 42px;
    height: 42px;
    font-size: 1.15rem;
  }
}

/* Medium Desktop (1024px - 1439px) */
@media (min-width: 1024px) and (max-width: 1439px) {
  .search-controls {
    flex-direction: column;
    align-items: stretch;
  }

  .search-box {
    min-width: auto;
  }

  .table th {
    padding: 1rem 1.1rem;
    font-size: 0.8rem;
  }
  
  .table td {
    padding: 1.4rem 1.1rem;
    font-size: 0.85rem;
  }
  
  /* Adjust column widths for medium screens */
  .table th:nth-child(2) { width: 260px; min-width: 220px; }
  .table th:nth-child(7) { width: 200px; min-width: 180px; }
}

/* Tablet Landscape (768px - 1023px) */
@media (min-width: 768px) and (max-width: 1023px) {
  .filter-content {
    gap: 1.5rem;
  }

  .filters-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
    align-items: stretch;
  }

  .filter-group {
    min-height: auto;
    justify-content: flex-start;
  }

  .button-group {
    min-height: auto;
    justify-content: center;
  }

  .table {
    font-size: 0.8rem;
    border-radius: 16px;
  }

  .table th,
  .table td {
    padding: 1rem 0.75rem;
  }
  
  /* Hide less critical columns on smaller screens */
  .table th:nth-child(5), /* Hiện trạng */
  .table td:nth-child(5),
  .table th:nth-child(6), /* Trạng thái */
  .table td:nth-child(6) {
    display: none;
  }
  
  .action-buttons {
    gap: 0.5rem;
  }
  
  .action-buttons .btn-action {
    width: 36px;
    height: 36px;
    font-size: 1rem;
  }
}

/* Mobile Portrait (481px - 767px) */
@media (min-width: 481px) and (max-width: 767px) {
  .pagination-wrapper {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }

  .modal-overlay {
    padding: 1rem;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .table {
    font-size: 0.8125rem;
    border-radius: 12px;
  }

  .table th,
  .table td {
    padding: 0.75rem 0.5rem;
  }

  /* Hide more columns on smaller mobile */
  .table th:nth-child(3), /* Giá trị giảm giá */
  .table td:nth-child(3),
  .table th:nth-child(4), /* Thời gian */
  .table td:nth-child(4),
  .table th:nth-child(5), /* Hiện trạng */
  .table td:nth-child(5),
  .table th:nth-child(6), /* Trạng thái */
  .table td:nth-child(6) {
    display: none;
  }

  .search-section {
    padding: 1rem;
  }

  .filters-grid {
    grid-template-columns: 1fr;
    gap: 0.75rem;
  }

  .filter-group {
    min-height: auto;
  }

  .button-group {
    min-height: auto;
  }
  
  .action-buttons {
    flex-direction: column;
    gap: 0.25rem;
  }
  
  .action-buttons .btn-action {
    width: 32px;
    height: 32px;
    font-size: 0.9rem;
  }
}

/* Small Mobile (max-width: 480px) */
@media (max-width: 480px) {
  .discount-campaigns {
    padding: 0 0.5rem;
  }

  .filter-section {
    padding: 1rem;
  }

  .table {
    font-size: 0.75rem;
  }

  .table th,
  .table td {
    padding: 0.5rem 0.25rem;
  }

  .card {
    margin: 0 -0.5rem;
    border-radius: 0;
  }
  
  .action-buttons .btn-action {
    width: 28px;
    height: 28px;
    font-size: 0.8rem;
  }
}

/* Ultra-wide Desktop Optimization (2560px+) */
@media (min-width: 2560px) {
  .table th {
    padding: 1.5rem 2rem;
    font-size: 1rem;
  }
  
  .table td {
    padding: 2rem;
    font-size: 1.1rem;
  }
  
  .action-buttons .btn-action {
    width: 50px;
    height: 50px;
    font-size: 1.3rem;
  }
  
  /* Increase column widths for ultra-wide */
  .table th:nth-child(2) { width: 400px; min-width: 350px; }
  .table th:nth-child(7) { width: 280px; min-width: 250px; }
}

/* Apply Modal Styles - Redesigned */
.apply-modal-minimal {
  max-width: 900px;
  width: 90vw;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.selection-controls-minimal {
  display: flex;
  gap: 0.75rem;
  margin: 1rem 0;
  align-items: center;
}

.btn-control-minimal {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  border: 1px solid #e2e8f0;
  background: white;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-control-minimal:hover:not(:disabled) {
  background: #f8fafc;
  border-color: #cbd5e1;
  transform: translateY(-1px);
}

.btn-control-minimal:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-icon-minimal {
  width: 16px;
  height: 16px;
}

.btn-select-all:hover:not(:disabled) {
  border-color: #22c55e;
  color: #22c55e;
}

.btn-clear-all:hover:not(:disabled) {
  border-color: #ef4444;
  color: #ef4444;
}

.selection-summary-minimal {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem;
  background: #f8fafc;
  border-radius: 8px;
  margin: 1rem 0;
  border: 1px solid #e2e8f0;
}

.summary-item-minimal {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.summary-label-minimal {
  font-size: 0.875rem;
  color: #64748b;
  font-weight: 500;
}

.summary-value-minimal {
  font-size: 0.875rem;
  font-weight: 600;
}

.products-list-minimal {
  max-height: 400px;
  overflow-y: auto;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background: white;
}

.product-section-minimal {
  border-bottom: 1px solid #f1f5f9;
}

.product-section-minimal:last-child {
  border-bottom: none;
}

.section-header-minimal {
  padding: 0.75rem 1rem;
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}

.section-badge-minimal {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.375rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.025em;
}

.section-badge-minimal.current-campaign {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.section-badge-minimal.available {
  background: #dbeafe;
  color: #1e40af;
  border: 1px solid #93c5fd;
}

.section-badge-minimal.unavailable {
  background: #fef3c7;
  color: #d97706;
  border: 1px solid #fde68a;
}

.badge-icon-minimal {
  width: 14px;
  height: 14px;
}

.product-item-minimal {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  border-bottom: 1px solid #f1f5f9;
  cursor: pointer;
  transition: all 0.2s ease;
}

.product-item-minimal:last-child {
  border-bottom: none;
}

.product-item-minimal:hover:not(.unavailable) {
  background: #f8fafc;
}

.product-item-minimal.current-applied {
  background: #f0fdf4;
  border-left: 3px solid #22c55e;
}

.product-item-minimal.available {
  background: white;
}

.product-item-minimal.unavailable {
  background: #fafafa;
  cursor: not-allowed;
  opacity: 0.7;
}

.product-checkbox-minimal {
  flex-shrink: 0;
}

.product-checkbox-minimal input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.product-details-minimal {
  flex: 1;
  min-width: 0;
}

.product-name-minimal {
  font-size: 0.875rem;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 0.25rem;
  line-height: 1.4;
}

.product-specs-minimal {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.75rem;
  color: #64748b;
  margin-bottom: 0.25rem;
}

.spec-item-minimal {
  font-weight: 500;
}

.spec-separator-minimal {
  color: #cbd5e1;
}

.product-status-minimal {
  font-size: 0.75rem;
  font-weight: 500;
  padding: 0.125rem 0.5rem;
  border-radius: 4px;
  display: inline-block;
}

.current-status {
  background: #dcfce7;
  color: #166534;
}

.available-status {
  background: #dbeafe;
  color: #1e40af;
}

.unavailable-status {
  background: #fef3c7;
  color: #d97706;
}

.product-price-minimal {
  font-size: 0.875rem;
  font-weight: 600;
  color: #059669;
  flex-shrink: 0;
  text-align: right;
}

.disabled-text {
  opacity: 0.6;
  color: #64748b !important;
}

.empty-state-minimal {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem 2rem;
  text-align: center;
}

.empty-icon-minimal {
  width: 48px;
  height: 48px;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.empty-icon-minimal img {
  width: 100%;
  height: 100%;
}

.empty-text-minimal h4 {
  font-size: 1.125rem;
  font-weight: 600;
  color: #374151;
  margin: 0 0 0.5rem 0;
}

.empty-text-minimal p {
  font-size: 0.875rem;
  color: #6b7280;
  margin: 0;
}

.discount-info {
  background: #ffffff;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  border: 1px solid #e5e7eb;
}

.info-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
}

.info-row:last-child {
  margin-bottom: 0;
}

.label {
  font-weight: 500;
  color: #6b7280;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.value {
  font-weight: 600;
  color: #374151;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.product-selection h4 {
  margin-bottom: 1rem;
  color: #374151;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  font-weight: 600;
}

.product-search {
  margin-bottom: 1rem;
}

.product-list {
  max-height: 300px;
  overflow-y: auto;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 0.5rem;
}

.product-item {
  display: flex;
  align-items: flex-start;
  padding: 0.75rem;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s ease;
  margin-bottom: 0.5rem;
  border: 1px solid #e5e7eb;
}

.product-item:hover {
  background-color: #ffffff;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.product-item:last-child {
  margin-bottom: 0;
}

.product-item input[type="checkbox"] {
  margin-right: 0.75rem;
  margin-top: 0.25rem;
  cursor: pointer;
  flex-shrink: 0;
}

.product-info {
  flex: 1;
}

.product-name {
  font-weight: 500;
  color: #374151;
  margin-bottom: 0.25rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.product-details {
  font-size: 0.875rem;
  color: #6b7280;
  margin-bottom: 0.25rem;
}

.details-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.5rem;
}

.detail-column {
  display: flex;
  flex-direction: column;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.125rem;
  font-size: 0.8125rem;
}

.detail-label {
  font-weight: 500;
  color: #4b5563;
  min-width: 70px;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.detail-value {
  color: #6b7280;
  text-align: right;
  flex: 1;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.product-price {
  font-weight: 600;
  color: #22c55e;
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.empty-products {
  text-align: center;
  padding: 2rem;
  color: #6b7280;
}

.selection-controls {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.selection-controls .btn {
  font-size: 0.875rem;
  padding: 0.5rem 1rem;
}

.selection-summary {
  margin-top: 1rem;
}

.selected-count {
  padding: 0.75rem;
  background: #ecfdf5;
  border: 1px solid #d1fae5;
  border-radius: 6px;
  font-weight: 500;
  color: #065f46;
  text-align: center;
  margin-bottom: 0.5rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.available-count {
  padding: 0.5rem;
  background: #ffffff;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 0.875rem;
  color: #6b7280;
  text-align: center;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.available-count small {
  color: #9ca3af;
  font-size: 0.8125rem;
}

.product-section {
  margin-bottom: 1.5rem;
}

.section-title {
  font-size: 0.9375rem;
  font-weight: 600;
  margin-bottom: 0.75rem;
  padding: 0.5rem 0.75rem;
  border-radius: 6px;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.available-title {
  background: #ecfdf5;
  color: #065f46;
  border: 1px solid #d1fae5;
}

.current-campaign-title {
  background: #ffffff;
  color: #1e40af;
  border: 1px solid #bfdbfe;
}

.unavailable-title {
  background: #fef2f2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.available-product {
  border: 1px solid #d1fae5;
  background: #ffffff;
}

.available-product:hover {
  background: #f0fdf4;
  border-color: #a7f3d0;
}

.current-campaign-product {
  border: 1px solid #bfdbfe;
  background: #ffffff;
}

.current-campaign-product:hover {
  background: #ffffff;
  border-color: #93c5fd;
}

.unavailable-product {
  border: 1px solid #fecaca;
  background: #fef2f2;
  cursor: not-allowed;
  opacity: 0.7;
}

.disabled-checkbox {
  opacity: 0.5;
  cursor: not-allowed;
}

.disabled-text {
  color: #9ca3af;
}

.discount-active {
  color: #dc2626;
  font-weight: 600;
}

.current-campaign {
  color: #1d4ed8;
  font-weight: 600;
}

.multiple-campaigns {
  color: #059669;
  font-weight: 600;
  font-size: 0.75rem;
}

.empty-available {
  text-align: center;
  padding: 2rem;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  margin: 1rem 0;
}

.warning-text {
  color: #dc2626;
  font-weight: 500;
  margin: 0;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

@media (max-width: 768px) {
  .apply-modal {
    max-width: 95vw;
    margin: 1rem;
  }

  .product-list {
    max-height: 250px;
  }

  .info-row {
    flex-direction: column;
    gap: 0.25rem;
  }

  .details-grid {
    grid-template-columns: 1fr;
  }

  .detail-label {
    min-width: 90px;
  }
}

/* Form styling improvements */
.form-group {
  margin-bottom: 1.5rem;
}

.form-group:last-child {
  margin-bottom: 0;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #374151;
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.form-control {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 0.875rem;
  transition: all 0.2s ease;
  background-color: #fff;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.form-control:focus {
  outline: none;
  border-color: #4ade80;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1);
  transform: translateY(-1px);
}

.form-control:disabled {
  background-color: #ffffff;
  color: #9ca3af;
  cursor: not-allowed;
}

.form-control.is-invalid {
  border-color: var(--error);
}

.form-control.is-valid {
  border-color: var(--success);
}

.form-help {
  display: block;
  margin-top: 0.25rem;
  font-size: 0.75rem;
  color: #6b7280;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

/* Row and column layout */
.row {
  display: flex;
  margin: 0 -0.75rem;
  margin-bottom: 1rem;
}

.col-6 {
  flex: 0 0 50%;
  max-width: 50%;
  padding: 0 0.75rem;
}

.col-6 .form-group {
  margin-bottom: 0;
}

/* Form sections spacing */
.modal-body .form-group {
  margin-bottom: 1.25rem;
}

.modal-body .row {
  margin-bottom: 1.25rem;
}

.modal-body .row:last-child {
  margin-bottom: 0;
}

/* Mobile responsive form */
@media (max-width: 480px) {
  .row {
    flex-direction: column;
    margin: 0;
    margin-bottom: 1rem;
  }

  .col-6 {
    flex: none;
    max-width: 100%;
    padding: 0;
  }

  .col-6 .form-group {
    margin-bottom: 1rem;
  }

  .col-6:last-child .form-group {
    margin-bottom: 0;
  }
}

/* View Campaign Detail Modal Styles */
.detail-modal {
  max-width: 900px;
  max-height: 90vh;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid var(--border-color);
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
}

.header-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.header-icon {
  font-size: 2.5rem;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0.1) 100%);
  border-radius: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.header-text h3 {
  margin: 0;
  color: white;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  font-weight: 600;
  font-size: 1.5rem;
}

.header-subtitle {
  margin: 0.5rem 0 0 0;
  color: white;
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  opacity: 0.9;
}

.campaign-overview {
  padding: 1.5rem;
}

.overview-header {
  margin-bottom: 2rem;
}

.campaign-title h2 {
  margin: 0 0 1rem 0;
  color: #1f2937;
  font-size: 1.75rem;
  font-weight: 700;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.campaign-badge {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.badge-code {
  background: #ffffff;
  color: #6b7280;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', monospace;
  border: 1px solid #e5e7eb;
}

.badge-status {
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.badge-active {
  background: #d1fae5;
  color: #065f46;
  border: 1px solid #a7f3d0;
}

.badge-inactive {
  background: #fef3c7;
  color: #92400e;
  border: 1px solid #fde68a;
}

.campaign-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  text-align: center;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  border-color: #4ade80;
}

.stat-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  color: #4ade80;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 0.5rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.stat-label {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.campaign-details {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.detail-section {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.section-title {
  margin: 0 0 1.5rem 0;
  color: #1f2937;
  font-size: 1.125rem;
  font-weight: 600;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.detail-label {
  font-weight: 500;
  color: #6b7280;
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.detail-value {
  color: #1f2937;
  font-weight: 600;
  font-size: 0.9375rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.code-value {
  color: #6b7280;
  font-weight: 500;
  font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', monospace;
  background: #ffffff;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  border: 1px solid #e5e7eb;
}

/* CSS moved to external file */

.status-badge {
  font-size: 0.75rem;
  font-weight: 500;
  padding: 0.25rem 0.75rem;
  border-radius: 4px;
  text-align: center;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.status-active {
  background: #d4edda !important;
  color: #155724 !important;
}

.status-inactive {
  background: #f8d7da !important;
  color: #721c24 !important;
}

.status-deleted {
  background: #f8f9fa !important;
  color: #6c757d !important;
}

.status-expired {
  background: #fff3cd !important;
  color: #856404 !important;
}

.status-upcoming {
  background: #dbeafe !important;
  color: #1e40af !important;
}

.time-remaining {
  color: #dc2626;
  font-weight: 700;
}

.products-summary {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.summary-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  padding: 1rem;
  background: #ffffff;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem;
  background: white;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
}

.summary-label {
  font-weight: 500;
  color: #6b7280;
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.summary-value {
  font-weight: 600;
  color: #1f2937;
  font-size: 1rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.active-count {
  color: #059669;
}

.products-list {
  max-height: 300px;
  overflow-y: auto;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 1rem;
  background: #ffffff;
}

.product-card {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  border: 1px solid #e5e7eb;
  background: white;
  transition: all 0.2s ease;
}

.product-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #4ade80;
}

.product-card:last-child {
  margin-bottom: 0;
}

.product-info {
  flex: 1;
}

.product-name {
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 0.75rem;
  font-size: 1rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.product-details {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 0.75rem;
}

.product-attribute {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem;
  background: #ffffff;
  border-radius: 4px;
  border: 1px solid #e5e7eb;
}

.attr-label {
  font-weight: 500;
  color: #6b7280;
  font-size: 0.8125rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.attr-value {
  color: #1f2937;
  font-weight: 600;
  font-size: 0.8125rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.price {
  color: #6b7280;
}

.discounted-price {
  color: #dc2626;
  font-weight: 700;
}

.product-status {
  margin-left: 1rem;
  flex-shrink: 0;
}

.status-indicator {
  font-size: 0.875rem;
  font-weight: 600;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.no-products {
  text-align: center;
  padding: 3rem 2rem;
  color: #6b7280;
  background: #ffffff;
  border-radius: 8px;
  border: 2px dashed #d1d5db;
}

.no-products-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.no-products p {
  margin: 0 0 1.5rem 0;
  font-size: 1rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.btn-apply-products {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
  border: none;
  border-radius: 8px;
  padding: 0.875rem 1.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-apply-products:hover {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.progress-container {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.progress-bar {
  width: 100%;
  height: 12px;
  background: #ffffff;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #e5e7eb;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #4ade80 0%, #22c55e 100%);
  border-radius: 6px;
  transition: width 0.5s ease;
}

.progress-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.875rem;
  color: #6b7280;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.progress-text {
  font-weight: 600;
  color: #059669;
}

.progress-days {
  font-weight: 500;
  color: #6b7280;
}

/* Responsive Design for Detail Modal */
@media (max-width: 768px) {
  .detail-modal {
    max-width: 95vw;
    margin: 1rem;
  }
  
  .campaign-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
  }
  
  .detail-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .campaign-badge {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .product-details {
    grid-template-columns: 1fr;
  }
  
  .product-card {
    flex-direction: column;
    gap: 1rem;
  }
  
  .product-status {
    margin-left: 0;
    align-self: flex-start;
  }
  
  .summary-stats {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .campaign-stats {
    grid-template-columns: 1fr;
  }
  
  .campaign-title h2 {
    font-size: 1.5rem;
  }
  
  .header-icon {
    width: 50px;
    height: 50px;
    font-size: 2rem;
  }
  
  .header-text h3 {
    font-size: 1.25rem;
  }
}

/* Edit Modal Styling */
.edit-modal {
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
}

.edit-modal .modal-header {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  color: white;
  border-radius: 12px 12px 0 0;
  padding: 1.5rem;
  border-bottom: none;
}

.edit-modal .header-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.edit-modal .header-icon {
  width: 60px;
  height: 60px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  backdrop-filter: blur(10px);
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.edit-modal .header-text h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.5rem;
  font-weight: 700;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  color: #fff !important;
}

.edit-modal .header-subtitle {
  margin: 0;
  font-size: 1rem;
  opacity: 0.9;
  font-weight: 400;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  color: #fff !important;
}

.edit-modal .modal-body {
  padding: 2rem;
  background: #ffffff;
}

.form-section {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  border: 1px solid #e5e7eb;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.form-section:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #22c55e;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #f1f5f9;
}

.section-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  color: white;
}

.section-header h4 {
  margin: 0;
  font-size: 1.125rem;
  font-weight: 600;
  color: #1f2937;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #374151;
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.form-control {
  width: 100%;
  padding: 0.875rem 1rem;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  font-size: 0.875rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  transition: all 0.3s ease;
  background: white;
}

.form-control:focus {
  outline: none;
  border-color: #22c55e;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
}

.form-control:disabled {
  background: #ffffff;
  color: #6b7280;
  cursor: not-allowed;
}

.input-with-help {
  position: relative;
}

.form-help {
  display: block;
  margin-top: 0.5rem;
  font-size: 0.75rem;
  color: #6b7280;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.date-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.date-group {
  display: flex;
  flex-direction: column;
}

.text-muted {
  color: #6b7280;
  font-size: 0.75rem;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  margin-top: 0.5rem;
}

.edit-modal .modal-footer {
  padding: 1.5rem 2rem;
  background: white;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  border-radius: 0 0 12px 12px;
}

.btn {
  padding: 0.875rem 1.5rem;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  border: 2px solid transparent;
}

.btn-secondary {
  background: #ffffff;
  color: #374151;
  border-color: #d1d5db;
}

.btn-secondary:hover {
  background: #ffffff;
  border-color: #9ca3af;
  transform: translateY(-1px);
}

.btn-primary {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  color: white;
  border-color: #22c55e;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
  border-color: #16a34a;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
}

.btn-icon {
  font-size: 1rem;
}

/* Responsive Design for Edit Modal */
@media (max-width: 768px) {
  .edit-modal {
    max-width: 95vw;
    margin: 1rem;
  }
  
  .edit-modal .modal-body {
    padding: 1.5rem;
  }
  
  .date-row {
    grid-template-columns: 1fr;
  }
  
  .form-section {
    padding: 1rem;
  }
  
  .edit-modal .modal-footer {
    padding: 1rem 1.5rem;
    flex-direction: column;
  }
  
  .btn {
    width: 100%;
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .edit-modal .header-icon {
    width: 50px;
    height: 50px;
    font-size: 1.5rem;
  }
  
  .edit-modal .header-text h3 {
    font-size: 1.25rem;
  }
  
  .section-icon {
    width: 35px;
    height: 35px;
    font-size: 1rem;
  }
}

/* Notification Modal Styles */
.notification-overlay {
  background-color: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(4px);
}

.notification-modal {
  max-width: 600px;
  max-height: 80vh;
  animation: slideInFromTop 0.4s ease-out;
}

@keyframes slideInFromTop {
  0% {
    opacity: 0;
    transform: translateY(-50px) scale(0.9);
  }
  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.notification-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.5rem;
  border-bottom: 1px solid #e5e7eb;
  position: relative;
}

.notification-header.success {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
}

.notification-header.error {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
}

.notification-icon {
  font-size: 2rem;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.notification-title {
  flex: 1;
}

.notification-title h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.25rem;
  font-weight: 700;
  color: white;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.notification-title p {
  margin: 0;
  font-size: 1rem;
  opacity: 0.9;
  color: white;
}

.notification-close {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  color: white;
  font-size: 1.25rem;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.notification-close:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.1);
}

.notification-body {
  padding: 1.5rem;
  background: #ffffff;
}

.notification-details h4 {
  margin: 0 0 1rem 0;
  color: #374151;
  font-size: 1.125rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.notification-details h4::before {
  content: "<!-- icon: clipboard -->";
  font-size: 1.25rem;
}

.details-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  transition: all 0.2s ease;
}

.detail-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #4ade80;
}

.detail-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.detail-value {
  font-size: 1rem;
  font-weight: 600;
  color: #374151;
}

.notification-footer {
  padding: 1.5rem;
  background: white;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: center;
}

.notification-footer .btn {
  min-width: 120px;
  padding: 0.875rem 1.5rem;
  font-weight: 600;
  border-radius: 10px;
  transition: all 0.3s ease;
}

.notification-footer .btn-primary {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  border: 2px solid transparent;
}

.notification-footer .btn-primary:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
}

/* Delete Modal Styles */
.delete-overlay {
  background-color: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(6px);
}

.delete-modal {
  max-width: 700px;
  max-height: 85vh;
  animation: slideInFromCenter 0.4s ease-out;
}

@keyframes slideInFromCenter {
  0% {
    opacity: 0;
    transform: scale(0.8) translateY(-20px);
  }
  100% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.delete-header {
  background: #e2e8f0;
  color: #334155;
  padding: 2rem;
  text-align: center;
  border-radius: 12px 12px 0 0;
  position: relative;
}

.delete-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  background: transparent;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1rem auto;
  color: #334155;
}

.delete-icon svg,
.delete-icon svg *,
.delete-icon path,
.delete-icon circle,
.delete-icon rect {
  background: transparent !important;
  fill: currentColor !important;
  stroke: currentColor !important;
}

.delete-header h3 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #334155;
}

.delete-body {
  padding: 2rem;
  background: #ffffff;
}

.delete-warning {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  background: #fef3c7;
  border: 2px solid #f59e0b;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 2rem;
}

.warning-icon {
  font-size: 2rem;
  flex-shrink: 0;
  margin-top: 0.25rem;
}

.warning-text {
  margin: 0;
  font-size: 1.125rem;
  color: #92400e;
  font-weight: 500;
  line-height: 1.6;
}

.warning-text strong {
  color: #dc2626;
  font-weight: 700;
}

.delete-details {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  border: 1px solid #e5e7eb;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.delete-details h4 {
  margin: 0 0 1rem 0;
  color: #374151;
  font-size: 1.125rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.delete-details h4::before {
  content: "<!-- icon: clipboard -->";
  font-size: 1.25rem;
}

.delete-info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.delete-info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 1rem;
  background: #ffffff;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
}

.info-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.info-value {
  font-size: 1rem;
  font-weight: 600;
  color: #374151;
}

.delete-consequences {
  background: #fef2f2;
  border: 2px solid #fecaca;
  border-radius: 12px;
  padding: 1.5rem;
}

.delete-consequences h4 {
  margin: 0 0 1rem 0;
  color: #dc2626;
  font-size: 1.125rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.consequences-list {
  margin: 0;
  padding-left: 1.5rem;
  color: #7f1d1d;
}

.consequences-list li {
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
  line-height: 1.5;
}

.consequences-list li:last-child {
  margin-bottom: 0;
}

.delete-footer {
  padding: 2rem;
  background: white;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: center;
  gap: 1rem;
  border-radius: 0 0 12px 12px;
}

.delete-footer .btn {
  min-width: 140px;
  padding: 1rem 1.5rem;
  font-weight: 600;
  border-radius: 10px;
  transition: all 0.3s ease;
  font-size: 1rem;
}

.delete-footer .btn-outline {
  background: white;
  border: 2px solid #e5e7eb;
  color: #6b7280;
}

.delete-footer .btn-outline:hover {
  background: #ffffff;
  border-color: #9ca3af;
  transform: translateY(-2px);
}

.btn-danger {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  border: 2px solid transparent;
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

.btn-danger:hover {
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
}

.btn-danger:active {
  transform: translateY(0);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

/* Responsive Design for Notification and Delete Modals */
@media (max-width: 768px) {
  .notification-modal,
  .delete-modal {
    max-width: 95vw;
    margin: 1rem;
  }

  .notification-header {
    flex-direction: column;
    text-align: center;
    gap: 0.75rem;
  }

  .notification-icon {
    width: 40px;
    height: 40px;
    font-size: 1.5rem;
  }

  .details-grid,
  .delete-info-grid {
    grid-template-columns: 1fr;
  }

  .detail-item,
  .delete-info-item {
    padding: 0.75rem;
  }

  .delete-header {
    padding: 1.5rem;
  }

  .delete-icon {
    width: 60px;
    height: 60px;
    font-size: 2rem;
  }

  .delete-header h3 {
    font-size: 1.25rem;
  }

  .delete-body {
    padding: 1.5rem;
  }

  .delete-warning {
    flex-direction: column;
    text-align: center;
    padding: 1rem;
  }

  .warning-icon {
    margin: 0 auto 0.5rem auto;
  }

  .delete-footer {
    flex-direction: column;
    padding: 1.5rem;
  }

  .delete-footer .btn {
    min-width: 100%;
  }
}

/* Apply Discount Modal Styling (Enhanced Minimal Design) */
.apply-modal-minimal {
  background: white;
  border-radius: 20px;
  max-width: 900px;
  width: 90vw;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
  position: relative;
  border: none;
  backdrop-filter: blur(10px);
}

/* Modal Header - Enhanced */
.modal-header-minimal {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  padding: 2rem 2.5rem 1.5rem 2.5rem;
  background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 50%, #d1fae5 100%);
  border-bottom: 1px solid rgba(74, 222, 128, 0.2);
  position: relative;
  overflow: hidden;
}

.modal-header-minimal::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, #4ade80 0%, #22c55e 50%, #16a34a 100%);
}

.header-icon-minimal {
  width: 44px;
  height: 44px;
  padding: 10px;
  border-radius: 14px;
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 16px rgba(74, 222, 128, 0.3);
  position: relative;
}

.header-icon-minimal::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 14px;
  padding: 1px;
  background: linear-gradient(135deg, rgba(255,255,255,0.3) 0%, transparent 100%);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: exclude;
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask-composite: exclude;
}

.header-icon-minimal img {
  width: 20px;
  height: 20px;
  filter: brightness(0) invert(1) drop-shadow(0 2px 4px rgba(0,0,0,0.1));
}

.header-content-minimal {
  flex: 1;
}

.modal-title-minimal {
  font-size: 1.375rem;
  font-weight: 700;
  color: #1f2937;
  margin: 0;
  line-height: 1.4;
  background: linear-gradient(135deg, #1f2937 0%, #4ade80 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.modal-subtitle-minimal {
  font-size: 0.9375rem;
  color: #16a34a;
  margin: 0.375rem 0 0 0;
  line-height: 1.4;
  font-weight: 500;
}

/* Modal Body - Enhanced */
.modal-body-minimal {
  flex: 1;
  padding: 1.5rem 2.5rem 2rem 2.5rem;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 1.75rem;
  background: #fafafa;
}

/* Custom Scrollbar */
.modal-body-minimal::-webkit-scrollbar {
  width: 6px;
}

.modal-body-minimal::-webkit-scrollbar-track {
  background: rgba(0,0,0,0.05);
  border-radius: 3px;
}

.modal-body-minimal::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  border-radius: 3px;
}

.modal-body-minimal::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
}

/* Detail Section Styles */
.detail-section-minimal {
  background: white;
  border: 2px solid #e2e8f0;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.detail-section-minimal:hover {
  border-color: #4ade80;
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.15);
}

.section-title-minimal {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px 24px;
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.05) 0%, rgba(34, 197, 94, 0.05) 100%);
  border-bottom: 2px solid rgba(74, 222, 128, 0.1);
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
}

.section-icon-minimal {
  width: 20px;
  height: 20px;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.detail-rows-minimal {
  padding: 24px 24px 32px 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  background: white;
}

.detail-row-minimal {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 32px !important;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  transition: all 0.2s ease;
  box-sizing: border-box;
}

.detail-row-minimal:nth-child(3) {
  padding: 20px 32px !important;
  margin-bottom: 8px !important;
}

.detail-row-minimal:last-child {
  margin-bottom: 0;
}

.detail-row-minimal:hover {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.05) 0%, rgba(34, 197, 94, 0.05) 100%);
  border-color: rgba(74, 222, 128, 0.3);
  transform: translateX(2px);
}

.row-label-minimal {
  font-size: 14px;
  font-weight: 500;
  color: #64748b;
  margin: 0 !important;
  padding: 0 !important;
  flex-shrink: 0;
  min-width: fit-content;
}

.row-value-minimal {
  font-size: 14px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 !important;
  padding: 0 !important;
  text-align: right;
  flex-shrink: 0;
}

.row-value-minimal.primary-text {
  color: #22c55e;
  font-size: 16px;
  font-weight: 700;
}

/* Form Content Styles */
.form-content-minimal {
  display: flex;
  flex-direction: column;
  gap: 20px;
  padding: 24px;
  background: white;
  border-radius: 16px;
  border: 2px solid #e2e8f0;
  margin-bottom: 16px;
  transition: all 0.3s ease;
}

.form-content-minimal:hover {
  border-color: #4ade80;
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.15);
}

.form-group-minimal {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label-minimal {
  font-size: 14px;
  font-weight: 600;
  color: #374151;
  margin-bottom: 4px;
}

.form-input-minimal {
  padding: 12px 16px;
  border: 2px solid #e2e8f0;
  border-radius: 10px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: white;
}

.form-input-minimal:focus {
  outline: none;
  border-color: #4ade80;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1);
}

/* Selection Controls - Enhanced */
.selection-controls-minimal {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem;
  background: white;
  border: 1px solid rgba(74, 222, 128, 0.2);
  border-radius: 16px;
  margin-bottom: 0.5rem;
  box-shadow: 0 2px 8px rgba(74, 222, 128, 0.08);
}

.bulk-actions-minimal {
  display: flex;
  align-items: center;
  gap: 1.25rem;
}

.select-all-minimal {
  display: flex;
  align-items: center;
  gap: 0.625rem;
  cursor: pointer;
  padding: 0.625rem 0.875rem;
  border-radius: 10px;
  transition: all 0.3s ease;
  background: transparent;
  border: 1px solid transparent;
}

.select-all-minimal:hover {
  background: rgba(74, 222, 128, 0.08);
  border-color: rgba(74, 222, 128, 0.2);
}

.select-all-minimal input[type="checkbox"] {
  width: 18px;
  height: 18px;
  accent-color: #4ade80;
  cursor: pointer;
  border-radius: 4px;
}

.select-all-text-minimal {
  font-size: 0.9375rem;
  font-weight: 600;
  color: #374151;
  user-select: none;
}

.selection-summary-minimal {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  text-align: right;
}

.selected-count-minimal {
  font-size: 0.9375rem;
  font-weight: 700;
  color: #16a34a;
  background: rgba(74, 222, 128, 0.1);
  padding: 0.25rem 0.625rem;
  border-radius: 6px;
  border: 1px solid rgba(74, 222, 128, 0.2);
}

.available-count-minimal {
  font-size: 0.8125rem;
  color: #6b7280;
  font-weight: 500;
}

/* Products List Container - Enhanced */
.products-list-minimal {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.product-section-minimal {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.section-header-minimal {
  display: flex;
  align-items: center;
  margin-bottom: 0.75rem;
  position: sticky;
  top: -1.5rem;
  background: #fafafa;
  z-index: 10;
  padding: 0.5rem 0;
}

.section-badge-minimal {
  display: flex;
  align-items: center;
  gap: 0.625rem;
  padding: 0.75rem 1.125rem;
  border-radius: 12px;
  font-size: 0.9375rem;
  font-weight: 700;
  text-transform: none;
  letter-spacing: -0.025em;
  position: relative;
  border: 2px solid transparent;
}

.section-badge-minimal::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 12px;
  padding: 1px;
  background: linear-gradient(135deg, rgba(255,255,255,0.4) 0%, transparent 100%);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: exclude;
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask-composite: exclude;
}

.section-badge-minimal.current-campaign {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.15) 0%, rgba(74, 222, 128, 0.15) 100%);
  color: #15803d;
  border-color: rgba(34, 197, 94, 0.3);
  box-shadow: 0 4px 12px rgba(34, 197, 94, 0.15);
}

.section-badge-minimal.available {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.15) 0%, rgba(34, 197, 94, 0.15) 100%);
  color: #16a34a;
  border-color: rgba(74, 222, 128, 0.3);
  box-shadow: 0 4px 12px rgba(74, 222, 128, 0.15);
}

.section-badge-minimal.unavailable {
  background: linear-gradient(135deg, rgba(239, 68, 68, 0.15) 0%, rgba(220, 38, 38, 0.15) 100%);
  color: #dc2626;
  border-color: rgba(239, 68, 68, 0.3);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.15);
}

.badge-icon-minimal {
  width: 16px;
  height: 16px;
  filter: drop-shadow(0 1px 2px rgba(0,0,0,0.1));
}

/* Product Items - Enhanced */
.product-item-minimal {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  padding: 1.25rem;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  background: white;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.product-item-minimal::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: transparent;
  transition: all 0.3s ease;
}

.product-item-minimal:hover {
  border-color: rgba(74, 222, 128, 0.5);
  box-shadow: 0 8px 25px rgba(74, 222, 128, 0.12), 0 0 0 1px rgba(74, 222, 128, 0.1);
  transform: translateY(-2px);
  background: linear-gradient(135deg, #ffffff 0%, #f9fffe 100%);
}

.product-item-minimal:hover::before {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
}

.product-item-minimal.current-applied {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.05) 0%, rgba(74, 222, 128, 0.05) 100%);
  border-color: rgba(34, 197, 94, 0.3);
}

.product-item-minimal.current-applied::before {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
}

.product-item-minimal.available {
  background: white;
}

.product-item-minimal.unavailable {
  background: rgba(249, 250, 251, 0.8);
  border-color: rgba(156, 163, 175, 0.4);
  cursor: not-allowed;
  opacity: 0.75;
}

.product-item-minimal.unavailable:hover {
  transform: none;
  box-shadow: none;
  border-color: rgba(156, 163, 175, 0.4);
}

.product-item-minimal.unavailable::before {
  background: #9ca3af;
}

.product-checkbox-minimal {
  flex-shrink: 0;
}

.product-checkbox-minimal input[type="checkbox"] {
  width: 20px;
  height: 20px;
  accent-color: #4ade80;
  cursor: pointer;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.product-checkbox-minimal input[type="checkbox"]:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.product-details-minimal {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.625rem;
  min-width: 0;
}

.product-name-minimal {
  font-size: 1.0625rem;
  font-weight: 700;
  color: #1f2937;
  line-height: 1.4;
  margin: 0;
}

.product-specs-minimal {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.9375rem;
  color: #6b7280;
  flex-wrap: wrap;
}

.spec-item-minimal {
  background: rgba(74, 222, 128, 0.08);
  color: #16a34a;
  padding: 0.375rem 0.625rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.8125rem;
  border: 1px solid rgba(74, 222, 128, 0.2);
}

.spec-separator-minimal {
  color: #d1d5db;
  font-weight: 400;
  font-size: 1rem;
}

.product-status-minimal {
  font-size: 0.8125rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 0.375rem 0.625rem;
  border-radius: 8px;
  width: fit-content;
  border: 1px solid transparent;
}

.product-status-minimal.current-status {
  background: rgba(34, 197, 94, 0.12);
  color: #15803d;
  border-color: rgba(34, 197, 94, 0.2);
}

.product-status-minimal.available-status {
  background: rgba(74, 222, 128, 0.12);
  color: #16a34a;
  border-color: rgba(74, 222, 128, 0.2);
}

.product-status-minimal.unavailable-status {
  background: rgba(239, 68, 68, 0.12);
  color: #dc2626;
  border-color: rgba(239, 68, 68, 0.2);
}

.product-price-minimal {
  font-size: 1.125rem;
  font-weight: 800;
  color: #16a34a;
  text-align: right;
  flex-shrink: 0;
  background: rgba(74, 222, 128, 0.08);
  padding: 0.5rem 0.75rem;
  border-radius: 10px;
  border: 1px solid rgba(74, 222, 128, 0.2);
  min-width: fit-content;
}

.disabled-text {
  color: #9ca3af !important;
  opacity: 0.7;
}

/* Empty State - Enhanced */
.empty-state-minimal {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  text-align: center;
  background: white;
  border-radius: 16px;
  border: 2px dashed #d1d5db;
}

.empty-icon-minimal {
  width: 100px;
  height: 100px;
  margin-bottom: 1.5rem;
  opacity: 0.6;
  filter: grayscale(1);
}

.empty-icon-minimal img {
  width: 100%;
  height: 100%;
}

.empty-text-minimal h4 {
  font-size: 1.375rem;
  font-weight: 700;
  color: #374151;
  margin: 0 0 0.75rem 0;
}

.empty-text-minimal p {
  font-size: 1.0625rem;
  color: #6b7280;
  margin: 0;
  line-height: 1.6;
  max-width: 400px;
}

/* Modal Footer - Enhanced */
.modal-footer-minimal {
  display: flex;
  justify-content: center;
  gap: 1.25rem;
  padding: 2rem 2.5rem;
  background: white;
  border-top: 1px solid rgba(74, 222, 128, 0.15);
}

.btn-cancel-minimal,
.btn-confirm-minimal {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.625rem;
  padding: 1rem 1.75rem;
  border-radius: 12px;
  font-size: 0.9375rem;
  font-weight: 700;
  text-transform: none;
  letter-spacing: -0.025em;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  border: 2px solid transparent;
  min-width: 160px;
  position: relative;
  overflow: hidden;
}

.btn-cancel-minimal {
  background: white;
  border-color: #e5e7eb;
  color: #6b7280;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.btn-cancel-minimal:hover {
  background: #f9fafb;
  border-color: #9ca3af;
  color: #374151;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.btn-confirm-minimal {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
  border-color: transparent;
}

.btn-confirm-minimal::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 12px;
  padding: 1px;
  background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 100%);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: exclude;
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask-composite: exclude;
}

.btn-confirm-minimal:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 24px rgba(74, 222, 128, 0.4);
}

.btn-confirm-minimal:active,
.btn-cancel-minimal:active {
  transform: translateY(0);
}

.btn-icon-minimal {
  width: 18px;
  height: 18px;
}

.btn-cancel-minimal .btn-icon-minimal {
  filter: grayscale(1);
}

.btn-confirm-minimal .btn-icon-minimal {
  filter: brightness(0) invert(1) drop-shadow(0 1px 2px rgba(0,0,0,0.1));
}

/* Responsive Design for Apply Modal */
@media (max-width: 1024px) {
  .apply-modal-minimal {
    max-width: 95vw;
    max-height: 95vh;
    border-radius: 16px;
  }

  .modal-header-minimal,
  .modal-footer-minimal {
    padding: 1.5rem 2rem;
  }

  .modal-body-minimal {
    padding: 1.25rem 2rem;
    gap: 1.5rem;
  }
}

@media (max-width: 768px) {
  .apply-modal-minimal {
    max-width: 100vw;
    max-height: 100vh;
    border-radius: 0;
    margin: 0;
  }

  .modal-header-minimal {
    padding: 1.25rem 1.5rem;
    flex-wrap: wrap;
    gap: 1rem;
  }

  .header-icon-minimal {
    width: 40px;
    height: 40px;
    padding: 8px;
  }

  .header-icon-minimal img {
    width: 18px;
    height: 18px;
  }

  .modal-title-minimal {
    font-size: 1.25rem;
  }

  .modal-subtitle-minimal {
    font-size: 0.875rem;
  }

  .modal-body-minimal {
    padding: 1rem 1.5rem;
    gap: 1.25rem;
  }

  .selection-controls-minimal {
    flex-direction: column;
    align-items: stretch;
    gap: 1rem;
    padding: 1rem;
  }

  .bulk-actions-minimal {
    justify-content: center;
  }

  .selection-summary-minimal {
    text-align: center;
  }

  .product-item-minimal {
    flex-direction: column;
    align-items: stretch;
    gap: 1rem;
    padding: 1.125rem;
  }

  .product-details-minimal {
    text-align: center;
  }

  .product-specs-minimal {
    justify-content: center;
    flex-wrap: wrap;
  }

  .product-price-minimal {
    text-align: center;
    font-size: 1.25rem;
    align-self: center;
  }

  .modal-footer-minimal {
    flex-direction: column;
    padding: 1.25rem 1.5rem;
    gap: 1rem;
  }

  .btn-cancel-minimal,
  .btn-confirm-minimal {
    min-width: 100%;
    padding: 1.125rem 1.5rem;
  }

  .empty-state-minimal {
    padding: 2.5rem 1.5rem;
  }

  .empty-icon-minimal {
    width: 80px;
    height: 80px;
  }

  .empty-text-minimal h4 {
    font-size: 1.25rem;
  }

  .empty-text-minimal p {
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .modal-header-minimal {
    padding: 1rem 1.25rem;
  }

  .modal-body-minimal {
    padding: 0.875rem 1.25rem;
  }

  .modal-footer-minimal {
    padding: 1rem 1.25rem;
  }

  .product-item-minimal {
    padding: 1rem;
  }

  .section-badge-minimal {
    padding: 0.625rem 1rem;
    font-size: 0.875rem;
  }

  .selected-count-minimal {
    font-size: 0.875rem;
    padding: 0.375rem 0.75rem;
  }

  .product-name-minimal {
    font-size: 1rem;
  }

  .product-price-minimal {
    font-size: 1.125rem;
    padding: 0.625rem 1rem;
  }
}

/* Enhanced Animation Effects */
@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: scale(0.95) translateY(20px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.apply-modal-minimal {
  animation: modalSlideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes productSlideIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.product-item-minimal {
  animation: productSlideIn 0.2s ease-out;
  animation-fill-mode: backwards;
}

.product-item-minimal:nth-child(1) { animation-delay: 0ms; }
.product-item-minimal:nth-child(2) { animation-delay: 50ms; }
.product-item-minimal:nth-child(3) { animation-delay: 100ms; }
.product-item-minimal:nth-child(4) { animation-delay: 150ms; }
.product-item-minimal:nth-child(5) { animation-delay: 200ms; }

/* Loading States */
.product-item-minimal.loading {
  background: linear-gradient(90deg, #f0f0f0 0%, #e0e0e0 50%, #f0f0f0 100%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

/* Focus States for Accessibility */
.product-checkbox-minimal input[type="checkbox"]:focus,
.select-all-minimal input[type="checkbox"]:focus {
  outline: 2px solid #4ade80;
  outline-offset: 2px;
}

.btn-cancel-minimal:focus,
.btn-confirm-minimal:focus {
  outline: 2px solid #4ade80;
  outline-offset: 2px;
}

.product-item-minimal:focus {
  outline: 2px solid #4ade80;
  outline-offset: -2px;
}

/* Auto-update status notification styles */
.auto-update-notification {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.1) 0%, rgba(74, 222, 128, 0.1) 100%);
  border: 1px solid rgba(34, 197, 94, 0.3);
  border-radius: 8px;
  padding: 0.75rem;
  margin-top: 0.5rem;
  animation: slideInDown 0.5s ease-out, fadeOut 0.5s ease-in 4.5s forwards;
}

.auto-update-notification .help-icon-minimal {
  width: 16px;
  height: 16px;
  margin-right: 0.5rem;
}

.auto-update-notification span {
  color: #059669;
  font-size: 0.875rem;
  font-weight: 500;
  line-height: 1.4;
}

/* Animation for auto-update notification */
@keyframes slideInDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeOut {
  from {
    opacity: 1;
    transform: translateY(0);
  }
  to {
    opacity: 0;
    transform: translateY(-5px);
  }
}

/* ===============================================
   REDESIGNED PRODUCT SELECTION SECTION
   =============================================== */

.products-grid-redesign {
  max-height: 500px;
  overflow-y: auto;
  padding: 0 4px;
  margin-bottom: 16px;
  border-radius: 12px;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
}

/* Scrollbar Styling */
.products-grid-redesign::-webkit-scrollbar {
  width: 8px;
}

.products-grid-redesign::-webkit-scrollbar-track {
  background: rgba(148, 163, 184, 0.1);
  border-radius: 4px;
}

.products-grid-redesign::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #4ade80, #22c55e);
  border-radius: 4px;
  transition: all 0.3s ease;
}

.products-grid-redesign::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #22c55e, #16a34a);
}

/* Category Section */
.product-category-redesign {
  margin-bottom: 32px;
  background: white;
  border-radius: 16px;
  border: 2px solid transparent;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.product-category-redesign:hover {
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.product-category-redesign.available-category {
  border-color: rgba(74, 222, 128, 0.4);
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.02) 0%, rgba(34, 197, 94, 0.02) 100%);
}

.product-category-redesign.applied-category {
  border-color: rgba(59, 130, 246, 0.4);
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.02) 0%, rgba(37, 99, 235, 0.02) 100%);
}

.product-category-redesign.unavailable-category {
  border-color: rgba(248, 113, 113, 0.3);
}

/* Category Header */
.category-header-redesign {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 24px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}

/* Different backgrounds for each category */
.available-category .category-header-redesign {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.08) 0%, rgba(34, 197, 94, 0.08) 100%);
}

.applied-category .category-header-redesign {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.08) 0%, rgba(37, 99, 235, 0.08) 100%);
}

.unavailable-category .category-header-redesign {
  background: linear-gradient(135deg, rgba(248, 113, 113, 0.08) 0%, rgba(239, 68, 68, 0.08) 100%);
}

.category-title-redesign {
  display: flex;
  align-items: center;
  gap: 16px;
}

.category-icon-redesign {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.category-icon-redesign::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, currentColor 0%, currentColor 100%);
  opacity: 0.1;
}

.category-icon-redesign.available-icon {
  color: #22c55e;
  border: 2px solid rgba(74, 222, 128, 0.3);
  background: rgba(74, 222, 128, 0.1);
}

.category-icon-redesign.applied-icon {
  color: #3b82f6;
  border: 2px solid rgba(59, 130, 246, 0.3);
  background: rgba(59, 130, 246, 0.1);
}

.category-icon-redesign.unavailable-icon {
  color: #f87171;
  border: 2px solid rgba(248, 113, 113, 0.2);
}

.category-icon-redesign img {
  width: 24px;
  height: 24px;
  position: relative;
  z-index: 1;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.category-info-redesign h3 {
  font-size: 18px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 4px 0;
}

.category-info-redesign p {
  font-size: 14px;
  color: #64748b;
  margin: 0;
}

/* Category Actions */
.category-actions-redesign {
  display: flex;
  gap: 12px;
}

.quick-select-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  border: 2px solid transparent;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.quick-select-btn img {
  width: 16px;
  height: 16px;
}

.quick-select-btn.available-select {
  color: #16a34a;
  border-color: rgba(74, 222, 128, 0.3);
}

.quick-select-btn.available-select:hover {
  background: rgba(74, 222, 128, 0.1);
  border-color: #4ade80;
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
}

.quick-select-btn.applied-select {
  color: #1d4ed8;
  border-color: rgba(59, 130, 246, 0.3);
}

.quick-select-btn.applied-select:hover {
  background: rgba(59, 130, 246, 0.1);
  border-color: #3b82f6;
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(59, 130, 246, 0.3);
}

/* Products Grid Container */
.products-grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 16px;
  padding: 24px;
}

/* Product Card */
.product-card-redesign {
  background: white;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.product-card-redesign::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: transparent;
  transition: all 0.3s ease;
}

.product-card-redesign.available-card::before {
  background: linear-gradient(90deg, #22c55e, #16a34a);
}

.product-card-redesign.applied-card {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.02) 0%, rgba(37, 99, 235, 0.02) 100%);
  border-color: rgba(59, 130, 246, 0.2);
}

.product-card-redesign.applied-card::before {
  background: linear-gradient(90deg, #3b82f6, #2563eb);
}

.product-card-redesign.unavailable-card::before {
  background: linear-gradient(90deg, #f87171, #ef4444);
}

.product-card-redesign:hover:not(.disabled) {
  border-color: #4ade80;
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.2);
  transform: translateY(-2px);
}

.product-card-redesign.selected {
  border-color: #22c55e;
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.05) 0%, rgba(34, 197, 94, 0.05) 100%);
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.3);
}

.product-card-redesign.applied-card.selected {
  border-color: #3b82f6;
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.08) 0%, rgba(37, 99, 235, 0.08) 100%);
  box-shadow: 0 8px 32px rgba(59, 130, 246, 0.3);
}

.product-card-redesign.disabled {
  background: #f8fafc;
  border-color: #e2e8f0;
  cursor: not-allowed;
  opacity: 0.7;
}

/* Product Selection */
.product-selection-redesign {
  position: absolute;
  top: 16px;
  right: 16px;
  z-index: 2;
}

.custom-checkbox-redesign {
  position: relative;
  width: 24px;
  height: 24px;
}

.custom-checkbox-redesign input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  width: 100%;
  height: 100%;
  margin: 0;
}

.checkmark-redesign {
  position: absolute;
  top: 0;
  left: 0;
  width: 24px;
  height: 24px;
  background: white;
  border: 2px solid #cbd5e1;
  border-radius: 6px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.custom-checkbox-redesign input:checked ~ .checkmark-redesign {
  background: linear-gradient(135deg, #4ade80, #22c55e);
  border-color: #22c55e;
  box-shadow: 0 4px 12px rgba(74, 222, 128, 0.4);
}

.checkmark-redesign:after {
  content: "";
  position: absolute;
  display: none;
  left: 7px;
  top: 3px;
  width: 6px;
  height: 12px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.custom-checkbox-redesign input:checked ~ .checkmark-redesign:after {
  display: block;
}

.custom-checkbox-redesign.disabled .checkmark-redesign {
  background: #f1f5f9;
  border-color: #cbd5e1;
  cursor: not-allowed;
}

/* Product Info */
.product-info-redesign {
  padding-right: 40px;
}

.product-header-redesign {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 12px;
}

.product-name-redesign {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 4px 0;
  line-height: 1.4;
}

/* Status Badges */
.product-status-badge {
  padding: 4px 8px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  flex-shrink: 0;
}

.available-badge {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.15) 0%, rgba(34, 197, 94, 0.15) 100%);
  color: #16a34a;
  border: 1px solid rgba(74, 222, 128, 0.3);
}

.applied-badge {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.15) 0%, rgba(37, 99, 235, 0.15) 100%);
  color: #1d4ed8;
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.unavailable-badge {
  background: linear-gradient(135deg, rgba(248, 113, 113, 0.15) 0%, rgba(239, 68, 68, 0.15) 100%);
  color: #dc2626;
  border: 1px solid rgba(248, 113, 113, 0.3);
}

/* Product Details */
.product-details-redesign {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.product-specs-redesign {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.spec-chip-redesign {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 10px;
  background: #f1f5f9;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 13px;
}

.spec-chip-redesign.color-chip {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(37, 99, 235, 0.1) 100%);
  border-color: rgba(59, 130, 246, 0.3);
  color: #1d4ed8;
}

.spec-chip-redesign.size-chip {
  background: linear-gradient(135deg, rgba(168, 85, 247, 0.1) 0%, rgba(147, 51, 234, 0.1) 100%);
  border-color: rgba(168, 85, 247, 0.3);
  color: #7c3aed;
}

.spec-chip-redesign.disabled {
  background: #f8fafc;
  border-color: #e2e8f0;
  color: #94a3b8;
}

.spec-label {
  font-weight: 500;
}

.spec-value {
  font-weight: 600;
}

/* Product Price */
.product-price-redesign {
  font-size: 18px;
  font-weight: 700;
  color: #1e293b;
}

.product-price-redesign .currency {
  font-size: 14px;
  font-weight: 500;
  color: #64748b;
}

.product-price-redesign.disabled {
  color: #94a3b8;
}

/* Unavailable Reason */
.unavailable-reason-redesign {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 12px;
  padding: 8px 12px;
  background: rgba(248, 113, 113, 0.1);
  border: 1px solid rgba(248, 113, 113, 0.2);
  border-radius: 8px;
  font-size: 13px;
  color: #dc2626;
}

.unavailable-reason-redesign img {
  width: 16px;
  height: 16px;
  flex-shrink: 0;
}

/* Enhanced Empty State */
.empty-state-redesign {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 40px;
  text-align: center;
}

.empty-illustration-redesign {
  max-width: 400px;
  width: 100%;
}

.empty-icon-redesign {
  width: 80px;
  height: 80px;
  margin: 0 auto 24px;
  background: linear-gradient(135deg, rgba(248, 113, 113, 0.1) 0%, rgba(239, 68, 68, 0.1) 100%);
  border: 2px solid rgba(248, 113, 113, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-icon-redesign img {
  width: 40px;
  height: 40px;
}

.empty-content-redesign h3 {
  font-size: 24px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 12px 0;
}

.empty-content-redesign > p {
  font-size: 16px;
  color: #64748b;
  margin: 0 0 24px 0;
  line-height: 1.6;
}

.empty-suggestions-redesign {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 20px;
  text-align: left;
}

.empty-suggestions-redesign > p {
  font-size: 14px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 12px 0;
}

.empty-suggestions-redesign ul {
  margin: 0;
  padding-left: 16px;
  color: #64748b;
}

.empty-suggestions-redesign li {
  font-size: 14px;
  margin-bottom: 4px;
  line-height: 1.5;
}

/* Responsive Design */
@media (max-width: 768px) {
  .products-grid-container {
    grid-template-columns: 1fr;
    padding: 16px;
    gap: 12px;
  }
  
  .category-header-redesign {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    padding: 16px 20px;
  }
  
  .category-actions-redesign {
    width: 100%;
    justify-content: flex-end;
  }
  
  .product-card-redesign {
    padding: 16px;
  }
  
  .product-info-redesign {
    padding-right: 32px;
  }
}

/* Animation Enhancements */
.product-card-redesign {
  animation: cardSlideIn 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  animation-fill-mode: backwards;
}

.product-card-redesign:nth-child(odd) {
  animation-delay: 0.1s;
}

.product-card-redesign:nth-child(even) {
  animation-delay: 0.2s;
}

@keyframes cardSlideIn {
  from {
    opacity: 0;
    transform: translateY(20px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.category-header-redesign {
  animation: headerSlideIn 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes headerSlideIn {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* ===============================================
   REDESIGNED APPLY MODAL - UNIFIED BODY
   =============================================== */

.apply-modal-redesigned {
  max-width: 1100px;
  width: 95vw;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  background: white;
  border-radius: 24px;
  box-shadow: 0 32px 64px rgba(0, 0, 0, 0.12);
  overflow: hidden;
  position: relative;
}

/* Modal Header */
.modal-header-redesigned {
  background: #e2e8f0;
  padding: 24px 32px;
  border-bottom: 1px solid #e2e8f0;
}

.header-content-redesigned {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left-redesigned {
  display: flex;
  align-items: center;
  gap: 16px;
}

.campaign-icon-redesigned {
  width: 56px;
  height: 56px;
  background: #4ade80;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.tag-icon-redesigned {
  width: 24px;
  height: 24px;
  filter: brightness(0) invert(1);
}

.campaign-info-redesigned {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.campaign-title-redesigned {
  font-size: 24px;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
  line-height: 1.2;
}

.campaign-status-redesigned {
  display: flex;
  align-items: center;
}

.status-badge-redesigned {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: rgba(74, 222, 128, 0.1);
  color: #166534;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-badge-redesigned::before {
  content: '';
  width: 6px;
  height: 6px;
  background: #4ade80;
  border-radius: 50%;
}

.close-btn-redesigned {
  background: white;
  border: none;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.close-btn-redesigned:hover {
  background: #f8fafc;
  transform: scale(1.05);
}

.close-btn-redesigned img {
  width: 16px;
  height: 16px;
  opacity: 0.6;
}

/* Modal Body */
.modal-body-redesigned {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 32px;
  overflow-y: auto;
  background: #fafafa;
  gap: 32px;
}

/* Controls Section */
.controls-section-redesigned {
  background: white;
  border-radius: 20px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: 2px solid #e2e8f0;
  transition: all 0.3s ease;
}

.controls-section-redesigned:hover {
  border-color: #4ade80;
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.15);
}

.search-container-redesigned {
  margin-bottom: 20px;
}

.search-input-container-redesigned {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon-redesigned {
  position: absolute;
  left: 16px;
  width: 20px;
  height: 20px;
  opacity: 0.5;
  z-index: 2;
}

.search-input-redesigned {
  width: 100%;
  padding: 16px 16px 16px 48px;
  border: 2px solid #e2e8f0;
  border-radius: 16px;
  font-size: 16px;
  background: white;
  transition: all 0.3s ease;
}

.search-input-redesigned:focus {
  outline: none;
  border-color: #4ade80;
  box-shadow: 0 0 0 4px rgba(74, 222, 128, 0.1);
  background: #fafffe;
}

.selection-controls-redesigned {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 16px;
}

.control-buttons-redesigned {
  display: flex;
  gap: 12px;
}

.control-btn-redesigned {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  border: 2px solid transparent;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  background: white;
}

.control-btn-redesigned img {
  width: 16px;
  height: 16px;
}

.select-all-btn {
  color: #166534;
  border-color: #4ade80;
  background: rgba(74, 222, 128, 0.05);
}

.select-all-btn:hover:not(:disabled) {
  background: rgba(74, 222, 128, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
}

.clear-all-btn {
  color: #dc2626;
  border-color: #f87171;
  background: rgba(248, 113, 113, 0.05);
}

.clear-all-btn:hover:not(:disabled) {
  background: rgba(248, 113, 113, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(248, 113, 113, 0.3);
}

.control-btn-redesigned:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.selection-summary-redesigned {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.summary-badge-redesigned {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 600;
}

.summary-badge-redesigned.selected {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.15) 0%, rgba(74, 222, 128, 0.15) 100%);
  color: #166534;
  border: 1px solid rgba(74, 222, 128, 0.3);
}

.summary-badge-redesigned.available {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.15) 0%, rgba(37, 99, 235, 0.15) 100%);
  color: #1d4ed8;
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.summary-badge-redesigned.unavailable {
  background: linear-gradient(135deg, rgba(248, 113, 113, 0.15) 0%, rgba(239, 68, 68, 0.15) 100%);
  color: #dc2626;
  border: 1px solid rgba(248, 113, 113, 0.3);
}

.summary-count-redesigned {
  font-size: 16px;
  font-weight: 700;
}

.summary-label-redesigned {
  font-weight: 500;
  opacity: 0.8;
}

/* Products Container */
.products-container-redesigned {
  background: white;
  border-radius: 20px;
  padding: 32px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: 2px solid #e2e8f0;
  transition: all 0.3s ease;
}

.products-container-redesigned:hover {
  border-color: #4ade80;
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.15);
}

.products-grid-redesigned {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
  margin-bottom: 32px;
}

.product-card-redesigned {
  background: white;
  border: 2px solid #e2e8f0;
  border-radius: 16px;
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.product-card-redesigned::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: transparent;
  transition: all 0.3s ease;
}

.product-card-redesigned:hover:not(.unavailable-card) {
  border-color: #4ade80;
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.2);
  transform: translateY(-4px);
}

.product-card-redesigned:hover:not(.unavailable-card)::before {
  background: linear-gradient(90deg, #4ade80, #22c55e);
}

.product-card-redesigned.selected {
  border-color: #4ade80;
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.05) 0%, rgba(74, 222, 128, 0.05) 100%);
  box-shadow: 0 8px 32px rgba(74, 222, 128, 0.3);
  transform: translateY(-4px);
}

.product-card-redesigned.selected::before {
  background: linear-gradient(90deg, #4ade80, #4ade80);
}

.product-card-redesigned.applied {
  border-color: #4ade80;
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.03) 0%, rgba(34, 197, 94, 0.03) 100%);
}

.product-card-redesigned.applied::before {
  background: linear-gradient(90deg, #4ade80, #22c55e);
}

.product-card-redesigned.unavailable-card {
  background: #f8fafc;
  border-color: #e2e8f0;
  cursor: not-allowed;
  opacity: 0.7;
}

.product-card-redesigned.unavailable-card::before {
  background: linear-gradient(90deg, #f87171, #ef4444);
}

.product-selection-redesigned {
  position: absolute;
  top: 16px;
  right: 16px;
  z-index: 2;
}

.checkbox-container-redesigned {
  position: relative;
  width: 28px;
  height: 28px;
}

.product-checkbox-redesigned {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  width: 100%;
  height: 100%;
  margin: 0;
}

.checkmark-redesigned {
  position: absolute;
  top: 0;
  left: 0;
  width: 28px;
  height: 28px;
  background: white;
  border: 2px solid #cbd5e1;
  border-radius: 8px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.product-checkbox-redesigned:checked ~ .checkmark-redesigned {
  background: linear-gradient(135deg, #4ade80, #4ade80);
  border-color: #4ade80;
  box-shadow: 0 4px 12px rgba(74, 222, 128, 0.4);
}

.checkmark-redesigned:after {
  content: "";
  position: absolute;
  display: none;
  left: 9px;
  top: 5px;
  width: 6px;
  height: 12px;
  border: solid white;
  border-width: 0 3px 3px 0;
  transform: rotate(45deg);
}

.product-checkbox-redesigned:checked ~ .checkmark-redesigned:after {
  display: block;
}

.checkbox-container-redesigned.disabled .checkmark-redesigned {
  background: #f1f5f9;
  border-color: #cbd5e1;
  cursor: not-allowed;
}

.product-content-redesigned {
  padding-right: 44px;
}

.product-header-redesigned {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.product-name-redesigned {
  font-size: 18px;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
  line-height: 1.4;
}

.product-status-redesigned {
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  flex-shrink: 0;
  margin-left: 12px;
}

.available-status {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.15) 0%, rgba(74, 222, 128, 0.15) 100%);
  color: #166534;
  border: 1px solid rgba(74, 222, 128, 0.3);
}

.applied-status {
  background: linear-gradient(135deg, rgba(74, 222, 128, 0.15) 0%, rgba(34, 197, 94, 0.15) 100%);
  color: #166534;
  border: 1px solid rgba(74, 222, 128, 0.3);
}

.unavailable-status {
  background: linear-gradient(135deg, rgba(248, 113, 113, 0.15) 0%, rgba(239, 68, 68, 0.15) 100%);
  color: #dc2626;
  border: 1px solid rgba(248, 113, 113, 0.3);
}

.product-details-redesigned {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.product-specs-redesigned {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.spec-item-redesigned {
  padding: 8px 12px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  border: 1px solid;
}

.color-spec {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(37, 99, 235, 0.1) 100%);
  color: #1d4ed8;
  border-color: rgba(59, 130, 246, 0.3);
}

.size-spec {
  background: linear-gradient(135deg, rgba(168, 85, 247, 0.1) 0%, rgba(147, 51, 234, 0.1) 100%);
  color: #7c3aed;
  border-color: rgba(168, 85, 247, 0.3);
}

.product-price-redesigned {
  display: flex;
  align-items: baseline;
  gap: 4px;
}

.price-amount-redesigned {
  font-size: 20px;
  font-weight: 800;
  color: #1e293b;
}

.price-currency-redesigned {
  font-size: 14px;
  font-weight: 500;
  color: #64748b;
}

/* Unavailable Section */
.unavailable-section-redesigned {
  margin-top: 32px;
  padding-top: 32px;
  border-top: 2px dashed rgba(248, 113, 113, 0.3);
}

.unavailable-header-redesigned {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
  padding: 16px 20px;
  background: linear-gradient(135deg, rgba(248, 113, 113, 0.08) 0%, rgba(239, 68, 68, 0.08) 100%);
  border: 1px solid rgba(248, 113, 113, 0.2);
  border-radius: 12px;
}

.warning-icon-redesigned {
  width: 24px;
  height: 24px;
  filter: sepia(1) saturate(3) hue-rotate(330deg);
}

.unavailable-title-redesigned {
  font-size: 16px;
  font-weight: 600;
  color: #dc2626;
}

.unavailable-count-redesigned {
  font-size: 14px;
  font-weight: 500;
  color: #dc2626;
  opacity: 0.8;
}

.unavailable-products-redesigned {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 16px;
}

/* Empty State */
.empty-state-redesigned {
  text-align: center;
  padding: 60px 40px;
  color: #64748b;
}

.empty-icon-redesigned {
  width: 80px;
  height: 80px;
  margin: 0 auto 24px;
  background: linear-gradient(135deg, rgba(248, 113, 113, 0.1) 0%, rgba(239, 68, 68, 0.1) 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid rgba(248, 113, 113, 0.2);
}

.empty-icon-redesigned img {
  width: 40px;
  height: 40px;
  opacity: 0.6;
}

.empty-title-redesigned {
  font-size: 24px;
  font-weight: 700;
  color: #1e293b;
  margin: 0 0 12px 0;
}

.empty-description-redesigned {
  font-size: 16px;
  color: #64748b;
  margin: 0;
  line-height: 1.6;
}

/* Modal Footer */
.modal-footer-redesigned {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  padding: 24px 32px;
  border-top: 2px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-info-redesigned {
  color: #64748b;
  font-size: 14px;
}

.footer-text-redesigned strong {
  color: #4ade80;
  font-weight: 700;
}

.footer-actions-redesigned {
  display: flex;
  gap: 16px;
}

.btn-cancel-redesigned {
  padding: 12px 24px;
  border: 2px solid #e2e8f0;
  background: white;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  color: #64748b;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-cancel-redesigned:hover {
  background: #f8fafc;
  border-color: #cbd5e1;
  color: #374151;
}

.btn-confirm-redesigned {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: linear-gradient(135deg, #4ade80 0%, #4ade80 100%);
  border: none;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.4);
}

.btn-confirm-redesigned:hover:not(:disabled) {
  background: linear-gradient(135deg, #22c55e 0%, #22c55e 100%);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(74, 222, 128, 0.5);
}

.btn-confirm-redesigned:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.btn-confirm-redesigned img {
  width: 16px;
  height: 16px;
  filter: brightness(0) invert(1);
}

/* Responsive Design */
@media (max-width: 1024px) {
  .apply-modal-redesigned {
    max-width: 95vw;
    max-height: 95vh;
  }

  .modal-header-redesigned {
    padding: 20px 24px;
  }

  .campaign-icon-redesigned {
    width: 48px;
    height: 48px;
  }

  .tag-icon-redesigned {
    width: 20px;
    height: 20px;
  }

  .campaign-title-redesigned {
    font-size: 20px;
  }

  .products-grid-redesigned {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 16px;
  }

  .selection-controls-redesigned {
    flex-direction: column;
    align-items: stretch;
  }

  .control-buttons-redesigned {
    justify-content: center;
  }

  .selection-summary-redesigned {
    justify-content: center;
  }
}

@media (max-width: 768px) {
  .apply-modal-redesigned {
    max-width: 100vw;
    max-height: 100vh;
    border-radius: 0;
  }

  .modal-header-redesigned {
    padding: 20px;
  }

  .header-left-redesigned {
    gap: 12px;
  }

  .campaign-icon-redesigned {
    width: 40px;
    height: 40px;
  }

  .tag-icon-redesigned {
    width: 18px;
    height: 18px;
  }

  .campaign-title-redesigned {
    font-size: 18px;
  }

  .close-btn-redesigned {
    width: 36px;
    height: 36px;
  }

  .modal-body-redesigned,
  .modal-footer-redesigned {
    padding: 20px;
  }

  .modal-body-redesigned,
  .modal-footer-redesigned {
    padding: 20px;
  }

  .products-grid-redesigned,
  .unavailable-products-redesigned {
    grid-template-columns: 1fr;
  }

  .product-header-redesigned {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .product-status-redesigned {
    margin-left: 0;
  }

  .footer-actions-redesigned {
    flex-direction: column;
    width: 100%;
  }

  .btn-cancel-redesigned,
  .btn-confirm-redesigned {
    width: 100%;
    justify-content: center;
  }
}

/* Animations */
.product-card-redesigned {
  animation: cardFadeIn 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  animation-fill-mode: backwards;
}

.product-card-redesigned:nth-child(odd) {
  animation-delay: 0.1s;
}

.product-card-redesigned:nth-child(even) {
  animation-delay: 0.2s;
}

@keyframes cardFadeIn {
  from {
    opacity: 0;
    transform: translateY(30px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
</style>
