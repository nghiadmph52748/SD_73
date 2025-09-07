<template>
  <div class="order-management">
    <!-- Advanced Filters -->
    <div class="filters-panel">
      <div class="filters-header">
        <h3>Bộ lọc & Tìm kiếm</h3>
        <button class="btn-export" @click="resetFilters">
          <span class="btn-icon"><img :src="RefreshIcon" alt="Refresh" class="icon-sm" /></span>
          Đặt lại
        </button>
      </div>

      <div class="filters-content">
        <!-- Search Bar -->
        <div class="search-section">
          <div class="search-input-group">
            <div class="search-icon"></div>
            <input
              type="text"
              placeholder="Tìm theo mã đơn hàng, tên khách hàng, SĐT..."
              v-model="searchQuery"
              class="search-input"
            />
            <button
              v-if="searchQuery"
              class="clear-search"
              @click="searchQuery = ''"
            >
              ✕
            </button>
          </div>
        </div>

        <!-- Filter Grid -->
        <div class="filter-grid">
          <!-- Date Range -->
          <div class="filter-group">
            <label class="filter-label">Thời gian</label>
            <div class="date-range-group">
              <input
                type="date"
                v-model="fromDate"
                class="date-input"
                placeholder="Từ ngày"
              />
              <span class="date-separator">→</span>
              <input
                type="date"
                v-model="toDate"
                class="date-input"
                placeholder="Đến ngày"
              />
            </div>
          </div>

          <!-- Order Type -->
          <div class="filter-group">
            <label class="filter-label">Loại đơn hàng</label>
            <div class="radio-group">
              <label class="radio-option">
                <input type="radio" value="" v-model="selectedType" />
                <span class="radio-text">Tất cả</span>
              </label>
              <label class="radio-option">
                <input type="radio" value="online" v-model="selectedType" />
                <span class="radio-text">Trực tuyến</span>
              </label>
              <label class="radio-option">
                <input type="radio" value="pos" v-model="selectedType" />
                <span class="radio-text">Tại quầy</span>
              </label>
            </div>
          </div>

          <!-- Amount Range -->
          <div class="filter-group">
            <label class="filter-label">Khoảng giá</label>
            <div class="amount-range-group">
              <input
                type="number"
                v-model="minAmount"
                class="amount-input"
                placeholder="Từ"
              />
              <span class="amount-separator">-</span>
              <input
                type="number"
                v-model="maxAmount"
                class="amount-input"
                placeholder="Đến"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Status Tabs with Improved Design -->
    <div class="status-tabs-container">
      <div class="status-tabs">
        <button
          v-for="status in statusTabs"
          :key="status.value"
          :class="['status-tab', { active: selectedStatus === status.value }]"
          @click="selectedStatus = status.value"
        >
          <span class="tab-icon"><img :src="status.iconComponent" alt="Status icon" class="icon-sm" /></span>
          <span class="tab-text">{{ status.label }}</span>
          <span class="tab-count">{{ getStatusCount(status.value) }}</span>
        </button>
      </div>

      <div class="view-options">
        <button
          :class="['view-btn', { active: viewMode === 'table' }]"
          @click="viewMode = 'table'"
          title="Xem dạng bảng"
        >
          <img :src="ClipboardIcon" alt="Clipboard" class="icon-sm" />
        </button>
        <button
          :class="['view-btn', { active: viewMode === 'grid' }]"
          @click="viewMode = 'grid'"
          title="Xem dạng lưới"
        >
          <img :src="DashboardIcon" alt="Grid view" class="icon-sm" />
        </button>
      </div>
    </div>
       <!-- Header Actions bên góc phải -->
<div class="header-actions">
  <button class="btn-action" @click="refreshData">
    <img :src="RefreshIcon" alt="Refresh" class="icon-sm" />
    <span>Làm mới</span>
  </button>

  <button class="btn-action" @click="exportData">
    <img :src="StatisticsIcon" alt="Chart" class="icon-sm" />
    <span>Xuất báo cáo</span>
  </button>

  <button class="btn-action" @click="exportOrdersToExcel">
    <img :src="ExcelIcon" alt="Excel" class="icon-sm" />
    <span>Xuất Excel</span>
  </button>

  <button class="btn-action primary" @click="createOrder">
    <img :src="PlusIcon" alt="Plus" class="icon-sm" />
    <span>Tạo đơn hàng</span>
  </button>

  <button class="btn-action" @click="scanQRCode">
    <img :src="QRIcon" alt="QR Code" class="icon-sm" />
    <span>Quét mã QR</span>
  </button>
</div>

    <!-- Orders Display -->
    <div class="orders-container">
      <!-- Table View -->
      <div v-if="viewMode === 'table'" class="table-view">
        <div class="table-container">
          <table class="orders-table">
            <thead>
              <tr>
                <th class="sortable" @click="sortBy('code')">
                  <span>Mã đơn hàng</span>
                  <span class="sort-icon">{{ getSortIcon("code") }}</span>
                </th>
                <th class="sortable" @click="sortBy('customerName')">
                  <span>Khách hàng</span>
                  <span class="sort-icon">{{
                    getSortIcon("customerName")
                  }}</span>
                </th>
                <th>Sản phẩm</th>
                <th class="sortable text-right" @click="sortBy('totalAmount')">
                  <span>Tổng tiền</span>
                  <span class="sort-icon">{{
                    getSortIcon("totalAmount")
                  }}</span>
                </th>
                <th>Loại</th>
                <th>Trạng thái</th>
                <th class="sortable" @click="sortBy('ngayTao')">
                  <span>Ngày tạo</span>
                  <span class="sort-icon">{{ getSortIcon("ngayTao") }}</span>
                </th>
                <th class="text-center">Hành động</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="order in filteredOrders"
                :key="order.id"
                class="order-row"
              >
                <td class="order-code">
                  <div class="code-cell">
                    <span class="code-text">{{ order.id }}</span>
                    <span class="code-id">#{{ order.id }}</span>
                  </div>
                </td>
                <td class="customer-cell">
                  <div class="customer-info">
                    <div class="customer-name">
                      {{ order.tenKhachHang || "Khách lẻ" }}
                    </div>
                    <div class="customer-phone">{{ order.soDienThoai || "N/A" }}</div>
                  </div>
                </td>
                <td class="items-cell">
                  <div class="items-info">
                    <span class="items-count"
                      >{{ order.totalItems }} sản phẩm</span
                    >
                  </div>
                </td>
                <td class="amount-cell text-right">
                  <div class="amount-info">
                    <span class="amount-value">{{
                      formatCurrency(order.tongTienSauGiam)
                    }}</span>
                  </div>
                </td>
                <td class="type-cell">
                  <span :class="['type-badge', order.loaiDon]">
                    <span class="type-icon">{{
                      order.loaiDon === "online" ? "🌐" : "🏪"
                    }}</span>
                    <span class="type-text">{{
                      order.loaiDon === "online" ? "Online" : "Tại quầy"
                    }}</span>
                  </span>
                </td>
                <td class="status-cell">
                  <span :class="['status-badge', getStatusClass(order.trangThai)]">
                    {{ getStatusText(order.trangThai) }}
                  </span>
                </td>
                <td class="date-cell">
                  <div class="date-info">
                    <span class="date-value">{{
                      formatDate(order.ngayTao)
                    }}</span>
                    <span class="time-value">{{
                      formatTime(order.ngayTao)
                    }}</span>
                  </div>
                </td>
                <td class="actions-cell text-center">
                  <div class="action-buttons">
                    <button
                      class="action-btn view-btn"
                      @click="viewOrder(order)"
                      title="Xem chi tiết"
                    >
                      <img :src="ViewIcon" alt="View" class="icon-sm" />
                    </button>
                    <button
                      class="action-btn edit-btn"
                      @click="editOrder(order)"
                      title="Chỉnh sửa"
                    >
                      <img :src="EditIcon" alt="Edit" class="icon-sm" />
                    </button>
                    <button
                      class="action-btn print-btn"
                      @click="printOrder(order)"
                      title="In hóa đơn"
                    >
                      <img :src="PrintIcon" alt="Print" class="icon-sm" />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Grid View -->
      <div v-if="viewMode === 'grid'" class="grid-view">
        <div class="orders-grid">
          <div
            v-for="order in filteredOrders"
            :key="order.id"
            class="order-card"
          >
            <div class="card-header">
              <div class="order-meta">
                <span class="order-code">{{ order.id }}</span>
                <span :class="['type-badge', order.type]">
                  {{ order.type === "online" ? "🌐 Online" : "🏪 Tại quầy" }}
                </span>
              </div>
              <span :class="['status-badge', getStatusClass(order.status)]">
                {{ getStatusText(order.status) }}
              </span>
            </div>

            <div class="card-body">
              <div class="customer-section">
                <div class="customer-name">
                  {{ order.tenKhachHang  || "Khách lẻ" }}
                </div>
                <div class="customer-phone">{{ order.phone || "N/A" }}</div>
              </div>

              <div class="order-details">
                <div class="detail-item">
                  <span class="label">Sản phẩm:</span>
                  <span class="value">{{ order.totalItems }} item</span>
                </div>
                <div class="detail-item">
                  <span class="label">Tổng tiền:</span>
                  <span class="value amount">{{
                    formatCurrency(order.tongTienSauGiam)
                  }}</span>
                </div>
                <div class="detail-item">
                  <span class="label">Ngày tạo:</span>
                  <span class="value">{{ formatDate(order.ngayTao) }}</span>
                </div>
              </div>
            </div>

            <div class="card-actions">
              <button class="action-btn primary" @click="viewOrder(order)">
                <span class="btn-icon"><img :src="ViewIcon" alt="View" class="icon-sm" /></span>
                <span class="btn-text">Xem</span>
              </button>
              <button class="action-btn secondary" @click="editOrder(order)">
                <span class="btn-icon"><img :src="EditIcon" alt="Edit" class="icon-sm" /></span>
                <span class="btn-text">Sửa</span>
              </button>
              <button class="action-btn tertiary" @click="printOrder(order)">
                <span class="btn-icon"><img :src="PrintIcon" alt="Print" class="icon-sm" /></span>
                <span class="btn-text">In</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Enhanced Pagination -->
      <div class="pagination-section">
        <div class="pagination-info">
          <span class="showing"
            >Hiển thị {{ startIndex + 1 }} - {{ endIndex }} trong tổng số
            {{ totalOrders }} đơn hàng</span
          >
          <div class="per-page-selector">
            <label>Hiển thị:</label>
            <select v-model="itemsPerPage" class="per-page-select">
              <option value="10">10</option>
              <option value="25">25</option>
              <option value="50">50</option>
              <option value="100">100</option>
            </select>
          </div>
        </div>

        <div class="pagination-controls">
          <button
            class="pagination-btn first"
            @click="goToPage(1)"
            :disabled="currentPage === 1"
            title="Trang đầu"
          >
            <img :src="ChevronsLeftIcon" alt="First" class="icon-sm" />
          </button>
          <button
            class="pagination-btn prev"
            @click="previousPage"
            :disabled="currentPage === 1"
            title="Trang trước"
          >
            <img :src="ChevronLeftIcon" alt="Previous" class="icon-sm" />
          </button>

          <div class="page-numbers">
            <button
              v-for="page in getPageNumbers()"
              :key="page"
              :class="[
                'page-btn',
                { active: page === currentPage, dots: page === '...' },
              ]"
              @click="goToPage(page)"
              :disabled="page === '...'"
            >
              {{ page }}
            </button>
          </div>

          <button
            class="pagination-btn next"
            @click="nextPage"
            :disabled="currentPage === totalPages"
            title="Trang sau"
          >
            <img :src="ChevronRightIcon" alt="Next" class="icon-sm" />
          </button>
          <button
            class="pagination-btn last"
            :disabled="currentPage === backendTotalPages"
            @click="goToPage(backendTotalPages)"

            title="Trang cuối"
          >
            <img :src="ChevronsRightIcon" alt="Last" class="icon-sm" />
          </button>
        </div>
      </div>
    </div>
 

    <!-- Order Detail Modal -->
    <div
      v-if="showDetailModal"
      class="modal-overlay"
      @click="showDetailModal = false"
    >
      <div class="modal-content large" @click.stop>
        <div class="modal-header">
          <h3>Thông tin đơn hàng - {{ selectedOrder?.code }}</h3>
          <button class="modal-close" @click="showDetailModal = false">
            ✕
          </button>
        </div>

        <div class="modal-body" v-if="selectedOrder">
          <!-- Order Actions -->
          <div class="order-actions">
            <button class="btn-export">Chi tiết</button>
            <button class="btn-export">In hóa đơn</button>
          </div>

          <!-- Order Info -->
          <div class="order-detail-info">
            <div class="info-section">
              <h4>Thông tin đơn hàng - Đơn tại quầy</h4>
              <div class="info-grid">
                <div class="info-item">
                  <label>Mã:</label>
                  <span>{{ selectedOrder.id }}</span>
                </div>
                <div class="info-item">
                  <label>Tên khách hàng:</label>
                  <span>{{ selectedOrder.tenKhachHang || "Khách lẻ" }}</span>
                </div>
                <div class="info-item">
                  <label>Trạng thái:</label>
                  <span
                    :class="['badge', getStatusClass(selectedOrder.status)]"
                  >
                    {{ getStatusText(selectedOrder.status) }}
                  </span>
                </div>
                <div class="info-item">
                  <label>Số người nhận:</label>
                  <span>{{ selectedOrder.soDienThoai || "N/A" }}</span>
                </div>
                <div class="info-item">
                  <label>Loại:</label>
                  <span
                    :class="[
                      'badge',
                      selectedOrder.type === 'online'
                        ? 'badge-info'
                        : 'badge-success',
                    ]"
                  >
                    {{
                      selectedOrder.type === "online"
                        ? "Trực tuyến"
                        : "Tại quầy"
                    }}
                  </span>
                </div>
                <div class="info-item">
                  <label>Tên người nhận:</label>
                  <span>{{ selectedOrder.receiverName || "N/A" }}</span>
                </div>
              </div>
            </div>

            <!-- Payment History -->
            <div class="payment-history">
              <h4>Lịch sử thanh toán</h4>
              <table class="table">
                <thead>
                  <tr>
                    <th>Số tiền</th>
                    <th>Thời gian</th>
                    <th>Loại giao dịch</th>
                    <th>PTTT</th>
                    <th>Trạng thái</th>
                    <th>Ghi chú</th>
                    <th>Nhân viên xác nhận</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="payment in selectedOrder.payments"
                    :key="payment.id"
                  >
                    <td class="amount">{{ formatCurrency(payment.amount) }}</td>
                    <td>{{ formatDateTime(payment.ngayTao) }}</td>
                    <td>
                      <span
                        :class="[
                          'badge',
                          payment.type === 'payment'
                            ? 'badge-success'
                            : 'badge-warning',
                        ]"
                      >
                        {{
                          payment.type === "payment" ? "Thanh toán" : "Tiền mặt"
                        }}
                      </span>
                    </td>
                    <td>
                      <span
                        :class="[
                          'badge',
                          payment.method === 'completed'
                            ? 'badge-success'
                            : 'badge-info',
                        ]"
                      >
                        {{
                          payment.method === "completed"
                            ? "Thành công"
                            : "Tím một"
                        }}
                      </span>
                    </td>
                    <td>
                      <span
                        :class="[
                          'badge',
                          payment.status === 'completed'
                            ? 'badge-success'
                            : 'badge-warning',
                        ]"
                      >
                        {{
                          payment.status === "completed"
                            ? "Thành công"
                            : "Chờ xử lý"
                        }}
                      </span>
                    </td>
                    <td>{{ payment.note || "-" }}</td>
                    <td>{{ payment.confirmedBy }}</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Order Timeline -->
            <div class="order-timeline">
              <h4>Lịch sử đơn hàng</h4>
              <div class="timeline">
                <div class="timeline-item completed">
                  <div class="timeline-icon">✅</div>
                  <div class="timeline-content">
                    <div class="timeline-header">
                      <span class="timeline-title">Tạo đơn hàng</span>
                      <span class="timeline-time">{{
                        formatDateTime(selectedOrder.createdAt)
                      }}</span>
                    </div>
                    <div class="timeline-description">
                      Nhân viên - {{ selectedOrder.createdBy }} - NV6
                    </div>
                  </div>
                </div>
                <div class="timeline-item completed">
                  <div class="timeline-icon">✅</div>
                  <div class="timeline-content">
                    <div class="timeline-header">
                      <span class="timeline-title">Hoàn thành</span>
                      <span class="timeline-time">{{
                        formatDateTime(selectedOrder.completedAt)
                      }}</span>
                    </div>
                    <div class="timeline-description">
                      Nhân viên - {{ selectedOrder.completedBy }} - NV6
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Product List -->
            <div class="product-list">
              <h4>Danh sách sản phẩm</h4>
              <div class="product-items">
                <div
                  v-for="item in selectedOrder.items"
                  :key="item.id"
                  class="product-item"
                >
                  <div class="product-image">
                    <img v-if="item.image" :src="item.image" :alt="item.name" />
                    <div v-else class="placeholder-image"></div>
                  </div>
                  <div class="product-info">
                    <h5>{{ item.name }}</h5>
                    <p class="product-details">
                      Mã: {{ item.code }} | Size: {{ item.size }}
                    </p>
                  </div>
                  <div class="product-quantity">x{{ item.quantity }}</div>
                  <div class="product-price">
                    {{ formatCurrency(item.price) }}
                  </div>
                </div>
              </div>

              <!-- Order Summary -->
              <div class="order-summary">
                <div class="summary-row">
                  <span>Phiếu giảm giá:</span>
                  <span>{{ selectedOrder.couponCode || "N/A" }}</span>
                </div>
                <div class="summary-row">
                  <span>Giảm giá từ cửa hàng:</span>
                  <span>{{ selectedOrder.storeDiscount || "0%" }}</span>
                </div>
                <div class="summary-row">
                  <span>Tổng tiền hàng:</span>
                  <span>{{ formatCurrency(selectedOrder.subtotal) }}</span>
                </div>
                <div class="summary-row">
                  <span>Giảm giá:</span>
                  <span class="discount"
                    >-{{ formatCurrency(selectedOrder.discount) }}</span
                  >
                </div>
                <div class="summary-row">
                  <span>Phí vận chuyển:</span>
                  <span>{{ formatCurrency(selectedOrder.shippingFee) }}</span>
                </div>
                <div class="summary-row">
                  <span
                    >Miễn phí vận chuyển với đơn hàng có tổng tiền trên
                    1.000.000 VND</span
                  >
                </div>
                <div class="summary-row total">
                  <span>Tổng tiền:</span>
                  <span class="total-amount">{{
                    formatCurrency(selectedOrder.tongTienSauGiam)
                  }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// SVG Icons
import RefreshIcon from "@/assets/Reload.svg?url";
import EditIcon from "@/assets/Edit.svg?url";
import ViewIcon from "@/assets/View.svg?url";
import PrintIcon from "@/assets/Print.svg?url";
import PlusIcon from "@/assets/Plus.svg?url";
import TrashIcon from "@/assets/Trash.svg?url";
import SaveIcon from "@/assets/Save.svg?url";
import CancelIcon from "@/assets/Cancel.svg?url";
import ChevronLeftIcon from "@/assets/chevron-left.svg?url";
import ChevronRightIcon from "@/assets/chevron-right.svg?url";
import ChevronsLeftIcon from "@/assets/chevrons-left.svg?url";
import ChevronsRightIcon from "@/assets/chevrons-right.svg?url";
import ClipboardIcon from "@/assets/Clipboard.svg?url";
import ExcelIcon from "@/assets/Excel.svg?url";
import StatisticsIcon from "@/assets/Statistics.svg?url";
import PhoneIcon from "@/assets/Phone.svg?url";
import UsersIcon from "@/assets/Users.svg?url";
import ProfileIcon from "@/assets/Profile.svg?url";
import DashboardIcon from "@/assets/Dashboard.svg?url";
import OrdersIcon from "@/assets/Orders.svg?url";
import ProductsIcon from "@/assets/Shoes.svg?url";
import ShoppingCartIcon from "@/assets/ShoppingCart.svg?url";
import CreditCardIcon from "@/assets/CreditCard.svg?url";
import RevenueIcon from "@/assets/Revenue.svg?url";
import GrowthIcon from "@/assets/Growth.svg?url";
import SettingsIcon from "@/assets/Settings.svg?url";
import ExportIcon from "@/assets/Export.svg?url";
import FindIcon from "@/assets/Find.svg?url";
import QRIcon from "@/assets/QR.svg?url";
import PendingIcon from "@/assets/Pending.svg?url";
import ShippingIcon from "@/assets/Shipping.svg?url";
import CompletedIcon from "@/assets/Completed.svg?url";
import SuccessIcon from "@/assets/Success.svg?url";
import CelebrationIcon from "@/assets/Celebration.svg?url";
import FailedIcon from "@/assets/Failed.svg?url";


import axios from "axios";
import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import { exportToExcel, formatDataForExcel } from '../../utils/xuatExcel.js';


const router = useRouter();

// Data

const searchQuery = ref('')
const fromDate = ref('')
const toDate = ref('')
const selectedType = ref('')
const selectedStatus = ref('TAT_CA')
const currentPage = ref(1)
const itemsPerPage = ref(10) 
const viewMode = ref('table') // 'table' or 'grid'
const minAmount = ref('')
const maxAmount = ref('')
const sortField = ref('')
const sortDirection = ref('asc') // 'asc' or 'desc'
const showDetailModal = ref(false)
const selectedOrder = ref(null)
const orders = ref([])
const backendTotalOrders = ref(0)
const backendTotalPages = ref(0)
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => startIndex.value + itemsPerPage.value)

const loading = ref(false)
const error = ref(null)


const fetchOrders = async () => {
  loading.value = true;
  try {
    const res = await axios.get("http://localhost:8080/api/hoa-don-management/paging", {
      params: {
        page: currentPage.value - 1, // backend phân trang từ 0
        size: itemsPerPage.value
      }
    });

    // Lấy object chính
    const response = res.data.data;

    // Trường hợp backend trả: { data: [...], totalPages, currentPage, pageSize }
    if (response && Array.isArray(response.data)) {
      orders.value = response.data;                      // danh sách hóa đơn
      backendTotalOrders.value = response.data.length;   // tổng số phần tử
      backendTotalPages.value = response.totalPages || 1;
    } else {
      console.error("❌ API format không khớp:", response);
      orders.value = [];
      backendTotalOrders.value = 0;
      backendTotalPages.value = 0;
    }

    console.log("Fetched orders:", orders.value);
  } catch (err) {
    console.error("❌ Lỗi khi gọi API:", err);
    error.value = "Không thể tải dữ liệu từ server";
  } finally {
    loading.value = false;
  }
};






const statusTabs = [
  { value: "TAT_CA", label: "TẤT CẢ", iconComponent: ClipboardIcon },
  { value: "CHO_XAC_NHAN", label: "CHỞ XÁC NHẬN", iconComponent: PendingIcon },
  { value: "CHO_GIAO_HANG", label: "CHỞ GIAO HÀNG", iconComponent: ShippingIcon },
  { value: "DANG_VAN_CHUYEN", label: "ĐANG VẬN CHUYỂN", iconComponent: ShippingIcon },
  { value: "DA_GIAO_HANG", label: "ĐÃ GIAO HÀNG", iconComponent: CompletedIcon },
  { value: "CHO_THANH_TOAN", label: "CHỞ THANH TOÁN", iconComponent: CreditCardIcon },
  { value: "DA_THANH_TOAN", label: "ĐÃ THANH TOÁN", iconComponent: SuccessIcon },
  { value: "HOAN_THANH", label: "HOÀN THÀNH", iconComponent: CelebrationIcon },
  { value: "DA_HUY", label: "ĐÃ HỦY", iconComponent: FailedIcon },
];

// Mock data


// Computed
const filteredOrders = computed(() => {
  let filtered = orders.value;

  if (searchQuery.value) {
  filtered = filtered.filter(
    (order) =>
      order.maHoaDon?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      (order.tenNguoiNhan &&
        order.tenNguoiNhan.toLowerCase().includes(searchQuery.value.toLowerCase()))
  )
}

if (fromDate.value) {
  filtered = filtered.filter(
    (order) => new Date(order.ngayTao) >= new Date(fromDate.value)
  )
}

if (toDate.value) {
  filtered = filtered.filter(
    (order) => new Date(order.ngayTao) <= new Date(toDate.value + "T23:59:59")
  )
}

if (minAmount.value) {
  filtered = filtered.filter(
    (order) => order.tongTien >= parseInt(minAmount.value)
  )
}

if (maxAmount.value) {
  filtered = filtered.filter(
    (order) => order.tongTien <= parseInt(maxAmount.value)
  )
}



  return filtered.slice(startIndex.value, endIndex.value);

});

const totalOrders = computed(() => {
  let filtered = orders.value;

  if (searchQuery.value) {
    filtered = filtered.filter(
      (order) =>
        order.maHoaDon?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
        (order.tenNguoiNhan &&
          order.tenNguoiNhan.toLowerCase().includes(searchQuery.value.toLowerCase()))
    );
  }

  if (selectedType.value) {
    filtered = filtered.filter((order) => order.loaiDonHang === selectedType.value);
  }

  if (selectedStatus.value && selectedStatus.value !== "TAT_CA") {
    filtered = filtered.filter((order) => order.trangThai === selectedStatus.value);
  }

  if (fromDate.value) {
    filtered = filtered.filter(
      (order) => new Date(order.ngayTao) >= new Date(fromDate.value)
    );
  }

  if (toDate.value) {
    filtered = filtered.filter(
      (order) => new Date(order.ngayTao) <= new Date(toDate.value + "T23:59:59")
    );
  }

  if (minAmount.value) {
    filtered = filtered.filter(
      (order) => order.tongTien >= parseInt(minAmount.value)
    );
  }

  if (maxAmount.value) {
    filtered = filtered.filter(
      (order) => order.tongTien <= parseInt(maxAmount.value)
    );
  }

  return filtered.length;
});


// Statistics computed
const pendingOrdersCount = computed(
  () => orders.value.filter((order) => order.status === "CHO_XAC_NHAN").length
);

const processingOrdersCount = computed(
  () =>
    orders.value.filter((order) =>
      ["CHO_GIAO_HANG", "DANG_VAN_CHUYEN"].includes(order.status)
    ).length
);

const completedOrdersCount = computed(
  () => orders.value.filter((order) => order.status === "HOAN_THANH").length
);

// Methods
const formatCurrency = (amount) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    minimumFractionDigits: 0,
  })
    .format(amount)
    .replace("₫", " đ");
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("vi-VN");
};

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString("vi-VN");
};

const getStatusClass = (status) => {
  const statusClasses = {
    HOAN_THANH: "badge-success",
    CHO_XAC_NHAN: "badge-warning",
    CHO_GIAO_HANG: "badge-info",
    DANG_VAN_CHUYEN: "badge-info",
    DA_GIAO_HANG: "badge-success",
    DA_THANH_TOAN: "badge-success",
    CHO_THANH_TOAN: "badge-warning",
    DA_HUY: "badge-danger",
  };
  return statusClasses[status] || "badge-secondary";
};

const getStatusText = (status) => {
  if (typeof status === "boolean") {
    return status ? "Hoàn thành" : "Chờ xác nhận";
  }
  // fallback khi backend trả string
  const statusTexts = {
    HOAN_THANH: "Hoàn thành",
    CHO_XAC_NHAN: "Chờ xác nhận",
    CHO_GIAO_HANG: "Chờ giao hàng",
    DANG_VAN_CHUYEN: "Đang vận chuyển",
    DA_GIAO_HANG: "Đã giao hàng",
    DA_THANH_TOAN: "Đã thanh toán",
    CHO_THANH_TOAN: "Chờ thanh toán",
    DA_HUY: "Đã hủy",
  };
  return statusTexts[status] || "Không xác định";
};


const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    fetchOrders()
  }
};

const nextPage = () => {
  if (currentPage.value < backendTotalPages.value) {
    currentPage.value++
    fetchOrders()
  }
};

const viewOrder = (order) => {
  selectedOrder.value = order;
  showDetailModal.value = true;
};

const createOrder = () => {
  // Navigate to POS system to create new order
  router.push("/sales/pos");
};

const scanQRCode = () => {
};

const exportOrdersToExcel = () => {
  try {
    const headerMapping = {
      code: "Mã đơn hàng",
      customerName: "Khách hàng",
      phone: "Số điện thoại",
      totalItems: "Tổng sản phẩm",
      totalAmount: "Tổng tiền",
      type: "Loại đơn hàng",
      status: "Trạng thái",
      createdAt: "Ngày tạo",
    };

   const dataToExport = orders.value.map((order) => ({
  code: order.maHoaDon,
  customerName: order.tenNguoiNhan || "Khách lẻ",
  phone: order.soDienThoaiNguoiNhan || "N/A",
  totalAmount: order.tongTienSauGiam || order.tongTien,
  createdAt: order.ngayTao,
  status: getStatusText(order.trangThai ? "HOAN_THANH" : "CHO_XAC_NHAN")
}));


    const formattedData = formatDataForExcel(dataToExport, headerMapping);

    const result = exportToExcel(
      formattedData,
      "Danh_sach_don_hang",
      "Đơn hàng",
      { skipHeader: false }
    );

    if (result && result.success) {
      alert(`✅ ${result.message}`);
    } else {
      alert(`❌ ${result ? result.message : "Có lỗi xảy ra khi xuất file"}`);
    }
  } catch (error) {
    console.error("Error exporting orders to Excel:", error);
    alert(`❌ Có lỗi xảy ra khi xuất file Excel: ${error.message}`);
  }
};

const resetFilters = () => {
  searchQuery.value = "";
  fromDate.value = "";
  toDate.value = "";
  selectedType.value = "";
  selectedStatus.value = "TAT_CA";
  minAmount.value = "";
  maxAmount.value = "";
  currentPage.value = 1;
};

const sortBy = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === "asc" ? "desc" : "asc";
  } else {
    sortField.value = field;
    sortDirection.value = "asc";
  }
};

const getSortIcon = (field) => {
  if (sortField.value !== field) return "⇅";
  return sortDirection.value === "asc" ? "↑" : "↓";
};

const getStatusCount = (status) => {
  if (status === "TAT_CA") return orders.value.length;
  return orders.value.filter((order) => order.trangThai === status).length;
};

const formatTime = (dateString) => {
  return new Date(dateString).toLocaleTimeString("vi-VN", {
    hour: "2-digit",
    minute: "2-digit",
  });
};

const editOrder = (order) => {
};

const printOrder = (order) => {
};

const goToPage = (page) => {
  if (page !== "..." && page >= 1 && page <= backendTotalPages.value) {
    currentPage.value = page;
    fetchOrders();
  }
};

const getPageNumbers = () => {
   const pages = [];
  const total = backendTotalPages.value;
  const current = currentPage.value;

  if (total <= 7) {
    for (let i = 1; i <= total; i++) {
      pages.push(i);
    }
  } else {
    if (current <= 4) {
      for (let i = 1; i <= 5; i++) pages.push(i);
      pages.push("...");
      pages.push(total);
    } else if (current >= total - 3) {
      pages.push(1);
      pages.push("...");
      for (let i = total - 4; i <= total; i++) pages.push(i);
    } else {
      pages.push(1);
      pages.push("...");
      for (let i = current - 1; i <= current + 1; i++) pages.push(i);
      pages.push("...");
      pages.push(total);
    }
  }

  return pages;
};

const refreshData = () => {
  // Simulate data refresh
};

const exportData = () => {  
  alert("Chức năng xuất báo cáo đang được phát triển");
};
onMounted(() => {
  fetchOrders();

  const today = new Date();
  toDate.value = today.toISOString().split("T")[0];
  fromDate.value = "2025-01-01"; 
});



  // Set default dates to show all data
  const today = new Date();
  const oneMonthAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);

  toDate.value = today.toISOString().split("T")[0];
  fromDate.value = "2025-01-01"; // Set to beginning of 2025 to show all example data
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/quanLyDonHang.css';

/* SVG Icon Styles */
.icon-xs {
  width: 12px;
  height: 12px;
}

.icon-sm {
  width: 16px;
  height: 16px;
}

.icon-md {
  width: 20px;
  height: 20px;
}

.icon-lg {
  width: 24px;
  height: 24px;
}

.icon-xl {
  width: 32px;
  height: 32px;
}

/* Icon alignment improvements */
.btn-action {
  display: flex;
  align-items: center;
  gap: 8px;
}

.btn-action img {
  flex-shrink: 0;
}

.action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.btn-icon {
  display: flex;
  align-items: center;
}

.pagination-btn {
  display: flex;
  align-items: center;
  justify-content: center;
}

.view-btn {
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Status tab icon alignment */
.status-tab {
  display: flex;
  align-items: center;
  gap: 6px;
}

.tab-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.tab-icon img {
  flex-shrink: 0;
}

</style>
