<template>
  <div class="notifications-page">
    <!-- Page Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Quản lý Thông báo</h1>
          <p class="page-subtitle">Tạo và quản lý thông báo gửi tới khách hàng</p>
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
          <button class="btn-export" @click="exportNotificationsToExcel">
            <span class="btn-icon"><!-- icon: excel --></span>
            Xuất Excel
          </button>
          <button class="btn-export" @click="showCreateModal = true">
            <span class="btn-icon"><!-- icon: plus --></span>
            Tạo thông báo
          </button>
        </div>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid">
      <div class="stat-card total-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5-5-5h5v-5a7.5 7.5 0 01-7.5-7.5H2A10 10 0 0012 2a10 10 0 0010 10h-1.5a7.5 7.5 0 01-7.5 7.5v5z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ totalNotifications }}</div>
          <div class="stat-label">Tổng thông báo</div>
          <div class="stat-trend positive">+15% từ tháng trước</div>
        </div>
      </div>
      
      <div class="stat-card unread-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ unreadNotifications }}</div>
          <div class="stat-label">Chưa đọc</div>
          <div class="stat-trend neutral">{{ Math.round((unreadNotifications/totalNotifications)*100) }}% chưa đọc</div>
        </div>
      </div>

      <div class="stat-card read-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ readNotifications }}</div>
          <div class="stat-label">Đã đọc</div>
          <div class="stat-trend positive">{{ Math.round((readNotifications/totalNotifications)*100) }}% đã đọc</div>
        </div>
      </div>

      <div class="stat-card recent-stat">
        <div class="stat-icon">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ todayNotifications }}</div>
          <div class="stat-label">Hôm nay</div>
          <div class="stat-trend positive">+8% từ hôm qua</div>
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
              placeholder="Tìm theo tiêu đề, người nhận..." 
              v-model="searchQuery"
              class="search-input"
            >
          </div>
        </div>
        
        <div class="filter-group">
          <label>Loại thông báo</label>
          <select v-model="selectedType" class="filter-select">
            <option value="">Tất cả loại</option>
            <option value="system">Hệ thống</option>
            <option value="promotion">Khuyến mãi</option>
            <option value="order">Đơn hàng</option>
            <option value="account">Tài khoản</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Trạng thái</label>
          <select v-model="selectedStatus" class="filter-select">
            <option value="">Tất cả trạng thái</option>
            <option value="sent">Đã gửi</option>
            <option value="read">Đã đọc</option>
            <option value="unread">Chưa đọc</option>
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

    <!-- Notifications List -->
    <div class="data-card">
      <div class="data-header">
        <h3>Danh sách Thông báo ({{ filteredNotifications.length }} kết quả)</h3>
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
              <th>Người nhận</th>
              <th>Tiêu đề</th>
              <th>Loại</th>
              <th>Thời gian gửi</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(notification, index) in paginatedNotifications" :key="notification.id">
              <td class="index-cell">{{ index + 1 + startIndex }}</td>
              <td>
                <div class="user-info">
                  <div class="user-avatar">
                    {{ notification.nguoi_dung.ho_ten.charAt(0) }}
                  </div>
                  <div class="user-details">
                    <div class="user-name">{{ notification.nguoi_dung.ho_ten }}</div>
                    <div class="user-email">{{ notification.nguoi_dung.email }}</div>
                  </div>
                </div>
              </td>
              <td>
                <div class="notification-title">{{ notification.tieu_de }}</div>
                <div class="notification-preview">{{ notification.noi_dung.substring(0, 60) }}...</div>
              </td>
              <td>
                <span :class="['type-badge', getTypeClass(notification.loai)]">
                  {{ getTypeText(notification.loai) }}
                </span>
              </td>
              <td>
                <div class="date-info">
                  <div class="date-main">{{ formatDate(notification.ngay_tao) }}</div>
                  <div class="date-ago">{{ getTimeAgo(notification.ngay_tao) }}</div>
                </div>
              </td>
              <td>
                <span :class="['status-badge', getStatusClass(notification)]">
                  {{ getStatusText(notification) }}
                </span>
              </td>
              <td>
                <div class="actions">
                  <button 
                    class="action-btn view" 
                    @click="viewNotification(notification)"
                    title="Xem chi tiết"
                  >
                    <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                    </svg>
                  </button>
                  <button 
                    class="action-btn edit" 
                    @click="editNotification(notification)"
                    title="Chỉnh sửa"
                  >
                    <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                    </svg>
                  </button>
                  <button 
                    class="action-btn delete" 
                    @click="deleteNotification(notification)"
                    title="Xóa"
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
          Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của {{ filteredNotifications.length }} thông báo
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

    <!-- Create/Edit Modal -->
    <div v-if="showCreateModal || showEditModal" class="modal-overlay" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ showCreateModal ? 'Tạo thông báo mới' : 'Chỉnh sửa thông báo' }}</h3>
          <button class="modal-close" @click="closeModal">×</button>
        </div>
        
        <div class="modal-body">
          <div class="notification-form">
            <div class="form-section">
              <h4>Thông tin cơ bản</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label>Tiêu đề</label>
                  <input type="text" v-model="form.tieu_de" class="filter-input" placeholder="Nhập tiêu đề thông báo">
                </div>
                <div class="form-group">
                  <label>Loại thông báo</label>
                  <select v-model="form.loai" class="filter-select">
                    <option value="system">Hệ thống</option>
                    <option value="promotion">Khuyến mãi</option>
                    <option value="order">Đơn hàng</option>
                    <option value="account">Tài khoản</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="form-section">
              <h4>Nội dung</h4>
              <div class="form-group">
                <textarea 
                  v-model="form.noi_dung" 
                  class="content-textarea" 
                  placeholder="Nhập nội dung thông báo..."
                  rows="5"
                ></textarea>
              </div>
            </div>

            <div class="form-section">
              <h4>Người nhận</h4>
              <div class="recipient-options">
                <label class="radio-option">
                  <input type="radio" v-model="form.recipient_type" value="all">
                  <span>Gửi tất cả khách hàng</span>
                </label>
                <label class="radio-option">
                  <input type="radio" v-model="form.recipient_type" value="specific">
                  <span>Chọn khách hàng cụ thể</span>
                </label>
              </div>
              
              <div v-if="form.recipient_type === 'specific'" class="customer-select">
                <select v-model="form.selected_users" multiple class="filter-select">
                  <option v-for="user in availableUsers" :key="user.id" :value="user.id">
                    {{ user.ho_ten }} - {{ user.email }}
                  </option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-actions">
          <button class="btn btn-secondary" @click="closeModal">Hủy</button>
          <button class="btn btn-primary" @click="saveNotification">
            {{ showCreateModal ? 'Tạo thông báo' : 'Lưu thay đổi' }}
          </button>
        </div>
      </div>
    </div>

    <!-- View Modal -->
    <div v-if="showViewModal" class="modal-overlay" @click="closeViewModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Chi tiết thông báo</h3>
          <button class="modal-close" @click="closeViewModal">×</button>
        </div>
        
        <div class="modal-body" v-if="selectedNotification">
          <div class="notification-detail">
            <div class="detail-section">
              <h4>Thông tin thông báo</h4>
              <div class="info-grid">
                <div class="info-item">
                  <label>Tiêu đề</label>
                  <span>{{ selectedNotification.tieu_de }}</span>
                </div>
                <div class="info-item">
                  <label>Loại</label>
                  <span :class="['type-badge', getTypeClass(selectedNotification.loai)]">
                    {{ getTypeText(selectedNotification.loai) }}
                  </span>
                </div>
                <div class="info-item">
                  <label>Thời gian tạo</label>
                  <span>{{ formatDateTime(selectedNotification.ngay_tao) }}</span>
                </div>
                <div class="info-item">
                  <label>Trạng thái</label>
                  <span :class="['status-badge', getStatusClass(selectedNotification)]">
                    {{ getStatusText(selectedNotification) }}
                  </span>
                </div>
              </div>
            </div>

            <div class="detail-section">
              <h4>Nội dung</h4>
              <div class="content-display">
                {{ selectedNotification.noi_dung }}
              </div>
            </div>

            <div class="detail-section">
              <h4>Người nhận</h4>
              <div class="recipient-info">
                <div class="user-avatar-large">
                  {{ selectedNotification.nguoi_dung.ho_ten.charAt(0) }}
                </div>
                <div class="user-info-large">
                  <div class="user-name-large">{{ selectedNotification.nguoi_dung.ho_ten }}</div>
                  <div class="user-email-large">{{ selectedNotification.nguoi_dung.email }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-actions">
          <button class="btn btn-secondary" @click="closeViewModal">Đóng</button>
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
const selectedType = ref('')
const selectedStatus = ref('')
const fromDate = ref('')
const toDate = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(10)
const showCreateModal = ref(false)
const showEditModal = ref(false)
const showViewModal = ref(false)
const selectedNotification = ref(null)

const form = ref({
  tieu_de: '',
  noi_dung: '',
  loai: 'system',
  recipient_type: 'all',
  selected_users: []
})

const notifications = ref([])

const availableUsers = ref([])

// Computed
const filteredNotifications = computed(() => {
  let filtered = notifications.value

  if (searchQuery.value) {
    filtered = filtered.filter(n => 
      n.tieu_de.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      n.nguoi_dung.ho_ten.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      n.nguoi_dung.email.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }

  if (selectedType.value) {
    filtered = filtered.filter(n => n.loai === selectedType.value)
  }

  if (selectedStatus.value) {
    if (selectedStatus.value === 'read') {
      filtered = filtered.filter(n => n.da_doc === true)
    } else if (selectedStatus.value === 'unread') {
      filtered = filtered.filter(n => n.da_doc === false)
    }
  }

  if (fromDate.value) {
    filtered = filtered.filter(n => new Date(n.ngay_tao) >= new Date(fromDate.value))
  }

  if (toDate.value) {
    filtered = filtered.filter(n => new Date(n.ngay_tao) <= new Date(toDate.value))
  }

  return filtered
})

const totalPages = computed(() => Math.ceil(filteredNotifications.value.length / itemsPerPage.value))
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => Math.min(startIndex.value + itemsPerPage.value, filteredNotifications.value.length))

const paginatedNotifications = computed(() => {
  return filteredNotifications.value.slice(startIndex.value, endIndex.value)
})

// Statistics
const totalNotifications = computed(() => notifications.value.length)
const unreadNotifications = computed(() => notifications.value.filter(n => !n.da_doc).length)
const readNotifications = computed(() => notifications.value.filter(n => n.da_doc).length)
const todayNotifications = computed(() => {
  const today = new Date().toDateString()
  return notifications.value.filter(n => new Date(n.ngay_tao).toDateString() === today).length
})

// Methods
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

const getTypeClass = (type) => {
  switch (type) {
    case 'system': return 'type-system'
    case 'promotion': return 'type-promotion'
    case 'order': return 'type-order'
    case 'account': return 'type-account'
    default: return 'type-system'
  }
}

const getTypeText = (type) => {
  switch (type) {
    case 'system': return 'Hệ thống'
    case 'promotion': return 'Khuyến mãi'
    case 'order': return 'Đơn hàng'
    case 'account': return 'Tài khoản'
    default: return 'Hệ thống'
  }
}

const getStatusClass = (notification) => {
  return notification.da_doc ? 'status-read' : 'status-unread'
}

const getStatusText = (notification) => {
  return notification.da_doc ? 'Đã đọc' : 'Chưa đọc'
}

const resetFilters = () => {
  searchQuery.value = ''
  selectedType.value = ''
  selectedStatus.value = ''
  fromDate.value = ''
  toDate.value = ''
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

const viewNotification = (notification) => {
  selectedNotification.value = notification
  showViewModal.value = true
}

const editNotification = (notification) => {
  selectedNotification.value = notification
  form.value = {
    tieu_de: notification.tieu_de,
    noi_dung: notification.noi_dung,
    loai: notification.loai,
    recipient_type: 'specific',
    selected_users: [notification.id_nguoi_dung]
  }
  showEditModal.value = true
}

const deleteNotification = (notification) => {
  if (confirm(`Bạn có chắc chắn muốn xóa thông báo "${notification.tieu_de}"?`)) {
    const index = notifications.value.findIndex(n => n.id === notification.id)
    if (index !== -1) {
      notifications.value.splice(index, 1)
    }
  }
}

const closeModal = () => {
  showCreateModal.value = false
  showEditModal.value = false
  selectedNotification.value = null
  form.value = {
    tieu_de: '',
    noi_dung: '',
    loai: 'system',
    recipient_type: 'all',
    selected_users: []
  }
}

const closeViewModal = () => {
  showViewModal.value = false
  selectedNotification.value = null
}

const saveNotification = () => {
  if (showCreateModal.value) {
    // Create new notification
    const newId = Math.max(...notifications.value.map(n => n.id)) + 1
    const targetUsers = form.value.recipient_type === 'all' ? availableUsers.value : 
                       availableUsers.value.filter(u => form.value.selected_users.includes(u.id))
    
    targetUsers.forEach((user, index) => {
      notifications.value.push({
        id: newId + index,
        id_nguoi_dung: user.id,
        tieu_de: form.value.tieu_de,
        noi_dung: form.value.noi_dung,
        loai: form.value.loai,
        da_doc: false,
        ngay_tao: new Date().toISOString(),
        nguoi_dung: user
      })
    })
    
    alert(`Đã tạo thông báo cho ${targetUsers.length} người dùng`)
  } else {
    // Update existing notification
    const index = notifications.value.findIndex(n => n.id === selectedNotification.value.id)
    if (index !== -1) {
      notifications.value[index] = {
        ...notifications.value[index],
        tieu_de: form.value.tieu_de,
        noi_dung: form.value.noi_dung,
        loai: form.value.loai
      }
    }
    alert('Đã cập nhật thông báo')
  }
  
  closeModal()
}

const exportData = () => {
  alert('Chức năng xuất dữ liệu đang được phát triển')
}

const exportNotificationsToExcel = () => {
  try {
    const headerMapping = {
      nguoi_nhan: 'Người nhận',
      email_nguoi_nhan: 'Email người nhận',
      tieu_de: 'Tiêu đề',
      noi_dung: 'Nội dung',
      loai: 'Loại thông báo',
      da_doc: 'Đã đọc',
      ngay_tao: 'Ngày tạo'
    }
    
    const dataToExport = filteredNotifications.value.map(item => ({
      nguoi_nhan: item.nguoi_dung.ho_ten,
      email_nguoi_nhan: item.nguoi_dung.email,
      tieu_de: item.tieu_de,
      noi_dung: item.noi_dung,
      loai: getTypeText(item.loai),
      da_doc: item.da_doc ? 'Đã đọc' : 'Chưa đọc',
      ngay_tao: formatDateTime(item.ngay_tao)
    }))
    
    const formattedData = formatDataForExcel(dataToExport, headerMapping)
    
    const result = exportToExcel(
      formattedData,
      'Danh_sach_thong_bao',
      'Thông báo',
      { skipHeader: false }
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

// Initialize
const refreshData = () => {
  // Simulate data refresh  
}

onMounted(() => {
  const today = new Date()
  const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate())
  
  toDate.value = today.toISOString().split('T')[0]
  fromDate.value = lastMonth.toISOString().split('T')[0]
})
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/quanLyThongBao.css';
</style>
