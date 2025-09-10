<template>
  <div class="cart-page">
    <!-- Page Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Quản lý Giỏ hàng</h1>
          <p class="page-subtitle">Theo dõi và quản lý giỏ hàng của khách hàng</p>
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
          <button class="btn-export" @click="exportCartsToExcel">
            <span class="btn-icon"><!-- icon: excel --></span>
            Xuất Excel
          </button>
        </div>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid">
      <div class="stat-card carts-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13H17l4-8H5.4z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ totalCarts }}</div>
          <div class="stat-label">Tổng giỏ hàng</div>
          <div class="stat-trend positive">+12% từ tháng trước</div>
        </div>
      </div>
      
      <div class="stat-card active-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ activeCarts }}</div>
          <div class="stat-label">Đang hoạt động</div>
          <div class="stat-trend positive">+8% từ tháng trước</div>
        </div>
      </div>

      <div class="stat-card abandoned-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ abandonedCarts }}</div>
          <div class="stat-label">Bị bỏ lại</div>
          <div class="stat-trend negative">-5% từ tháng trước</div>
        </div>
      </div>

      <div class="stat-card value-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ formatCurrency(averageCartValue) }}</div>
          <div class="stat-label">Giá trị TB giỏ hàng</div>
          <div class="stat-trend positive">+15% từ tháng trước</div>
        </div>
      </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-card">
      <div class="filter-header">
        <h3>Bộ lọc & Tìm kiếm</h3>
        <button class="btn btn-secondary" @click="resetFilters">
          <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
          </svg>
          Đặt lại
        </button>
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
              placeholder="Tìm theo khách hàng..." 
              v-model="searchQuery"
              class="search-input"
            >
          </div>
        </div>
        
        <div class="filter-group">
          <label>Trạng thái</label>
          <select v-model="selectedStatus" class="filter-select">
            <option value="">Tất cả trạng thái</option>
            <option value="active">Đang hoạt động</option>
            <option value="abandoned">Bị bỏ lại</option>
            <option value="converted">Đã chuyển đổi</option>
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

        <div class="filter-group">
          <label>Số lượng tối thiểu</label>
          <input type="number" v-model="minQuantity" placeholder="0" class="filter-input">
        </div>
      </div>
    </div>

    <!-- Cart List -->
    <div class="data-card">
      <div class="data-header">
        <h3>Danh sách Giỏ hàng ({{ filteredCarts.length }} kết quả)</h3>
        <div class="header-controls">
          <select v-model="itemsPerPage" class="filter-select">
            <option value="10">10/trang</option>
            <option value="25">25/trang</option>
            <option value="50">50/trang</option>
          </select>
        </div>
      </div>

      <div class="table-wrapper">
        <table class="data-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Khách hàng</th>
              <th>Sản phẩm</th>
              <th>Số lượng</th>
              <th>Giá trị</th>
              <th>Cập nhật cuối</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(cart, index) in paginatedCarts" :key="cart.id">
              <td class="index-cell">{{ index + 1 + startIndex }}</td>
              <td>
                <div class="customer-info">
                  <div class="customer-avatar">
                    {{ cart.customer.name.charAt(0) }}
                  </div>
                  <div class="customer-details">
                    <div class="customer-name">{{ cart.customer.name }}</div>
                    <div class="customer-email">{{ cart.customer.email }}</div>
                  </div>
                </div>
              </td>
              <td>
                <div class="cart-products">
                  <div v-for="item in cart.items.slice(0, 2)" :key="item.id" class="product-item">
                    <div class="product-image">
                      <img :src="item.product.image" :alt="item.product.name">
                    </div>
                    <div class="product-details">
                      <div class="product-name">{{ item.product.name }}</div>
                      <div class="product-variant">{{ item.variant ? `${item.variant.color} - ${item.variant.size}` : '' }}</div>
                    </div>
                  </div>
                  <div v-if="cart.items.length > 2" class="more-products">
                    +{{ cart.items.length - 2 }} sản phẩm khác
                  </div>
                </div>
              </td>
              <td>
                <div class="quantity-badge">{{ getTotalQuantity(cart) }}</div>
              </td>
              <td>
                <div class="price-info">
                  <div class="price-current">{{ formatCurrency(getCartValue(cart)) }}</div>
                </div>
              </td>
              <td>
                <div class="date-info">
                  <div class="date-main">{{ formatDate(cart.updatedAt) }}</div>
                  <div class="date-ago">{{ getTimeAgo(cart.updatedAt) }}</div>
                </div>
              </td>
              <td>
                <span :class="['status-badge', getStatusClass(cart)]">
                  {{ getStatusText(cart) }}
                </span>
              </td>
              <td>
                <div class="actions">
                  <button 
                    class="action-btn view" 
                    @click="viewCartDetail(cart)"
                    title="Xem chi tiết"
                  >
                    <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                    </svg>
                  </button>
                  <button 
                    v-if="cart.status === 'abandoned'"
                    class="action-btn remind" 
                    @click="sendReminder(cart)"
                    title="Gửi nhắc nhở"
                  >
                    <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                  </button>
                  <button 
                    class="action-btn delete" 
                    @click="deleteCart(cart)"
                    title="Xóa giỏ hàng"
                  >
                    <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="pagination-wrapper">
        <div class="pagination-info">
          Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của {{ filteredCarts.length }} giỏ hàng
        </div>
        <div class="pagination">
          <button 
            class="pagination-btn" 
            @click="previousPage" 
            :disabled="currentPage === 1"
          >
            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
            </svg>
            Trước
          </button>
          <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
          <button 
            class="pagination-btn" 
            @click="nextPage" 
            :disabled="currentPage === totalPages"
          >
            Sau
            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Cart Detail Modal -->
    <div v-if="showDetailModal" class="modal-overlay" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Chi tiết giỏ hàng</h3>
          <button class="modal-close" @click="closeModal">×</button>
        </div>
        
        <div class="modal-body" v-if="selectedCart">
          <div class="cart-detail">
            <div class="customer-section">
              <h4>Thông tin khách hàng</h4>
              <div class="customer-detail">
                <div class="customer-avatar-large">
                  {{ selectedCart.customer.name.charAt(0) }}
                </div>
                <div class="customer-info-large">
                  <div class="customer-name-large">{{ selectedCart.customer.name }}</div>
                  <div class="customer-email-large">{{ selectedCart.customer.email }}</div>
                  <div class="customer-phone-large">{{ selectedCart.customer.phone }}</div>
                  <div class="customer-address-large">{{ selectedCart.customer.address }}</div>
                </div>
              </div>
            </div>

            <div class="products-section">
              <h4>Sản phẩm trong giỏ</h4>
              <div class="products-list">
                <div v-for="item in selectedCart.items" :key="item.id" class="product-detail">
                  <div class="detail-product-image">
                    <img :src="item.product.image" :alt="item.product.name">
                  </div>
                  <div class="product-info-large">
                    <div class="product-name-large">{{ item.product.name }}</div>
                    <div class="product-variant-large">{{ item.variant ? `${item.variant.color} - ${item.variant.size}` : 'Mặc định' }}</div>
                    <div class="product-price-large">{{ formatCurrency(item.price) }} x {{ item.so_luong }}</div>
                    <div class="product-total-large">{{ formatCurrency(item.price * item.so_luong) }}</div>
                  </div>
                </div>
              </div>
            </div>

            <div class="cart-info-section">
              <h4>Thông tin giỏ hàng</h4>
              <div class="info-grid">
                <div class="info-item">
                  <label>Tổng số lượng</label>
                  <span>{{ getTotalQuantity(selectedCart) }} sản phẩm</span>
                </div>
                <div class="info-item">
                  <label>Tổng giá trị</label>
                  <span>{{ formatCurrency(getCartValue(selectedCart)) }}</span>
                </div>
                <div class="info-item">
                  <label>Ngày tạo</label>
                  <span>{{ formatDateTime(selectedCart.createdAt) }}</span>
                </div>
                <div class="info-item">
                  <label>Cập nhật cuối</label>
                  <span>{{ formatDateTime(selectedCart.updatedAt) }}</span>
                </div>
              </div>
            </div>

            <div class="modal-actions">
              <button class="btn btn-secondary" @click="closeModal">Đóng</button>
              <button v-if="selectedCart.status === 'abandoned'" class="btn btn-primary" @click="sendReminder(selectedCart)">
                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                </svg>
                Gửi nhắc nhở
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
import { exportToExcel, formatDataForExcel } from '../../utils/xuatExcel.js'

// Data
const searchQuery = ref('')
const selectedStatus = ref('')
const fromDate = ref('')
const toDate = ref('')
const minQuantity = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(10)
const showDetailModal = ref(false)
const selectedCart = ref(null)

// Mock data based on ERD gio_hang table
const carts = ref([])

// Computed
const filteredCarts = computed(() => {
  let filtered = carts.value

  if (searchQuery.value) {
    filtered = filtered.filter(cart => 
      cart.customer.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      cart.customer.email.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      cart.customer.phone.includes(searchQuery.value)
    )
  }

  if (selectedStatus.value) {
    filtered = filtered.filter(cart => cart.status === selectedStatus.value)
  }

  if (fromDate.value) {
    filtered = filtered.filter(cart => new Date(cart.updatedAt) >= new Date(fromDate.value))
  }

  if (toDate.value) {
    filtered = filtered.filter(cart => new Date(cart.updatedAt) <= new Date(toDate.value))
  }

  if (minQuantity.value) {
    filtered = filtered.filter(cart => getTotalQuantity(cart) >= parseInt(minQuantity.value))
  }

  return filtered
})

const totalPages = computed(() => Math.ceil(filteredCarts.value.length / itemsPerPage.value))
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => Math.min(startIndex.value + itemsPerPage.value, filteredCarts.value.length))

const paginatedCarts = computed(() => {
  return filteredCarts.value.slice(startIndex.value, endIndex.value)
})

// Statistics
const totalCarts = computed(() => carts.value.length)
const activeCarts = computed(() => carts.value.filter(cart => cart.status === 'active').length)
const abandonedCarts = computed(() => carts.value.filter(cart => cart.status === 'abandoned').length)
const averageCartValue = computed(() => {
  const total = carts.value.reduce((sum, cart) => sum + getCartValue(cart), 0)
  return total / carts.value.length
})

// Methods
const getTotalQuantity = (cart) => {
  return cart.items.reduce((total, item) => total + item.so_luong, 0)
}

const getCartValue = (cart) => {
  return cart.items.reduce((total, item) => total + (item.price * item.so_luong), 0)
}

const formatCurrency = (amount) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND'
  }).format(amount)
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('vi-VN')
}

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString('vi-VN')
}

const getTimeAgo = (dateString) => {
  const now = new Date()
  const past = new Date(dateString)
  const diffInHours = Math.floor((now - past) / (1000 * 60 * 60))
  
  if (diffInHours < 1) return 'Vừa xong'
  if (diffInHours < 24) return `${diffInHours} giờ trước`
  
  const diffInDays = Math.floor(diffInHours / 24)
  return `${diffInDays} ngày trước`
}

const getStatusClass = (cart) => {
  switch (cart.status) {
    case 'active': return 'status-active'
    case 'abandoned': return 'status-abandoned'
    case 'converted': return 'status-converted'
    default: return 'status-unknown'
  }
}

const getStatusText = (cart) => {
  switch (cart.status) {
    case 'active': return 'Hoạt động'
    case 'abandoned': return 'Bỏ lại'
    case 'converted': return 'Đã mua'
    default: return 'Không xác định'
  }
}

const resetFilters = () => {
  searchQuery.value = ''
  selectedStatus.value = ''
  fromDate.value = ''
  toDate.value = ''
  minQuantity.value = ''
  currentPage.value = 1
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

const viewCartDetail = (cart) => {
  selectedCart.value = cart
  showDetailModal.value = true
}

const closeModal = () => {
  showDetailModal.value = false
  selectedCart.value = null
}

const sendReminder = (cart) => {
  alert(`Gửi email nhắc nhở cho khách hàng: ${cart.customer.name}`)
}

const deleteCart = (cart) => {
  if (confirm(`Bạn có chắc chắn muốn xóa giỏ hàng của "${cart.customer.name}"?`)) {
    const index = carts.value.findIndex(c => c.id === cart.id)
    if (index !== -1) {
      carts.value.splice(index, 1)
    }
  }
}

const exportData = () => {
  alert('Chức năng xuất dữ liệu đang được phát triển')
}

const exportCartsToExcel = () => {
  try {
    // Define Vietnamese headers for the Excel export
    const headerMapping = {
      id: 'ID Giỏ hàng',
      khach_hang: 'Khách hàng',
      email: 'Email',
      tong_san_pham: 'Tổng sản phẩm',
      tong_tien: 'Tổng tiền',
      trang_thai: 'Trạng thái',
      ngay_tao: 'Ngày tạo',
      lan_cuoi_cap_nhat: 'Lần cuối cập nhật'
    }
    
    // Get the filtered carts data
    const dataToExport = filteredCarts.value.map(cart => ({
      id: cart.id,
      khach_hang: cart.khach_hang,
      email: cart.email,
      tong_san_pham: cart.tong_san_pham,
      tong_tien: cart.tong_tien,
      trang_thai: cart.trang_thai,
      ngay_tao: cart.ngay_tao,
      lan_cuoi_cap_nhat: cart.lan_cuoi_cap_nhat
    }))
    
    // Format data with Vietnamese headers
    const formattedData = formatDataForExcel(dataToExport, headerMapping)
    
    // Export to Excel
    const result = exportToExcel(
      formattedData,
      'Danh_sach_gio_hang',
      'Giỏ hàng',
      {
        skipHeader: false
      }
    )
    
    if (result.success) {
      alert(`<!-- icon: check --> ${result.message}`)
    } else {
      alert(`<!-- icon: close --> ${result.message}`)
    }
  } catch (error) {
    console.error('Error in exportToExcel:', error)
    alert('<!-- icon: close --> Có lỗi xảy ra khi xuất file Excel')
  }
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([
      loadCarts(),
      loadStats()
    ])
  } catch (error) {
    console.error('Error refreshing cart data:', error)
  } finally {
    loading.value = false
  }
}

// Initialize date filters to last 30 days
onMounted(() => {
  const today = new Date()
  const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate())
  
  toDate.value = today.toISOString().split('T')[0]
  fromDate.value = lastMonth.toISOString().split('T')[0]
})
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/quanLyGioHang.css';
</style>
