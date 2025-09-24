<template>
  <div class="payment-result">
    <div class="result-card" :class="{ success: isSuccess, fail: !isSuccess }">
      <div class="result-header">
        <svg v-if="isSuccess" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2.5">
          <path d="M20 6L9 17l-5-5" />
        </svg>
        <svg v-else width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2.5">
          <circle cx="12" cy="12" r="10" />
          <line x1="15" y1="9" x2="9" y2="15" />
          <line x1="9" y1="9" x2="15" y2="15" />
        </svg>
        <h2>{{ isSuccess ? 'Thanh toán thành công' : 'Thanh toán thất bại' }}</h2>
        <span class="badge">VNPAY SANDBOX</span>
      </div>

      <div class="result-body">
        <div class="info-grid">
          <div class="info-item">
            <span class="label">Mã giao dịch</span>
            <span class="value">{{ transactionNo || '-' }}</span>
          </div>
          <div class="info-item">
            <span class="label">Mã đơn hàng (TxnRef)</span>
            <span class="value">{{ txnRef || '-' }}</span>
          </div>
          <div class="info-item">
            <span class="label">Số tiền</span>
            <span class="value">{{ formattedAmount }}</span>
          </div>
          <div class="info-item">
            <span class="label">Ngân hàng</span>
            <span class="value">{{ bankCode || '-' }}</span>
          </div>
          <div class="info-item">
            <span class="label">Thời gian</span>
            <span class="value">{{ formattedDate }}</span>
          </div>
          <div class="info-item">
            <span class="label">Nội dung</span>
            <span class="value">{{ orderInfo || '-' }}</span>
          </div>
        </div>
      </div>

      <div class="result-actions">
        <router-link class="btn primary" to="/sales/pos">Tiếp tục bán hàng</router-link>
        <router-link class="btn secondary" to="/sales/orders">Xem danh sách đơn</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const code = computed(() => route.query.code)
const txnRef = computed(() => route.query.txnRef)
const amount = computed(() => Number(route.query.amount || 0) / 100) // vnp_Amount/100
const bankCode = computed(() => route.query.bankCode)
const orderInfo = computed(() => route.query.orderInfo)
const transactionNo = computed(() => route.query.transactionNo)
const payDate = computed(() => route.query.payDate)

const isSuccess = computed(() => String(code.value) === '00')

const formattedAmount = computed(() => {
  const v = Number.isFinite(amount.value) ? amount.value : 0
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', minimumFractionDigits: 0 })
    .format(v)
    .replace('₫', ' VND')
})

const formattedDate = computed(() => {
  const raw = String(payDate.value || '')
  if (raw.length === 14) {
    // yyyyMMddHHmmss -> ISO-like
    const y = raw.slice(0, 4)
    const M = raw.slice(4, 6)
    const d = raw.slice(6, 8)
    const h = raw.slice(8, 10)
    const m = raw.slice(10, 12)
    const s = raw.slice(12, 14)
    return `${d}/${M}/${y} ${h}:${m}:${s}`
  }
  return raw || '-'
})
</script>

<style scoped>
.payment-result { display: flex; justify-content: center; padding: 32px; }
.result-card { width: 100%; max-width: 900px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; box-shadow: 0 4px 16px rgba(2,6,23,.06); }
.result-header { display: flex; align-items: center; gap: 12px; padding: 18px 20px; border-bottom: 1px solid #e2e8f0; }
.result-header h2 { margin: 0; font-size: 20px; font-weight: 800; color: #0f172a; }
.badge { margin-left: auto; padding: 3px 10px; border-radius: 999px; background: #ecfeff; color: #0e7490; border: 1px solid #a5f3fc; font-size: 11px; font-weight: 800; }
.result-body { padding: 16px 20px; }
.info-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 12px; }
.info-item { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 12px; }
.label { display: block; font-size: 12px; color: #64748b; margin-bottom: 4px; }
.value { font-weight: 700; color: #0f172a; word-break: break-word; }
.result-actions { padding: 16px 20px 20px; display: flex; gap: 12px; }
.btn { padding: 10px 14px; border-radius: 10px; text-decoration: none; font-weight: 700; border: 1px solid transparent; }
.btn.primary { background: #4ade80; color: #fff; box-shadow: 0 2px 6px rgba(74,222,128,0.35); }
.btn.secondary { background: #fff; color: #0f172a; border-color: #e2e8f0; }
.success .result-header svg { stroke: #16a34a; }
.fail .result-header svg { stroke: #ef4444; }
@media (max-width: 820px) { .info-grid { grid-template-columns: repeat(2, minmax(0,1fr)); } }
@media (max-width: 560px) { .info-grid { grid-template-columns: 1fr; } }
</style>
