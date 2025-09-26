<template>
  <div class="discount-form-page">
    <div class="card">
      <div class="card-header">
        <div class="table-header-content">
          <h3 class="table-title">{{ isEdit ? 'Cập nhật phiếu giảm giá' : 'Tạo phiếu giảm giá' }}</h3>
          <div class="table-actions">
            <button class="btn btn-outline btn-sm" @click="router.back()">
              Quay lại
            </button>
          </div>
        </div>
      </div>

      <div class="card-body">
        <form class="edit-form" @submit.prevent="onSave">
          <div class="detail-row">
            <div class="detail-label">
              <img :src="ClipboardIcon" alt="Basic Info" class="icon-svg" />
              Tên phiếu giảm giá
            </div>
            <div class="detail-value">
              <input
                type="text"
                v-model="couponForm.tenPhieuGiamGia"
                class="detail-input"
                placeholder="Nhập tên phiếu giảm giá"
                required
              />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="TagIcon" alt="Discount Type" class="icon-svg" />
              Kiểu giảm giá
            </div>
            <div class="detail-value">
              <select v-model="couponForm.loaiPhieuGiamGia" class="detail-input" required>
                <option :value="false">Phần trăm (%)</option>
                <option :value="true">Số tiền cố định (VND)</option>
              </select>
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="MoneyIcon" alt="Discount Value" class="icon-svg" />
              Giá trị giảm
            </div>
            <div class="detail-value">
              <input
                type="number"
                v-model.number="couponForm.giaTriGiamGia"
                class="detail-input"
                :class="{ 'form-error': showDiscountError }"
                :placeholder="!couponForm.loaiPhieuGiamGia ? 'Nhập % giảm (1-100)' : 'Nhập số tiền'"
                :min="!couponForm.loaiPhieuGiamGia ? 1 : 1000"
                :max="!couponForm.loaiPhieuGiamGia ? 100 : undefined"
                @input="validateDiscountValue"
                required
              />
              <div v-if="showDiscountError" class="detail-error">
                <p>Giảm giá phần trăm không được vượt quá 100%</p>
              </div>
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="HashIcon" alt="Quantity" class="icon-svg" />
              Số lượng sử dụng
            </div>
            <div class="detail-value">
              <input
                type="number"
                v-model.number="couponForm.soLuongDung"
                class="detail-input"
                placeholder="Nhập số lượng"
                min="1"
                required
              />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="CalendarIcon" alt="Start Date" class="icon-svg" />
              Ngày bắt đầu
            </div>
            <div class="detail-value">
              <DatePickerPopup v-model="couponForm.ngayBatDau" withTime returnType="datetime" />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="CalendarIcon" alt="End Date" class="icon-svg" />
              Ngày kết thúc
            </div>
            <div class="detail-value">
              <DatePickerPopup v-model="couponForm.ngayKetThuc" withTime returnType="datetime" />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="DollarIcon" alt="Min Order" class="icon-svg" />
              Hóa đơn tối thiểu
            </div>
            <div class="detail-value">
              <input
                type="text"
                :value="formattedHoaDonToiThieu"
                @input="handleNumberInput($event, 'hoaDonToiThieu')"
                class="detail-input"
                placeholder="Nhập giá trị đơn hàng tối thiểu (VNĐ)"
              />
            </div>
          </div>

          <div class="detail-row" v-if="!couponForm.loaiPhieuGiamGia">
            <div class="detail-label">
              <img :src="DollarIcon" alt="Max Discount" class="icon-svg" />
              Giảm tối đa
            </div>
            <div class="detail-value">
              <input
                type="text"
                :value="formattedSoTienToiDa"
                @input="handleNumberInput($event, 'soTienToiDa')"
                class="detail-input"
                placeholder="Số tiền giảm tối đa (VNĐ)"
              />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="UsersIcon" alt="Target" class="icon-svg" />
              Loại phiếu
            </div>
            <div class="detail-value">
              <select v-model="couponForm.idKhachHang" class="detail-input">
                <option :value="null">Công khai (tất cả khách hàng)</option>
                <option value="personal">Áp dụng cho khách hàng cụ thể</option>
              </select>
            </div>
          </div>

          <div class="detail-row" v-if="couponForm.idKhachHang === 'personal'">
            <div class="detail-label">
              <img :src="UsersIcon" alt="Customers" class="icon-svg" />
              Khách hàng
            </div>
            <div class="detail-value">
              <div class="customer-selection-wrapper">
                <div class="customer-search">
                  <input
                    type="text"
                    class="detail-input"
                    placeholder="Tìm kiếm khách hàng..."
                    v-model="searchCustomerQuery"
                  />
                </div>
                <div class="customer-actions">
                  <button type="button" class="btn btn-outline btn-sm" @click="selectAllCustomers">
                    Chọn hết
                  </button>
                  <button type="button" class="btn btn-outline btn-sm" @click="clearAllCustomers">
                    Bỏ chọn hết
                  </button>
                </div>
                <div class="customer-list customer-card-grid">
                  <label
                    v-for="customer in availableCustomers"
                    :key="customer.id"
                    :class="['customer-card', { 'selected': selectedCustomers.includes(customer.id) }]"
                  >
                    <input
                      type="checkbox"
                      class="customer-card-checkbox"
                      :checked="selectedCustomers.includes(customer.id)"
                      @change="toggleCustomerSelection(customer.id)"
                    />
                    <div class="customer-card-body">
                      <div class="customer-avatar">{{ getCustomerInitials(customer.tenKhachHang) }}</div>
                      <div class="customer-card-info">
                        <div class="customer-name">{{ customer.tenKhachHang }}</div>
                        <div class="customer-card-meta">
                          <div class="customer-chip">
                            <span class="customer-chip-label">Email</span>
                            <span class="customer-chip-value">{{ customer.email || 'Chưa cập nhật' }}</span>
                          </div>
                          <div class="customer-chip">
                            <span class="customer-chip-label">SĐT</span>
                            <span class="customer-chip-value">{{ customer.soDienThoai || 'Chưa cập nhật' }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </label>
                </div>
                <div v-if="selectedCustomers.length > 0" class="customer-summary">
                  Đã chọn {{ selectedCustomers.length }} khách hàng
                </div>
              </div>
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="FileTextIcon" alt="Description" class="icon-svg" />
              Mô tả
            </div>
            <div class="detail-value">
              <textarea
                v-model="couponForm.moTa"
                class="detail-input"
                rows="3"
                placeholder="Nhập mô tả phiếu giảm giá"
                style="resize: vertical; min-height: 80px;"
              ></textarea>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="btn btn-secondary" @click="router.push('/marketing/discounts')">
              Hủy
            </button>
            <button type="submit" class="btn btn-primary">
              {{ isEdit ? 'Cập nhật' : 'Tạo mới' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DatePickerPopup from '@/components/common/DatePickerPopup.vue'
import ClipboardIcon from '@/assets/Clipboard.svg?url'
import TagIcon from '@/assets/TagLabel.svg?url'
import MoneyIcon from '@/assets/Money.svg?url'
import DollarIcon from '@/assets/Money.svg?url'
import UsersIcon from '@/assets/Users.svg?url'

import { fetchAllKhachHang } from '@/services/KhachHang/KhachHangService.js'
import { dichVuPhieuGiamGia } from '@/services/GiamGia/dichVuPhieuGiamGia.js'
import { fetchCreatePhieuGiamGia, fetchUpdatePhieuGiamGia } from '@/services/GiamGia/PhieuGiamGiaService.js'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => !!route.params.id)

const couponForm = ref({
  maPhieuGiamGia: '',
  tenPhieuGiamGia: '',
  moTa: '',
  loaiPhieuGiamGia: false, // false = %, true = VND
  giaTriGiamGia: 0,
  hoaDonToiThieu: 0,
  soTienToiDa: 0,
  soLuongDung: 1,
  ngayBatDau: '',
  ngayKetThuc: '',
  trangThai: true,
  deleted: false,
  idKhachHang: null,
})

const customers = ref([])
const searchCustomerQuery = ref('')
const selectedCustomers = ref([])

const showDiscountError = ref(false)

const availableCustomers = computed(() => {
  let list = customers.value
  const q = searchCustomerQuery.value.trim().toLowerCase()
  if (q) {
    list = list.filter(c => (c.tenKhachHang || '').toLowerCase().includes(q) || (c.email || '').toLowerCase().includes(q) || (c.soDienThoai || '').includes(q))
  }
  return list
})

const formattedHoaDonToiThieu = computed({
  get() {
    return formatNumberInput(couponForm.value.hoaDonToiThieu)
  },
  set(value) {
    couponForm.value.hoaDonToiThieu = parseNumberInput(value)
  }
})

const formattedSoTienToiDa = computed({
  get() {
    return formatNumberInput(couponForm.value.soTienToiDa)
  },
  set(value) {
    couponForm.value.soTienToiDa = parseNumberInput(value)
  }
})

function validateDiscountValue() {
  if (!couponForm.value.loaiPhieuGiamGia) {
    showDiscountError.value = Number(couponForm.value.giaTriGiamGia) > 100
  } else {
    showDiscountError.value = false
  }
}

function handleNumberInput(event, fieldName) {
  const input = event.target
  const rawValue = input.value.replace(/\./g, '')
  const numericValue = parseInt(rawValue) || 0
  couponForm.value[fieldName] = numericValue
  input.value = numericValue > 0 ? formatNumberInput(numericValue) : ''
}

function formatNumberInput(value) {
  if (!value || value === 0) return ''
  return new Intl.NumberFormat('vi-VN').format(value)
}

function parseNumberInput(value) {
  if (!value) return 0
  return parseInt(value.toString().replace(/\./g, '')) || 0
}

function getCustomerInitials(name) {
  if (!name) return '?'
  return name.split(' ').filter(Boolean).slice(0, 2).map(p => p.charAt(0).toUpperCase()).join('')
}

function toggleCustomerSelection(customerId) {
  const i = selectedCustomers.value.indexOf(customerId)
  if (i > -1) selectedCustomers.value.splice(i, 1)
  else selectedCustomers.value.push(customerId)
}
function selectAllCustomers() {
  selectedCustomers.value = availableCustomers.value.map(c => c.id)
}
function clearAllCustomers() {
  selectedCustomers.value = []
}

async function loadCustomers() {
  try {
    const res = await fetchAllKhachHang()
    customers.value = res.data || []
  } catch (e) {
    console.error('Error loading customers', e)
  }
}

async function loadCouponForEdit(id) {
  try {
    const list = await dichVuPhieuGiamGia.layTatCa()
    const found = Array.isArray(list) ? list.find(c => String(c.id) === String(id)) : null
    if (found) {
      couponForm.value = {
        ...couponForm.value,
        maPhieuGiamGia: found.maPhieuGiamGia || '',
        tenPhieuGiamGia: found.tenPhieuGiamGia || '',
        moTa: found.moTa || '',
        loaiPhieuGiamGia: !!found.loaiPhieuGiamGia,
        giaTriGiamGia: found.giaTriGiamGia || 0,
        hoaDonToiThieu: found.hoaDonToiThieu || 0,
        soTienToiDa: found.soTienToiDa || 0,
        soLuongDung: found.soLuongDung || 1,
        ngayBatDau: found.ngayBatDau || '',
        ngayKetThuc: found.ngayKetThuc || '',
        trangThai: Boolean(found.trangThai),
        deleted: false,
        idKhachHang: (found.idKhachHang && found.idKhachHang.length > 0) ? 'personal' : null,
      }
      if (Array.isArray(found.idKhachHang)) selectedCustomers.value = [...found.idKhachHang]
    }
  } catch (e) {
    console.error('Error loading coupon for edit', e)
  }
}

async function onSave() {
  // basic validation
  if (!couponForm.value.tenPhieuGiamGia.trim()) return
  if (!couponForm.value.ngayBatDau || !couponForm.value.ngayKetThuc) return

  const payload = {
    ...couponForm.value,
    idKhachHang: couponForm.value.idKhachHang === 'personal' ? [...selectedCustomers.value] : [],
    deleted: false,
  }

  try {
    if (isEdit.value) {
      await fetchUpdatePhieuGiamGia(route.params.id, payload)
    } else {
      await fetchCreatePhieuGiamGia(payload)
    }
    router.push('/marketing/discounts')
  } catch (e) {
    console.error('Save coupon failed', e)
  }
}

onMounted(async () => {
  await loadCustomers()
  if (isEdit.value) await loadCouponForEdit(route.params.id)
})
</script>

<style scoped>
@import "@/styles/cssSanPham/productsUnified.css";
.discount-form-page { padding: 20px; }
.card { background: #fff; border-radius: 12px; box-shadow: 0 8px 32px rgba(5,5,5,.06); }
.card-body { padding: 20px; }
.detail-row { display: grid; grid-template-columns: 220px 1fr; gap: 16px; align-items: start; margin-bottom: 14px; }
.detail-label { display: flex; align-items: center; gap: 8px; font-weight: 600; color: #111827; }
.detail-value { display: block; }
.detail-input { width: 100%; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 8px; font-size: 14px; }
.form-error { border-color: #ef4444; }
.customer-selection-wrapper { display: grid; gap: 12px; }
/* Ensure both class names are supported */
.customer-actions,
.customers-action { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; margin: 8px 0; }
.customer-selection-wrapper .customer-actions,
.customer-selection-wrapper .customers-action { justify-content: center; flex-wrap: wrap; gap: 12px; margin: 8px 0; padding: 0; }
/* Button styles inside actions */
.customer-actions .btn { padding: 0.65rem 1.75rem; min-width: 120px; border-radius: 999px; font-weight: 600; letter-spacing: 0.3px; transition: all 0.2s ease; }
/* Force readable text color for outline buttons within the customer actions area */
.detail-value .customer-selection-wrapper .customer-actions .btn.btn-outline,
.detail-value .customer-selection-wrapper .customers-action .btn.btn-outline,
.customer-actions .btn.btn-outline,
.customers-action .btn.btn-outline { background: linear-gradient(135deg, rgba(236,253,245,0.82) 0%, rgba(219,234,254,0.76) 100%) !important; color: #15803d !important; border: 1.5px solid rgba(34,197,94,0.65) !important; box-shadow: 0 16px 32px -20px rgba(34,197,94,0.45) !important; }
.customer-actions .btn.btn-outline:hover,
.customers-action .btn.btn-outline:hover { background: linear-gradient(135deg, rgba(34,197,94,0.92) 0%, rgba(22,163,74,0.92) 100%) !important; color: #ffffff !important; transform: translateY(-2px); box-shadow: 0 20px 40px -22px rgba(22,163,74,0.6) !important; }
.customer-actions .btn.btn-outline:focus-visible,
.customers-action .btn.btn-outline:focus-visible { outline: none !important; box-shadow: 0 0 0 4px rgba(74,222,128,0.25) !important; }
.customer-card-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px,1fr)); gap: 10px; }
.customer-card { border: 1px solid #e5e7eb; border-radius: 10px; padding: 10px; display: grid; grid-template-columns: 1fr; gap: 8px; cursor: pointer; }
.customer-card.selected { border-color: #4ade80; }
.customer-card-body { display: grid; grid-template-columns: 44px 1fr; gap: 10px; align-items: center; }
.customer-avatar { width: 44px; height: 44px; border-radius: 8px; background: #f3f4f6; display: grid; place-items: center; font-weight: 700; color: #111827; }
.customer-chip { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 6px; padding: 2px 6px; font-size: 12px; color: #374151; display: inline-flex; gap: 6px; margin-right: 6px; }
.form-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 16px; }
</style>
