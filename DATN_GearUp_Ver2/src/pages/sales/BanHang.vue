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
               :class="['order-tab', { active: currentOrderId === order.id }]"
               @click="switchOrder(order.id)">
            <div class="tab-main">
              <div class="tab-indicator"></div>
              <div class="tab-content">
                <div class="tab-title">{{ order.tenDonHang }}</div>
                <div class="tab-meta">{{ order.danhSachSanPham?.length || 0 }} sản phẩm</div>
              </div>
              <button v-if="tempOrder.length > 1" 
                      class="tab-close" 
                      @click.stop="closeOrder(order.id)"
                      title="Đóng đơn hàng">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M18 6L6 18M6 6l12 12"/>
                </svg>
              </button>
            </div>
          </div>
        </div>
        <button class="new-tab-btn" @click="createNewOrder" title="Tạo đơn hàng mới">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <path d="M12 5v14M5 12h14"/>
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
                <circle cx="8" cy="21" r="1"/>
                <circle cx="19" cy="21" r="1"/> 
                <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/>
              </svg>
            </div>
            <div class="cart-info">
              <h2 class="cart-title">Giỏ hàng</h2>
              <p class="cart-subtitle">{{ currentOrder?.danhSachSanPham?.length || 0 }} sản phẩm</p>
            </div>
          </div>
          <div class="cart-header-actions">
            <button class="cart-action-btn secondary-btn" @click="showProductSearch = true" title="Quét QR code">
              <img src="@/assets/QR.svg" alt="QR Code" width="18" height="18" />
            </button>
            <button class="cart-action-btn primary-btn" @click="showProductSearch = true" title="Thêm sản phẩm">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 5v14M5 12h14"/>
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
                <input type="checkbox" v-model="item.selected" class="modern-checkbox" id="item-{{ item.id }}" />
                <label :for="'item-' + item.id" class="checkbox-label"></label>
              </div>
              
              <div class="item-image-wrapper">
                <div class="item-image">
                  <img v-if="item.duongDanAnh" 
                       :src="item.duongDanAnh.startsWith('http') ? item.duongDanAnh : IMAGE_BASE_URL + item.duongDanAnh" 
                       :alt="item.tenSanPham" 
                       class="product-image" />
                  <div v-else class="image-placeholder">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                      <rect x="3" y="3" width="18" height="18" rx="2"/>
                      <circle cx="8.5" cy="8.5" r="1.5"/>
                      <path d="M21 15l-5-5L5 21"/>
                    </svg>
                  </div>
                </div>
              </div>

              <div class="item-details-wrapper">
                <div class="item-main-info">
                  <h3 class="product-title">{{ item.tenSanPham }}</h3>
                  <div class="product-attributes">
                    <span class="attribute">{{ item.tenKichThuoc }}</span>
                    <span class="attribute-separator">•</span>
                    <span class="attribute">{{ item.tenMauSac }}</span>
                    <span class="attribute-separator">•</span>
                    <span class="attribute">{{ item.tenNhaSanXuat }}</span>
                  </div>
                </div>
                
                <div class="item-price-info">
                  <div class="price-wrapper">
                    <span v-if="item.giaTriGiamGia > 0" class="original-price">
                      {{ formatCurrency(item.giaBan) }}
                    </span>
                    <span class="current-price">
                      {{ formatCurrency(item.giaSauGiam) }}
                    </span>
                  </div>
                  <span v-if="item.giaTriGiamGia > 0" class="discount-tag">
                    -{{ item.giaTriGiamGia }}%
                  </span>
                </div>
              </div>

              <div class="item-actions">
                <div class="quantity-controls">
                  <button @click="updateQuantity(item, -1)" class="quantity-btn" :disabled="item.soLuong <= 1">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M5 12h14"/>
                    </svg>
                  </button>
                  <span class="quantity-display">{{ item.soLuong }}</span>
                  <button @click="updateQuantity(item, 1)" class="quantity-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M12 5v14M5 12h14"/>
                    </svg>
                  </button>
                </div>
                
                <div class="item-total-price">
                  {{ formatCurrency(item.giaSauGiam * item.soLuong) }}
                </div>
                
                <button @click="removeItem(item)" class="remove-item-btn" title="Xóa khỏi giỏ hàng">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 6h18M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2M10 11v6M14 11v6"/>
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Modern Empty State -->
        <div v-else class="modern-empty-state">
          <div class="empty-state-content">
            <div class="empty-illustration">
              <svg width="96" height="96" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                <circle cx="8" cy="21" r="1"/>
                <circle cx="19" cy="21" r="1"/> 
                <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/>
              </svg>
            </div>
            <div class="empty-text">
              <h3 class="empty-title">Giỏ hàng trống</h3>
              <p class="empty-description">Chưa có sản phẩm nào trong giỏ hàng. Hãy thêm sản phẩm để bắt đầu tạo đơn hàng.</p>
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
              <span class="total-value">{{ formatCurrency(currentOrder.tongTien || 0) }}</span>
            </div>
            <div class="total-row" v-if="currentOrder.discount && currentOrder.discount > 0">
              <span class="total-label discount-label">Giảm giá:</span>
              <span class="total-value discount-value">-{{ formatCurrency(currentOrder.discount) }}</span>
            </div>
            <div class="total-divider"></div>
            <div class="total-row final-total">
              <span class="final-label">Thành tiền:</span>
              <span class="final-value">{{ formatCurrency((currentOrder.tongTien || 0) - (currentOrder.discount || 0)) }}</span>
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
              <p class="customer-section-subtitle">Thông tin khách hàng và xử lý thanh toán</p>
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
                  <svg class="customer-input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                  </svg>
                  <input type="text" v-model="customerDisplayName" @input="searchCustomers"
                    @focus="showCustomerDropdown = true" class="customer-input"
                    placeholder="Nhập tên hoặc email khách hàng" autocomplete="off" />
                  <button v-if="customerDisplayName" class="clear-customer-input" @click="clearCustomerInput"
                    title="Xóa nội dung">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M18 6L6 18M6 6l12 12"/>
                    </svg>
                  </button>
                </div>

                <!-- Customer Suggestions -->
                <div v-if="customerSuggestions.length > 0 && showCustomerDropdown" class="customer-suggestions">
                  <div v-for="customer in customerSuggestions" :key="customer.id" 
                       :class="['customer-suggestion', { 'create-new': customer.isCreateNew }]"
                       @click="selectCustomerFromSuggestions(customer)">
                    <div class="suggestion-content">
                      <div class="suggestion-info" v-if="!customer.isCreateNew">
                        <span class="suggestion-name">{{ customer.tenKhachHang }}</span>
                        <span class="suggestion-details">{{ customer.email }} • {{ customer.soDienThoai }}</span>
                      </div>
                      <div class="suggestion-info create-new-info" v-else>
                        <div class="create-new-row">
                          <img :src="PlusIcon" alt="Plus" class="plus-icon" />
                          <span class="create-new-text">{{ customer.displayName }}</span>
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
              <button class="select-coupon-btn" @click="openCouponModal"
                :disabled="availableCoupons.length === 0">
                <div class="coupon-btn-inner">
                  <div class="coupon-btn-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M21 12v-2a2 2 0 00-2-2H5a2 2 0 00-2 2v2"/>
                      <path d="M21 12v2a2 2 0 01-2 2H5a2 2 0 01-2-2v-2"/>
                      <circle cx="9" cy="12" r="1"/>
                      <circle cx="15" cy="12" r="1"/>
                    </svg>
                  </div>
                  <div class="coupon-btn-text">
                    <span v-if="selectedCoupons.length > 0">Chọn phiếu giảm giá</span>
                    <span v-else-if="availableCoupons.length > 0">Chọn phiếu giảm giá</span>
                    <span v-else>Đang tải phiếu giảm giá...</span>
                  </div>
                  <svg class="coupon-chevron" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9 18l6-6-6-6"/>
                  </svg>
                </div>
              </button>
            </div>

              <!-- Selected Coupon Display -->
              <div v-if="selectedCoupons.length > 0" class="selected-coupon">
                <div class="coupon-info">
                  <div class="coupon-details">
                    <span class="coupon-name">{{ selectedCoupons[0].tenPhieuGiamGia }}</span>
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
                      <path d="M18 6L6 18M6 6l12 12"/>
                    </svg>
                  </button>
                </div>
              </div>

              <!-- Auto Applied Notification -->
              <div v-if="autoAppliedCoupon" class="auto-applied-notice">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M9 12l2 2 4-4"/>
                  <circle cx="12" cy="12" r="10"/>
                </svg>
                <span>Đã tự động áp dụng phiếu giảm giá tốt nhất</span>
              </div>
            </div>
          </div>

          <!-- Payment Section -->
          <div class="payment-section">
            <h4 class="section-title">Thanh toán</h4>
            
            <!-- Payment Methods -->
            <div class="payment-options">
              <div class="payment-option" 
                   :class="{ selected: currentOrder?.phuongThucThanhToan === 'pay_now' }"
                   @click="currentOrder.phuongThucThanhToan = 'pay_now'">
                <div class="payment-option-icon">
                  <img src="@/assets/Money.svg" alt="Cash Icon" width="18" height="18" />
                </div>
                <div class="payment-option-content">
                  <span class="payment-option-title">Tiền mặt</span>
                  <span class="payment-option-desc">Thanh toán trực tiếp</span>
                </div>
              </div>
              
              <div class="payment-option" 
                   :class="{ selected: currentOrder?.phuongThucThanhToan === 'bank_transfer' }"
                   @click="currentOrder.phuongThucThanhToan = 'bank_transfer'">
                <div class="payment-option-icon">
                  <img src="@/assets/Banking.svg" alt="Banking Icon" width="18" height="18" />
                </div>
                <div class="payment-option-content">
                  <span class="payment-option-title">Chuyển khoản</span>
                  <span class="payment-option-desc">Thanh toán qua ngân hàng</span>
                </div>
              </div>
              
              <div class="payment-option" 
                   :class="{ selected: currentOrder?.phuongThucThanhToan === 'home_delivery' }"
                   @click="currentOrder.phuongThucThanhToan = 'home_delivery'">
                <div class="payment-option-icon">
                  <img src="@/assets/Shipping.svg" alt="Delivery Icon" width="18" height="18" />
                </div>
                <div class="payment-option-content">
                  <span class="payment-option-title">Giao hàng tận nơi</span>
                  <span class="payment-option-desc">Thanh toán khi nhận hàng</span>
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
                    <p class="bank-subtitle">Vui lòng chuyển khoản theo thông tin bên dưới</p>
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
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
                          <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/>
                        </svg>
                      </button>
                    </div>
                  </div>
                  <div class="bank-detail-row">
                    <span class="bank-label">Chủ tài khoản:</span>
                    <span class="bank-value">CONG TY TNHH GEAR UP</span>
                  </div>
                  <div class="bank-detail-row">
                    <span class="bank-label">Số tiền:</span>
                    <span class="bank-value amount">{{ formatCurrency((currentOrder?.tongTien || 0) - (currentOrder?.discount || 0)) }}</span>
                  </div>
                  <div class="bank-detail-row">
                    <span class="bank-label">Nội dung:</span>
                    <div class="bank-account">
                      <span class="bank-value">{{ `THANH TOAN DON HANG ${currentOrder?.tenDonHang || 'HD' + currentOrder?.id}` }}</span>
                      <button class="copy-btn" @click="copyToClipboard(`THANH TOAN DON HANG ${currentOrder?.tenDonHang || 'HD' + currentOrder?.id}`)" title="Sao chép nội dung chuyển khoản">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
                          <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
                
                <div class="qr-code-section">
                  <div class="qr-header">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="3" width="5" height="5"/>
                      <rect x="3" y="16" width="5" height="5"/>
                      <rect x="16" y="3" width="5" height="5"/>
                      <path d="M21 16h-3v3M21 21v.01M12 7v3M12 15.01V15"/>
                    </svg>
                    <span class="qr-title">Quét mã QR để chuyển khoản</span>
                  </div>
                  
                  <div class="qr-code-container">
                    <div class="qr-placeholder">
                      <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                        <!-- QR Code placeholder pattern -->
                        <rect width="120" height="120" fill="#ffffff" stroke="#e2e8f0" stroke-width="2" rx="8"/>
                        <rect x="10" y="10" width="20" height="20" fill="#1e293b" rx="2"/>
                        <rect x="35" y="10" width="5" height="5" fill="#1e293b"/>
                        <rect x="45" y="10" width="5" height="5" fill="#1e293b"/>
                        <rect x="55" y="10" width="10" height="10" fill="#1e293b"/>
                        <rect x="90" y="10" width="20" height="20" fill="#1e293b" rx="2"/>
                        
                        <rect x="15" y="15" width="10" height="10" fill="#ffffff" rx="1"/>
                        <rect x="95" y="15" width="10" height="10" fill="#ffffff" rx="1"/>
                        
                        <rect x="10" y="40" width="5" height="5" fill="#1e293b"/>
                        <rect x="20" y="40" width="10" height="5" fill="#1e293b"/>
                        <rect x="35" y="40" width="5" height="10" fill="#1e293b"/>
                        <rect x="50" y="40" width="15" height="5" fill="#1e293b"/>
                        <rect x="80" y="40" width="5" height="10" fill="#1e293b"/>
                        
                        <rect x="10" y="60" width="10" height="5" fill="#1e293b"/>
                        <rect x="30" y="60" width="5" height="10" fill="#1e293b"/>
                        <rect x="45" y="60" width="5" height="5" fill="#1e293b"/>
                        <rect x="60" y="60" width="10" height="10" fill="#1e293b"/>
                        <rect x="85" y="60" width="10" height="5" fill="#1e293b"/>
                        
                        <rect x="10" y="90" width="20" height="20" fill="#1e293b" rx="2"/>
                        <rect x="15" y="95" width="10" height="10" fill="#ffffff" rx="1"/>
                        
                        <rect x="40" y="80" width="5" height="5" fill="#1e293b"/>
                        <rect x="50" y="80" width="5" height="10" fill="#1e293b"/>
                        <rect x="65" y="80" width="10" height="5" fill="#1e293b"/>
                        <rect x="85" y="80" width="5" height="15" fill="#1e293b"/>
                        <rect x="100" y="80" width="10" height="10" fill="#1e293b"/>
                      </svg>
                    </div>
                    <div class="qr-info">
                      <p class="qr-description">Quét mã QR bằng app ngân hàng để chuyển khoản nhanh chóng</p>
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
                      <circle cx="12" cy="12" r="10"/>
                      <path d="M12 16v-4M12 8h.01"/>
                    </svg>
                  </div>
                  <div class="note-content">
                    <p><strong>Lưu ý quan trọng:</strong></p>
                    <ul>
                      <li>Vui lòng chuyển đúng số tiền và nội dung chuyển khoản</li>
                      <li>Đơn hàng sẽ được xử lý sau khi nhận được thanh toán</li>
                      <li>Liên hệ hotline: <strong>1900-xxx-xxx</strong> nếu cần hỗ trợ</li>
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
                    <p class="delivery-subtitle">Thông tin địa chỉ và thời gian giao hàng</p>
                  </div>
                </div>
                
                <div class="delivery-form">
                  <div class="form-group">
                    <label class="form-label">Họ và tên người nhận:</label>
                    <input type="text" class="form-input" :value="customerDisplayName" readonly placeholder="Tên khách hàng" />
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Số điện thoại:</label>
                    <input type="text" class="form-input" placeholder="Nhập số điện thoại người nhận" />
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Địa chỉ giao hàng:</label>
                    <textarea class="form-textarea" rows="3" placeholder="Nhập địa chỉ cụ thể để giao hàng"></textarea>
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
                      <select class="form-select" v-model="selectedServiceType" @change="updateShippingFee" :disabled="!selectedShippingCarrier">
                        <option value="">Chọn loại dịch vụ</option>
                        <template v-if="selectedShippingCarrier === 'ghn'">
                          <option value="standard">Tiêu chuẩn (2-3 ngày) - 25.000Đ</option>
                          <option value="express">Nhanh (1-2 ngày) - 35.000Đ</option>
                          <option value="same_day">Trong ngày - 50.000Đ</option>
                        </template>
                        <template v-else-if="selectedShippingCarrier === 'ghtk'">
                          <option value="standard">Tiêu chuẩn (2-4 ngày) - 22.000Đ</option>
                          <option value="express">Nhanh (1-2 ngày) - 30.000Đ</option>
                        </template>
                        <template v-else-if="selectedShippingCarrier === 'vnpost'">
                          <option value="standard">Tiêu chuẩn (3-5 ngày) - 20.000Đ</option>
                          <option value="express">Nhanh (2-3 ngày) - 28.000Đ</option>
                        </template>
                        <template v-else-if="selectedShippingCarrier === 'jnt'">
                          <option value="standard">Tiêu chuẩn (2-3 ngày) - 24.000Đ</option>
                          <option value="express">Nhanh (1-2 ngày) - 32.000Đ</option>
                        </template>
                        <template v-else-if="selectedShippingCarrier === 'grab'">
                          <option value="standard">Standard (2-4h) - 40.000Đ</option>
                          <option value="express">Express (1-2h) - 60.000Đ</option>
                        </template>
                        <template v-else-if="selectedShippingCarrier === 'shopee'">
                          <option value="standard">Tiêu chuẩn (2-3 ngày) - 23.000Đ</option>
                          <option value="express">Nhanh (1-2 ngày) - 31.000Đ</option>
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
                        <span class="total-value">{{ formatFinalShippingFee() }}</span>
                      </div>
                    </div>
                    
                    <div class="shipping-note" v-if="selectedShippingCarrier">
                      <div class="carrier-info">
                        <div class="carrier-logo">
                          <span class="carrier-name">{{ getCarrierDisplayName() }}</span>
                        </div>
                        <div class="delivery-estimate">
                          <span class="estimate-text">{{ getDeliveryEstimate() }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div class="delivery-note">
                  <div class="note-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <circle cx="12" cy="12" r="10"/>
                      <path d="M12 16v-4M12 8h.01"/>
                    </svg>
                  </div>
                  <div class="note-content">
                    <p><strong>Lưu ý quan trọng:</strong></p>
                    <ul>
                      <li>Vui lòng kiểm tra kỹ sản phẩm trước khi thanh toán</li>
                      <li>Thanh toán tiền mặt khi nhận hàng</li>
                      <li>Liên hệ hotline: <strong>1900-xxx-xxx</strong> nếu cần hỗ trợ</li>
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
                  <span class="total-amount">{{ formatCurrency(currentOrder?.tongTien || 0) }}</span>
                </div>
                <div class="total-row" v-if="currentOrder?.discount">
                  <span class="total-label">Giảm giá:</span>
                  <span class="total-amount discount-amount">-{{ formatCurrency(currentOrder.discount) }}</span>
                </div>
                <div class="total-divider"></div>
                <div class="total-row final-row">
                  <span class="final-label">Thành tiền:</span>
                  <span class="final-amount">{{ formatCurrency((currentOrder?.tongTien || 0) - (currentOrder?.discount || 0)) }}</span>
                </div>
              </div>
            </div>

            <!-- Confirm Order Button -->
            <button class="confirm-order-btn" @click="confirmOrder" 
                    :disabled="!currentOrder || !currentOrder.danhSachSanPham?.length || !customerDisplayName.trim()">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 12l2 2 4-4"/>
                <circle cx="12" cy="12" r="10"/>
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
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <div class="modal-body">
          <!-- Clean Search Header -->
          <div class="search-header">
            <div class="main-search-container">
              <div class="search-input-wrapper">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="search-icon">
                  <circle cx="11" cy="11" r="8"></circle>
                  <path d="M21 21l-4.35-4.35"></path>
                </svg>
                <input type="text" v-model="productSearchQuery" class="main-search-input" placeholder="Tìm theo tên sản phẩm, mã sản phẩm..." />
              </div>
              
              <div class="price-filter-compact">
                <span class="price-label">Khoảng giá:</span>
                <div class="price-display">
                  <span class="price-value">{{ formatCurrency(priceRange.min) }}</span>
                  <input type="range" :min="priceRange.min" :max="priceRange.max" v-model="selectedPriceMax" class="price-slider" />
                  <span class="price-value">{{ formatCurrency(priceRange.max) }}</span>
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
                  <path d="M3 6h18M8 6V4a2 2 0 012-2h4a2 2 0 012 2v2m3 0v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6"/>
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
                <div class="product-details">
                  <span class="product-code">{{ product.maSanPham }}</span>
                  <span class="product-brand">{{ product.tenNhaSanXuat }}</span>
                </div>
                <div class="product-specs">
                  <span class="spec">{{ product.tenMauSac }}</span>
                  <span class="spec">{{ product.tenKichThuoc }}</span>
                  <span class="spec">{{ product.tenChatLieu }}</span>
                </div>
                <div class="product-pricing">
                  <span v-if="product.giaTriGiamGia > 0" class="original-price">{{ formatCurrency(product.giaBan)
                  }}</span>
                  <span class="current-price">{{
                    formatCurrency(
                      (product.giaBan / 100) * (100 - product.giaTriGiamGia)
                    )
                  }}</span>
                </div>
              </div>

              <div class="product-actions">
                <button class="add-to-cart-btn" @click="addProductToCart(product)">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path
                      d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-2.5 5M7 13l2.5 5m6-5v6a2 2 0 01-2 2H9a2 2 0 01-2-2v-6m8 0V9a2 2 0 00-2-2H9a2 2 0 00-2 2v4.01" />
                  </svg>
                  <span>Thêm vào giỏ</span>
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
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <div class="customer-modal-body">
          <div class="customer-search-section">
            <div class="search-input-container">
              <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/>
                <path d="M21 21l-4.35-4.35"/>
              </svg>
              <input type="text" v-model="customerSearchQuery" class="customer-search-input"
                placeholder="Tìm kiếm tên hoặc số điện thoại hoặc email" />
            </div>
            <button class="add-customer-btn" @click="openAddCustomerForm">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 5v14M5 12h14"/>
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
                  <div class="table-cell">{{ customer.ngaySinh || '1998-03-10' }}</div>
                  <div class="table-cell">{{ customer.soDienThoai }}</div>
                  <div class="table-cell">
                    <span class="gender-badge">{{ customer.gioiTinh ? "Nam" : "Nữ" }}</span>
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
                  <input type="email" v-model="newCustomerForm.email" class="modern-form-input" 
                         placeholder="Nhập email" required />
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
                <path d="M21 12v-2a2 2 0 00-2-2H5a2 2 0 00-2 2v2"/>
                <path d="M21 12v2a2 2 0 01-2 2H5a2 2 0 01-2-2v-2"/>
                <circle cx="9" cy="12" r="1"/>
                <circle cx="15" cy="12" r="1"/>
              </svg>
            </div>
            <div class="header-text">
              <h3 class="modal-title">Chọn phiếu giảm giá</h3>
              <p class="modal-subtitle">Chọn phiếu giảm giá phù hợp cho đơn hàng của bạn</p>
            </div>
          </div>
          <button class="modern-close-btn" @click="closeCouponModal">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <div class="coupon-modal-body">
          <div class="order-info-card">
            <div class="order-summary">
              <span class="order-label">Tổng đơn hàng:</span>
              <span class="order-amount">{{ formatCurrency(currentOrder?.tongTien || 0) }}</span>
            </div>
          </div>

          <div class="coupon-grid">
            <div v-for="coupon in availableCoupons" :key="coupon.id" 
                 class="modern-coupon-card" 
                 :class="{
                   selected: isCouponSelected(coupon.id),
                   disabled: !canApplyCoupon(coupon),
                   percentage: coupon.loaiPhieuGiamGia === false,
                   fixed: coupon.loaiPhieuGiamGia === true
                 }" 
                 @click="canApplyCoupon(coupon) ? toggleCouponSelection(coupon) : null">
              
              <div class="coupon-badge">
                <div class="discount-icon">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path v-if="coupon.loaiPhieuGiamGia === false" d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                    <path v-else d="M12 2v20M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
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
                      Tiết kiệm: {{ formatCurrency(calculateCouponDiscount(coupon)) }}
                    </div>
                  </div>
                  
                  <div v-if="coupon.donHangToiThieu" class="min-order-requirement">
                    Đơn tối thiểu: {{ formatCurrency(coupon.donHangToiThieu) }}
                  </div>
                </div>

                <div v-if="!canApplyCoupon(coupon)" class="unavailable-reason">
                  <div class="reason-icon">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <circle cx="12" cy="12" r="10"/>
                      <path d="M15 9l-6 6M9 9l6 6"/>
                    </svg>
                  </div>
                  <span v-if="coupon.donHangToiThieu && currentOrder.tongTien < coupon.donHangToiThieu">
                    Chưa đủ giá trị tối thiểu
                  </span>
                  <span v-else-if="selectedCoupons.length > 0 && !selectedCoupons.some((c) => c.id === coupon.id)">
                    Chỉ được chọn 1 phiếu
                  </span>
                  <span v-else>Phiếu không khả dụng</span>
                </div>
              </div>

              <div class="coupon-selection">
                <div class="custom-radio">
                  <input type="radio" 
                         :id="'coupon-' + coupon.id" 
                         :name="'coupon-selection'" 
                         :checked="isCouponSelected(coupon.id)" 
                         :disabled="!canApplyCoupon(coupon)" 
                         @change="toggleCouponSelection(coupon)" />
                  <label :for="'coupon-' + coupon.id" class="radio-label"></label>
                </div>
              </div>
            </div>

            <div v-if="availableCoupons.length === 0" class="no-coupons-state">
              <div class="empty-icon">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <path d="M21 12v-2a2 2 0 00-2-2H5a2 2 0 00-2 2v2"/>
                  <path d="M21 12v2a2 2 0 01-2 2H5a2 2 0 01-2-2v-2"/>
                  <circle cx="9" cy="12" r="1"/>
                  <circle cx="15" cy="12" r="1"/>
                </svg>
              </div>
              <h4 class="empty-title">Chưa có phiếu giảm giá</h4>
              <p class="empty-description">Hiện tại không có phiếu giảm giá nào khả dụng cho đơn hàng này.</p>
            </div>
          </div>
        </div>

        <div class="coupon-modal-footer">
          <div class="selection-summary">
            <div class="selection-info">
              <span v-if="selectedCoupons.length > 0" class="selected-text">
                🎉 Đã chọn 1 phiếu giảm giá
              </span>
              <span v-else class="no-selection-text">
                Chưa chọn phiếu nào
              </span>
            </div>
            <div v-if="selectedCoupons.length > 0" class="total-savings">
              Tiết kiệm: {{ formatCurrency(calculateCouponDiscount(selectedCoupons[0])) }}
            </div>
          </div>
          
          <div class="modal-actions">
            <button class="cancel-btn" @click="closeCouponModal">
              Hủy
            </button>
            <button class="confirm-btn" @click="confirmCouponSelection" :disabled="selectedCoupons.length === 0">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 6L9 17l-5-5"/>
              </svg>
              {{ selectedCoupons.length > 0 ? 'Xác nhận (1 phiếu)' : 'Xác nhận' }}
            </button>
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

import { computed, onMounted, ref, watch } from "vue";
import { fetchCreateHoaDon } from "../../services/BanHang/HoaDonService";
import {
  fetchActivePhieuGiamGiaForCustomer,
  fetchAllPhieuGiamGia,
} from "../../services/GiamGia/PhieuGiamGiaService";
import {
  fetchAllKhachHang,
  fetchQuickAddKhachHang,
  fetchUpdateKhachHang
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
      `🎫 Tự động áp dụng phiếu giảm giá tốt nhất: ${bestCoupon.tenPhieuGiamGia
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
          .replace('<img :src="PlusIcon" alt="Plus" class="icon-sm" /> Tạo khách hàng mới: "', "")
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
};

// Copy to clipboard function
const copyToClipboard = async (text) => {
  try {
    await navigator.clipboard.writeText(text);
    // You can add a toast notification here if needed
    console.log('Đã sao chép:', text);
  } catch (error) {
    console.error('Lỗi sao chép:', error);
    // Fallback method for older browsers
    const textArea = document.createElement('textarea');
    textArea.value = text;
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    try {
      document.execCommand('copy');
      console.log('Đã sao chép (fallback):', text);
    } catch (fallbackError) {
      console.error('Lỗi sao chép fallback:', fallbackError);
    }
    document.body.removeChild(textArea);
  }
};

// Refresh data function
const refreshData = async () => {
  try {
    console.log('Làm mới dữ liệu...');
    await fetchAll();
    console.log('Đã làm mới dữ liệu thành công!');
  } catch (error) {
    console.error('Lỗi khi làm mới dữ liệu:', error);
  }
};

// Clear all filters function
const clearAllFilters = () => {
  selectedNhaSanXuat.value = '';
  selectedXuatXu.value = '';
  selectedChatLieu.value = '';
  selectedSize.value = '';
  selectedDeGiay.value = '';
  selectedMauSac.value = '';
  productSearchQuery.value = '';
};

// Shipping carrier utility functions
const getShippingFeeByCarrierAndService = (carrier, serviceType) => {
  const feeMap = {
    ghn: { standard: 25000, express: 35000, same_day: 50000 },
    ghtk: { standard: 22000, express: 30000 },
    vnpost: { standard: 20000, express: 28000 },
    jnt: { standard: 24000, express: 32000 },
    grab: { standard: 40000, express: 60000 },
    shopee: { standard: 23000, express: 31000 }
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
  const orderTotal = (currentOrder.value?.tongTien || 0) - (currentOrder.value?.discount || 0);
  return orderTotal >= 500000 && shippingFee.value > 0;
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
    shopee: "Shopee Express"
  };
  return carrierNames[selectedShippingCarrier.value] || "";
};

const getDeliveryEstimate = () => {
  if (!selectedShippingCarrier.value || !selectedServiceType.value) return "";
  
  const estimates = {
    ghn: { standard: "Giao trong 2-3 ngày", express: "Giao trong 1-2 ngày", same_day: "Giao trong ngày" },
    ghtk: { standard: "Giao trong 2-4 ngày", express: "Giao trong 1-2 ngày" },
    vnpost: { standard: "Giao trong 3-5 ngày", express: "Giao trong 2-3 ngày" },
    jnt: { standard: "Giao trong 2-3 ngày", express: "Giao trong 1-2 ngày" },
    grab: { standard: "Giao trong 2-4 giờ", express: "Giao trong 1-2 giờ" },
    shopee: { standard: "Giao trong 2-3 ngày", express: "Giao trong 1-2 ngày" }
  };
  
  return estimates[selectedShippingCarrier.value]?.[selectedServiceType.value] || "";
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
