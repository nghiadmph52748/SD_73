<template>
  <div class="favorites-page">
    <!-- Page Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Quản lý Sản phẩm Yêu thích</h1>
          <p class="page-subtitle">Phân tích sở thích khách hàng và xu hướng sản phẩm</p>
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

    <!-- Stats Cards -->
    <div class="stats-grid">
      <div class="stat-card favorites-stat">
        <div class="stat-icon">
          <svg fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ totalFavorites }}</div>
          <div class="stat-label">Tổng lượt yêu thích</div>
          <div class="stat-trend positive">+15% từ tháng trước</div>
        </div>
      </div>
      
      <div class="stat-card users-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ uniqueUsers }}</div>
          <div class="stat-label">Người dùng tích cực</div>
          <div class="stat-trend positive">+8% từ tuần trước</div>
        </div>
      </div>
      
      <div class="stat-card products-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ topProduct.count }}</div>
          <div class="stat-label">Lượt yêu thích cao nhất</div>
          <div class="stat-trend neutral">{{ topProduct.name }}</div>
        </div>
      </div>
      
      <div class="stat-card conversion-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ conversionRate }}%</div>
          <div class="stat-label">Tỷ lệ chuyển đổi</div>
          <div class="stat-trend positive">+3.2% từ tháng trước</div>
        </div>
      </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-card">
      <div class="filter-header">
        <h3>Bộ lọc & Tìm kiếm</h3>
        <div class="view-toggle">
          <button 
            :class="['toggle-btn', { active: viewMode === 'list' }]"
            @click="viewMode = 'list'"
          >
            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"></path>
            </svg>
            Danh sách
          </button>
          <button 
            :class="['toggle-btn', { active: viewMode === 'analytics' }]"
            @click="viewMode = 'analytics'"
          >
            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
            </svg>
            Phân tích
          </button>
        </div>
      </div>
      
      <div class="filter-grid">
        <div class="filter-group">
          <label>Tìm kiếm</label>
          <div class="search-wrapper">
            <svg class="search-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
            <input 
              type="text" 
              placeholder="Tìm theo khách hàng, sản phẩm..." 
              v-model="searchQuery"
              class="search-input"
            >
          </div>
        </div>
        
        <div class="filter-group">
          <label>Khách hàng</label>
          <select v-model="selectedCustomer" class="filter-select">
            <option value="">Tất cả khách hàng</option>
            <option v-for="customer in availableCustomers" :key="customer.id" :value="customer.id">
              {{ customer.ho_ten }}
            </option>
          </select>
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
          <label>Từ ngày</label>
          <input type="date" v-model="fromDate" class="filter-input">
        </div>
        
        <div class="filter-group">
          <label>Đến ngày</label>
          <input type="date" v-model="toDate" class="filter-input">
        </div>
      </div>
    </div>

    <!-- List View -->
    <div v-if="viewMode === 'list'" class="data-card">
      <div class="data-header">
        <h3>Danh sách Yêu thích ({{ totalFilteredFavorites }} kết quả)</h3>
      </div>

      <div class="table-wrapper">
        <table class="data-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Khách hàng</th>
              <th>Sản phẩm</th>
              <th>Giá</th>
              <th>Danh mục</th>
              <th>Ngày thêm</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(favorite, index) in filteredFavorites" :key="favorite.id">
              <td class="index-cell">{{ index + 1 + startIndex }}</td>
              <td>
                <div class="customer-info">
                  <div class="customer-avatar">
                    {{ favorite.nguoi_dung.ho_ten.charAt(0) }}
                  </div>
                  <div class="customer-details">
                    <div class="customer-name">{{ favorite.nguoi_dung.ho_ten }}</div>
                    <div class="customer-email">{{ favorite.nguoi_dung.email }}</div>
                  </div>
                </div>
              </td>
              <td>
                <div class="product-info">
                  <div class="product-image">
                    <img :src="favorite.san_pham.hinh_anh" :alt="favorite.san_pham.ten_san_pham">
                  </div>
                  <div class="product-details">
                    <div class="product-name">{{ favorite.san_pham.ten_san_pham }}</div>
                    <div class="product-brand">{{ favorite.san_pham.thuong_hieu }}</div>
                  </div>
                </div>
              </td>
              <td>
                <div class="price-info">
                  <div class="current-price">{{ formatCurrency(favorite.san_pham.gia_ban) }}</div>
                  <div v-if="favorite.san_pham.khuyen_mai" class="original-price">
                    {{ formatCurrency(favorite.san_pham.gia_goc) }}
                  </div>
                </div>
              </td>
              <td>
                <span class="category-badge">{{ favorite.san_pham.danh_muc }}</span>
              </td>
              <td>
                <div class="date-info">
                  <div class="date-text">{{ formatDate(favorite.ngay_them) }}</div>
                  <div class="time-text">{{ formatTime(favorite.ngay_them) }}</div>
                </div>
              </td>
              <td>
                <div class="action-buttons">
                  <button class="action-btn view-btn" @click="viewDetails(favorite)" title="Xem chi tiết">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                    </svg>
                  </button>
                  <button class="action-btn recommend-btn" @click="createRecommendation(favorite)" title="Tạo gợi ý">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path>
                    </svg>
                  </button>
                  <button class="action-btn delete-btn" @click="removeFavorite(favorite)" title="Xóa yêu thích">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- Pagination -->
        <div class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của {{ totalFilteredFavorites }} yêu thích
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

    <!-- Analytics View -->
    <div v-if="viewMode === 'analytics'" class="analytics-section">
      <div class="analytics-grid">
        <!-- Top Products Chart -->
        <div class="analytics-card">
          <div class="card-header">
            <h4>Top 10 Sản phẩm được yêu thích</h4>
            <div class="card-badge">{{ topProducts.length }} sản phẩm</div>
          </div>
          <div class="chart-container">
            <div v-for="(product, index) in topProducts" :key="product.id" class="chart-bar">
              <div class="bar-rank">{{ index + 1 }}</div>
              <div class="bar-content">
                <div class="bar-info">
                  <span class="product-name">{{ product.ten_san_pham }}</span>
                  <span class="favorite-count">{{ product.count }} lượt</span>
                </div>
                <div class="bar-visual">
                  <div class="bar-fill" :style="{ width: (product.count / topProducts[0].count * 100) + '%' }"></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Category Distribution -->
        <div class="analytics-card">
          <div class="card-header">
            <h4>Phân bố theo danh mục</h4>
            <div class="card-badge">{{ categoryStats.length }} danh mục</div>
          </div>
          <div class="category-stats">
            <div v-for="category in categoryStats" :key="category.name" class="category-item">
              <div class="category-header">
                <div class="category-info">
                  <span class="category-name">{{ category.name }}</span>
                  <span class="category-count">{{ category.count }}</span>
                </div>
                <div class="category-percentage">{{ category.percentage }}%</div>
              </div>
              <div class="category-bar">
                <div class="category-fill" :style="{ width: category.percentage + '%' }"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- User Engagement -->
        <div class="analytics-card">
          <div class="card-header">
            <h4>Người dùng tích cực nhất</h4>
            <div class="card-badge">Top {{ topUsers.length }}</div>
          </div>
          <div class="user-stats">
            <div v-for="(user, index) in topUsers" :key="user.id" class="user-item">
              <div class="user-rank">{{ index + 1 }}</div>
              <div class="user-avatar">{{ user.ho_ten.charAt(0) }}</div>
              <div class="user-info">
                <div class="user-name">{{ user.ho_ten }}</div>
                <div class="user-favorites">{{ user.favoriteCount }} sản phẩm yêu thích</div>
              </div>
              <div class="user-badge">
                <svg fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Time Trends -->
        <div class="analytics-card">
          <div class="card-header">
            <h4>Xu hướng theo thời gian</h4>
            <div class="card-badge">6 tháng gần đây</div>
          </div>
          <div class="time-chart">
            <div v-for="period in timeTrends" :key="period.period" class="time-item">
              <div class="time-label">{{ formatPeriod(period.period) }}</div>
              <div class="time-bar">
                <div class="time-fill" :style="{ width: (period.count / Math.max(...timeTrends.map(t => t.count)) * 100) + '%' }"></div>
              </div>
              <div class="time-count">{{ period.count }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Details Modal -->
    <div v-if="showDetailsModal" class="modal-overlay" @click="showDetailsModal = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Chi tiết sản phẩm yêu thích</h3>
          <button class="modal-close" @click="showDetailsModal = false">✕</button>
        </div>
        
        <div class="modal-body" v-if="selectedFavorite">
          <div class="favorite-detail">
            <div class="customer-section">
              <h4>Thông tin khách hàng</h4>
              <div class="customer-detail">
                <div class="customer-avatar-large">{{ selectedFavorite.nguoi_dung.ho_ten.charAt(0) }}</div>
                <div class="customer-detail-info">
                  <div class="customer-name-large">{{ selectedFavorite.nguoi_dung.ho_ten }}</div>
                  <div class="customer-email">{{ selectedFavorite.nguoi_dung.email }}</div>
                  <div class="customer-phone">{{ selectedFavorite.nguoi_dung.sdt }}</div>
                </div>
              </div>
            </div>

            <div class="product-section">
              <h4>Thông tin sản phẩm</h4>
              <div class="product-detail">
                <img :src="selectedFavorite.san_pham.hinh_anh" :alt="selectedFavorite.san_pham.ten_san_pham" class="detail-product-image">
                <div class="product-detail-info">
                  <div class="product-name-large">{{ selectedFavorite.san_pham.ten_san_pham }}</div>
                  <div class="product-brand-large">{{ selectedFavorite.san_pham.thuong_hieu }}</div>
                  <div class="product-category-large">{{ selectedFavorite.san_pham.danh_muc }}</div>
                  <div class="product-price-large">{{ formatCurrency(selectedFavorite.san_pham.gia_ban) }}</div>
                </div>
              </div>
            </div>

            <div class="favorite-info-section">
              <h4>Thông tin yêu thích</h4>
              <div class="info-grid">
                <div class="info-item">
                  <label>Ngày thêm:</label>
                  <span>{{ formatDateTime(selectedFavorite.ngay_them) }}</span>
                </div>
                <div class="info-item">
                  <label>Thời gian:</label>
                  <span>{{ getTimeSince(selectedFavorite.ngay_them) }}</span>
                </div>
              </div>
            </div>

            <div class="modal-actions">
              <button class="btn btn-primary" @click="createRecommendation(selectedFavorite)">
                <!-- icon: lightbulb --> Tạo gợi ý sản phẩm
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
const selectedCustomer = ref('')
const selectedProduct = ref('')
const fromDate = ref('')
const toDate = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(15)
const showDetailsModal = ref(false)
const selectedFavorite = ref(null)
const viewMode = ref('list')

// Available data for filtering
const availableCustomers = ref([])

const availableProducts = ref([])

// Mock data - should match ERD yeu_thich table
const favorites = ref([])

// Computed
const filteredFavorites = computed(() => {
  let filtered = favorites.value

  if (searchQuery.value) {
    filtered = filtered.filter(fav => 
      fav.nguoi_dung.ho_ten.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      fav.san_pham.ten_san_pham.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }

  if (selectedCustomer.value) {
    filtered = filtered.filter(fav => fav.id_nguoi_dung === parseInt(selectedCustomer.value))
  }

  if (selectedProduct.value) {
    filtered = filtered.filter(fav => fav.id_san_pham === parseInt(selectedProduct.value))
  }

  if (fromDate.value) {
    filtered = filtered.filter(fav => 
      new Date(fav.ngay_them) >= new Date(fromDate.value)
    )
  }

  if (toDate.value) {
    filtered = filtered.filter(fav => 
      new Date(fav.ngay_them) <= new Date(toDate.value + 'T23:59:59')
    )
  }

  return filtered.slice(startIndex.value, endIndex.value)
})

const totalFavorites = computed(() => favorites.value.length)
const totalFilteredFavorites = computed(() => filteredFavorites.value.length)
const totalPages = computed(() => Math.ceil(totalFilteredFavorites.value / itemsPerPage.value))
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => Math.min(startIndex.value + itemsPerPage.value, totalFilteredFavorites.value))

const uniqueUsers = computed(() => {
  const userIds = [...new Set(favorites.value.map(fav => fav.id_nguoi_dung))]
  return userIds.length
})

const topProduct = computed(() => {
  const productCounts = {}
  let topProductName = ''
  let maxCount = 0

  favorites.value.forEach(fav => {
    productCounts[fav.id_san_pham] = (productCounts[fav.id_san_pham] || 0) + 1
    if (productCounts[fav.id_san_pham] > maxCount) {
      maxCount = productCounts[fav.id_san_pham]
      topProductName = fav.san_pham.ten_san_pham
    }
  })

  return { count: maxCount, name: topProductName }
})

const conversionRate = computed(() => {
  // Mock conversion rate calculation
  return Math.round((uniqueUsers.value / totalFavorites.value) * 100 * 1.2)
})

const topProducts = computed(() => {
  const productCounts = {}
  favorites.value.forEach(fav => {
    if (!productCounts[fav.id_san_pham]) {
      productCounts[fav.id_san_pham] = {
        id: fav.id_san_pham,
        ten_san_pham: fav.san_pham.ten_san_pham,
        count: 0
      }
    }
    productCounts[fav.id_san_pham].count++
  })
  return Object.values(productCounts).sort((a, b) => b.count - a.count).slice(0, 10)
})

const categoryStats = computed(() => {
  const categoryCounts = {}
  const total = favorites.value.length
  
  favorites.value.forEach(fav => {
    const category = fav.san_pham.danh_muc
    categoryCounts[category] = (categoryCounts[category] || 0) + 1
  })

  return Object.entries(categoryCounts).map(([name, count]) => ({
    name,
    count,
    percentage: Math.round((count / total) * 100)
  })).sort((a, b) => b.count - a.count)
})

const topUsers = computed(() => {
  const userCounts = {}
  favorites.value.forEach(fav => {
    if (!userCounts[fav.id_nguoi_dung]) {
      userCounts[fav.id_nguoi_dung] = {
        id: fav.id_nguoi_dung,
        ho_ten: fav.nguoi_dung.ho_ten,
        favoriteCount: 0
      }
    }
    userCounts[fav.id_nguoi_dung].favoriteCount++
  })
  return Object.values(userCounts).sort((a, b) => b.favoriteCount - a.favoriteCount).slice(0, 5)
})

const timeTrends = computed(() => {
  const periods = {}
  favorites.value.forEach(fav => {
    const date = new Date(fav.ngay_them)
    const period = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`
    periods[period] = (periods[period] || 0) + 1
  })
  
  return Object.entries(periods).map(([period, count]) => ({
    period,
    count
  })).sort((a, b) => a.period.localeCompare(b.period)).slice(-6)
})

// Methods
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('vi-VN', { 
    style: 'currency', 
    currency: 'VND' 
  }).format(amount)
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('vi-VN')
}

const formatTime = (dateString) => {
  return new Date(dateString).toLocaleTimeString('vi-VN', {
    hour: '2-digit',
    minute: '2-digit'
  })
}

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString('vi-VN')
}

const formatPeriod = (period) => {
  const [year, month] = period.split('-')
  return `${month}/${year}`
}

const getTimeSince = (dateString) => {
  const now = new Date()
  const date = new Date(dateString)
  const diffTime = Math.abs(now - date)
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  return `${diffDays} ngày trước`
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

const viewDetails = (favorite) => {
  selectedFavorite.value = favorite
  showDetailsModal.value = true
}

const createRecommendation = (favorite) => {
  alert(`Tạo gợi ý sản phẩm cho ${favorite.nguoi_dung.ho_ten} dựa trên sở thích`)
  showDetailsModal.value = false
}

const removeFavorite = (favorite) => {
  if (confirm(`Xóa sản phẩm yêu thích "${favorite.san_pham.ten_san_pham}" của ${favorite.nguoi_dung.ho_ten}?`)) {
    favorites.value = favorites.value.filter(fav => fav.id !== favorite.id)
  }
}

const exportData = () => {
  alert('Xuất báo cáo sản phẩm yêu thích')
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([
      loadFavorites(),
      loadStats()
    ])
  } catch (error) {
    console.error('Error refreshing data:', error)
  } finally {
    loading.value = false
  }
}

const exportToExcel = () => {
  try {
    const headerMapping = {
      'id': 'ID',
      'user_name': 'Tên người dùng', 
      'product_name': 'Tên sản phẩm',
      'brand': 'Thương hiệu',
      'category': 'Danh mục',
      'price': 'Giá (VND)',
      'added_date': 'Ngày thêm'
    }
    
    const filteredData = filteredFavorites.value.map(item => ({
      id: item.id || 'N/A',
      user_name: item.user_name || 'N/A',
      product_name: item.product_name || 'N/A', 
      brand: item.brand || 'N/A',
      category: item.category || 'N/A',
      price: item.price ? new Intl.NumberFormat('vi-VN').format(item.price) : 'N/A',
      added_date: item.added_date ? new Date(item.added_date).toLocaleDateString('vi-VN') : 'N/A'
    }))
    
    const result = exportToExcel(filteredData, 'Favorites_Management', 'Danh sách sản phẩm yêu thích', headerMapping)
    
    if (result && result.success) {
      alert(`<!-- icon: check --> ${result.message}`)
    } else {
      alert(`<!-- icon: close --> ${result ? result.message : 'Có lỗi xảy ra khi xuất file Excel'}`)
    }
  } catch (error) {
    console.error('Error exporting to Excel:', error)
    alert(`<!-- icon: close --> Có lỗi xảy ra khi xuất file Excel: ${error.message}`)
  }
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
@import '../../styles/cssQuanLy/quanLyYeuThich.css';
</style>
