<template>
  <div class="returns-management">
    <!-- Page Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Quản lý Đổi trả</h1>
          <p class="page-subtitle">Xử lý yêu cầu đổi trả sản phẩm từ khách hàng</p>
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
          <button class="btn-export" @click="exportReturnsToExcel">
            <span class="btn-icon"><!-- icon: excel --></span>
            Xuất Excel
          </button>
          <button class="btn-export" @click="scanQR">
            <span class="btn-icon"><!-- icon: phone --></span>
            Quét mã QR
          </button>
        </div>
      </div>
    </div>

    <!-- Search Section -->
    <div class="search-section">
      <div class="search-box">
        <div class="search-input">
          <span class="search-icon"><!-- icon: search --></span>
          <input 
            type="text" 
            placeholder="Mã hóa đơn:" 
            v-model="searchQuery"
            class="form-control"
          >
        </div>
        <button class="btn btn-primary" @click="searchOrder">TÌM KIẾM</button>
        <button class="btn btn-outline" @click="scanQR"><!-- icon: phone --> QUÉT MÃ</button>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="!selectedOrder" class="empty-state">
      <div class="empty-illustration">
        <div class="delivery-truck">
          <div class="truck-body">
            <div class="truck-cabin"></div>
            <div class="truck-cargo">
              <div class="package"><!-- icon: package --></div>
              <div class="package"><!-- icon: package --></div>
            </div>
          </div>
          <div class="truck-wheels">
            <div class="wheel"></div>
            <div class="wheel"></div>
          </div>
        </div>
        <div class="delivery-person"><!-- icon: user --></div>
      </div>
      <h3>TRẢ HÀNG</h3>
      <p>Nhập mã hóa đơn để bắt đầu quy trình trả hàng</p>
    </div>

    <!-- Return Form -->
    <div v-if="selectedOrder" class="return-form">
      <!-- Order Info -->
      <div class="order-info">
        <h3>Thông tin đơn hàng</h3>
        <div class="order-details">
          <div class="detail-item">
            <label>Mã đơn hàng:</label>
            <span>{{ selectedOrder.code }}</span>
          </div>
          <div class="detail-item">
            <label>Khách hàng:</label>
            <span>{{ selectedOrder.customerName }}</span>
          </div>
          <div class="detail-item">
            <label>Người nhận:</label>
            <span>{{ selectedOrder.receiverName || 'Địa chỉ 12' }}</span>
          </div>
          <div class="detail-item">
            <label>Địa chỉ:</label>
            <span>{{ selectedOrder.address || 'aaaaa, Xã Mường Giàng, Huyện Quỳnh Nhai, Sơn La' }}</span>
          </div>
        </div>
      </div>

      <!-- Return Products -->
      <div class="return-products">
        <h3>Chọn sản phẩm cần trả</h3>
        <div class="products-list">
          <div v-for="item in selectedOrder.items" :key="item.id" class="product-item">
            <div class="product-checkbox">
              <input 
                type="checkbox" 
                :id="'product-' + item.id"
                v-model="item.selected"
                @change="updateReturnTotal"
              >
            </div>
            <div class="product-image">
              <img v-if="item.image" :src="item.image" :alt="item.name">
              <div v-else class="placeholder-image"><!-- icon: product --></div>
            </div>
            <div class="product-info">
              <h4>{{ item.name }}</h4>
              <p class="product-details">Size: {{ item.size }}</p>
              <p class="product-quantity">Số lượng: {{ item.quantity }} / {{ item.quantity }}</p>
            </div>
            <div class="product-controls">
              <div class="quantity-selector">
                <button 
                  @click="decreaseQuantity(item)" 
                  :disabled="!item.selected || item.returnQuantity <= 0"
                  class="qty-btn"
                >
                  -
                </button>
                <span class="quantity">{{ item.returnQuantity || 0 }}</span>
                <button 
                  @click="increaseQuantity(item)" 
                  :disabled="!item.selected || item.returnQuantity >= item.quantity"
                  class="qty-btn"
                >
                  +
                </button>
              </div>
              <div class="item-total">{{ formatCurrency(item.price) }}</div>
            </div>
          </div>
        </div>

        <!-- Return Summary -->
        <div v-if="hasSelectedItems" class="return-summary">
          <h4><!-- icon: refresh --> Danh sách sản phẩm trả</h4>
          <div class="summary-items">
            <div v-for="item in selectedItems" :key="'return-' + item.id" class="summary-item">
              <span class="item-name">{{ item.name }}</span>
              <span class="item-quantity">x{{ item.returnQuantity }}</span>
              <span class="item-price">{{ formatCurrency(item.price * item.returnQuantity) }}</span>
            </div>
          </div>
          
          <div class="summary-totals">
            <div class="total-row">
              <span>Tổng tiền</span>
              <span class="total-amount">{{ formatCurrency(returnTotal) }}</span>
            </div>
            <div class="total-row">
              <span>Giảm giá</span>
              <span class="discount-amount">{{ formatCurrency(returnDiscount) }}</span>
            </div>
            <div class="total-row final">
              <span>Số tiền hoàn trả</span>
              <span class="refund-amount">{{ formatCurrency(refundAmount) }}</span>
            </div>
          </div>
        </div>

        <!-- Customer Info -->
        <div class="customer-section">
          <h4><!-- icon: clipboard --> Thông tin hoàn trả</h4>
          <div class="customer-info">
            <div class="info-item">
              <span class="info-label"><!-- icon: user --> Khách hàng:</span>
              <span class="info-value">{{ selectedOrder.customerName }}</span>
            </div>
            <div class="info-item">
              <span class="info-label"><!-- icon: users --> Người nhận:</span>
              <span class="info-value">{{ selectedOrder.receiverName || 'Địa chỉ 12' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label"><!-- icon: location --> Địa chỉ:</span>
              <span class="info-value">{{ selectedOrder.address || 'aaaaa, Xã Mường Giàng, Huyện Quỳnh Nhai, Sơn La' }}</span>
            </div>
          </div>
          
          <div class="return-totals">
            <div class="total-item">
              <span>Tổng tiền:</span>
              <span class="amount">{{ formatCurrency(returnTotal) }}</span>
            </div>
            <div class="total-item">
              <span>Giảm giá:</span>
              <span class="amount discount">{{ formatCurrency(returnDiscount) }}</span>
            </div>
            <div class="total-item final">
              <span>Số tiền hoàn trả:</span>
              <span class="amount refund">{{ formatCurrency(refundAmount) }}</span>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div v-if="hasSelectedItems" class="action-buttons">
          <button class="btn btn-primary btn-lg" @click="processReturn">
            <!-- icon: refresh --> TRẢ HÀNG
          </button>
        </div>
      </div>
    </div>

    <!-- Success Modal -->
    <div v-if="showSuccessModal" class="modal-overlay" @click="showSuccessModal = false">
      <div class="modal-content success" @click.stop>
        <div class="modal-body">
          <div class="success-icon"><!-- icon: check --></div>
          <h3>Trả hàng thành công!</h3>
          <p>Số tiền hoàn trả: <strong>{{ formatCurrency(refundAmount) }}</strong></p>
          <button class="btn btn-primary" @click="resetForm">OK</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { exportToExcel, formatDataForExcel } from '../../utils/xuatExcel.js'
import { 
  notifyOrderUpdated, 
  triggerCustomNotification,
  notifySystemReport 
} from '../../services/response/dichVuThongBao.js'

// Data
const searchQuery = ref('')
const selectedOrder = ref(null)
const showSuccessModal = ref(false)

const mockOrders = {}

// Computed
const hasSelectedItems = computed(() => {
  return selectedOrder.value?.items.some(item => item.selected && item.returnQuantity > 0)
})

const selectedItems = computed(() => {
  if (!selectedOrder.value) return []
  return selectedOrder.value.items.filter(item => item.selected && item.returnQuantity > 0)
})

const returnTotal = computed(() => {
  return selectedItems.value.reduce((total, item) => {
    return total + (item.price * item.returnQuantity)
  }, 0)
})

const returnDiscount = computed(() => {
  if (!selectedOrder.value || returnTotal.value === 0) return 0
  
  // Calculate proportional discount
  const discountRate = selectedOrder.value.discount / selectedOrder.value.totalAmount
  return Math.round(returnTotal.value * discountRate)
})

const refundAmount = computed(() => {
  return returnTotal.value - returnDiscount.value
})

// Methods
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
    minimumFractionDigits: 0
  }).format(amount).replace('₫', ' VND')
}

const searchOrder = () => {
  if (searchQuery.value.trim()) {
    const orderCode = searchQuery.value.toUpperCase()
    const foundOrder = mockOrders[orderCode]
    
    if (foundOrder) {
      // Create a deep copy of the found order
      selectedOrder.value = JSON.parse(JSON.stringify(foundOrder))
      // Reset return quantities
      selectedOrder.value.items.forEach(item => {
        item.returnQuantity = 0
        item.selected = false
      })
    } else {
      alert('Không tìm thấy đơn hàng với mã: ' + orderCode)
      selectedOrder.value = null
    }
  } else {
    alert('Vui lòng nhập mã hóa đơn')
  }
}

const scanQR = () => {
  // Simulate QR scan
  alert('Chức năng quét QR sẽ được cập nhật trong phiên bản tiếp theo')
}

const increaseQuantity = (item) => {
  if (item.returnQuantity < item.quantity) {
    item.returnQuantity++
    updateReturnTotal()
  }
}

const decreaseQuantity = (item) => {
  if (item.returnQuantity > 0) {
    item.returnQuantity--
    if (item.returnQuantity === 0) {
      item.selected = false
    }
    updateReturnTotal()
  }
}

const updateReturnTotal = () => {
  // Auto-set return quantity when item is selected
  selectedOrder.value.items.forEach(item => {
    if (item.selected && item.returnQuantity === 0) {
      item.returnQuantity = 1
    }
    if (!item.selected) {
      item.returnQuantity = 0
    }
  })
}

const processReturn = () => {
  if (!hasSelectedItems.value) {
    alert('Vui lòng chọn ít nhất một sản phẩm để trả hàng')
    return
  }
  
  // Process return logic here
  // TODO: Add actual API call to process return
  // Only trigger notification after successful API response
  
  showSuccessModal.value = true
  
  // Example: Only trigger notification after successful return processing
  // const orderId = selectedOrder.value.id
  // const returnValue = refundAmount.value
  // const itemCount = selectedItems.value.length
  //
  // triggerCustomNotification({
  //   title: 'Trả hàng thành công',
  //   message: `Đơn hàng #${orderId} đã được trả ${itemCount} sản phẩm. Hoàn tiền: ${returnValue.toLocaleString('vi-VN')}đ`,
  //   icon: '<!-- icon: refresh -->',
  //   type: 'order'
  // })
}

const resetForm = () => {
  selectedOrder.value = null
  searchQuery.value = ''
  showSuccessModal.value = false
}

const refreshData = () => {
  // Simulate data refresh
}

const exportReturnsToExcel = () => {
  try {
    const headerMapping = {
      'orderCode': 'Mã đơn hàng',
      'customerName': 'Khách hàng',
      'phone': 'Số điện thoại',
      'returnDate': 'Ngày đổi trả',
      'reason': 'Lý do',
      'status': 'Trạng thái',
      'total': 'Tổng tiền'
    }
    
    const data = selectedOrder.value ? [selectedOrder.value] : []
    const filteredData = data.map(item => ({
      orderCode: item.order_code || 'N/A',
      customerName: item.customer_name || 'N/A',
      phone: item.phone || 'N/A',
      returnDate: new Date().toLocaleDateString('vi-VN'),
      reason: 'Đổi trả sản phẩm',
      status: 'Đã xử lý',
      total: item.total ? new Intl.NumberFormat('vi-VN').format(item.total) + ' đ' : 'N/A'
    }))
    
    const result = exportToExcel(filteredData, 'Returns_Data', 'Dữ liệu đổi trả', headerMapping)
    
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

// No auto search - start with empty state
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/quanLyTraHang.css';
</style>
