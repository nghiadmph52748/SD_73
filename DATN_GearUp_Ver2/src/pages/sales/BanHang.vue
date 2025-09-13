<template>
  <div class="pos-system">
    <!-- Simple Action Bar -->
    <div class="simple-action-bar">
      <button class="action-btn secondary-btn" @click="refreshData" title="Làm mới dữ liệu">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <polyline points="23,4 23,10 17,10"></polyline>
          <polyline points="1,20 1,14 7,14"></polyline>
          <path d="M20.49,9A9,9,0,0,0,5.64,5.64L1,10m22,4L18.36,18.36A9,9,0,0,1,3.51,15"></path>
        </svg>
        <span>Làm mới</span>
      </button>
      <button class="action-btn secondary-btn" @click="showProductSearch = true" title="Tìm kiếm sản phẩm">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8"></circle>
          <path d="M21 21l-4.35-4.35"></path>
        </svg>
        <span>Tìm sản phẩm</span>
      </button>
      <button class="action-btn primary-btn" @click="createNewOrder" title="Tạo đơn hàng mới">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M12 5v14M5 12h14"></path>
        </svg>
        <span>Tạo đơn hàng mới</span>
      </button>
    </div>

    <!-- Modern Order Tabs -->
    <div class="order-tabs">
      <div class="tabs-wrapper">
        <div class="tabs-scroll">
          <div v-for="order in tempOrder" :key="order.id"
            :class="['order-tab', { active: currentOrderId === order.id }]" @click="switchOrder(order.id)">
            <div class="tab-main">
              <div class="tab-indicator"></div>
              <div class="tab-content">
                <div class="tab-title">{{ order.tenDonHang }}</div>
                <div class="tab-meta">
                  {{ order.danhSachSanPham?.length || 0 }} sản phẩm
                </div>
              </div>
              <button v-if="tempOrder.length > 1" class="tab-close" @click.stop="closeOrder(order.id)"
                title="Đóng đơn hàng">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>
        </div>
        <button class="new-tab-btn" @click="createNewOrder" title="Tạo đơn hàng mới">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <path d="M12 5v14M5 12h14" />
          </svg>
        </button>
      </div>
    </div>

    <div class="main-content">
      <!-- Modern Cart Section -->
      <div class="modern-cart-section">
        <div class="cart-header">
          <div class="cart-header-left">
            <div class="cart-icon">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="8" cy="21" r="1" />
                <circle cx="19" cy="21" r="1" />
                <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12" />
              </svg>
            </div>
            <div class="cart-info">
              <h2 class="cart-title">Giỏ hàng</h2>
              <p class="cart-subtitle">
                {{ currentOrder?.danhSachSanPham?.length || 0 }} sản phẩm
              </p>
            </div>
          </div>
          <div class="cart-header-actions">
            <button class="cart-action-btn secondary-btn" @click="showQRScanner = true" title="Quét QR code">
              <img src="@/assets/QR.svg" alt="QR Code" width="18" height="18" />
            </button>
            <button class="cart-action-btn primary-btn" @click="showProductSearch = true" title="Thêm sản phẩm">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 5v14M5 12h14" />
              </svg>
              <span>Thêm sản phẩm</span>
            </button>
          </div>
        </div>

        <!-- Modern Cart Items -->
        <div class="modern-cart-items" v-if="currentOrder && currentOrder.danhSachSanPham.length > 0">
          <div v-for="item in currentOrder.danhSachSanPham" :key="item.id" class="modern-cart-item">
            <div class="cart-item-content">
              <div class="item-checkbox-wrapper">
                <input type="checkbox" v-model="item.selected" class="modern-checkbox" :id="'item-' + item.id" />
                <label :for="'item-' + item.id" class="checkbox-label"></label>
              </div>

              <div class="item-image-wrapper">
                <div class="item-image">
                  <img v-if="item.duongDanAnh" :src="item.duongDanAnh.startsWith('http')
                      ? item.duongDanAnh
                      : IMAGE_BASE_URL + item.duongDanAnh
                    " :alt="item.tenSanPham" class="product-image" />
                  <div v-else class="image-placeholder">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="1.5">
                      <rect x="3" y="3" width="18" height="18" rx="2" />
                      <circle cx="8.5" cy="8.5" r="1.5" />
                      <path d="M21 15l-5-5L5 21" />
                    </svg>
                  </div>
                </div>
              </div>

              <div class="item-info-wrapper">
                <div class="item-main-info">
                  <h3 class="product-title">{{ item.tenSanPham }}</h3>
                  <div class="product-details">
                    <span class="product-brand">{{ item.tenNhaSanXuat }}</span>
                  </div>
                  <div class="product-specs">
                    <span class="spec product-code">{{ 
                      item.ma_san_pham ||
                      item.sanPham?.ma_san_pham ||
                      item.maSanPham || 
                      item.sanPham?.maSanPham || 
                      item.code || 
                      item.productCode ||
                      item.sku || 
                      `SP${String(item.id).padStart(5, '0')}` 
                    }}</span>
                    <span class="spec">{{ item.tenMauSac }}</span>
                    <span class="spec">{{ item.tenKichThuoc }}</span>
                  </div>
                </div>

                <div class="item-price-section">
                  <div class="price-info">
                    <div class="price-wrapper">
                      <span class="current-price">
                        {{ formatCurrency(item.giaSauGiam) }}
                      </span>
                      <span v-if="item.giaTriGiamGia > 0" class="discount-tag">
                        -{{ item.giaTriGiamGia }}%
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <div class="item-controls-wrapper">
                <div class="quantity-controls">
                  <button @click="updateQuantity(item, -1)" class="quantity-btn" :disabled="item.soLuong <= 1">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M5 12h14" />
                    </svg>
                  </button>
                  <span class="quantity-display">{{ item.soLuong }}</span>
                  <button @click="updateQuantity(item, 1)" class="quantity-btn">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M12 5v14M5 12h14" />
                    </svg>
                  </button>
                </div>

                <div class="total-and-remove">
                  <div class="item-total-price">
                    {{ formatCurrency(item.giaSauGiam * item.soLuong) }}
                  </div>
                  <button @click="removeItem(item)" class="remove-item-btn" title="Xóa khỏi giỏ hàng">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path
                        d="M3 6h18M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2M10 11v6M14 11v6" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Modern Empty State -->
        <div v-else class="modern-empty-state">
          <div class="empty-state-content">
            <div class="empty-illustration">
              <svg width="96" height="96" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                <circle cx="8" cy="21" r="1" />
                <circle cx="19" cy="21" r="1" />
                <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12" />
              </svg>
            </div>
            <div class="empty-text">
              <h3 class="empty-title">Giỏ hàng trống</h3>
              <p class="empty-description">
                Chưa có sản phẩm nào trong giỏ hàng. Hãy thêm sản phẩm để bắt
                đầu tạo đơn hàng.
              </p>
            </div>
            <button class="add-first-product-btn" @click="showProductSearch = true">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 5v14M5 12h14"></path>
              </svg>
              <span>Thêm sản phẩm đầu tiên</span>
            </button>
          </div>
        </div>

        <!-- Modern Total Section -->
        <div class="modern-total-section" v-if="currentOrder && currentOrder.danhSachSanPham.length > 0">
          <div class="total-summary-card">
            <div class="total-row">
              <span class="total-label">Tổng tiền hàng:</span>
              <span class="total-value">{{
                formatCurrency(currentOrder.tongTien || 0)
                }}</span>
            </div>
            <div class="total-row" v-if="currentOrder.discount && currentOrder.discount > 0">
              <span class="total-label discount-label">Giảm giá:</span>
              <span class="total-value discount-value">-{{ formatCurrency(currentOrder.discount) }}</span>
            </div>
            <div class="total-divider"></div>
            <div class="total-row final-total">
              <span class="final-label">Thành tiền:</span>
              <span class="final-value">{{
                formatCurrency(
                  (currentOrder.tongTien || 0) - (currentOrder.discount || 0)
                )
              }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Clean Customer Section -->
      <div class="clean-customer-section">
        <div class="customer-section-header">
          <div class="customer-header-content">
            <div class="customer-icon-wrapper">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
            </div>
            <div class="customer-header-text">
              <h3 class="customer-section-title">Khách hàng & Thanh toán</h3>
              <p class="customer-section-subtitle">
                Thông tin khách hàng và xử lý thanh toán
              </p>
            </div>
          </div>
          <button class="find-customer-btn" @click="showCustomerSearch = true">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="M21 21l-4.35-4.35"></path>
            </svg>
            <span>Tìm khách hàng</span>
          </button>
        </div>

        <div class="clean-customer-form" v-if="currentOrder">
          <!-- Customer Info Section -->
          <div class="customer-info-section">
            <h4 class="section-title">Thông tin khách hàng</h4>

            <div class="customer-input-group">
              <label class="customer-label">Tên khách hàng</label>
              <div class="customer-input-wrapper">
                <div class="customer-input-container">
                  <svg class="customer-input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                  </svg>
                  <input type="text" v-model="customerDisplayName" @input="searchCustomers"
                    @focus="showCustomerDropdown = true" class="customer-input"
                    placeholder="Nhập tên hoặc email khách hàng" autocomplete="off" />
                  <button v-if="customerDisplayName" class="clear-customer-input" @click="clearCustomerInput"
                    title="Xóa nội dung">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M18 6L6 18M6 6l12 12" />
                    </svg>
                  </button>
                </div>

                <!-- Customer Suggestions -->
                <div v-if="customerSuggestions.length > 0 && showCustomerDropdown" class="customer-suggestions">
                  <div v-for="customer in customerSuggestions" :key="customer.id" :class="[
                    'customer-suggestion',
                    { 'create-new': customer.isCreateNew },
                  ]" @click="selectCustomerFromSuggestions(customer)">
                    <div class="suggestion-content">
                      <div class="suggestion-info" v-if="!customer.isCreateNew">
                        <span class="suggestion-name">{{
                          customer.tenKhachHang
                          }}</span>
                        <span class="suggestion-details">{{ customer.email }} •
                          {{ customer.soDienThoai }}</span>
                      </div>
                      <div class="suggestion-info create-new-info" v-else>
                        <div class="create-new-row">
                          <img :src="PlusIcon" alt="Plus" class="plus-icon" />
                          <span class="create-new-text">{{
                            customer.displayName
                            }}</span>
                        </div>
                        <span class="create-new-hint">Nhấn để tạo khách hàng mới</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Discount Section -->
          <div class="discount-section">
            <h4 class="section-title">Giảm giá & Khuyến mãi</h4>

            <div class="coupon-selector">
              <button class="select-coupon-btn" @click="openCouponModal" :disabled="availableCoupons.length === 0">
                <div class="coupon-btn-inner">
                  <div class="coupon-btn-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M21 12v-2a2 2 0 00-2-2H5a2 2 0 00-2 2v2" />
                      <path d="M21 12v2a2 2 0 01-2 2H5a2 2 0 01-2-2v-2" />
                      <circle cx="9" cy="12" r="1" />
                      <circle cx="15" cy="12" r="1" />
                    </svg>
                  </div>
                  <div class="coupon-btn-text">
                    <span v-if="selectedCoupons.length > 0">Chọn phiếu giảm giá</span>
                    <span v-else-if="availableCoupons.length > 0">Chọn phiếu giảm giá</span>
                    <span v-else>Đang tải phiếu giảm giá...</span>
                  </div>
                  <svg class="coupon-chevron" width="14" height="14" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2">
                    <path d="M9 18l6-6-6-6" />
                  </svg>
                </div>
              </button>
            </div>

            <!-- Selected Coupon Display -->
            <div v-if="selectedCoupons.length > 0" class="selected-coupon">
              <div class="coupon-info">
                <div class="coupon-details">
                  <span class="coupon-name">{{
                    selectedCoupons[0].tenPhieuGiamGia
                    }}</span>
                  <span class="coupon-value">
                    <span v-if="selectedCoupons[0].loaiPhieuGiamGia === false">
                      -{{ selectedCoupons[0].giaTriGiamGia }}%
                    </span>
                    <span v-else>
                      -{{ formatCurrency(selectedCoupons[0].giaTriGiamGia) }}
                    </span>
                  </span>
                </div>
                <button class="remove-coupon-btn" @click="removeSelectedCoupon(selectedCoupons[0].id)">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 6L6 18M6 6l12 12" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Auto Applied Notification -->
            <div v-if="autoAppliedCoupon" class="auto-applied-notice">
              <div class="notice-icon">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M9 12l2 2 4-4" />
                  <circle cx="12" cy="12" r="10" />
                </svg>
              </div>
              <div class="notice-content">
                <div class="notice-title">🎉 Phiếu giảm giá tự động</div>
                <div class="notice-detail">
                  <strong>{{ autoAppliedCoupon.tenPhieuGiamGia }}</strong>
                  <span class="discount-info">
                    <span v-if="autoAppliedCoupon.loaiPhieuGiamGia === false">
                      -{{ autoAppliedCoupon.giaTriGiamGia }}%
                    </span>
                    <span v-else>
                      -{{ formatCurrency(autoAppliedCoupon.giaTriGiamGia) }}
                    </span>
                  </span>
                </div>
              </div>
              <button class="notice-close" @click="autoAppliedCoupon = null" title="Ẩn thông báo">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>

          <!-- Gợi ý phiếu giảm giá tốt hơn -->
          <div v-if="showRecommendation && betterCoupons.length > 0" class="recommendation-section-external">
            <div class="recommendation-header">
              <div class="recommendation-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path
                    d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                </svg>
              </div>
              <h4 class="recommendation-title">
                💡 Gợi ý phiếu giảm giá tốt hơn
              </h4>
            </div>
            <p class="recommendation-subtitle">
              Mua thêm để đạt được phiếu giảm giá có lợi hơn!
            </p>

            <div class="recommendation-list">
              <div v-for="(coupon, index) in betterCoupons" :key="coupon.coupon.id" class="recommendation-item-external"
                @click="openCouponModal">
                <div class="recommendation-info">
                  <div class="recommendation-name">
                    {{ coupon.coupon.tenPhieuGiamGia }}
                  </div>
                  <div class="recommendation-details">
                    <span class="needed-amount">
                      Cần thêm: {{ formatCurrency(coupon.neededAmount) }}
                    </span>
                    <span class="potential-savings">
                      Tiết kiệm: {{ formatCurrency(coupon.potentialSavings) }}
                    </span>
                  </div>
                </div>
                <div class="recommendation-benefit">
                  <div class="benefit-amount">
                    +{{ formatCurrency(coupon.potentialSavings) }}
                  </div>
                  <div class="benefit-label">Tiết kiệm</div>
                </div>
                <div class="click-hint">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9 5l7 7-7 7" />
                  </svg>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Payment Section -->
        <div class="payment-section">
          <h4 class="section-title">Thanh toán</h4>

          <!-- Payment Methods -->
          <div class="payment-options">
            <div class="payment-option" :class="{
              selected: currentOrder?.phuongThucThanhToan === 'pay_now',
            }" @click="currentOrder.phuongThucThanhToan = 'pay_now'">
              <div class="payment-option-icon">
                <img src="@/assets/Money.svg" alt="Cash Icon" width="18" height="18" />
              </div>
              <div class="payment-option-content">
                <span class="payment-option-title">Tiền mặt</span>
                <span class="payment-option-desc">Thanh toán trực tiếp</span>
              </div>
            </div>

            <div class="payment-option" :class="{
              selected: currentOrder?.phuongThucThanhToan === 'bank_transfer',
            }" @click="currentOrder.phuongThucThanhToan = 'bank_transfer'">
              <div class="payment-option-icon">
                <img src="@/assets/Banking.svg" alt="Banking Icon" width="18" height="18" />
              </div>
              <div class="payment-option-content">
                <span class="payment-option-title">Chuyển khoản</span>
                <span class="payment-option-desc">Thanh toán qua ngân hàng</span>
              </div>
            </div>

            <div class="payment-option" :class="{
              selected: currentOrder?.phuongThucThanhToan === 'home_delivery',
            }" @click="selectHomeDelivery">
              <div class="payment-option-icon">
                <img src="@/assets/Shipping.svg" alt="Delivery Icon" width="18" height="18" />
              </div>
              <div class="payment-option-content">
                <span class="payment-option-title">Giao hàng tận nơi</span>
                <span class="payment-option-desc">Thanh toán khi nhận hàng</span>
              </div>
            </div>
          </div>

          <!-- Cash Payment Details -->
          <div v-if="currentOrder?.phuongThucThanhToan === 'pay_now'" class="cash-payment-info">
            <div class="cash-payment-card">
              <div class="cash-payment-header">
                <div class="cash-icon">
                  <img src="@/assets/Money.svg" alt="Cash Icon" width="24" height="24" />
                </div>
                <div class="cash-header-text">
                  <h5 class="cash-title">Thanh toán tiền mặt</h5>
                  <p class="cash-subtitle">
                    Nhập số tiền khách hàng đưa để tính tiền thừa
                  </p>
                </div>
              </div>

              <div class="cash-payment-form">
                <div class="cash-input-group">
                  <label class="cash-input-label">Tiền khách đưa:</label>
                  <div class="cash-input-wrapper">
                    <input type="number" class="cash-input" v-model.number="currentOrder.tienKhachTra"
                      placeholder="Nhập số tiền khách đưa" min="0" step="1000" @input="calculateChange" />
                    <span class="currency-unit">VNĐ</span>
                  </div>
                </div>

                <div class="cash-calculation">
                  <div class="calculation-row">
                    <span class="calc-label">Tổng tiền cần thanh toán:</span>
                    <span class="calc-amount">{{
                      formatCurrency(currentOrder?.tongTienSauGiam || 0)
                      }}</span>
                  </div>
                  <div class="calculation-row">
                    <span class="calc-label">Tiền khách đưa:</span>
                    <span class="calc-amount">{{
                      formatCurrency(currentOrder?.tienKhachTra || 0)
                      }}</span>
                  </div>
                  <div class="calculation-divider"></div>
                  <div class="calculation-row final-row">
                    <span class="calc-label final-label">
                      <span v-if="
                        (currentOrder?.tienKhachTra || 0) >=
                        (currentOrder?.tongTienSauGiam || 0)
                      ">
                        Tiền thừa:
                      </span>
                      <span v-else class="text-red"> Còn thiếu: </span>
                    </span>
                    <span class="calc-amount final-amount" :class="{
                      'text-green':
                        (currentOrder?.tienKhachTra || 0) >=
                        (currentOrder?.tongTienSauGiam || 0),
                      'text-red':
                        (currentOrder?.tienKhachTra || 0) <
                        (currentOrder?.tongTienSauGiam || 0),
                    }">
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

                <div class="cash-note">
                  <div class="note-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <circle cx="12" cy="12" r="10" />
                      <path d="M12 16v-4M12 8h.01" />
                    </svg>
                  </div>
                  <div class="note-content">
                    <p><strong>Lưu ý:</strong></p>
                    <ul>
                      <li>Kiểm tra kỹ số tiền khách đưa trước khi nhập</li>
                      <li>
                        Thông báo rõ ràng số tiền thừa/thiếu cho khách hàng
                      </li>
                      <li>Bảo quản tiền mặt an toàn</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Bank Transfer Details -->
          <div v-if="currentOrder?.phuongThucThanhToan === 'bank_transfer'" class="bank-transfer-info">
            <div class="bank-info-card">
              <div class="bank-card-header">
                <div class="bank-icon">
                  <img src="@/assets/Banking.svg" alt="Banking Icon" width="24" height="24" />
                </div>
                <div class="bank-header-text">
                  <h5 class="bank-title">Thông tin chuyển khoản</h5>
                  <p class="bank-subtitle">
                    Vui lòng chuyển khoản theo thông tin bên dưới
                  </p>
                </div>
              </div>

              <div class="bank-details">
                <div class="bank-detail-row">
                  <span class="bank-label">Ngân hàng:</span>
                  <span class="bank-value">Vietcombank (VCB)</span>
                </div>
                <div class="bank-detail-row">
                  <span class="bank-label">Số tài khoản:</span>
                  <div class="bank-account">
                    <span class="bank-value">1234567890123</span>
                    <button class="copy-btn" @click="copyToClipboard('1234567890123')" title="Sao chép số tài khoản">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2">
                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                        <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" />
                      </svg>
                    </button>
                  </div>
                </div>
                <div class="bank-detail-row">
                  <span class="bank-label">Chủ tài khoản:</span>
                  <span class="bank-value">GEARUP STORE</span>
                </div>
                <div class="bank-detail-row">
                  <span class="bank-label">Số tiền:</span>
                  <span class="bank-value amount">{{
                    formatCurrency(
                      (currentOrder?.tongTien || 0) -
                      (currentOrder?.discount || 0)
                    )
                  }}</span>
                </div>
                <div class="bank-detail-row">
                  <span class="bank-label">Nội dung:</span>
                  <div class="bank-account">
                    <span class="bank-value">{{
                      `THANH TOAN DON HANG ${currentOrder?.tenDonHang || "HD" + currentOrder?.id
                      }`
                    }}</span>
                    <button class="copy-btn" @click="
                      copyToClipboard(
                        `THANH TOAN DON HANG ${currentOrder?.tenDonHang || 'HD' + currentOrder?.id
                        }`
                      )
                      " title="Sao chép nội dung chuyển khoản">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2">
                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                        <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" />
                      </svg>
                    </button>
                  </div>
                </div>
              </div>

              <div class="qr-code-section">
                <div class="qr-header">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="5" height="5" />
                    <rect x="3" y="16" width="5" height="5" />
                    <rect x="16" y="3" width="5" height="5" />
                    <path d="M21 16h-3v3M21 21v.01M12 7v3M12 15.01V15" />
                  </svg>
                  <span class="qr-title">Quét mã QR để chuyển khoản</span>
                </div>

                <div class="qr-code-container">
                  <div class="qr-placeholder">
                    <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                      <!-- QR Code placeholder pattern -->
                      <rect width="120" height="120" fill="#ffffff" stroke="#e2e8f0" stroke-width="2" rx="8" />
                      <rect x="10" y="10" width="20" height="20" fill="#1e293b" rx="2" />
                      <rect x="35" y="10" width="5" height="5" fill="#1e293b" />
                      <rect x="45" y="10" width="5" height="5" fill="#1e293b" />
                      <rect x="55" y="10" width="10" height="10" fill="#1e293b" />
                      <rect x="90" y="10" width="20" height="20" fill="#1e293b" rx="2" />

                      <rect x="15" y="15" width="10" height="10" fill="#ffffff" rx="1" />
                      <rect x="95" y="15" width="10" height="10" fill="#ffffff" rx="1" />

                      <rect x="10" y="40" width="5" height="5" fill="#1e293b" />
                      <rect x="20" y="40" width="10" height="5" fill="#1e293b" />
                      <rect x="35" y="40" width="5" height="10" fill="#1e293b" />
                      <rect x="50" y="40" width="15" height="5" fill="#1e293b" />
                      <rect x="80" y="40" width="5" height="10" fill="#1e293b" />

                      <rect x="10" y="60" width="10" height="5" fill="#1e293b" />
                      <rect x="30" y="60" width="5" height="10" fill="#1e293b" />
                      <rect x="45" y="60" width="5" height="5" fill="#1e293b" />
                      <rect x="60" y="60" width="10" height="10" fill="#1e293b" />
                      <rect x="85" y="60" width="10" height="5" fill="#1e293b" />

                      <rect x="10" y="90" width="20" height="20" fill="#1e293b" rx="2" />
                      <rect x="15" y="95" width="10" height="10" fill="#ffffff" rx="1" />

                      <rect x="40" y="80" width="5" height="5" fill="#1e293b" />
                      <rect x="50" y="80" width="5" height="10" fill="#1e293b" />
                      <rect x="65" y="80" width="10" height="5" fill="#1e293b" />
                      <rect x="85" y="80" width="5" height="15" fill="#1e293b" />
                      <rect x="100" y="80" width="10" height="10" fill="#1e293b" />
                    </svg>
                  </div>
                  <div class="qr-info">
                    <p class="qr-description">
                      Quét mã QR bằng app ngân hàng để chuyển khoản nhanh chóng
                    </p>
                    <div class="supported-banks">
                      <span class="bank-tag">VCB</span>
                      <span class="bank-tag">MB Bank</span>
                      <span class="bank-tag">TPBank</span>
                      <span class="bank-tag">+10 khác</span>
                    </div>
                  </div>
                </div>
              </div>

              <div class="transfer-note">
                <div class="note-icon">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M12 16v-4M12 8h.01" />
                  </svg>
                </div>
                <div class="note-content">
                  <p><strong>Lưu ý quan trọng:</strong></p>
                  <ul>
                    <li>
                      Vui lòng chuyển đúng số tiền và nội dung chuyển khoản
                    </li>
                    <li>Đơn hàng sẽ được xử lý sau khi nhận được thanh toán</li>
                    <li>
                      Liên hệ hotline: <strong>1900-xxx-xxx</strong> nếu cần hỗ
                      trợ
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- Home Delivery Details -->
          <div v-if="currentOrder?.phuongThucThanhToan === 'home_delivery'" class="delivery-info">
            <div class="delivery-info-card">
              <div class="delivery-card-header">
                <div class="delivery-icon">
                  <img src="@/assets/Shipping.svg" alt="Delivery Icon" width="24" height="24" />
                </div>
                <div class="delivery-header-text">
                  <h5 class="delivery-title">Thông tin giao hàng</h5>
                  <p class="delivery-subtitle">
                    Thông tin địa chỉ và thời gian giao hàng
                  </p>
                </div>
              </div>

              <div class="delivery-form">
                <div class="form-group">
                  <label class="form-label">Họ và tên người nhận:</label>
                  <input type="text" class="form-input" :value="customerDisplayName" readonly
                    placeholder="Tên khách hàng" />
                </div>

                <div class="form-group">
                  <label class="form-label">Số điện thoại:</label>
                  <input type="text" class="form-input" v-model="deliveryAddress.soDienThoaiNguoiNhan"
                    placeholder="Nhập số điện thoại người nhận" />
                </div>

                <div class="form-group">
                  <label class="form-label">Email:</label>
                  <input type="email" class="form-input" v-model="deliveryAddress.emailNguoiNhan"
                    placeholder="Nhập email người nhận" />
                </div>

                <!-- Địa chỉ chi tiết -->
                <div class="address-section">
                  <h6 class="address-title">Địa chỉ giao hàng</h6>

                  <div class="address-row">
                    <div class="form-group address-group">
                      <label class="form-label">Tỉnh/Thành phố:</label>
                      <select class="form-select" v-model="deliveryAddress.thanhPho" @change="onProvinceChange">
                        <option value="">Chọn tỉnh/thành phố</option>
                        <option v-for="province in provinces" :key="province.code" :value="province.name">
                          {{ province.name }}
                        </option>
                      </select>
                    </div>

                    <div class="form-group address-group">
                      <label class="form-label">Quận/Huyện:</label>
                      <select class="form-select" v-model="deliveryAddress.quan" @change="onDistrictChange"
                        :disabled="!deliveryAddress.thanhPho">
                        <option value="">Chọn quận/huyện</option>
                        <option v-for="district in districts" :key="district.code" :value="district.name">
                          {{ district.name }}
                        </option>
                      </select>
                    </div>

                    <div class="form-group address-group">
                      <label class="form-label">Xã/Phường:</label>
                      <select class="form-select" v-model="deliveryAddress.phuong" :disabled="!deliveryAddress.quan">
                        <option value="">Chọn xã/phường</option>
                        <option v-for="ward in wards" :key="ward.code" :value="ward.name">
                          {{ ward.name }}
                        </option>
                      </select>
                    </div>
                  </div>

                  <div class="form-group">
                    <label class="form-label">Địa chỉ cụ thể:</label>
                    <input type="text" class="form-input" v-model="deliveryAddress.diaChiCuThe"
                      placeholder="Số nhà, tên đường, khu vực..." />
                  </div>

                  <!-- Hiển thị địa chỉ đầy đủ -->
                  <div class="address-preview" v-if="fullAddress">
                    <label class="form-label">Địa chỉ đầy đủ:</label>
                    <div class="address-display">{{ fullAddress }}</div>
                  </div>
                </div>

                <div class="delivery-options">
                  <div class="delivery-option-item">
                    <label class="form-label">Đơn vị vận chuyển:</label>
                    <select class="form-select" v-model="selectedShippingCarrier" @change="updateShippingFee">
                      <option value="">Chọn đơn vị vận chuyển</option>
                      <option value="ghn">Giao Hàng Nhanh (GHN)</option>
                      <option value="ghtk">Giao Hàng Tiết Kiệm (GHTK)</option>
                      <option value="vnpost">VNPost</option>
                      <option value="jnt">J&T Express</option>
                      <option value="grab">GrabExpress</option>
                      <option value="shopee">Shopee Express</option>
                    </select>
                  </div>

                  <div class="delivery-option-item">
                    <label class="form-label">Loại dịch vụ:</label>
                    <select class="form-select" v-model="selectedServiceType" @change="updateShippingFee"
                      :disabled="!selectedShippingCarrier">
                      <option value="">Chọn loại dịch vụ</option>
                      <template v-if="selectedShippingCarrier === 'ghn'">
                        <option value="standard">
                          Tiêu chuẩn (2-3 ngày) - 25.000Đ
                        </option>
                        <option value="express">
                          Nhanh (1-2 ngày) - 35.000Đ
                        </option>
                        <option value="same_day">Trong ngày - 50.000Đ</option>
                      </template>
                      <template v-else-if="selectedShippingCarrier === 'ghtk'">
                        <option value="standard">
                          Tiêu chuẩn (2-4 ngày) - 22.000Đ
                        </option>
                        <option value="express">
                          Nhanh (1-2 ngày) - 30.000Đ
                        </option>
                      </template>
                      <template v-else-if="selectedShippingCarrier === 'vnpost'">
                        <option value="standard">
                          Tiêu chuẩn (3-5 ngày) - 20.000Đ
                        </option>
                        <option value="express">
                          Nhanh (2-3 ngày) - 28.000Đ
                        </option>
                      </template>
                      <template v-else-if="selectedShippingCarrier === 'jnt'">
                        <option value="standard">
                          Tiêu chuẩn (2-3 ngày) - 24.000Đ
                        </option>
                        <option value="express">
                          Nhanh (1-2 ngày) - 32.000Đ
                        </option>
                      </template>
                      <template v-else-if="selectedShippingCarrier === 'grab'">
                        <option value="standard">
                          Standard (2-4h) - 40.000Đ
                        </option>
                        <option value="express">
                          Express (1-2h) - 60.000Đ
                        </option>
                      </template>
                      <template v-else-if="selectedShippingCarrier === 'shopee'">
                        <option value="standard">
                          Tiêu chuẩn (2-3 ngày) - 23.000Đ
                        </option>
                        <option value="express">
                          Nhanh (1-2 ngày) - 31.000Đ
                        </option>
                      </template>
                    </select>
                  </div>
                </div>

                <div class="shipping-fee-summary">
                  <div class="fee-breakdown">
                    <div class="fee-item">
                      <span class="fee-label">Phí giao hàng:</span>
                      <span class="fee-value">{{ formatShippingFee() }}</span>
                    </div>
                    <div class="fee-item" v-if="isEligibleForFreeShipping()">
                      <span class="fee-label text-green">Miễn phí giao hàng:</span>
                      <span class="fee-value text-green">-{{ formatShippingFee() }}</span>
                    </div>
                    <div class="fee-total">
                      <span class="total-label">Tổng phí vận chuyển:</span>
                      <span class="total-value">{{
                        formatFinalShippingFee()
                        }}</span>
                    </div>
                  </div>

                  <div class="shipping-note" v-if="selectedShippingCarrier">
                    <div class="carrier-info">
                      <div class="carrier-logo">
                        <span class="carrier-name">{{
                          getCarrierDisplayName()
                          }}</span>
                      </div>
                      <div class="delivery-estimate">
                        <span class="estimate-text">{{
                          getDeliveryEstimate()
                          }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="delivery-note">
                <div class="note-icon">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M12 16v-4M12 8h.01" />
                  </svg>
                </div>
                <div class="note-content">
                  <p><strong>Lưu ý quan trọng:</strong></p>
                  <ul>
                    <li>Vui lòng kiểm tra kỹ sản phẩm trước khi thanh toán</li>
                    <li>Thanh toán tiền mặt khi nhận hàng</li>
                    <li>
                      Liên hệ hotline: <strong>1900-xxx-xxx</strong> nếu cần hỗ
                      trợ
                    </li>
                    <li>Khách hàng có thể trả hàng trong vòng 7 ngày</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- Order Total -->
          <div class="order-total">
            <div class="total-summary">
              <div class="total-row">
                <span class="total-label">Tổng tiền hàng:</span>
                <span class="total-amount">{{
                  formatCurrency(currentOrder?.tongTien || 0)
                  }}</span>
              </div>
              <div class="total-row" v-if="currentOrder?.discount">
                <span class="total-label">Giảm giá:</span>
                <span class="total-amount discount-amount">-{{ formatCurrency(currentOrder.discount) }}</span>
              </div>
              <div class="total-divider"></div>
              <div class="total-row final-row">
                <span class="final-label">Thành tiền:</span>
                <span class="final-amount">{{
                  formatCurrency(
                    (currentOrder?.tongTien || 0) -
                    (currentOrder?.discount || 0)
                  )
                }}</span>
              </div>
            </div>
          </div>

          <!-- Confirm Order Button -->
          <button class="confirm-order-btn" @click="confirmOrder" :disabled="!currentOrder ||
            !currentOrder.danhSachSanPham?.length ||
            !customerDisplayName.trim()
            ">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M9 12l2 2 4-4" />
              <circle cx="12" cy="12" r="10" />
            </svg>
            <span>Xác nhận đặt hàng</span>
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modern Product Search Modal -->
  <div v-if="showProductSearch" class="modal-overlay" @click="showProductSearch = false">
    <div class="product-modal" @click.stop>
      <div class="product-modal-header">
        <h3 class="modal-title">Tìm kiếm sản phẩm</h3>
        <p class="modal-subtitle">Chọn sản phẩm để thêm vào đơn hàng</p>
        <button class="modal-close-btn" @click="showProductSearch = false">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M18 6L6 18M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div class="modal-body">
        <!-- Clean Search Header -->
        <div class="search-header">
          <div class="main-search-container">
            <div class="search-input-wrapper">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                class="search-icon">
                <circle cx="11" cy="11" r="8"></circle>
                <path d="M21 21l-4.35-4.35"></path>
              </svg>
              <input type="text" v-model="productSearchQuery" class="main-search-input"
                placeholder="Tìm theo tên sản phẩm, mã sản phẩm..." />
            </div>

            <div class="price-filter-compact">
              <span class="price-label">Khoảng giá:</span>
              <div class="price-display">
                <span class="price-value">{{
                  formatCurrency(priceRange.min)
                  }}</span>
                <input type="range" :min="priceRange.min" :max="priceRange.max" v-model="selectedPriceMax"
                  class="price-slider" />
                <span class="price-value">{{
                  formatCurrency(priceRange.max)
                  }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Clean Filter Section -->
        <div class="filter-section">
          <div class="filter-header">
            <h4 class="filter-title">Bộ lọc sản phẩm</h4>
            <button class="clear-filters-btn" @click="clearAllFilters">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 6h18M8 6V4a2 2 0 012-2h4a2 2 0 012 2v2m3 0v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6" />
              </svg>
              Xóa bộ lọc
            </button>
          </div>

          <div class="filters-grid">
            <div class="filter-item">
              <label class="filter-label">Nhà sản xuất</label>
              <select v-model="selectedNhaSanXuat" class="filter-select">
                <option value="">Tất cả nhà sản xuất</option>
                <option v-for="category in NhaSanXuats" :key="category.id" :value="category.id">
                  {{ category.tenNhaSanXuat }}
                </option>
              </select>
            </div>

            <div class="filter-item">
              <label class="filter-label">Xuất xứ</label>
              <select v-model="selectedXuatXu" class="filter-select">
                <option value="">Tất cả xuất xứ</option>
                <option v-for="category in XuatXus" :key="category.id" :value="category.id">
                  {{ category.tenXuatXu }}
                </option>
              </select>
            </div>

            <div class="filter-item">
              <label class="filter-label">Chất liệu</label>
              <select v-model="selectedChatLieu" class="filter-select">
                <option value="">Tất cả chất liệu</option>
                <option v-for="category in ChatLieus" :key="category.id" :value="category.id">
                  {{ category.tenChatLieu }}
                </option>
              </select>
            </div>

            <div class="filter-item">
              <label class="filter-label">Kích thước</label>
              <select v-model="selectedSize" class="filter-select">
                <option value="">Tất cả kích thước</option>
                <option v-for="category in KichThuocs" :key="category.id" :value="category.id">
                  {{ category.tenKichThuoc }}
                </option>
              </select>
            </div>

            <div class="filter-item">
              <label class="filter-label">Đế giày</label>
              <select v-model="selectedDeGiay" class="filter-select">
                <option value="">Tất cả loại đế</option>
                <option v-for="category in DeGiays" :key="category.id" :value="category.id">
                  {{ category.tenDeGiay }}
                </option>
              </select>
            </div>

            <div class="filter-item">
              <label class="filter-label">Màu sắc</label>
              <select v-model="selectedMauSac" class="filter-select">
                <option value="">Tất cả màu sắc</option>
                <option v-for="category in MauSacs" :key="category.id" :value="category.id">
                  {{ category.tenMauSac }}
                </option>
              </select>
            </div>
          </div>
        </div>

        <!-- Redesigned Product Grid -->
        <div class="product-grid">
          <div v-for="product in filteredSearchProducts" :key="product.id" class="product-card">
            <div class="product-discount-badge" v-if="product.giaTriGiamGia > 0">
              <span class="discount-text">-{{ product.giaTriGiamGia }}%</span>
            </div>

            <div class="product-image-section" @click="openImageModal(product.id)">
              <div class="product-image">
                <img v-if="product.anhSanPham && product.anhSanPham.length > 0" :src="product.anhSanPham[0].startsWith('http')
                    ? product.anhSanPham[0]
                    : IMAGE_BASE_URL + product.anhSanPham[0]
                  " :alt="product.tenSanPham" @error="handleImageError" />
                <div v-else class="image-placeholder">
                  <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                    <polyline points="21,15 16,10 5,21"></polyline>
                  </svg>
                </div>
              </div>
              <div class="image-overlay">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                  <circle cx="12" cy="12" r="3"></circle>
                </svg>
              </div>
            </div>

            <div class="product-info-section">
              <h4 class="product-name">{{ product.tenSanPham }}</h4>

              <!-- Stock Status Badge -->
              <div class="stock-status">
                <div class="stock-badge" :class="{
                  'in-stock': product.soLuong > 10,
                  'low-stock': product.soLuong > 0 && product.soLuong <= 10,
                  'out-of-stock': !product.soLuong || product.soLuong <= 0,
                }">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                  </svg>
                  <span class="stock-text">
                    {{
                      product.soLuong > 0
                        ? `Còn ${product.soLuong}`
                        : "Hết hàng"
                    }}
                  </span>
                </div>
              </div>

              <div class="product-details">
                <span class="product-brand">{{ product.tenNhaSanXuat }}</span>
              </div>
              <div class="product-specs">
                <span class="spec product-code">{{ 
                  product.ma_san_pham ||
                  product.sanPham?.ma_san_pham ||
                  product.maSanPham || 
                  product.sanPham?.maSanPham || 
                  product.code || 
                  product.productCode ||
                  product.sku || 
                  `SP${String(product.id).padStart(5, '0')}` 
                }}</span>
                <span class="spec">{{ product.tenMauSac }}</span>
                <span class="spec">{{ product.tenKichThuoc }}</span>
                <span class="spec">{{ product.tenChatLieu }}</span>
              </div>
              <div class="product-pricing">
                <span v-if="product.giaTriGiamGia > 0" class="original-price">{{
                  formatCurrency(product.giaBan)
                  }}</span>
                <span class="current-price">{{
                  formatCurrency(
                    (product.giaBan / 100) * (100 - product.giaTriGiamGia)
                  )
                }}</span>
              </div>
            </div>

            <div class="product-actions">
              <button class="add-to-cart-btn" :class="{
                disabled:
                  !product.trangThai ||
                  !product.soLuong ||
                  product.soLuong <= 0,
              }" :disabled="!product.trangThai || !product.soLuong || product.soLuong <= 0
                  " @click="addProductToCart(product)">
                <img :src="ShoppingCartIcon" alt="Shopping Cart" width="16" height="16" />
                <span>
                  {{
                    !product.trangThai
                      ? "Ngưng bán"
                      : !product.soLuong || product.soLuong <= 0 ? "Hết hàng" : "Thêm vào giỏ" }} </span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Modern Customer Search Modal -->
  <div v-if="showCustomerSearch" class="modal-overlay" @click="showCustomerSearch = false">
    <div class="customer-modal" @click.stop>
      <div class="customer-modal-header">
        <h3 class="modal-title">Tìm kiếm khách hàng</h3>
        <button class="modal-close-btn" @click="showCustomerSearch = false">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M18 6L6 18M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div class="customer-modal-body">
        <div class="customer-search-section">
          <div class="search-input-container">
            <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
              stroke-width="2">
              <circle cx="11" cy="11" r="8" />
              <path d="M21 21l-4.35-4.35" />
            </svg>
            <input type="text" v-model="customerSearchQuery" class="customer-search-input"
              placeholder="Tìm kiếm tên hoặc số điện thoại hoặc email" />
          </div>
          <button class="add-customer-btn" @click="openAddCustomerForm">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 5v14M5 12h14" />
            </svg>
            <span>THÊM KHÁCH HÀNG</span>
          </button>
        </div>

        <div class="customer-table-container">
          <div class="modern-table">
            <div class="table-header">
              <div class="header-cell">STT</div>
              <div class="header-cell">EMAIL</div>
              <div class="header-cell">HỌ TÊN</div>
              <div class="header-cell">NGÀY SINH</div>
              <div class="header-cell">SỐ ĐIỆN THOẠI</div>
              <div class="header-cell">GIỚI TÍNH</div>
              <div class="header-cell">TRẠNG THÁI</div>
              <div class="header-cell">THAO TÁC</div>
            </div>
            <div class="table-body">
              <div v-for="(customer, index) in filteredCustomers" :key="customer.id" class="table-row">
                <div class="table-cell">{{ index + 1 }}</div>
                <div class="table-cell">{{ customer.email }}</div>
                <div class="table-cell">
                  <div class="customer-name">{{ customer.tenKhachHang }}</div>
                </div>
                <div class="table-cell">
                  {{ customer.ngaySinh || "1998-03-10" }}
                </div>
                <div class="table-cell">{{ customer.soDienThoai }}</div>
                <div class="table-cell">
                  <span class="gender-badge">{{
                    customer.gioiTinh ? "Nam" : "Nữ"
                    }}</span>
                </div>
                <div class="table-cell">
                  <span class="status-badge active">
                    {{ !customer.trangThai ? "Hoạt động" : "Không hoạt động" }}
                  </span>
                </div>
                <div class="table-cell">
                  <button class="select-customer-btn" @click="selectCustomer(customer)">
                    CHỌN
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Modern Add Customer Form -->
        <div v-if="showAddCustomerForm" class="modern-add-customer-form">
          <div class="add-form-header">
            <h4 class="add-form-title">Thông tin cá nhân</h4>
            <small class="add-form-subtitle">*Họ và tên</small>
          </div>
          <div class="add-form-content">
            <div class="modern-form-group">
              <input type="text" v-model="newCustomerForm.tenKhachHang" class="modern-form-input"
                placeholder="Nhập họ và tên" required />
            </div>

            <div class="form-row">
              <div class="modern-form-group">
                <label class="modern-form-label">*Email</label>
                <input type="email" v-model="newCustomerForm.email" class="modern-form-input" placeholder="Nhập email"
                  required />
              </div>
              <div class="modern-form-group">
                <label class="modern-form-label">*Số điện thoại</label>
                <input type="tel" v-model="newCustomerForm.soDienThoai" class="modern-form-input"
                  placeholder="Nhập số điện thoại" required />
              </div>
            </div>

            <div class="form-row">
              <div class="modern-form-group">
                <label class="modern-form-label">*Ngày sinh</label>
                <input type="date" v-model="newCustomerForm.ngaySinh" class="modern-form-input" required />
              </div>
              <div class="modern-form-group">
                <label class="modern-form-label">*Giới tính</label>
                <select v-model="newCustomerForm.gioiTinh" class="modern-form-select">
                  <option :value="true">Nam</option>
                  <option :value="false">Nữ</option>
                </select>
              </div>
            </div>

            <div class="form-section">
              <h4>Thông tin tài khoản</h4>
              <div class="form-group">
                <label class="form-label">*Tài khoản</label>
                <input type="text" v-model="newCustomerForm.tenTaiKhoan" class="form-control" required />
              </div>
              <div class="form-group">
                <label class="form-label">*Mật khẩu</label>
                <input type="password" v-model="newCustomerForm.matKhau" class="form-control" required />
              </div>
            </div>

            <div class="form-section">
              <div class="address-header">
                <h4>Địa chỉ</h4>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Tỉnh/thành phố</label>
                  <input type="text" v-model="newCustomerForm.listDiaChi[0].thanhPho" class="form-control"
                    placeholder="Nhập tên tỉnh/thành phố" required />
                </div>
                <div class="form-group">
                  <label class="form-label">*Quận/huyện</label>
                  <input type="text" v-model="newCustomerForm.listDiaChi[0].quan" class="form-control"
                    placeholder="Nhập tên quận/huyện" required />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Xã/phường/thị trấn</label>
                  <input type="text" v-model="newCustomerForm.listDiaChi[0].phuong" class="form-control"
                    placeholder="Nhập tên xã/phường/thị trấn" required />
                </div>
                <div class="form-group">
                  <label class="form-label">*Địa chỉ cụ thể</label>
                  <input type="text" v-model="newCustomerForm.listDiaChi[0].diaChiCuThe" class="form-control"
                    required />
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
    <div v-if="showImageModal" class="image-modal-overlay" @click="closeImageModal">
      <div class="image-modal-content" @click.stop>
        <button class="image-modal-close" @click="closeImageModal">✕</button>

        <div class="image-modal-main">
          <button v-if="currentProductImages.length > 1" class="nav-btn prev-btn" @click="prevImage">
            ‹
          </button>

          <div class="image-modal-display">
            <img :src="currentProductImages[selectedImageIndex]?.duongDanAnh" :alt="`Ảnh ${selectedImageIndex + 1}`"
              class="modal-image" @error="handleImageError" />
          </div>

          <button v-if="currentProductImages.length > 1" class="nav-btn next-btn" @click="nextImage">
            ›
          </button>
        </div>

        <div v-if="currentProductImages.length > 1" class="image-modal-thumbnails">
          <div v-for="(image, index) in currentProductImages" :key="image.id"
            :class="['thumbnail', { active: index === selectedImageIndex }]" @click="selectImage(index)">
            <img :src="image.duongDanAnh" :alt="`Thumbnail ${index + 1}`" @error="handleImageError" />
          </div>
        </div>

        <div class="image-modal-counter">
          {{ selectedImageIndex + 1 }} / {{ currentProductImages.length }}
        </div>
      </div>
    </div>
  </div>

  <!-- Modern Coupon Selection Modal -->
  <div v-if="showCouponModal" class="modal-overlay" @click="closeCouponModal">
    <div class="coupon-selection-modal" @click.stop>
      <div class="coupon-modal-header">
        <div class="header-content">
          <div class="header-icon">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M21 12v-2a2 2 0 00-2-2H5a2 2 0 00-2 2v2" />
              <path d="M21 12v2a2 2 0 01-2 2H5a2 2 0 01-2-2v-2" />
              <circle cx="9" cy="12" r="1" />
              <circle cx="15" cy="12" r="1" />
            </svg>
          </div>
          <div class="header-text">
            <h3 class="modal-title">Chọn phiếu giảm giá</h3>
            <p class="modal-subtitle">
              Chọn phiếu giảm giá phù hợp cho đơn hàng của bạn
            </p>
          </div>
        </div>
        <button class="modern-close-btn" @click="closeCouponModal">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M18 6L6 18M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div class="coupon-modal-body">
        <!-- Current Applied Voucher Section -->
        <div v-if="autoAppliedCoupon || selectedCoupons.length > 0" class="current-voucher-section">
          <div class="current-voucher-card">
            <div class="current-voucher-header">
              <div class="current-voucher-icon">
                <img :src="GiftIcon" alt="Gift" width="20" height="20" />
              </div>
              <div class="current-voucher-text">
                <h4 class="current-voucher-title">
                  Phiếu giảm giá đang áp dụng
                </h4>
                <p class="current-voucher-subtitle">
                  Bạn có thể thay đổi hoặc hủy phiếu này
                </p>
              </div>
            </div>

            <div class="current-voucher-info">
              <div class="current-voucher-details">
                <div class="voucher-name">
                  {{
                    (autoAppliedCoupon || selectedCoupons[0])?.tenPhieuGiamGia
                  }}
                </div>
                <div class="voucher-discount">
                  <img :src="CelebrationIcon" alt="Celebration" width="16" height="16" class="discount-icon" />
                  <span v-if="
                    (autoAppliedCoupon || selectedCoupons[0])
                      ?.loaiPhieuGiamGia === false
                  ">
                    -{{
                      (autoAppliedCoupon || selectedCoupons[0])?.giaTriGiamGia
                    }}%
                  </span>
                  <span v-else>
                    -{{
                      formatCurrency(
                        (autoAppliedCoupon || selectedCoupons[0])?.giaTriGiamGia
                      )
                    }}
                  </span>
                </div>
              </div>

              <div class="voucher-status">
                <div class="status-indicator" :class="{
                  valid: canApplyCoupon(
                    autoAppliedCoupon || selectedCoupons[0]
                  ),
                  invalid: !canApplyCoupon(
                    autoAppliedCoupon || selectedCoupons[0]
                  ),
                }">
                  <span v-if="
                    canApplyCoupon(autoAppliedCoupon || selectedCoupons[0])
                  " class="status-text valid-text">
                    <img :src="CompletedIcon" alt="Valid" width="16" height="16" class="status-icon" />
                    Có thể sử dụng
                  </span>
                  <span v-else class="status-text invalid-text">
                    ❌ Không đủ điều kiện
                  </span>
                </div>
              </div>

              <div class="current-voucher-actions">
                <button class="change-voucher-btn" @click="scrollToVoucherList">
                  <img :src="EditIcon" alt="Edit" width="16" height="16" />
                  Thay đổi
                </button>
                <button class="remove-voucher-btn" @click="removeCurrentVoucher">
                  <img :src="TrashIcon" alt="Remove" width="16" height="16" />
                  Hủy phiếu
                </button>
              </div>
            </div>

            <!-- Validation Messages -->
            <div v-if="!canApplyCoupon(autoAppliedCoupon || selectedCoupons[0])" class="validation-messages">
              <div class="validation-item">
                <div class="validation-icon">
                  <img :src="WarningIcon" alt="Warning" width="14" height="14" />
                </div>
                <div class="validation-text">
                  <div v-if="
                    currentOrder?.tongTien <
                    (autoAppliedCoupon || selectedCoupons[0])?.hoaDonToiThieu
                  ">
                    Đơn hàng tối thiểu:
                    {{
                      formatCurrency(
                        (autoAppliedCoupon || selectedCoupons[0])
                          ?.hoaDonToiThieu
                      )
                    }}
                    (Hiện tại:
                    {{ formatCurrency(currentOrder?.tongTien || 0) }})
                  </div>
                  <div v-else>Phiếu giảm giá không còn hợp lệ</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="order-info-card">
          <div class="order-summary">
            <span class="order-label">Tổng đơn hàng:</span>
            <span class="order-amount">{{
              formatCurrency(currentOrder?.tongTien || 0)
              }}</span>
          </div>
        </div>

        <div class="coupon-grid">
          <div v-for="coupon in availableCoupons" :key="coupon.id" class="modern-coupon-card" :class="{
            selected: isCouponSelected(coupon.id),
            disabled: !canApplyCoupon(coupon),
            percentage: coupon.loaiPhieuGiamGia === false,
            fixed: coupon.loaiPhieuGiamGia === true,
          }" @click="
              canApplyCoupon(coupon) ? toggleCouponSelection(coupon) : null
              ">
            <div class="coupon-badge">
              <div class="discount-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path v-if="coupon.loaiPhieuGiamGia === false"
                    d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
                  <path v-else d="M12 2v20M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6" />
                </svg>
              </div>
              <div class="discount-value">
                <span v-if="coupon.loaiPhieuGiamGia === false" class="percentage-discount">
                  {{ coupon.giaTriGiamGia }}%
                </span>
                <span v-else class="fixed-discount">
                  {{ Math.round(coupon.giaTriGiamGia / 1000) }}K
                </span>
              </div>
            </div>

            <div class="coupon-content">
              <h4 class="coupon-name">{{ coupon.tenPhieuGiamGia }}</h4>

              <div class="coupon-details">
                <div class="discount-info">
                  <span v-if="coupon.loaiPhieuGiamGia === false" class="discount-text">
                    Giảm {{ coupon.giaTriGiamGia }}% đơn hàng
                  </span>
                  <span v-else class="discount-text">
                    Giảm {{ formatCurrency(coupon.giaTriGiamGia) }}
                  </span>
                  <div class="savings-amount">
                    Tiết kiệm:
                    {{ formatCurrency(calculateCouponDiscount(coupon)) }}
                  </div>
                </div>

                <div v-if="coupon.hoaDonToiThieu" class="min-order-requirement">
                  Đơn tối thiểu: {{ formatCurrency(coupon.hoaDonToiThieu) }}
                </div>
              </div>

              <div v-if="!canApplyCoupon(coupon)" class="unavailable-reason">
                <div class="reason-icon">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M15 9l-6 6M9 9l6 6" />
                  </svg>
                </div>
                <span v-if="
                  coupon.hoaDonToiThieu &&
                  currentOrder.tongTien < coupon.hoaDonToiThieu
                ">
                  Chưa đủ giá trị tối thiểu
                </span>
                <span v-else-if="
                  selectedCoupons.length > 0 &&
                  !selectedCoupons.some((c) => c.id === coupon.id)
                ">
                  Chỉ được chọn 1 phiếu
                </span>
                <span v-else>Phiếu không khả dụng</span>
              </div>
            </div>

            <div class="coupon-selection">
              <div class="custom-radio">
                <input type="radio" :id="'coupon-' + coupon.id" :name="'coupon-selection'"
                  :checked="isCouponSelected(coupon.id)" :disabled="!canApplyCoupon(coupon)"
                  @change="toggleCouponSelection(coupon)" />
                <label :for="'coupon-' + coupon.id" class="radio-label"></label>
              </div>
            </div>
          </div>

          <div v-if="availableCoupons.length === 0" class="no-coupons-state">
            <div class="empty-icon">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M21 12v-2a2 2 0 00-2-2H5a2 2 0 00-2 2v2" />
                <path d="M21 12v2a2 2 0 01-2 2H5a2 2 0 01-2-2v-2" />
                <circle cx="9" cy="12" r="1" />
                <circle cx="15" cy="12" r="1" />
              </svg>
            </div>
            <h4 class="empty-title">Chưa có phiếu giảm giá</h4>
            <p class="empty-description">
              Hiện tại không có phiếu giảm giá nào khả dụng cho đơn hàng này.
            </p>
          </div>
        </div>
      </div>

      <div class="coupon-modal-footer">
        <div class="selection-summary">
          <div class="selection-info">
            <span v-if="selectedCoupons.length > 0" class="selected-text">
              🎉 Đã chọn 1 phiếu giảm giá
            </span>
            <span v-else class="no-selection-text"> Chưa chọn phiếu nào </span>
          </div>
          <div v-if="selectedCoupons.length > 0" class="total-savings">
            Tiết kiệm:
            {{ formatCurrency(calculateCouponDiscount(selectedCoupons[0])) }}
          </div>
        </div>

        <div class="modal-actions">
          <button class="cancel-btn" @click="closeCouponModal">Hủy</button>
          <button class="confirm-btn" @click="confirmCouponSelection" :disabled="selectedCoupons.length === 0">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M20 6L9 17l-5-5" />
            </svg>
            {{ selectedCoupons.length > 0 ? "Xác nhận (1 phiếu)" : "Xác nhận" }}
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Notification Popup -->
  <div v-if="showNotification" class="notification-overlay" @click="showNotification = false">
    <div class="notification-modal" @click.stop>
      <div class="notification-content" :class="notificationType">
        <div class="notification-icon">
          <svg v-if="notificationType === 'success'" width="24" height="24" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
            <polyline points="22,4 12,14.01 9,11.01" />
          </svg>
          <svg v-else-if="notificationType === 'error'" width="24" height="24" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10" />
            <line x1="15" y1="9" x2="9" y2="15" />
            <line x1="9" y1="9" x2="15" y2="15" />
          </svg>
          <svg v-else-if="notificationType === 'warning'" width="24" height="24" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2">
            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
            <line x1="12" y1="9" x2="12" y2="13" />
            <line x1="12" y1="17" x2="12.01" y2="17" />
          </svg>
          <svg v-else width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10" />
            <path d="M12 16v-4M12 8h.01" />
          </svg>
        </div>
        <div class="notification-text">
          {{ notificationMessage }}
        </div>
        <button class="notification-close" @click="showNotification = false">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18" />
            <line x1="6" y1="6" x2="18" y2="18" />
          </svg>
        </button>
      </div>
    </div>
  </div>

  <!-- Modern QR Scanner Modal -->
  <div v-if="showQRScanner" class="modal-overlay" @click="closeQRScanner">
    <div class="qr-scanner-modal" @click.stop>
      <div class="qr-modal-header">
        <h3 class="modal-title">Quét mã QR sản phẩm</h3>
        <p class="modal-subtitle">Đưa mã QR vào khung hình để quét</p>
        <button class="modal-close-btn" @click="closeQRScanner">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M18 6L6 18M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div class="qr-modal-body">
        <div class="qr-scanner-container">
          <!-- Camera Preview -->
          <div class="camera-preview">
            <video 
              ref="qrVideo" 
              autoplay 
              playsinline 
              muted
              class="qr-video"
              @loadedmetadata="onVideoLoaded"
            ></video>
            <canvas ref="qrCanvas" class="qr-canvas"></canvas>
            
            <!-- Scanning overlay -->
            <div class="scanning-overlay">
              <div class="scanning-frame">
                <div class="corner-tl"></div>
                <div class="corner-tr"></div>
                <div class="corner-bl"></div>
                <div class="corner-br"></div>
                <div class="scanning-line" :class="{ active: isScanning }"></div>
              </div>
              <p class="scanning-text">
                {{ isScanning ? 'Đang quét...' : cameraError ? cameraError : 'Đưa mã QR vào khung hình' }}
              </p>
            </div>
          </div>

          <!-- QR Scanner Controls -->
          <div class="qr-controls">
            <div class="control-buttons">
              <button 
                class="control-btn" 
                @click="toggleCamera" 
                :disabled="!hasMultipleCameras"
                :class="{ disabled: !hasMultipleCameras }"
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m0 0V11a1 1 0 011-1h2a1 1 0 011 1v10m0 0h3a1 1 0 001-1V10M13 7h.01" />
                </svg>
                <span>Đổi camera</span>
              </button>
              
              <button class="control-btn" @click="toggleTorch" v-if="torchSupported">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M9 12l2 2 4-4" v-if="torchEnabled" />
                  <circle cx="12" cy="12" r="3" />
                  <path d="M12 1v6m0 6v6m11-7h-6m-6 0H1" />
                </svg>
                <span>{{ torchEnabled ? 'Tắt đèn pin' : 'Bật đèn pin' }}</span>
              </button>

              <button class="control-btn secondary" @click="closeQRScanner">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>
                <span>Đóng</span>
              </button>
            </div>
          </div>

          <!-- QR Result -->
          <div v-if="qrResult" class="qr-result">
            <div class="result-header">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="success-icon">
                <polyline points="20,6 9,17 4,12"></polyline>
              </svg>
              <h4>Quét thành công!</h4>
            </div>
            <div class="result-content">
              <p class="result-text">Mã QR: <strong>{{ qrResult }}</strong></p>
              <div class="result-actions">
                <button class="result-btn primary" @click="addProductFromQR">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 5v14M5 12h14" />
                  </svg>
                  Thêm vào giỏ hàng
                </button>
                <button class="result-btn secondary" @click="scanAgain">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="23,4 23,10 17,10"></polyline>
                    <polyline points="1,20 1,14 7,14"></polyline>
                    <path d="M20.49,9A9,9,0,0,0,5.64,5.64L1,10m22,4L18.36,18.36A9,9,0,0,1,3.51,15"></path>
                  </svg>
                  Quét lại
                </button>
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
import CelebrationIcon from "@/assets/Celebration.svg?url";
import CompletedIcon from "@/assets/Completed.svg?url";
import EditIcon from "@/assets/Edit.svg?url";
import GiftIcon from "@/assets/Gift.svg?url";
import PlusIcon from "@/assets/Plus.svg?url";
import ShoppingCartIcon from "@/assets/ShoppingCart.svg?url";
import TrashIcon from "@/assets/Trash.svg?url";
import WarningIcon from "@/assets/Warning.svg?url";

import { computed, nextTick, onMounted, onUnmounted, ref, watch } from "vue";
import {
  getDistricts,
  getProvinces,
  getWards,
} from "../../services/AddressService";
import { fetchCreateHoaDonChiTiet } from "../../services/BanHang/HoaDonChiTietService";
import {
  fetchActivePhieuGiamGiaForCustomer,
  fetchAllPhieuGiamGia,
} from "../../services/GiamGia/PhieuGiamGiaService";
import { fetchCreateDiaChiKhachHang } from "../../services/KhachHang/DiaChiKhachHangService";
import {
  fetchAllKhachHang,
  fetchQuickAddKhachHang,
  fetchUpdateKhachHang,
} from "../../services/KhachHang/KhachHangService";
import {
  fetchAllChiTietSanPham,
  fetchChiTietSanPhamWithInventory,
} from "../../services/SanPham/ChiTietSanPhamService";
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
const showQRScanner = ref(false);
const productSearchQuery = ref("");
const customerSearchQuery = ref("");
const customerDisplayName = ref(""); // Hiển thị tên khách hàng trong input
const customerSuggestions = ref([]); // Danh sách gợi ý khách hàng
const showCustomerDropdown = ref(false); // Hiển thị dropdown suggestions
let searchTimeout = null; // Timeout for debouncing search

// QR Scanner variables
const qrVideo = ref(null);
const qrCanvas = ref(null);
const qrResult = ref("");
const isScanning = ref(false);
const cameraError = ref("");
const hasMultipleCameras = ref(false);
const torchSupported = ref(false);
const torchEnabled = ref(false);
const currentCameraIndex = ref(0);
let qrStream = null;
let qrCodeReader = null;
let animationFrameId = null;
let availableCameras = [];

// Notification popup
const showNotification = ref(false);
const notificationMessage = ref("");
const notificationType = ref("info"); // success, error, warning, info

// Function to show notification
const showNotificationPopup = (message, type = "info") => {
  notificationMessage.value = message;
  notificationType.value = type;
  showNotification.value = true;

  // Auto hide after 5 seconds for success and info, 8 seconds for error and warning
  const duration = type === "success" || type === "info" ? 5000 : 8000;
  setTimeout(() => {
    showNotification.value = false;
  }, duration);
};

// QR Scanner Functions
const initCamera = async () => {
  try {
    cameraError.value = "";
    isScanning.value = false;
    
    // Get available cameras
    const devices = await navigator.mediaDevices.enumerateDevices();
    availableCameras = devices.filter(device => device.kind === 'videoinput');
    hasMultipleCameras.value = availableCameras.length > 1;
    
    if (availableCameras.length === 0) {
      cameraError.value = "Không tìm thấy camera";
      return;
    }

    // Setup camera constraints
    const constraints = {
      video: {
        deviceId: availableCameras[currentCameraIndex.value]?.deviceId,
        facingMode: availableCameras.length > 1 ? 'environment' : 'user',
        width: { ideal: 1920 },
        height: { ideal: 1080 }
      }
    };

    // Check for torch support
    const track = qrStream?.getVideoTracks()[0];
    if (track && 'torch' in track.getSettings()) {
      torchSupported.value = true;
    }

    qrStream = await navigator.mediaDevices.getUserMedia(constraints);
    qrVideo.value.srcObject = qrStream;
    
  } catch (error) {
    console.error("Camera initialization error:", error);
    if (error.name === 'NotAllowedError') {
      cameraError.value = "Vui lòng cho phép truy cập camera";
    } else if (error.name === 'NotFoundError') {
      cameraError.value = "Không tìm thấy camera";
    } else {
      cameraError.value = "Lỗi kết nối camera";
    }
  }
};

const onVideoLoaded = () => {
  if (qrVideo.value && qrCanvas.value) {
    const video = qrVideo.value;
    const canvas = qrCanvas.value;
    const context = canvas.getContext('2d');
    
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    
    isScanning.value = true;
    startScanning(context, canvas, video);
  }
};

const startScanning = (context, canvas, video) => {
  const scan = () => {
    if (!isScanning.value || !showQRScanner.value) {
      return;
    }

    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
    
    // Simple QR detection using cross-platform approach
    const qrCode = detectQRCode(imageData);
    
    if (qrCode) {
      qrResult.value = qrCode;
      isScanning.value = false;
      showNotificationPopup("Quét QR thành công!", "success");
    } else {
      animationFrameId = requestAnimationFrame(scan);
    }
  };
  
  scan();
};

// Cross-platform QR detection (simplified implementation)
const detectQRCode = (imageData) => {
  // This is a simplified QR detection
  // In production, you should use a proper QR code library like jsQR
  try {
    // Import jsQR dynamically for better cross-platform support
    if (typeof window !== 'undefined' && window.jsQR) {
      const code = window.jsQR(imageData.data, imageData.width, imageData.height);
      return code ? code.data : null;
    }
    
    // Fallback: simulate QR detection for testing
    // Remove this in production and use proper QR library
    const mockQRCodes = ['PRODUCT123', 'PRODUCT456', 'PRODUCT789'];
    return Math.random() < 0.1 ? mockQRCodes[Math.floor(Math.random() * mockQRCodes.length)] : null;
    
  } catch (error) {
    console.error("QR detection error:", error);
    return null;
  }
};

const toggleCamera = async () => {
  if (hasMultipleCameras.value && availableCameras.length > 1) {
    currentCameraIndex.value = (currentCameraIndex.value + 1) % availableCameras.length;
    await stopCamera();
    await initCamera();
  }
};

const toggleTorch = async () => {
  if (torchSupported.value && qrStream) {
    try {
      const track = qrStream.getVideoTracks()[0];
      const capabilities = track.getCapabilities();
      
      if (capabilities.torch) {
        await track.applyConstraints({
          advanced: [{ torch: !torchEnabled.value }]
        });
        torchEnabled.value = !torchEnabled.value;
      }
    } catch (error) {
      console.error("Torch toggle error:", error);
      showNotificationPopup("Không thể bật/tắt đèn pin", "error");
    }
  }
};

const stopCamera = async () => {
  if (qrStream) {
    qrStream.getTracks().forEach(track => track.stop());
    qrStream = null;
  }
  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId);
    animationFrameId = null;
  }
  isScanning.value = false;
  torchEnabled.value = false;
};

const closeQRScanner = async () => {
  await stopCamera();
  showQRScanner.value = false;
  qrResult.value = "";
  cameraError.value = "";
};

const scanAgain = () => {
  qrResult.value = "";
  isScanning.value = true;
  if (qrVideo.value && qrCanvas.value) {
    const context = qrCanvas.value.getContext('2d');
    startScanning(context, qrCanvas.value, qrVideo.value);
  }
};

const addProductFromQR = async () => {
  try {
    if (!qrResult.value) {
      showNotificationPopup("Không có mã QR để thêm sản phẩm", "error");
      return;
    }

    // Find product by QR code (assuming QR contains product code)
    const product = chiTietSanPhams.value.find(p => 
      p.maSanPham === qrResult.value || 
      p.id.toString() === qrResult.value ||
      p.sanPham?.maSanPham === qrResult.value
    );

    if (!product) {
      showNotificationPopup(`Không tìm thấy sản phẩm với mã: ${qrResult.value}`, "error");
      return;
    }

    if (product.soLuong <= 0) {
      showNotificationPopup("Sản phẩm đã hết hàng", "warning");
      return;
    }

    // Add product to current order
    const order = currentOrder.value;
    if (!order) {
      showNotificationPopup("Vui lòng tạo đơn hàng trước", "error");
      return;
    }

    const existingItem = order.danhSachSanPham.find(item => item.id === product.id);
    
    if (existingItem) {
      // Update quantity if item already exists
      if (existingItem.soLuong < product.soLuong) {
        existingItem.soLuong += 1;
      } else {
        showNotificationPopup("Số lượng sản phẩm trong kho không đủ", "warning");
        return;
      }
    } else {
      // Add new item - using same structure as addProductToCart
      const newItem = {
        id: product.id,
        maSanPham: product.ma_san_pham || product.sanPham?.ma_san_pham || product.maSanPham || product.sanPham?.maSanPham || product.code || product.productCode || product.sku || `SP${String(product.id).padStart(5, '0')}`,
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
        selected: true,
      };
      order.danhSachSanPham.push(newItem);
    }

    updateOrderTotals();
    showNotificationPopup(`Đã thêm ${product.tenSanPham || 'sản phẩm'} vào giỏ hàng`, "success");
    closeQRScanner();
    
  } catch (error) {
    console.error("Error adding product from QR:", error);
    showNotificationPopup("Có lỗi xảy ra khi thêm sản phẩm", "error");
  }
};

// Watch for QR scanner modal open/close
watch(showQRScanner, async (newVal) => {
  if (newVal) {
    await nextTick();
    await initCamera();
  } else {
    await stopCamera();
  }
});

// Cleanup camera on component unmount
onUnmounted(async () => {
  await stopCamera();
});

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

// Address management
const provinces = ref([]);
const districts = ref([]);
const wards = ref([]);
const selectedProvinceCode = ref("");
const selectedDistrictCode = ref("");

// Thông tin gợi ý phiếu giảm giá tốt hơn
const betterCoupons = ref([]);
const showRecommendation = ref(false);

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

// Watcher: Sync autoAppliedCoupon with selectedCoupons when modal is open
watch(
  [autoAppliedCoupon, showCouponModal],
  ([newAutoApplied, modalOpen]) => {
    // Chỉ đồng bộ khi popup đang mở và có voucher tự động
    if (modalOpen && newAutoApplied) {
      console.log(
        `🔄 Đồng bộ voucher tự động trong popup: ${newAutoApplied.tenPhieuGiamGia}`
      );

      // Kiểm tra xem voucher tự động có khác với voucher hiện tại trong selectedCoupons không
      const currentSelected = selectedCoupons.value[0];
      if (!currentSelected || currentSelected.id !== newAutoApplied.id) {
        selectedCoupons.value = [newAutoApplied];
        console.log(`✅ Đã cập nhật selectedCoupons cho popup`);
      }
    }
  },
  { immediate: true }
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
const fullAddress = computed(() => {
  const addr = deliveryAddress.value;
  if (!addr.diaChiCuThe || !addr.thanhPho) return "";

  let address = addr.diaChiCuThe;
  if (addr.phuong) address += `, ${addr.phuong}`;
  if (addr.quan) address += `, ${addr.quan}`;
  if (addr.thanhPho) address += `, ${addr.thanhPho}`;

  return address;
});

// Function to calculate change for cash payment
const calculateChange = () => {
  if (!currentOrder.value) return;

  // Ensure tienKhachTra is a number
  if (typeof currentOrder.value.tienKhachTra !== "number") {
    currentOrder.value.tienKhachTra =
      parseFloat(currentOrder.value.tienKhachTra) || 0;
  }

  // Update order totals to ensure calculations are current
  updateOrderTotals();
};

const selectedSize = ref("");
const selectedDeGiay = ref("");
const selectedMauSac = ref("");
const selectedKichThuoc = ref("");
const selectedPriceMax = ref(10000000);

// Shipping carrier variables
const selectedShippingCarrier = ref("");
const selectedServiceType = ref("");
const shippingFee = ref(0);

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
  } catch (error) { }
};
const fetchCreateOrderDetail = async (id) => {
  try {
    let res3 = await fetchActivePhieuGiamGiaForCustomer(id);
    PhieuGiamGias.value = res3.data;
  } catch (error) { }
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

    // Lấy địa chỉ mặc định từ khách hàng được chọn
    let defaultCustomerAddress = "";
    let defaultCustomerPhone = "";
    let defaultCustomerEmail = "";

    if (order.idKhachHang) {
      const customer = KhachHangs.value.find((c) => c.id === order.idKhachHang);
      if (customer) {
        // Lấy địa chỉ đầu tiên từ listDiaChi làm địa chỉ mặc định
        if (customer.listDiaChi && customer.listDiaChi.length > 0) {
          const firstAddress = customer.listDiaChi[0];
          if (firstAddress.diaChiCuThe || firstAddress.thanhPho) {
            // Format địa chỉ theo chuẩn Việt Nam
            const diaChiParts = [
              firstAddress.diaChiCuThe,
              firstAddress.phuong,
              firstAddress.quan,
              firstAddress.thanhPho,
            ].filter((part) => part && part.trim() !== "");

            defaultCustomerAddress = diaChiParts.join(", ");
            console.log(
              "🏠 Đã lấy địa chỉ mặc định từ khách hàng:",
              defaultCustomerAddress
            );
          }
        } else {
          console.log("⚠️ Khách hàng không có địa chỉ nào trong hệ thống");
        }
        defaultCustomerPhone = customer.soDienThoai || "";
        defaultCustomerEmail = customer.email || "";
      }
    }

    // If delivery is selected, use delivery address form data
    if (order.ghiChu === "delivery" && isAddressComplete.value) {
      tenNguoiNhan = deliveryAddress.value.tenNguoiNhan;
      soDienThoaiNguoiNhan = deliveryAddress.value.soDienThoaiNguoiNhan;
      emailNguoiNhan = deliveryAddress.value.emailNguoiNhan;

      // Format địa chỉ đầy đủ theo chuẩn Việt Nam
      const diaChiParts = [
        deliveryAddress.value.diaChiCuThe,
        deliveryAddress.value.phuong,
        deliveryAddress.value.quan,
        deliveryAddress.value.thanhPho,
      ].filter((part) => part && part.trim() !== "");

      diaChiNhanHang = diaChiParts.join(", ");
      console.log("🚚 Đã tạo địa chỉ giao hàng từ form:", diaChiNhanHang);
    } else if (order.idKhachHang && defaultCustomerAddress) {
      // Ngay cả khi bán tại quầy, vẫn lấy địa chỉ khách hàng nếu có
      diaChiNhanHang = defaultCustomerAddress;
      tenNguoiNhan = customerDisplayName.value;
      soDienThoaiNguoiNhan = defaultCustomerPhone;
      emailNguoiNhan = defaultCustomerEmail;
      console.log(
        "🏪 Bán tại quầy - Sử dụng địa chỉ khách hàng:",
        diaChiNhanHang
      );
    }

    // Tạo payload theo cấu trúc BanHangTaiQuayRequest
    const payload = {
      // IDs
      idKhachHang: order.idKhachHang,
      idNhanVien: 1, // ID nhân viên hiện tại
      idPhuongThucThanhToan: getPaymentMethodId(order.phuongThucThanhToan),
      idTrangThaiDonHang: 2, // Trạng thái đơn hàng: 2 = Đã xác nhận

      // Danh sách sản phẩm
      danhSachSanPham: danhSachSanPhamMap, // HashMap<Integer, Integer>

      // Thông tin tiền (bao gồm phí giao hàng)
      phiVanChuyen: order.phiVanChuyen || 0,
      tongTien: order.tongTien || 0,
      tongTienSauGiam: order.tongTienSauGiam || 0, // Đã bao gồm phí giao hàng

      // Thông tin giao hàng - Map với BanHangTaiQuayRequest
      tenNguoiNhan:
        tenNguoiNhan || order.tenNguoiNhan || customerDisplayName.value,
      diaChiNhanHang:
        diaChiNhanHang || order.diaChiNhanHang || defaultCustomerAddress, // Format: "địa chỉ cụ thể, phường, quận, thành phố"
      soDienThoaiNguoiNhan:
        soDienThoaiNguoiNhan ||
        order.soDienThoaiNguoiNhan ||
        defaultCustomerPhone,
      emailNguoiNhan:
        emailNguoiNhan || order.emailNguoiNhan || defaultCustomerEmail,

      // Thời gian
      ngayTao: order.ngayTao
        ? order.ngayTao.toISOString().split("T")[0]
        : new Date().toISOString().split("T")[0],
      ngayThanhToan: order.ngayThanhToan
        ? order.ngayThanhToan.toISOString().split("T")[0]
        : new Date().toISOString().split("T")[0],

      // Cấu hình
      loaiDon: false, // 0 = Bán hàng tại quầy
      trangThai: true, // true = Active
      deleted: false, // false = Chưa xóa

      // Ghi chú
      ghiChu: order.selectedService
        ? `${order.ghiChu} - ${order.selectedService.name} (${order.selectedService.deliveryTime})`
        : order.ghiChu || "",
    };

    // Chỉ thêm idPhieuGiamGia nếu có giá trị
    if (selectedCoupons.value && selectedCoupons.value.length > 0) {
      payload.idPhieuGiamGia = selectedCoupons.value[0].id;
    }

    // Validation theo BanHangTaiQuayRequest
    if (!payload.idKhachHang) {
      throw new Error("Thiếu thông tin khách hàng");
    }
    if (!payload.idNhanVien) {
      throw new Error("Thiếu thông tin nhân viên");
    }
    if (
      !payload.danhSachSanPham ||
      Object.keys(payload.danhSachSanPham).length === 0
    ) {
      throw new Error("Giỏ hàng trống");
    }
    if (payload.tongTien === null || payload.tongTien === undefined) {
      throw new Error("Thiếu thông tin tổng tiền");
    }
    if (payload.loaiDon === null || payload.loaiDon === undefined) {
      throw new Error("Thiếu thông tin loại đơn");
    }

    // Debug chi tiết payload trước khi gửi API
    console.log("📤 ===== DEBUG PAYLOAD GỬI LÊN BACKEND =====");
    console.log("📋 Thông tin cơ bản:");
    console.log("- ID Khách hàng:", payload.idKhachHang);
    console.log("- ID Nhân viên:", payload.idNhanVien);
    console.log("- ID Phương thức thanh toán:", payload.idPhuongThucThanhToan);
    console.log("- ID Trạng thái đơn hàng:", payload.idTrangThaiDonHang);

    console.log("🛒 Danh sách sản phẩm:", payload.danhSachSanPham);

    console.log("💰 Thông tin tiền:");
    console.log("- Phí vận chuyển:", formatCurrency(payload.phiVanChuyen));
    console.log("- Tổng tiền hàng:", formatCurrency(payload.tongTien));
    console.log(
      "- Tổng tiền sau giảm:",
      formatCurrency(payload.tongTienSauGiam)
    );
    console.log(
      "- Phí giao hàng đã bao gồm trong tổng tiền sau giảm:",
      payload.tongTienSauGiam >= payload.tongTien ? "Có" : "Không"
    );

    console.log("📍 Thông tin giao hàng:");
    console.log("- Tên người nhận:", payload.tenNguoiNhan);
    console.log("- Địa chỉ nhận hàng:", payload.diaChiNhanHang);
    console.log("- SĐT người nhận:", payload.soDienThoaiNguoiNhan);
    console.log("- Email người nhận:", payload.emailNguoiNhan);

    console.log("📅 Thời gian:");
    console.log("- Ngày tạo:", payload.ngayTao);
    console.log("- Ngày thanh toán:", payload.ngayThanhToan);

    console.log("⚙️ Cấu hình:");
    console.log("- Loại đơn:", payload.loaiDon ? "Giao hàng" : "Bán tại quầy");
    console.log("- Trạng thái:", payload.trangThai ? "Active" : "Inactive");
    console.log("- Deleted:", payload.deleted);

    console.log("📝 Thông tin khác:");
    console.log("- Ghi chú:", payload.ghiChu);
    console.log("- ID Phiếu giảm giá:", payload.idPhieuGiamGia || "Không có");

    console.log("🔍 Payload đầy đủ:", payload);
    console.log("===========================================");
    console.log("🔗 Mapping với BanHangTaiQuayRequest:");
    console.log("- idKhachHang:", payload.idKhachHang);
    console.log(
      "- danhSachSanPham:",
      Object.keys(payload.danhSachSanPham || {}).length,
      "sản phẩm"
    );
    console.log("- diaChiNhanHang:", payload.diaChiNhanHang);
    console.log("- loaiDon:", payload.loaiDon, "(false = bán hàng tại quầy)");

    // Gửi API tạo hóa đơn
    const response = await fetch(
      "http://localhost:8080/api/hoa-don-management/add",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      }
    );

    if (!response.ok) {
      throw new Error("Không thể tạo hóa đơn");
    }

    const result = await response.json();
    const hoaDonResponse = result.data;
    const hoaDonId = hoaDonResponse.id;

    console.log("✅ Đã tạo hóa đơn thành công với ID:", hoaDonId);

    // Tạo chi tiết sản phẩm cho từng sản phẩm trong giỏ hàng
    console.log("🔄 Bắt đầu tạo chi tiết sản phẩm...");
    const orderItems = currentOrder.value.danhSachSanPham;

    for (const item of orderItems) {
      const hoaDonChiTietPayload = {
        idHoaDon: hoaDonId,
        idChiTietSanPham: item.id,
        soLuong: item.soLuong,
        giaBan: item.giaSauGiam || item.giaBan,
        thanhTien: (item.giaSauGiam || item.giaBan) * item.soLuong,
        trangThai: true,
        deleted: false,
        ghiChu: `Chi tiết sản phẩm: ${item.tenSanPham || "Sản phẩm"}`,
      };

      console.log("📦 Tạo chi tiết sản phẩm:", hoaDonChiTietPayload);

      try {
        await fetchCreateHoaDonChiTiet(hoaDonChiTietPayload);
        console.log(
          `✅ Đã tạo chi tiết sản phẩm cho ${item.tenSanPham || "Sản phẩm"}`
        );
      } catch (detailError) {
        console.error("❌ Lỗi khi tạo chi tiết sản phẩm:", detailError);
        // Không throw error để không dừng quá trình tạo hóa đơn
      }
    }

    console.log("🎉 Hoàn thành tạo chi tiết sản phẩm cho hóa đơn:", hoaDonId);
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

const switchOrder = async (orderId) => {
  currentOrderId.value = orderId;

  // Khi chuyển đổi đơn hàng, load phiếu giảm giá cho khách hàng của đơn hàng mới
  const order = currentOrder.value;
  if (order && order.idKhachHang) {
    await loadCouponsForCustomer(order.idKhachHang);

    // Tự động áp dụng phiếu giảm giá tốt nhất cho đơn hàng mới
    if (order.tongTien > 0) {
      setTimeout(() => {
        autoApplyBestCoupon();
      }, 100);
    }
  } else {
    // Nếu không có khách hàng, load tất cả phiếu giảm giá
    await loadAllCoupons();
  }
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

const addProductToCart = async (product) => {
  const order = currentOrder.value;

  if (!order) {
    console.error("❌ No current order found!");
    return;
  }

  if (!order.danhSachSanPham) {
    order.danhSachSanPham = [];
  }

  try {
    // Kiểm tra số lượng còn lại trong kho
    const chiTietSanPham = await fetchChiTietSanPhamWithInventory(product.id);

    // Kiểm tra sản phẩm có trạng thái active không
    if (!chiTietSanPham.trangThai) {
      showNotificationPopup(
        "Sản phẩm này hiện không khả dụng để bán!",
        "error"
      );
      return;
    }

    // Tính tổng số lượng đã có trong giỏ hàng
    const existingItem = order.danhSachSanPham.find(
      (item) => item.id === product.id
    );

    const currentQuantityInCart = existingItem ? existingItem.soLuong : 0;
    const requestedQuantity = currentQuantityInCart + 1;

    // Kiểm tra số lượng có đủ không
    if (
      chiTietSanPham.soLuong === null ||
      chiTietSanPham.soLuong === undefined ||
      chiTietSanPham.soLuong < requestedQuantity
    ) {
      showNotificationPopup(
        `Không đủ số lượng sản phẩm "${product.tenSanPham}".\nCòn lại: ${chiTietSanPham.soLuong || 0
        }, yêu cầu: ${requestedQuantity}`,
        "warning"
      );
      return;
    }

    if (existingItem) {
      // Nếu sản phẩm đã có trong giỏ hàng, tăng số lượng lên 1
      existingItem.soLuong += 1;
    } else {
      // Nếu sản phẩm chưa có, thêm mới vào giỏ hàng
      const newItem = {
        id: product.id,
        maSanPham: product.ma_san_pham || product.sanPham?.ma_san_pham || product.maSanPham || product.sanPham?.maSanPham || product.code || product.productCode || product.sku || `SP${String(product.id).padStart(5, '0')}`,
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
  } catch (error) {
    console.error("❌ Lỗi khi thêm sản phẩm vào giỏ hàng:", error);
    showNotificationPopup(
      "Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng. Vui lòng thử lại!",
      "error"
    );
  }
};

const updateQuantity = async (item, change) => {
  const newQuantity = Math.max(1, item.soLuong + change);

  // Kiểm tra nếu số lượng không thay đổi thì không cần làm gì
  if (newQuantity === item.soLuong) {
    return;
  }

  try {
    // Kiểm tra số lượng còn lại trong kho khi tăng số lượng
    if (change > 0) {
      const chiTietSanPham = await fetchChiTietSanPhamWithInventory(item.id);

      // Kiểm tra sản phẩm có trạng thái active không
      if (!chiTietSanPham.trangThai) {
        showNotificationPopup(
          "Sản phẩm này hiện không khả dụng để bán!",
          "error"
        );
        return;
      }

      // Kiểm tra số lượng có đủ không
      if (
        chiTietSanPham.soLuong === null ||
        chiTietSanPham.soLuong === undefined ||
        chiTietSanPham.soLuong < newQuantity
      ) {
        showNotificationPopup(
          `Không đủ số lượng sản phẩm "${item.tenSanPham}".\nCòn lại: ${chiTietSanPham.soLuong || 0
          }, yêu cầu: ${newQuantity}`,
          "warning"
        );
        return;
      }
    }

    item.soLuong = newQuantity;
    updateOrderTotals();

    // Tự động áp dụng phiếu giảm giá tốt nhất sau khi thay đổi số lượng
    // Chỉ áp dụng nếu có thay đổi về tổng tiền
    const order = currentOrder.value;
    if (order && order.tongTien > 0) {
      setTimeout(() => {
        autoApplyBestCoupon();
      }, 100);
    }
  } catch (error) {
    console.error("❌ Lỗi khi cập nhật số lượng:", error);
    showNotificationPopup(
      "Có lỗi xảy ra khi cập nhật số lượng. Vui lòng thử lại!",
      "error"
    );
  }
};

// Function to validate inventory for all items in cart before creating order
const validateCartInventory = async () => {
  const order = currentOrder.value;
  if (!order || !order.danhSachSanPham || order.danhSachSanPham.length === 0) {
    return;
  }

  console.log(
    "🔍 Đang validate số lượng cho",
    order.danhSachSanPham.length,
    "sản phẩm trong giỏ hàng"
  );

  for (const item of order.danhSachSanPham) {
    try {
      console.log(`🔍 Kiểm tra sản phẩm: ${item.tenSanPham} (ID: ${item.id})`);

      // Lấy thông tin sản phẩm từ server
      const chiTietSanPham = await fetchChiTietSanPhamWithInventory(item.id);

      // Kiểm tra sản phẩm có tồn tại không
      if (!chiTietSanPham) {
        throw new Error(
          `Không tìm thấy sản phẩm ${item.tenSanPham} trong hệ thống`
        );
      }

      // Kiểm tra trạng thái sản phẩm
      if (!chiTietSanPham.trangThai) {
        throw new Error(
          `Sản phẩm "${item.tenSanPham}" hiện không khả dụng để bán`
        );
      }

      // Kiểm tra số lượng
      const availableStock = chiTietSanPham.soLuong || 0;
      if (availableStock < item.soLuong) {
        throw new Error(
          `Không đủ số lượng sản phẩm "${item.tenSanPham}".\n` +
          `Yêu cầu: ${item.soLuong}, Còn lại: ${availableStock}`
        );
      }

      console.log(
        `✅ Sản phẩm "${item.tenSanPham}" - Còn: ${availableStock}, Yêu cầu: ${item.soLuong} ✓`
      );
    } catch (error) {
      console.error(`❌ Lỗi validate sản phẩm ${item.tenSanPham}:`, error);
      showNotificationPopup(error.message, "error");
      throw error; // Re-throw to stop order creation
    }
  }

  console.log("🎉 Tất cả sản phẩm trong giỏ hàng đã được validate thành công!");
};

const removeItem = (item) => {
  const order = currentOrder.value;
  if (!order) return;

  const index = order.danhSachSanPham.findIndex((i) => i.id === item.id);
  if (index > -1) {
    order.danhSachSanPham.splice(index, 1);
    updateOrderTotals();

    // Nếu xóa hết sản phẩm, reset phiếu giảm giá
    if (order.danhSachSanPham.length === 0) {
      selectedCoupons.value = [];
      autoAppliedCoupon.value = null;
      console.log("🚫 Đã xóa hết sản phẩm, reset phiếu giảm giá");
    } else {
      // Tự động áp dụng phiếu giảm giá tốt nhất sau khi xóa sản phẩm
      setTimeout(() => {
        autoApplyBestCoupon();
      }, 100);
    }
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

  // Debug: Log chi tiết từng sản phẩm
  console.log("🔍 CHI TIẾT TÍNH TỔNG TIỀN HÀNG GỐC:");
  order.danhSachSanPham.forEach((item, index) => {
    console.log(
      `  ${index + 1}. ${item.tenSanPham}: ${formatCurrency(item.giaBan)} × ${item.soLuong
      } = ${formatCurrency(item.giaBan * item.soLuong)}`
    );
  });
  console.log(`  → TỔNG TIỀN HÀNG GỐC: ${formatCurrency(tongTienGoc)}`);
  console.log(
    `  → CHECK FREE SHIP: ${tongTienGoc} >= 2000000 = ${tongTienGoc >= 2000000 ? "✅ Đủ điều kiện" : "❌ Chưa đủ"
    }`
  );
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

  // Tính tiền hàng sau giảm giá sản phẩm (hiển thị)
  order.tongTien = order.danhSachSanPham.reduce(
    (sum, item) => sum + item.giaSauGiam * item.soLuong,
    0
  );

  // Tạm thời set phí giao hàng = 0 để tính giảm giá trước
  order.phiVanChuyen = 0;

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

  // Tính tổng tiền sau giảm giá (chưa bao gồm phí giao hàng)
  const tongTienSauGiamChuaPhi = order.tongTien - finalDiscount;

  // Tính phí vận chuyển dựa trên tổng tiền hàng gốc (chưa giảm voucher)
  const tongTienHangGoc = tongTienGoc; // tongTienGoc đã được tính ở trên

  console.log("🔍 DEBUG PHÍ VẬN CHUYỂN:");
  console.log(
    "- Tổng tiền hàng gốc (chưa giảm):",
    formatCurrency(tongTienHangGoc)
  );
  console.log(
    "- Tổng tiền sau giảm voucher:",
    formatCurrency(tongTienSauGiamChuaPhi)
  );
  console.log(
    "- Đủ điều kiện miễn phí (tổng gốc >= 2tr):",
    tongTienHangGoc >= 2000000 ? "✅ Có" : "❌ Không"
  );

  // Calculate shipping fee based on delivery type and selected service
  if (order.ghiChu === "delivery") {
    if (order.selectedService) {
      order.phiVanChuyen = order.selectedService.fee || 0;
      console.log(
        "🚚 Phí giao hàng ban đầu:",
        formatCurrency(order.phiVanChuyen)
      );
      console.log(
        "🚚 Selected service fee:",
        formatCurrency(order.selectedService.fee || 0)
      );

      // Miễn phí giao hàng nếu tổng tiền hàng gốc >= 2 triệu (CHƯA GIẢM VOUCHER)
      console.log("🔍 CHECK MIỄN PHÍ TRONG updateOrderTotals:");
      console.log("- tongTienHangGoc:", tongTienHangGoc);
      console.log(
        "- Condition: tongTienHangGoc >= 2000000 =",
        tongTienHangGoc >= 2000000
      );
      console.log("- Giá trị so sánh: 2000000");
      console.log("- Kết quả so sánh:", tongTienHangGoc >= 2000000);

      if (tongTienHangGoc >= 2000000) {
        order.phiVanChuyen = 0;
        console.log("🎉 Tổng tiền hàng gốc trên 2 triệu - MIỄN PHÍ giao hàng!");
      } else {
        console.log(
          "💰 Tổng tiền hàng gốc dưới 2 triệu - Áp dụng phí giao hàng:",
          formatCurrency(order.phiVanChuyen)
        );
        console.log("   → tongTienHangGoc =", tongTienHangGoc, "< 2000000");
      }
    } else {
      // Nếu chưa chọn dịch vụ cụ thể, set phí mặc định
      order.phiVanChuyen = 0; // Sẽ được cập nhật khi chọn dịch vụ
      console.log("📦 Chưa chọn dịch vụ giao hàng - Phí tạm thời: 0đ");
    }
  } else {
    order.phiVanChuyen = 0;
    console.log("🏪 Bán tại quầy - Không có phí giao hàng");
  }

  console.log("🎯 KẾT QUẢ CUỐI CÙNG TRONG updateOrderTotals:");
  console.log("- order.phiVanChuyen:", formatCurrency(order.phiVanChuyen));
  console.log("- order.ghiChu:", order.ghiChu);
  console.log(
    "- order.selectedService:",
    order.selectedService ? "Có" : "Không"
  );

  // Tính tổng tiền sau giảm (bao gồm phí giao hàng)
  const tongTienSauGiam = tongTienSauGiamChuaPhi + order.phiVanChuyen;
  order.tongTienSauGiam = tongTienSauGiam;

  // Debug logging cho việc tính tổng tiền
  console.log("💵 CHI TIẾT TÍNH TIỀN:");
  console.log("- Tổng tiền hàng gốc:", formatCurrency(tongTienHangGoc));
  console.log(
    "- Tổng tiền hàng (sau giảm sản phẩm):",
    formatCurrency(order.tongTien)
  );
  console.log("- Giảm giá voucher:", formatCurrency(finalDiscount));
  console.log(
    "- Tổng tiền sau giảm voucher:",
    formatCurrency(tongTienSauGiamChuaPhi)
  );
  console.log("- Phí giao hàng:", formatCurrency(order.phiVanChuyen));
  console.log(
    "- Thành tiền (bao gồm phí ship):",
    formatCurrency(tongTienSauGiam)
  );
  console.log(
    "- Miễn phí giao hàng:",
    tongTienHangGoc >= 2000000 ? "✅ Có" : "❌ Không"
  );
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
};

// Function tính toán lợi ích của phiếu giảm giá
const calculateCouponBenefit = (coupon, orderTotal) => {
  if (!coupon || !orderTotal || orderTotal <= 0)
    return { discountAmount: 0, benefit: 0, priority: 0 };

  let discountAmount = 0;
  let priority = 0;

  // Đảm bảo orderTotal là số
  const total = Number(orderTotal) || 0;

  if (coupon.loaiPhieuGiamGia === false) {
    // Giảm theo phần trăm
    const percentValue = Number(coupon.giaTriGiamGia) || 0;
    discountAmount = Math.round((total * percentValue) / 100);
    priority = percentValue; // Ưu tiên phần trăm cao hơn (10% > 5%)
  } else if (coupon.loaiPhieuGiamGia === true) {
    // Giảm số tiền cố định
    discountAmount = Number(coupon.giaTriGiamGia) || 0;
    priority = discountAmount / 1000; // Chuẩn hóa để so sánh với phần trăm (200k = priority 200)
  }

  // Đảm bảo giảm giá không vượt quá tổng tiền
  discountAmount = Math.min(discountAmount, total);

  // Tăng ưu tiên mạnh cho phiếu dành riêng cho khách hàng
  if (
    coupon.idKhachHang &&
    coupon.idKhachHang === currentOrder.value?.idKhachHang
  ) {
    priority += 10000; // Bonus rất cao cho phiếu cá nhân (ưu tiên tuyệt đối)
  }

  return {
    discountAmount,
    benefit: discountAmount, // Số tiền giảm thực tế = benefit chính
    priority,
    coupon,
  };
};

// Function tìm phiếu giảm giá tốt nhất có thể đạt được
const findBestAvailableCoupon = (orderTotal) => {
  if (!availableCoupons.value || availableCoupons.value.length === 0)
    return null;

  const validCoupons = availableCoupons.value.filter((coupon) => {
    // Kiểm tra trạng thái active
    if (coupon.trangThai !== true) return false;

    // Kiểm tra yêu cầu tối thiểu
    if (coupon.hoaDonToiThieu && orderTotal < coupon.hoaDonToiThieu)
      return false;

    // Kiểm tra khách hàng cụ thể
    if (
      coupon.idKhachHang &&
      currentOrder.value?.idKhachHang &&
      coupon.idKhachHang !== currentOrder.value.idKhachHang
    )
      return false;

    // Kiểm tra ngày hết hạn
    if (coupon.ngayKetThuc) {
      const expiryDate = new Date(coupon.ngayKetThuc);
      const now = new Date();
      if (expiryDate < now) return false;
    }

    return true;
  });

  if (validCoupons.length === 0) return null;

  // Tính lợi ích cho từng phiếu
  const couponBenefits = validCoupons.map((coupon) =>
    calculateCouponBenefit(coupon, orderTotal)
  );

  // Sắp xếp theo lợi ích thực tế giảm dần (ưu tiên giảm nhiều tiền nhất)
  couponBenefits.sort((a, b) => {
    // Ưu tiên phiếu giảm được nhiều tiền nhất trước
    if (b.benefit !== a.benefit) {
      return b.benefit - a.benefit;
    }
    // Nếu giảm bằng nhau thì ưu tiên phiếu cá nhân, sau đó ưu tiên cao hơn
    if (b.priority !== a.priority) {
      return b.priority - a.priority;
    }
    // Nếu vẫn bằng thì ưu tiên phiếu có hạn sử dụng gần hơn
    const aExpiry = a.coupon.ngayKetThuc
      ? new Date(a.coupon.ngayKetThuc)
      : new Date(9999, 11, 31);
    const bExpiry = b.coupon.ngayKetThuc
      ? new Date(b.coupon.ngayKetThuc)
      : new Date(9999, 11, 31);
    return aExpiry - bExpiry; // Ưu tiên phiếu hết hạn sớm hơn
  });

  return couponBenefits[0];
};

// Function tìm phiếu giảm giá tốt hơn chưa đủ điều kiện
const findBetterCoupons = (orderTotal) => {
  if (!availableCoupons.value || availableCoupons.value.length === 0) return [];

  const currentAppliedCoupon =
    autoAppliedCoupon.value ||
    (selectedCoupons.value.length > 0 ? selectedCoupons.value[0] : null);
  const currentAppliedBenefit = currentAppliedCoupon
    ? calculateCouponBenefit(currentAppliedCoupon, orderTotal).benefit
    : 0;

  const betterCoupons = availableCoupons.value.filter((coupon) => {
    // Chỉ lấy phiếu chưa đủ điều kiện nhưng có lợi ích tốt hơn
    if (coupon.trangThai !== true) return false;

    // Kiểm tra ngày hết hạn
    if (coupon.ngayKetThuc) {
      const expiryDate = new Date(coupon.ngayKetThuc);
      const now = new Date();
      if (expiryDate < now) return false;
    }

    // Kiểm tra khách hàng cụ thể
    if (
      coupon.idKhachHang &&
      currentOrder.value?.idKhachHang &&
      coupon.idKhachHang !== currentOrder.value.idKhachHang
    )
      return false;

    const minOrderValue = Number(coupon.hoaDonToiThieu) || 0;
    if (!coupon.hoaDonToiThieu || orderTotal >= minOrderValue) {
      return false;
    }

    const potentialBenefitIfQualified = calculateCouponBenefit(
      coupon,
      minOrderValue
    ).benefit;

    if (potentialBenefitIfQualified <= currentAppliedBenefit) {
      return false;
    }

    return true;
  });

  // Tính lợi ích cho từng phiếu
  const couponRecommendations = betterCoupons.map((coupon) => {
    const minOrderValue = Number(coupon.hoaDonToiThieu) || 0;
    const benefitAtMinOrder = calculateCouponBenefit(coupon, minOrderValue);
    return {
      coupon,
      neededAmount: minOrderValue - orderTotal,
      potentialSavings: benefitAtMinOrder.discountAmount,
      priority: benefitAtMinOrder.priority,
    };
  });

  // Sắp xếp: ưu tiên phiếu cần mua thêm ít nhất, sau đó ưu tiên lợi ích cao nhất
  couponRecommendations.sort((a, b) => {
    if (a.neededAmount !== b.neededAmount) {
      return a.neededAmount - b.neededAmount; // Ít cần mua thêm nhất
    }
    return b.potentialSavings - a.potentialSavings; // Lợi ích cao nhất
  });

  return couponRecommendations.slice(0, 1); // Chỉ lấy phiếu tốt nhất
};

// Function tự động áp dụng phiếu giảm giá tốt nhất
const autoApplyBestCoupon = () => {
  const order = currentOrder.value;
  console.log(
    `🔍 DEBUG autoApplyBestCoupon - Tổng tiền đơn hàng: ${order?.tongTien}đ`
  );
  console.log(
    `🔍 DEBUG autoApplyBestCoupon - Số phiếu có sẵn: ${availableCoupons.value?.length || 0
    }`
  );

  if (
    !order ||
    !availableCoupons.value ||
    availableCoupons.value.length === 0 ||
    order.tongTien <= 0
  ) {
    console.log(
      `❌ autoApplyBestCoupon - Không thể áp dụng phiếu (order: ${!!order}, coupons: ${availableCoupons.value?.length || 0
      }, total: ${order?.tongTien}đ)`
    );
    return;
  }

  const orderTotal = Number(order.tongTien) || 0;

  // Tìm phiếu tốt nhất có thể áp dụng ngay
  const bestAvailableCoupon = findBestAvailableCoupon(orderTotal);

  // Tìm phiếu tốt hơn chưa đủ điều kiện để gợi ý
  const betterCouponsList = findBetterCoupons(orderTotal);
  betterCoupons.value = betterCouponsList;
  showRecommendation.value = betterCouponsList.length > 0;

  if (bestAvailableCoupon && bestAvailableCoupon.discountAmount > 0) {
    // Kiểm tra xem có cần thay đổi phiếu hiện tại không
    const currentCoupon = selectedCoupons.value[0];
    const shouldChange =
      !currentCoupon ||
      currentCoupon.id !== bestAvailableCoupon.coupon.id ||
      !autoAppliedCoupon.value;

    if (shouldChange) {
      // Áp dụng phiếu giảm giá tốt nhất
      selectedCoupons.value = [bestAvailableCoupon.coupon];
      autoAppliedCoupon.value = bestAvailableCoupon.coupon;

      const discountType =
        bestAvailableCoupon.coupon.loaiPhieuGiamGia === false ? "%" : "đ";
      const discountValue =
        bestAvailableCoupon.coupon.loaiPhieuGiamGia === false
          ? bestAvailableCoupon.coupon.giaTriGiamGia
          : Math.round(bestAvailableCoupon.coupon.giaTriGiamGia / 1000) + "K";

      console.log(
        `🎫 Tự động áp dụng phiếu giảm giá tốt nhất: ${bestAvailableCoupon.coupon.tenPhieuGiamGia} (${discountValue}${discountType})`
      );
      console.log(
        `💰 Tiết kiệm: ${bestAvailableCoupon.discountAmount.toLocaleString()}đ`
      );

      // Cập nhật lại tổng tiền
      updateOrderTotals();
    }
  } else {
    // Không có phiếu phù hợp, reset auto applied coupon
    if (autoAppliedCoupon.value) {
      autoAppliedCoupon.value = null;
      console.log("🚫 Không có phiếu giảm giá phù hợp");
    }
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
    console.log("🔍 DEBUG - Response gốc từ API:", coupons);
    console.log("🔍 DEBUG - coupons.data:", coupons.data);
    console.log("🔍 DEBUG - coupons.data.data:", coupons.data?.data);

    // Đảm bảo luôn là mảng - API trả về {data: {data: [...], message: "...", success: true}}
    const couponArray =
      coupons.data && coupons.data.data ? coupons.data.data : [];
    availableCoupons.value = Array.isArray(couponArray) ? couponArray : [];

    console.log("🔍 DEBUG - Mảng phiếu cuối cùng:", availableCoupons.value);
    console.log("🔍 DEBUG - Phiếu đầu tiên:", availableCoupons.value[0]);
    console.log(
      "🔍 DEBUG - Keys của phiếu đầu tiên:",
      availableCoupons.value[0] ? Object.keys(availableCoupons.value[0]) : []
    );

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

// Load phiếu giảm giá cho khách hàng cụ thể
const loadCouponsForCustomer = async (customerId) => {
  try {
    if (customerId && customerId > 0) {
      console.log(`Đang load phiếu giảm giá cho khách hàng ID: ${customerId}`);
      const response = await fetchActivePhieuGiamGiaForCustomer(customerId);

      console.log("🔍 DEBUG - Response cho khách hàng:", response);
      console.log("🔍 DEBUG - response.data:", response.data);
      console.log("🔍 DEBUG - response.data.data:", response.data?.data);

      // API trả về {data: {data: [...], message: "...", success: true}}
      const couponArray =
        response.data && response.data.data ? response.data.data : [];
      availableCoupons.value = Array.isArray(couponArray) ? couponArray : [];

      console.log(
        "🔍 DEBUG - Mảng phiếu cho khách hàng:",
        availableCoupons.value
      );
      console.log(
        "🔍 DEBUG - Phiếu đầu tiên cho khách hàng:",
        availableCoupons.value[0]
      );
      console.log(
        "🔍 DEBUG - Keys của phiếu cho khách hàng:",
        availableCoupons.value[0] ? Object.keys(availableCoupons.value[0]) : []
      );

      console.log(
        `Đã load được ${availableCoupons.value.length} phiếu giảm giá cho khách hàng`
      );
    } else {
      // Nếu không có khách hàng, load tất cả phiếu giảm giá active
      console.log("Không có khách hàng, load tất cả phiếu giảm giá active");
      await loadAllCoupons();
    }
  } catch (error) {
    console.error("Lỗi khi load phiếu giảm giá cho khách hàng:", error);
    // Fallback: load tất cả phiếu giảm giá
    await loadAllCoupons();
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
          .replace(
            '<img :src="PlusIcon" alt="Plus" class="icon-sm" /> Tạo khách hàng mới: "',
            ""
          )
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

    // Load phiếu giảm giá cho khách hàng cụ thể
    await loadCouponsForCustomer(customer.id);

    // Tự động áp dụng phiếu giảm giá tốt nhất cho khách hàng mới
    setTimeout(() => {
      autoApplyBestCoupon();
    }, 100);
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
      showNotificationPopup(
        "Đã tạo khách hàng mới thành công! Thông tin địa chỉ đã được lưu.",
        "success"
      );
    }
  } catch (error) {
    console.error("Error creating new customer:", error);
    showNotificationPopup(
      "Có lỗi xảy ra khi tạo khách hàng mới. Vui lòng thử lại.",
      "error"
    );
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
    console.log(`🗑️ Bỏ chọn voucher: ${coupon.tenPhieuGiamGia}`);
  } else {
    // Check if can apply coupon
    if (!canApplyCoupon(coupon)) {
      console.log(`❌ Không thể áp dụng voucher: ${coupon.tenPhieuGiamGia}`);
      return;
    }

    // Replace current coupon with new one (only allow one coupon at a time)
    selectedCoupons.value = [coupon]; // Replace with new coupon

    // Reset auto applied coupon khi người dùng chọn thủ công
    autoAppliedCoupon.value = null;
    console.log(`🎫 Chọn voucher mới: ${coupon.tenPhieuGiamGia}`);
  }

  // Update current order's selected coupons (deprecated - using selectedCoupons.value directly)
  // currentOrder.value.selectedCoupons = selectedCoupons.value;

  // Recalculate totals
  updateOrderTotals();
};

const canApplyCoupon = (coupon) => {
  if (!currentOrder.value || !coupon) {
    console.log(`🔍 canApplyCoupon - Không có order hoặc coupon`);
    return false;
  }

  const orderTotal = Number(currentOrder.value.tongTien) || 0;
  const minOrderValue = Number(coupon.hoaDonToiThieu) || 0;

  console.log(`🔍 canApplyCoupon - Phiếu: ${coupon.tenPhieuGiamGia}`);
  console.log(`🔍 canApplyCoupon - Tổng tiền: ${orderTotal}đ`);
  console.log(`🔍 canApplyCoupon - Yêu cầu tối thiểu: ${minOrderValue}đ`);
  console.log(`🔍 canApplyCoupon - hoaDonToiThieu: ${coupon.hoaDonToiThieu}`);

  // Check minimum order value
  if (coupon.hoaDonToiThieu && orderTotal < minOrderValue) {
    console.log(
      `❌ canApplyCoupon - Không đủ điều kiện tối thiểu: ${orderTotal}đ < ${minOrderValue}đ`
    );
    return false;
  }

  // Check if coupon is already selected - nếu đã chọn rồi thì vẫn cho phép (để hiển thị trạng thái)
  const isAlreadySelected = selectedCoupons.value.some(
    (c) => c.id === coupon.id
  );

  // Nếu đã chọn rồi thì vẫn cho phép (để hiển thị trạng thái hợp lệ)
  if (isAlreadySelected) return true;

  // Only allow one coupon at a time - chỉ áp dụng khi chưa có phiếu nào
  if (selectedCoupons.value.length > 0) {
    return false;
  }

  // Check if coupon is active (assuming trangThai indicates active status)
  if (coupon.trangThai !== true) {
    console.log(`❌ canApplyCoupon - Phiếu không active: ${coupon.trangThai}`);
    return false;
  }

  console.log(`✅ canApplyCoupon - Phiếu hợp lệ: ${coupon.tenPhieuGiamGia}`);
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

    // Không tự động áp dụng phiếu khác khi người dùng xóa thủ công
    // Chỉ áp dụng tự động khi thêm sản phẩm hoặc đổi khách hàng
  }
};

const isCouponSelected = (couponId) => {
  // Kiểm tra trong danh sách phiếu đã chọn thủ công
  const isInSelectedCoupons = selectedCoupons.value.some(
    (c) => c.id === couponId
  );

  // Kiểm tra trong phiếu được áp dụng tự động
  const isAutoApplied =
    autoAppliedCoupon.value && autoAppliedCoupon.value.id === couponId;

  const result = isInSelectedCoupons || isAutoApplied;

  // Debug log để theo dõi trạng thái
  if (result) {
    console.log(`✅ Voucher ${couponId} được chọn:`, {
      inSelectedCoupons: isInSelectedCoupons,
      autoApplied: isAutoApplied,
      result: result,
    });
  }

  return result;
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
    // Đồng bộ hóa trạng thái phiếu giảm giá để hiển thị đúng trong popup
    console.log("🔍 Mở popup voucher:");
    console.log(
      "- autoAppliedCoupon:",
      autoAppliedCoupon.value ? autoAppliedCoupon.value.tenPhieuGiamGia : "null"
    );
    console.log("- selectedCoupons trước:", selectedCoupons.value.length);

    if (autoAppliedCoupon.value) {
      // Nếu có phiếu tự động, đảm bảo nó được hiển thị trong popup
      selectedCoupons.value = [autoAppliedCoupon.value];
      console.log(
        `🎫 Đã set selectedCoupons cho voucher tự động: ${autoAppliedCoupon.value.tenPhieuGiamGia}`
      );
    } else if (selectedCoupons.value.length > 0) {
      // Nếu có voucher thủ công được chọn
      console.log(
        `✅ Giữ voucher thủ công: ${selectedCoupons.value[0].tenPhieuGiamGia}`
      );
    } else {
      // Nếu không có voucher nào
      selectedCoupons.value = [];
      console.log("📋 Không có voucher nào được chọn");
    }

    console.log("- selectedCoupons sau:", selectedCoupons.value.length);

    // Đảm bảo UI được cập nhật trước khi hiển thị popup
    nextTick(() => {
      showCouponModal.value = true;
      console.log("✅ Popup voucher đã được mở");
    });
  }
};

const closeCouponModal = () => {
  console.log("❌ Đóng popup voucher");

  // Reset về trạng thái ban đầu khi người dùng hủy
  if (autoAppliedCoupon.value) {
    // Nếu có voucher tự động, khôi phục lại
    selectedCoupons.value = [autoAppliedCoupon.value];
    console.log(
      `🔄 Khôi phục voucher tự động: ${autoAppliedCoupon.value.tenPhieuGiamGia}`
    );
  } else {
    // Nếu không có voucher tự động, không chọn gì
    selectedCoupons.value = [];
    console.log("🔄 Không có voucher nào được chọn");
  }

  showCouponModal.value = false;
};

const confirmCouponSelection = () => {
  if (selectedCoupons.value.length === 0) {
    // Người dùng không chọn voucher nào
    autoAppliedCoupon.value = null;
    console.log("📋 Người dùng không chọn voucher nào");
  } else {
    // Người dùng đã chọn voucher
    const selectedCoupon = selectedCoupons.value[0];

    // Kiểm tra xem voucher này có phải là voucher tự động ban đầu không
    const isOriginalAutoApplied =
      autoAppliedCoupon.value &&
      autoAppliedCoupon.value.id === selectedCoupon.id;

    if (isOriginalAutoApplied) {
      // Giữ nguyên trạng thái tự động nếu người dùng giữ voucher gốc
      console.log(
        `🎫 Giữ nguyên voucher tự động: ${selectedCoupon.tenPhieuGiamGia}`
      );
    } else {
      // Nếu người dùng chọn voucher khác, reset trạng thái tự động
      autoAppliedCoupon.value = null;
      console.log(
        `✅ Người dùng chọn voucher thủ công: ${selectedCoupon.tenPhieuGiamGia}`
      );
    }
  }

  // Update current order with selected coupons
  if (currentOrder.value) {
    // currentOrder.value.selectedCoupons = selectedCoupons.value; // deprecated
    updateOrderTotals();
  }
  showCouponModal.value = false;
};

// Scroll to voucher list section
const scrollToVoucherList = () => {
  const couponGrid = document.querySelector(".coupon-grid");
  if (couponGrid) {
    couponGrid.scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
    console.log("🔽 Cuộn đến danh sách voucher");
  }
};

// Remove current applied voucher
const removeCurrentVoucher = () => {
  const currentVoucher =
    autoAppliedCoupon.value ||
    (selectedCoupons.value.length > 0 ? selectedCoupons.value[0] : null);

  if (currentVoucher) {
    console.log(`🗑️ Hủy voucher: ${currentVoucher.tenPhieuGiamGia}`);

    // Reset trạng thái
    selectedCoupons.value = [];
    autoAppliedCoupon.value = null;

    // Cập nhật tổng tiền
    updateOrderTotals();

    // Thông báo cho người dùng
    showNotificationPopup(
      `Đã hủy phiếu giảm giá: ${currentVoucher.tenPhieuGiamGia}`,
      "info"
    );
  }
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
          tenKhachHang: "Tạo khách hàng mới",
          displayName: `Tạo khách hàng mới: "${query}"`,
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
            tenKhachHang: "Tạo khách hàng mới",
            displayName: `Tạo khách hàng mới: "${query}"`,
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
    showNotificationPopup("Không tìm thấy đơn hàng hiện tại", "error");
    return;
  }

  if (!order.danhSachSanPham || order.danhSachSanPham.length === 0) {
    showNotificationPopup("Vui lòng thêm sản phẩm vào đơn hàng", "warning");
    return;
  }

  if (!customerDisplayName.value.trim()) {
    showNotificationPopup("Vui lòng nhập thông tin khách hàng", "warning");
    return;
  }

  if (!order.phuongThucThanhToan) {
    showNotificationPopup("Vui lòng chọn phương thức thanh toán", "warning");
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
        showNotificationPopup("Có lỗi khi tạo khách hàng mới", "error");
        return;
      }
    }
  }

  // Validation cho giao hàng tận nơi
  if (order.ghiChu === "delivery") {
    if (!isAddressComplete.value) {
      showNotificationPopup(
        "Vui lòng nhập đầy đủ thông tin địa chỉ giao hàng",
        "warning"
      );
      return;
    }
  }

  // Validation cho từng phương thức thanh toán
  if (order.phuongThucThanhToan === "pay_now") {
    if (!order.tienKhachTra || order.tienKhachTra < 0) {
      showNotificationPopup("Vui lòng nhập số tiền khách trả", "warning");
      return;
    }
    if (order.tienKhachTra < order.tongTienSauGiam) {
      showNotificationPopup(
        "Số tiền khách trả không đủ. Vui lòng thanh toán đủ hoặc chọn phương thức khác.",
        "warning"
      );
      return;
    }
  }

  // Validate số lượng sản phẩm trong kho trước khi tạo đơn hàng
  console.log("🔍 Bắt đầu validate số lượng sản phẩm trong kho...");
  await validateCartInventory();

  await fetchCreateOrder();
  await fetchAll();

  // Save delivery address to customer if changed
  if (order.phuongThucThanhToan === "home_delivery") {
    await saveDeliveryAddressToCustomer();
  }

  showNotificationPopup("Đơn hàng đã được tạo thành công!", "success");

  // Reset current order
  if (order) {
    order.danhSachSanPham = [];
    order.idKhachHang = null;
    // order.selectedCoupons = []; // Reset selected coupons - deprecated
    order.idNhanVien = 1;
    order.idPhuongThucThanhToan = 0;
    order.phuongThucThanhToan = null;
    order.tienKhachTra = 0;
  }

  // Reset delivery address
  deliveryAddress.value = {
    tenNguoiNhan: "",
    soDienThoaiNguoiNhan: "",
    emailNguoiNhan: "",
    diaChiCuThe: "",
    thanhPho: "",
    quan: "",
    phuong: "",
    // Original values for comparison
    originalThanhPho: "",
    originalQuan: "",
    originalPhuong: "",
    originalDiaChiCuThe: "",
  };

  // Reset customer display name
  customerDisplayName.value = "";
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
    // Original values for comparison
    originalThanhPho: "",
    originalQuan: "",
    originalPhuong: "",
    originalDiaChiCuThe: "",
  };
  order.ngayThanhToan = thanhToan(order.idPhuongThucThanhToan || 0);
  order.trangThai = true;
  order.deleted = false;
  order.createAt = new Date();
  order.createBy = 0;
  updateOrderTotals();

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
};

// Copy to clipboard function
const copyToClipboard = async (text) => {
  try {
    await navigator.clipboard.writeText(text);
    // You can add a toast notification here if needed
    console.log("Đã sao chép:", text);
  } catch (error) {
    console.error("Lỗi sao chép:", error);
    // Fallback method for older browsers
    const textArea = document.createElement("textarea");
    textArea.value = text;
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    try {
      document.execCommand("copy");
      console.log("Đã sao chép (fallback):", text);
    } catch (fallbackError) {
      console.error("Lỗi sao chép fallback:", fallbackError);
    }
    document.body.removeChild(textArea);
  }
};

// Refresh data function
const refreshData = async () => {
  try {
    console.log("Làm mới dữ liệu...");
    await fetchAll();
    console.log("Đã làm mới dữ liệu thành công!");
  } catch (error) {
    console.error("Lỗi khi làm mới dữ liệu:", error);
  }
};

// Clear all filters function
const clearAllFilters = () => {
  selectedNhaSanXuat.value = "";
  selectedXuatXu.value = "";
  selectedChatLieu.value = "";
  selectedSize.value = "";
  selectedDeGiay.value = "";
  selectedMauSac.value = "";
  productSearchQuery.value = "";
};

// Shipping carrier utility functions
const getShippingFeeByCarrierAndService = (carrier, serviceType) => {
  const feeMap = {
    ghn: { standard: 25000, express: 35000, same_day: 50000 },
    ghtk: { standard: 22000, express: 30000 },
    vnpost: { standard: 20000, express: 28000 },
    jnt: { standard: 24000, express: 32000 },
    grab: { standard: 40000, express: 60000 },
    shopee: { standard: 23000, express: 31000 },
  };

  return feeMap[carrier]?.[serviceType] || 0;
};

const updateShippingFee = () => {
  if (selectedShippingCarrier.value && selectedServiceType.value) {
    shippingFee.value = getShippingFeeByCarrierAndService(
      selectedShippingCarrier.value,
      selectedServiceType.value
    );
  } else {
    shippingFee.value = 0;
  }
};

const formatShippingFee = () => {
  return shippingFee.value > 0 ? formatCurrency(shippingFee.value) : "0 VNĐ";
};

const isEligibleForFreeShipping = () => {
  // Sử dụng tổng tiền hàng gốc (chưa giảm voucher) để check miễn phí
  const order = currentOrder.value;
  if (!order || !order.danhSachSanPham) return false;

  // Tính tổng tiền hàng gốc (chưa giảm voucher)
  const tongTienHangGoc = order.danhSachSanPham.reduce(
    (sum, item) => sum + item.giaBan * item.soLuong,
    0
  );

  console.log("🚚 CHECK FREE SHIPPING (từ isEligibleForFreeShipping):");
  console.log("- Tổng tiền hàng gốc:", formatCurrency(tongTienHangGoc));
  console.log(
    "- Đủ điều kiện miễn phí:",
    tongTienHangGoc >= 2000000 ? "✅ Có" : "❌ Không"
  );
  console.log(
    "- Kết quả function:",
    tongTienHangGoc >= 2000000 ? "✅ TRUE" : "❌ FALSE"
  );

  // Debug chi tiết từng sản phẩm để so sánh
  console.log("🔍 CHI TIẾT TỪNG SẢN PHẨM (từ isEligibleForFreeShipping):");
  order.danhSachSanPham.forEach((item, index) => {
    console.log(
      `  ${index + 1}. ${item.tenSanPham}: ${formatCurrency(item.giaBan)} × ${item.soLuong
      } = ${formatCurrency(item.giaBan * item.soLuong)}`
    );
  });

  // Chỉ check tổng tiền hàng gốc >= 2 triệu, không quan tâm đến shippingFee.value
  // vì logic miễn phí được xử lý trong updateOrderTotals()
  return tongTienHangGoc >= 2000000;
};

const formatFinalShippingFee = () => {
  const finalFee = isEligibleForFreeShipping() ? 0 : shippingFee.value;
  return finalFee > 0 ? formatCurrency(finalFee) : "Miễn phí";
};

const getCarrierDisplayName = () => {
  const carrierNames = {
    ghn: "Giao Hàng Nhanh",
    ghtk: "Giao Hàng Tiết Kiệm",
    vnpost: "VNPost",
    jnt: "J&T Express",
    grab: "GrabExpress",
    shopee: "Shopee Express",
  };
  return carrierNames[selectedShippingCarrier.value] || "";
};

const getDeliveryEstimate = () => {
  if (!selectedShippingCarrier.value || !selectedServiceType.value) return "";

  const estimates = {
    ghn: {
      standard: "Giao trong 2-3 ngày",
      express: "Giao trong 1-2 ngày",
      same_day: "Giao trong ngày",
    },
    ghtk: { standard: "Giao trong 2-4 ngày", express: "Giao trong 1-2 ngày" },
    vnpost: { standard: "Giao trong 3-5 ngày", express: "Giao trong 2-3 ngày" },
    jnt: { standard: "Giao trong 2-3 ngày", express: "Giao trong 1-2 ngày" },
    grab: { standard: "Giao trong 2-4 giờ", express: "Giao trong 1-2 giờ" },
    shopee: { standard: "Giao trong 2-3 ngày", express: "Giao trong 1-2 ngày" },
  };

  return (
    estimates[selectedShippingCarrier.value]?.[selectedServiceType.value] || ""
  );
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
      showNotificationPopup("Vui lòng nhập họ và tên", "warning");
      return;
    }
    if (!newCustomerForm.value.email.trim()) {
      showNotificationPopup("Vui lòng nhập email", "warning");
      return;
    }
    if (!newCustomerForm.value.soDienThoai.trim()) {
      showNotificationPopup("Vui lòng nhập số điện thoại", "warning");
      return;
    }
    if (!newCustomerForm.value.tenTaiKhoan.trim()) {
      showNotificationPopup("Vui lòng nhập tên tài khoản", "warning");
      return;
    }
    if (!newCustomerForm.value.matKhau.trim()) {
      showNotificationPopup("Vui lòng nhập mật khẩu", "warning");
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
    showNotificationPopup("Thêm khách hàng thành công!", "success");

    // Reset form
    resetNewCustomerForm();
  } catch (error) {
    console.error("Error saving customer:", error);
    showNotificationPopup("Có lỗi xảy ra khi thêm khách hàng", "error");
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

  // Load provinces data
  await loadProvinces();

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

// Address functions
const loadProvinces = async () => {
  try {
    provinces.value = await getProvinces();
  } catch (error) {
    console.error("Error loading provinces:", error);
  }
};

// Function to normalize address names for better matching
const normalizeAddressName = (name) => {
  if (!name) return "";
  return name
    .trim()
    .toLowerCase()
    .replace(/^(tỉnh|thành phố|tp\.?)\s+/i, "") // Remove prefix
    .replace(/^(quận|huyện|q\.?|h\.?)\s+/i, "") // Remove prefix
    .replace(/^(phường|xã|thị trấn|tt\.?|p\.?)\s+/i, "") // Remove prefix
    .replace(/\s+/g, " ") // Normalize spaces
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, ""); // Remove accents
};

// Function to find best match for address name
const findBestAddressMatch = (searchName, addressList) => {
  if (!searchName || !addressList || addressList.length === 0) return null;

  const normalizedSearch = normalizeAddressName(searchName);

  // First try exact match (after normalization)
  let match = addressList.find((item) => {
    const normalizedItem = normalizeAddressName(item.name);
    return normalizedItem === normalizedSearch;
  });

  if (match) return match;

  // Try partial match
  match = addressList.find((item) => {
    const normalizedItem = normalizeAddressName(item.name);
    return (
      normalizedItem.includes(normalizedSearch) ||
      normalizedSearch.includes(normalizedItem)
    );
  });

  if (match) return match;

  // Try fuzzy match with original names
  match = addressList.find((item) => {
    const itemName = item.name.toLowerCase();
    const search = searchName.toLowerCase();
    return itemName.includes(search) || search.includes(itemName);
  });

  return match;
};

const onProvinceChange = async () => {
  // Reset dependent fields
  deliveryAddress.value.quan = "";
  deliveryAddress.value.phuong = "";
  districts.value = [];
  wards.value = [];
  selectedDistrictCode.value = "";

  if (!deliveryAddress.value.thanhPho) return;

  try {
    // Find province code by name
    const province = provinces.value.find(
      (p) => p.name === deliveryAddress.value.thanhPho
    );
    if (province) {
      selectedProvinceCode.value = province.code;
      districts.value = await getDistricts(province.code);
    }
  } catch (error) {
    console.error("Error loading districts:", error);
  }
};

const onDistrictChange = async () => {
  // Reset dependent fields
  deliveryAddress.value.phuong = "";
  wards.value = [];

  if (!deliveryAddress.value.quan || !selectedProvinceCode.value) return;

  try {
    // Find district code by name
    const district = districts.value.find(
      (d) => d.name === deliveryAddress.value.quan
    );
    if (district) {
      selectedDistrictCode.value = district.code;
      wards.value = await getWards(selectedProvinceCode.value, district.code);
    }
  } catch (error) {
    console.error("Error loading wards:", error);
  }
};

// Function to populate delivery address from customer data
const populateDeliveryAddress = () => {
  if (!currentOrder.value?.idKhachHang) return;

  const customer = KhachHangs.value.find(
    (c) => c.id === currentOrder.value.idKhachHang
  );
  if (customer) {
    // Map thông tin khách hàng làm thông tin người nhận mặc định
    deliveryAddress.value.tenNguoiNhan = customer.tenKhachHang;
    deliveryAddress.value.soDienThoaiNguoiNhan = customer.soDienThoai || "";
    deliveryAddress.value.emailNguoiNhan = customer.email || "";

    // Populate địa chỉ từ danh sách địa chỉ của khách hàng
    if (customer.listDiaChi && customer.listDiaChi.length > 0) {
      // Lấy địa chỉ đầu tiên làm địa chỉ mặc định
      const defaultAddr = customer.listDiaChi[0];

      // Map địa chỉ từ API khách hàng sang delivery address
      deliveryAddress.value.diaChiCuThe = defaultAddr.diaChiCuThe || "";
      deliveryAddress.value.thanhPho = defaultAddr.thanhPho || "";
      deliveryAddress.value.quan = defaultAddr.quan || "";
      deliveryAddress.value.phuong = defaultAddr.phuong || "";

      // Khách hàng đã có địa chỉ, không cần lưu địa chỉ mới
      // Chỉ set địa chỉ gốc để hiển thị
      deliveryAddress.value.originalThanhPho = defaultAddr.thanhPho || "";
      deliveryAddress.value.originalQuan = defaultAddr.quan || "";
      deliveryAddress.value.originalPhuong = defaultAddr.phuong || "";
      deliveryAddress.value.originalDiaChiCuThe = defaultAddr.diaChiCuThe || "";

      console.log("📍 Đã mapping địa chỉ khách hàng làm địa chỉ người nhận:");
      console.log("- Tên người nhận:", customer.tenKhachHang);
      console.log("- SĐT người nhận:", customer.soDienThoai || "Không có");
      console.log("- Email người nhận:", customer.email || "Không có");
      console.log(
        "- Địa chỉ:",
        `${defaultAddr.diaChiCuThe || ""}, ${defaultAddr.phuong || ""}, ${defaultAddr.quan || ""
        }, ${defaultAddr.thanhPho || ""}`
      );

      // Trigger auto-select matching after a delay to ensure data is loaded
      setTimeout(() => {
        autoSelectMatchingAddress();
      }, 500);
    } else {
      console.log(
        "⚠️ Khách hàng chưa có địa chỉ nào, chỉ mapping thông tin cá nhân"
      );
    }
  }
};

// Function to save delivery address back to customer if changed
const saveDeliveryAddressToCustomer = async () => {
  if (!currentOrder.value?.idKhachHang) return;

  const customer = KhachHangs.value.find(
    (c) => c.id === currentOrder.value.idKhachHang
  );
  if (!customer) return;

  // Kiểm tra xem khách hàng đã có địa chỉ nào chưa
  const hasExistingAddresses =
    customer.listDiaChi && customer.listDiaChi.length > 0;

  if (hasExistingAddresses) {
    console.log(
      "ℹ️ Khách hàng đã có địa chỉ trong hệ thống, không lưu địa chỉ mới"
    );
    console.log("- Số địa chỉ hiện có:", customer.listDiaChi.length);
    console.log("- Địa chỉ đầu tiên:", customer.listDiaChi[0]);
    return; // Không lưu địa chỉ mới cho khách hàng đã có địa chỉ
  }

  // Chỉ lưu địa chỉ mới cho khách hàng mới (chưa có địa chỉ)
  console.log("🆕 Khách hàng mới chưa có địa chỉ, sẽ lưu địa chỉ giao hàng");

  const deliveryAddr = deliveryAddress.value;

  // Validate địa chỉ giao hàng
  if (!deliveryAddr.thanhPho || !deliveryAddr.diaChiCuThe) {
    console.log(
      "⚠️ Địa chỉ giao hàng thiếu thông tin bắt buộc (thành phố hoặc địa chỉ cụ thể)"
    );
    return;
  }

  try {
    // Validate required fields
    if (!customer.id) {
      console.error("Không tìm thấy ID khách hàng");
      return;
    }

    // Create new address object matching DiaChiKhachHangRequest structure
    const newAddress = {
      idKhachHang: customer.id,
      tenDiaChi: `Địa chỉ giao hàng - ${new Date().toLocaleDateString(
        "vi-VN"
      )}`,
      diaChiCuThe: deliveryAddr.diaChiCuThe.trim(),
      thanhPho: deliveryAddr.thanhPho.trim(),
      quan: deliveryAddr.quan ? deliveryAddr.quan.trim() : "",
      phuong: deliveryAddr.phuong ? deliveryAddr.phuong.trim() : "",
      deleted: false,
    };

    console.log("🔄 Đang lưu địa chỉ mới:", newAddress);

    // Save to backend
    await fetchCreateDiaChiKhachHang(newAddress);

    console.log(
      "✅ Đã lưu địa chỉ giao hàng đầu tiên cho khách hàng:",
      customer.tenKhachHang
    );

    // Update local customer data
    if (!customer.listDiaChi) {
      customer.listDiaChi = [];
    }
    customer.listDiaChi.unshift({
      diaChiCuThe: deliveryAddr.diaChiCuThe,
      thanhPho: deliveryAddr.thanhPho,
      quan: deliveryAddr.quan,
      phuong: deliveryAddr.phuong,
    });

    // Update original values to reflect the saved address
    deliveryAddr.originalThanhPho = deliveryAddr.thanhPho;
    deliveryAddr.originalQuan = deliveryAddr.quan;
    deliveryAddr.originalPhuong = deliveryAddr.phuong;
    deliveryAddr.originalDiaChiCuThe = deliveryAddr.diaChiCuThe;

    console.log("📍 Đã cập nhật địa chỉ gốc sau khi lưu thành công");

    // Cập nhật địa chỉ gốc trong customer data để đồng bộ
    if (customer.listDiaChi && customer.listDiaChi.length > 0) {
      const latestAddress = customer.listDiaChi[customer.listDiaChi.length - 1];
      deliveryAddr.originalThanhPho = latestAddress.thanhPho || "";
      deliveryAddr.originalQuan = latestAddress.quan || "";
      deliveryAddr.originalPhuong = latestAddress.phuong || "";
      deliveryAddr.originalDiaChiCuThe = latestAddress.diaChiCuThe || "";
    }
  } catch (error) {
    console.error("❌ Lỗi khi lưu địa chỉ giao hàng:", error);
    // Don't show alert to avoid interrupting user flow
    // User can continue with order creation even if address save fails
  }
};

// Function to auto-select matching address from dropdown
const autoSelectMatchingAddress = async () => {
  if (!deliveryAddress.value.thanhPho) return;

  try {
    // Wait for provinces to load if not loaded yet
    if (provinces.value.length === 0) {
      await loadProvinces();
    }

    // Use improved matching function
    const matchingProvince = findBestAddressMatch(
      deliveryAddress.value.thanhPho,
      provinces.value
    );

    if (matchingProvince) {
      selectedProvinceCode.value = matchingProvince.code;
      // Update the display name to match the official name
      deliveryAddress.value.thanhPho = matchingProvince.name;
      console.log("✅ Tìm thấy tỉnh/thành phố:", matchingProvince.name);

      // Load districts for this province
      const districtData = await getDistricts(matchingProvince.code);
      districts.value = districtData;

      // Find and select matching district
      if (deliveryAddress.value.quan) {
        const matchingDistrict = findBestAddressMatch(
          deliveryAddress.value.quan,
          districtData
        );

        if (matchingDistrict) {
          selectedDistrictCode.value = matchingDistrict.code;
          deliveryAddress.value.quan = matchingDistrict.name;
          console.log("✅ Tìm thấy quận/huyện:", matchingDistrict.name);

          // Load wards for this district
          const wardData = await getWards(
            matchingProvince.code,
            matchingDistrict.code
          );
          wards.value = wardData;

          // Find and select matching ward
          if (deliveryAddress.value.phuong) {
            const matchingWard = findBestAddressMatch(
              deliveryAddress.value.phuong,
              wardData
            );

            if (matchingWard) {
              deliveryAddress.value.phuong = matchingWard.name;
              console.log("✅ Tìm thấy xã/phường:", matchingWard.name);
            }
          }
        }
      }
    } else {
      console.warn(
        "Không tìm thấy tỉnh/thành phố khớp:",
        deliveryAddress.value.thanhPho
      );
      console.log(
        "Danh sách tỉnh có sẵn:",
        provinces.value.map((p) => p.name)
      );
    }
  } catch (error) {
    console.error("Lỗi khi tự động chọn địa chỉ:", error);
  }
};

// Function to handle home delivery selection
const selectHomeDelivery = () => {
  currentOrder.value.phuongThucThanhToan = "home_delivery";
  // Populate delivery address when user selects home delivery
  populateDeliveryAddress();

  // Cập nhật lại tổng tiền để tính phí giao hàng
  updateOrderTotals();
};

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
/* Import redesigned CSS file cho Bán Hàng */
@import "../../styles/cssBanHang/banHang.css";

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
</style>
