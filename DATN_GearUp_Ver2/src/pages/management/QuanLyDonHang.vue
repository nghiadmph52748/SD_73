<template>
  <div class="order-management">
    <!-- Advanced Filters -->
    <div class="filters-panel">
      <div class="filters-header">
        <h3>Bộ lọc & Tìm kiếm</h3>
        <button class="btn-export" @click="resetFilters">
          <span class="btn-icon">🔄</span>
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
          <div class="filter-group">
            <label class="filter-label">Loại đơn hàng</label>
            <div class="radio-group">
              <label class="radio-option">
                <input type="radio" value="" v-model="selectedType" /> Tất cả
              </label>
              <label class="radio-option">
                 <input type="radio" :value="false" v-model="selectedType" /> Trực tuyến
              </label>
              <label class="radio-option">
                <input type="radio" :value="true" v-model="selectedType" /> Tại quầy
              </label>
            </div>
          </div>
          
        </div>
      </div>
    </div>

    <!-- Status Tabs with Improved Design -->
    <!-- <div class="status-tabs-container">
      <div class="status-tabs">
        <button
          v-for="status in statusTabs"
          :key="status.value"
          :class="['status-tab', { active: selectedStatus === status.value }]"
          @click="selectedStatus = status.value"
        >
          <span class="tab-icon">{{ status.icon }}</span>
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
          📋
        </button>
        <button
          :class="['view-btn', { active: viewMode === 'grid' }]"
          @click="viewMode = 'grid'"
          title="Xem dạng lưới"
        >
          ▦
        </button>
      </div>
    </div>

      <div class="header-actions">
      

      
        <button class="btn-action" @click="exportOrdersToExcel">
          <i class="lucide lucide-file-spreadsheet"></i>
          <span>Xuất Excel</span>
        </button>

        <button class="btn-action primary" @click="createOrder">
          <i class="lucide lucide-plus-circle"></i>
          <span>Tạo đơn hàng</span>
        </button>

      
      </div> -->

    <!-- Orders Display -->
    <div class="orders-container">
       <div class="status-tabs-container">
      <div class="status-tabs">
        <button
          v-for="status in statusTabs"
          :key="status.value"
          :class="['status-tab', { active: selectedStatus === status.value }]"
          @click="selectedStatus = status.value"
        >
          <span class="tab-icon">{{ status.icon }}</span>
          <span class="tab-text">{{ status.label }}</span>
          <span class="tab-count">{{ getStatusCount(status.value) }}</span>
        </button>
      </div>

     
      <div class="header-actions">
      

      
        <button class="btn-action" @click="exportOrdersToExcel">
          <i class="lucide lucide-file-spreadsheet"></i>
          <span>Xuất Excel</span>
        </button>

        <button class="btn-action primary" @click="createOrder">
          <i class="lucide lucide-plus-circle"></i>
          <span>Tạo đơn hàng</span>
        </button>

      
      </div>
       <div class="view-options">
        <button
          :class="['view-btn', { active: viewMode === 'table' }]"
          @click="viewMode = 'table'"
          title="Xem dạng bảng"
        >
          📋
        </button>
        <button
          :class="['view-btn', { active: viewMode === 'grid' }]"
          @click="viewMode = 'grid'"
          title="Xem dạng lưới"
        >
          ▦
        </button>
      </div>
    </div>

      

      <!-- Table View -->
      <div v-if="viewMode === 'table'" class="table-view">
        <div class="table-container">
          <table class="orders-table">
            <thead>
              <tr>
                <th class="sortable" @click="sortBy('code')">
                  <span>STT</span>
                  <span class="sort-icon">{{ getSortIcon("code") }}</span>
                </th>
                <th>Mã Hóa Đơn</th>
                <th class="sortable" @click="sortBy('customerName')">
                  <span>Khách hàng</span>
                  <span class="sort-icon">{{
                    getSortIcon("customerName")
                  }}</span>
                </th>
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
                  </div>
                </td>
                <!-- Mã Hóa Đơn -->
                <td class="order-code">
                  <div class="code-cell">
                   <span class="code-text">{{ order.lichSuThanhToan?.[0]?.maHoaDon }}</span>
                  </div>
                </td>
                <td class="customer-cell">
                  <div class="customer-info">
                    <div class="customer-name">
                      {{ order.tenKhachHang || "Khách lẻ" }}
                    </div>
                  </div>
                </td>
                <!-- <td class="items-cell">
                <div class="items-info">
                  <span v-if="order.tenSanPhams && order.tenSanPhams.length">
                    {{ order.tenSanPhams.join(', ') }}
                  </span>
                  <span v-else>
                    Không có sản phẩm
                  </span>
                </div>
              </td> -->
                <td class="amount-cell text-right">
                  <div class="amount-info">
                    <span class="amount-value">{{
                      formatCurrency(order.tongTienSauGiam)
                    }}</span>
                  </div>
                </td>
                <td class="type-cell">
                  <span :class="['type-badge', order.loaiDon ? 'offline' : 'online']">
                    <span class="type-icon">
                      {{ order.loaiDon ? "🏪" : "🌐" }}
                    </span>
                    <span class="type-text">
                      {{ order.loaiDon ? "Tại quầy" : "Online" }}
                    </span>
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
                  <td>
                <ButtonGroup spacing="xs">
                  <ActionButton
                      icon="view"
                      variant="info"
                      size="sm"
                      tooltip="Xem chi tiết"
                      class="action-button-info"
                      @click="viewOrder(order)"
                    />
                  <ActionButton
                    icon="edit"
                    variant="info"
                    size="sm"
                    tooltip="Chỉnh sửa thông tin"
                    class="action-button-warning"
                    @click="editOrder(order)"
                  />
                  <ActionButton
                   icon="print"
                    variant="info"
                    size="sm"
                    tooltip="In Hóa Đơn"
                    class="action-button-danger"
                    @click="printOrder(order)"
                  />
                </ButtonGroup>
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
                <span :class="['type-badge', order.loaiDon ? 'offline' : 'online']">
                  {{ order.loaiDon ? "🏪 Tại quầy" : "🌐 Online" }}
                </span>
              </div>
              <span :class="['status-badge', getStatusClass(order.trangThai)]">
                {{ getStatusText(order.trangThai) }}
              </span>
            </div>


            <div class="card-body">
              <div class="customer-section">
                <div class="customer-name">
                  {{ order.tenKhachHang  || "Khách lẻ" }}
                </div>
                <div class="customer-phone">{{ order.soDienThoai || "N/A" }}</div>
              </div>

              <div class="order-details">
                <div class="detail-item">
                  <span class="label">Sản phẩm:</span>
                  <span class="value">{{ order.tenSanPham }} item</span>
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
              <td>
                <ButtonGroup spacing="xs">
                  <ActionButton
                      icon="view"
                      variant="info"
                      size="sm"
                      tooltip="Xem chi tiết"
                      class="action-button-info"
                      @click="viewOrder(order)"
                    />
                  <ActionButton
                    icon="edit"
                    variant="info"
                    size="sm"
                    tooltip="Chỉnh sửa thông tin"
                    class="action-button-warning"
                    @click="editOrder(order)"
                  />
                  <ActionButton
                   icon="print"
                    variant="info"
                    size="sm"
                    tooltip="In Hóa Đơn"
                    class="action-button-danger"
                    @click="printOrder(order)"
                  />
                </ButtonGroup>
              </td>
            </div>
          </div>
        </div>
      </div>
      <!-- Edit Order Modal -->
            <div
              v-if="showEditModal"
              class="modal-overlay"
              @click="closeEditModal"
            >
              <div class="modal-content medium" @click.stop>
                <div class="modal-header">
                  <h3>✏️ Chỉnh sửa đơn hàng</h3>
                  <button class="modal-close" @click="closeEditModal">✕</button>
                </div>

                <div class="modal-body">
                  <form @submit.prevent="updateOrder">
                    <!-- Tên khách hàng -->
                    <div class="form-group">
                      <label for="tenKhachHang">Tên khách hàng:</label>
                      <input
                        id="tenKhachHang"
                        v-model="editingOrder.tenKhachHang"
                        type="text"
                        class="form-control"
                      />
                    </div>

                    <!-- Trạng thái -->
                    <div class="form-group">
                      <label for="trangThai">Trạng thái:</label>
                    <select v-model="editingOrder.trangThai" class="form-control">
                      <option :value="true">Hoàn thành</option>
                      <option :value="false">Chờ xác nhận</option>
                    </select>

                    </div>

                    <!-- Loại đơn -->
                    <select v-model="editingOrder.loaiDon" class="form-control">
                      <option :value="true">🌐 Online</option>
                      <option :value="false">🏪 Tại quầy</option>
                    </select>


                    <!-- Tổng tiền -->
                    <div class="form-group">
                      <label for="tongTienSauGiam">Tổng tiền sau giảm:</label>
                      <input
                        id="tongTienSauGiam"
                        v-model="editingOrder.tongTienSauGiam"
                        type="number"
                        class="form-control"
                      />
                    </div>

                    <!-- Buttons -->
                    <div class="form-actions">
                      <button type="button" class="btn btn-secondary" @click="closeEditModal">
                        Hủy
                      </button>
                      <button type="submit" class="btn btn-primary" >
                        💾 Lưu
                      </button>
                    </div>
                  </form>
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
            ⏮
          </button>
          <button
            class="pagination-btn prev"
            @click="previousPage"
            :disabled="currentPage === 1"
            title="Trang trước"
          >
            ◀<
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
            ▶>
          </button>
          <button
            class="pagination-btn last"
            :disabled="currentPage === backendTotalPages"
            @click="goToPage(backendTotalPages)"

            title="Trang cuối"
          >
            ⏭
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
        <div class="order-detail-header">
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
                    :class="['badge', getStatusClass(selectedOrder.trangThai)]"
                  >
                    {{ getStatusText(selectedOrder.trangThai) }}
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
                    selectedOrder.loaiDon ? 'badge-success' : 'badge-info'
                  ]"
                >
                  {{ selectedOrder.loaiDon ? "Tại quầy" : "Trực tuyến" }}
                </span>
              </div>
                <div class="info-item">
                  <label>Tên người nhận:</label>
                  <span>{{ selectedOrder.tenNguoiNhan || "N/A" }}</span>
                </div>
              </div>
            </div>

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
              <tbody v-if="selectedOrder?.lichSuThanhToan?.length > 0">
                <tr
                  v-for="(payment, index) in selectedOrder.lichSuThanhToan"
                  :key="payment.id"
                >
                  <!-- Số tiền -->
                  <td class="amount">
                    {{ formatCurrency((payment.tienMat || 0) + (payment.tienChuyenKhoan || 0)) }}
                  </td>

                  <!-- Thời gian -->
                  <td>{{ formatDateTime(payment.ngayTao) }}</td>

                  <!-- Loại giao dịch -->
                  <td>
                    <span class="badge badge-info">
                      {{ payment.loaiGiaoDich || "Thanh toán" }}
                    </span>
                  </td>

                  <!-- PTTT -->
                  <td>
                    <span class="badge badge-success">
                      {{ payment.tenPhuongThucThanhToan }}
                    </span>
                  </td>

                  <!-- Trạng thái -->
                  <td>
                    <span
                      :class="[
                        'badge',
                        payment.trangThai === '1' ? 'badge-success' : 'badge-warning',
                      ]"
                    >
                      {{ payment.trangThai === '1' ? 'Thành công' : 'Chờ xử lý' }}
                    </span>
                  </td>

                  <!-- Ghi chú từ hóa đơn chi tiết -->
                  <td>
                    {{ payment.ghiChu || "-" }}
                  </td>

                  <!-- Nhân viên xác nhận -->
                  <td>
                    {{ payment.tenNhanVienXacNhan || "-" }}
                  </td>
                </tr>
              </tbody>

            </table>
          </div>


                            <div class="order-timeline">
                  <h4>Lịch sử đơn hàng</h4>
                  <div class="timeline">
                    <!-- Mốc 1: Tạo đơn -->
                    <div class="timeline-item completed">
                      <div class="timeline-icon">✓</div>
                      <div class="timeline-content">
                        <div class="timeline-header">
                          <span class="timeline-title">Tạo đơn hàng</span>
                          <span class="timeline-time">
                            {{ formatDateTime(selectedOrder?.ngayTao) }}
                          </span>
                        </div>
                        <div class="timeline-description">
                          Nhân viên - {{ selectedOrder?.tenNhanVien || '---' }}
                        </div>
                      </div>
                    </div>

                    <!-- Mốc 2: Hoàn thành -->
                    <div class="timeline-item completed" v-if="selectedOrder?.ngayThanhToan">
                      <div class="timeline-icon">✓</div>
                      <div class="timeline-content">
                        <div class="timeline-header">
                          <span class="timeline-title">Hoàn thành</span>
                          <span class="timeline-time">
                            {{ formatDateTime(selectedOrder?.ngayThanhToan) }}
                          </span>
                        </div>
                        <div class="timeline-description">
                          Nhân viên - {{
                            selectedOrder?.lichSuThanhToan?.[0]?.tenNhanVienXacNhan || '---'
                          }}
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
                v-for="item in products"
                :key="item.id"
                class="product-item"
              >
                <div class="product-image">
                  <img v-if="item.anhSanPham && item.anhSanPham.length > 0"
                      :src="item.anhSanPham[0]"
                      :alt="item.tenNhaSanXuat" />
                  <div v-else class="placeholder-image">👟</div>
                </div>

                <div class="product-info">
                  <h5>{{ item.tenNhaSanXuat }} - Size {{ item.tenKichThuoc }}</h5>
                  <p class="product-details">
                    Màu: {{ item.tenMauSac }} | 
                    Xuất xứ: {{ item.tenXuatXu }}
                  </p>
                  <p class="product-details">
                    Đế: {{ item.tenDeGiay }} | 
                    Chất liệu: {{ item.tenChatLieu }}
                  </p>
                  <p class="product-details">
                    Trọng lượng: {{ item.tenTrongLuong }}
                  </p>
                </div>

                <div class="product-quantity">SL: {{ item.soLuong }}</div>

                <div class="product-price">
                  <span v-if="item.giaTriGiamGia">
                    <span class="old-price">{{ formatCurrency(item.giaBan) }}</span>
                    <span class="discounted-price">
                      {{ formatCurrency(item.giaBan * (1 - item.giaTriGiamGia / 100)) }}
                    </span>
                    <span class="discount-tag">-{{ item.giaTriGiamGia }}%</span>
                  </span>
                  <span v-else>
                    {{ formatCurrency(item.giaBan) }}
                  </span>
                </div>
              </div>
            </div>

          

              <!-- Order Summary -->
              <div class="order-summary">
                <div class="summary-row">
                  <span>Phiếu giảm giá:</span>
                  <span>{{ selectedOrder.maPhieuGiamGia || "N/A" }}</span>
                </div>
                <div class="summary-row">
                  <span>Giảm giá từ cửa hàng:</span>
                  <span>{{ selectedOrder.giaTriGiamGia  || "0%" }}%</span>
                </div>
                <div class="summary-row">
                  <span>Tổng tiền hàng:</span>
                  <span>{{ formatCurrency(selectedOrder.tongTien) }}</span>
                </div>
                <!-- <div class="summary-row">
                  <span>Giảm giá:</span>
                  <span class="discount"
                    >-{{ formatCurrency(selectedOrder.soTienGiam) }}</span>
                </div> -->
                <div class="summary-row">
                  <span>Phí vận chuyển:</span>
                  <span>{{ formatCurrency(selectedOrder.phiVanChuyen) }}</span>
                </div>
                <div class="summary-row">
                  <span
                    >Miễn phí vận chuyển với đơn hàng có tổng tiền trên
                    1.000.000 VND</span>
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

import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { exportToExcel, formatDataForExcel } from '../../utils/xuatExcel.js'
import ActionButton from "@/components/ui/NutHanhDong.vue";
import ButtonGroup from "@/components/ui/NhomNut.vue";
import axios from "axios"



const router = useRouter();
const selectedOrder = ref(null);        // hóa đơn đang xem chi tiết
const showDetailModal = ref(false); 
const showEditModal = ref(false);
const editingOrder = ref({});

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
      console.error(" API format không khớp:", response);
      orders.value = [];
      backendTotalOrders.value = 0;
      backendTotalPages.value = 0;
    }

    console.log("Fetched orders:", orders.value);
  } catch (err) {
    console.error(" Lỗi khi gọi API:", err);
    error.value = "Không thể tải dữ liệu từ server";
  } finally {
    loading.value = false;
  }
};




const statusTabs = [
  { value: "TAT_CA", label: "TẤT CẢ", icon: "" },
  { value: "CHO_XAC_NHAN", label: "CHỜ XÁC NHẬN", icon: "" },
  { value: "CHO_GIAO_HANG", label: "CHỜ GIAO HÀNG", icon: "" },
  { value: "DANG_VAN_CHUYEN", label: "ĐANG VẬN CHUYỂN", icon: "" },
  // { value: "DA_GIAO_HANG", label: "ĐÃ GIAO HÀNG", icon: "" },
  // { value: "CHO_THANH_TOAN", label: "CHỜ THANH TOÁN", icon: "" },
  { value: "DA_THANH_TOAN", label: "ĐÃ THANH TOÁN", icon: "" },
  { value: "HOAN_THANH", label: "HOÀN THÀNH", icon: "" },
  { value: "DA_HUY", label: "ĐÃ HỦY", icon: "" },
];





// Computed
const filteredOrders = computed(() => {
  let filtered = orders.value;
  console.log("Total orders:", orders.value.length);
  console.log("Selected status:", selectedStatus.value);
  console.log("From date:", fromDate.value);
  console.log("To date:", toDate.value);

  if (searchQuery.value) {
  filtered = filtered.filter(
    (order) =>
      order.maHoaDon?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      (order.tenNguoiNhan &&
        order.tenNguoiNhan.toLowerCase().includes(searchQuery.value.toLowerCase()))
  )
}
    if (selectedType.value !== "") {
        filtered = filtered.filter((order) => order.loaiDon === selectedType.value);
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

  console.log("Filtered orders count:", filtered.length);
  console.log("Start index:", startIndex.value, "End index:", endIndex.value);

  return filtered.slice(startIndex.value, endIndex.value);

});
//
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
  if (selectedType.value !== "") {
    filtered = filtered.filter(
      (order) => String(order.loaiDon) === selectedType.value
    );
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
    selectedOrder.value = { ...order };   // clone dữ liệu để hiển thị chi tiết
    showDetailModal.value = true;    
  };
  const closeDetailModal = () => {
  showDetailModal.value = false;
  selectedOrder.value = null;
};
const createOrder = () => {
  // Navigate to POS system to create new order
  router.push("/sales/pos");
};
const scanQRCode = () => {
  console.log("Open QR code scanner");
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

const printOrder = (order) => {
 console.log("🖨️ In đơn:", order);
  // Ở đây bạn có thể mở window.print() hoặc gọi API tạo PDF
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
  console.log("Refreshing orders data...");
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


const editOrder = (order) => {
  editingOrder.value = {
    id: order.id,   // PHẢI có dòng này để update dùng id
    tongTienSauGiam: order.tongTienSauGiam,
    trangThai: order.trangThai,
    loaiDon: order.loaiDon === true || order.loaiDon === 1,
    tenKhachHang: order.tenKhachHang, // chỉ hiển thị
    tenHoaDon: order.tenHoaDon,
    phiVanChuyen: order.phiVanChuyen,
    maHoaDon: order.maHoaDon,
    tongTien: order.tongTien,
    ghiChu: order.ghiChu,
    tenNguoiNhan: order.tenNguoiNhan,
    diaChiNhanHang: order.diaChiNhanHang,
    soDienThoaiNguoiNhan: order.soDienThoaiNguoiNhan,
    emailNguoiNhan: order.emailNguoiNhan,
    ngayThanhToan: order.ngayThanhToan,
    ngayTao: order.ngayTao,
    idKhachHang: order.idKhachHang,
    idNhanVien: order.idNhanVien,
    idPhieuGiamGia: order.idPhieuGiamGia,
  };
  showEditModal.value = true;
};




// đóng form sửa
const closeEditModal = () => {
  showEditModal.value = false
  editingOrder.value = {}
}

// cập nhật đơn hàng
// cập nhật đơn hàng
const updateOrder = async () => {
  try {
    const id = editingOrder.value?.id;
    if (!id) {
      alert("❌ Không tìm thấy ID đơn hàng!");
      return;
    }

    const payload = {
  tenHoaDon: editingOrder.value.tenHoaDon || "",
  loaiDon: editingOrder.value.loaiDon,     
  phiVanChuyen: Number(editingOrder.value.phiVanChuyen) || 0,
  tongTien: Number(editingOrder.value.tongTien) || 0,
  tongTienSauGiam: Number(editingOrder.value.tongTienSauGiam) || 0,
  ghiChu: editingOrder.value.ghiChu || "",
  tenNguoiNhan: editingOrder.value.tenNguoiNhan || "",
  diaChiNhanHang: editingOrder.value.diaChiNhanHang || "",
  soDienThoaiNguoiNhan: editingOrder.value.soDienThoaiNguoiNhan || "",
  emailNguoiNhan: editingOrder.value.emailNguoiNhan || "",
  ngayThanhToan: editingOrder.value.ngayThanhToan 
      ? editingOrder.value.ngayThanhToan.slice(0,10) : null,
  ngayTao: editingOrder.value.ngayTao 
      ? editingOrder.value.ngayTao.slice(0,10) : null,
  idKhachHang: editingOrder.value.idKhachHang || null,
  idNhanVien: editingOrder.value.idNhanVien || null,
  idPhieuGiamGia: editingOrder.value.idPhieuGiamGia || null,
  trangThai: editingOrder.value.trangThai === true,
};


    console.log("Update payload:", payload);

    const { data } = await axios.put(
      `http://localhost:8080/api/hoa-don-management/update/${id}`, 
      payload,
      { headers: { "Content-Type": "application/json" } }
    );

    alert(data?.message || "✅ Cập nhật thành công!");
    
    closeEditModal();
  } catch (err) {
    console.error("❌ Update error:", err?.response?.data || err);
    alert("❌ Cập nhật thất bại: " + (err?.response?.data?.message || err.message));
  }
};





</script>

<style scoped>
.orders-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  background: #fff;
  padding: 10px 16px;
  border-radius: 8px;
  box-shadow: 0 1px 2px rgba(0,0,0,0.05);
}

.action-button-info {
  background-color: #ffffff; /* xanh đậm */
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}

.action-button-info:hover {
  background-color: #e0e0e0; 
  color: #333;              
  border: 1px solid #5f768e; 
  cursor: pointer;
}
/* Nút Chỉnh sửa */
.action-button-warning {
  background-color: #ffffff; /* xanh đậm */
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}

.action-button-warning:hover {
  background-color: #e0e0e0; 
  color: #333;              
  border: 1px solid #5f768e; 
  cursor: pointer;
}

/* Nút Xóa */
.action-button-danger {
 background-color: #ffffff; /* xanh đậm */
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}
.action-button-danger:hover {
 background-color: #e0e0e0; 
  color: #333;              
  border: 1px solid #5f768e; 
  cursor: pointer;
}
.modal-content.large {
  max-width: 1200px;
  width: 90%;
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.header-actions {
     display: flex;
  align-items: center;
  gap: 10px;
}

.btn-action {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  background: #f5f6f8;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  color: #333;
  transition: all 0.2s ease;
}

.btn-action i {
  font-size: 16px;
}

.btn-action:hover {
  background: #e8ebee;
  transform: translateY(-1px);
  box-shadow: 0 2px 6px rgba(0,0,0,0.08);
}

.btn-action.primary {
  background: #7588af;
  color: white;
  border: none;
}

.btn-action.primary:hover {
  background: #8b95af;
}

.order-management {
  max-width: 1600px;
  margin: 0 auto;
  padding: 1.5rem;
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  min-height: 100vh;
}

/* === STATISTICS OVERVIEW === */
.stats-overview {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: linear-gradient(135deg, #ffffff 0%, #fafbfc 100%);
  border-radius: 16px;
  padding: 1.5rem;
  border: 1px solid var(--border-color);
  display: flex;
  align-items: center;
  gap: 1rem;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.stat-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #4ade80, #22c55e);
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.stat-card.total::before {
  background: linear-gradient(90deg, #4ade80, #22c55e);
}

.stat-card.pending::before {
  background: linear-gradient(90deg, #f093fb, #f5576c);
}

.stat-card.processing::before {
  background: linear-gradient(90deg, #4facfe, #00f2fe);
}

.stat-card.completed::before {
  background: linear-gradient(90deg, #43e97b, #38f9d7);
}

.stat-icon {
  font-size: 2.5rem;
  opacity: 0.8;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 2rem;
  font-weight: 800;
  color: var(--text-primary);
  line-height: 1;
  margin-bottom: 0.25rem;
}

.stat-label {
  font-size: 0.875rem;
  color: var(--text-secondary);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-trend {
  font-size: 0.75rem;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  background: var(--gray-100);
  color: var(--text-secondary);
  font-weight: 600;
}

.stat-trend.positive {
  background: rgba(74, 222, 128, 0.1);
  color: var(--success-color);
}

/* === ADVANCED FILTERS PANEL === */
.filters-panel {
  background: white;
  border-radius: 16px;
  margin-bottom: 2rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  border: 1px solid var(--border-color);
  overflow: hidden;
}

.filters-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem 2rem;
  border-bottom: 1px solid var(--border-color);
  background: #e5e9f0; /* nền panel */
}

.filters-header h3 {
  margin: 0;
  color: var(--text-primary);
  font-size: 1.125rem;
  font-weight: 600;
}

.btn-reset {
  background: transparent !important;
  color: var(--text-secondary) !important;
  border: 1px solid var(--border-color) !important;
  padding: 0.5rem 1rem !important;
}

.btn-reset:hover {
  background: var(--gray-50) !important;
  color: var(--text-primary) !important;
}

.filters-content {
  padding: 2rem;
}

.search-section {
  margin-bottom: 2rem;
}

.search-input-group {
  position: relative;
  max-width: 600px;
  width: 600px;
}

.search-icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  font-size: 1.125rem;
  color: var(--text-secondary);
  z-index: 2;
}

.search-input {
  width: 100%;
  padding: 0.875rem 1rem 0.875rem 3rem;
  border: 2px solid var(--border-color);
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.3s ease;
  background: white;
}

.search-input:focus {
  outline: none;
  border-color: #4ade80;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1);
}

.clear-search {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: var(--text-secondary);
  cursor: pointer;
  font-size: 1.125rem;
  padding: 0.25rem;
  border-radius: 50%;
  transition: all 0.2s ease;
}

.clear-search:hover {
  background: var(--gray-100);
  color: var(--text-primary);
}

.filter-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  align-items: center;
}
.filter-group {
  flex: 1 1 30%;
  min-width: 200px;
}


.filter-input {
  flex: 1 1 1;
  min-width: 0; /* để các phần tử co giãn đều nhau */
  min-height: 38px;
}
@media (max-width: 578px) {
  .filter-input {
    max-width: 100%;
  }
}
.filter-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-primary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.date-range-group {
  display: flex;
  gap: 10px;
  align-items: center;
}

.date-input {
  flex: 1;
  padding: 0.75rem;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  font-size: 0.875rem;
  transition: border-color 0.3s ease;
}

.date-input:focus {
  outline: none;
  border-color: #4ade80;
}

.date-separator {
  color: var(--text-secondary);
  font-weight: 600;
}

.radio-group {
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  cursor: pointer;
  color: #7d9dd1;
}

.radio-option input[type="radio"] {
   width: 16px;
  height: 16px;
  accent-color: #22c55e;
  cursor: pointer;
  margin: 0;
}

.radio-text {
  color: var(--text-secondary);
  transition: color 0.2s ease;
}

.radio-option:hover .radio-text {
  color: var(--text-primary);
}

.amount-range-group {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.amount-input {
  flex: 1;
  min-width: 80px;
  padding: 0.75rem;
  border: 3px solid var(--border-color);
  font-size: 0.875rem;
  transition: border-color 0.3s ease;
}

.amount-input:focus {
  outline: none;
  border-color: #ebebeb;
}

.amount-separator {
  color: var(--text-secondary);
  font-weight: 600;
  flex-shrink: 0;
}

/* === STATUS TABS ENHANCED === */
.status-tabs-container {
  display: flex;
  align-items: center;
  gap: 12px; /* khoảng cách giữa tab và view-options */
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  background: #fff;
  padding: 10px 16px;
  border-radius: 8px;
}

.status-tabs {
 display: flex;
  gap: 8px;
}

.status-tab {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.5rem 0.875rem;
  border: 1px solid var(--border-color);
  background: white;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-weight: 500;
  white-space: nowrap;
  font-size: 0.8125rem;
}

.status-tab:hover {
  background: var(--gray-50);
  border-color: #4ade80;
}

.status-tab.active {
  background: #4ade80;
  border-color: #4ade80;
  color: white;
  box-shadow: 0 4px 12px rgba(74, 222, 128, 0.3);
}

.tab-icon {
  font-size: 1rem;
}

.tab-text {
  font-weight: 500;
}

.tab-count {
  background: rgba(255, 255, 255, 0.2);
  padding: 0.125rem 0.375rem;
  border-radius: 6px;
  font-size: 0.6875rem;
  font-weight: 600;
  min-width: 20px;
  text-align: center;
}

.status-tab:not(.active) .tab-count {
  background: var(--gray-100);
  color: var(--text-secondary);
}

.view-options {
  display: flex;
  gap: 6px;
}

.view-btn {
  padding: 0.75rem;
  border: 2px solid var(--border-color);
  background: white;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1.125rem;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 44px;
  min-height: 44px;
}

.view-btn:hover {
  background: var(--gray-50);
  border-color: #4ade80;
}

.view-btn.active {
  background: #4ade80;
  border-color: #4ade80;
  color: white;
}

/* === ENHANCED TABLE VIEW === */
.orders-container {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  border: 1px solid var(--border-color);
}

.table-container {
  overflow-x: auto;
}

.orders-table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
  font-size: 14px;
  
}
.orders-table th {
  text-align: left;
  padding: 12px;
  font-weight: 600;
  color: #374151;
  border-bottom: 2px solid #e5e7eb;
}
.orders-table td {
  padding: 12px;
  border-bottom: 1px solid #e5e7eb;
  color: #111827;
  vertical-align: middle;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.orders-table thead th {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  color: var(--text-primary);
  font-weight: 600;
  padding: 1.25rem 1rem;
  text-align: left;
  border-bottom: 2px solid var(--border-color);
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.sortable {
  cursor: pointer;
  user-select: none;
  transition: background-color 0.2s ease;
}

.sortable:hover {
  background: var(--gray-100) !important;
}

.sort-icon {
  margin-left: 0.5rem;
  opacity: 0.5;
  transition: opacity 0.2s ease;
}

.sortable:hover .sort-icon {
  opacity: 1;
}

.order-row {
  transition: all 0.2s ease;
  border-bottom: 1px solid var(--border-light);
}

.order-row:hover {
  background: var(--gray-50);
}

.order-row:last-child {
  border-bottom: none;
}

.orders-table td {
  padding: 1.25rem 1rem;
  vertical-align: middle;
}

.code-cell {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.code-text {
  font-weight: 700;
  color: #424242;
  font-size: 0.9375rem;
}

.code-id {
  font-size: 0.75rem;
  color: var(--text-secondary);
  opacity: 0.7;
}

.customer-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.customer-name {
  font-weight: 600;
  color: var(--text-primary);
  font-size: 0.9375rem;
}

.customer-phone {
  font-size: 0.8125rem;
  color: var(--text-secondary);
}

.items-info {
  font-size: 0.875rem;
  color: var(--text-secondary);
}

.items-count {
  font-weight: 500;
}

.amount-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 0.25rem;
}

.amount-value {
  font-weight: 700;
  color: var(--success-color);
  font-size: 1rem;
}

.type-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}
.type-badge.online {
  background: #e0f2fe;
  color: #0284c7;
}
.type-badge.offline {
  background: #fef3c7;
  color: #d97706;
}

/* Badge Trạng thái */
.status-badge {
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}
.status-badge.hoan-thanh {
  background: #dcfce7;
  color: #16a34a;
}
.status-badge.cho-xac-nhan {
  background: #fef9c3;
  color: #ca8a04;
}
.status-badge.da-huy {
  background: #fee2e2;
  color: #dc2626;
}
.status-badge {
  display: inline-block;
  padding: 0.375rem 0.875rem;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  text-align: center;
  min-width: 80px;
}

.date-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  align-items: flex-start;
}

.date-value {
  font-weight: 600;
  color: var(--text-primary);
  font-size: 0.875rem;
}

.time-value {
  font-size: 0.75rem;
  color: var(--text-secondary);
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
  justify-content: center;
}

.action-btn {
  padding: 0.5rem;
  border: 1px solid var(--border-color);
  background: white;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 36px;
  min-height: 36px;
}

.action-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.action-btn.view-btn:hover {
  background: rgba(59, 130, 246, 0.1);
  border-color: #3b82f6;
}

.action-btn.edit-btn:hover {
  background: rgba(245, 158, 11, 0.1);
  border-color: #f59e0b;
}

.action-btn.print-btn:hover {
  background: rgba(107, 114, 128, 0.1);
  border-color: #6b7280;
}

/* === ENHANCED GRID VIEW === */
.grid-view {
  padding: 1.5rem;
}

.orders-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
}

.order-card {
  background: white;
  border-radius: 12px;
  border: 1px solid var(--border-color);
  overflow: hidden;
  transition: all 0.3s ease;
}

.order-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.card-header {
  padding: 1.25rem;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  border-bottom: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
}

.order-meta {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.order-card .order-code {
  font-weight: 700;
  color: #4ade80;
  font-size: 1.125rem;
}

.card-body {
  padding: 1.25rem;
}

.customer-section {
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid var(--border-light);
}

.customer-section .customer-name {
  font-weight: 600;
  color: var(--text-primary);
  font-size: 1rem;
  margin-bottom: 0.25rem;
}

.customer-section .customer-phone {
  font-size: 0.875rem;
  color: var(--text-secondary);
}

.order-details {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-item .label {
  font-size: 0.875rem;
  color: var(--text-secondary);
  font-weight: 500;
}

.detail-item .value {
  font-weight: 600;
  color: var(--text-primary);
}

.detail-item .value.amount {
  color: var(--success-color);
  font-size: 1rem;
}

.card-actions {
  padding: 1.25rem;
  background: var(--gray-50);
  display: flex;
  gap: 0.75rem;
}

.card-actions .action-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.75rem;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  min-height: 40px;
}

.card-actions .action-btn.primary {
  background: #4ade80;
  border-color: #4ade80;
  color: white;
}

.card-actions .action-btn.secondary {
  background: white;
  border-color: var(--border-color);
  color: var(--text-primary);
}

.card-actions .action-btn.tertiary {
  background: var(--gray-100);
  border-color: var(--gray-200);
  color: var(--text-secondary);
}

/* === ENHANCED PAGINATION === */
.pagination-section {
  padding: 1.5rem 2rem;
  background: var(--gray-50);
  border-top: 1px solid var(--border-color);
}

.pagination-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
  gap: 1rem;
}

.showing {
  font-size: 0.875rem;
  color: var(--text-secondary);
  font-weight: 500;
}

.per-page-selector {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.875rem;
  color: var(--text-secondary);
}

.per-page-select {
  padding: 0.5rem 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: white;
  font-size: 0.875rem;
}

.pagination-controls {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;
}

.pagination-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 40px;
  height: 40px;
  border: 1px solid var(--border-color);
  background: white;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.875rem;
}

.pagination-btn:hover:not(:disabled) {
  background: var(--gray-50);
  border-color: #323232;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-numbers {
  display: flex;
  gap: 0.25rem;
}

.page-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 55px;
  height: 35px;
  border: 1px solid var(--border-color);
  background: white;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-weight: 500;
  font-size: 0.875rem;
}

.page-btn:hover:not(.active):not(:disabled) {
  background: var(--gray-50);
  border-color: #4ade80;
}

.page-btn.active {
  background: #ffffff;
  border-color: #141414;
  color: rgb(0, 0, 0);
}

.page-btn.dots {
  border: none;
  background: none;
  cursor: default;
  color: var(--text-secondary);
}

.page-btn:disabled {
  cursor: not-allowed;
}

/* page-header styles are now defined in globals.css */

/* Modern Button Styles */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 1.5rem;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 0.9375rem;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  position: relative;
  overflow: hidden;
}

.btn:before {
  content: "";
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.2),
    transparent
  );
  transition: left 0.5s;
}

.btn:hover:before {
  left: 100%;
}

.btn-primary {
  background: linear-gradient(135deg, #4ade80, #22c55e);
  color: white;
  box-shadow: 0 4px 15px rgba(74, 222, 128, 0.3);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.6);
}

.btn-secondary {
  background: linear-gradient(135deg, #4ade80, #16a34a);
  color: white;
  box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
}

.btn-secondary:hover {
  background: linear-gradient(135deg, #5b5fcf, #3730a3);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(99, 102, 241, 0.6);
}

.btn-outline {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(10px);
}

.btn-outline:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
  transform: translateY(-2px);
}

/* btn-export styles now in globals.css */

.btn-icon {
  font-size: 1.125rem;
}

.btn-text {
  font-weight: 600;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .filter-grid {
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1.25rem;
  }
}

@media (max-width: 768px) {
  .filter-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .search-input-group {
    max-width: 100%;
  }

  .date-range-group {
    flex-direction: column;
    align-items: stretch;
    gap: 0.75rem;
  }

  .date-separator {
    display: none;
  }

  .amount-range-group {
    flex-direction: column;
    align-items: stretch;
    gap: 0.75rem;
  }

  .amount-separator {
    display: none;
  }

  .radio-group {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .status-tabs-container {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }

  .view-options {
    justify-content: center;
  }
  /* page-header responsive styles are handled in globals.css */

  .btn-action {
  display: flex;
  align-items: center;
  gap: 6px;
  background: #f8f9fa;
  border: 1px solid #ddd;
  border-radius: 6px;
  padding: 6px 12px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s ease;
}
.btn-action:hover {
  background: #e9ecef;
  border-color: #ccc;
}

.btn-action.primary {
  background: #4ade80;
  border-color: #4ade80;
  color: white;
  font-weight: 500;
}

.btn-action.primary:hover {
  background: #45a049;
}

.btn-icon {
  font-size: 16px;
}

  .status-tabs {
    flex-wrap: wrap;
  }

  .table {
    font-size: 0.875rem;
  }

  .table th,
  .table td {
    padding: 0.5rem;
  }

  .action-buttons {
    flex-direction: column;
  }

  .pagination-wrapper {
    flex-direction: column;
    gap: 1rem;
  }

  .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.45);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 1000;
  }

  .order-actions {
    flex-direction: column;
  }

  .info-grid {
      display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  }
  .payment-history table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}
.payment-history th, 
.payment-history td {
  border: 1px solid #eee;
  padding: 8px;
  text-align: center;
}
.payment-history th {
  background: #f8f8f8;
}

/* Timeline */
.timeline {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.timeline-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}
.timeline-icon {
  background: #4caf50;
  color: #fff;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* Product List */
.product-items {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.product-item {
  display: grid;
  grid-template-columns: 60px 1fr auto auto;
  gap: 12px;
  align-items: center;
  padding: 8px;
  border-bottom: 1px solid #eee;
}
.product-image img {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 6px;
}

/* Summary */
.order-summary {
  margin-top: 16px;
  border-top: 2px solid #f0f0f0;
  padding-top: 12px;
}
.summary-row {
  display: flex;
  justify-content: space-between;
  padding: 6px 0;
}
.summary-row.total {
  font-weight: bold;
  font-size: 16px;
}
.total-amount {
  color: #e53935;
}
.order-detail-modal {
  display: flex;
  flex-direction: column;
  height: 100%; /* chiếm toàn bộ chiều cao modal */
}
.order-detail-header {
  position: sticky;
  top: 0;
  background: #fff; /* để header không bị trong suốt */
  z-index: 10;
  padding: 10px;
  border-bottom: 1px solid #eee;
}

.order-detail-body {
  flex: 1;
  overflow-y: auto; /* cuộn riêng phần nội dung */
  padding: 10px 20px;
}

  .product-item {
    flex-direction: column;
    text-align: center;
  }

  .timeline-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.25rem;
  }
}
.btn-export {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  border: 1px solid #2ab37f; /* xanh lá */
  border-radius: 8px;
  background: #0fbc43;       /* nền xanh luôn */
  color: #fff;               /* chữ trắng sáng */
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-export .btn-icon {
  font-size: 16px;
}

.btn-export:hover {
  background: #16a34a; /* xanh đậm hơn khi hover */
}
  /* Chỉ chỉnh phần radio Loại đơn hàng */
.radio-group {
  display: flex;
  gap: 20px; /* khoảng cách giữa các lựa chọn */
  align-items: center;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  cursor: pointer;
  color: #374151;
}

.radio-option input[type="radio"] {
  width: 16px;
  height: 16px;
  accent-color: #22c55e; /* màu xanh đồng bộ */
  cursor: pointer;
}

.radio-text {
  user-select: none;
}
.radio-group {
  display: flex;
  align-items: center; /* Căn giữa dọc */
  gap: 15px;
}

.radio-option {
  display: flex;
  align-items: center; /* Căn giữa input radio và text */
  gap: 5px;
}

.radio-option input[type="radio"] {
  margin: 0; /* bỏ margin mặc định của radio */
  vertical-align: middle;
}

</style>
