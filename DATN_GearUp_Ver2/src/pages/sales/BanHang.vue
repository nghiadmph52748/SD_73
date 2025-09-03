<template>
  <div class="pos-system">
    <!-- Modern Header -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h1 class="page-title">Hệ thống bán hàng</h1>
          <p class="page-subtitle">Quản lý đơn hàng và thanh toán trực tiếp</p>
        </div>
        <div class="header-actions">
          <button class="btn-refresh" @click="refreshData">
            <span class="btn-icon">🔄</span>
            Làm mới
          </button>
          <button class="btn-export" @click="showProductSearch = true">
            <span class="btn-icon">🔍</span>
            Tìm sản phẩm
          </button>
          <button class="btn-export" @click="createNewOrder">
            <span class="btn-icon">➕</span>
            Tạo đơn hàng
          </button>
        </div>
      </div>
    </div>

    <!-- Modern Order Tabs -->
    <div class="modern-tabs-container">
      <div class="order-tabs">
        <div
          v-for="order in tempOrder"
          :key="order.id"
          :class="['modern-tab', { active: currentOrderId === order.id }]"
          @click="switchOrder(order.id)"
        >
          <div class="tab-content">
            <div class="tab-icon">
              <svg
                width="16"
                height="16"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="M19 7h-2V6a2 2 0 00-2-2h-4a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h6l2.29 2.29c.39.39 1.02.39 1.41 0L16 12h3a2 2 0 002-2V9a2 2 0 00-2-2z"
                />
              </svg>
            </div>
            <span class="tab-text">{{ order.tenDonHang }}</span>
            <div class="tab-indicator"></div>
          </div>
          <button
            v-if="tempOrder.length > 1"
            class="modern-close-btn"
            @click.stop="closeOrder(order.id)"
            title="Đóng đơn hàng"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
              <path
                d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"
              />
            </svg>
          </button>
        </div>
        <button
          class="add-tab-btn"
          @click="createNewOrder"
          title="Thêm đơn hàng mới"
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" />
          </svg>
        </button>
      </div>
    </div>

    <div class="pos-content">
      <!-- Modern Product Section -->
      <div class="modern-product-section">
        <div class="modern-section-header">
          <div class="header-title-group">
            <div class="section-icon">
              <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="M19 7h-2V6a2 2 0 00-2-2h-4a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h6l2.29 2.29c.39.39 1.02.39 1.41 0L16 12h3a2 2 0 002-2V9a2 2 0 00-2-2z"
                />
              </svg>
            </div>
            <div class="title-text">
              <h3 class="section-title">Giỏ hàng</h3>
              <p class="section-subtitle">Quản lý sản phẩm trong đơn hàng</p>
            </div>
          </div>
          <div class="section-actions">
            <button
              class="action-btn secondary"
              @click="showProductSearch = true"
            >
              <div class="btn-icon">
                <svg
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path
                    d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z"
                  />
                </svg>
              </div>
              <span>Quét QR</span>
            </button>
            <button
              class="action-btn primary"
              @click="showProductSearch = true"
            >
              <div class="btn-icon">
                <svg
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" />
                </svg>
              </div>
              <span>Thêm SP</span>
            </button>
          </div>
        </div>

        <!-- Modern Cart Items -->
        <div
          class="modern-cart-items"
          v-if="currentOrder && currentOrder.danhSachSanPham.length > 0"
        >
          <div
            v-for="item in currentOrder.danhSachSanPham"
            :key="item.id"
            class="modern-cart-item"
          >
            <div class="discount-badge" v-if="item.giaTriGiamGia > 0">
              <span class="discount-text">{{ item.giaTriGiamGia }}% OFF</span>
            </div>

            <div class="item-checkbox">
              <label class="modern-checkbox">
                <input type="checkbox" v-model="item.selected" />
                <span class="checkmark"></span>
              </label>
            </div>

            <div class="item-image">
              <div class="image-container">
                <img
                  v-if="item.duongDanAnh"
                  :src="
                    item.duongDanAnh.startsWith('http')
                      ? item.duongDanAnh
                      : IMAGE_BASE_URL + item.duongDanAnh
                  "
                  :alt="item.tenSanPham"
                />
                <div v-else class="placeholder-image">
                  <svg
                    width="32"
                    height="32"
                    viewBox="0 0 24 24"
                    fill="currentColor"
                  >
                    <path
                      d="M20,6H16V4A2,2 0 0,0 14,2H10A2,2 0 0,0 8,4V6H4A1,1 0 0,0 3,7V8A1,1 0 0,0 4,9H5V19A3,3 0 0,0 8,22H16A3,3 0 0,0 19,19V9H20A1,1 0 0,0 21,8V7A1,1 0 0,0 20,6M10,4H14V6H10V4M17,19A1,1 0 0,1 16,20H8A1,1 0 0,1 7,19V9H17V19Z"
                    />
                  </svg>
                </div>
              </div>
            </div>

            <div class="item-details">
              <div class="item-header">
                <h4 class="item-name">{{ item.tenSanPham }}</h4>
                <div class="item-meta">
                  <span class="item-size">{{ item.tenKichThuoc }}</span>
                  <span class="item-size">Màu {{ item.tenMauSac }}</span>
                  <span class="item-size">{{ item.tenTrongLuong }}</span>
                  <span class="item-size">{{ item.tenDeGiay }}</span>
                  <span class="item-size">{{ item.tenNhaSanXuat }}</span>
                  <span class="item-size">{{ item.tenXuatXu }}</span>
                  <span class="item-size">{{ item.tenChatLieu }}</span>
                </div>
              </div>
              <div class="item-pricing">
                <span v-if="item.giaTriGiamGia > 0" class="original-price">{{
                  formatCurrency(item.giaBan)
                }}</span>
                <span class="current-price">{{
                  formatCurrency(item.giaSauGiam)
                }}</span>
              </div>
            </div>

            <div class="item-controls">
              <div class="quantity-section">
                <div class="quantity-controls">
                  <button
                    @click="updateQuantity(item, -1)"
                    class="modern-qty-btn minus"
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                    >
                      <path d="M19 13H5v-2h14v2z" />
                    </svg>
                  </button>
                  <div class="quantity-display">{{ item.soLuong }}</div>
                  <button
                    @click="updateQuantity(item, 1)"
                    class="modern-qty-btn plus"
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                    >
                      <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" />
                    </svg>
                  </button>
                </div>
                <div class="item-total">
                  {{ formatCurrency(item.giaSauGiam * item.soLuong) }}
                </div>
              </div>
              <button
                @click="removeItem(item)"
                class="modern-remove-btn"
                title="Xóa sản phẩm"
              >
                <svg
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path
                    d="M19,4H15.5L14.5,3H9.5L8.5,4H5V6H19M6,19A2,2 0 0,0 8,21H16A2,2 0 0,0 18,19V7H6V19Z"
                  />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Modern Empty State -->
        <div v-else class="modern-empty-cart">
          <div class="empty-animation">
            <div class="empty-icon">
              <svg
                width="80"
                height="80"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="M17,18C15.89,18 15,18.89 15,20A2,2 0 0,0 17,22A2,2 0 0,0 19,20C19,18.89 18.1,18 17,18M1,2V4H3L6.6,11.59L5.24,14.04C5.09,14.32 5,14.65 5,15A2,2 0 0,0 7,17H19V15H7.42A0.25,0.25 0 0,1 7.17,14.75C7.17,14.7 7.18,14.66 7.2,14.63L8.1,13H15.55C16.3,13 16.96,12.58 17.3,11.97L20.88,5H5.21L4.27,3H1M7,18C5.89,18 5,18.89 5,20A2,2 0 0,0 7,22A2,2 0 0,0 9,20C9,18.89 8.1,18 7,18Z"
                />
              </svg>
            </div>
            <div class="empty-circles">
              <div class="circle circle-1"></div>
              <div class="circle circle-2"></div>
              <div class="circle circle-3"></div>
            </div>
          </div>
          <div class="empty-content">
            <h3 class="empty-title">Giỏ hàng trống</h3>
            <p class="empty-subtitle">Thêm sản phẩm để bắt đầu tạo đơn hàng</p>
            <button
              class="modern-btn btn-primary"
              @click="showProductSearch = true"
            >
              <div class="btn-icon">
                <svg
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" />
                </svg>
              </div>
              <span>Thêm sản phẩm đầu tiên</span>
            </button>
          </div>
        </div>

        <!-- Modern Total Section -->
        <div class="modern-total-section" v-if="currentOrder">
          <div class="total-background"></div>
          <div class="total-content">
            <div class="total-icon">
              <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="M12,1L8,5H11V14H13V5H16M18,23H6A2,2 0 0,1 4,21V9A2,2 0 0,1 6,7H9V9H6V21H18V9H15V7H18A2,2 0 0,1 20,9V21A2,2 0 0,1 18,23Z"
                />
              </svg>
            </div>
            <div class="total-info">
              <span class="total-label">Tổng tiền hàng</span>
              <span class="total-amount">{{
                formatCurrency(currentOrder.tongTien || 0)
              }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Modern Customer Section -->
      <div class="modern-customer-section">
        <div class="modern-section-header">
          <div class="header-title-group">
            <div class="section-icon customer">
              <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z"
                />
              </svg>
            </div>
            <div class="title-text">
              <h3 class="section-title">Khách hàng & Thanh toán</h3>
              <p class="section-subtitle">
                Thông tin khách hàng và xử lý thanh toán
              </p>
            </div>
          </div>
          <button class="action-btn primary" @click="showCustomerSearch = true">
            <div class="btn-icon">
              <svg
                width="18"
                height="18"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"
                />
              </svg>
            </div>
            <span>Chọn KH</span>
          </button>
        </div>

        <div class="customer-form" v-if="currentOrder">
          <!-- Customer Info Section -->
          <div class="customer-info-section">
            <div class="form-group">
              <label class="form-label">Tên Khách hàng</label>
              <div class="customer-input-container">
                <input
                  type="text"
                  v-model="customerDisplayName"
                  @input="searchCustomers"
                  @focus="showCustomerDropdown = true"
                  class="form-control"
                  placeholder="Nhập tên hoặc email khách hàng để tìm kiếm"
                  autocomplete="off"
                />
                <button
                  v-if="customerDisplayName"
                  class="btn-clear-input"
                  @click="clearCustomerInput"
                  title="Xóa nội dung"
                >
                  ✕
                </button>

                <!-- Customer Suggestions Dropdown -->
                <div
                  v-if="customerSuggestions.length > 0 && showCustomerDropdown"
                  class="customer-suggestions"
                >
                  <div
                    v-for="customer in customerSuggestions"
                    :key="customer.id"
                    :class="[
                      'customer-suggestion-item',
                      { 'create-new-customer': customer.isCreateNew },
                    ]"
                    @click="selectCustomerFromSuggestions(customer)"
                  >
                    <div class="customer-info">
                      <strong>{{ customer.tenKhachHang }}</strong>
                      <small v-if="!customer.isCreateNew"
                        >{{ customer.email }} |
                        {{ customer.soDienThoai }}</small
                      >
                      <small v-else class="create-new-hint">
                        📝 Nhấn để tạo khách hàng mới
                      </small>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Discount Section -->
          <div class="discount-section">
            <h4 class="subsection-title">💰 Giảm giá & Khuyến mãi</h4>

            <!-- Available Coupons -->
            <div class="form-group">
              <label class="form-label">Phiếu giảm giá khả dụng</label>
              <div class="coupon-selector">
                <!-- Main Coupon Select Button -->
                <button
                  class="btn btn-outline coupon-select-btn"
                  @click="openCouponModal"
                  :disabled="availableCoupons.length === 0"
                >
                  <span v-if="availableCoupons.length > 0">
                    <span v-if="selectedCoupons.length > 0">
                      🎫 Đã chọn phiếu giảm giá
                      <span v-if="autoAppliedCoupon" class="auto-indicator"
                        >(🤖 Tự động)</span
                      >
                    </span>
                    <span v-else>🎫 Chọn phiếu giảm giá</span>
                  </span>
                  <span v-else> 🎫 Chọn phiếu giảm giá (Đang tải...) </span>
                </button>

                <!-- Info Message -->
                <div v-if="availableCoupons.length === 0" class="info-message">
                  <small class="text-muted">
                    📝 Đang tải danh sách phiếu giảm giá...
                  </small>
                </div>
              </div>
            </div>

            <!-- Auto Applied Notification -->
            <div v-if="autoAppliedCoupon" class="auto-applied-notification">
              <small class="text-info">
                🤖 Đã tự động áp dụng phiếu giảm giá tốt nhất cho đơn hàng của
                bạn!
              </small>
            </div>

            <!-- Selected Coupons Display -->
            <div class="form-group" v-if="selectedCoupons.length > 0">
              <label class="form-label">Phiếu giảm giá đã chọn</label>
              <div class="selected-coupons">
                <div class="selected-coupon-item">
                  <div class="coupon-summary">
                    <div class="coupon-header">
                      <span class="coupon-name">{{
                        selectedCoupons[0].tenPhieuGiamGia
                      }}</span>
                      <span
                        v-if="
                          autoAppliedCoupon &&
                          autoAppliedCoupon.id === selectedCoupons[0].id
                        "
                        class="auto-applied-badge"
                      >
                        🤖 Tự động
                      </span>
                    </div>
                    <span class="coupon-value">
                      <span
                        v-if="selectedCoupons[0].loaiPhieuGiamGia === false"
                      >
                        -{{ selectedCoupons[0].giaTriGiamGia }}% (-{{
                          calculateCouponDiscount(
                            selectedCoupons[0]
                          ).toLocaleString()
                        }}đ)
                      </span>
                      <span
                        v-else-if="selectedCoupons[0].loaiPhieuGiamGia === true"
                      >
                        -{{
                          selectedCoupons[0].giaTriGiamGia.toLocaleString()
                        }}đ
                      </span>
                    </span>
                  </div>
                  <div class="coupon-actions">
                    <button
                      class="btn-change-coupon"
                      @click="openCouponModal"
                      title="Thay đổi phiếu giảm giá"
                    >
                      🔄
                    </button>
                    <button
                      class="btn-remove-coupon"
                      @click="removeSelectedCoupon(selectedCoupons[0].id)"
                      title="Xóa phiếu giảm giá"
                    >
                      ✕
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Tổng giảm giá</label>
              <div class="discount-display">
                <span class="discount-amount"
                  >{{
                    currentOrder.discount
                      ? currentOrder.discount.toLocaleString()
                      : "0"
                  }}đ</span
                >
                <small
                  class="discount-breakdown"
                  v-if="selectedCoupons.length > 0"
                >
                  (Từ phiếu giảm giá)
                </small>
                <div v-if="selectedCoupons.length > 0" class="discount-details">
                  <small class="discount-detail">
                    {{ selectedCoupons[0].tenPhieuGiamGia }}:
                    <span v-if="selectedCoupons[0].loaiPhieuGiamGia === false">
                      -{{
                        calculateCouponDiscount(
                          selectedCoupons[0]
                        ).toLocaleString()
                      }}đ
                    </span>
                    <span
                      v-else-if="selectedCoupons[0].loaiPhieuGiamGia === true"
                    >
                      -{{ selectedCoupons[0].giaTriGiamGia.toLocaleString() }}đ
                    </span>
                  </small>
                </div>
              </div>
            </div>
          </div>

          <!-- Shipping Section -->
          <div class="shipping-section">
            <h4 class="subsection-title">🚚 Giao hàng</h4>
            <div class="delivery-toggle" v-if="currentOrder">
              <label class="toggle-option">
                <input
                  type="radio"
                  value="pickup"
                  v-model="currentOrder.ghiChu"
                  checked
                />
                <span>Nhận tại cửa hàng</span>
              </label>
              <label class="toggle-option">
                <input
                  type="radio"
                  value="delivery"
                  v-model="currentOrder.ghiChu"
                />
                <span>Giao hàng tận nơi</span>
              </label>
            </div>

            <div
              class="shipping-info"
              v-if="currentOrder && currentOrder.ghiChu === 'delivery'"
            >
              <div class="delivery-service-selector">
                <label class="form-label">Đơn vị vận chuyển:</label>
                <div class="delivery-service-toggle">
                  <button
                    v-for="service in deliveryServices"
                    :key="service.code"
                    :class="[
                      'service-btn',
                      {
                        active:
                          currentOrder?.selectedService?.code === service.code,
                      },
                    ]"
                    @click="selectDeliveryService(service)"
                  >
                    <div class="service-logo">
                      <span
                        class="service-text"
                        :style="{ color: service.color }"
                        >{{ service.name }}</span
                      >
                    </div>
                    <div class="service-info">
                      <div class="service-time">{{ service.deliveryTime }}</div>
                      <div class="service-fee">
                        {{ formatCurrency(service.fee) }}
                      </div>
                    </div>
                  </button>
                </div>
              </div>

              <div
                class="selected-service-info"
                v-if="currentOrder?.selectedService"
              >
                <div class="shipping-method">
                  <span
                    >🚚 Đơn vị: {{ currentOrder.selectedService.name }}</span
                  >
                </div>
                <div class="estimated-delivery">
                  <span
                    >📅 Thời gian:
                    {{ currentOrder.selectedService.deliveryTime }}</span
                  >
                </div>
                <div class="shipping-fee">
                  <span
                    >💰 Phí vận chuyển:
                    {{
                      formatCurrency(currentOrder.selectedService.fee || 0)
                    }}</span
                  >
                </div>
              </div>
            </div>

            <!-- Delivery Address Section -->
            <div
              v-if="currentOrder && currentOrder.ghiChu === 'delivery'"
              class="delivery-address-section"
            >
              <h5 class="address-title">📍 Địa chỉ giao hàng</h5>

              <div class="address-form">
                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">*Họ tên người nhận</label>
                    <input
                      type="text"
                      v-model="deliveryAddress.tenNguoiNhan"
                      class="form-control"
                      placeholder="Nhập họ tên người nhận"
                    />
                  </div>
                  <div class="form-group">
                    <label class="form-label">*Số điện thoại người nhận</label>
                    <input
                      type="tel"
                      v-model="deliveryAddress.soDienThoaiNguoiNhan"
                      class="form-control"
                      placeholder="Nhập số điện thoại"
                    />
                  </div>
                </div>

                <div class="form-group">
                  <label class="form-label">Email người nhận (tùy chọn)</label>
                  <input
                    type="email"
                    v-model="deliveryAddress.emailNguoiNhan"
                    class="form-control"
                    placeholder="Nhập email người nhận"
                  />
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">*Tỉnh/Thành phố</label>
                    <input
                      type="text"
                      v-model="deliveryAddress.thanhPho"
                      class="form-control"
                      placeholder="Nhập tỉnh/thành phố"
                    />
                  </div>
                  <div class="form-group">
                    <label class="form-label">*Quận/Huyện</label>
                    <input
                      type="text"
                      v-model="deliveryAddress.quan"
                      class="form-control"
                      placeholder="Nhập quận/huyện"
                    />
                  </div>
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">*Xã/Phường</label>
                    <input
                      type="text"
                      v-model="deliveryAddress.phuong"
                      class="form-control"
                      placeholder="Nhập xã/phường"
                    />
                  </div>
                  <div class="form-group">
                    <label class="form-label">*Địa chỉ cụ thể</label>
                    <input
                      type="text"
                      v-model="deliveryAddress.diaChiCuThe"
                      class="form-control"
                      placeholder="Nhập địa chỉ cụ thể"
                    />
                  </div>
                </div>

                <div class="address-preview" v-if="isAddressComplete">
                  <strong>📍 Địa chỉ đầy đủ:</strong>
                  <p>{{ getFullAddress }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Price Summary -->
          <div class="price-summary-section">
            <h4 class="subsection-title">📊 Tổng kết đơn hàng</h4>
            <div class="price-breakdown" v-if="currentOrder">
              <div class="price-row">
                <span>Tiền hàng</span>
                <span>{{ formatCurrency(currentOrder.tongTien || 0) }}</span>
              </div>
              <div class="price-row">
                <span>Phí vận chuyển</span>
                <span
                  v-if="
                    currentOrder.tongTien >= 3000000 &&
                    currentOrder.ghiChu === 'delivery'
                  "
                >
                  <span class="free-shipping">Miễn phí 🚚</span>
                </span>
                <span v-else>
                  {{ formatCurrency(currentOrder.phiVanChuyen || 0) }}
                </span>
              </div>
              <!-- Thông báo miễn phí giao hàng -->
              <div
                v-if="currentOrder.ghiChu === 'delivery'"
                class="shipping-notice"
              >
                <small
                  v-if="currentOrder.tongTien >= 3000000"
                  class="text-success"
                >
                  🎉 Đơn hàng đủ điều kiện miễn phí giao hàng!
                </small>
                <small v-else class="text-muted">
                  💡 Mua thêm
                  {{ formatCurrency(3000000 - currentOrder.tongTien) }} để được
                  miễn phí giao hàng
                </small>
              </div>
              <!-- Coupon Discount Breakdown -->
              <div
                v-if="selectedCoupons.length > 0"
                class="coupon-discount-breakdown"
              >
                <div class="price-row coupon-discount">
                  <span>
                    {{ selectedCoupons[0].tenPhieuGiamGia }}
                    <small v-if="selectedCoupons[0].loaiPhieuGiamGia === false">
                      ({{ selectedCoupons[0].giaTriGiamGia }}%)
                    </small>
                    <small
                      v-else-if="selectedCoupons[0].loaiPhieuGiamGia === true"
                    >
                      ({{ selectedCoupons[0].giaTriGiamGia.toLocaleString() }}đ)
                    </small>
                  </span>
                  <span class="discount">
                    <span v-if="selectedCoupons[0].loaiPhieuGiamGia === false">
                      -{{
                        calculateCouponDiscount(
                          selectedCoupons[0]
                        ).toLocaleString()
                      }}đ
                    </span>
                    <span
                      v-else-if="selectedCoupons[0].loaiPhieuGiamGia === true"
                    >
                      -{{ selectedCoupons[0].giaTriGiamGia.toLocaleString() }}đ
                    </span>
                  </span>
                </div>

                <!-- Total Discount Row -->
                <div class="price-row discount-total">
                  <span><strong>Tổng giảm giá</strong></span>
                  <span class="discount"
                    >-{{ formatCurrency(currentOrder.discount || 0) }}</span
                  >
                </div>
              </div>
              <div class="price-row total">
                <span>Tổng số tiền</span>
                <span class="total-amount">{{
                  formatCurrency(currentOrder.tongTienSauGiam || 0)
                }}</span>
              </div>
            </div>
          </div>

          <!-- Payment Section -->
          <div class="payment-section">
            <h4 class="subsection-title">💳 Thanh toán</h4>

            <!-- Payment Method Selection -->
            <div class="payment-method-selection" v-if="currentOrder">
              <label class="form-label">Phương thức thanh toán</label>
              <div class="payment-options">
                <div class="payment-option">
                  <input
                    type="radio"
                    id="pay_now"
                    value="pay_now"
                    v-model="currentOrder.phuongThucThanhToan"
                  />
                  <label for="pay_now">💰 Trả ngay</label>
                </div>
                <div class="payment-option">
                  <input
                    type="radio"
                    id="bank_transfer"
                    value="bank_transfer"
                    v-model="currentOrder.phuongThucThanhToan"
                  />
                  <label for="bank_transfer">🏦 Chuyển khoản</label>
                </div>
                <div
                  class="payment-option"
                  v-if="
                    currentOrder.ghiChu &&
                    currentOrder.ghiChu.includes('delivery')
                  "
                >
                  <input
                    type="radio"
                    id="cod"
                    value="cod"
                    v-model="currentOrder.phuongThucThanhToan"
                  />
                  <label for="cod">🚚 Thanh toán khi nhận hàng</label>
                </div>
              </div>
            </div>

            <!-- Pay Now Input -->
            <div
              class="payment-method"
              v-if="currentOrder?.phuongThucThanhToan === 'pay_now'"
            >
              <label class="form-label">Số tiền khách trả</label>
              <div class="payment-amount">
                <input
                  type="number"
                  v-model="currentOrder.tienKhachTra"
                  class="form-control"
                  placeholder="Nhập số tiền khách thanh toán"
                  min="0"
                  :max="currentOrder.tongTienSauGiam"
                />
              </div>
            </div>

            <!-- Bank Transfer QR Code -->
            <div
              class="bank-transfer-section"
              v-if="currentOrder?.phuongThucThanhToan === 'bank_transfer'"
            >
              <div class="qr-code-container">
                <h5>🏦 Thông tin chuyển khoản</h5>
                <div class="bank-info">
                  <p><strong>Ngân hàng:</strong> Vietcombank</p>
                  <p><strong>Số tài khoản:</strong> 1234567890</p>
                  <p><strong>Chủ tài khoản:</strong> GEAR UP STORE</p>
                  <p>
                    <strong>Số tiền:</strong>
                    {{ formatCurrency(currentOrder.tongTienSauGiam) }}
                  </p>
                  <p><strong>Nội dung:</strong> HD{{ Date.now() }}</p>
                </div>
                <div class="qr-placeholder">
                  <div class="qr-code">
                    📱<br />QR Code<br />{{
                      formatCurrency(currentOrder.tongTienSauGiam)
                    }}
                  </div>
                  <p class="qr-note">Quét mã QR để chuyển khoản</p>
                </div>
              </div>
            </div>

            <!-- COD Info -->
            <div
              class="cod-info"
              v-if="currentOrder?.phuongThucThanhToan === 'cod'"
            >
              <div class="cod-notice">
                <h5>🚚 Thanh toán khi nhận hàng</h5>
                <p>
                  Khách hàng sẽ thanh toán khi nhận được hàng tại địa chỉ giao
                  hàng.
                </p>
                <p>
                  <strong>Số tiền cần thanh toán:</strong>
                  {{ formatCurrency(currentOrder.tongTienSauGiam) }}
                </p>
              </div>
            </div>

            <!-- Payment Status -->
            <div
              class="payment-details"
              v-if="currentOrder?.phuongThucThanhToan === 'pay_now'"
            >
              <div class="detail-row">
                <span>Số tiền cần trả</span>
                <span class="amount">{{
                  formatCurrency(currentOrder?.tongTienSauGiam || 0)
                }}</span>
              </div>
              <div class="detail-row">
                <span>Khách đã trả</span>
                <span class="amount paid">{{
                  formatCurrency(currentOrder?.tienKhachTra || 0)
                }}</span>
              </div>
              <div class="detail-row">
                <span>Tiền thiếu/Trả lại</span>
                <span
                  :class="[
                    'amount',
                    (currentOrder?.tienKhachTra || 0) -
                      (currentOrder?.tongTienSauGiam || 0) >=
                    0
                      ? 'surplus'
                      : 'deficit',
                  ]"
                >
                  {{
                    formatCurrency(
                      Math.abs(
                        (currentOrder?.tienKhachTra || 0) -
                          (currentOrder?.tongTienSauGiam || 0)
                      )
                    )
                  }}
                </span>
              </div>
            </div>

            <!-- Transfer Status -->
            <div
              class="payment-details"
              v-if="currentOrder?.phuongThucThanhToan === 'bank_transfer'"
            >
              <div class="detail-row">
                <span>Trạng thái</span>
                <span class="status pending">⏳ Chờ chuyển khoản</span>
              </div>
              <div class="detail-row">
                <span>Số tiền cần chuyển</span>
                <span class="amount">{{
                  formatCurrency(currentOrder?.tongTienSauGiam || 0)
                }}</span>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
              <button
                class="btn btn-primary btn-lg w-100"
                @click="confirmOrder"
              >
                XÁC NHẬN ĐẶT HÀNG
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Product Search Modal -->
    <div
      v-if="showProductSearch"
      class="modal-overlay"
      @click="showProductSearch = false"
    >
      <div class="modal-content large" @click.stop>
        <div class="modal-header">
          <h3>Tìm kiếm sản phẩm</h3>
          <button class="modal-close" @click="showProductSearch = false">
            ✕
          </button>
        </div>

        <div class="modal-body">
          <!-- Search and Filter -->
          <div
            class="search-section"
            style="display: flex; gap: 20px; align-items: center"
          >
            <div class="search-bar">
              <input
                type="text"
                v-model="productSearchQuery"
                class="form-control"
                style="width: 400px"
                placeholder="Tìm theo tên sản phẩm, mã và thuộc tính sản phẩm"
              />
            </div>

            <div class="price-range" style="margin-left: auto">
              <span>{{ formatCurrency(priceRange.min) }}</span>
              <input
                type="range"
                :min="priceRange.min"
                :max="priceRange.max"
                v-model="selectedPriceMax"
                class="price-slider"
              />
              <span>{{ formatCurrency(priceRange.max) }}</span>
            </div>
          </div>

          <div
            class="filter-row"
            style="
              display: flex;
              gap: 19.2px;
              margin-top: 15px;
              flex-wrap: wrap;
              align-items: center;
            "
          >
            <select
              v-model="selectedNhaSanXuat"
              class="form-control"
              style="width: 165px"
            >
              <option value="">Nhà sản xuất: Tất cả</option>
              <option
                v-for="category in NhaSanXuats"
                :key="category.id"
                :value="category.id"
              >
                {{ category.tenNhaSanXuat }}
              </option>
            </select>

            <select
              v-model="selectedXuatXu"
              class="form-control"
              style="width: 165px"
            >
              <option value="">Xuất xứ: Tất cả</option>
              <option
                v-for="category in XuatXus"
                :key="category.id"
                :value="category.id"
              >
                {{ category.tenXuatXu }}
              </option>
            </select>

            <select
              v-model="selectedChatLieu"
              class="form-control"
              style="width: 165px"
            >
              <option value="">Chất liệu: Tất cả</option>
              <option
                v-for="category in ChatLieus"
                :key="category.id"
                :value="category.id"
              >
                {{ category.tenChatLieu }}
              </option>
            </select>

            <select
              v-model="selectedSize"
              class="form-control"
              style="width: 165px"
            >
              <option value="">Size: Tất cả</option>
              <option
                v-for="category in KichThuocs"
                :key="category.id"
                :value="category.id"
              >
                {{ category.tenKichThuoc }}
              </option>
            </select>

            <select
              v-model="selectedDeGiay"
              class="form-control"
              style="width: 165px"
            >
              <option value="">Đế giày: Tất cả</option>
              <option
                v-for="category in DeGiays"
                :key="category.id"
                :value="category.id"
              >
                {{ category.tenDeGiay }}
              </option>
            </select>

            <select
              v-model="selectedMauSac"
              class="form-control"
              style="width: 165px"
            >
              <option value="">Màu sắc: Tất cả</option>
              <option
                v-for="category in MauSacs"
                :key="category.id"
                :value="category.id"
              >
                {{ category.tenMauSac }}
              </option>
            </select>
          </div>

          <!-- Product Grid -->
          <div class="product-grid">
            <div
              v-for="product in filteredSearchProducts"
              :key="product.id"
              class="product-card"
            >
              <div class="discount-label" v-if="product.giaSauGiamGia > 0">
                {{ product.giaTriGiamGia }}% OFF
              </div>
              <div class="product-image" @click="openImageModal(product.id)">
                <!-- Carousel cho nhiều ảnh -->
                <div
                  v-if="product.anhSanPham && product.anhSanPham.length > 1"
                  class="image-carousel"
                >
                  <div
                    v-for="(imageUrl, index) in product.anhSanPham"
                    :key="`carousel-${product.id}-${index}`"
                    :class="['carousel-image', { active: index === 0 }]"
                  >
                    <img
                      :src="
                        imageUrl.startsWith('http')
                          ? imageUrl
                          : IMAGE_BASE_URL + imageUrl
                      "
                      :alt="`${product.tenSanPham} - ${index + 1}`"
                      @error="
                        (e) => {
                          console.error(
                            '❌ Carousel image error:',
                            imageUrl,
                            e
                          );
                          handleImageError(e);
                        }
                      "
                    />
                  </div>

                  <!-- Indicators -->
                  <div class="carousel-indicators">
                    <span
                      v-for="(imageUrl, index) in product.anhSanPham"
                      :key="`indicator-${product.id}-${index}`"
                      :class="['indicator', { active: index === 0 }]"
                    ></span>
                  </div>
                </div>

                <!-- Ảnh đơn -->
                <div v-else class="single-image">
                  <img
                    v-if="product.anhSanPham && product.anhSanPham.length > 0"
                    :src="
                      product.anhSanPham[0].startsWith('http')
                        ? product.anhSanPham[0]
                        : IMAGE_BASE_URL + product.anhSanPham[0]
                    "
                    :alt="product.tenSanPham"
                    @error="
                      (e) => {
                        handleImageError(e);
                      }
                    "
                  />
                  <div v-else class="placeholder-image">👟</div>
                </div>
              </div>
              <div class="product-info">
                <h4>{{ product.tenSanPham }}</h4>
                <p class="product-details">
                  {{ product.maSanPham }} | {{ product.tenDeGiay }} |
                  {{ product.tenNhaSanXuat }}
                </p>
                <p class="product-specs">
                  {{ product.tenMauSac }} | {{ product.tenChatLieu }} | Size:
                  {{ product.tenKichThuoc }}
                </p>
                <div class="product-price">
                  <span
                    v-if="product.giaTriGiamGia > 0"
                    class="original-price"
                    >{{ formatCurrency(product.giaBan) }}</span
                  >
                  <span class="current-price">{{
                    formatCurrency(
                      (product.giaBan / 100) * (100 - product.giaTriGiamGia)
                    )
                  }}</span>
                </div>
              </div>
              <div class="product-actions">
                <button
                  class="btn btn-primary btn-sm"
                  @click="addProductToCart(product)"
                >
                  CHỌN
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Customer Search Modal -->
    <div
      v-if="showCustomerSearch"
      class="modal-overlay"
      @click="showCustomerSearch = false"
    >
      <div class="modal-content customer-modal" @click.stop>
        <div class="modal-header">
          <h3>Tìm kiếm khách hàng</h3>
          <button class="modal-close" @click="showCustomerSearch = false">
            ✕
          </button>
        </div>

        <div class="modal-body">
          <div class="search-section">
            <input
              type="text"
              v-model="customerSearchQuery"
              class="form-control"
              placeholder="Tìm kiếm tên hoặc số điện thoại hoặc email"
            />
            <button class="btn btn-primary" @click="openAddCustomerForm">
              ➕ THÊM KHÁCH HÀNG
            </button>
          </div>

          <div class="customer-list">
            <table class="table">
              <thead>
                <tr>
                  <th>STT</th>
                  <th>Email</th>
                  <th>Họ tên</th>
                  <th>Ngày sinh</th>
                  <th>Số điện thoại</th>
                  <th>Giới tính</th>
                  <th>Trạng thái</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="(customer, index) in filteredCustomers"
                  :key="customer.id"
                >
                  <td>{{ index + 1 }}</td>
                  <td>{{ customer.email }}</td>
                  <td>{{ customer.tenKhachHang }}</td>
                  <td>{{ customer.ngaySinh }}</td>
                  <td>{{ customer.soDienThoai }}</td>
                  <td>{{ customer.gioiTinh ? "Nam" : "Nữ" }}</td>
                  <td>
                    <span class="badge badge-success">{{
                      !customer.trangThai ? "Hoạt động" : "Không hoạt động"
                    }}</span>
                  </td>
                  <td>
                    <button
                      class="btn btn-primary btn-sm"
                      @click="selectCustomer(customer)"
                    >
                      CHỌN
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Add Customer Form -->
          <div v-if="showAddCustomerForm" class="add-customer-form">
            <div class="form-sections">
              <div class="form-section">
                <h4>Thông tin cá nhân</h4>
                <div class="form-group">
                  <label class="form-label">*Họ và tên</label>
                  <input
                    type="text"
                    v-model="newCustomerForm.tenKhachHang"
                    class="form-control"
                    required
                  />
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">*Email</label>
                    <input
                      type="email"
                      v-model="newCustomerForm.email"
                      class="form-control"
                      required
                    />
                  </div>
                  <div class="form-group">
                    <label class="form-label">*Số điện thoại</label>
                    <input
                      type="tel"
                      v-model="newCustomerForm.soDienThoai"
                      class="form-control"
                      required
                    />
                  </div>
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">*Ngày sinh</label>
                    <input
                      type="date"
                      v-model="newCustomerForm.ngaySinh"
                      class="form-control"
                      required
                    />
                  </div>
                  <div class="form-group">
                    <label class="form-label">*Giới tính</label>
                    <select
                      v-model="newCustomerForm.gioiTinh"
                      class="form-control"
                    >
                      <option :value="true">Nam</option>
                      <option :value="false">Nữ</option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="form-section">
                <h4>Thông tin tài khoản</h4>
                <div class="form-group">
                  <label class="form-label">*Tài khoản</label>
                  <input
                    type="text"
                    v-model="newCustomerForm.tenTaiKhoan"
                    class="form-control"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Mật khẩu</label>
                  <input
                    type="password"
                    v-model="newCustomerForm.matKhau"
                    class="form-control"
                    required
                  />
                </div>
              </div>

              <div class="form-section">
                <div class="address-header">
                  <h4>Địa chỉ</h4>
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">*Tỉnh/thành phố</label>
                    <input
                      type="text"
                      v-model="newCustomerForm.listDiaChi[0].thanhPho"
                      class="form-control"
                      placeholder="Nhập tên tỉnh/thành phố"
                      required
                    />
                  </div>
                  <div class="form-group">
                    <label class="form-label">*Quận/huyện</label>
                    <input
                      type="text"
                      v-model="newCustomerForm.listDiaChi[0].quan"
                      class="form-control"
                      placeholder="Nhập tên quận/huyện"
                      required
                    />
                  </div>
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">*Xã/phường/thị trấn</label>
                    <input
                      type="text"
                      v-model="newCustomerForm.listDiaChi[0].phuong"
                      class="form-control"
                      placeholder="Nhập tên xã/phường/thị trấn"
                      required
                    />
                  </div>
                  <div class="form-group">
                    <label class="form-label">*Địa chỉ cụ thể</label>
                    <input
                      type="text"
                      v-model="newCustomerForm.listDiaChi[0].diaChiCuThe"
                      class="form-control"
                      required
                    />
                  </div>
                </div>
              </div>
            </div>

            <div class="form-actions">
              <button class="btn btn-secondary" @click="cancelAddCustomer">
                Hủy
              </button>
              <button class="btn btn-primary" @click="saveNewCustomer">
                Thêm khách hàng
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Image Modal -->
      <div
        v-if="showImageModal"
        class="image-modal-overlay"
        @click="closeImageModal"
      >
        <div class="image-modal-content" @click.stop>
          <button class="image-modal-close" @click="closeImageModal">✕</button>

          <div class="image-modal-main">
            <button
              v-if="currentProductImages.length > 1"
              class="nav-btn prev-btn"
              @click="prevImage"
            >
              ‹
            </button>

            <div class="image-modal-display">
              <img
                :src="currentProductImages[selectedImageIndex]?.duongDanAnh"
                :alt="`Ảnh ${selectedImageIndex + 1}`"
                class="modal-image"
                @error="handleImageError"
              />
            </div>

            <button
              v-if="currentProductImages.length > 1"
              class="nav-btn next-btn"
              @click="nextImage"
            >
              ›
            </button>
          </div>

          <div
            v-if="currentProductImages.length > 1"
            class="image-modal-thumbnails"
          >
            <div
              v-for="(image, index) in currentProductImages"
              :key="image.id"
              :class="['thumbnail', { active: index === selectedImageIndex }]"
              @click="selectImage(index)"
            >
              <img
                :src="image.duongDanAnh"
                :alt="`Thumbnail ${index + 1}`"
                @error="handleImageError"
              />
            </div>
          </div>

          <div class="image-modal-counter">
            {{ selectedImageIndex + 1 }} / {{ currentProductImages.length }}
          </div>
        </div>
      </div>
    </div>

    <!-- Coupon Selection Modal -->
    <div v-if="showCouponModal" class="modal-overlay" @click="closeCouponModal">
      <div class="modal-content coupon-modal" @click.stop>
        <div class="modal-header">
          <h3>🎫 Chọn phiếu giảm giá</h3>
          <button class="modal-close-btn" @click="closeCouponModal">✕</button>
        </div>

        <div class="modal-body">
          <div class="coupon-list">
            <div
              v-for="coupon in availableCoupons"
              :key="coupon.id"
              class="coupon-modal-item"
              :class="{
                selected: isCouponSelected(coupon.id),
                disabled: !canApplyCoupon(coupon),
              }"
              @click="
                canApplyCoupon(coupon) ? toggleCouponSelection(coupon) : null
              "
            >
              <div class="coupon-modal-info">
                <div class="coupon-modal-name">
                  {{ coupon.tenPhieuGiamGia }}
                </div>
                <div class="coupon-modal-details">
                  <span v-if="coupon.loaiPhieuGiamGia === false">
                    Giảm {{ coupon.giaTriGiamGia }}% (sẽ trừ:
                    {{ calculateCouponDiscount(coupon).toLocaleString() }}đ)
                  </span>
                  <span v-else-if="coupon.loaiPhieuGiamGia === true">
                    Giảm {{ coupon.giaTriGiamGia.toLocaleString() }}đ
                  </span>
                  <span v-if="coupon.donHangToiThieu" class="min-order">
                    • Đơn tối thiểu:
                    {{ coupon.donHangToiThieu.toLocaleString() }}đ
                  </span>
                </div>
                <div v-if="!canApplyCoupon(coupon)" class="coupon-reason">
                  <small
                    v-if="
                      coupon.donHangToiThieu &&
                      currentOrder.tongTien < coupon.donHangToiThieu
                    "
                  >
                    💰 Đơn hàng chưa đủ giá trị tối thiểu
                  </small>
                  <small
                    v-else-if="
                      selectedCoupons.length > 0 &&
                      !selectedCoupons.some((c) => c.id === coupon.id)
                    "
                  >
                    ⚠️ Đã chọn phiếu khác, chỉ được dùng 1 phiếu
                  </small>
                  <small v-else> ⚠️ Phiếu không khả dụng </small>
                </div>
              </div>
              <div class="coupon-modal-checkbox">
                <input
                  type="checkbox"
                  :checked="isCouponSelected(coupon.id)"
                  :disabled="!canApplyCoupon(coupon)"
                  @change="toggleCouponSelection(coupon)"
                />
              </div>
            </div>

            <div
              v-if="availableCoupons.length === 0"
              class="no-coupons-available"
            >
              <p>📝 Không có phiếu giảm giá nào khả dụng</p>
            </div>
          </div>

          <div class="modal-footer">
            <div class="selected-count">
              <span v-if="selectedCoupons.length > 0"> Đã chọn: 1 phiếu </span>
              <span v-else> Chưa chọn phiếu nào </span>
            </div>
            <div class="modal-actions">
              <button class="btn btn-outline" @click="closeCouponModal">
                Hủy
              </button>
              <button class="btn btn-primary" @click="confirmCouponSelection">
                {{ selectedCoupons.length > 0 ? "Xác nhận (1)" : "Xác nhận" }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { fetchCreateHoaDon } from "../../services/BanHang/HoaDonService";
import {
  fetchActivePhieuGiamGiaForCustomer,
  fetchAllPhieuGiamGia,
} from "../../services/GiamGia/PhieuGiamGiaService";
import {
  fetchAllKhachHang,
  fetchCreateKhachHang,
  fetchQuickAddKhachHang,
  fetchUpdateKhachHang,
} from "../../services/KhachHang/KhachHangService";
import { fetchAllChiTietSanPham } from "../../services/SanPham/ChiTietSanPhamService";
import { fetchAllChatLieu } from "../../services/ThuocTinh/ChatLieuService";
import { fetchAllDeGiay } from "../../services/ThuocTinh/DeGiayService";
import { fetchAllKichThuoc } from "../../services/ThuocTinh/KichThuocService";
import { fetchAllMauSac } from "../../services/ThuocTinh/MauSacService";
import { fetchAllNhaSanXuat } from "../../services/ThuocTinh/NhaSanXuatService";
import { fetchAllTrongLuong } from "../../services/ThuocTinh/TrongLuongService";
import { fetchAllXuatXu } from "../../services/ThuocTinh/XuatXuService";

// Data

const tempOrder = ref([
  {
    id: 1,
    tenDonHang: "Đơn hàng 1 - HD1",
    idKhachHang: null,
    idPhieuGiamGia: null, // Danh sách phiếu giảm giá đã chọn
    idNhanVien: null,
    idPhuongThucThanhToan: null,
    phuongThucThanhToan: null,
    tienKhachTra: 0,
    idTrangThaiDonHang: null,
    danhSachSanPham: [],
    phiVanChuyen: 0,
    tongTien: 0,
    tongTienSauGiam: 0,
    ghiChu: "",
    tenNguoiNhan: "",
    diaChiNhanHang: "",
    soDienThoaiNguoiNhan: "",
    emailNguoiNhan: "",
    ngayTao: new Date(),
    ngayThanhToan: new Date(),
    trangThai: true,
    deleted: false,
    createAt: new Date(),
    createBy: null,
  },
]);

const currentOrderId = ref(1);
const showProductSearch = ref(false);
const showCustomerSearch = ref(false);
const productSearchQuery = ref("");
const customerSearchQuery = ref("");
const customerDisplayName = ref(""); // Hiển thị tên khách hàng trong input
const customerSuggestions = ref([]); // Danh sách gợi ý khách hàng
const showCustomerDropdown = ref(false); // Hiển thị dropdown suggestions
let searchTimeout = null; // Timeout for debouncing search

// Add customer form in modal
const showAddCustomerForm = ref(false); // Hiển thị form thêm khách hàng
const newCustomerForm = ref({
  tenKhachHang: "",
  email: "",
  soDienThoai: "",
  gioiTinh: true,
  ngaySinh: "",
  tenTaiKhoan: "",
  matKhau: "",
  deleted: false,
  listDiaChi: [
    {
      diaChiCuThe: "",
      thanhPho: "",
      quan: "",
      phuong: "",
    },
  ],
});

// Delivery address form
const deliveryAddress = ref({
  tenNguoiNhan: "",
  soDienThoaiNguoiNhan: "",
  emailNguoiNhan: "",
  diaChiCuThe: "",
  thanhPho: "",
  quan: "",
  phuong: "",
});

// Filters
const selectedNhaSanXuat = ref("");
const selectedXuatXu = ref("");
const selectedChatLieu = ref("");

// Coupon/Voucher management
const availableCoupons = ref([]); // Danh sách phiếu giảm giá khả dụng
const selectedCoupons = ref([]); // Danh sách phiếu giảm giá đã chọn
const autoAppliedCoupon = ref(null); // Phiếu giảm giá được áp dụng tự động
const showCouponModal = ref(false); // Hiển thị modal chọn phiếu giảm giá

// Computed: Check if delivery address is complete
const isAddressComplete = computed(() => {
  return (
    deliveryAddress.value.tenNguoiNhan.trim() &&
    deliveryAddress.value.soDienThoaiNguoiNhan.trim() &&
    deliveryAddress.value.thanhPho.trim() &&
    deliveryAddress.value.quan.trim() &&
    deliveryAddress.value.phuong.trim() &&
    deliveryAddress.value.diaChiCuThe.trim()
  );
});

// Computed: Get current order
const currentOrder = computed(() => {
  return tempOrder.value.find(
    (tempOrder) => tempOrder.id === currentOrderId.value
  );
});

const selectedService = computed(() => {
  if (!currentOrder.value?.ghiChu) return null;
  return deliveryServices.value.find(
    (service) => service.code === currentOrder.value.ghiChu.split(" - ")[0]
  );
});

// Watcher: Sync selectedCoupons with currentOrder.selectedCoupons
watch(
  selectedCoupons,
  (newCoupons) => {
    if (currentOrder.value) {
      currentOrder.value.selectedCoupons = newCoupons;
    }
  },
  { deep: true }
);

// Watcher: Sync currentOrder changes to selectedCoupons
watch(
  currentOrder,
  (newOrder) => {
    if (newOrder && newOrder.selectedCoupons) {
      // Only update if different to avoid infinite loop
      if (
        JSON.stringify(selectedCoupons.value) !==
        JSON.stringify(newOrder.selectedCoupons)
      ) {
        selectedCoupons.value = [...newOrder.selectedCoupons];
      }
    }
  },
  { deep: true }
);

// Computed: Calculate discount amount for a coupon
const calculateCouponDiscount = (coupon) => {
  if (!currentOrder.value || !coupon) return 0;

  const orderTotal = currentOrder.value.tongTien || 0;

  if (coupon.loaiPhieuGiamGia === false) {
    // Percentage discount
    return Math.round((orderTotal * coupon.giaTriGiamGia) / 100);
  } else if (coupon.loaiPhieuGiamGia === true) {
    // Fixed amount discount
    return coupon.giaTriGiamGia;
  }

  return 0;
};

// Computed: Get full delivery address
const getFullAddress = computed(() => {
  if (!isAddressComplete.value) return "";

  return `${deliveryAddress.value.tenNguoiNhan} - ${deliveryAddress.value.soDienThoaiNguoiNhan}
${deliveryAddress.value.diaChiCuThe}, ${deliveryAddress.value.phuong}, ${deliveryAddress.value.quan}, ${deliveryAddress.value.thanhPho}`;
});

const selectedSize = ref("");
const selectedDeGiay = ref("");
const selectedMauSac = ref("");
const selectedKichThuoc = ref("");
const selectedPriceMax = ref(10000000);

const priceRange = ref({
  min: 100000,
  max: 10000000,
});

// Product images data
const showImageModal = ref(false);
const selectedImageIndex = ref(0);
const currentProductImages = ref([]);
const currentProductId = ref(null);

// Delivery services data
const deliveryServices = ref([
  {
    code: "ghn",
    name: "GHN",
    color: "#ff6b00",
    deliveryTime: "2-3 ngày",
    fee: 25000,
    description: "Giao Hàng Nhanh",
  },
  {
    code: "viettel",
    name: "Viettel Post",
    color: "#e60012",
    deliveryTime: "3-4 ngày",
    fee: 20000,
    description: "Viettel Post",
  },
  {
    code: "best",
    name: "Best Express",
    color: "#2e7d32",
    deliveryTime: "2-3 ngày",
    fee: 28000,
    description: "Best Express",
  },
  {
    code: "vnpost",
    name: "VietnamPost",
    color: "#1976d2",
    deliveryTime: "4-5 ngày",
    fee: 15000,
    description: "Bưu điện Việt Nam",
  },
]);

// Mock data
const ChiTietSanPhams = ref([]);
const KhachHangs = ref([]);
const PhieuGiamGias = ref([]);
const NhaSanXuats = ref([]);
const XuatXus = ref([]);
const ChatLieus = ref([]);
const DeGiays = ref([]);
const MauSacs = ref([]);
const KichThuocs = ref([]);
const TrongLuongs = ref([]);

const fetchNhaSanXuat = async () => {
  try {
    const response = await fetchAllNhaSanXuat();
    NhaSanXuats.value = response.data;
  } catch (error) {
    console.error("Error fetching nha san xuat:", error);
  }
};

const fetchXuatXu = async () => {
  try {
    const response = await fetchAllXuatXu();
    XuatXus.value = response.data;
  } catch (error) {
    console.error("Error fetching xuat xu:", error);
  }
};

const fetchChatLieu = async () => {
  try {
    const response = await fetchAllChatLieu();
    ChatLieus.value = response.data;
  } catch (error) {
    console.error("Error fetching chat lieu:", error);
  }
};

const fetchTrongLuong = async () => {
  try {
    const response = await fetchAllTrongLuong();
    TrongLuongs.value = response.data;
  } catch (error) {
    console.error("Error fetching trong luong:", error);
  }
};

const fetchDeGiay = async () => {
  try {
    const response = await fetchAllDeGiay();
    DeGiays.value = response.data;
  } catch (error) {
    console.error("Error fetching de giay:", error);
  }
};

const fetchMauSac = async () => {
  try {
    const response = await fetchAllMauSac();
    MauSacs.value = response.data;
  } catch (error) {
    console.error("Error fetching mau sac:", error);
  }
};

const fetchKichThuoc = async () => {
  try {
    const response = await fetchAllKichThuoc();
    KichThuocs.value = response.data;
  } catch (error) {
    console.error("Error fetching kich thuoc:", error);
  }
};

const fetchKhachHang = async () => {
  try {
    const response = await fetchAllKhachHang();
    KhachHangs.value = response.data;
  } catch (error) {
    console.error("Error fetching khach hang:", error);
  }
};

const fetchPhieuGiamGia = async () => {
  try {
    const response = await fetchAllPhieuGiamGia();
    // API trả về {data: {data: [...], message: "...", success: true}}
    const couponArray =
      response.data && response.data.data ? response.data.data : [];
    PhieuGiamGias.value = Array.isArray(couponArray) ? couponArray : [];
  } catch (error) {
    console.error("Error fetching phieu giam gia:", error);
  }
};

const fetchChiTietSanPham = async () => {
  try {
    const response = await fetchAllChiTietSanPham();
    ChiTietSanPhams.value = response.data;
    // Images are now included directly in the API response
  } catch (error) {
    console.error("Error fetching san pham:", error);
  }
};
const fetchAll = async () => {
  try {
    await fetchNhaSanXuat();
    await fetchXuatXu();
    await fetchChatLieu();
    await fetchTrongLuong();
    await fetchDeGiay();
    await fetchMauSac();
    await fetchKichThuoc();
    await fetchKhachHang();
    await fetchPhieuGiamGia();
    await fetchChiTietSanPham();
  } catch (error) {}
};
const fetchCreateOrderDetail = async (id) => {
  try {
    let res3 = await fetchActivePhieuGiamGiaForCustomer(id);
    PhieuGiamGias.value = res3.data;
  } catch (error) {}
};
const fetchCreateOrder = async () => {
  try {
    const order = currentOrder.value;
    if (!order) return;

    // Chuyển đổi danhSachSanPham từ array sang HashMap<Integer, Integer>
    const danhSachSanPhamMap = {};
    order.danhSachSanPham.forEach((item) => {
      danhSachSanPhamMap[item.id] = item.soLuong;
    });

    // Prepare delivery address information
    let tenNguoiNhan = order.tenNguoiNhan;
    let diaChiNhanHang = order.diaChiNhanHang;
    let soDienThoaiNguoiNhan = order.soDienThoaiNguoiNhan;
    let emailNguoiNhan = order.emailNguoiNhan;

    // If delivery is selected, use delivery address form data
    if (order.ghiChu === "delivery" && isAddressComplete.value) {
      tenNguoiNhan = deliveryAddress.value.tenNguoiNhan;
      soDienThoaiNguoiNhan = deliveryAddress.value.soDienThoaiNguoiNhan;
      emailNguoiNhan = deliveryAddress.value.emailNguoiNhan;
      diaChiNhanHang = `${deliveryAddress.value.diaChiCuThe}, ${deliveryAddress.value.phuong}, ${deliveryAddress.value.quan}, ${deliveryAddress.value.thanhPho}`;
    }

    // Tạo payload theo cấu trúc backend yêu cầu
    const payload = {
      idKhachHang: order.idKhachHang,
      idNhanVien: 1,
      idPhuongThucThanhToan: getPaymentMethodId(order.phuongThucThanhToan),
      idTrangThaiDonHang: 2,
      danhSachSanPham: danhSachSanPhamMap, // HashMap<Integer, Integer>
      phiVanChuyen: order.phiVanChuyen,
      tongTien: order.tongTien,
      tongTienSauGiam: order.tongTienSauGiam,
      ghiChu: order.selectedService
        ? `${order.ghiChu} - ${order.selectedService.name} (${order.selectedService.deliveryTime})`
        : order.ghiChu,
      tenNguoiNhan:
        tenNguoiNhan || order.tenNguoiNhan || customerDisplayName.value,
      diaChiNhanHang: diaChiNhanHang || order.diaChiNhanHang || "",
      soDienThoaiNguoiNhan:
        soDienThoaiNguoiNhan || order.soDienThoaiNguoiNhan || "",
      emailNguoiNhan: emailNguoiNhan || order.emailNguoiNhan || "",
      ngayTao: order.ngayTao ? order.ngayTao.toISOString().split("T")[0] : null,
      ngayThanhToan: order.ngayThanhToan
        ? order.ngayThanhToan.toISOString().split("T")[0]
        : null,
      trangThai: true,
      deleted: false,
      createAt: new Date(),
      createBy: 1,
    };

    // Chỉ thêm idPhieuGiamGia nếu có giá trị
    if (selectedCoupons.value && selectedCoupons.value.length > 0) {
      payload.idPhieuGiamGia = selectedCoupons.value[0].id;
    }

    // Validation cơ bản
    if (!payload.idKhachHang) {
      throw new Error("Thiếu thông tin khách hàng");
    }
    if (
      !payload.danhSachSanPham ||
      Object.keys(payload.danhSachSanPham).length === 0
    ) {
      throw new Error("Giỏ hàng trống");
    }

    console.log("payload: ", payload);
    await fetchCreateHoaDon(payload);
  } catch (error) {
    console.error("Error fetching create order:", error);
  }
};
// Computed

const filteredSearchProducts = computed(() => {
  let filtered = ChiTietSanPhams.value;
  return filtered.filter((product) => product.giaBan <= selectedPriceMax.value);
});

const filteredCustomers = computed(() => {
  if (!customerSearchQuery.value) return KhachHangs.value;

  return KhachHangs.value.filter(
    (customer) =>
      customer.tenKhachHang
        .toLowerCase()
        .includes(customerSearchQuery.value.toLowerCase()) ||
      customer.email
        .toLowerCase()
        .includes(customerSearchQuery.value.toLowerCase()) ||
      customer.soDienThoai.includes(customerSearchQuery.value)
  );
});

// Methods
const formatCurrency = (amount) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    minimumFractionDigits: 0,
  })
    .format(amount)
    .replace("₫", " VND");
};

const selectDeliveryService = (service) => {
  if (currentOrder.value) {
    // Set selected service info without overwriting delivery/pickup choice
    currentOrder.value.selectedService = service;
    updateOrderTotals();
  }
};

const createNewOrder = () => {
  const newId = Math.max(...tempOrder.value.map((o) => o.id)) + 1;
  const newOrder = {
    id: newId,
    tenDonHang: `Đơn hàng ${tempOrder.value.length + 1} - HD${newId}`,
    danhSachSanPham: [],
    idKhachHang: 0,
    idPhieuGiamGia: null, // Danh sách phiếu giảm giá đã chọn
    idNhanVien: 1,
    idPhuongThucThanhToan: 0,
    phuongThucThanhToan: null,
    tienKhachTra: 0,
    idTrangThaiDonHang: 0,
    phiVanChuyen: 0,
    tongTien: 0,
    tongTienSauGiam: 0,
    ghiChu: "pickup", // Default to pickup at store
    selectedCoupons: [], // Danh sách phiếu giảm giá đã chọn
    tenNguoiNhan: "",
    diaChiNhanHang: "",
    soDienThoaiNguoiNhan: "",
    emailNguoiNhan: "",
    ngayTao: new Date(),
    ngayThanhToan: thanhToan(0),
    trangThai: true,
    deleted: false,
    createAt: new Date(),
    createBy: 0,
    selectedService: null, // Initialize selected delivery service
  };

  tempOrder.value.push(newOrder);
  currentOrderId.value = newId;
};

const thanhToan = (idPhuongThucThanhToan = null) => {
  // Nếu không truyền tham số, lấy từ currentOrder
  const paymentMethod =
    idPhuongThucThanhToan !== null
      ? idPhuongThucThanhToan
      : currentOrder.value?.idPhuongThucThanhToan || 0;
  if (paymentMethod == 5) {
    return null;
  } else {
    return new Date();
  }
};

// Convert payment method string to backend ID
const getPaymentMethodId = (method) => {
  switch (method) {
    case "pay_now":
      return 1; // Thanh toán ngay
    case "bank_transfer":
      return 2; // Chuyển khoản
    case "cod":
      return 3; // Thanh toán khi nhận hàng
    default:
      return 1;
  }
};

const switchOrder = (orderId) => {
  currentOrderId.value = orderId;
};

const closeOrder = (orderId) => {
  if (tempOrder.value.length > 1) {
    const index = tempOrder.value.findIndex((o) => o.id === orderId);
    tempOrder.value.splice(index, 1);

    if (currentOrderId.value === orderId) {
      currentOrderId.value = tempOrder.value[0].id;
    }
  }
};

const addProductToCart = (product) => {
  const order = currentOrder.value;

  if (!order) {
    console.error("❌ No current order found!");
    return;
  }

  if (!order.danhSachSanPham) {
    order.danhSachSanPham = [];
  }

  // Chỉ kiểm tra ID sản phẩm để xác định trùng, không kiểm tra số lượng
  const existingItem = order.danhSachSanPham.find(
    (item) => item.id === product.id
  );

  if (existingItem) {
    // Nếu sản phẩm đã có trong giỏ hàng, tăng số lượng lên 1
    existingItem.soLuong += 1;
  } else {
    // Nếu sản phẩm chưa có, thêm mới vào giỏ hàng
    const newItem = {
      id: product.id,
      tenSanPham: product.tenSanPham,
      giaBan: product.giaBan,
      giaSauGiam:
        product.giaTriGiamGia && product.giaTriGiamGia > 0
          ? (product.giaBan / 100) * (100 - product.giaTriGiamGia)
          : product.giaBan,
      giaTriGiamGia: product.giaTriGiamGia,
      tenKichThuoc: product.tenKichThuoc,
      tenChatLieu: product.tenChatLieu,
      tenDeGiay: product.tenDeGiay,
      tenNhaSanXuat: product.tenNhaSanXuat,
      tenXuatXu: product.tenXuatXu,
      tenTrongLuong: product.tenTrongLuong,
      tenMauSac: product.tenMauSac,
      soLuong: 1,
      deleted: false,
      duongDanAnh:
        product.anhSanPham && product.anhSanPham.length > 0
          ? product.anhSanPham[0]
          : null,
      trangThai: product.trangThai,
      selected: false,
    };
    order.danhSachSanPham.push(newItem);
  }

  updateOrderTotals();

  // Tự động áp dụng phiếu giảm giá tốt nhất sau khi thêm sản phẩm
  setTimeout(() => {
    autoApplyBestCoupon();
  }, 100);

  showProductSearch.value = false;
};

const updateQuantity = (item, change) => {
  item.soLuong = Math.max(1, item.soLuong + change);
  updateOrderTotals();

  // Tự động áp dụng phiếu giảm giá tốt nhất sau khi thay đổi số lượng
  setTimeout(() => {
    autoApplyBestCoupon();
  }, 100);
};

const removeItem = (item) => {
  const order = currentOrder.value;
  const index = order.danhSachSanPham.findIndex((i) => i.id === item.id);
  if (index > -1) {
    order.danhSachSanPham.splice(index, 1);
    updateOrderTotals();

    // Tự động áp dụng phiếu giảm giá tốt nhất sau khi xóa sản phẩm
    setTimeout(() => {
      autoApplyBestCoupon();
    }, 100);
  }
};

const updateOrderTotals = () => {
  const order = currentOrder.value;
  if (!order) {
    console.error("❌ No order to update totals");
    return;
  }

  // Tính tiền hàng (subtotal) - sử dụng giá gốc để áp dụng phiếu giảm giá
  const tongTienGoc = order.danhSachSanPham.reduce(
    (sum, item) => sum + item.giaBan * item.soLuong,
    0
  );

  // Tính tiền hàng sau giảm giá sản phẩm (hiển thị)
  order.tongTien = order.danhSachSanPham.reduce(
    (sum, item) => sum + item.giaSauGiam * item.soLuong,
    0
  );

  // Calculate shipping fee based on delivery type and selected service
  if (order.ghiChu === "delivery" && order.selectedService) {
    order.phiVanChuyen = order.selectedService.fee || 0;

    // Miễn phí giao hàng nếu đơn hàng trên 3 triệu
    if (order.tongTien >= 3000000) {
      order.phiVanChuyen = 0;
    }
  } else {
    order.phiVanChuyen = 0;
  }

  // Tính giảm giá từ các phiếu đã chọn (áp dụng lên tổng tiền sau giảm sản phẩm)
  let totalDiscount = 0;
  if (selectedCoupons.value && selectedCoupons.value.length > 0) {
    selectedCoupons.value.forEach((coupon) => {
      if (coupon.loaiPhieuGiamGia === false) {
        // loaiPhieuGiamGia = false: Giảm theo phần trăm trên tổng tiền đã giảm sản phẩm
        const discountAmount = (order.tongTien * coupon.giaTriGiamGia) / 100;
        totalDiscount += discountAmount;
      } else if (coupon.loaiPhieuGiamGia === true) {
        // loaiPhieuGiamGia = true: Giảm số tiền cố định
        totalDiscount += coupon.giaTriGiamGia;
      }
    });
  }

  // Đảm bảo giảm giá không vượt quá tổng tiền
  const finalDiscount = Math.min(totalDiscount, order.tongTien);

  // Force update discount to ensure reactivity
  order.discount = finalDiscount;

  // Tính tổng tiền sau giảm
  order.tongTienSauGiam = order.tongTien - finalDiscount + order.phiVanChuyen;
};

// Function tự động áp dụng phiếu giảm giá tốt nhất
const autoApplyBestCoupon = () => {
  const order = currentOrder.value;
  if (
    !order ||
    !availableCoupons.value ||
    availableCoupons.value.length === 0
  ) {
    return;
  }

  // Đảm bảo availableCoupons.value là mảng trước khi lọc
  const couponsArray = Array.isArray(availableCoupons.value)
    ? availableCoupons.value
    : [];
  // Lọc các phiếu giảm giá hợp lệ
  const validCoupons = couponsArray.filter((coupon) => {
    // Kiểm tra trạng thái active
    if (coupon.trangThai !== true) return false;

    // Kiểm tra giá trị đơn hàng tối thiểu
    if (coupon.donHangToiThieu && order.tongTien < coupon.donHangToiThieu) {
      return false;
    }

    // Kiểm tra có phải là khách hàng cụ thể không (nếu có)
    if (
      coupon.idKhachHang &&
      order.idKhachHang &&
      coupon.idKhachHang !== order.idKhachHang
    ) {
      return false;
    }

    return true;
  });

  if (validCoupons.length === 0) {
    return;
  }

  // Tính toán lợi ích của từng phiếu
  const couponBenefits = validCoupons.map((coupon) => {
    let discountAmount = 0;
    if (coupon.loaiPhieuGiamGia === false) {
      // Giảm theo phần trăm
      discountAmount = (order.tongTien * coupon.giaTriGiamGia) / 100;
    } else if (coupon.loaiPhieuGiamGia === true) {
      // Giảm số tiền cố định
      discountAmount = coupon.giaTriGiamGia;
    }

    // Đảm bảo giảm giá không vượt quá tổng tiền
    discountAmount = Math.min(discountAmount, order.tongTien);

    return {
      coupon,
      discountAmount,
      benefit: discountAmount, // Lợi ích = số tiền giảm
    };
  });

  // Sắp xếp theo lợi ích giảm dần và chọn phiếu tốt nhất
  couponBenefits.sort((a, b) => b.benefit - a.benefit);
  const bestCoupon = couponBenefits[0]?.coupon;

  if (bestCoupon) {
    // Áp dụng phiếu giảm giá tốt nhất
    selectedCoupons.value = [bestCoupon];
    autoAppliedCoupon.value = bestCoupon; // Đánh dấu phiếu được áp dụng tự động
    console.log(
      `🎫 Tự động áp dụng phiếu giảm giá tốt nhất: ${
        bestCoupon.tenPhieuGiamGia
      } (giảm ${couponBenefits[0].discountAmount.toLocaleString()}đ)`
    );

    // Cập nhật lại tổng tiền
    updateOrderTotals();
  } else {
    // Không có phiếu phù hợp, reset auto applied coupon
    autoAppliedCoupon.value = null;
  }
};

const applyCoupon = (voucher) => {
  // Apply coupon logic
  if (currentOrder.value) {
    currentOrder.value.idPhieuGiamGia = voucher.id;
  }
};

// Load all coupons from API
const loadAllCoupons = async () => {
  try {
    console.log("Đang load phiếu giảm giá...");
    const coupons = await fetchAllPhieuGiamGia();
    console.log("Dữ liệu phiếu giảm giá nhận được:", coupons);
    // Đảm bảo luôn là mảng - API trả về {data: {data: [...], message: "...", success: true}}
    const couponArray =
      coupons.data && coupons.data.data ? coupons.data.data : [];
    availableCoupons.value = Array.isArray(couponArray) ? couponArray : [];
    console.log(
      "Đã load được",
      availableCoupons.value.length,
      "phiếu giảm giá"
    );
  } catch (error) {
    console.error("Error loading all coupons:", error);
    availableCoupons.value = [];
  }
};

// Load available coupons for customer (filter from all coupons)
const loadAvailableCoupons = async (customerId) => {
  try {
    if (customerId && customerId > 0) {
      // Filter coupons that are active and available for this customer
      const couponsArray = Array.isArray(availableCoupons.value)
        ? availableCoupons.value
        : [];
      const customerCoupons = couponsArray.filter((coupon) => {
        // You can add more filtering logic here based on customer eligibility
        return coupon.trangThai === true; // Assuming 'trangThai' indicates active status
      });
      // For now, just return all available coupons (you can customize filtering later)
      return customerCoupons;
    } else {
      return [];
    }
  } catch (error) {
    console.error("Error filtering available coupons:", error);
    return [];
  }
};

const selectCustomer = async (customer) => {
  if (currentOrder.value) {
    // Check if this is a "create new customer" option
    if (customer.isCreateNew) {
      await createNewCustomer(
        customer.tenKhachHang
          .replace('➕ Tạo khách hàng mới: "', "")
          .replace('"', "")
      );
      return;
    }

    currentOrder.value.idKhachHang = customer.id;
    customerDisplayName.value = customer.tenKhachHang;

    // Populate delivery address and order info from customer
    if (customer.listDiaChi && customer.listDiaChi.length > 0) {
      const customerAddress = customer.listDiaChi[0]; // Use first address
      deliveryAddress.value = {
        tenNguoiNhan: customer.tenKhachHang,
        soDienThoaiNguoiNhan: customer.soDienThoai || "",
        emailNguoiNhan: customer.email || "",
        diaChiCuThe: customerAddress.diaChiCuThe || "",
        thanhPho: customerAddress.thanhPho || "",
        quan: customerAddress.quan || "",
        phuong: customerAddress.phuong || "",
      };

      // Also update order with customer info
      currentOrder.value.tenNguoiNhan = customer.tenKhachHang;
      currentOrder.value.soDienThoaiNguoiNhan = customer.soDienThoai || "";
      currentOrder.value.emailNguoiNhan = customer.email || "";
      currentOrder.value.diaChiNhanHang = customerAddress.diaChiCuThe || "";
    } else {
      // Clear address if customer doesn't have one
      deliveryAddress.value = {
        tenNguoiNhan: customer.tenKhachHang,
        soDienThoaiNguoiNhan: customer.soDienThoai || "",
        emailNguoiNhan: customer.email || "",
        diaChiCuThe: "",
        thanhPho: "",
        quan: "",
        phuong: "",
      };

      // Update order with basic customer info
      currentOrder.value.tenNguoiNhan = customer.tenKhachHang;
      currentOrder.value.soDienThoaiNguoiNhan = customer.soDienThoai || "";
      currentOrder.value.emailNguoiNhan = customer.email || "";
      currentOrder.value.diaChiNhanHang = "";
    }

    // If customer doesn't have address but delivery address is provided, update customer with address
    if (
      (!customer.listDiaChi || customer.listDiaChi.length === 0) &&
      deliveryAddress.value.diaChiCuThe &&
      deliveryAddress.value.diaChiCuThe.trim() !== ""
    ) {
      try {
        console.log(
          `Cập nhật địa chỉ cho khách hàng: ${customer.tenKhachHang}`
        );

        const updatedCustomerData = {
          ...customer,
          email: deliveryAddress.value.emailNguoiNhan || customer.email || "",
          soDienThoai:
            deliveryAddress.value.soDienThoaiNguoiNhan ||
            customer.soDienThoai ||
            "",
          listDiaChi: [
            {
              diaChiCuThe: deliveryAddress.value.diaChiCuThe,
              thanhPho: deliveryAddress.value.thanhPho,
              quan: deliveryAddress.value.quan,
              phuong: deliveryAddress.value.phuong,
            },
          ],
        };

        await fetchUpdateKhachHang(customer.id, updatedCustomerData);

        // Reload customer list to get updated data
        await fetchKhachHang();

        console.log(
          `Đã cập nhật địa chỉ cho khách hàng: ${customer.tenKhachHang}`
        );
      } catch (error) {
        console.error("Error updating customer address:", error);
        // Continue with order creation even if address update fails
      }
    }

    await fetchCreateOrderDetail(customer.id);

    // Note: Coupons are already loaded globally, no need to load per customer
  }
  showCustomerSearch.value = false;
  showCustomerDropdown.value = false;
  customerSuggestions.value = [];
};

// Create new customer
const createNewCustomer = async (customerName) => {
  try {
    // Show loading state
    console.log(`Đang tạo khách hàng mới: ${customerName}`);

    // Prepare customer data with delivery address info if available
    const newCustomerData = {
      tenKhachHang: customerName,
      email: deliveryAddress.value.emailNguoiNhan || "",
      soDienThoai: deliveryAddress.value.soDienThoaiNguoiNhan || "",
      gioiTinh: true, // Default to male
      ngaySinh: null,
      diaChi: deliveryAddress.value.diaChiCuThe || "",
      trangThai: true,
      deleted: false,
      // Include address details if available
      listDiaChi: deliveryAddress.value.diaChiCuThe
        ? [
            {
              diaChiCuThe: deliveryAddress.value.diaChiCuThe,
              thanhPho: deliveryAddress.value.thanhPho,
              quan: deliveryAddress.value.quan,
              phuong: deliveryAddress.value.phuong,
            },
          ]
        : [],
    };

    // Call API to create customer
    await fetchQuickAddKhachHang(newCustomerData);

    // Reload customer list
    await fetchKhachHang();

    // Find the newly created customer (assume it's the last one or by name)
    const newCustomer = KhachHangs.value.find(
      (c) => c.tenKhachHang === customerName
    );

    if (newCustomer) {
      console.log(
        `Đã tạo khách hàng mới thành công: ${newCustomer.tenKhachHang}`
      );
      // Update current order with new customer info
      currentOrder.value.tenNguoiNhan = newCustomer.tenKhachHang;
      currentOrder.value.soDienThoaiNguoiNhan = newCustomer.soDienThoai || "";
      currentOrder.value.emailNguoiNhan = newCustomer.email || "";
      currentOrder.value.diaChiNhanHang = newCustomer.diaChi || "";
      // Auto-select the new customer
      await selectCustomer(newCustomer);
    } else {
      console.error("Không tìm thấy khách hàng vừa tạo");
      // Fallback: update with delivery address info if available
      currentOrder.value.tenNguoiNhan = customerName;
      currentOrder.value.soDienThoaiNguoiNhan =
        deliveryAddress.value.soDienThoaiNguoiNhan || "";
      currentOrder.value.emailNguoiNhan =
        deliveryAddress.value.emailNguoiNhan || "";
      currentOrder.value.diaChiNhanHang =
        deliveryAddress.value.diaChiCuThe || "";
      customerDisplayName.value = customerName;
      alert("Đã tạo khách hàng mới thành công! Thông tin địa chỉ đã được lưu.");
    }
  } catch (error) {
    console.error("Error creating new customer:", error);
    alert("Có lỗi xảy ra khi tạo khách hàng mới. Vui lòng thử lại.");
  }
};

// Select customer from input suggestions
const selectCustomerFromSuggestions = async (customer) => {
  await selectCustomer(customer);
};

// Coupon/Voucher management functions
const toggleCouponSelection = (coupon) => {
  if (!currentOrder.value) return;

  const index = selectedCoupons.value.findIndex((c) => c.id === coupon.id);
  if (index > -1) {
    // Remove coupon if already selected
    selectedCoupons.value.splice(index, 1);
  } else {
    // Check if can apply coupon
    if (!canApplyCoupon(coupon)) return;

    // Replace current coupon with new one (only allow one coupon at a time)
    selectedCoupons.value = [coupon]; // Replace with new coupon

    // Reset auto applied coupon khi người dùng chọn thủ công
    autoAppliedCoupon.value = null;
  }

  // Update current order's selected coupons (deprecated - using selectedCoupons.value directly)
  // currentOrder.value.selectedCoupons = selectedCoupons.value;

  // Recalculate totals
  updateOrderTotals();
};

const canApplyCoupon = (coupon) => {
  if (!currentOrder.value || !coupon) return false;

  const orderTotal = currentOrder.value.tongTien || 0;

  // Check minimum order value
  if (coupon.donHangToiThieu && orderTotal < coupon.donHangToiThieu) {
    return false;
  }

  // Check if coupon is already selected
  const isAlreadySelected = selectedCoupons.value.some(
    (c) => c.id === coupon.id
  );
  if (isAlreadySelected) return false;

  // Only allow one coupon at a time
  if (selectedCoupons.value.length > 0) {
    return false;
  }

  // Check if coupon is active (assuming trangThai indicates active status)
  if (coupon.trangThai !== true) {
    return false;
  }

  return true;
};

const removeSelectedCoupon = (couponId) => {
  const index = selectedCoupons.value.findIndex((c) => c.id === couponId);
  if (index > -1) {
    selectedCoupons.value.splice(index, 1);
    // currentOrder.value.selectedCoupons = selectedCoupons.value; // deprecated

    // Reset auto applied coupon nếu xóa phiếu tự động
    if (autoAppliedCoupon.value && autoAppliedCoupon.value.id === couponId) {
      autoAppliedCoupon.value = null;
    }

    updateOrderTotals();

    // Tự động áp dụng phiếu khác nếu có sau khi xóa
    setTimeout(() => {
      autoApplyBestCoupon();
    }, 100);
  }
};

const isCouponSelected = (couponId) => {
  return selectedCoupons.value.some((c) => c.id === couponId);
};

const clearAllSelectedCoupons = () => {
  selectedCoupons.value = [];
  if (currentOrder.value) {
    // currentOrder.value.selectedCoupons = []; // deprecated
    updateOrderTotals();
  }
};

// Modal functions
const openCouponModal = () => {
  if (availableCoupons.value.length > 0) {
    showCouponModal.value = true;
  }
};

const closeCouponModal = () => {
  showCouponModal.value = false;
};

const confirmCouponSelection = () => {
  // Update current order with selected coupons
  if (currentOrder.value) {
    // currentOrder.value.selectedCoupons = selectedCoupons.value; // deprecated
    updateOrderTotals();
  }
  showCouponModal.value = false;
};

// Search customers as user types (optimized for real-time)
const searchCustomers = () => {
  const query = customerDisplayName.value.trim();

  // Clear previous timeout
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }

  if (query.length < 1) {
    customerSuggestions.value = [];
    showCustomerDropdown.value = false;
    return;
  }

  // Immediate search for better UX
  searchTimeout = setTimeout(async () => {
    try {
      // Filter existing customers - search by name and email with lowercase
      const filteredCustomers = KhachHangs.value.filter((customer) => {
        const nameMatch = customer.tenKhachHang
          .toLowerCase()
          .includes(query.toLowerCase());
        const emailMatch =
          customer.email &&
          customer.email.toLowerCase().includes(query.toLowerCase());
        const phoneMatch =
          customer.soDienThoai && customer.soDienThoai.includes(query);

        return nameMatch || emailMatch || phoneMatch;
      });

      // Always show dropdown when there is a query
      showCustomerDropdown.value = query.length > 0;

      if (filteredCustomers.length > 0) {
        // Show existing customers (limit to 4 to leave space for "create new")
        customerSuggestions.value = filteredCustomers.slice(0, 4);
        // Add "Create new customer" option if not already in suggestions
        const createNewOption = {
          id: "create_new",
          tenKhachHang: `➕ Tạo khách hàng mới: "${query}"`,
          email: "",
          soDienThoai: "",
          isCreateNew: true,
        };
        customerSuggestions.value.push(createNewOption);
      } else {
        // No existing customers found, show only "create new" option
        customerSuggestions.value = [
          {
            id: "create_new",
            tenKhachHang: `➕ Tạo khách hàng mới: "${query}"`,
            email: "",
            soDienThoai: "",
            isCreateNew: true,
          },
        ];
      }
    } catch (error) {
      console.error("Error searching customers:", error);
      customerSuggestions.value = [];
      showCustomerDropdown.value = false;
    }
  }, 150);
};

const confirmOrder = async () => {
  const order = currentOrder.value;
  if (!order) {
    alert("Không tìm thấy đơn hàng hiện tại");
    return;
  }

  if (!order.danhSachSanPham || order.danhSachSanPham.length === 0) {
    alert("Vui lòng thêm sản phẩm vào đơn hàng");
    return;
  }

  if (!customerDisplayName.value.trim()) {
    alert("Vui lòng nhập thông tin khách hàng");
    return;
  }

  if (!order.phuongThucThanhToan) {
    alert("Vui lòng chọn phương thức thanh toán");
    return;
  }

  // Check if customer exists, if not create new one
  let customerId = order.idKhachHang;
  const customerName = customerDisplayName.value.trim();

  if (!customerId) {
    // Try to find customer by name or email (use includes for better matching)
    const existingCustomer = KhachHangs.value.find((customer) => {
      const nameMatch = customer.tenKhachHang
        .toLowerCase()
        .includes(customerName.toLowerCase());
      const emailMatch =
        customer.email &&
        customer.email.toLowerCase().includes(customerName.toLowerCase());

      return nameMatch || emailMatch;
    });

    if (existingCustomer) {
      customerId = existingCustomer.id;
      order.idKhachHang = customerId;
    } else {
      // Create new customer - match structure from KhachHang.vue
      try {
        const newCustomer = {
          id: Date.now(), // Temporary ID
          tenKhachHang: customerName,
          email: "",
          soDienThoai: "",
          gioiTinh: true, // Default to Nam (true)
          ngaySinh: "",
          tenTaiKhoan: "", // Empty for now
          matKhau: "", // Empty for now
          deleted: false,
          listDiaChi: [
            {
              diaChiCuThe: "",
              thanhPho: "",
              quan: "",
              phuong: "",
            },
          ],
        };

        // Add to local list
        KhachHangs.value.push(newCustomer);
        customerId = newCustomer.id;
        order.idKhachHang = customerId;
      } catch (error) {
        console.error("Error creating new customer:", error);
        alert("Có lỗi khi tạo khách hàng mới");
        return;
      }
    }
  }

  // Validation cho giao hàng tận nơi
  if (order.ghiChu === "delivery") {
    if (!isAddressComplete.value) {
      alert("Vui lòng nhập đầy đủ thông tin địa chỉ giao hàng");
      return;
    }
  }

  // Validation cho từng phương thức thanh toán
  if (order.phuongThucThanhToan === "pay_now") {
    if (!order.tienKhachTra || order.tienKhachTra < 0) {
      alert("Vui lòng nhập số tiền khách trả");
      return;
    }
    if (order.tienKhachTra < order.tongTienSauGiam) {
      alert(
        "Số tiền khách trả không đủ. Vui lòng thanh toán đủ hoặc chọn phương thức khác."
      );
      return;
    }
  }

  await fetchCreateOrder();
  await fetchAll();

  alert("Đơn hàng đã được tạo thành công!");

  // Reset current order
  if (order) {
    order.danhSachSanPham = [];
    order.idKhachHang = null;
    // order.selectedCoupons = []; // Reset selected coupons - deprecated
    order.idNhanVien = 1;
    order.idPhuongThucThanhToan = 0;
    order.phuongThucThanhToan = null;
    order.tienKhachTra = 0;
    order.ghiChu = "pickup"; // Reset to default pickup
    order.phiVanChuyen = 0;
    order.tongTien = 0;
    order.tongTienSauGiam = 0;
    order.tenNguoiNhan = "";
    order.diaChiNhanHang = "";
    order.soDienThoaiNguoiNhan = "";
    order.emailNguoiNhan = "";
    order.ngayTao = new Date();
    order.selectedService = null; // Reset selected delivery service

    // Reset delivery address
    deliveryAddress.value = {
      tenNguoiNhan: "",
      soDienThoaiNguoiNhan: "",
      emailNguoiNhan: "",
      diaChiCuThe: "",
      thanhPho: "",
      quan: "",
      phuong: "",
    };
    order.ngayThanhToan = thanhToan(order.idPhuongThucThanhToan || 0);
    order.trangThai = true;
    order.deleted = false;
    order.createAt = new Date();
    order.createBy = 0;
    updateOrderTotals();
  }

  // Reset customer display
  customerDisplayName.value = "";
  customerSuggestions.value = [];
  showCustomerDropdown.value = false;
  // Clear search timeout
  if (searchTimeout) {
    clearTimeout(searchTimeout);
    searchTimeout = null;
  }
};

// Close customer dropdown when clicking outside
const closeCustomerDropdown = () => {
  showCustomerDropdown.value = false;
  customerSuggestions.value = [];
  // Clear search timeout
  if (searchTimeout) {
    clearTimeout(searchTimeout);
    searchTimeout = null;
  }
};

// Clear customer input
const clearCustomerInput = () => {
  customerDisplayName.value = "";
  customerSuggestions.value = [];
  showCustomerDropdown.value = false;
  // Clear search timeout
  if (searchTimeout) {
    clearTimeout(searchTimeout);
    searchTimeout = null;
  }
  // Also clear customer selection and delivery address
  if (currentOrder.value) {
    currentOrder.value.idKhachHang = null;
  }
  // Clear delivery address
  deliveryAddress.value = {
    tenNguoiNhan: "",
    soDienThoaiNguoiNhan: "",
    emailNguoiNhan: "",
    diaChiCuThe: "",
    thanhPho: "",
    quan: "",
    phuong: "",
  };
};

// Open add customer form
const openAddCustomerForm = () => {
  showAddCustomerForm.value = true;
  // Reset form
  resetNewCustomerForm();
};

// Cancel add customer
const cancelAddCustomer = () => {
  showAddCustomerForm.value = false;
  resetNewCustomerForm();
};

// Save new customer
const saveNewCustomer = async () => {
  try {
    // Validate required fields
    if (!newCustomerForm.value.tenKhachHang.trim()) {
      alert("Vui lòng nhập họ và tên");
      return;
    }
    if (!newCustomerForm.value.email.trim()) {
      alert("Vui lòng nhập email");
      return;
    }
    if (!newCustomerForm.value.soDienThoai.trim()) {
      alert("Vui lòng nhập số điện thoại");
      return;
    }
    if (!newCustomerForm.value.tenTaiKhoan.trim()) {
      alert("Vui lòng nhập tên tài khoản");
      return;
    }
    if (!newCustomerForm.value.matKhau.trim()) {
      alert("Vui lòng nhập mật khẩu");
      return;
    }

    // Add temporary ID for local use
    const customerToAdd = {
      ...newCustomerForm.value,
      id: Date.now(),
      trangThai: true,
    };

    // Add to local list
    KhachHangs.value.push(customerToAdd);

    // Close form and show success message
    showAddCustomerForm.value = false;
    alert("Thêm khách hàng thành công!");

    // Reset form
    resetNewCustomerForm();
  } catch (error) {
    console.error("Error saving customer:", error);
    alert("Có lỗi xảy ra khi thêm khách hàng");
  }
};

// Reset new customer form
const resetNewCustomerForm = () => {
  newCustomerForm.value = {
    tenKhachHang: "",
    email: "",
    soDienThoai: "",
    gioiTinh: true,
    ngaySinh: "",
    tenTaiKhoan: "",
    matKhau: "",
    deleted: false,
    listDiaChi: [
      {
        diaChiCuThe: "",
        thanhPho: "",
        quan: "",
        phuong: "",
      },
    ],
  };
};

onMounted(async () => {
  fetchAll();

  // Load all coupons from API
  await loadAllCoupons();

  // Tạo đơn hàng đầu tiên nếu chưa có
  if (tempOrder.value.length === 0) {
    createNewOrder();
  }
  updateOrderTotals();

  // Add click outside listener for customer dropdown
  document.addEventListener("click", (event) => {
    const customerInput = event.target.closest(".customer-input-container");
    if (!customerInput) {
      closeCustomerDropdown();
    }
  });
});

// Base URL for images
const IMAGE_BASE_URL = "http://localhost:8080/";

// Images are now loaded directly from the product API response

// Methods for image modal
const openImageModal = (productId) => {
  const product = ChiTietSanPhams.value.find((p) => p.id === productId);

  if (product && product.anhSanPham && product.anhSanPham.length > 0) {
    currentProductImages.value = product.anhSanPham.map((imageUrl, index) => ({
      id: `image-${index}`,
      duongDanAnh: imageUrl.startsWith("http")
        ? imageUrl
        : IMAGE_BASE_URL + imageUrl,
      tenSanPham: product.tenSanPham,
    }));
    currentProductId.value = productId;
    selectedImageIndex.value = 0;
    showImageModal.value = true;
  }
};

const closeImageModal = () => {
  showImageModal.value = false;
  currentProductImages.value = [];
  currentProductId.value = null;
  selectedImageIndex.value = 0;
};

const nextImage = () => {
  selectedImageIndex.value =
    (selectedImageIndex.value + 1) % currentProductImages.value.length;
};

const prevImage = () => {
  selectedImageIndex.value =
    selectedImageIndex.value === 0
      ? currentProductImages.value.length - 1
      : selectedImageIndex.value - 1;
};

const selectImage = (index) => {
  selectedImageIndex.value = index;
};

// Handle image loading errors
const handleImageError = (event) => {
  event.target.src = "/placeholder-image.png";
};

// Component cleanup is no longer needed
</script>

<style scoped>
.pos-system {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0;
  animation: fadeIn 0.5s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Modern Header */
/* pos-header now uses global page-header styling */

/* header-content, page-title, page-subtitle, header-actions now use global CSS */

/* Modern buttons now use global btn-export styling */

/* btn-icon now uses global CSS */

/* Modern Order Tabs */
.modern-tabs-container {
  margin-bottom: 2rem;
  padding: 0.5rem;
  background: linear-gradient(135deg, #f8fafc, #f1f5f9);
  border-radius: 16px;
  border: 1px solid #e2e8f0;
}

.order-tabs {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.modern-tab {
  position: relative;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 12px;
  overflow: hidden;
}

.tab-content {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.25rem;
  background: white;
  border: 2px solid transparent;
  border-radius: 12px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.modern-tab:hover .tab-content {
  background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
  border-color: #0ea5e9;
  transform: translateY(-1px);
}

.modern-tab.active .tab-content {
  background: linear-gradient(135deg, #4ade80, #22c55e);
  color: white;
  border-color: #4ade80;
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
}

.tab-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
  border-radius: 8px;
  transition: all 0.3s ease;
}

.modern-tab.active .tab-icon {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

.tab-text {
  font-size: 0.875rem;
  font-weight: 600;
  color: #374151;
  transition: color 0.3s ease;
}

.modern-tab.active .tab-text {
  color: white;
}

.tab-indicator {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, #4ade80, #22c55e);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.modern-tab.active .tab-indicator {
  transform: scaleX(1);
}

.modern-close-btn {
  position: absolute;
  top: 0.25rem;
  right: 0.25rem;
  width: 24px;
  height: 24px;
  background: rgba(0, 0, 0, 0.1);
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  opacity: 0;
}

.modern-tab:hover .modern-close-btn {
  opacity: 1;
}

.modern-close-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: scale(1.1);
}

.add-tab-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  background: linear-gradient(135deg, #4ade80, #22c55e);
  color: white;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(74, 222, 128, 0.3);
  margin-left: 0.5rem;
}

.add-tab-btn:hover {
  background: linear-gradient(135deg, #22c55e, #16a34a);
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.4);
}

/* POS Content */
.pos-content {
  display: grid;
  grid-template-columns: 1.8fr 1fr;
  gap: 2rem;
  min-height: calc(100vh - 280px);
  max-height: calc(100vh - 280px);
}

/* Modern Product Section */
.modern-product-section {
  background: linear-gradient(145deg, #ffffff, #f8fafc);
  border-radius: 20px;
  padding: 0;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.8);
  display: flex;
  flex-direction: column;
  height: 100%;
  overflow: hidden;
  position: relative;
  transition: all 0.3s ease;
}

.modern-product-section:hover {
  transform: translateY(-2px);
  box-shadow: 0 16px 48px rgba(0, 0, 0, 0.15);
}

.modern-section-header {
  padding: 1.5rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(
    135deg,
    rgba(74, 222, 128, 0.03),
    rgba(34, 197, 94, 0.03)
  );
  border-bottom: 1px solid rgba(74, 222, 128, 0.1);
  position: relative;
}

.header-title-group {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.section-icon {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #4ade80, #22c55e);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
  transition: all 0.3s ease;
}

.section-icon.customer {
  background: linear-gradient(135deg, #4ade80, #16a34a);
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
}

.section-icon:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 20px rgba(74, 222, 128, 0.4);
}

.section-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0 0 0.25rem 0;
  letter-spacing: -0.025em;
}

.section-subtitle {
  font-size: 0.875rem;
  color: #64748b;
  margin: 0;
  font-weight: 500;
}

.section-actions {
  display: flex;
  gap: 0.75rem;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1rem;
  border-radius: 12px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
  position: relative;
  overflow: hidden;
}

.action-btn::before {
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
  transition: left 0.6s ease;
}

.action-btn:hover::before {
  left: 100%;
}

.action-btn.primary {
  background: linear-gradient(135deg, #4ade80, #22c55e);
  color: white;
  box-shadow: 0 2px 8px rgba(74, 222, 128, 0.3);
}

.action-btn.primary:hover {
  background: linear-gradient(135deg, #22c55e, #16a34a);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.4);
}

.action-btn.secondary {
  background: rgba(71, 85, 105, 0.1);
  color: #475569;
  border-color: rgba(71, 85, 105, 0.2);
}

.action-btn.secondary:hover {
  background: rgba(71, 85, 105, 0.2);
  border-color: rgba(71, 85, 105, 0.3);
  transform: translateY(-2px);
}

/* Modern Cart Items */
.modern-cart-items {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.modern-cart-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.25rem;
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.9),
    rgba(248, 250, 252, 0.9)
  );
  border: 2px solid rgba(226, 232, 240, 0.8);
  border-radius: 16px;
  transition: all 0.3s ease;
  animation: slideInUp 0.3s ease;
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modern-cart-item:hover {
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 1),
    rgba(248, 250, 252, 1)
  );
  border-color: rgba(74, 222, 128, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.discount-badge {
  position: absolute;
  top: -8px;
  left: 60px;
  background: linear-gradient(135deg, #ef4444, #dc2626);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
  z-index: 10;
}

.discount-text {
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.modern-checkbox {
  position: relative;
  cursor: pointer;
  display: block;
  width: 24px;
  height: 24px;
}

.modern-checkbox input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}

.checkmark {
  position: absolute;
  top: 0;
  left: 0;
  height: 24px;
  width: 24px;
  background: linear-gradient(135deg, #f8fafc, #e2e8f0);
  border: 2px solid #e2e8f0;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.checkmark::after {
  content: "";
  position: absolute;
  display: none;
  left: 7px;
  top: 3px;
  width: 6px;
  height: 10px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.modern-checkbox input:checked ~ .checkmark {
  background: linear-gradient(135deg, #4ade80, #22c55e);
  border-color: #4ade80;
  box-shadow: 0 2px 8px rgba(74, 222, 128, 0.3);
}

.modern-checkbox input:checked ~ .checkmark::after {
  display: block;
}

.image-container {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  overflow: hidden;
  background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.image-container:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.placeholder-image {
  color: #94a3b8;
  transition: color 0.3s ease;
}

.modern-cart-item:hover .placeholder-image {
  color: #4ade80;
}

.item-details {
  flex: 1;
  min-width: 0;
}

.item-header {
  margin-bottom: 0.5rem;
}

.item-name {
  font-size: 0.875rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 0.25rem 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.item-meta {
  display: flex;
  gap: 0.75rem;
  font-size: 0.75rem;
  color: #64748b;
}

.item-size {
  background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
  padding: 0.125rem 0.5rem;
  border-radius: 6px;
  font-weight: 500;
}

.item-pricing {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.original-price {
  text-decoration: line-through;
  color: red !important;
  font-size: 0.875rem;
  font-weight: 500;
}

.current-price {
  color: #059669;
  font-size: 1rem;
  font-weight: 700;
}

.item-controls {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  flex-shrink: 0;
}

.quantity-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.quantity-controls {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #f8fafc, #f1f5f9);
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  padding: 0.25rem;
  gap: 0.25rem;
}

.modern-qty-btn {
  width: 32px;
  height: 32px;
  border: none;
  background: white;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  color: #64748b;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.modern-qty-btn:hover {
  background: linear-gradient(135deg, #4ade80, #22c55e);
  color: white;
  transform: scale(1.1);
}

.modern-qty-btn.minus:hover {
  background: linear-gradient(135deg, #ef4444, #dc2626);
}

.quantity-display {
  min-width: 32px;
  text-align: center;
  font-weight: 700;
  color: #1e293b;
  font-size: 1rem;
}

.item-total {
  font-size: 0.875rem;
  font-weight: 700;
  color: #059669;
  text-align: center;
  background: linear-gradient(
    135deg,
    rgba(5, 150, 105, 0.1),
    rgba(16, 185, 129, 0.1)
  );
  padding: 0.25rem 0.75rem;
  border-radius: 8px;
  border: 1px solid rgba(5, 150, 105, 0.2);
}

.modern-remove-btn {
  width: 36px;
  height: 36px;
  background: linear-gradient(
    135deg,
    rgba(239, 68, 68, 0.1),
    rgba(220, 38, 38, 0.1)
  );
  border: 2px solid rgba(239, 68, 68, 0.2);
  color: #ef4444;
  border-radius: 10px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.modern-remove-btn:hover {
  background: linear-gradient(135deg, #ef4444, #dc2626);
  border-color: #dc2626;
  color: white;
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

/* Modern Empty State */
.modern-empty-cart {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem 2rem;
  text-align: center;
}

.empty-animation {
  position: relative;
  margin-bottom: 2rem;
}

.empty-icon {
  color: #cbd5e1;
  animation: float 3s ease-in-out infinite;
  position: relative;
  z-index: 2;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}

.empty-circles {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 1;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(135deg, #e2e8f0, #cbd5e1);
  opacity: 0.3;
  animation: pulse 2s ease-in-out infinite;
}

.circle-1 {
  width: 120px;
  height: 120px;
  top: -60px;
  left: -60px;
  animation-delay: 0s;
}

.circle-2 {
  width: 80px;
  height: 80px;
  top: -40px;
  left: -40px;
  animation-delay: 0.5s;
}

.circle-3 {
  width: 40px;
  height: 40px;
  top: -20px;
  left: -20px;
  animation-delay: 1s;
}

@keyframes pulse {
  0%,
  100% {
    transform: scale(1);
    opacity: 0.3;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.1;
  }
}

.empty-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #374151;
  margin: 0 0 0.5rem 0;
}

.empty-subtitle {
  font-size: 1rem;
  color: #6b7280;
  margin: 0 0 1.5rem 0;
  line-height: 1.5;
}

/* Modern Total Section */
.modern-total-section {
  position: relative;
  padding: 1.5rem 2rem;
  background: linear-gradient(
    135deg,
    rgba(74, 222, 128, 0.05),
    rgba(34, 197, 94, 0.05)
  );
  border-top: 1px solid rgba(74, 222, 128, 0.1);
}

.total-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #f0f4ff, #e0e7ff);
  opacity: 0.5;
}

.total-content {
  position: relative;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.total-icon {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #4ade80, #22c55e);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
}

.total-info {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.total-label {
  font-size: 1rem;
  font-weight: 600;
  color: #374151;
}

.total-amount {
  font-size: 1.5rem;
  font-weight: 800;
  color: #059669;
  background: linear-gradient(135deg, #059669, #047857);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Modern Customer Section */
.modern-customer-section {
  background: linear-gradient(145deg, #ffffff, #f8fafc);
  border-radius: 20px;
  padding: 0;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.8);
  height: 100%;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  transition: all 0.3s ease;
}

.modern-customer-section:hover {
  transform: translateY(-2px);
  box-shadow: 0 16px 48px rgba(0, 0, 0, 0.15);
}

/* Customer Form Sections */
.customer-form {
  padding: 1.5rem 2rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  flex: 1;
}

.customer-info-section,
.discount-section,
.price-summary-section {
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.8),
    rgba(248, 250, 252, 0.8)
  );
  border: 1px solid rgba(226, 232, 240, 0.8);
  border-radius: 16px;
  padding: 1.5rem;
}

.subsection-title {
  font-size: 1rem;
  font-weight: 600;
  color: #374151;
  margin: 0 0 1rem 0;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .pos-content {
    grid-template-columns: 1fr;
    min-height: auto;
    max-height: none;
    gap: 1.5rem;
  }

  .modern-product-section,
  .modern-customer-section {
    height: auto;
    min-height: 500px;
  }
}

@media (max-width: 768px) {
  .pos-title {
    font-size: 2rem;
  }

  .header-content {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }

  .header-actions {
    justify-content: center;
  }

  .modern-tabs-container {
    padding: 0.25rem;
  }

  .order-tabs {
    flex-wrap: wrap;
    gap: 0.25rem;
  }

  .modern-tab .tab-content {
    padding: 0.75rem 1rem;
    gap: 0.5rem;
  }

  .tab-text {
    font-size: 0.8125rem;
  }

  .modern-section-header {
    padding: 1rem 1.5rem;
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }

  .section-actions {
    justify-content: center;
  }

  .modern-cart-items {
    padding: 1rem 1.5rem;
  }

  .modern-cart-item {
    flex-direction: column;
    text-align: center;
    padding: 1rem;
  }

  .item-controls {
    flex-direction: row;
    justify-content: center;
    align-items: center;
    width: 100%;
  }

  .quantity-section {
    flex-direction: row;
    align-items: center;
  }

  .modern-empty-cart {
    padding: 2rem 1rem;
  }

  .empty-title {
    font-size: 1.25rem;
  }

  .modern-total-section {
    padding: 1rem 1.5rem;
  }

  .total-content {
    flex-direction: column;
    text-align: center;
    gap: 0.75rem;
  }

  .total-info {
    flex-direction: column;
    gap: 0.5rem;
  }
}

/* Modern Button Styles */
.modern-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 2rem;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  box-sizing: border-box;
  backdrop-filter: blur(10px);
}

.modern-btn.btn-primary {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.modern-btn.btn-primary:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border-color: rgba(255, 255, 255, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(74, 222, 128, 0.3);
}

.modern-btn.btn-primary:active {
  transform: translateY(0);
}

.modern-btn .btn-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.modern-btn .btn-icon svg {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

@media (max-width: 480px) {
  /* Responsive styles now handled by global CSS */

  .header-actions {
    flex-direction: column;
    gap: 0.75rem;
  }

  .modern-btn {
    padding: 0.875rem 1.5rem;
    font-size: 0.8125rem;
  }

  .order-tabs {
    flex-direction: column;
    align-items: stretch;
  }

  .add-tab-btn {
    width: 100%;
    height: 40px;
    margin-left: 0;
    margin-top: 0.5rem;
  }

  .modern-section-header {
    padding: 1rem;
  }

  .section-icon {
    width: 40px;
    height: 40px;
  }

  .section-title {
    font-size: 1.125rem;
  }

  .action-btn {
    padding: 0.625rem 0.875rem;
    font-size: 0.8125rem;
  }

  .modern-cart-items {
    padding: 0.75rem 1rem;
  }

  .modern-cart-item {
    padding: 0.875rem;
  }

  .quantity-controls {
    padding: 0.125rem;
  }

  .modern-qty-btn {
    width: 28px;
    height: 28px;
  }

  .empty-animation {
    margin-bottom: 1.5rem;
  }

  .empty-icon svg {
    width: 60px;
    height: 60px;
  }

  .circle-1 {
    width: 100px;
    height: 100px;
    top: -50px;
    left: -50px;
  }

  .circle-2 {
    width: 70px;
    height: 70px;
    top: -35px;
    left: -35px;
  }

  .circle-3 {
    width: 35px;
    height: 35px;
    top: -17.5px;
    left: -17.5px;
  }
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.section-header h3 {
  margin: 0;
  color: var(--secondary-color);
}

.product-actions {
  display: flex;
  gap: 0.5rem;
}

/* Cart Items */
.cart-items {
  flex: 1;
  overflow-y: auto;
  margin-bottom: 1rem;
}

.cart-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  margin-bottom: 1rem;
}

.discount-badge {
  position: absolute;
  top: -8px;
  left: 60px;
  background-color: var(--success-color);
  color: white;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: bold;
}

.item-checkbox {
  flex-shrink: 0;
}

.item-image {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.placeholder-image {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--light-gray);
  font-size: 1.5rem;
}

.item-details {
  flex: 1;
}

.item-details h4 {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  color: var(--secondary-color);
}

.item-price {
  margin: 0.25rem 0;
}

.original-price {
  text-decoration: line-through;
  color: var(--medium-gray);
  margin-right: 0.5rem;
}

.current-price {
  color: #4ade80;
  font-weight: bold;
}

.item-size,
.item-sku {
  margin: 0.25rem 0;
  font-size: 0.875rem;
  color: var(--medium-gray);
}

.item-controls {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  flex-shrink: 0;
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.qty-btn {
  width: 30px;
  height: 30px;
  border: 1px solid var(--border-color);
  background: white;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.qty-btn:hover {
  background-color: var(--light-gray);
}

.quantity {
  font-weight: bold;
  min-width: 30px;
  text-align: center;
}

.item-total {
  font-weight: bold;
  color: #4ade80;
}

.remove-btn {
  background: none;
  border: none;
  color: var(--danger-color);
  cursor: pointer;
  padding: 0.25rem;
  border-radius: 4px;
}

.remove-btn:hover {
  background-color: rgba(231, 76, 60, 0.1);
}

/* Empty Cart */
.empty-cart {
  text-align: center;
  padding: 3rem 1rem;
  color: var(--medium-gray);
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.empty-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

/* Total Section */
.total-section {
  border-top: 2px solid var(--border-color);
  padding-top: 1rem;
  margin-top: 1rem;
}

.total-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 1.125rem;
  font-weight: bold;
}

.total-amount {
  color: #4ade80;
}

/* Customer Section */
.customer-section {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: var(--shadow);
  height: 100%;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.customer-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  flex: 1;
}

.coupon-input {
  display: flex;
  gap: 0.5rem;
}

.coupon-input input {
  flex: 1;
}

/* Shipping Section */
.shipping-section {
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 1rem;
}

.shipping-section h4 {
  margin: 0 0 1rem 0;
  color: var(--secondary-color);
}

.delivery-toggle {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
}

.toggle-option {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 6px;
  transition: background-color 0.2s ease;
}

.toggle-option:hover {
  background-color: var(--light-gray);
}

.shipping-info {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  font-size: 0.875rem;
}

.delivery-service-selector {
  margin-bottom: 1rem;
}

.delivery-service-toggle {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 0.75rem;
  margin-top: 0.5rem;
}

.service-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 0.75rem 0.5rem;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  background: white;
  cursor: pointer;
  transition: all 0.2s ease;
  text-align: center;
}

.service-btn:hover {
  border-color: #4ade80;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.service-btn.active {
  border-color: #4ade80;
  background-color: rgba(74, 222, 128, 0.05);
  box-shadow: 0 2px 8px rgba(59, 130, 246, 0.2);
}

.service-logo {
  margin-bottom: 0.25rem;
}

.service-text {
  font-weight: bold;
  font-size: 0.875rem;
  white-space: nowrap;
}

.service-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  font-size: 0.75rem;
  color: var(--medium-gray);
}

.service-time {
  font-weight: 500;
}

.service-fee {
  color: var(--success-color);
  font-weight: 600;
}

.selected-service-info {
  background-color: var(--gray-50);
  padding: 0.75rem;
  border-radius: 6px;
  border-left: 4px solid #4ade80;
}

.selected-service-info > div {
  margin-bottom: 0.25rem;
  font-size: 0.875rem;
}

.selected-service-info > div:last-child {
  margin-bottom: 0;
}

/* Price Breakdown */
.price-breakdown {
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 1rem;
}

.price-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
}

.price-row.total {
  border-top: 1px solid var(--border-color);
  padding-top: 0.5rem;
  margin-top: 0.5rem;
  font-weight: bold;
  font-size: 1.125rem;
}

.free-shipping {
  color: var(--success-color);
  font-weight: bold;
  font-size: 0.95rem;
}

.discount {
  color: var(--success-color);
}

/* Payment Section */
.payment-section {
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 1rem;
}

/* Payment Method Selection */
.payment-method-selection {
  margin-bottom: 1.5rem;
}

.payment-options {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-top: 0.5rem;
}

.payment-option {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: white;
  transition: all 0.2s ease;
}

.payment-option:hover {
  border-color: var(--primary-color);
  background: rgba(74, 222, 128, 0.05);
}

.payment-option input[type="radio"] {
  margin: 0;
  width: 18px;
  height: 18px;
}

.payment-option label {
  cursor: pointer;
  font-weight: 500;
  color: var(--text-color);
}

/* Bank Transfer Section */
.bank-transfer-section {
  margin-top: 1rem;
  padding: 1rem;
  border: 2px solid #e3f2fd;
  border-radius: 8px;
  background: #f8f9fa;
}

.qr-code-container {
  text-align: center;
}

.bank-info {
  margin-bottom: 1rem;
  padding: 1rem;
  background: white;
  border-radius: 6px;
  border: 1px solid var(--border-color);
}

.bank-info p {
  margin: 0.25rem 0;
  color: var(--text-color);
}

.qr-placeholder {
  display: inline-block;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  border: 2px solid var(--border-color);
}

.qr-code {
  font-size: 2rem;
  color: var(--primary-color);
  margin-bottom: 0.5rem;
}

.qr-note {
  font-size: 0.875rem;
  color: var(--text-secondary);
  margin: 0;
}

/* COD Info */
.cod-info {
  margin-top: 1rem;
  padding: 1rem;
  border: 2px solid #fff3cd;
  border-radius: 8px;
  background: #fffbf0;
}

.cod-notice h5 {
  margin: 0 0 0.5rem 0;
  color: #856404;
}

.cod-notice p {
  margin: 0.25rem 0;
  color: #856404;
}

/* Payment Status */
.status.pending {
  color: #856404;
  font-weight: 600;
}

.amount.paid {
  color: var(--success-color);
}

.amount.surplus {
  color: var(--success-color);
}

.amount.deficit {
  color: var(--danger-color);
}

.payment-method {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.payment-amount input {
  width: 120px;
  text-align: right;
}

.payment-details {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.detail-row {
  display: flex;
  justify-content: space-between;
}

.amount.deficit {
  color: var(--danger-color);
  font-weight: bold;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 2rem;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.modal-content.large {
  max-width: 1200px;
}

.modal-content.customer-modal {
  max-width: 1200px;
  width: 92vw;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid var(--border-color);
}

.modal-header h3 {
  margin: 0;
  color: var(--secondary-color);
}

.modal-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background-color 0.3s ease;
}

.modal-close:hover {
  background-color: var(--light-gray);
}

.modal-body {
  padding: 1.5rem;
}

/* Product Search Modal */
.search-section {
  margin-bottom: 2rem;
}

.search-bar {
  margin-bottom: 1rem;
}

.price-range {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
  border: 1px solid var(--border-color);
  padding: 1rem;
  border-radius: 12px;
}

.price-slider {
  flex: 1;
}

.filter-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
}

/* Product Grid */
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
  max-height: 500px;
  overflow-y: auto;
  margin: 1rem 0 0 0;
}

.product-card {
  position: relative;
  border: 2px solid var(--border-color);
  border-radius: 12px;
  padding: 1rem;
  transition: all 0.3s ease;
}

.product-card:hover {
  border-color: #4ade80;
  transform: translateY(-2px);
}

.discount-label {
  position: absolute;
  top: -8px;
  left: 8px;
  background-color: var(--success-color);
  color: white;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: bold;
}

.product-card .product-image {
  width: 100%;
  height: 200px;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 1rem;
}

.product-info h4 {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  color: var(--secondary-color);
}

.product-details,
.product-specs {
  font-size: 0.875rem;
  color: black;
  margin: 0.25rem 0;
}

.product-price {
  margin: 0.5rem 0;
}

.product-actions {
  text-align: center;
  margin-top: 1rem;
}

/* Customer Search */
.customer-modal .search-section {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
  align-items: center;
}

.customer-modal .search-section input {
  flex: 1;
  min-width: 0;
}

.customer-list {
  max-height: 500px;
  overflow-y: auto;
  border: 1px solid var(--border-color);
  border-radius: 8px;
}

.customer-modal .table {
  width: 100%;
  table-layout: fixed;
  margin-bottom: 0;
  font-size: 0.9rem;
}

.customer-modal .table th:nth-child(1) {
  width: 60px;
} /* STT */
.customer-modal .table th:nth-child(2) {
  width: 25%;
} /* Email */
.customer-modal .table th:nth-child(3) {
  width: 20%;
} /* Họ tên */
.customer-modal .table th:nth-child(4) {
  width: 15%;
} /* Ngày sinh */
.customer-modal .table th:nth-child(5) {
  width: 15%;
} /* SĐT */
.customer-modal .table th:nth-child(6) {
  width: 10%;
} /* Giới tính */
.customer-modal .table th:nth-child(7) {
  width: 10%;
} /* Trạng thái */
.customer-modal .table th:nth-child(8) {
  width: 100px;
} /* Thao tác */

.customer-modal .table th {
  background-color: var(--gray-100);
  color: var(--secondary-color);
  font-weight: 600;
  padding: 1rem;
  text-align: left;
  border-bottom: 2px solid var(--border-color);
  position: sticky;
  top: 0;
  z-index: 10;
}

.customer-modal .table td {
  padding: 0.875rem 1rem;
  border-bottom: 1px solid var(--border-light);
  vertical-align: middle;
}

.customer-modal .table tbody tr:hover {
  background-color: var(--gray-50);
}

.customer-modal .table tbody tr:last-child td {
  border-bottom: none;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .pos-content {
    grid-template-columns: 1fr;
    min-height: auto;
    max-height: none;
  }

  .product-section,
  .customer-section {
    height: auto;
    min-height: 400px;
  }

  .product-grid {
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  }
}

@media (max-width: 768px) {
  /* pos-header responsive styles now handled by global page-header CSS */

  .order-tabs {
    flex-wrap: wrap;
  }

  .section-header {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }

  .product-actions {
    flex-direction: column;
  }

  .cart-item {
    flex-direction: column;
    text-align: center;
  }

  .item-controls {
    flex-direction: row;
    justify-content: center;
  }

  .filter-row {
    grid-template-columns: 1fr;
  }

  .search-section {
    flex-direction: column;
  }

  .modal-overlay {
    padding: 1rem;
  }

  .customer-modal {
    width: 95vw;
    max-width: none;
  }

  .customer-modal .search-section {
    flex-direction: column;
    align-items: stretch;
    gap: 0.75rem;
  }

  .customer-modal .table {
    font-size: 0.8rem;
  }

  .customer-modal .table th,
  .customer-modal .table td {
    padding: 0.5rem;
  }

  /* Hide some columns on mobile for customer table */
  .customer-modal .table th:nth-child(4),
  .customer-modal .table td:nth-child(4),
  .customer-modal .table th:nth-child(6),
  .customer-modal .table td:nth-child(6) {
    display: none;
  }

  .delivery-toggle {
    flex-direction: column;
    gap: 0.5rem;
  }

  .delivery-service-toggle {
    grid-template-columns: repeat(2, 1fr);
    gap: 0.5rem;
  }

  .service-btn {
    padding: 0.5rem 0.25rem;
  }

  .service-text {
    font-size: 0.75rem;
  }
}

/* Image Carousel Styles */
.image-carousel {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
  border-radius: 8px;
  cursor: pointer;
}

.carousel-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  min-width: 200px;
  min-height: 200px;
  object-fit: cover;
  object-position: center;
  opacity: 0;
  transition: opacity 0.5s ease-in-out;
}

.carousel-image.active {
  opacity: 1;
}

.carousel-indicators {
  position: absolute;
  bottom: 8px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 6px;
}

.indicator {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.5);
  transition: background 0.3s ease;
}

.indicator.active {
  background: #007bff;
}

/* Single image */
.single-image {
  width: 100%;
  height: 200px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
}

.single-image img {
  width: 100%;
  height: 100%;
  min-width: 200px;
  min-height: 200px;
  object-fit: cover;
  object-position: center;
}

/* Image Modal Styles */
.image-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: modalFadeIn 0.3s ease;
}

.image-modal-content {
  position: relative;
  max-width: 90vw;
  max-height: 90vh;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

.image-modal-close {
  position: absolute;
  top: 15px;
  right: 15px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border: none;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  font-size: 20px;
  cursor: pointer;
  z-index: 10;
  transition: background 0.3s ease;
}

.image-modal-close:hover {
  background: rgba(0, 0, 0, 0.9);
}

.image-modal-main {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 400px;
  background: #000;
}

.image-modal-display {
  max-width: 90vw;
  max-height: 80vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-image {
  max-width: 100%;
  max-height: 100%;
  min-width: 300px;
  min-height: 300px;
  object-fit: contain;
  object-position: center;
  border-radius: 8px;
}

.nav-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border: none;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  font-size: 24px;
  cursor: pointer;
  z-index: 5;
  transition: all 0.3s ease;
}

.nav-btn:hover {
  background: rgba(0, 0, 0, 0.9);
  transform: translateY(-50%) scale(1.1);
}

.prev-btn {
  left: 20px;
}

.next-btn {
  right: 20px;
}

.image-modal-thumbnails {
  display: flex;
  justify-content: center;
  gap: 10px;
  padding: 15px;
  background: #f8f9fa;
  border-top: 1px solid #dee2e6;
  overflow-x: auto;
}

.thumbnail {
  width: 70px;
  height: 70px;
  border-radius: 6px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
  transition: border 0.3s ease;
}

.thumbnail:hover {
  border-color: #007bff;
}

.thumbnail.active {
  border-color: #007bff;
  box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
}

.thumbnail img {
  width: 100%;
  height: 100%;
  min-width: 70px;
  min-height: 70px;
  object-fit: cover;
  object-position: center;
}

.image-modal-counter {
  position: absolute;
  bottom: 15px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 5px 15px;
  border-radius: 20px;
  font-size: 14px;
  z-index: 10;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .image-modal-display {
    max-width: 95vw;
    max-height: 60vh;
  }

  .image-modal-thumbnails {
    gap: 8px;
    padding: 10px;
  }

  .thumbnail {
    width: 60px;
    height: 60px;
  }

  .nav-btn {
    width: 40px;
    height: 40px;
    font-size: 20px;
  }

  .prev-btn {
    left: 10px;
  }

  .next-btn {
    right: 10px;
  }
}

/* Customer Input Enhancements */
.customer-input-container {
  position: relative;
  display: flex;
  align-items: center;
}

.customer-input-container .form-control {
  padding-right: 35px; /* Tạo khoảng trống cho nút X */
}

.btn-clear-input {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: var(--text-secondary);
  font-size: 14px;
  cursor: pointer;
  padding: 4px;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  z-index: 5;
}

.btn-clear-input:hover {
  background: rgba(0, 0, 0, 0.1);
  color: var(--text-color);
}

/* Customer Suggestions Dropdown */
.customer-suggestions {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  width: 100%;
  background: white;
  border: 1px solid var(--border-color);
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  z-index: 9999;
  max-height: 250px;
  overflow-y: auto;
  margin-top: 2px;
  animation: dropdownFadeIn 0.15s ease-out;
}

@keyframes dropdownFadeIn {
  from {
    opacity: 0;
    transform: translateY(-5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.customer-suggestion-item {
  padding: 0.75rem;
  cursor: pointer;
  border-bottom: 1px solid var(--border-color);
  transition: background-color 0.2s ease;
}

.customer-suggestion-item:last-child {
  border-bottom: none;
}

.customer-suggestion-item:hover {
  background-color: rgba(74, 222, 128, 0.05);
}

.create-new-customer {
  background-color: rgba(59, 130, 246, 0.05);
  border-left: 3px solid #3b82f6;
}

.create-new-customer:hover {
  background-color: rgba(59, 130, 246, 0.1);
}

.create-new-hint {
  color: #3b82f6;
  font-weight: 500;
}

.customer-info strong {
  display: block;
  color: var(--text-color);
  margin-bottom: 0.25rem;
}

.customer-info small {
  color: var(--text-secondary);
  font-size: 0.75rem;
}

/* Add Customer Form Styling */
.add-customer-form {
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 1px solid var(--border-color);
}

.form-sections {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.form-section h4 {
  margin: 0 0 1rem 0;
  color: var(--secondary-color);
  font-size: 1.125rem;
  font-weight: 600;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 1rem;
  border-top: 1px solid var(--border-color);
}

.address-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.address-header h4 {
  margin: 0;
}

/* Delivery Address Section */
.delivery-address-section {
  margin-top: 1.5rem;
  padding: 1.5rem;
  background: #f8fafc;
  border-radius: 8px;
  border: 1px solid var(--border-color);
}

.address-title {
  margin: 0 0 1rem 0;
  color: var(--secondary-color);
  font-size: 1.125rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.address-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.address-preview {
  margin-top: 1rem;
  padding: 1rem;
  background: white;
  border-radius: 6px;
  border: 1px solid #e2e8f0;
}

.address-preview strong {
  color: var(--secondary-color);
  display: block;
  margin-bottom: 0.5rem;
}

.address-preview p {
  margin: 0;
  color: var(--text-color);
  font-size: 0.9rem;
  line-height: 1.4;
  white-space: pre-line;
}

/* Hide suggestions when clicking outside */
.customer-suggestions::before {
  content: "";
  position: absolute;
  top: -8px;
  left: 20px;
  width: 0;
  height: 0;
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-bottom: 8px solid white;
}

.customer-suggestions::after {
  content: "";
  position: absolute;
  top: -9px;
  left: 20px;
  width: 0;
  height: 0;
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-bottom: 9px solid var(--border-color);
}

/* Coupon Selector Styles */
.coupon-selector {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.clear-coupons-btn {
  width: 100%;
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
  color: white;
  border: none;
  padding: 0.75rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.9rem;
  font-weight: 500;
}

.clear-coupons-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
}

.coupon-select-btn {
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0.75rem 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.9rem;
  font-weight: 500;
}

.coupon-select-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.coupon-select-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: var(--text-muted);
}

/* Selected Coupons Display */
.selected-coupons {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.no-customer-message {
  padding: 0.75rem;
  background: var(--warning-light);
  border: 1px solid var(--warning-color);
  border-radius: 6px;
  text-align: center;
}

.no-customer-message small {
  color: var(--warning-color);
  font-style: italic;
}

.no-coupons-message {
  padding: 0.75rem;
  background: var(--info-light);
  border: 1px solid var(--info-color);
  border-radius: 6px;
  text-align: center;
}

.no-coupons-message small {
  color: var(--info-color);
  font-style: italic;
}

.info-message {
  padding: 0.75rem;
  background: var(--info-light);
  border: 1px solid var(--info-color);
  border-radius: 6px;
  text-align: center;
}

.info-message small {
  color: var(--info-color);
  font-style: italic;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10000;
}

.modal-content {
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  max-width: 600px;
  width: 90%;
  max-height: 80vh;
  overflow: hidden;
  animation: modalFadeIn 0.3s ease-out;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
    transform: scale(0.9) translateY(-20px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.coupon-modal {
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem 2rem;
  border-bottom: 1px solid var(--border-color);
  background: var(--primary-light);
}

.modal-header h3 {
  margin: 0;
  color: var(--primary-color);
  font-size: 1.2rem;
  font-weight: 600;
}

.modal-close-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: var(--text-muted);
  padding: 0.5rem;
  border-radius: 50%;
  transition: all 0.2s ease;
}

.modal-close-btn:hover {
  background: var(--error-light);
  color: var(--error-color);
}

.modal-body {
  flex: 1;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.coupon-list {
  flex: 1;
  overflow-y: auto;
  padding: 1rem;
  max-height: 400px;
}

.coupon-modal-item {
  display: flex;
  align-items: center;
  padding: 1rem;
  border: 1px solid var(--border-color);
  border-radius: 8px;
  margin-bottom: 0.75rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.coupon-modal-item:hover:not(.disabled) {
  border-color: var(--primary-color);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.coupon-modal-item.selected {
  border-color: var(--primary-color);
  background: var(--primary-light);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
}

.coupon-modal-item.disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: var(--disabled-bg);
}

.coupon-modal-info {
  flex: 1;
}

.coupon-modal-name {
  font-weight: 600;
  color: var(--text-color);
  margin-bottom: 0.5rem;
  font-size: 1rem;
}

.coupon-modal-details {
  color: var(--text-muted);
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.min-order {
  display: block;
  margin-top: 0.25rem;
  color: var(--warning-color);
  font-weight: 500;
}

.coupon-modal-checkbox {
  margin-left: 1rem;
}

.coupon-modal-checkbox input[type="checkbox"] {
  width: 20px;
  height: 20px;
  accent-color: var(--primary-color);
}

.no-coupons-available {
  text-align: center;
  padding: 3rem 1rem;
  color: var(--text-muted);
}

.no-coupons-available p {
  font-size: 1.1rem;
  margin: 0;
}

.modal-footer {
  border-top: 1px solid var(--border-color);
  padding: 1.5rem 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: var(--background-light);
}

.selected-count {
  font-weight: 500;
  color: var(--primary-color);
  font-size: 0.9rem;
}

.modal-actions {
  display: flex;
  gap: 1rem;
}

.modal-actions .btn {
  padding: 0.75rem 1.5rem;
  font-weight: 500;
}

.selected-coupon-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem;
  background: var(--primary-light);
  border: 1px solid var(--primary-color);
  border-radius: 6px;
}

.coupon-summary {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  flex: 1;
}

.coupon-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  justify-content: space-between;
}

.coupon-summary .coupon-name {
  font-weight: 500;
  color: var(--text-color);
}

.auto-applied-badge {
  background: var(--info-color);
  color: white;
  padding: 0.125rem 0.375rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 500;
}

.auto-indicator {
  color: var(--info-color);
  font-weight: 500;
  font-size: 0.85em;
}

.auto-applied-notification {
  background: var(--info-light);
  border: 1px solid var(--info-color);
  border-radius: 6px;
  padding: 0.5rem;
  margin-bottom: 0.75rem;
}

.auto-applied-notification small {
  color: var(--info-color);
  font-style: italic;
}

.coupon-summary .coupon-value {
  color: var(--success-color);
  font-weight: 600;
}

.coupon-actions {
  display: flex;
  gap: 0.25rem;
}

.btn-change-coupon,
.btn-remove-coupon {
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.25rem;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s ease;
}

.btn-change-coupon {
  color: var(--primary-color);
}

.btn-change-coupon:hover {
  background: var(--primary-light);
}

.btn-remove-coupon {
  color: var(--error-color);
}

.btn-remove-coupon:hover {
  background: var(--error-light);
}

/* Coupon Discount Breakdown */
.coupon-discount-breakdown {
  border: 1px solid var(--border-light);
  border-radius: 6px;
  margin: 0.5rem 0;
  background: var(--background-light);
}

.coupon-discount {
  background: rgba(255, 193, 7, 0.05);
  border-bottom: 1px solid var(--border-light);
}

.coupon-discount:last-child {
  border-bottom: none;
}

.coupon-discount small {
  color: var(--text-muted);
  font-size: 0.75rem;
  margin-left: 0.25rem;
}

.discount-total {
  background: var(--success-light);
  border-top: 2px solid var(--success-color);
  font-weight: 600;
}

.discount-total .discount {
  color: var(--success-color);
  font-weight: 700;
}

/* Discount Display */
.discount-display {
  padding: 0.75rem;
  background: var(--success-light);
  border: 1px solid var(--success-color);
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
}

.discount-amount {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--success-color);
}

.discount-breakdown {
  color: var(--text-muted);
  font-size: 0.8rem;
}

.discount-details {
  margin-top: 0.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.discount-detail {
  color: var(--success-color);
  font-weight: 500;
}
</style>
