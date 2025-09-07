<template>
  <div class="price-history-management">
    <!-- Page Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Quản lý Lịch sử Giá</h1>
          <p class="page-subtitle">Theo dõi và phân tích biến động giá sản phẩm</p>
        </div>
        <div class="header-actions">
          <button class="btn-refresh" @click="refreshData">
            <span class="btn-icon"><!-- icon: refresh --></span>
            Làm mới
          </button>
          <button class="btn-export" @click="exportData">
            <span class="btn-icon"><!-- icon: chart --></span>
            Xuất báo cáo
          </button>
          <button class="btn-export" @click="exportToExcel">
            <span class="btn-icon"><!-- icon: excel --></span>
            Xuất Excel
          </button>
        </div>
      </div>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-cards">
      <div class="stats-card">
        <div class="stats-icon"><!-- icon: note --></div>
        <div class="stats-content">
          <div class="stats-number">{{ totalPriceChanges }}</div>
          <div class="stats-label">Lần thay đổi giá</div>
        </div>
      </div>
      <div class="stats-card">
        <div class="stats-icon"><!-- icon: chart-up --></div>
        <div class="stats-content">
          <div class="stats-number">{{ priceIncreases }}</div>
          <div class="stats-label">Lần tăng giá</div>
        </div>
      </div>
      <div class="stats-card">
        <div class="stats-icon"><!-- icon: chart-down --></div>
        <div class="stats-content">
          <div class="stats-number">{{ priceDecreases }}</div>
          <div class="stats-label">Lần giảm giá</div>
        </div>
      </div>
      <div class="stats-card">
        <div class="stats-icon"><!-- icon: money --></div>
        <div class="stats-content">
          <div class="stats-number">{{ formatCurrency(avgPriceChange) }}</div>
          <div class="stats-label">Biến động TB</div>
        </div>
      </div>
    </div>

    <!-- Modern Filter Section -->
    <div class="filter-section">
      <div class="filter-card">
        <div class="filter-header">
          <div class="filter-title">
            <span class="filter-icon"><!-- icon: chart --></span>
            <h3>Tìm kiếm lịch sử giá</h3>
          </div>
          <div class="filter-stats">
            {{ filteredHistory.length }} / {{ priceHistory.length }} bản ghi
          </div>
        </div>
        
        <div class="filter-content">
          <div class="search-section">
            <div class="input-group">
              <span class="input-icon"><!-- icon: search --></span>
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Tìm kiếm theo sản phẩm hoặc người thay đổi..."
                class="form-control search-input"
              />
              <button v-if="searchQuery" @click="searchQuery = ''" class="clear-btn">
                <span>✕</span>
              </button>
            </div>
          </div>
          
          <div class="filters-grid">
            <div class="filter-group">
              <label class="filter-label">
                <span class="label-icon"><!-- icon: package --></span>
                Sản phẩm
              </label>
              <select v-model="selectedProduct" class="form-select">
                <option value="">Tất cả sản phẩm</option>
                <option v-for="product in availableProducts" :key="product.id" :value="product.id">
                  {{ product.ten_san_pham }}
                </option>
              </select>
            </div>
            
            <div class="filter-group">
              <label class="filter-label">
                <span class="label-icon"><!-- icon: user --></span>
                Người thay đổi
              </label>
              <select v-model="selectedUser" class="form-select">
                <option value="">Tất cả người thay đổi</option>
            <option v-for="user in availableUsers" :key="user.id" :value="user.id">
              {{ user.ho_ten }}
            </option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">
                <span class="label-icon"><!-- icon: chart-up --></span>
                Loại thay đổi
              </label>
              <select v-model="changeType" class="form-select">
                <option value="">Tất cả loại</option>
                <option value="increase"><!-- icon: chart-up --> Tăng giá</option>
                <option value="decrease"><!-- icon: chart-down --> Giảm giá</option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">
                <span class="label-icon"><!-- icon: calendar --></span>
                Từ ngày
              </label>
              <input type="date" v-model="fromDate" class="form-control date-input">
            </div>

            <div class="filter-group">
              <label class="filter-label">
                <span class="label-icon"><!-- icon: calendar --></span>
                Đến ngày
              </label>
              <input type="date" v-model="toDate" class="form-control date-input">
            </div>
            
            <div class="filter-actions">
              <button @click="clearFilters" class="btn btn-outline">
                <span class="btn-icon"><!-- icon: refresh --></span>
                Đặt lại
              </button>
              <button @click="applyFilters" class="btn btn-primary">
                <span class="btn-icon"><!-- icon: search --></span>
                Áp dụng
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- View Toggle -->
    <div class="view-controls">
      <div class="view-toggle">
        <button 
          :class="['toggle-btn', { active: viewMode === 'list' }]"
          @click="viewMode = 'list'"
        >
          <!-- icon: clipboard --> Danh sách
        </button>
        <button 
          :class="['toggle-btn', { active: viewMode === 'chart' }]"
          @click="viewMode = 'chart'"
        >
          <!-- icon: chart --> Biểu đồ
        </button>
      </div>
    </div>

    <!-- List View -->
    <div v-if="viewMode === 'list'" class="card">
      <div class="card-body">
        <table class="table">
          <thead>
            <tr>
              <th>#</th>
              <th>Sản phẩm</th>
              <th>Giá cũ</th>
              <th>Giá mới</th>
              <th>Biến động</th>
              <th>Lý do</th>
              <th>Người thay đổi</th>
              <th>Ngày thay đổi</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(history, index) in filteredPriceHistory" :key="history.id">
              <td>{{ index + 1 }}</td>
              <td>
                <div class="product-info">
                  <img :src="history.san_pham.hinh_anh" :alt="history.san_pham.ten_san_pham" class="product-image">
                  <div class="product-details">
                    <div class="product-name">{{ history.san_pham.ten_san_pham }}</div>
                    <div class="product-brand">{{ history.san_pham.thuong_hieu }}</div>
                  </div>
                </div>
              </td>
              <td>
                <span class="old-price">{{ formatCurrency(history.gia_cu) }}</span>
              </td>
              <td>
                <span class="new-price">{{ formatCurrency(history.gia_moi) }}</span>
              </td>
              <td>
                <div class="price-change" :class="getPriceChangeClass(history.gia_cu, history.gia_moi)">
                  <div class="change-amount">{{ formatPriceChange(history.gia_cu, history.gia_moi) }}</div>
                  <div class="change-percentage">{{ formatPercentageChange(history.gia_cu, history.gia_moi) }}</div>
                </div>
              </td>
              <td>
                <div class="reason-info">
                  <p>{{ history.ly_do || 'Không có' }}</p>
                </div>
              </td>
              <td>
                <div class="user-info">
                  <div class="user-name">{{ history.nguoi_thay_doi.ho_ten }}</div>
                  <div class="user-role">{{ history.nguoi_thay_doi.vai_tro }}</div>
                </div>
              </td>
              <td>
                <div class="date-info">
                  {{ formatDateTime(history.ngay_thay_doi) }}
                </div>
              </td>
              <td>
                <div class="action-buttons">
                  <button class="btn btn-sm btn-primary" @click="viewDetails(history)">
                    <!-- icon: view --> Chi tiết
                  </button>
                  <button class="btn btn-sm btn-info" @click="viewPriceChart(history.san_pham)">
                    <!-- icon: chart --> Biểu đồ
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- Pagination -->
        <div class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của {{ totalFilteredHistory }} bản ghi
          </div>
          <div class="pagination">
            <button 
              class="btn btn-outline btn-sm" 
              @click="previousPage" 
              :disabled="currentPage === 1"
            >
              ❮ Trước
            </button>
            <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
            <button 
              class="btn btn-outline btn-sm" 
              @click="nextPage" 
              :disabled="currentPage === totalPages"
            >
              Sau ❯
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Chart View -->
    <div v-if="viewMode === 'chart'" class="chart-section">
      <div class="chart-controls">
        <select v-model="selectedProductForChart" class="form-control">
          <option value="">Chọn sản phẩm để xem biểu đồ</option>
          <option v-for="product in availableProducts" :key="product.id" :value="product.id">
            {{ product.ten_san_pham }}
          </option>
        </select>
      </div>

      <div v-if="selectedProductForChart" class="price-chart-container">
        <div class="chart-header">
          <h4>Biểu đồ biến động giá: {{ getProductName(selectedProductForChart) }}</h4>
        </div>
        <div class="price-timeline">
          <div v-for="point in getProductPriceTimeline(selectedProductForChart)" :key="point.id" class="timeline-point">
            <div class="timeline-date">{{ formatDate(point.ngay_thay_doi) }}</div>
            <div class="timeline-connector"></div>
            <div class="timeline-content">
              <div class="price-change-info" :class="getPriceChangeClass(point.gia_cu, point.gia_moi)">
                <div class="change-prices">
                  <span class="from-price">{{ formatCurrency(point.gia_cu) }}</span>
                  <span class="arrow">→</span>
                  <span class="to-price">{{ formatCurrency(point.gia_moi) }}</span>
                </div>
                <div class="change-details">
                  <span class="change-amount">{{ formatPriceChange(point.gia_cu, point.gia_moi) }}</span>
                  <span class="change-percentage">{{ formatPercentageChange(point.gia_cu, point.gia_moi) }}</span>
                </div>
                <div class="change-reason">{{ point.ly_do || 'Không có lý do' }}</div>
                <div class="change-author">Bởi: {{ point.nguoi_thay_doi.ho_ten }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-else class="no-chart-selected">
        <div class="no-chart-icon"><!-- icon: chart --></div>
        <div class="no-chart-text">Chọn sản phẩm để xem biểu đồ biến động giá</div>
      </div>
    </div>

    <!-- Details Modal -->
    <div v-if="showDetailsModal" class="modal-overlay" @click="showDetailsModal = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Chi tiết thay đổi giá</h3>
          <button class="modal-close" @click="showDetailsModal = false">✕</button>
        </div>
        
        <div class="modal-body" v-if="selectedHistory">
          <div class="history-detail">
            <div class="detail-section">
              <h4>Thông tin sản phẩm</h4>
              <div class="product-detail">
                <img :src="selectedHistory.san_pham.hinh_anh" :alt="selectedHistory.san_pham.ten_san_pham" class="detail-product-image">
                <div class="product-detail-info">
                  <div class="product-name">{{ selectedHistory.san_pham.ten_san_pham }}</div>
                  <div class="product-brand">{{ selectedHistory.san_pham.thuong_hieu }}</div>
                  <div class="product-category">{{ selectedHistory.san_pham.danh_muc }}</div>
                </div>
              </div>
            </div>

            <div class="detail-section">
              <h4>Thông tin thay đổi giá</h4>
              <div class="price-change-detail">
                <div class="price-comparison">
                  <div class="price-item old">
                    <div class="price-label">Giá cũ</div>
                    <div class="price-value">{{ formatCurrency(selectedHistory.gia_cu) }}</div>
                  </div>
                  <div class="price-arrow">→</div>
                  <div class="price-item new">
                    <div class="price-label">Giá mới</div>
                    <div class="price-value">{{ formatCurrency(selectedHistory.gia_moi) }}</div>
                  </div>
                </div>
                <div class="change-summary" :class="getPriceChangeClass(selectedHistory.gia_cu, selectedHistory.gia_moi)">
                  <div class="change-amount">{{ formatPriceChange(selectedHistory.gia_cu, selectedHistory.gia_moi) }}</div>
                  <div class="change-percentage">{{ formatPercentageChange(selectedHistory.gia_cu, selectedHistory.gia_moi) }}</div>
                </div>
              </div>
            </div>

            <div class="detail-section">
              <h4>Thông tin khác</h4>
              <div class="info-grid">
                <div class="info-item">
                  <label>Người thay đổi:</label>
                  <span>{{ selectedHistory.nguoi_thay_doi.ho_ten }}</span>
                </div>
                <div class="info-item">
                  <label>Vai trò:</label>
                  <span>{{ selectedHistory.nguoi_thay_doi.vai_tro }}</span>
                </div>
                <div class="info-item">
                  <label>Ngày thay đổi:</label>
                  <span>{{ formatDateTime(selectedHistory.ngay_thay_doi) }}</span>
                </div>
                <div class="info-item">
                  <label>Lý do:</label>
                  <span>{{ selectedHistory.ly_do || 'Không có' }}</span>
                </div>
              </div>
            </div>

            <div class="modal-actions">
              <button class="btn btn-info" @click="viewProductHistory(selectedHistory.san_pham)">
                <!-- icon: chart --> Xem toàn bộ lịch sử
              </button>
              <button class="btn btn-secondary" @click="showDetailsModal = false">
                Đóng
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

// Data
const searchQuery = ref('')
const selectedProduct = ref('')
const selectedUser = ref('')
const changeType = ref('')
const fromDate = ref('')
const toDate = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(15)
const showDetailsModal = ref(false)
const selectedHistory = ref(null)
const viewMode = ref('list')
const selectedProductForChart = ref('')
const loading = ref(false)

// Available data for filtering
const availableProducts = ref([])

const availableUsers = ref([])

// Mock data - should match ERD lich_su_gia table
const priceHistory = ref([])

// Computed - Filtered data without pagination
const filteredHistory = computed(() => {
  let filtered = priceHistory.value

  if (searchQuery.value) {
    filtered = filtered.filter(history => 
      history.san_pham.ten_san_pham.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      history.nguoi_thay_doi.ho_ten.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }

  if (selectedProduct.value) {
    filtered = filtered.filter(history => history.id_san_pham === parseInt(selectedProduct.value))
  }

  if (selectedUser.value) {
    filtered = filtered.filter(history => history.nguoi_thay_doi_id === parseInt(selectedUser.value))
  }

  if (changeType.value) {
    if (changeType.value === 'increase') {
      filtered = filtered.filter(history => history.gia_moi > history.gia_cu)
    } else if (changeType.value === 'decrease') {
      filtered = filtered.filter(history => history.gia_moi < history.gia_cu)
    }
  }

  if (fromDate.value) {
    filtered = filtered.filter(history => 
      new Date(history.ngay_thay_doi) >= new Date(fromDate.value)
    )
  }

  if (toDate.value) {
    filtered = filtered.filter(history => 
      new Date(history.ngay_thay_doi) <= new Date(toDate.value + 'T23:59:59')
    )
  }

  // Sort by date descending
  return filtered.sort((a, b) => new Date(b.ngay_thay_doi) - new Date(a.ngay_thay_doi))
})

// Computed - Paginated filtered data
const filteredPriceHistory = computed(() => {
  return filteredHistory.value.slice(startIndex.value, endIndex.value)
})

const totalPriceChanges = computed(() => priceHistory.value.length)
const totalFilteredHistory = computed(() => filteredHistory.value.length)
const priceIncreases = computed(() => priceHistory.value.filter(h => h.gia_moi > h.gia_cu).length)
const priceDecreases = computed(() => priceHistory.value.filter(h => h.gia_moi < h.gia_cu).length)
const avgPriceChange = computed(() => {
  const total = priceHistory.value.reduce((sum, h) => sum + Math.abs(h.gia_moi - h.gia_cu), 0)
  return totalPriceChanges.value > 0 ? total / totalPriceChanges.value : 0
})

const totalPages = computed(() => Math.ceil(totalFilteredHistory.value / itemsPerPage.value))
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => Math.min(startIndex.value + itemsPerPage.value, totalFilteredHistory.value))

// Methods
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('vi-VN', { 
    style: 'currency', 
    currency: 'VND' 
  }).format(amount)
}

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString('vi-VN')
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('vi-VN')
}

const formatPriceChange = (oldPrice, newPrice) => {
  const change = newPrice - oldPrice
  const sign = change >= 0 ? '+' : ''
  return `${sign}${formatCurrency(change)}`
}

const formatPercentageChange = (oldPrice, newPrice) => {
  if (oldPrice === 0) return '0%'
  const percentage = ((newPrice - oldPrice) / oldPrice) * 100
  const sign = percentage >= 0 ? '+' : ''
  return `${sign}${percentage.toFixed(1)}%`
}

const getPriceChangeClass = (oldPrice, newPrice) => {
  if (newPrice > oldPrice) return 'price-increase'
  if (newPrice < oldPrice) return 'price-decrease'
  return 'price-neutral'
}

const getProductName = (productId) => {
  const product = availableProducts.value.find(p => p.id === parseInt(productId))
  return product ? product.ten_san_pham : ''
}

const getProductPriceTimeline = (productId) => {
  return priceHistory.value
    .filter(h => h.id_san_pham === parseInt(productId))
    .sort((a, b) => new Date(a.ngay_thay_doi) - new Date(b.ngay_thay_doi))
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

const viewDetails = (history) => {
  selectedHistory.value = history
  showDetailsModal.value = true
}

const viewPriceChart = (product) => {
  viewMode.value = 'chart'
  selectedProductForChart.value = product.id || product.id_san_pham
}

const viewProductHistory = (product) => {
  viewMode.value = 'chart'
  selectedProductForChart.value = product.id || product.id_san_pham
  showDetailsModal.value = false
}

const loadPriceHistory = async () => {
  // Simulate loading price history data
  return new Promise(resolve => setTimeout(resolve, 100))
}

const loadStatistics = async () => {
  // Simulate loading statistics data
  return new Promise(resolve => setTimeout(resolve, 100))
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([
      loadPriceHistory(),
      loadStatistics()
    ])
  } catch (error) {
    console.error('Error refreshing data:', error)
  } finally {
    loading.value = false
  }
}

const clearFilters = () => {
  searchQuery.value = ''
  selectedProduct.value = ''
  selectedUser.value = ''
  changeType.value = ''
  fromDate.value = ''
  toDate.value = ''
  currentPage.value = 1
}

const applyFilters = () => {
  // Filters are already applied through computed properties
  currentPage.value = 1
}

const exportToExcel = () => {
  // Export to Excel functionality
  const exportData = filteredHistory.value.map(item => ({
    'ID': item.id,
    'Tên sản phẩm': item.san_pham.ten_san_pham,
    'Giá cũ': formatCurrency(item.gia_cu),
    'Giá mới': formatCurrency(item.gia_moi),
    'Biến động': formatPriceChange(item.gia_cu, item.gia_moi),
    'Tỷ lệ': formatPercentageChange(item.gia_cu, item.gia_moi),
    'Người thay đổi': item.nguoi_thay_doi.ho_ten,
    'Ngày thay đổi': formatDateTime(item.ngay_thay_doi),
    'Lý do': item.ly_do || 'Không có'
  }))
  
  // In a real application, you would use a library like xlsx or sheetjs
  // For now, we'll just show an alert
  alert('Xuất Excel thành công! (Chức năng đang được phát triển)')
}

const exportData = () => {
  alert('Xuất báo cáo lịch sử giá')
}

onMounted(() => {
  // Set default date filter to last 30 days
  const today = new Date()
  const thirtyDaysAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000)
  fromDate.value = thirtyDaysAgo.toISOString().split('T')[0]
  toDate.value = today.toISOString().split('T')[0]
})
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/quanLyLichSuGia.css';
</style>
