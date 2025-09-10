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
        <!-- Search Section -->
        <div class="tim-kiem-section">
          <div class="tim-kiem-input-group">
            <div class="tim-kiem-icon">
              <img :src="FindIcon" alt="Search" class="icon-sm" />
            </div>
            <input
              type="text"
              placeholder="Tìm theo mã đơn hàng, tên khách hàng, SĐT..."
              v-model="searchQuery"
              class="tim-kiem-input"
            />
            <button
              v-if="searchQuery"
              class="xoa-tim-kiem"
              @click="searchQuery = ''"
            >
              <img :src="CancelIcon" alt="Clear" class="icon-xs" />
            </button>
          </div>
        </div>

        <!-- Filter Groups Grid -->
        <div class="bo-loc-grid">
          <!-- Date Range Filter -->
          <div class="bo-loc-group">
            <div class="bo-loc-header">
              <img :src="ClockIcon" alt="Time" class="icon-sm" />
              <span class="bo-loc-title">Thời gian</span>
            </div>
            <div class="thoi-gian-range">
              <div class="ngay-input-wrapper">
                <input
                  type="date"
                  v-model="fromDate"
                  class="ngay-input"
                  title="Từ ngày"
                />
                <label class="ngay-label">Từ ngày</label>
              </div>
              <div class="range-separator">
                <img :src="DateIcon" alt="To" class="icon-xs" />
              </div>
              <div class="ngay-input-wrapper">
                <input
                  type="date"
                  v-model="toDate"
                  class="ngay-input"
                  title="Đến ngày"
                />
                <label class="ngay-label">Đến ngày</label>
              </div>
            </div>
          </div>

          <!-- Order Type Filter -->
          <div class="bo-loc-group">
            <div class="bo-loc-header">
              <img :src="OrdersIcon" alt="Orders" class="icon-sm" />
              <span class="bo-loc-title">Loại đơn hàng</span>
            </div>
            <div class="loai-don-options">
              <label class="loai-don-option" :class="{ active: selectedType === '' }">
                <input type="radio" value="" v-model="selectedType" class="sr-only" />
                <span class="option-indicator">•</span>
                <span class="option-text">Tất cả</span>
              </label>
              <label class="loai-don-option" :class="{ active: selectedType === 'online' }">
                <input type="radio" value="online" v-model="selectedType" class="sr-only" />
                <span class="option-indicator">🌐</span>
                <span class="option-text">Trực tuyến</span>
              </label>
              <label class="loai-don-option" :class="{ active: selectedType === 'pos' }">
                <input type="radio" value="pos" v-model="selectedType" class="sr-only" />
                <span class="option-indicator">🏪</span>
                <span class="option-text">Tại quầy</span>
              </label>
            </div>
          </div>

          <!-- Amount Range Filter -->
          <div class="bo-loc-group">
            <div class="bo-loc-header">
              <img :src="MoneyIcon" alt="Money" class="icon-sm" />
              <span class="bo-loc-title">Khoảng giá</span>
            </div>
            <div class="gia-range">
              <div class="gia-input-wrapper">
                <input
                  type="number"
                  v-model="minAmount"
                  class="gia-input"
                  placeholder="0"
                  title="Giá từ"
                />
                <label class="gia-label">Từ (đ)</label>
              </div>
              <div class="range-separator">
                <img :src="MoneyIcon" alt="To" class="icon-xs" />
              </div>
              <div class="gia-input-wrapper">
                <input
                  type="number"
                  v-model="maxAmount"
                  class="gia-input"
                  placeholder="∞"
                  title="Giá đến"
                />
                <label class="gia-label">Đến (đ)</label>
              </div>
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
      class="detail-modal-overlay"
      @click="showDetailModal = false"
    >
      <div class="detail-modal-content" @click.stop>
        <div class="detail-modal-header">
          <div class="detail-header-content">
            <div class="detail-modal-icon">
              <img :src="OrdersIcon" alt="Order" class="icon-lg" />
            </div>
            <div class="detail-title-section">
              <h3 class="detail-modal-title">Thông tin đơn hàng</h3>
              <p class="detail-modal-subtitle">Mã đơn hàng: #{{ selectedOrder?.id }}</p>
            </div>
          </div>
          <button class="detail-close-btn" @click="showDetailModal = false">
            <img :src="CancelIcon" alt="Close" class="icon-md" />
          </button>
        </div>

        <!-- Order Actions in Center -->
        <div class="detail-order-actions">
          <button class="detail-action-btn primary" @click="editOrder(selectedOrder)">
            <img :src="EditIcon" alt="Edit" class="icon-sm" />
            <span>Chỉnh sửa</span>
          </button>
          <button class="detail-action-btn primary" @click="printOrder(selectedOrder)">
            <img :src="PrintIcon" alt="Print" class="icon-sm" />
            <span>In hóa đơn</span>
          </button>
          <button class="detail-action-btn primary" @click="exportOrderDetail">
            <img :src="ExportIcon" alt="Export" class="icon-sm" />
            <span>Xuất file</span>
          </button>
        </div>

        <div class="detail-modal-body" v-if="selectedOrder">

          <!-- Order Overview Card -->
          <div class="modern-info-card">
            <div class="card-header">
              <div class="header-content">
                <h4 class="card-title">Thông tin cơ bản</h4>
                <span class="card-subtitle">Chi tiết đơn hàng và khách hàng</span>
              </div>
              <div class="order-type-badge" :class="selectedOrder.loaiDon || 'pos'">
                <span class="type-icon">{{
                  (selectedOrder.loaiDon || 'pos') === 'online' ? '🌐' : '🏦'
                }}</span>
                <span class="type-text">{{
                  (selectedOrder.loaiDon || 'pos') === 'online' ? 'Trực tuyến' : 'Tại quầy'
                }}</span>
              </div>
            </div>
            <div class="modern-info-grid">
              <div class="info-item">
                <div class="info-label">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>
                    <rect x="8" y="2" width="8" height="4" rx="1" ry="1"/>
                  </svg>
                  <span>Mã đơn hàng</span>
                </div>
                <div class="info-value">#{{ selectedOrder.id }}</div>
              </div>
              <div class="info-item">
                <div class="info-label">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                  </svg>
                  <span>Khách hàng</span>
                </div>
                <div class="info-value">{{ selectedOrder.tenKhachHang || 'Khách lẻ' }}</div>
              </div>
              <div class="info-item">
                <div class="info-label">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                  </svg>
                  <span>Số điện thoại</span>
                </div>
                <div class="info-value">{{ selectedOrder.soDienThoai || 'N/A' }}</div>
              </div>
              <div class="info-item">
                <div class="info-label">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="3"/>
                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1 1.51V6a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V12a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/>
                  </svg>
                  <span>Trạng thái</span>
                </div>
                <div class="info-value">
                  <span class="modern-status-badge" :class="getStatusClass(selectedOrder.trangThai)">
                    {{ getStatusText(selectedOrder.trangThai) }}
                  </span>
                </div>
              </div>
              <div class="info-item">
                <div class="info-label">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/>
                    <polyline points="12,6 12,12 16,14"/>
                  </svg>
                  <span>Ngày tạo</span>
                </div>
                <div class="info-value">{{ formatDateTime(selectedOrder.ngayTao) }}</div>
              </div>
              <div class="info-item">
                <div class="info-label">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="1" x2="12" y2="23"/>
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                  </svg>
                  <span>Tổng tiền</span>
                </div>
                <div class="info-value amount">{{ formatCurrency(selectedOrder.tongTienSauGiam) }}</div>
              </div>
            </div>
          </div>

          <!-- Product Details Card -->
          <div class="san-pham-card">
            <div class="card-header">
              <div class="header-content">
                <h3 class="card-title">Chi tiết sản phẩm</h3>
                <span class="card-subtitle">Danh sách sản phẩm trong đơn hàng</span>
              </div>
              <div class="so-luong-badge">
                <span>{{ getOrderItemsLength(selectedOrder) }} sản phẩm</span>
              </div>
            </div>
            <div class="san-pham-table">
              <div class="table-header">
                <div class="cot-san-pham">Sản phẩm</div>
                <div class="cot-size">Size</div>
                <div class="cot-mau">Màu</div>
                <div class="cot-so-luong">SL</div>
                <div class="cot-gia">Đơn giá</div>
                <div class="cot-tong">Tổng</div>
              </div>
              <div class="table-body">
                <!-- Check if products exist in either chiTietDonHang or items -->
                <div v-if="getOrderItems(selectedOrder).length === 0" class="no-products-message">
                  <div class="empty-state">
                    <div class="empty-icon">📦</div>
                    <h4>Không có sản phẩm</h4>
                    <p>Đơn hàng này chưa có sản phẩm nào.</p>
                  </div>
                </div>
                <div
                  v-else
                  v-for="(item, index) in getOrderItems(selectedOrder)"
                  :key="index"
                  class="san-pham-row"
                >
                  <div class="cot-san-pham">
                    <div class="san-pham-cell">
                      <div class="san-pham-image-wrapper">
                        <img
                          :src="getItemImage(item)"
                          :alt="getItemName(item)"
                          class="san-pham-image"
                          loading="lazy"
                          @error="handleImageError"
                        />
                      </div>
                      <div class="san-pham-info">
                        <div class="san-pham-name">{{ getItemName(item) }}</div>
                        <div class="san-pham-sku" v-if="getItemCode(item)">
                          SKU: {{ getItemCode(item) }}
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="cot-size">
                    <span class="size-badge">{{ getItemSize(item) }}</span>
                  </div>
                  <div class="cot-mau">
                    <div class="mau-cell" v-if="getItemColor(item)">
                      <div 
                        class="mau-indicator" 
                        :style="{ backgroundColor: getColorCode(getItemColor(item)) }"
                      ></div>
                      <span>{{ getItemColor(item) }}</span>
                    </div>
                    <span v-else class="no-data">N/A</span>
                  </div>
                  <div class="cot-so-luong">
                    <div class="so-luong-badge">{{ getItemQuantity(item) }}</div>
                  </div>
                  <div class="cot-gia">
                    <span class="gia-text">{{ formatCurrency(getItemPrice(item)) }}</span>
                  </div>
                  <div class="cot-tong">
                    <span class="tong-text">{{ formatCurrency(getItemQuantity(item) * getItemPrice(item)) }}</span>
                  </div>
                </div>
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
                <div v-if="getOrderItems(selectedOrder).length === 0" class="no-products-message">
                  <div class="empty-state">
                    <div class="empty-icon">📦</div>
                    <h4>Không có sản phẩm</h4>
                    <p>Đơn hàng này chưa có sản phẩm nào.</p>
                  </div>
                </div>
                <div
                  v-else
                  v-for="item in getOrderItems(selectedOrder)"
                  :key="item.id || item.index"
                  class="product-item"
                >
                  <div class="product-image">
                    <img 
                      v-if="getItemImage(item)" 
                      :src="getItemImage(item)" 
                      :alt="getItemName(item)"
                      @error="handleImageError"
                    />
                    <div v-else class="placeholder-image">👟</div>
                  </div>
                  <div class="product-info">
                    <h5>{{ getItemName(item) }}</h5>
                    <p class="product-details">
                      Mã: {{ getItemCode(item) || 'N/A' }} | Size: {{ getItemSize(item) }}
                    </p>
                  </div>
                  <div class="product-quantity">x{{ getItemQuantity(item) }}</div>
                  <div class="product-price">
                    {{ formatCurrency(getItemPrice(item)) }}
                  </div>
                </div>
              </div>

              <!-- Order Summary -->
              <div class="order-summary">
                <div class="summary-row">
                  <span>Phiếu giảm giá:</span>
                  <span>{{ getOrderField(selectedOrder, 'couponCode', 'maPhieuGiamGia') || "N/A" }}</span>
                </div>
                <div class="summary-row">
                  <span>Giảm giá từ cửa hàng:</span>
                  <span>{{ getOrderField(selectedOrder, 'storeDiscount', 'giamGiaCuaHang') || "0%" }}</span>
                </div>
                <div class="summary-row">
                  <span>Tổng tiền hàng:</span>
                  <span>{{ formatCurrency(getOrderField(selectedOrder, 'subtotal', 'tongTienHang') || 0) }}</span>
                </div>
                <div class="summary-row">
                  <span>Giảm giá:</span>
                  <span class="discount"
                    >-{{ formatCurrency(getOrderField(selectedOrder, 'discount', 'giamGia') || 0) }}</span
                  >
                </div>
                <div class="summary-row">
                  <span>Phí vận chuyển:</span>
                  <span>{{ formatCurrency(getOrderField(selectedOrder, 'shippingFee', 'phiVanChuyen') || 0) }}</span>
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
                    formatCurrency(getOrderField(selectedOrder, 'total', 'tongTienSauGiam', 'tongTien') || 0)
                  }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
    </div>

    <!-- Edit Order Modal -->
    <div
      v-if="showEditModal"
      class="edit-modal-overlay"
      @click.self="showEditModal = false"
    >
      <div class="edit-modal-content">
        <div class="edit-modal-header">
          <div class="edit-header-content">
            <div class="edit-header-left">
              <div class="edit-modal-icon">
                <img :src="EditIcon" alt="Edit" class="icon-lg" />
              </div>
              <div class="edit-title-group">
                <h2 class="edit-modal-title">Chỉnh sửa đơn hàng</h2>
                <p class="edit-modal-subtitle">Mã đơn hàng: #{{ editingOrder?.id }}</p>
              </div>
            </div>
            <button class="edit-close-btn" @click="showEditModal = false">
              <img :src="CancelIcon" alt="Close" class="icon-md" />
            </button>
          </div>
        </div>
        
        <div class="edit-modal-body" v-if="editingOrder">
          <!-- Edit Form -->
          <div class="edit-form-container">
            <!-- Customer Information Section -->
            <div class="edit-info-card">
              <div class="edit-card-header">
                <div class="edit-header-content">
                  <img :src="ProfileIcon" alt="Customer" class="icon-md" />
                  <h3 class="edit-card-title">Thông tin khách hàng</h3>
                  <span class="edit-card-subtitle">Cập nhật thông tin liên hệ</span>
                </div>
              </div>
              <div class="edit-form-grid">
                <div class="edit-form-group">
                  <label class="edit-form-label">
                    <img :src="UsersIcon" alt="Name" class="icon-sm" />
                    Tên khách hàng
                  </label>
                  <input
                    type="text"
                    v-model="editingOrder.tenNguoiNhan"
                    class="edit-form-input"
                    placeholder="Nhập tên khách hàng"
                  />
                </div>
                <div class="edit-form-group">
                  <label class="edit-form-label">
                    <img :src="PhoneIcon" alt="Phone" class="icon-sm" />
                    Số điện thoại
                  </label>
                  <input
                    type="tel"
                    v-model="editingOrder.soDienThoaiNguoiNhan"
                    class="edit-form-input"
                    placeholder="Nhập số điện thoại"
                  />
                </div>
                <div class="edit-form-group full-width">
                  <label class="edit-form-label">
                    <img :src="OrdersIcon" alt="Address" class="icon-sm" />
                    Địa chỉ giao hàng
                  </label>
                  <textarea
                    v-model="editingOrder.diaChiGiaoHang"
                    class="edit-form-textarea"
                    placeholder="Nhập địa chỉ giao hàng"
                    rows="3"
                  ></textarea>
                </div>
              </div>
            </div>

            <!-- Order Status Section -->
            <div class="edit-info-card">
              <div class="edit-card-header">
                <div class="edit-header-content">
                  <img :src="SettingsIcon" alt="Status" class="icon-md" />
                  <h3 class="edit-card-title">Trạng thái đơn hàng</h3>
                  <span class="edit-card-subtitle">Cập nhật trạng thái xử lý</span>
                </div>
              </div>
              <div class="edit-status-selection">
                <div class="edit-status-options">
                  <label
                    v-for="status in orderStatuses"
                    :key="status.value"
                    class="edit-status-option"
                    :class="{ active: editingOrder.trangThai === status.value }"
                  >
                    <input
                      type="radio"
                      :value="status.value"
                      v-model="editingOrder.trangThai"
                      class="edit-status-radio"
                    />
                    <div class="edit-status-card">
                      <div class="edit-status-icon">
                        <img :src="status.icon" alt="Status" class="icon-lg" />
                      </div>
                      <div class="edit-status-text">
                        <div class="edit-status-name">{{ status.label }}</div>
                        <div class="edit-status-desc">{{ status.description }}</div>
                      </div>
                    </div>
                  </label>
                </div>
              </div>
            </div>

            <!-- Order Notes Section -->
            <div class="edit-info-card">
              <div class="edit-card-header">
                <div class="edit-header-content">
                  <img :src="DocumentIcon" alt="Notes" class="icon-md" />
                  <h3 class="edit-card-title">Ghi chú đơn hàng</h3>
                  <span class="edit-card-subtitle">Thêm thông tin bổ sung</span>
                </div>
              </div>
              <div class="edit-form-grid">
                <div class="edit-form-group full-width">
                  <label class="edit-form-label">
                    Ghi chú thêm
                  </label>
                  <textarea
                    v-model="editingOrder.ghiChu"
                    class="edit-form-textarea"
                    placeholder="Nhập ghi chú cho đơn hàng này..."
                    rows="4"
                  ></textarea>
                </div>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="edit-modal-actions">
            <button class="edit-action-btn secondary" @click="showEditModal = false">
              <img :src="CancelIcon" alt="Cancel" class="icon-sm" />
              <span>Hủy bỏ</span>
            </button>
            <button class="edit-action-btn primary" @click="saveOrderChanges">
              <img :src="SaveIcon" alt="Save" class="icon-sm" />
              <span>Lưu thay đổi</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// SVG Icons
import CancelIcon from "@/assets/Cancel.svg?url";
import CelebrationIcon from "@/assets/Celebration.svg?url";
import ChevronLeftIcon from "@/assets/chevron-left.svg?url";
import ChevronRightIcon from "@/assets/chevron-right.svg?url";
import ChevronsLeftIcon from "@/assets/chevrons-left.svg?url";
import ChevronsRightIcon from "@/assets/chevrons-right.svg?url";
import ClipboardIcon from "@/assets/Clipboard.svg?url";
import ClockIcon from "@/assets/Clock.svg?url";
import CompletedIcon from "@/assets/Completed.svg?url";
import CreditCardIcon from "@/assets/CreditCard.svg?url";
import DashboardIcon from "@/assets/Dashboard.svg?url";
import DateIcon from "@/assets/Date.svg?url";
import DocumentIcon from "@/assets/Document.svg?url";
import EditIcon from "@/assets/Edit.svg?url";
import ExcelIcon from "@/assets/Excel.svg?url";
import ExportIcon from "@/assets/Export.svg?url";
import FailedIcon from "@/assets/Failed.svg?url";
import FindIcon from "@/assets/Find.svg?url";
import MoneyIcon from "@/assets/Money.svg?url";
import OrdersIcon from "@/assets/Orders.svg?url";
import PendingIcon from "@/assets/Pending.svg?url";
import PhoneIcon from "@/assets/Phone.svg?url";
import PlusIcon from "@/assets/Plus.svg?url";
import PrintIcon from "@/assets/Print.svg?url";
import ProfileIcon from "@/assets/Profile.svg?url";
import QRIcon from "@/assets/QR.svg?url";
import RefreshIcon from "@/assets/Reload.svg?url";
import SaveIcon from "@/assets/Save.svg?url";
import SettingsIcon from "@/assets/Settings.svg?url";
import ShippingIcon from "@/assets/Shipping.svg?url";
import StatisticsIcon from "@/assets/Statistics.svg?url";
import SuccessIcon from "@/assets/Success.svg?url";
import UsersIcon from "@/assets/Users.svg?url";
import ViewIcon from "@/assets/View.svg?url";


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
const showEditModal = ref(false)
const editingOrder = ref(null)
const orders = ref([])
const backendTotalOrders = ref(0)
const backendTotalPages = ref(0)
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => startIndex.value + itemsPerPage.value)

const loading = ref(false)
const error = ref(null)

// Order statuses for editing
const orderStatuses = ref([
  {
    value: 'CHO_XAC_NHAN',
    label: 'Chờ xác nhận',
    description: 'Đơn hàng chưa được xác nhận',
    icon: PendingIcon
  },
  {
    value: 'CHO_GIAO_HANG',
    label: 'Chờ giao hàng',
    description: 'Đơn hàng đã xác nhận, chờ giao',
    icon: ClockIcon
  },
  {
    value: 'DANG_VAN_CHUYEN',
    label: 'Đang vận chuyển',
    description: 'Đơn hàng đang được giao',
    icon: ShippingIcon
  },
  {
    value: 'HOAN_THANH',
    label: 'Hoàn thành',
    description: 'Đơn hàng đã giao thành công',
    icon: CompletedIcon
  },
  {
    value: 'DA_HUY',
    label: 'Đã hủy',
    description: 'Đơn hàng đã bị hủy',
    icon: FailedIcon
  }
])


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

// Helper functions for order item data handling
const getOrderItems = (order) => {
  if (!order) return [];
  // Check for Vietnamese field names first, then English
  return order.chiTietDonHang || order.items || order.orderItems || [];
};

const getOrderItemsLength = (order) => {
  return getOrderItems(order).length;
};

const getItemName = (item) => {
  return item.tenSanPham || item.name || item.productName || 'Sản phẩm không xác định';
};

const getItemCode = (item) => {
  return item.maSanPham || item.code || item.sku || item.productCode || '';
};

const getItemImage = (item) => {
  return item.hinhAnh || item.image || item.productImage || '/default-product.jpg';
};

const getItemSize = (item) => {
  return item.kichCo || item.size || item.kichThuoc || 'N/A';
};

const getItemColor = (item) => {
  return item.mauSac || item.color || item.mau || '';
};

const getItemQuantity = (item) => {
  return item.soLuong || item.quantity || item.so_luong || 0;
};

const getItemPrice = (item) => {
  return item.giaBan || item.price || item.gia_ban || item.unitPrice || 0;
};

const handleImageError = (event) => {
  event.target.src = '/default-product.jpg';
};

const getColorCode = (colorName) => {
  // Simple color mapping - can be expanded
  const colorMap = {
    'Đen': '#000000',
    'Trắng': '#FFFFFF',
    'Đỏ': '#FF0000',
    'Xanh': '#0000FF',
    'Xanh lá': '#00FF00',
    'Vàng': '#FFFF00',
    'Tím': '#800080',
    'Hồng': '#FFC0CB',
    'Nâu': '#8B4513',
    'Xám': '#808080'
  };
  return colorMap[colorName] || '#666666';
};

const getOrderField = (order, ...fieldNames) => {
  if (!order) return null;
  
  for (const fieldName of fieldNames) {
    if (order[fieldName] !== undefined && order[fieldName] !== null) {
      return order[fieldName];
    }
  }
  return null;
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
  editingOrder.value = JSON.parse(JSON.stringify(order));
  showEditModal.value = true;
};

const saveOrderChanges = async () => {
  if (!editingOrder.value) return;
  try {
    // Example: call API to update order
    await axios.put(`http://localhost:8080/api/hoa-don-management/${editingOrder.value.id}`, editingOrder.value);
    // Update local selectedOrder and orders list
    selectedOrder.value = { ...selectedOrder.value, ...editingOrder.value };
    const idx = orders.value.findIndex(o => o.id === editingOrder.value.id);
    if (idx !== -1) {
      orders.value[idx] = { ...orders.value[idx], ...editingOrder.value };
    }
    showEditModal.value = false;
    alert('✅ Đã lưu thay đổi đơn hàng');
  } catch (e) {
    console.error(e);
    alert('❌ Lưu thay đổi thất bại');
  }
};

const printOrder = (order) => {
  // Simple print logic placeholder
  window.print();
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

// Helper functions for enhanced modal
const exportOrderDetail = () => {
  // Export current order details
  if (selectedOrder.value) {
    console.log('Exporting order details:', selectedOrder.value.id);
    alert('Chức năng xuất chi tiết đơn hàng đang được phát triển');
  }
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

/* Edit Modal specific overrides to ensure proper styling */
.edit-action-btn img {
  flex-shrink: 0;
}

.edit-form-label img {
  flex-shrink: 0;
}

.edit-header-content img {
  flex-shrink: 0;
}

/* Ensure edit modal uses only specified colors */
.edit-action-btn.primary {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%) !important;
}

.edit-action-btn.primary:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%) !important;
}

</style>
