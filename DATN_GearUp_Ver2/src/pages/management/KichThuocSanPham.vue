<template>
  <div class="product-sizes">
    <!-- Page Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Quản lý Kích cỡ</h1>
          <p class="page-subtitle">Quản lý danh sách size và kích cỡ sản phẩm</p>
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
          <button class="btn-export" @click="exportSizesToExcel">
            <span class="btn-icon"><!-- icon: excel --></span>
            Xuất Excel
          </button>
          <button class="btn-export" @click="showAddModal = true">
            <span class="btn-icon"><!-- icon: plus --></span>
            Thêm đế giày
          </button>
        </div>
      </div>
    </div>

    <!-- Modern Filter Section -->
    <div class="filter-section">
      <div class="filter-card">
        <div class="filter-header">
          <div class="filter-title">
            <span class="filter-icon"><!-- icon: product --></span>
            <h3>Tìm kiếm kích cỡ</h3>
          </div>
          <div class="filter-stats">
            {{ filteredSizes.length }} / {{ sizes.length }} kích cỡ
          </div>
        </div>
        
        <div class="filter-content">
          <div class="search-section">
            <div class="input-group">
              <span class="input-icon"><!-- icon: search --></span>
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Tìm kiếm tên đế giày, mô tả..."
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
                <span class="label-icon">🧪</span>
                Chất liệu
              </label>
              <select v-model="materialFilter" class="form-select">
                <option value="">Tất cả chất liệu</option>
                <option value="rubber">🔧 Cao su</option>
                <option value="eva">✨ EVA</option>
                <option value="pu">💎 PU</option>
                <option value="tpr"><!-- icon: settings --> TPR</option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">
                <span class="label-icon">⚡</span>
                Trạng thái
              </label>
              <select v-model="statusFilter" class="form-select">
                <option value="">Tất cả trạng thái</option>
                <option value="active"><!-- icon: check --> Hoạt động</option>
                <option value="inactive"><!-- icon: close --> Ngừng hoạt động</option>
              </select>
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

    <!-- Sizes Table -->
    <div class="card">
      <div class="card-body">
        <table class="table">
          <thead>
            <tr>
              <th>STT</th>
              <th>Mã đế</th>
              <th>Tên đế giày</th>
              <th>Chất liệu</th>
              <th>Độ dày (mm)</th>
              <th>Trạng thái</th>
              <th>Ngày tạo</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(size, index) in filteredSizes" :key="size.id">
              <td>{{ index + 1 }}</td>
              <td class="sole-code">{{ size.code }}</td>
              <td class="sole-name">{{ size.name }}</td>
              <td>
                <span class="badge badge-info">
                  {{ getMaterialText(size.material) }}
                </span>
              </td>
              <td>
                <div class="thickness-indicator">
                  <div class="thickness-bar">
                    <div class="thickness-fill" :style="{height: (size.thickness / 50 * 100) + '%'}"></div>
                  </div>
                  <span class="thickness-value">{{ size.thickness }}mm</span>
                </div>
              </td>
              <td>
                <span class="badge" :class="size.status === 'active' ? 'badge-success' : 'badge-danger'">
                  {{ size.status === 'active' ? 'Hoạt động' : 'Ngừng hoạt động' }}
                </span>
              </td>
              <td>{{ formatDate(size.created_at) }}</td>
              <td>
                <ButtonGroup spacing="xs">
                  <button class="btn btn-secondary" @click="editSize(size)">
                    <span class="btn-icon"><!-- icon: edit --></span>
                    Sửa
                  </button>
                  <button class="btn btn-danger" @click="deleteSize(size.id)">
                    <span class="btn-icon"><!-- icon: delete --></span>
                    Xóa
                  </button>
                </ButtonGroup>
              </td>
            </tr>
            <tr v-if="filteredSizes.length === 0">
              <td colspan="8" class="text-center">Không có dữ liệu</td>
            </tr>
          </tbody>
        </table>
        
        <!-- Pagination -->
        <div class="pagination-wrapper">
          <div class="pagination-info">
            Xem {{ Math.min(10, filteredSizes.length) }} đế giày
          </div>
          <div class="pagination">
            <button class="btn btn-secondary" disabled>
              <span class="btn-icon">❮</span>
            </button>
            <span class="page-info">1</span>
            <button class="btn btn-secondary" disabled>
              <span class="btn-icon">❯</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Add/Edit Modal -->
    <div v-if="showAddModal || showEditModal" class="modal-overlay" @click="closeModals">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ showAddModal ? 'Thêm đế giày' : 'Cập nhật đế giày' }}</h3>
          <button class="modal-close" @click="closeModals">×</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label class="form-label">Mã đế giày *</label>
            <input
              v-model="formData.code"
              type="text"
              class="form-control"
              placeholder="Nhập mã đế giày"
            />
          </div>

          <div class="form-group">
            <label class="form-label">Tên đế giày *</label>
            <input
              v-model="formData.name"
              type="text"
              class="form-control"
              placeholder="Nhập tên đế giày"
            />
          </div>

          <div class="form-group">
            <label class="form-label">Chất liệu *</label>
            <select v-model="formData.material" class="form-control">
              <option value="">Chọn chất liệu</option>
              <option value="rubber">Cao su</option>
              <option value="eva">EVA</option>
              <option value="pu">PU</option>
              <option value="tpr">TPR</option>
              <option value="leather">Da</option>
              <option value="fabric">Vải</option>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label">Độ dày (mm)</label>
            <input
              v-model.number="formData.thickness"
              type="range"
              min="5"
              max="50"
              step="1"
              class="form-range"
            />
            <div class="range-value">{{ formData.thickness }}mm</div>
          </div>
          
          <div class="form-group">
            <label class="form-label">Mô tả</label>
            <textarea
              v-model="formData.description"
              class="form-control"
              rows="3"
              placeholder="Nhập mô tả đế giày"
            ></textarea>
          </div>
          
          <div class="form-group">
            <label class="form-label">Trạng thái</label>
            <select v-model="formData.status" class="form-control">
              <option value="active">Hoạt động</option>
              <option value="inactive">Ngừng hoạt động</option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeModals">
            <span class="btn-icon"><!-- icon: close --></span>
            Hủy
          </button>
          <button class="btn btn-primary" @click="saveSize">
            <span class="btn-icon"><!-- icon: save --></span>
            {{ showAddModal ? 'Thêm' : 'Cập nhật' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { exportToExcel, formatDataForExcel } from '../../utils/xuatExcel.js'
import ActionButton from '@/components/ui/NutHanhDong.vue'
import ButtonGroup from '@/components/ui/NhomNut.vue'

// Reactive data
const searchQuery = ref('')
const statusFilter = ref('')
const materialFilter = ref('')
const showAddModal = ref(false)
const showEditModal = ref(false)
const editingSize = ref(null)

const formData = ref({
  code: '',
  name: '',
  material: '',
  thickness: 20,
  description: '',
  status: 'active'
})

// Mock data
const sizes = ref([])
  
// Computed
const filteredSizes = computed(() => {
  return sizes.value.filter(size => {
    const matchesSearch = size.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                         size.code.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesStatus = !statusFilter.value || size.status === statusFilter.value
    const matchesMaterial = !materialFilter.value || size.material === materialFilter.value
    return matchesSearch && matchesStatus && matchesMaterial
  })
})

// Methods
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('vi-VN')
}

const getMaterialText = (material) => {
  const materialMap = {
    'rubber': 'Cao su',
    'eva': 'EVA',
    'pu': 'PU',
    'tpr': 'TPR',
    'leather': 'Da',
    'fabric': 'Vải'
  }
  return materialMap[material] || material
}

const editSize = (size) => {
  editingSize.value = size
  formData.value = { ...size }
  showEditModal.value = true
}

const deleteSize = (id) => {
  if (confirm('Bạn có chắc chắn muốn xóa đế giày này?')) {
    const index = sizes.value.findIndex(s => s.id === id)
    if (index > -1) {
      sizes.value.splice(index, 1)
    }
  }
}

const saveSize = () => {
  if (!formData.value.code.trim() || !formData.value.name.trim() || !formData.value.material) {
    alert('Vui lòng nhập đầy đủ thông tin bắt buộc')
    return
  }

  if (showAddModal.value) {
    const newSize = {
      ...formData.value,
      id: Date.now(),
      created_at: new Date().toISOString()
    }
    sizes.value.unshift(newSize)
  } else if (showEditModal.value && editingSize.value) {
    const index = sizes.value.findIndex(s => s.id === editingSize.value.id)
    if (index > -1) {
      sizes.value[index] = { ...editingSize.value, ...formData.value }
    }
  }

  closeModals()
}

const closeModals = () => {
  showAddModal.value = false
  showEditModal.value = false
  editingSize.value = null
  formData.value = {
    code: '',
    name: '',
    material: '',
    thickness: 20,
    description: '',
    status: 'active'
  }
}

const refreshData = () => {
  // Simulate data refresh
}

const exportData = () => {
  alert('Chức năng xuất báo cáo đang được phát triển')
}

const exportSizesToExcel = () => {
  try {
    const headerMapping = {
      'code': 'Mã đế giày',
      'name': 'Tên đế giày', 
      'material': 'Chất liệu',
      'thickness': 'Độ dày (mm)',
      'description': 'Mô tả',
      'status': 'Trạng thái'
    }
    
    const filteredData = filteredSizes.value.map(item => ({
      code: item.code || 'N/A',
      name: item.name || 'N/A',
      material: item.material || 'N/A',
      thickness: `${item.thickness || 20}mm`,
      description: item.description || 'N/A', 
      status: item.status === 'active' ? 'Hoạt động' : 'Ngừng hoạt động'
    }))
    
    const result = exportToExcel(filteredData, 'Product_Sizes', 'Danh sách kích cỡ sản phẩm', headerMapping)
    
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
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/kichThuocSanPham.css';
</style>
