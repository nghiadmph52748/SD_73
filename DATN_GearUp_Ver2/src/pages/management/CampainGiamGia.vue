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
                    campaign.deleted ? 'status-deleted' : 
                    (campaign.trangThai ? 'status-active' : 'status-inactive'),
                  ]"
                >
                  {{ campaign.deleted ? "Đã xóa" : (campaign.trangThai ? "Hoạt động" : "Ngừng hoạt động") }}
                </span>
              </td>
              <td>
                <span
                  :class="[
                    'status-badge',
                    campaign.trangThai ? 'status-active' : 'status-upcoming',
                  ]"
                >
                  {{ campaign.trangThai ? "Đang diễn ra" : "Sắp diễn ra" }}
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
          <button class="cancel-btn-minimal" @click="closeModals">
            <img :src="CancelIcon" alt="Cancel" class="btn-icon-minimal" />
            <span>Hủy</span>
          </button>
          <button class="save-btn-minimal" @click="saveCampaign">
            <img :src="showAddModal ? PlusIcon : EditIcon" alt="Save" class="btn-icon-minimal" />
            <span>{{ showAddModal ? "Tạo đợt giảm giá" : "Cập nhật" }}</span>
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
                  :src="selectedCampaign.trangThai ? SuccessIcon : CancelIcon" 
                  alt="Status" 
                  class="status-icon-minimal" 
                />
                <span class="status-text-minimal">
                  {{ selectedCampaign.trangThai ? 'ĐANG HOẠT ĐỘNG' : 'NGỪNG HOẠT ĐỘNG' }}
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
                  <span class="row-value-minimal" :class="selectedCampaign.trangThai ? 'success-text' : 'warning-text'">
                    {{ selectedCampaign.trangThai ? 'Đang hoạt động' : 'Ngừng hoạt động' }}
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
    <div v-if="showApplyModal" class="modal-overlay" @click="closeApplyModal">
      <div class="modal-content apply-modal" @click.stop>
        <div class="modal-header">
          <h3>Áp dụng đợt giảm giá: {{ applyingCampaign?.tenDotGiamGia }}</h3>
          <button class="modal-close" @click="closeApplyModal">✕</button>
        </div>

        <div class="modal-body">
          <div class="discount-info">
            <div class="info-row">
              <span class="label">Giá trị giảm giá:</span>
              <span class="value">{{ applyingCampaign?.giaTriGiamGia }}%</span>
            </div>
            <div class="info-row">
              <span class="label">Thời gian:</span>
              <span class="value">
                {{ formatDateShort(applyingCampaign?.ngayBatDau) }} -
                {{ formatDateShort(applyingCampaign?.ngayKetThuc) }}
              </span>
            </div>
          </div>

          <div class="product-selection">
            <h4>Chọn sản phẩm chi tiết áp dụng:</h4>
            <div class="product-search">
              <input
                type="text"
                placeholder="Tìm kiếm sản phẩm..."
                class="form-control"
                v-model="searchProductQuery"
              />
            </div>

            <div class="selection-controls">
              <button
                class="btn btn-outline btn-sm"
                @click="selectAllProducts"
                :disabled="
                  selectedProducts.length === availableProducts.length ||
                  availableProducts.length === 0
                "
              >
                <!-- icon: check --> Chọn hết
              </button>
              <button
                class="btn btn-outline btn-sm"
                @click="clearAllProducts"
                :disabled="selectedProducts.length === 0"
              >
                <!-- icon: close --> Bỏ chọn hết
              </button>
            </div>

            <div class="product-list">
              <!-- Products already in current campaign -->
              <div
                v-if="currentCampaignProducts.length > 0"
                class="product-section"
              >
                <h5 class="section-title current-campaign-title">
                  <!-- icon: refresh --> Sản phẩm đã áp dụng cho đợt này ({{
                    currentCampaignProducts.length
                  }})
                </h5>
                <div
                  v-for="product in currentCampaignProducts"
                  :key="'current-' + product.id"
                  class="product-item current-campaign-product"
                  @click="toggleProductSelection(product.id)"
                >
                  <input
                    type="checkbox"
                    :checked="selectedProducts.includes(product.id)"
                    @click.stop="toggleProductSelection(product.id)"
                  />
                  <div class="product-info">
                    <div class="product-name">{{ product.tenSanPham }}</div>
                    <div class="product-details">
                      <div class="details-grid">
                        <div class="detail-column">
                          <div class="detail-row">
                            <span class="detail-label">Màu sắc:</span>
                            <span class="detail-value">{{
                              product.tenMauSac
                            }}</span>
                          </div>
                          <div class="detail-row">
                            <span class="detail-label">Kích thước:</span>
                            <span class="detail-value">{{
                              product.tenKichThuoc
                            }}</span>
                          </div>
                        </div>
                        <div class="detail-column">
                          <div class="detail-row">
                            <span class="detail-label">Trạng thái:</span>
                            <span class="detail-value current-campaign"
                              >Đã áp dụng</span
                            >
                          </div>
                          <div class="detail-row" v-if="getProductActiveCampaigns(product.id).length > 1">
                            <span class="detail-label">Tham gia:</span>
                            <span class="detail-value multiple-campaigns">
                              {{ getProductActiveCampaigns(product.id).length }} đợt
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="product-price">
                      {{
                        new Intl.NumberFormat("vi-VN").format(product.giaBan)
                      }}
                      VNĐ
                    </div>
                  </div>
                </div>
              </div>

              <!-- Available Products -->
              <div
                v-if="availableProducts.length > currentCampaignProducts.length"
                class="product-section"
              >
                <h5 class="section-title available-title">
                  <!-- icon: check --> Sản phẩm có thể áp dụng ({{
                    availableProducts.length - currentCampaignProducts.length
                  }})
                </h5>
                <div
                  v-for="product in availableProducts.filter(
                    (p) => !getProductCurrentCampaignStatus(p.id)
                  )"
                  :key="product.id"
                  class="product-item available-product"
                  @click="toggleProductSelection(product.id)"
                >
                  <input
                    type="checkbox"
                    :checked="selectedProducts.includes(product.id)"
                    @click.stop="toggleProductSelection(product.id)"
                  />
                  <div class="product-info">
                    <div class="product-name">{{ product.tenSanPham }}</div>
                    <div class="product-details">
                      <div class="details-grid">
                        <div class="detail-column">
                          <div class="detail-row">
                            <span class="detail-label">Màu sắc:</span>
                            <span class="detail-value">{{
                              product.tenMauSac
                            }}</span>
                          </div>
                          <div class="detail-row">
                            <span class="detail-label">Kích thước:</span>
                            <span class="detail-value">{{
                              product.tenKichThuoc
                            }}</span>
                          </div>
                          <div class="detail-row" v-if="product.tenChatLieu">
                            <span class="detail-label">Chất liệu:</span>
                            <span class="detail-value">{{
                              product.tenChatLieu
                            }}</span>
                          </div>
                          <div class="detail-row" v-if="product.tenDoBen">
                            <span class="detail-label">Độ bền:</span>
                            <span class="detail-value">{{
                              product.tenDoBen
                            }}</span>
                          </div>
                          <div class="detail-row" v-if="product.tenTrongLuong">
                            <span class="detail-label">Trọng lượng:</span>
                            <span class="detail-value">{{
                              product.tenTrongLuong
                            }}</span>
                          </div>
                        </div>

                        <div class="detail-column">
                          <div class="detail-row" v-if="product.tenDeGiay">
                            <span class="detail-label">Đế giày:</span>
                            <span class="detail-value">{{
                              product.tenDeGiay
                            }}</span>
                          </div>
                          <div class="detail-row" v-if="product.tenDemGiay">
                            <span class="detail-label">Đệm giày:</span>
                            <span class="detail-value">{{
                              product.tenDemGiay
                            }}</span>
                          </div>
                          <div class="detail-row" v-if="product.tenLoaiMua">
                            <span class="detail-label">Loại mùa:</span>
                            <span class="detail-value">{{
                              product.tenLoaiMua
                            }}</span>
                          </div>
                          <div class="detail-row" v-if="product.tenMonTheThao">
                            <span class="detail-label">Môn thể thao:</span>
                            <span class="detail-value">{{
                              product.tenMonTheThao
                            }}</span>
                          </div>
                          <div class="detail-row" v-if="product.tenChongNuoc">
                            <span class="detail-label">Chống nước:</span>
                            <span class="detail-value">{{
                              product.tenChongNuoc
                            }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="product-price">
                      {{
                        new Intl.NumberFormat("vi-VN").format(product.giaBan)
                      }}
                      VNĐ
                    </div>
                  </div>
                </div>
              </div>

              <!-- Products with existing discount from higher value campaigns -->
              <div
                v-if="productsWithDiscount.length > 0"
                class="product-section"
              >
                <h5 class="section-title unavailable-title">
                  <!-- icon: close --> Sản phẩm có giảm giá cao hơn ({{ productsWithDiscount.length }})
                </h5>
                <div
                  v-for="product in productsWithDiscount"
                  :key="product.id"
                  class="product-item unavailable-product"
                >
                  <input type="checkbox" disabled class="disabled-checkbox" />
                  <div class="product-info">
                    <div class="product-name disabled-text">
                      {{ product.tenSanPham }}
                    </div>
                    <div class="product-details">
                      <div class="details-grid">
                        <div class="detail-column">
                          <div class="detail-row">
                            <span class="detail-label">Màu sắc:</span>
                            <span class="detail-value">{{
                              product.tenMauSac
                            }}</span>
                          </div>
                          <div class="detail-row">
                            <span class="detail-label">Kích thước:</span>
                            <span class="detail-value">{{
                              product.tenKichThuoc
                            }}</span>
                          </div>
                        </div>
                        <div class="detail-column">
                          <div class="detail-row">
                            <span class="detail-label">Trạng thái:</span>
                            <span class="detail-value discount-active"
                              >Có giảm giá cao hơn</span
                            >
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="product-price disabled-text">
                      {{
                        new Intl.NumberFormat("vi-VN").format(product.giaBan)
                      }}
                      VNĐ
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div
              v-if="
                availableProducts.length === 0 &&
                productsWithDiscount.length === 0 &&
                currentCampaignProducts.length === 0
              "
              class="empty-products"
            >
              <p>Không có sản phẩm nào</p>
            </div>

            <div
              v-if="
                availableProducts.length === currentCampaignProducts.length &&
                productsWithDiscount.length > 0
              "
              class="empty-available"
            >
              <p class="warning-text">
                <!-- icon: warning --> Các sản phẩm còn lại đều có đợt giảm giá với giá trị cao hơn
              </p>
            </div>
          </div>

          <div class="selection-summary">
            <div class="selected-count">
              Đã chọn: {{ selectedProducts.length }} sản phẩm
            </div>
            <div class="available-count">
              Có thể áp dụng: {{ availableProducts.length }} /
              {{ productsDetails.length }} sản phẩm
              <br />
              <small
                >Đã áp dụng: {{ currentCampaignProducts.length }} | Có giảm giá cao hơn:
                {{ productsWithDiscount.length }}</small
              >
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeApplyModal">
            Hủy
          </button>
          <button class="btn btn-primary" @click="applyDiscountToCampaign">
            Xác nhận áp dụng
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
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
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
const editingCampaign = ref(null);
const selectedCampaign = ref(null);
const applyingCampaign = ref(null);
const selectedProducts = ref([]);
const deleteCampaignData = ref(null);

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
      const now = new Date();
      filtered = filtered.filter((campaign) => {
        const endDate = new Date(campaign.ngayKetThuc);
        return endDate < now;
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
      const now = new Date();
      filtered = filtered.filter((campaign) => {
        const endDate = new Date(campaign.ngayKetThuc);
        return endDate < now;
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
    }
  }
);

// Validate and auto-update campaign status based on dates
const validateCampaignStatus = (campaign) => {
  const now = new Date();
  const startDate = new Date(campaign.ngayBatDau);
  const endDate = new Date(campaign.ngayKetThuc);

  // If current date is not within campaign period, set status to false
  if (!(now >= startDate && now <= endDate)) {
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
  const now = new Date();
  const endedCampaigns = campaigns.value.filter(campaign => {
    const endDate = new Date(campaign.ngayKetThuc);
    return endDate < now && campaign.trangThai;
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

    // Auto-validate status based on dates before saving
    const now = new Date();
    const startDate = new Date(formData.value.ngayBatDau);
    const endDate = new Date(formData.value.ngayKetThuc);

    // If current date is not within campaign period, force status to false
    if (!(now >= startDate && now <= endDate)) {
      formData.value.trangThai = false;
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
    title: "Thành công! <!-- icon: celebration -->",
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
  width: 140px;
  min-width: 120px;
}

.table th:nth-child(6) { /* Trạng thái */
  width: 140px;
  min-width: 120px;
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
  width: 140px;
  min-width: 120px;
}

.table td:nth-child(6) { /* Trạng thái */
  width: 140px;
  min-width: 120px;
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

.modal-content {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  animation: modalSlideIn 0.3s ease-out;
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

.modal-body {
  padding: 1.5rem;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 1.5rem;
  border-top: 1px solid var(--border-color);
  background: #ffffff;
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

/* Apply Modal Styles */
.apply-modal {
  max-width: 800px;
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
  font-size: 0.875rem;
  font-weight: 600;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  text-align: center;
  font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', sans-serif;
}

.status-active {
  background: #d1fae5;
  color: #065f46;
  border: 1px solid #a7f3d0;
}

.status-inactive {
  background: #fef3c7;
  color: #92400e;
  border: 1px solid #fde68a;
}

.status-deleted {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
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
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  padding: 2rem;
  text-align: center;
  border-radius: 12px 12px 0 0;
  position: relative;
}

.delete-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1rem auto;
}

.delete-header h3 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
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
</style>
