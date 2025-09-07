<template>
  <div class="comments-page">
    <!-- Page Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Quản lý Bình luận</h1>
          <p class="page-subtitle">Kiểm duyệt và quản lý bình luận từ khách hàng</p>
        </div>
        <div class="header-actions">
          <button class="btn-refresh" @click="refreshData">
            <span class="btn-icon"><!-- icon: refresh --></span>
            Làm mới
          </button>
          <button class="btn-export" @click="exportComments">
            <span class="btn-icon"><!-- icon: chart --></span>
            Xuất báo cáo
          </button>
          <button class="btn-export" @click="exportCommentsToExcel">
            <span class="btn-icon"><!-- icon: excel --></span>
            Xuất Excel
          </button>
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="stats-grid">
      <div class="stat-card total-stat">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9,22A1,1 0 0,1 8,21V18H4A2,2 0 0,1 2,16V4C2,2.89 2.9,2 4,2H20A2,2 0 0,1 22,4V16A2,2 0 0,1 20,18H13.9L10.2,21.71C10,21.9 9.75,22 9.5,22H9Z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ totalComments.toLocaleString() }}</div>
          <div class="stat-label">Tổng bình luận</div>
        </div>
      </div>

      <div class="stat-card pending-stat">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M16.2,16.2L11,13V7H12.5V12.2L17,14.7L16.2,16.2Z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ pendingComments.toLocaleString() }}</div>
          <div class="stat-label">Chờ duyệt</div>
        </div>
      </div>

      <div class="stat-card approved-stat">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ approvedComments.toLocaleString() }}</div>
          <div class="stat-label">Đã duyệt</div>
        </div>
      </div>

      <div class="stat-card rejected-stat">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ rejectedComments.toLocaleString() }}</div>
          <div class="stat-label">Đã từ chối</div>
        </div>
      </div>
    </div>

    <!-- Filters Section -->
    <div class="filters-section">
      <div class="filters-header">
        <h3>Bộ lọc tìm kiếm</h3>
        <button class="clear-filters-btn" @click="clearAllFilters">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
          </svg>
          Xóa bộ lọc
        </button>
      </div>
      
      <div class="filters-grid">
        <div class="filter-group">
          <label>Tìm kiếm</label>
          <div class="search-input-container">
            <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z"/>
            </svg>
            <input 
              type="text" 
              placeholder="Tìm theo sản phẩm, người dùng, nội dung..." 
              v-model="searchQuery"
              class="search-input"
            />
          </div>
        </div>

        <div class="filter-group">
          <label>Sản phẩm</label>
          <select v-model="selectedProduct" class="filter-select">
            <option value="">Tất cả sản phẩm</option>
            <option v-for="product in availableProducts" :key="product.id" :value="product.id">
              {{ product.ten_san_pham }}
            </option>
          </select>
        </div>

        <div class="filter-group">
          <label>Trạng thái</label>
          <select v-model="selectedStatus" class="filter-select">
            <option value="">Tất cả trạng thái</option>
            <option value="pending">Chờ duyệt</option>
            <option value="approved">Đã duyệt</option>
            <option value="rejected">Đã từ chối</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Từ ngày</label>
          <input type="date" v-model="fromDate" class="filter-input">
        </div>

        <div class="filter-group">
          <label>Đến ngày</label>
          <input type="date" v-model="toDate" class="filter-input">
        </div>
      </div>
    </div>

    <!-- Bulk Actions -->
    <div v-if="selectedComments.length > 0" class="bulk-actions-card">
      <div class="bulk-info">
        <div class="selected-count">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M10,17L5,12L6.41,10.59L10,14.17L17.59,6.58L19,8L10,17Z"/>
          </svg>
          Đã chọn {{ selectedComments.length }} bình luận
        </div>
      </div>
      <div class="bulk-actions">
        <button class="bulk-btn approve" @click="bulkApprove">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
          </svg>
          Duyệt hàng loạt
        </button>
        <button class="bulk-btn reject" @click="bulkReject">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
          </svg>
          Từ chối hàng loạt
        </button>
        <button class="bulk-btn clear" @click="clearSelection">
          Bỏ chọn
        </button>
      </div>
    </div>

    <!-- Comments List -->
    <div class="comments-section">
      <div class="section-header">
        <h3>Danh sách bình luận ({{ filteredComments.length }})</h3>
        <div class="view-toggle">
          <button 
            class="toggle-btn" 
            :class="{ active: viewMode === 'card' }" 
            @click="viewMode = 'card'"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M3,5A2,2 0 0,1 5,3H19A2,2 0 0,1 21,5V19A2,2 0 0,1 19,21H5C3.89,21 3,20.1 3,19V5Z"/>
            </svg>
            Thẻ
          </button>
          <button 
            class="toggle-btn" 
            :class="{ active: viewMode === 'table' }" 
            @click="viewMode = 'table'"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M3,5V19H21V5M7,7V9H5V7M5,13V11H7V13M5,15H7V17H5M19,17H9V15H19M19,13H9V11H19M19,9H9V7H19Z"/>
            </svg>
            Bảng
          </button>
        </div>
      </div>

      <!-- Card View -->
      <div v-if="viewMode === 'card'" class="comments-grid">
        <div v-for="comment in paginatedComments" :key="comment.id" class="comment-card">
          <div class="card-header">
            <div class="comment-select">
              <input 
                type="checkbox" 
                :value="comment.id" 
                v-model="selectedComments"
                class="comment-checkbox"
              />
            </div>
            <div class="comment-status">
              <span :class="['status-badge', getStatusClass(comment.trang_thai)]">
                {{ getStatusText(comment.trang_thai) }}
              </span>
            </div>
          </div>

          <div class="card-content">
            <div class="product-section">
              <div class="product-image">
                <img :src="comment.san_pham.hinh_anh" :alt="comment.san_pham.ten_san_pham" />
              </div>
              <div class="product-info">
                <h4>{{ comment.san_pham.ten_san_pham }}</h4>
                <p class="product-brand">{{ comment.san_pham.thuong_hieu }}</p>
                <p class="product-price">{{ formatCurrency(comment.san_pham.gia_ban) }}</p>
              </div>
            </div>

            <div class="user-section">
              <div class="user-avatar">
                {{ comment.nguoi_dung.ho_ten.charAt(0) }}
              </div>
              <div class="user-info">
                <h5>{{ comment.nguoi_dung.ho_ten }}</h5>
                <p>{{ comment.nguoi_dung.email }}</p>
              </div>
            </div>

            <div class="comment-section">
              <p class="comment-text">{{ comment.noi_dung }}</p>
              <div class="comment-meta">
                <span class="comment-date">{{ formatDateTime(comment.ngay_binh_luan) }}</span>
              </div>
            </div>
          </div>

          <div class="card-actions">
            <button class="action-btn small primary" @click="viewComment(comment)">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9M12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17M12,4.5C7,4.5 2.73,7.61 1,12C2.73,16.39 7,19.5 12,19.5C17,19.5 21.27,16.39 23,12C21.27,7.61 17,4.5 12,4.5Z"/>
              </svg>
              Xem
            </button>
            <button 
              v-if="comment.trang_thai === null" 
              class="action-btn small success" 
              @click="approveComment(comment)"
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
              </svg>
              Duyệt
            </button>
            <button 
              v-if="comment.trang_thai === null" 
              class="action-btn small danger" 
              @click="rejectComment(comment)"
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
              </svg>
              Từ chối
            </button>
          </div>
        </div>
      </div>

      <!-- Table View -->
      <div v-else class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th class="checkbox-col">
                <input 
                  type="checkbox" 
                  :checked="selectAll" 
                  @change="toggleSelectAll"
                  class="table-checkbox"
                />
              </th>
              <th>Sản phẩm</th>
              <th>Người dùng</th>
              <th>Nội dung</th>
              <th>Ngày</th>
              <th>Trạng thái</th>
              <th class="actions-col">Hành động</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="comment in paginatedComments" :key="comment.id">
              <td class="checkbox-col">
                <input 
                  type="checkbox" 
                  :value="comment.id" 
                  v-model="selectedComments"
                  class="table-checkbox"
                />
              </td>
              <td>
                <div class="table-product">
                  <img :src="comment.san_pham.hinh_anh" :alt="comment.san_pham.ten_san_pham" />
                  <div>
                    <div class="product-name">{{ comment.san_pham.ten_san_pham }}</div>
                    <div class="product-brand">{{ comment.san_pham.thuong_hieu }}</div>
                  </div>
                </div>
              </td>
              <td>
                <div class="table-user">
                  <div class="user-name">{{ comment.nguoi_dung.ho_ten }}</div>
                  <div class="user-email">{{ comment.nguoi_dung.email }}</div>
                </div>
              </td>
              <td>
                <div class="table-comment">
                  <p>{{ truncateText(comment.noi_dung, 100) }}</p>
                  <button 
                    v-if="comment.noi_dung.length > 100" 
                    class="read-more-btn" 
                    @click="viewComment(comment)"
                  >
                    Xem thêm
                  </button>
                </div>
              </td>
              <td class="date-col">{{ formatDateTime(comment.ngay_binh_luan) }}</td>
              <td>
                <span :class="['status-badge', getStatusClass(comment.trang_thai)]">
                  {{ getStatusText(comment.trang_thai) }}
                </span>
              </td>
              <td class="actions-col">
                <div class="table-actions">
                  <button class="action-btn small primary" @click="viewComment(comment)">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9M12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17M12,4.5C7,4.5 2.73,7.61 1,12C2.73,16.39 7,19.5 12,19.5C17,19.5 21.27,16.39 23,12C21.27,7.61 17,4.5 12,4.5Z"/>
                    </svg>
                  </button>
                  <button 
                    v-if="comment.trang_thai === null" 
                    class="action-btn small success" 
                    @click="approveComment(comment)"
                  >
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                    </svg>
                  </button>
                  <button 
                    v-if="comment.trang_thai === null" 
                    class="action-btn small danger" 
                    @click="rejectComment(comment)"
                  >
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div v-if="totalPages > 1" class="pagination-container">
        <div class="pagination-info">
          Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của {{ filteredComments.length }} bình luận
        </div>
        <div class="pagination-controls">
          <button 
            class="pagination-btn" 
            @click="previousPage" 
            :disabled="currentPage === 1"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M15.41,16.58L10.83,12L15.41,7.41L14,6L8,12L14,18L15.41,16.58Z"/>
            </svg>
          </button>
          <span class="page-numbers">
            <button 
              v-for="page in pageNumbers" 
              :key="page" 
              class="page-btn" 
              :class="{ active: page === currentPage }"
              @click="goToPage(page)"
            >
              {{ page }}
            </button>
          </span>
          <button 
            class="pagination-btn" 
            @click="nextPage" 
            :disabled="currentPage === totalPages"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z"/>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Comment Details Modal -->
    <div v-if="showDetailsModal" class="modal-overlay" @click="closeModal">
      <div class="modal-container" @click.stop>
        <div class="modal-header">
          <h2>Chi tiết bình luận</h2>
          <button class="modal-close" @click="closeModal">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
            </svg>
          </button>
        </div>
        
        <div class="modal-content" v-if="selectedComment">
          <div class="modal-section">
            <div class="section-title">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M2,6H22V8H2V6M2,11H15V13H2V11M2,16H13V18H2V16Z"/>
              </svg>
              Thông tin sản phẩm
            </div>
            <div class="product-detail-card">
              <img :src="selectedComment.san_pham.hinh_anh" :alt="selectedComment.san_pham.ten_san_pham" class="detail-product-image">
              <div class="product-detail-info">
                <h3>{{ selectedComment.san_pham.ten_san_pham }}</h3>
                <p class="brand">{{ selectedComment.san_pham.thuong_hieu }}</p>
                <p class="price">{{ formatCurrency(selectedComment.san_pham.gia_ban) }}</p>
              </div>
            </div>
          </div>

          <div class="modal-section">
            <div class="section-title">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z"/>
              </svg>
              Thông tin người dùng
            </div>
            <div class="user-detail-grid">
              <div class="detail-item">
                <label>Họ tên:</label>
                <span>{{ selectedComment.nguoi_dung.ho_ten }}</span>
              </div>
              <div class="detail-item">
                <label>Email:</label>
                <span>{{ selectedComment.nguoi_dung.email }}</span>
              </div>
              <div class="detail-item">
                <label>Số điện thoại:</label>
                <span>{{ selectedComment.nguoi_dung.sdt }}</span>
              </div>
              <div class="detail-item">
                <label>Ngày bình luận:</label>
                <span>{{ formatDateTime(selectedComment.ngay_binh_luan) }}</span>
              </div>
            </div>
          </div>

          <div class="modal-section">
            <div class="section-title">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M9,22A1,1 0 0,1 8,21V18H4A2,2 0 0,1 2,16V4C2,2.89 2.9,2 4,2H20A2,2 0 0,1 22,4V16A2,2 0 0,1 20,18H13.9L10.2,21.71C10,21.9 9.75,22 9.5,22H9Z"/>
              </svg>
              Nội dung bình luận
            </div>
            <div class="comment-detail-content">
              <p>{{ selectedComment.noi_dung }}</p>
            </div>
            <div class="comment-status-section">
              <label>Trạng thái hiện tại:</label>
              <span :class="['status-badge', getStatusClass(selectedComment.trang_thai)]">
                {{ getStatusText(selectedComment.trang_thai) }}
              </span>
            </div>
          </div>
        </div>

        <div class="modal-actions">
          <button 
            v-if="selectedComment?.trang_thai === null" 
            class="action-btn success" 
            @click="approveComment(selectedComment)"
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
              <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
            </svg>
            Duyệt bình luận
          </button>
          <button 
            v-if="selectedComment?.trang_thai === null" 
            class="action-btn danger" 
            @click="rejectComment(selectedComment)"
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
            </svg>
            Từ chối bình luận
          </button>
          <button class="action-btn secondary" @click="closeModal">
            Đóng
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { exportToExcel, formatDataForExcel } from '../../utils/xuatExcel.js'

// Reactive data
const searchQuery = ref('')
const selectedProduct = ref('')
const selectedStatus = ref('')
const fromDate = ref('')
const toDate = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(12)
const showDetailsModal = ref(false)
const selectedComment = ref(null)
const selectedComments = ref([])
const viewMode = ref('card')

// Available products for filtering
const availableProducts = ref([])

// Mock data - ERD compliant
const comments = ref([])

// Computed properties
const filteredComments = computed(() => {
  let filtered = comments.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(comment => 
      comment.san_pham.ten_san_pham.toLowerCase().includes(query) ||
      comment.nguoi_dung.ho_ten.toLowerCase().includes(query) ||
      comment.noi_dung.toLowerCase().includes(query) ||
      comment.nguoi_dung.email.toLowerCase().includes(query)
    )
  }

  if (selectedProduct.value) {
    filtered = filtered.filter(comment => comment.id_san_pham === parseInt(selectedProduct.value))
  }

  if (selectedStatus.value) {
    if (selectedStatus.value === 'pending') {
      filtered = filtered.filter(comment => comment.trang_thai === null)
    } else if (selectedStatus.value === 'approved') {
      filtered = filtered.filter(comment => comment.trang_thai === true)
    } else if (selectedStatus.value === 'rejected') {
      filtered = filtered.filter(comment => comment.trang_thai === false)
    }
  }

  if (fromDate.value) {
    filtered = filtered.filter(comment => 
      new Date(comment.ngay_binh_luan) >= new Date(fromDate.value)
    )
  }

  if (toDate.value) {
    filtered = filtered.filter(comment => 
      new Date(comment.ngay_binh_luan) <= new Date(toDate.value + 'T23:59:59')
    )
  }

  return filtered
})

const totalComments = computed(() => comments.value.length)
const pendingComments = computed(() => comments.value.filter(c => c.trang_thai === null).length)
const approvedComments = computed(() => comments.value.filter(c => c.trang_thai === true).length)
const rejectedComments = computed(() => comments.value.filter(c => c.trang_thai === false).length)

const totalPages = computed(() => Math.ceil(filteredComments.value.length / itemsPerPage.value))
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => Math.min(startIndex.value + itemsPerPage.value, filteredComments.value.length))

const paginatedComments = computed(() => {
  return filteredComments.value.slice(startIndex.value, endIndex.value)
})

const pageNumbers = computed(() => {
  const pages = []
  const maxVisible = 5
  const start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  const end = Math.min(totalPages.value, start + maxVisible - 1)
  
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  return pages
})

const selectAll = computed({
  get: () => paginatedComments.value.length > 0 && selectedComments.value.length === paginatedComments.value.length,
  set: (value) => {
    if (value) {
      selectedComments.value = paginatedComments.value.map(comment => comment.id)
    } else {
      selectedComments.value = []
    }
  }
})

// Methods
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('vi-VN', { 
    style: 'currency', 
    currency: 'VND' 
  }).format(amount)
}

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString('vi-VN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const truncateText = (text, maxLength) => {
  if (text.length <= maxLength) return text
  return text.slice(0, maxLength) + '...'
}

const getStatusClass = (status) => {
  if (status === true) return 'approved'
  if (status === false) return 'rejected'
  return 'pending'
}

const getStatusText = (status) => {
  if (status === true) return 'Đã duyệt'
  if (status === false) return 'Đã từ chối'
  return 'Chờ duyệt'
}

const clearAllFilters = () => {
  searchQuery.value = ''
  selectedProduct.value = ''
  selectedStatus.value = ''
  fromDate.value = ''
  toDate.value = ''
  currentPage.value = 1
}

const toggleSelectAll = () => {
  selectAll.value = !selectAll.value
}

const clearSelection = () => {
  selectedComments.value = []
}

const viewComment = (comment) => {
  selectedComment.value = comment
  showDetailsModal.value = true
}

const closeModal = () => {
  showDetailsModal.value = false
  selectedComment.value = null
}

const approveComment = (comment) => {
  comment.trang_thai = true
  if (showDetailsModal.value) {
    closeModal()
  }
  // Simulate API call
  setTimeout(() => {
    alert(`Đã duyệt bình luận của ${comment.nguoi_dung.ho_ten}`)
  }, 100)
}

const rejectComment = (comment) => {
  if (confirm(`Bạn có chắc chắn muốn từ chối bình luận của ${comment.nguoi_dung.ho_ten}?`)) {
    comment.trang_thai = false
    if (showDetailsModal.value) {
      closeModal()
    }
    // Simulate API call
    setTimeout(() => {
      alert(`Đã từ chối bình luận của ${comment.nguoi_dung.ho_ten}`)
    }, 100)
  }
}

const bulkApprove = () => {
  if (confirm(`Bạn có chắc chắn muốn duyệt ${selectedComments.value.length} bình luận đã chọn?`)) {
    selectedComments.value.forEach(commentId => {
      const comment = comments.value.find(c => c.id === commentId)
      if (comment) {
        comment.trang_thai = true
      }
    })
    alert(`Đã duyệt ${selectedComments.value.length} bình luận`)
    selectedComments.value = []
  }
}

const bulkReject = () => {
  if (confirm(`Bạn có chắc chắn muốn từ chối ${selectedComments.value.length} bình luận đã chọn?`)) {
    selectedComments.value.forEach(commentId => {
      const comment = comments.value.find(c => c.id === commentId)
      if (comment) {
        comment.trang_thai = false
      }
    })
    alert(`Đã từ chối ${selectedComments.value.length} bình luận`)
    selectedComments.value = []
  }
}

const exportComments = () => {
  alert('Xuất báo cáo bình luận')
  // Implementation for exporting comments
}

const exportCommentsToExcel = () => {
  try {
    
    // Simple test data first
    const testData = [
      { 'ID': 1, 'Tên': 'Test 1', 'Trạng thái': 'Hoạt động' },
      { 'ID': 2, 'Tên': 'Test 2', 'Trạng thái': 'Không hoạt động' }
    ]
    
    
    // Test with simple data first
    const result = exportToExcel(
      testData,
      'Test_Export',
      'Test Sheet'
    )
    
    
    if (result.success) {
      alert(`<!-- icon: check --> ${result.message}`)
    } else {
      alert(`<!-- icon: close --> ${result.message}`)
    }
  } catch (error) {
    console.error('Error in exportCommentsToExcel:', error)
    alert(`<!-- icon: close --> Có lỗi xảy ra khi xuất file Excel: ${error.message}`)
  }
}

const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
  }
}

const goToPage = (page) => {
  currentPage.value = page
}

const refreshData = () => {
  // Simulate data refresh
}

onMounted(() => {
  // Set default date range to last 30 days
  const today = new Date()
  const thirtyDaysAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000)
  fromDate.value = thirtyDaysAgo.toISOString().split('T')[0]
  toDate.value = today.toISOString().split('T')[0]
})
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/quanLyBinhLuan.css';
</style>
