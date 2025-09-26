<template>
  <div class="discount-form-page">
    <div class="card">
      <div class="card-header">
        <div class="table-header-content">
          <h3 class="table-title">{{ isEdit ? 'Cập nhật đợt giảm giá' : 'Tạo đợt giảm giá' }}</h3>
          <div class="table-actions">
            <button class="btn btn-outline btn-sm" @click="router.back()">Quay lại</button>
          </div>
        </div>
      </div>

      <div class="card-body">
        <form class="edit-form" @submit.prevent="onSave">
          <div class="detail-row">
            <div class="detail-label">
              <img :src="ClipboardIcon" alt="Name" class="icon-svg" />
              Tên đợt giảm giá
            </div>
            <div class="detail-value">
              <input type="text" v-model="form.tenDotGiamGia" class="detail-input" placeholder="Nhập tên đợt giảm giá" required />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="MoneyIcon" alt="Discount" class="icon-svg" />
              Giá trị giảm (%)
            </div>
            <div class="detail-value">
              <input type="number" v-model.number="form.giaTriGiamGia" class="detail-input" placeholder="Nhập % giảm (1-100)" min="1" max="100" required />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="DateIcon" alt="Start" class="icon-svg" />
              Ngày bắt đầu
            </div>
            <div class="detail-value">
              <DatePickerPopup v-model="form.ngayBatDau" :max="form.ngayKetThuc || ''" />
            </div>
          </div>

          <div class="detail-row">
            <div class="detail-label">
              <img :src="DateIcon" alt="End" class="icon-svg" />
              Ngày kết thúc
            </div>
            <div class="detail-value">
              <DatePickerPopup v-model="form.ngayKetThuc" :min="form.ngayBatDau || ''" />
            </div>
          </div>

          <div class="detail-row" v-if="isEdit">
            <div class="detail-label">
              <img :src="ChecklistIcon" alt="Status" class="icon-svg" />
              Trạng thái
            </div>
            <div class="detail-value">
              <select v-model="form.trangThai" class="detail-input">
                <option :value="true">Đang hoạt động</option>
                <option :value="false">Ngừng hoạt động</option>
              </select>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="btn btn-secondary" @click="router.push('/marketing/campaigns')">Hủy</button>
            <button type="submit" class="btn btn-primary">{{ isEdit ? 'Cập nhật' : 'Tạo mới' }}</button>
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
import MoneyIcon from '@/assets/Money.svg?url'
import DateIcon from '@/assets/Date.svg?url'
import ChecklistIcon from '@/assets/Checklist.svg?url'

import { fetchAllDotGiamGia, fetchCreateDotGiamGia, fetchUpdateDotGiamGia } from '@/services/GiamGia/DotGiamGiaService.js'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => !!route.params.id)

const form = ref({
  tenDotGiamGia: '',
  giaTriGiamGia: 0,
  ngayBatDau: '',
  ngayKetThuc: '',
  trangThai: true,
  deleted: false,
})

async function loadForEdit(id) {
  try {
    const res = await fetchAllDotGiamGia()
    const found = Array.isArray(res?.data) ? res.data.find(c => String(c.id) === String(id)) : null
    if (found) {
      form.value = {
        tenDotGiamGia: found.tenDotGiamGia || '',
        giaTriGiamGia: found.giaTriGiamGia || 0,
        ngayBatDau: found.ngayBatDau || '',
        ngayKetThuc: found.ngayKetThuc || '',
        trangThai: Boolean(found.trangThai),
        deleted: false,
      }
    }
  } catch (e) {
    console.error('Error loading campaign', e)
  }
}

function validate() {
  if (!form.value.tenDotGiamGia.trim()) return false
  if (!form.value.giaTriGiamGia || form.value.giaTriGiamGia < 1 || form.value.giaTriGiamGia > 100) return false
  if (!form.value.ngayBatDau || !form.value.ngayKetThuc) return false
  const s = new Date(form.value.ngayBatDau)
  const e = new Date(form.value.ngayKetThuc)
  if (e <= s) return false
  return true
}

async function onSave() {
  if (!validate()) return
  try {
    if (isEdit.value) {
      await fetchUpdateDotGiamGia(route.params.id, form.value)
    } else {
      await fetchCreateDotGiamGia(form.value)
    }
    router.push('/marketing/campaigns')
  } catch (e) {
    console.error('Save campaign failed', e)
  }
}

onMounted(async () => {
  if (isEdit.value) await loadForEdit(route.params.id)
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
.form-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 16px; }
.icon-svg { width: 16px; height: 16px; }
</style>
