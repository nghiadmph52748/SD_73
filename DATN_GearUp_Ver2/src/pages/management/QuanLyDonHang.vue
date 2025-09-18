<template>
  <div class="order-management">
    <!-- Filter Title -->
    <h2 class="tieu-de-bo-loc">Bộ lọc</h2>

    <!-- Filter Section styled like PhieuGiamGia -->
    <div class="bo-loc-section">
      <!-- Right-aligned Action Buttons -->
      <div class="bo-loc-buttons-right">
        <button class="xoa-toan-bo-bo-loc-btn" @click="resetFilters">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M6 18L18 6M6 6l12 12"/>
          </svg>
          Xóa toàn bộ bộ lọc
        </button>
        <button class="xoa-toan-bo-bo-loc-btn" @click="exportOrdersToExcel">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4M7 10l5 5 5-5M12 15V3"/>
          </svg>
          Xuất báo cáo
        </button>
      </div>

      <!-- Filter Grid - Main Row -->
      <div class="luoi-bo-loc">
        <!-- Mã Đơn Hàng -->
        <div class="nhom-bo-loc">
          <label class="nhan-nhom-bo-loc">Mã Đơn Hàng</label>
          <input
            v-model="orderCode"
            type="text"
            placeholder="Lọc mã đơn hàng"
            class="dau-vao-bo-loc"
          />
        </div>

        <!-- Khách Hàng -->
        <div class="nhom-bo-loc">
          <label class="nhan-nhom-bo-loc">Khách Hàng</label>
          <input
            v-model="customerName"
            type="text"
            placeholder="Lọc tên khách hàng"
            class="dau-vao-bo-loc"
          />
        </div>

        <!-- Trạng Thái -->
        <div class="nhom-bo-loc">
          <label class="nhan-nhom-bo-loc">Trạng Thái Đơn Hàng</label>
          <select v-model="status" class="lua-chon-bo-loc">
            <option value="" disabled selected>Chọn trạng thái</option>
            <option value="CHO_XAC_NHAN">Chờ xác nhận</option>
            <option value="CHO_GIAO_HANG">Đang xử lý</option>
            <option value="HOAN_THANH">Hoàn thành</option>
            <option value="DA_HUY">Đã hủy</option>
          </select>
        </div>

        <!-- Loại Đơn Hàng -->
        <div class="nhom-bo-loc">
          <label class="nhan-nhom-bo-loc">Loại Đơn Hàng</label>
          <select v-model="orderType" class="lua-chon-bo-loc">
            <option value="" disabled selected>Chọn loại đơn hàng</option>
            <option value="ONLINE">Trực tuyến</option>
            <option value="OFFLINE">Tại quầy</option>
          </select>
        </div>
      </div>

      <!-- Date Filters Row -->
      <div class="luoi-bo-loc luoi-bo-loc-dong-ba">
        <div class="nhom-bo-loc">
          <label class="nhan-nhom-bo-loc">Ngày tạo từ</label>
          <DatePickerPopup
            v-model="fromDate"
            :max="toDate || ''"
          />
        </div>
        <div class="nhom-bo-loc">
          <label class="nhan-nhom-bo-loc">Ngày tạo đến</label>
          <DatePickerPopup
            v-model="toDate"
            :min="fromDate || ''"
          />
        </div>
      </div>

      <!-- Bottom Search Section -->
      <div class="phan-tim-kiem-duoi">
        <div class="hop-tim-kiem-duoi">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="bieu-tuong-tim-kiem">
            <circle cx="11" cy="11" r="8"/>
            <path d="m21 21-4.35-4.35"/>
          </svg>
          <input
            type="text"
            v-model="searchQueryBottom"
            placeholder="Tìm kiếm..."
            class="dau-vao-tim-kiem-duoi"
          />
        </div>
      </div>
    </div>

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
          <img :src="status.iconSrc" alt="" class="tab-icon-svg" />
          <span class="tab-text">{{ status.label }}</span>
          <span class="tab-count">{{ getStatusCount(status.value) }}</span>
        </button>
      </div>

     
      <div class="header-actions">
        <!-- <button class="btn-action" @click="exportOrdersToExcel">
          <i class="lucide lucide-file-spreadsheet"></i>
          <span>Xuất Excel</span>
        </button>

        <button class="btn-action primary" @click="createOrder">
          <i class="lucide lucide-plus-circle"></i>
          <span>Tạo đơn hàng</span>
        </button> -->

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
          <div class="table-wrapper">
            <table class="coupons-table">
            <thead>
              <tr>
                <th class="col-checkbox">
                  <input 
                    type="checkbox" 
                    class="select-all-checkbox"
                    @change="toggleSelectAll"
                    :checked="isAllSelected"
                    :indeterminate="isIndeterminate"
                  >
                </th>
                <th class="col-stt">STT</th>
                <th class="col-ma">MÃ ĐƠN HÀNG</th>
                <th class="col-ten">TÊN KHÁCH HÀNG</th>
                <th class="col-loai">LOẠI ĐƠN</th>
                <th class="col-giatri">TỔNG TIỀN</th>
                <th class="col-batdau">BẮT ĐẦU</th>
                <th class="col-ketthuc">KẾT THÚC</th>
                <th class="col-soluong">SL</th>
                <th class="col-trangthai">TRẠNG THÁI</th>
                <th class="col-hanhdong">HÀNH ĐỘNG</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="(order, index) in filteredOrders"
                :key="order.id"
              >
                <td class="col-checkbox">
                  <input 
                    type="checkbox" 
                    class="row-checkbox"
                    :value="order.id"
                    v-model="selectedOrderIds"
                    @change="updateSelectedOrders"
                  >
                </td>
                <td class="col-stt">{{ startIndex + index + 1 }}</td>
                <td class="col-ma">
                  <div class="coupon-code">{{ order.maHoaDon || order.lichSuThanhToan?.[0]?.maHoaDon || 'N/A' }}</div>
                </td>
                <td class="col-ten">
                  <div class="coupon-name">{{ order.tenKhachHang || 'Khách lẻ' }}</div>
                </td>
                <td class="col-loai">
                  <div class="coupon-type">
                    <span class="type-label">{{ order.loaiDon ? 'Tại quầy' : 'Trực tuyến' }}</span>
                  </div>
                </td>
                <td class="col-giatri">
                  <div class="discount-value-detailed">
                    <strong>{{ formatCompactCurrency(order.tongTienSauGiam || order.tongTien || 0) }}</strong>
                  </div>
                </td>
                <td class="col-batdau">
                  <div class="date-info-compact">
                    {{ formatTimeOnly(order.ngayTao) }} / {{ formatDateOnly(order.ngayTao) }}
                  </div>
                </td>
                <td class="col-ketthuc">
                  <div class="date-info-compact">
                    {{ formatTimeOnly(order.ngayThanhToan) }} / {{ formatDateOnly(order.ngayThanhToan) }}
                  </div>
                </td>
                <td class="col-soluong">
                  <div class="quantity-info">
                    {{ order.items?.length || order.soLuongSanPham || 0 }}
                  </div>
                </td>
                <td class="col-trangthai">
                  <span
                    :class="[
                      'status-badge-detailed',
                      order.deleted ? 'status-deleted' : 
                      (getDetailedOrderStatus(order) === 'Hoàn thành' ? 'status-active' : 
                      (getDetailedOrderStatus(order) === 'Đang xử lý' ? 'status-upcoming' : 'status-expired')),
                    ]"
                  >
                    {{ getDetailedOrderStatus(order) }}
                  </span>
                </td>
                <td class="col-hanhdong">
                  <div class="action-buttons-compact">
                    <button
                      class="action-btn-compact edit-btn"
                      @click="editOrder(order)"
                      title="Chỉnh sửa"
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="action-icon-svg">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                      </svg>
                    </button>
                    <button
                      class="action-btn-compact view-btn"
                      @click="viewOrder(order)"
                      title="Xem chi tiết"
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="action-icon-svg">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                        <circle cx="12" cy="12" r="3"/>
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
            </table>
          </div>
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
                  <!-- <ActionButton
                   icon="print"
                    variant="info"
                    size="sm"
                    tooltip="In Hóa Đơn"
                    class="action-button-danger"
                    @click="printOrder(order)"
                  /> -->
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
        <div class="modal-content add-modal" @click.stop>
          <!-- Modal Header -->
          <div class="modal-header add-header">
            <h3>
              <img :src="EditIcon" alt="Form" class="icon-svg" />
              Cập nhật đơn hàng
            </h3>
            <button class="modal-close" @click="closeEditModal">
              <span>×</span>
            </button>
          </div>

          <!-- Modal Body -->
          <div class="modal-body">
            <form @submit.prevent="updateOrder" class="edit-form">
              <!-- Tên khách hàng -->
              <div class="detail-row">
                <div class="detail-label">
                  <img :src="UsersIcon" alt="Customer" class="icon-svg" />
                  Tên khách hàng
                </div>
                <div class="detail-value">
                  <input
                    type="text"
                    v-model="editingOrder.tenKhachHang"
                    class="detail-input"
                    placeholder="Nhập tên khách hàng"
                  />
                </div>
              </div>

              <!-- Trạng thái đơn hàng -->
              <div class="detail-row">
                <div class="detail-label">
                  <img :src="ChecklistIcon" alt="Status" class="icon-svg" />
                  Trạng thái đơn hàng
                </div>
                <div class="detail-value">
                  <select v-model="editingOrder.trangThai" class="detail-input">
                    <option :value="true">Hoàn thành</option>
                    <option :value="false">Chờ xác nhận</option>
                  </select>
                </div>
              </div>

              <!-- Loại đơn hàng -->
              <div class="detail-row">
                <div class="detail-label">
                  <img :src="ShippingIcon" alt="Type" class="icon-svg" />
                  Loại đơn hàng
                </div>
                <div class="detail-value">
                  <select v-model="editingOrder.loaiDon" class="detail-input">
                    <option :value="false">Trực tuyến</option>
                    <option :value="true">Tại quầy</option>
                  </select>
                </div>
              </div>

              <!-- Tổng tiền sau giảm -->
              <div class="detail-row">
                <div class="detail-label">
                  <img :src="MoneyIcon" alt="Total" class="icon-svg" />
                  Tổng tiền sau giảm
                </div>
                <div class="detail-value">
                  <div class="input-with-suffix">
                    <input
                      type="text"
                      :value="formattedTongTienSauGiam"
                      class="detail-input has-suffix"
                      placeholder="Nhập tổng tiền"
                      @input="handleVndInput($event, 'tongTienSauGiam')"
                      inputmode="numeric"
                    />
                    <span class="input-suffix">VND</span>
                  </div>
                </div>
              </div>
            </form>
          </div>

          <!-- Modal Footer -->
          <div class="modal-footer add-footer">
            <button 
              class="btn btn-secondary" 
              @click="closeEditModal"
            >
              <img :src="CancelIcon" alt="Cancel" class="icon-svg" />
              Hủy
            </button>
            <button 
              class="btn btn-primary" 
              @click="updateOrder"
            >
              <img :src="EditIcon" alt="Save" class="icon-svg" />
              Cập nhật
            </button>
          </div>
        </div>
      </div>


    </div>

    <!-- Pagination Section (separate from table container) -->
    <div class="pagination-container">
      <div class="pagination-info">
        Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của {{ totalOrders }} đơn hàng
      </div>
      <div class="pagination-controls">
        <button
          class="pagination-btn"
          @click="previousPage"
          :disabled="currentPage === 1"
        >
          ❮ Trước
        </button>
        <span class="page-info">{{ currentPage }} / {{ backendTotalPages }}</span>
        <button
          class="pagination-btn"
          @click="nextPage"
          :disabled="currentPage === backendTotalPages"
        >
          Sau ❯
        </button>
      </div>
    </div>


    <!-- Order Detail Modal -->
    <div
      v-if="showDetailModal"
      class="modal-overlay"
      @click="showDetailModal = false"
    >
      <div class="modal-content large order-detail-modal" @click.stop>
        <div class="order-detail-header">
          <div class="header-info">
            <div class="order-code-badge">#{{ selectedOrder?.id }}</div>
            <div class="order-title-block">
              <h3>{{ selectedOrder?.code || 'Chi tiết đơn hàng' }}</h3>
              <div class="order-status-pill" :class="getStatusClass(selectedOrder?.trangThai)">
                {{ getStatusText(selectedOrder?.trangThai) }}
              </div>
            </div>
          </div>
          <button class="modal-close" @click="showDetailModal = false">✕</button>
        </div>

        <div v-if="selectedOrder" class="order-detail-body">
          <div class="order-overview">
            <div class="overview-card">
              <span class="label">Loại đơn</span>
              <span class="value" :class="selectedOrder.loaiDon ? 'value-success' : 'value-info'">
                {{ selectedOrder.loaiDon ? 'Tại quầy' : 'Trực tuyến' }}
              </span>
            </div>
            <div class="overview-card">
              <span class="label">Ngày tạo</span>
              <span class="value">{{ formatDateTime(selectedOrder.ngayTao) }}</span>
            </div>
            <div class="overview-card">
              <span class="label">Tổng thanh toán</span>
              <span class="value highlight">{{ formatCurrency(selectedOrder.tongTienSauGiam) }}</span>
            </div>
          </div>

          <div class="order-detail-grid">
            <section class="order-card">
              <header class="card-header">
                <h4>Thông tin khách hàng</h4>
              </header>
              <div class="card-body info-grid">
                <div class="info-item">
                  <span class="info-label">Khách hàng</span>
                  <span class="info-value">{{ selectedOrder.tenKhachHang || 'Khách lẻ' }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">Số điện thoại</span>
                  <span class="info-value">{{ selectedOrder.soDienThoai || '---' }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">Người nhận</span>
                  <span class="info-value">{{ selectedOrder.tenNguoiNhan || '---' }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">Nhân viên phụ trách</span>
                  <span class="info-value">{{ selectedOrder.tenNhanVien || '---' }}</span>
                </div>
              </div>
            </section>

            <section class="order-card">
              <header class="card-header">
                <h4>Lịch sử đơn hàng</h4>
              </header>
              <div class="card-body timeline" style="display: flex; flex-direction: column; gap: 16px; padding: 16px 0;">
                <div class="timeline-item" style="display: flex; align-items: flex-start; gap: 12px; margin-bottom: 16px;">
                  <div class="timeline-marker completed" style="width: 16px; height: 16px; border-radius: 50%; background: #22c55e; flex-shrink: 0; margin-top: 2px;"></div>
                  <div class="timeline-content" style="flex: 1;">
                    <div class="timeline-title" style="font-weight: 600; font-size: 16px; color: #1f2937; margin-bottom: 4px;">Tạo đơn hàng</div>
                    <div class="timeline-meta" style="font-size: 14px; color: #6b7280; margin-bottom: 2px;">{{ formatDateTime(selectedOrder?.ngayTao) }}</div>
                    <div class="timeline-note" style="font-size: 14px; color: #6b7280; margin: 0;">Nhân viên: {{ selectedOrder?.tenNhanVien || '---' }}</div>
                  </div>
                </div>
                <div class="timeline-item" :class="{ completed: !!selectedOrder?.ngayThanhToan }" style="display: flex; align-items: flex-start; gap: 12px; margin-bottom: 16px;">
                  <div class="timeline-marker" :class="{ completed: !!selectedOrder?.ngayThanhToan }" :style="{
                    width: '16px',
                    height: '16px', 
                    borderRadius: '50%',
                    background: selectedOrder?.ngayThanhToan ? '#22c55e' : '#d1d5db',
                    flexShrink: '0',
                    marginTop: '2px'
                  }"></div>
                  <div class="timeline-content" style="flex: 1;">
                    <div class="timeline-title" style="font-weight: 600; font-size: 16px; color: #1f2937; margin-bottom: 4px;">Hoàn thành</div>
                    <div class="timeline-meta" style="font-size: 14px; color: #6b7280; margin-bottom: 2px;">
                      {{ selectedOrder?.ngayThanhToan ? formatDateTime(selectedOrder.ngayThanhToan) : 'Chưa xác nhận' }}
                    </div>
                  </div>
                </div>
              </div>
            </section>

            <section class="order-card">
              <header class="card-header">
                <h4>Tổng quan đơn hàng</h4>
              </header>
              <div class="card-body summary">
                <div class="summary-row">
                  <span>Phiếu giảm giá</span>
                  <span>{{ selectedOrder.maPhieuGiamGia || 'Không có' }}</span>
                </div>
                <div class="summary-row">
                  <span>Giảm giá cửa hàng</span>
                  <span>{{ selectedOrder.giaTriGiamGia || 0 }}%</span>
                </div>
                <div class="summary-row">
                  <span>Tổng tiền hàng</span>
                  <span>{{ formatCurrency(selectedOrder.tongTien) }}</span>
                </div>
                <div class="summary-row">
                  <span>Phí vận chuyển</span>
                  <span>{{ formatCurrency(selectedOrder.phiVanChuyen) }}</span>
                </div>
                <div class="summary-row note">
                  <span>Miễn phí vận chuyển cho đơn trên 1,000,000 VND</span>
                </div>
                <div class="summary-row total">
                  <span>Tổng thanh toán</span>
                  <span class="total-amount">{{ formatCurrency(selectedOrder.tongTienSauGiam) }}</span>
                </div>
              </div>
            </section>
          </div>

          <section class="order-card product-section">
            <header class="card-header">
              <h4>Sản phẩm</h4>
              <span class="chip">{{ selectedOrder?.items?.length || 0 }} sản phẩm</span>
            </header>
            <div class="card-body product-list modern-products">
              <div
                v-for="item in (selectedOrder?.items || [])"
                :key="item.id"
                class="product-card"
              >
                <div class="product-media">
                  <img
                    v-if="getProductImage(item)"
                    :src="getProductImage(item)"
                    :alt="item.tenNhaSanXuat || 'Sản phẩm'"
                    @error="onProductImgError"
                  />
                  <div v-else class="media-placeholder">👟</div>
                </div>
                <div class="product-info">
                  <div class="product-title-row">
                    <div class="product-title">{{ item.tenNhaSanXuat }} - Size {{ item.tenKichThuoc }}</div>
                    <div class="product-qty-chip">x{{ item.soLuong }}</div>
                  </div>
                  <div class="product-meta-row">
                    <span class="meta-chip">Màu {{ item.tenMauSac }}</span>
                    <span class="meta-chip">Xuất xứ {{ item.tenXuatXu }}</span>
                    <span class="meta-chip">Đế {{ item.tenDeGiay }}</span>
                    <span class="meta-chip">Chất liệu {{ item.tenChatLieu }}</span>
                  </div>
                  <div class="product-price-row">
                    <template v-if="item.giaTriGiamGia">
                      <span class="price-old">{{ formatCurrency(item.giaBan) }}</span>
                      <span class="price-new">{{ formatCurrency(item.giaBan * (1 - item.giaTriGiamGia / 100)) }}</span>
                      <span class="price-badge">-{{ item.giaTriGiamGia }}%</span>
                    </template>
                    <template v-else>
                      <span class="price-new">{{ formatCurrency(item.giaBan) }}</span>
                    </template>
                  </div>
                </div>
              </div>
              <div v-if="!selectedOrder?.items?.length" class="empty-state modern-empty">
                Không có sản phẩm trong đơn hàng này.
              </div>
            </div>
          </section>

          <section class="order-card payment-section">
            <header class="card-header">
              <h4>Lịch sử thanh toán</h4>
            </header>
            <div class="card-body">
              <div v-if="selectedOrder?.lichSuThanhToan?.length" class="payment-table-wrapper">
                <table class="payment-table">
                  <thead>
                    <tr>
                      <th>Số tiền</th>
                      <th>Thời gian</th>
                      <th>Loại giao dịch</th>
                      <th>PTTT</th>
                      <th>Trạng thái</th>
                      <th>Ghi chú</th>
                      <th>Xác nhận</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="payment in selectedOrder.lichSuThanhToan" :key="payment.id">
                      <td class="amount">{{ formatCurrency((payment.tienMat || 0) + (payment.tienChuyenKhoan || 0)) }}</td>
                      <td>{{ formatDateTime(payment.ngayTao) }}</td>
                      <td><span class="badge badge-info">{{ payment.loaiGiaoDich || 'Thanh toán' }}</span></td>
                      <td><span class="badge badge-success">{{ payment.tenPhuongThucThanhToan }}</span></td>
                      <td>
                        <span :class="['badge', payment.trangThai === '1' ? 'badge-success' : 'badge-warning']">
                          {{ payment.trangThai === '1' ? 'Thành công' : 'Chờ xử lý' }}
                        </span>
                      </td>
                      <td>{{ payment.ghiChu || '-' }}</td>
                      <td>{{ payment.tenNhanVienXacNhan || '-' }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div v-else class="empty-state">Chưa có lịch sử thanh toán</div>
            </div>
          </section>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>

import DatePickerPopup from "@/components/common/DatePickerPopup.vue";
import ButtonGroup from "@/components/ui/NhomNut.vue";
import ActionButton from "@/components/ui/NutHanhDong.vue";
import axios from "axios";
import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import { exportToExcel, formatDataForExcel } from '../../utils/xuatExcel.js';
// Status tab icons
import CancelStatusIcon from "@/assets/Cancel.svg?url";
import ChecklistIcon from "@/assets/Checklist.svg?url";
import CompletedIcon from "@/assets/Completed.svg?url";
import EditIcon from "@/assets/Edit.svg?url";
import OrdersIcon from "@/assets/Orders.svg?url";
import PendingIcon from "@/assets/Pending.svg?url";
import ShippingIcon from "@/assets/Shipping.svg?url";
import ViewIcon from "@/assets/View.svg?url";
// Icons used in the Edit Order modal
import UsersIcon from "@/assets/Users.svg?url";
import MoneyIcon from "@/assets/Money.svg?url";
import CancelIcon from "@/assets/Cancel.svg?url";


const router = useRouter();
const selectedOrder = ref(null);        // hóa đơn đang xem chi tiết
const showDetailModal = ref(false); 
const showEditModal = ref(false);
const editingOrder = ref({});

// Data

const searchQuery = ref('')
const searchQueryBottom = ref('')
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
const orderCode = ref('')
const customerName = ref('')
const status = ref('')
const orderType = ref('')
const orders = ref([])
const backendTotalOrders = ref(0)
const backendTotalPages = ref(0)
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => startIndex.value + itemsPerPage.value)

const loading = ref(false)
const error = ref(null)

// Checkbox selection state
const selectedOrderIds = ref([])
const selectedOrders = ref([])



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
  { value: "TAT_CA", label: "Tất Cả", iconSrc: OrdersIcon },
  { value: "CHO_XAC_NHAN", label: "Chờ Xác Nhận", iconSrc: PendingIcon },
  { value: "CHO_GIAO_HANG", label: "Đang Xử Lý", iconSrc: ChecklistIcon },
  { value: "DANG_VAN_CHUYEN", label: "Đang Vận Chuyển", iconSrc: ShippingIcon },
  { value: "HOAN_THANH", label: "Hoàn Thành", iconSrc: CompletedIcon },
  { value: "DA_HUY", label: "Đã Hủy", iconSrc: CancelStatusIcon },
];





// Computed
const filteredOrders = computed(() => {
  let filtered = orders.value;

  // Lọc theo mã đơn hàng (lấy từ lịch sử thanh toán)
  if (orderCode.value) {
    filtered = filtered.filter((order) =>
      order.lichSuThanhToan?.[0]?.maHoaDon?.toLowerCase().includes(orderCode.value.toLowerCase())
    );
  }

  // Lọc theo tên khách hàng
  if (customerName.value) {
    filtered = filtered.filter((order) =>
      order.tenKhachHang?.toLowerCase().includes(customerName.value.toLowerCase())
    );
  }

  // Tìm kiếm nhanh phía dưới
  if (searchQueryBottom.value) {
    const q = searchQueryBottom.value.toLowerCase();
    filtered = filtered.filter((order) => {
      const code = (order.lichSuThanhToan?.[0]?.maHoaDon || order.maHoaDon || '').toLowerCase();
      const name = (order.tenKhachHang || order.tenNguoiNhan || '').toLowerCase();
      return code.includes(q) || name.includes(q);
    });
  }

  // Lọc theo trạng thái
  if (status.value) {
    filtered = filtered.filter((order) => order.trangThai === status.value);
  }

  // Lọc theo loại đơn hàng
  if (orderType.value) {
    if (orderType.value === "ONLINE") {
      filtered = filtered.filter((order) => order.loaiDon === false);
    } else if (orderType.value === "OFFLINE") {
      filtered = filtered.filter((order) => order.loaiDon === true);
    }
  }

  // Lọc ngày tạo từ
  if (fromDate.value) {
    filtered = filtered.filter((order) => new Date(order.ngayTao) >= new Date(fromDate.value));
  }

  // Lọc ngày tạo đến
  if (toDate.value) {
    filtered = filtered.filter((order) => new Date(order.ngayTao) <= new Date(toDate.value + "T23:59:59"));
  }

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

// Compact currency formatter like PhieuGiamGia
const formatCompactCurrency = (amount) => {
  if (!amount || amount === 0) return '0đ'
  
  // Convert to number if string
  const num = typeof amount === 'string' ? parseFloat(amount) : amount
  
  if (num >= 1000000) {
    return (num / 1000000).toFixed(num % 1000000 === 0 ? 0 : 1) + 'tr'
  } else if (num >= 1000) {
    return (num / 1000).toFixed(num % 1000 === 0 ? 0 : 0) + 'k'
  } else {
    return num.toLocaleString('vi-VN') + 'đ'
  }
};

// Date and time formatters like PhieuGiamGia  
const formatTimeOnly = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleTimeString('vi-VN', {
    hour: '2-digit', 
    minute: '2-digit',
    hour12: false
  })
}

const formatDateOnly = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleDateString('vi-VN')
}
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

// Detailed status for orders like PhieuGiamGia
const getDetailedOrderStatus = (order) => {
  if (order.deleted) return 'Đã xóa'
  
  if (typeof order.trangThai === 'boolean') {
    return order.trangThai ? 'Hoàn thành' : 'Chờ xác nhận'
  }
  
  const now = new Date()
  const created = order.ngayTao ? new Date(order.ngayTao) : null
  const completed = order.ngayThanhToan ? new Date(order.ngayThanhToan) : null
  
  if (completed && completed <= now) {
    return 'Hoàn thành'
  } else if (created && created <= now && !completed) {
    return 'Đang xử lý'
  } else {
    return 'Chờ xác nhận'
  }
}
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

  // Thêm 4 field lọc mới
  orderCode.value = "";
  customerName.value = "";
  status.value = "";
  orderType.value = "";
};

// Checkbox functionality like PhieuGiamGia
const isAllSelected = computed(() => {
  const visibleOrderIds = filteredOrders.value.map(order => order.id)
  return visibleOrderIds.length > 0 && visibleOrderIds.every(id => selectedOrderIds.value.includes(id))
})

const isIndeterminate = computed(() => {
  const visibleOrderIds = filteredOrders.value.map(order => order.id)
  const selectedVisibleIds = selectedOrderIds.value.filter(id => visibleOrderIds.includes(id))
  return selectedVisibleIds.length > 0 && selectedVisibleIds.length < visibleOrderIds.length
})

const toggleSelectAll = () => {
  const visibleOrderIds = filteredOrders.value.map(order => order.id)
  
  if (isAllSelected.value) {
    // Unselect all visible orders
    selectedOrderIds.value = selectedOrderIds.value.filter(id => !visibleOrderIds.includes(id))
  } else {
    // Select all visible orders
    const newSelectedIds = [...selectedOrderIds.value]
    visibleOrderIds.forEach(id => {
      if (!newSelectedIds.includes(id)) {
        newSelectedIds.push(id)
      }
    })
    selectedOrderIds.value = newSelectedIds
  }
  updateSelectedOrders()
}

const updateSelectedOrders = () => {
  selectedOrders.value = orders.value.filter(order => selectedOrderIds.value.includes(order.id))
}


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

// ===== Helper: format number with '.' thousand separators
const formatNumberDots = (value) => {
  const str = String(value ?? '').replace(/\D/g, '');
  if (!str) return '';
  return str.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
};

// Display value for VND input (Tổng tiền sau giảm)
const formattedTongTienSauGiam = computed(() => {
  const v = editingOrder.value?.tongTienSauGiam;
  if (v === undefined || v === null || v === 0) return editingOrder.value?.tongTienSauGiam === 0 ? '0' : '';
  return formatNumberDots(v);
});

// Handle typing in VND input and keep numeric state
const handleVndInput = (evt, field) => {
  const raw = evt?.target?.value ?? '';
  const digits = raw.replace(/\D/g, '');
  editingOrder.value[field] = digits ? parseInt(digits, 10) : 0;
  // reflect formatted text back into the input for immediate feedback
  evt.target.value = digits ? formatNumberDots(digits) : '';
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

// Get product image from various possible shapes
const getProductImage = (item) => {
  if (!item) return null;
  const a = item.anhSanPham;
  // If already an array of urls
  if (Array.isArray(a) && a.length) return a[0];
  // If it's a JSON string representing an array
  if (typeof a === 'string') {
    try {
      const parsed = JSON.parse(a);
      if (Array.isArray(parsed) && parsed.length) return parsed[0];
    } catch (_) {
      // not JSON, assume direct url string
      if (a.trim().length > 4) return a.trim();
    }
  }
  // Try common alternative fields
  if (item.hinhAnh && typeof item.hinhAnh === 'string') return item.hinhAnh;
  if (item.imageUrl && typeof item.imageUrl === 'string') return item.imageUrl;
  return null;
};

// Fallback image for broken links
const DEFAULT_PRODUCT_IMG =
  "data:image/svg+xml;utf8," +
  encodeURIComponent(
    '<svg xmlns="http://www.w3.org/2000/svg" width="72" height="72" viewBox="0 0 24 24"><rect width="24" height="24" rx="4" fill="#f1f5f9"/><path d="M2 16c3 0 4-2 6-2s3 2 6 2 5-1 6-1 2 1 2 2-1 2-2 2H4a2 2 0 0 1-2-2z" fill="#9ca3af"/></svg>'
  );
const onProductImgError = (e) => {
  if (e && e.target) {
    e.target.onerror = null;
    e.target.src = DEFAULT_PRODUCT_IMG;
  }
};
const exportData = () => {  
  alert("Chức năng xuất báo cáo đang được phát triển");
};
onMounted(() => {
  fetchOrders();
  const today = new Date();
  toDate.value = today.toISOString().split("T")[0];
  fromDate.value = "2025-01-01";
  
  // Debug icon imports
  console.log('EditIcon:', EditIcon);
  console.log('ViewIcon:', ViewIcon);
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
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}

.add-modal {
  max-width: 800px; /* Wider for forms */
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e5e7eb;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.icon-svg {
  width: 24px;
  height: 24px;
}

.modal-close {
  background: none;
  border: none;
  font-size: 1.75rem;
  cursor: pointer;
  color: #6b7280;
  padding: 0;
  line-height: 1;
}

.modal-body {
  padding: 1.5rem;
  overflow-y: auto;
  flex-grow: 1;
}

.edit-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.detail-row {
  display: grid;
  grid-template-columns: 200px 1fr;
  align-items: flex-start;
  gap: 1rem;
}

.detail-label {
  font-weight: 600;
  color: #374151;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.detail-value {
  display: flex;
  flex-direction: column;
}

.detail-input,
.detail-textarea {
  width: 100%;
  padding: 0.5rem 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 0.875rem;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.detail-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.25);
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  padding: 1rem 1.5rem;
  border-top: 1px solid #e5e7eb;
  gap: 0.75rem;
}

.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.6rem 1.2rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  border: 1px solid transparent;
}

.btn-secondary {
  background-color: #f3f4f6;
  color: #374151;
  border-color: #d1d5db;
}

.btn-secondary:hover {
  background-color: #e5e7eb;
}

.btn-primary {
  background-color: #2563eb;
  color: white;
}

.btn-primary:hover {
  background-color: #1d4ed8;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.closexy{
  position: absolute;
  right: 10px;               /* Nút đóng nằm sát góc phải */
  top: 0%;
}
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
  background: #fff;
  border-radius: 8px;
  max-width: 1000px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
  padding: 20px 25px;
  position: relative;
  font-family: Arial, sans-serif;
  color: #222;
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
  background: #fff;
  padding: 16px;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
   margin-bottom: 40px;
}

.filters-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.filters-header h3 {
  margin: 0;
  font-size: 18px;
}

.btn-reset {
  background: none;
  border: none;
  color: #2a9d8f;
  cursor: pointer;
  font-weight: 500;
}

.btn-reset:hover {
  background: var(--gray-50) !important;
  color: var(--text-primary) !important;
}

.filters-content {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.filter-row {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.filter-item {
  flex: 1;              /* Tự động giãn ra đều nhau */
  min-width: 220px;     /* Độ dài tối thiểu */
}

/* Input chung */
.filter-input,
.filter-select {
  min-width: 415px;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 6px;
}

.quick-buttons {
  display: flex;
  align-items: flex-end;
  gap: 8px;
}
.quick-buttons button {
  padding: 6px 12px;
  border: 1px solid #2a9d8f;
  background: #e6f7f5;
  color: #2a9d8f;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
}
.quick-buttons button:hover {
  background: #2a9d8f;
  color: #fff;
}
.type-cell {
  text-align: center !important;
}

.type-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  padding: 8px 12px;
  border-radius: 12px;
  font-size: 18px;
  font-weight: 700;
}


.search-section {
  margin-bottom: 2rem;
}

.search-input-group {
  display: flex;
  align-items: center;
  gap: 8px;
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
  padding: 10px 12px;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  font-size: 0.9rem;
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
  padding: 0.75rem;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  font-size: 0.875rem;
  transition: border-color 0.3s ease;
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
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 12px;
  background: linear-gradient(135deg, rgba(219, 234, 254, 0.35) 0%, rgba(239, 246, 255, 0.75) 100%);
  border: 1px solid #e5e7eb;
  padding: 8px 12px;
  border-radius: 14px;
}

.status-tabs {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.status-tab {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 10px;
  border: 1px solid #e5e7eb;
  background: #ffffff;
  border-radius: 9999px; /* pill */
  cursor: pointer;
  transition: all 0.2s ease;
  font-weight: 600;
  white-space: nowrap;
  font-size: 12px;
  color: #0f172a;
}

.status-tab:hover {
  background: rgba(219, 234, 254, 0.6);
  border-color: #4ade80;
}

.status-tab.active {
  background: #4ade80;
  border-color: #4ade80;
  color: #ffffff;
  box-shadow: 0 6px 16px -6px rgba(34, 197, 94, 0.45);
}

.tab-icon { font-size: 14px; }
.tab-icon-svg { width: 16px; height: 16px; }
.tab-text { font-weight: 600; }

.tab-count {
  padding: 2px 6px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 700;
  min-width: 18px;
  text-align: center;
  background: rgba(255, 255, 255, 0.25);
}

.status-tab:not(.active) .tab-count {
  background: #f1f5f9;
  color: #64748b;
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

/* detail */


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
.orders-table td {
  padding: 0.5rem 0.75rem;
}

.orders-table th {
  padding: 0.5rem 0.75rem;
}

.code-cell,
.customer-info,
.amount-info,
.date-info {
  gap: 2px !important; /* giảm khoảng cách dọc giữa các dòng */
}

.orders-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

/* Compact table overrides */
.orders-table--compact {
  font-size: 13px;
}
.orders-table--compact th,
.orders-table--compact td {
  padding: 8px 10px !important;
}
.orders-table--compact .code-text { font-size: 0.875rem; }
.orders-table--compact .amount-value { font-size: 0.9375rem; }

.orders-table th {
  border: 1px solid #dee2e6;
  text-align: left;
  font-weight: 700;
  color: #374151;
  border-bottom: 2px solid #e5e7eb;
}
.orders-table td {
  border: 1px solid #dee2e6;
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
  padding: 0.8rem 1rem;
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

/* Loại bỏ border đáy ở dòng cuối */
.order-row:last-child td {
  border-bottom: none !important;
}

/* Reset padding/margin tránh dư khoảng trắng */
.orders-table,
.orders-table tbody,
.orders-table tr,
.orders-table td,
.table-container {
  margin: 0;
  padding-bottom: 0;
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

.amount-cell {
  text-align: left !important;
}

.amount-info {
  display: flex;
  flex-direction: column;
  align-items: flex-start !important;
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
 display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-top: 1px solid #e5e7eb;
  background-color: #fff;
  flex-wrap: wrap;
  gap: 1rem;
}

.pagination-info {
 display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.per-page-selector {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.per-page-select {
  padding: 4px 8px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
}

.pagination-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.pagination-btn {
  padding: 6px 12px;
  border: 1px solid #d1d5db;
  background-color: white;
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-btn {
  padding: 6px 10px;
  border: 1px solid #d1d5db;
  background: white;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.page-btn.active {
  border-color: #111827;
  font-weight: bold;
}

.page-btn.dots {
  cursor: default;
  background: none;
  border: none;
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

/* Compact column widths to fit viewport without scrolling */

/* Checkbox column */
.coupons-table .col-checkbox,
.coupons-table th.col-checkbox,
.coupons-table td.col-checkbox { 
  width: 3% !important; 
  min-width: 30px !important; 
  max-width: 35px !important; 
  text-align: center !important; 
  padding: 4px 2px !important;
}

/* STT column */
.coupons-table .col-stt,
.coupons-table th.col-stt,
.coupons-table td.col-stt { 
  width: 4% !important; 
  min-width: 35px !important; 
  max-width: 40px !important; 
  text-align: center !important;
  padding: 4px 2px !important;
}

/* Mã đơn hàng column */
.coupons-table .col-ma,
.coupons-table th.col-ma,
.coupons-table td.col-ma { 
  width: 8% !important; 
  min-width: 70px !important; 
  max-width: 80px !important; 
  text-align: center !important;
  padding: 4px 2px !important;
}

/* Tên khách hàng column */
.coupons-table .col-ten,
.coupons-table th.col-ten,
.coupons-table td.col-ten { 
  width: 15% !important; 
  min-width: 120px !important; 
  max-width: 140px !important; 
  text-align: left !important;
  padding: 4px 4px !important;
}

/* Loại đơn column */
.coupons-table .col-loai,
.coupons-table th.col-loai,
.coupons-table td.col-loai { 
  width: 8% !important; 
  min-width: 70px !important; 
  max-width: 80px !important; 
  text-align: center !important;
  padding: 4px 2px !important;
}

/* Tổng tiền column */
.coupons-table .col-giatri,
.coupons-table th.col-giatri,
.coupons-table td.col-giatri { 
  width: 7% !important; 
  min-width: 60px !important; 
  max-width: 70px !important; 
  text-align: center !important;
  padding: 4px 2px !important;
}

/* Bắt đầu column */
.coupons-table .col-batdau,
.coupons-table th.col-batdau,
.coupons-table td.col-batdau { 
  width: 10% !important; 
  min-width: 80px !important; 
  max-width: 90px !important; 
  text-align: center !important;
  padding: 4px 2px !important;
}

/* Kết thúc column */
.coupons-table .col-ketthuc,
.coupons-table th.col-ketthuc,
.coupons-table td.col-ketthuc { 
  width: 10% !important; 
  min-width: 80px !important; 
  max-width: 90px !important; 
  text-align: center !important;
  padding: 4px 2px !important;
}

/* SL column */
.coupons-table .col-soluong,
.coupons-table th.col-soluong,
.coupons-table td.col-soluong {
  width: 3% !important;
  min-width: 35px !important;
  max-width: 40px !important;
  text-align: center !important;
  padding: 4px 2px !important;
}

/* Trạng thái column */
.coupons-table .col-trangthai,
.coupons-table th.col-trangthai,
.coupons-table td.col-trangthai {
  width: 10% !important;
  min-width: 85px !important;
  max-width: 95px !important;
  text-align: center !important;
  padding: 4px 2px !important;
}

/* Hành động column */
.coupons-table .col-hanhdong,
.coupons-table th.col-hanhdong,
.coupons-table td.col-hanhdong {
  width: 6% !important;
  min-width: 55px !important;
  max-width: 65px !important;
  text-align: center !important;
  padding: 4px 1px !important;
}

/* Center align status and value columns */
.coupons-table .col-trangthai,
.coupons-table th.col-trangthai,
.coupons-table td.col-trangthai {
  text-align: center !important;
  vertical-align: middle !important;
}

.coupons-table .col-giatri,
.coupons-table th.col-giatri,
.coupons-table td.col-giatri {
  text-align: center !important;
  vertical-align: middle !important;
}

.select-all-checkbox,
.row-checkbox {
  width: 16px;
  height: 16px;
  accent-color: #4ade80;
  cursor: pointer;
  margin: 0;
}

/* Override default table cell padding for compact rows */
.coupons-table tbody td {
  padding: 4px 2px !important;
  vertical-align: middle !important;
  font-size: 0.75rem !important;
  line-height: 1.1 !important;
  height: 38px !important;
  max-height: 38px !important;
}

.coupons-table thead th {
  padding: 6px 2px !important;
  font-size: 0.65rem !important;
  line-height: 1.05 !important;
  height: 34px !important;
}

/* Reduce table minimum width to fit viewport */
.coupons-table {
  min-width: 900px !important;
  width: 100% !important;
}

/* Make content elements more compact */
.coupon-code,
.coupon-name,
.date-info-compact,
.quantity-info {
  line-height: 1.05 !important;
  margin: 0 !important;
  padding: 1px 2px !important;
  font-size: 0.7rem !important;
}

.discount-value-detailed {
  min-height: 30px !important;
  line-height: 1.1 !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 100% !important;
}

.discount-value-detailed strong {
  line-height: 1.1 !important;
}

.coupon-type {
  gap: 2px !important;
  line-height: 1 !important;
}

.type-label,
.type-icon {
  line-height: 1 !important;
  margin: 0 !important;
}

/* Enhanced status badges with larger text and colored backgrounds */
.status-badge-detailed {
  padding: 6px 12px !important;
  font-size: 0.75rem !important;
  font-weight: 600 !important;
  line-height: 1.2 !important;
  border-radius: 12px !important;
  text-align: center !important;
  min-width: 80px !important;
  display: inline-block !important;
  margin: 0 auto !important;
}

/* Hoàn thành - Green background */
.status-badge-detailed.status-active {
  background: #dcfce7 !important;
  color: #166534 !important;
  border: 1px solid #bbf7d0 !important;
}

/* Đang xử lý - Blue background */
.status-badge-detailed.status-upcoming {
  background: #dbeafe !important;
  color: #1d4ed8 !important;
  border: 1px solid #93c5fd !important;
}

/* Chờ xác nhận - Orange background */
.status-badge-detailed.status-expired {
  background: #fed7aa !important;
  color: #c2410c !important;
  border: 1px solid #fdba74 !important;
}

/* Đã xóa - Red background */
.status-badge-detailed.status-deleted {
  background: #fee2e2 !important;
  color: #991b1b !important;
  border: 1px solid #fecaca !important;
}

/* Inactive/Other states - Gray background */
.status-badge-detailed.status-inactive {
  background: #f3f4f6 !important;
  color: #6b7280 !important;
  border: 1px solid #e5e7eb !important;
}

.action-buttons-compact {
  gap: 2px !important;
  justify-content: center !important;
  align-items: center !important;
  display: flex !important;
  flex-wrap: nowrap !important;
}

.action-btn-compact {
  width: 24px !important;
  height: 24px !important;
}

.action-icon-compact {
  width: 12px !important;
  height: 12px !important;
  display: inline-block !important;
  opacity: 1 !important;
  visibility: visible !important;
  filter: none !important;
}

/* Clean action buttons matching the reference design */
.action-btn-compact {
  width: 24px !important;
  height: 24px !important;
  border: 1px solid #e5e7eb !important;
  background: #ffffff !important;
  border-radius: 3px !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  cursor: pointer !important;
  transition: all 0.2s ease !important;
  flex-shrink: 0 !important;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05) !important;
}

.action-btn-compact:hover {
  border-color: #d1d5db !important;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
  transform: translateY(-1px) !important;
}

.action-btn-compact.edit-btn:hover {
  border-color: #f59e0b !important;
  background: #fffbeb !important;
}

.action-btn-compact.view-btn:hover {
  border-color: #3b82f6 !important;
  background: #eff6ff !important;
}

/* Force icon visibility with high specificity */
.coupons-table .action-btn-compact img.action-icon-compact,
.action-buttons-compact .action-btn-compact img.action-icon-compact,
td.col-hanhdong img.action-icon-compact {
  width: 12px !important;
  height: 12px !important;
  display: inline-block !important;
  opacity: 1 !important;
  visibility: visible !important;
  filter: none !important;
  margin: 0 !important;
  padding: 0 !important;
}

/* Override any global SVG/img hiding rules */
.order-management img[src],
.order-management svg,
.table-view img[src],
.table-container img[src] {
  display: inline-block !important;
  opacity: 1 !important;
  visibility: visible !important;
}

/* CRITICAL TIMELINE FIXES - Direct element targeting */
div[class="card-body timeline"] {
  position: relative !important;
}

div[class="timeline-item"] {
  display: flex !important;
  align-items: flex-start !important;
  gap: 12px !important;
  margin-bottom: 20px !important;
  position: relative !important;
}

div[class="timeline-marker"] {
  width: 16px !important;
  height: 16px !important;
  border-radius: 50% !important;
  background: #e5e7eb !important;
  flex-shrink: 0 !important;
  margin-top: 2px !important;
  position: relative !important;
  border: none !important;
}

div[class="timeline-marker completed"] {
  background: #22c55e !important;
}

div[class="timeline-content"] {
  flex: 1 !important;
}

div[class="timeline-title"] {
  font-weight: 600 !important;
  font-size: 16px !important;
  color: #1f2937 !important;
  margin-bottom: 4px !important;
}

div[class="timeline-meta"] {
  font-size: 14px !important;
  color: #6b7280 !important;
  margin-bottom: 2px !important;
}

div[class="timeline-note"] {
  font-size: 14px !important;
  color: #6b7280 !important;
  margin: 0 !important;
}

/* Ultra-specific modal timeline targeting */
.modal-overlay .modal-content.large.order-detail-modal .order-detail-body .order-detail-grid section.order-card .card-body.timeline .timeline-item .timeline-marker {
  width: 16px !important;
  height: 16px !important;
  border-radius: 50% !important;
  background: #d1d5db !important;
  margin-top: 2px !important;
  flex-shrink: 0 !important;
}

.modal-overlay .modal-content.large.order-detail-modal .order-detail-body .order-detail-grid section.order-card .card-body.timeline .timeline-item .timeline-marker.completed {
  background: #22c55e !important;
}

.modal-overlay .modal-content.large.order-detail-modal .order-detail-body .order-detail-grid section.order-card .card-body.timeline .timeline-item {
  display: flex !important;
  align-items: flex-start !important;
  gap: 12px !important;
  margin-bottom: 16px !important;
}

/* Reset any conflicting timeline icon styles */
.timeline-icon {
  display: none !important;
}

/* ===== ORDER SUMMARY STYLING ===== */
.card-body.summary {
  padding: 20px !important;
  background: #ffffff !important;
}

.summary-row {
  display: flex !important;
  justify-content: space-between !important;
  align-items: center !important;
  padding: 12px 0 !important;
  border-bottom: 1px solid #f3f4f6 !important;
  font-size: 14px !important;
  transition: background-color 0.2s ease !important;
}

.summary-row:hover {
  background: #f9fafb !important;
  margin: 0 -20px !important;
  padding-left: 20px !important;
  padding-right: 20px !important;
}

.summary-row:last-child {
  border-bottom: none !important;
}

/* Summary row labels (left side) */
.summary-row span:first-child {
  font-weight: 500 !important;
  color: #374151 !important;
  flex: 1 !important;
}

/* Summary row values (right side) */
.summary-row span:last-child {
  font-weight: 600 !important;
  color: #1f2937 !important;
  text-align: right !important;
}

/* Note row styling */
.summary-row.note {
  border-bottom: 2px solid #e5e7eb !important;
  padding-bottom: 16px !important;
  margin-bottom: 16px !important;
}

.summary-row.note span {
  font-size: 12px !important;
  color: #6b7280 !important;
  font-style: italic !important;
  font-weight: 400 !important;
}

/* Total row styling */
.summary-row.total {
  border-top: 2px solid #e5e7eb !important;
  border-bottom: none !important;
  padding-top: 16px !important;
  margin-top: 16px !important;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%) !important;
  margin: 16px -20px 0 -20px !important;
  padding: 16px 20px !important;
  border-radius: 8px !important;
}

.summary-row.total span:first-child {
  font-size: 16px !important;
  font-weight: 700 !important;
  color: #1f2937 !important;
}

.summary-row.total .total-amount {
  font-size: 18px !important;
  font-weight: 800 !important;
  color: #dc2626 !important;
  text-shadow: 0 1px 2px rgba(220, 38, 38, 0.1) !important;
}

/* Specific value styling for different types */
.summary-row span[class*="highlight"] {
  color: #059669 !important;
  font-weight: 600 !important;
}

/* Coupon code styling */
.summary-row:first-child span:last-child {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace !important;
  background: #f3f4f6 !important;
  padding: 4px 8px !important;
  border-radius: 4px !important;
  font-size: 12px !important;
  color: #1f2937 !important;
}

/* Percentage styling */
.summary-row:nth-child(2) span:last-child {
  color: #059669 !important;
  font-weight: 700 !important;
}

/* Money amount styling */
.summary-row:nth-child(3) span:last-child,
.summary-row:nth-child(4) span:last-child {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace !important;
  color: #1f2937 !important;
  font-weight: 600 !important;
}

/* Zero amount special styling */
.summary-row span:last-child:contains('0 đ') {
  color: #6b7280 !important;
}

/* Summary section header enhancement */
.order-card h4 {
  margin: 0 !important;
  font-size: 18px !important;
  font-weight: 600 !important;
  color: #1f2937 !important;
}

/* ===== INFO GRID LAYOUT FIXES ===== */
.card-body.info-grid {
  padding: 20px !important;
  margin-top: 0 !important;
  background: #ffffff !important;
}

.info-grid {
  display: flex !important;
  flex-direction: column !important;
  gap: 12px !important;
  margin: 0 !important;
}

.info-item {
  display: flex !important;
  flex-direction: column !important;
  gap: 6px !important;
  padding: 14px 16px !important;
  background: #f9fafb !important;
  border-radius: 8px !important;
  border: 1px solid #f3f4f6 !important;
  transition: all 0.2s ease !important;
  min-height: 60px !important;
}

.info-item:hover {
  background: #f3f4f6 !important;
  border-color: #e5e7eb !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05) !important;
}

.info-label {
  font-size: 11px !important;
  font-weight: 600 !important;
  color: #6b7280 !important;
  text-transform: uppercase !important;
  letter-spacing: 0.5px !important;
  margin: 0 !important;
  text-align: left !important;
  line-height: 1.3 !important;
}

.info-value {
  font-size: 14px !important;
  font-weight: 600 !important;
  color: #1f2937 !important;
  line-height: 1.3 !important;
  text-align: left !important;
  word-wrap: break-word !important;
  margin: 0 !important;
}

/* Card header spacing fix */
.order-card .card-header {
  padding: 16px 20px !important;
  margin-bottom: 0 !important;
  border-bottom: 1px solid #f3f4f6 !important;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%) !important;
}

.order-card .card-header h4 {
  margin: 0 !important;
  font-size: 16px !important;
  font-weight: 600 !important;
  color: #1f2937 !important;
}

/* Payment section specific styling */
.payment-section .card-body {
  padding: 20px !important;
  background: #ffffff !important;
}

.payment-table-wrapper {
  border-radius: 12px !important;
  overflow: hidden !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06) !important;
  border: 1px solid #e2e8f0 !important;
  background: #ffffff !important;
}

.payment-table {
  width: 100% !important;
  border-collapse: collapse !important;
  margin: 0 !important;
}

.payment-table thead {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%) !important;
}

.payment-table th {
  padding: 14px 16px !important;
  text-align: center !important;
  font-size: 11px !important;
  font-weight: 600 !important;
  color: #475569 !important;
  text-transform: uppercase !important;
  letter-spacing: 0.5px !important;
  border-right: 1px solid #f1f5f9 !important;
}

.payment-table th:last-child {
  border-right: none !important;
}

.payment-table td {
  padding: 12px 16px !important;
  text-align: center !important;
  vertical-align: middle !important;
  color: #1f2937 !important;
  border-bottom: 1px solid #f1f5f9 !important;
}

.payment-table td.amount {
  font-weight: 700 !important;
  color: #059669 !important;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace !important;
}

.payment-table tbody tr:hover {
  background: #fafbfc !important;
}

.payment-table tbody tr:last-child td {
  border-bottom: none !important;
}

/* Ensure proper spacing between sections */
.order-card {
  margin-bottom: 24px !important;
  background: #ffffff !important;
  border: 1px solid #e5e7eb !important;
  border-radius: 12px !important;
  overflow: hidden !important;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1) !important;
}

/* Clean SVG action icons styling */
.action-btn-compact svg.action-icon-svg {
  width: 12px !important;
  height: 12px !important;
  min-width: 12px !important;
  max-width: 12px !important;
  min-height: 12px !important;
  max-height: 12px !important;
  display: inline-block !important;
  opacity: 1 !important;
  visibility: visible !important;
  stroke: #6b7280 !important;
  fill: none !important;
  stroke-width: 1.5 !important;
  transition: stroke 0.2s ease !important;
  margin: 0 !important;
  padding: 0 !important;
}

/* Ensure both buttons have identical sizes */
.action-btn-compact.edit-btn,
.action-btn-compact.view-btn {
  width: 24px !important;
  height: 24px !important;
  min-width: 24px !important;
  max-width: 24px !important;
  min-height: 24px !important;
  max-height: 24px !important;
  padding: 0 !important;
  margin: 0 !important;
  border-radius: 3px !important;
  box-sizing: border-box !important;
}

/* Specific rules for edit button */
.action-btn-compact.edit-btn {
  width: 24px !important;
  height: 24px !important;
}

.action-btn-compact.edit-btn svg.action-icon-svg {
  width: 12px !important;
  height: 12px !important;
}

/* Specific rules for view button */
.action-btn-compact.view-btn {
  width: 24px !important;
  height: 24px !important;
}

.action-btn-compact.view-btn svg.action-icon-svg {
  width: 12px !important;
  height: 12px !important;
}

/* Action button hover effects with icon color changes */
.action-btn-compact.edit-btn:hover svg.action-icon-svg {
  stroke: #d97706 !important;
}

.action-btn-compact.view-btn:hover svg.action-icon-svg {
  stroke: #2563eb !important;
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

/* Timeline - High specificity to override conflicts */
.order-detail-modal .card-body.timeline,
.card-body.timeline {
  display: flex !important;
  flex-direction: column !important;
  gap: 16px !important;
  padding: 16px 0 !important;
}

.order-detail-modal .timeline-item,
.card-body.timeline .timeline-item {
  display: flex !important;
  align-items: flex-start !important;
  gap: 12px !important;
  position: relative !important;
  margin: 0 !important;
}

.order-detail-modal .timeline-marker,
.card-body.timeline .timeline-marker {
  width: 12px !important;
  height: 12px !important;
  border-radius: 50% !important;
  background: #d1d5db !important;
  border: 3px solid #ffffff !important;
  box-shadow: 0 0 0 2px #d1d5db !important;
  flex-shrink: 0 !important;
  margin-top: 6px !important;
  position: relative !important;
  display: block !important;
}

.order-detail-modal .timeline-marker.completed,
.card-body.timeline .timeline-marker.completed {
  background: #22c55e !important;
  box-shadow: 0 0 0 2px #22c55e !important;
}

.order-detail-modal .timeline-content,
.card-body.timeline .timeline-content {
  flex: 1 !important;
  padding-left: 8px !important;
  margin: 0 !important;
}

.order-detail-modal .timeline-title,
.card-body.timeline .timeline-title {
  font-weight: 600 !important;
  font-size: 16px !important;
  color: #1f2937 !important;
  margin-bottom: 6px !important;
  line-height: 1.2 !important;
}

.order-detail-modal .timeline-meta,
.card-body.timeline .timeline-meta {
  font-size: 14px !important;
  color: #6b7280 !important;
  margin-bottom: 4px !important;
  line-height: 1.3 !important;
}

.order-detail-modal .timeline-note,
.card-body.timeline .timeline-note {
  font-size: 14px !important;
  color: #6b7280 !important;
  line-height: 1.3 !important;
  margin: 0 !important;
}

/* Timeline connector line with high specificity */
.order-detail-modal .timeline-item:not(:last-child) .timeline-marker::after,
.card-body.timeline .timeline-item:not(:last-child) .timeline-marker::after {
  content: '' !important;
  position: absolute !important;
  top: 18px !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  width: 2px !important;
  height: 24px !important;
  background: #e5e7eb !important;
}

.order-detail-modal .timeline-item.completed:not(:last-child) .timeline-marker::after,
.card-body.timeline .timeline-item.completed:not(:last-child) .timeline-marker::after {
  background: #bbf7d0 !important;
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
/* Simple Clean Order Detail Header */
.order-detail-header {
  display: flex !important;
  align-items: center !important;
  justify-content: space-between !important;
  padding: 20px 24px !important;
  background: #ffffff !important;
  border-bottom: 1px solid #e5e7eb !important;
  position: relative !important;
}

.order-detail-header .header-info {
  display: flex !important;
  align-items: center !important;
  gap: 12px !important;
}

.order-title-block {
  display: flex !important;
  flex-direction: row !important;
  align-items: center !important;
  gap: 12px !important;
}

.order-title-block h3 {
  margin: 0 !important;
  font-size: 18px !important;
  font-weight: 600 !important;
  color: #1f2937 !important;
  line-height: 1.5 !important;
}

/* Hide the badges and complex elements for clean look */
.order-code-badge,
.order-status-pill {
  display: none !important;
}

/* Simple Close Button */
.order-detail-header .modal-close {
  width: 32px !important;
  height: 32px !important;
  border: none !important;
  background: transparent !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  cursor: pointer !important;
  color: #6b7280 !important;
  font-size: 20px !important;
  font-weight: 400 !important;
  transition: color 0.2s ease !important;
  border-radius: 4px !important;
}

.order-detail-header .modal-close:hover {
  color: #374151 !important;
  background: #f3f4f6 !important;
}

/* Edit Modal Form Styling */
.edit-form {
  width: 100% !important;
}

.edit-fields-container {
  display: flex !important;
  flex-direction: column !important;
  gap: 0px !important;
  padding: 24px !important;
  background: #f9fafb !important;
  min-height: 400px !important;
}

/* More specific selectors for field cards */
.order-detail-modal .edit-fields-container .field-card {
  background: #ffffff !important;
  border: 2px solid #cbd5e1 !important;
  border-radius: 12px !important;
  padding: 20px !important;
  margin-bottom: 20px !important;
  transition: all 0.2s ease !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08) !important;
  position: relative !important;
  display: block !important;
  width: 100% !important;
  box-sizing: border-box !important;
}

.order-detail-modal .edit-fields-container .field-card:hover {
  border-color: #9ca3af !important;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12) !important;
  transform: translateY(-1px) !important;
}

.order-detail-modal .edit-fields-container .field-card .field-card-content {
  display: flex !important;
  align-items: flex-start !important;
  gap: 16px !important;
}

.order-detail-modal .edit-fields-container .field-card:focus-within {
  border-color: #4ade80 !important;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1), 0 6px 20px rgba(0, 0, 0, 0.12) !important;
}

/* Original field-card replaced with more specific selector above */

.field-card-content {
  display: flex !important;
  align-items: flex-start !important;
  gap: 16px !important;
}

.field-icon {
  flex-shrink: 0 !important;
  width: 44px !important;
  height: 44px !important;
  background: #f3f4f6 !important;
  border: 1px solid #e5e7eb !important;
  border-radius: 8px !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  color: #374151 !important;
  margin-top: 2px !important;
}

.field-icon svg {
  width: 20px !important;
  height: 20px !important;
}

.field-content {
  flex: 1 !important;
  display: flex !important;
  flex-direction: column !important;
  gap: 12px !important;
  min-width: 0 !important;
}

.field-label {
  font-size: 15px !important;
  font-weight: 600 !important;
  color: #1f2937 !important;
  margin: 0 !important;
  line-height: 1.5 !important;
  padding-top: 2px !important;
}

.field-input,
.field-select {
  width: 100% !important;
  padding: 14px 16px !important;
  border: 2px solid #e5e7eb !important;
  border-radius: 8px !important;
  font-size: 15px !important;
  color: #1f2937 !important;
  background: #ffffff !important;
  transition: all 0.2s ease !important;
  box-sizing: border-box !important;
  font-weight: 500 !important;
}

.field-input:focus,
.field-select:focus {
  outline: none !important;
  border-color: #4ade80 !important;
  background: #ffffff !important;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1) !important;
}

.field-input:hover,
.field-select:hover {
  border-color: #9ca3af !important;
  background: #ffffff !important;
}

.field-input[type="number"] {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace !important;
  font-weight: 600 !important;
}

.field-input::placeholder {
  color: #9ca3af !important;
  font-weight: 400 !important;
}

.field-select {
  cursor: pointer !important;
  appearance: none !important;
  background-image: url('data:image/svg+xml;charset=US-ASCII,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="%236b7280" viewBox="0 0 16 16"><path d="M8 11L3 6h10l-5 5z"/></svg>') !important;
  background-repeat: no-repeat !important;
  background-position: right 12px center !important;
  background-size: 16px !important;
  padding-right: 40px !important;
}

/* Form Actions */
.form-actions {
  display: flex !important;
  justify-content: flex-end !important;
  gap: 12px !important;
  padding: 24px !important;
  border-top: 1px solid #f3f4f6 !important;
  background: #f9fafb !important;
  margin-top: 24px !important;
}

.form-actions .btn {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 8px !important;
  padding: 14px 24px !important;
  border-radius: 8px !important;
  font-size: 14px !important;
  font-weight: 600 !important;
  cursor: pointer !important;
  transition: all 0.2s ease !important;
  border: 2px solid transparent !important;
  min-width: 140px !important;
  min-height: 48px !important;
}

.form-actions .btn svg {
  width: 16px !important;
  height: 16px !important;
  flex-shrink: 0 !important;
}

.form-actions .btn-secondary {
  background: #ffffff !important;
  color: #6b7280 !important;
  border-color: #d1d5db !important;
  box-sizing: border-box !important;
}

.form-actions .btn-secondary:hover {
  background: #f9fafb !important;
  color: #374151 !important;
  border-color: #9ca3af !important;
  transform: translateY(-1px) !important;
}

.form-actions .btn-primary {
  background: #4ade80 !important;
  color: #ffffff !important;
  border-color: #4ade80 !important;
  box-sizing: border-box !important;
}

.form-actions .btn-primary:hover {
  background: #22c55e !important;
  border-color: #22c55e !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(74, 222, 128, 0.3) !important;
}

/* Responsive edit modal */
@media (max-width: 768px) {
  .edit-form .order-detail-grid {
    display: block !important;
  }
  
  .form-actions {
    flex-direction: column !important;
  }
  
  .form-actions .btn {
    width: 100% !important;
    justify-content: center !important;
  }
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

/* ===== Edit Order Modal alignment fixes ===== */

/* Modern product list */
/* Add top spacing so it doesn't stick to the section header */
.order-card .card-body { padding-top: 16px !important; }

/* Add breathing room below the modal header for the overview cards */
.order-detail-body .order-overview { margin-top: 12px; margin-bottom: 16px; }

.modern-products {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.product-card {
  display: grid;
  grid-template-columns: 72px 1fr;
  gap: 14px;
  padding: 12px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #fff;
  transition: transform .15s ease, box-shadow .15s ease, border-color .15s ease;
}
.product-card:hover {
  transform: translateY(-1px);
  border-color: #dbeafe;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.06);
}

.product-media,
.product-media img,
.media-placeholder {
  width: 72px;
  height: 72px;
  border-radius: 10px;
  object-fit: cover;
}
.media-placeholder {
  background: #f1f5f9;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
}

.product-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.product-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}
.product-title {
  font-weight: 600;
  color: #0f172a;
}
.product-qty-chip {
  padding: 4px 10px;
  border-radius: 999px;
  background: #ecfeff;
  color: #0369a1;
  font-weight: 700;
  font-size: 12px;
  white-space: nowrap;
}

.product-meta-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.meta-chip {
  padding: 4px 8px;
  border-radius: 999px;
  background: #f8fafc;
  border: 1px solid #e5e7eb;
  color: #475569;
  font-size: 12px;
}

.product-price-row {
  display: flex;
  align-items: baseline;
  gap: 10px;
}
.product-price-row .price-old {
  text-decoration: line-through;
  color: #94a3b8;
}
.product-price-row .price-new {
  color: #15803d;
  font-weight: 700;
}
.product-price-row .price-badge {
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(248, 113, 113, 0.15);
  color: #dc2626;
  font-size: 11px;
  font-weight: 700;
}

/* empty */
.modern-empty {
  border: 1px dashed #e5e7eb;
  background: #f8fafc;
}
.edit-form .detail-row {
  display: flex;
  align-items: center; /* Align label, icon and field vertically */
  gap: 16px;
  margin-bottom: 16px;
  padding: 12px 16px;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
}

/* Label + icon block should match input height and center vertically */
.edit-form .detail-label {
  display: inline-flex;
  align-items: center;
  justify-content: flex-start;
  gap: 10px;
  min-width: 220px;
  min-height: 44px; /* same as input */
  margin: 0; /* override any global margin-top */
  font-weight: 700;
  color: #1f2937;
}

.edit-form .detail-label .icon-svg {
  display: inline-block;
  width: 18px;
  height: 18px;
  flex-shrink: 0;
  object-fit: contain;
  filter: invert(65%) sepia(78%) saturate(394%) hue-rotate(75deg) brightness(102%) contrast(89%);
}

.edit-form .detail-value {
  flex: 1;
}

.edit-form .detail-input {
  width: 100%;
  min-height: 44px; /* unifies input and select heights */
  padding: 12px 16px;
  border-radius: 12px;
  border: 1.5px solid #dbeafe;
  background: linear-gradient(135deg, rgba(219, 234, 254, 0.25) 0%, rgba(239, 246, 255, 0.65) 100%);
  transition: border-color .2s ease, box-shadow .2s ease;
}

.edit-form .detail-input:focus {
  outline: none;
  border-color: #4ade80;
  box-shadow: 0 0 0 4px rgba(74, 222, 128, 0.12);
  background: #ffffff;
}

/* Input suffix styles */
.input-with-suffix {
  position: relative;
}
.input-with-suffix .detail-input.has-suffix {
  padding-right: 64px; /* leave room for suffix */
}
.input-with-suffix .input-suffix {
  position: absolute;
  top: 50%;
  right: 12px;
  transform: translateY(-50%);
  color: #111827;
  font-weight: 700;
  font-size: 14px;
  background: transparent;
  pointer-events: none;
}

/* Button sizes and hover states */
.modal-footer.add-footer .btn {
  padding: 10px 24px;
  font-size: 15px;
  border-radius: 10px;
  min-width: 120px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.modal-footer.add-footer .btn img.icon-svg {
  width: 16px;
  height: 16px;
}

.modal-footer.add-footer .btn.btn-primary {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: #fff;
  border: 2px solid #4ade80;
  box-shadow: 0 4px 12px rgba(74, 222, 128, 0.25);
}
.modal-footer.add-footer .btn.btn-primary:hover {
  transform: translateY(-1px);
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
}

/* Match size and hover behavior for secondary button */
.modal-footer.add-footer .btn.btn-secondary {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: #fff;
  border: 2px solid #ef4444;
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
}
.modal-footer.add-footer .btn.btn-secondary:hover {
  transform: translateY(-1px);
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
}
</style>

<!-- Load page-level CSS (unscoped) -->
<style src="../../styles/cssQuanLy/quanLyDonHang.css"></style>
<!-- Reuse the coupons table styling exactly -->
<style src="../../styles/cssGiamGia/phieuGiamGia.css"></style>
