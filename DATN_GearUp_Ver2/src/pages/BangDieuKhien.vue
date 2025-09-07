<template>
  <div class="dashboard">
    <!-- Action Buttons -->
    <div class="action-buttons">
      <button class="modern-btn refresh-btn" @click="refreshData">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <polyline points="23,4 23,10 17,10"></polyline>
          <polyline points="1,20 1,14 7,14"></polyline>
          <path d="M20.49,9A9,9,0,0,0,5.64,5.64L1,10m22,4L18.36,18.36A9,9,0,0,1,3.51,15"></path>
        </svg>
            Làm mới
          </button>
      <button class="modern-btn export-btn" @click="exportData">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M21,15v4a2,2,0,0,1-2,2H5a2,2,0,0,1-2-2V15"></path>
          <polyline points="7,10 12,15 17,10"></polyline>
          <line x1="12" y1="15" x2="12" y2="3"></line>
        </svg>
            Xuất báo cáo
          </button>
    </div>

    <!-- Modern Key Metrics -->
    <div class="modern-metrics-grid">
      <!-- Revenue Card -->
      <div v-if="!loadingMetrics" class="modern-metric-card revenue-card">
        <div class="metric-background"></div>
        <div class="metric-content">
          <div class="metric-header">
            <div class="metric-icon-wrapper">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="12" y1="1" x2="12" y2="23"></line>
                <path d="M17,5H9.5a3.5,3.5,0,0,0,0,7h5a3.5,3.5,0,0,1,0,7H6"></path>
              </svg>
        </div>
            <div class="metric-trend positive">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="23,6 13.5,15.5 8.5,10.5 1,18"></polyline>
                <polyline points="17,6 23,6 23,12"></polyline>
              </svg>
              +12.5%
        </div>
      </div>
          <div class="metric-body">
          <h3 class="metric-title">Tổng doanh thu</h3>
          <p class="metric-value">{{ formatCurrency(totalRevenue) }}</p>
          <p class="metric-subtitle">So với tháng trước</p>
          </div>
        </div>
      </div>

      <!-- Orders Card -->
      <div v-if="!loadingMetrics" class="modern-metric-card orders-card">
        <div class="metric-background"></div>
        <div class="metric-content">
        <div class="metric-header">
            <div class="metric-icon-wrapper">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M16,4h2a2,2,0,0,1,2,2v14a2,2,0,0,1-2,2H6a2,2,0,0,1-2-2V6A2,2,0,0,1,6,4H8"></path>
                <rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect>
              </svg>
        </div>
            <div class="metric-trend positive">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="23,6 13.5,15.5 8.5,10.5 1,18"></polyline>
                <polyline points="17,6 23,6 23,12"></polyline>
              </svg>
              +8.2%
            </div>
          </div>
          <div class="metric-body">
          <h3 class="metric-title">Tổng đơn hàng</h3>
          <p class="metric-value">{{ totalOrders }}</p>
          <p class="metric-subtitle">Trong tháng này</p>
          </div>
        </div>
      </div>

      <!-- Products Card -->
      <div v-if="!loadingMetrics" class="modern-metric-card products-card">
        <div class="metric-background"></div>
        <div class="metric-content">
        <div class="metric-header">
            <div class="metric-icon-wrapper">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M6,2L3,6V20a2,2,0,0,0,2,2H19a2,2,0,0,0,2-2V6L18,2Z"></path>
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <path d="M16,10a4,4,0,0,1-8,0"></path>
              </svg>
        </div>
            <div class="metric-trend neutral">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="5" y1="12" x2="19" y2="12"></line>
              </svg>
              0%
            </div>
          </div>
          <div class="metric-body">
          <h3 class="metric-title">Sản phẩm bán</h3>
          <p class="metric-value">{{ totalProducts }}</p>
          <p class="metric-subtitle">Sản phẩm khác nhau</p>
          </div>
        </div>
      </div>

      <!-- Customers Card -->
      <div v-if="!loadingMetrics" class="modern-metric-card customers-card">
        <div class="metric-background"></div>
        <div class="metric-content">
        <div class="metric-header">
            <div class="metric-icon-wrapper">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20,21v-2a4,4,0,0,0-4-4H8a4,4,0,0,0-4,4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
        </div>
            <div class="metric-trend positive">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="23,6 13.5,15.5 8.5,10.5 1,18"></polyline>
                <polyline points="17,6 23,6 23,12"></polyline>
              </svg>
              +15.1%
            </div>
          </div>
          <div class="metric-body">
          <h3 class="metric-title">Khách hàng mới</h3>
          <p class="metric-value">{{ newCustomers }}</p>
          <p class="metric-subtitle">Trong tuần này</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Modern Time-based Stats -->
    <div class="modern-stats-grid">
      <!-- Today Stats -->
      <div class="modern-stat-card today-card">
        <div class="stat-background"></div>
        <div class="stat-content">
        <div class="stat-header">
            <div class="stat-icon-wrapper">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"></circle>
                <polyline points="12,6 12,12 16,14"></polyline>
              </svg>
            </div>
          <div class="stat-period">Hôm nay</div>
        </div>
          <div class="stat-body">
          <div class="stat-main">
            <h3 class="stat-amount">{{ formatCurrency(todayStats.revenue) }}</h3>
              <div class="stat-change positive">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <polyline points="23,6 13.5,15.5 8.5,10.5 1,18"></polyline>
                  <polyline points="17,6 23,6 23,12"></polyline>
                </svg>
                +{{ ((todayStats.revenue / weekStats.revenue * 7 - 1) * 100).toFixed(1) }}%
              </div>
          </div>
          <div class="stat-details">
            <div class="stat-item">
              <span class="stat-label">Sản phẩm</span>
              <span class="stat-value">{{ todayStats.products }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn thành công</span>
              <span class="stat-value">{{ todayStats.completedOrders }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn hủy</span>
              <span class="stat-value">{{ todayStats.cancelledOrders }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Week Stats -->
      <div class="modern-stat-card week-card">
        <div class="stat-background"></div>
        <div class="stat-content">
        <div class="stat-header">
            <div class="stat-icon-wrapper">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                <line x1="16" y1="2" x2="16" y2="6"></line>
                <line x1="8" y1="2" x2="8" y2="6"></line>
                <line x1="3" y1="10" x2="21" y2="10"></line>
              </svg>
            </div>
          <div class="stat-period">Tuần này</div>
        </div>
          <div class="stat-body">
          <div class="stat-main">
            <h3 class="stat-amount">{{ formatCurrency(weekStats.revenue) }}</h3>
              <div class="stat-change positive">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <polyline points="23,6 13.5,15.5 8.5,10.5 1,18"></polyline>
                  <polyline points="17,6 23,6 23,12"></polyline>
                </svg>
                +{{ ((weekStats.revenue / monthStats.revenue * 4 - 1) * 100).toFixed(1) }}%
              </div>
          </div>
          <div class="stat-details">
            <div class="stat-item">
              <span class="stat-label">Sản phẩm</span>
              <span class="stat-value">{{ weekStats.products }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn thành công</span>
              <span class="stat-value">{{ weekStats.completedOrders }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn hủy</span>
              <span class="stat-value">{{ weekStats.cancelledOrders }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Month Stats -->
      <div class="modern-stat-card month-card">
        <div class="stat-background"></div>
        <div class="stat-content">
        <div class="stat-header">
            <div class="stat-icon-wrapper">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3,3v18h18"></path>
                <path d="M18.7,8l-5.1,5.2-2.8-2.7L7,14.3"></path>
              </svg>
            </div>
          <div class="stat-period">Tháng này</div>
        </div>
          <div class="stat-body">
          <div class="stat-main">
            <h3 class="stat-amount">{{ formatCurrency(monthStats.revenue) }}</h3>
              <div class="stat-change neutral">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                0%
              </div>
          </div>
          <div class="stat-details">
            <div class="stat-item">
              <span class="stat-label">Sản phẩm</span>
              <span class="stat-value">{{ monthStats.products }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn thành công</span>
              <span class="stat-value">{{ monthStats.completedOrders }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn hủy</span>
              <span class="stat-value">{{ monthStats.cancelledOrders }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Year Stats -->
      <div class="modern-stat-card year-card">
        <div class="stat-background"></div>
        <div class="stat-content">
        <div class="stat-header">
            <div class="stat-icon-wrapper">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21,16V8a2,2,0,0,0-1-1.73l-7-4a2,2,0,0,0-2,0l-7,4A2,2,0,0,0,3,8v8a2,2,0,0,0,1,1.73l7,4a2,2,0,0,0,2,0l7-4A2,2,0,0,0,21,16Z"></path>
                <polyline points="3.27,6.96 12,12.01 20.73,6.96"></polyline>
                <line x1="12" y1="22.08" x2="12" y2="12"></line>
              </svg>
            </div>
          <div class="stat-period">Năm này</div>
        </div>
          <div class="stat-body">
          <div class="stat-main">
            <h3 class="stat-amount">{{ formatCurrency(yearStats.revenue) }}</h3>
              <div class="stat-change positive">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <polyline points="23,6 13.5,15.5 8.5,10.5 1,18"></polyline>
                  <polyline points="17,6 23,6 23,12"></polyline>
                </svg>
                +25.3%
              </div>
          </div>
          <div class="stat-details">
            <div class="stat-item">
              <span class="stat-label">Sản phẩm</span>
              <span class="stat-value">{{ yearStats.products }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn thành công</span>
              <span class="stat-value">{{ yearStats.completedOrders }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Đơn hủy</span>
              <span class="stat-value">{{ yearStats.cancelledOrders }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modern Filter Section -->
    <div class="modern-filter-section">
      <div class="filter-container">
        <!-- Quick Period Selector -->
        <div class="quick-filters">
          <div class="quick-filter-label">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" class="filter-icon">
              <path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/>
            </svg>
            <span>Thời gian</span>
          </div>
          <div class="period-chips">
            <button 
              v-for="period in filterPeriods.slice(0, 4)" 
              :key="period.value"
              :class="['period-chip', { active: selectedPeriod.value === period.value }]"
              @click="selectedPeriod.value = period.value"
            >
              <span class="chip-icon">{{ period.icon }}</span>
              <span class="chip-text">{{ period.label }}</span>
            </button>
          </div>
        </div>

        <!-- Custom Date Range -->
        <div class="custom-date-filter" :class="{ active: selectedPeriod === 'TUY_CHINH' }">
          <button 
            :class="['custom-toggle', { active: selectedPeriod === 'TUY_CHINH' }]"
            @click="selectedPeriod = 'TUY_CHINH'"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/>
            </svg>
            <span>Tùy chỉnh</span>
          </button>
          <div class="date-range-inputs" v-show="selectedPeriod === 'TUY_CHINH'">
            <div class="date-input-group">
              <input type="date" v-model="fromDate" class="modern-date-input" placeholder="Từ ngày">
            </div>
            <div class="date-separator">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
              </svg>
            </div>
            <div class="date-input-group">
              <input type="date" v-model="toDate" class="modern-date-input" placeholder="Đến ngày">
            </div>
          </div>
        </div>

        <!-- Filter Actions -->
        <div class="filter-actions">
          <button class="filter-apply-btn" @click="applyFilters">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z"/>
            </svg>
            Áp dụng
          </button>
          <button class="filter-reset-btn" @click="resetFilters">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 8 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Main Revenue Chart -->
    <div class="main-analytics-section">
      <div class="analytics-card large">
        <div class="card-header">
          <div class="header-content">
            <h4 class="card-title">{{ currentChartTitle }}</h4>
            <p class="card-subtitle">{{ currentChartSubtitle }}</p>
          </div>
          <div class="header-actions">
            <button class="action-btn" @click="changeChartType">
              <span class="action-icon"></span>
            </button>
          </div>
        </div>
        <div class="card-body">
          <div v-if="loadingChart" class="chart-wrapper skeleton-chart">
            <div class="skeleton-chart-content"></div>
          </div>
          <div v-if="!loadingChart" class="chart-wrapper">
            <canvas ref="salesChart" class="main-chart"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- Content Grid: Products & Status/Quick Stats -->
    <div class="content-grid">
      <!-- Top Products Table -->
      <div class="left-column">
        <div class="redesigned-products-card">
          <div class="products-card-header">
            <div class="products-header-content">
              <div class="products-icon-wrapper">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                  <line x1="3" y1="6" x2="21" y2="6"/>
                  <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
            </div>
              <div class="products-title-section">
                <h3 class="products-main-title">Sản phẩm bán chạy</h3>
                <p class="products-subtitle">Top 5 sản phẩm có doanh số cao nhất</p>
            </div>
          </div>
            <button class="products-view-all-btn">
              <span>Xem tất cả</span>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M5 12h14"/>
                <path d="M12 5l7 7-7 7"/>
              </svg>
            </button>
                </div>
          
          <div class="products-content">
            <div v-if="loadingProducts" class="redesigned-products-list">
              <div class="redesigned-product-item skeleton" v-for="i in 5" :key="i">
                <div class="skeleton-rank-badge"></div>
                <div class="skeleton-product-image"></div>
                <div class="skeleton-product-info">
                  <div class="skeleton-product-name"></div>
                  <div class="skeleton-product-details"></div>
              </div>
                <div class="skeleton-trend-badge"></div>
            </div>
            </div>
            <div v-if="!loadingProducts" class="redesigned-products-list">
              <div class="redesigned-product-item" v-for="(product, index) in topProducts.slice(0, 5)" :key="product.id">
                <div class="product-rank-badge" :class="'rank-' + (index + 1)">
                  <span class="rank-number">{{ index + 1 }}</span>
                </div>
                <div class="product-image-container">
                  <div class="product-image-placeholder">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                      <circle cx="8.5" cy="8.5" r="1.5"/>
                      <polyline points="21,15 16,10 5,21"/>
                    </svg>
                </div>
                  </div>
                <div class="product-details-section">
                  <h4 class="product-name">{{ product.name.length > 40 ? product.name.substring(0, 40) + '...' : product.name }}</h4>
                  <div class="product-metrics">
                    <div class="product-price">{{ formatCurrency(product.price) }}</div>
                    <div class="product-sales-count">{{ product.quantity }} đã bán</div>
                </div>
                </div>
                <div class="product-trend-badge positive">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="23,6 13.5,15.5 8.5,10.5 1,18"/>
                    <polyline points="17,6 23,6 23,12"/>
                  </svg>
                  <span>+12%</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Right Column: Order Status & Quick Stats -->
      <div class="right-column">
        <!-- Order Status Distribution -->
        <div class="redesigned-status-card">
          <div class="status-card-header">
            <div class="status-header-content">
              <div class="status-icon-wrapper">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M9 11H5a2 2 0 0 0-2 2v3c0 1.1.9 2 2 2h4m0-7v7m0-7h10a2 2 0 0 1 2 2v3c0 1.1-.9 2-2 2H9m0-7V9a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/>
                </svg>
              </div>
              <div class="status-title-section">
                <h3 class="status-main-title">Trạng thái đơn hàng</h3>
                <p class="status-subtitle">Phân bố theo tình trạng xử lý</p>
              </div>
            </div>
            <div class="status-total">
              <span class="total-number">{{ orderStatus.filter(s => s.count > 0).reduce((sum, s) => sum + s.count, 0) }}</span>
              <span class="total-label">Tổng đơn</span>
            </div>
          </div>
          
          <div class="status-content">
            <div class="status-chart-container">
              <div class="redesigned-chart-wrapper">
                <canvas ref="statusChart" class="redesigned-status-chart"></canvas>
                  </div>
                </div>
            
            <div class="status-list">
              <div class="status-item" v-for="status in orderStatus.filter(s => s.count > 0)" :key="status.name">
                <div class="status-item-header">
                  <div class="status-dot" :style="{ backgroundColor: status.color }"></div>
                  <span class="status-label">{{ status.name }}</span>
              </div>
                <div class="status-item-stats">
                  <span class="status-count">{{ status.count }}</span>
                  <span class="status-percent" :style="{ color: status.color }">{{ status.percentage }}%</span>
                  </div>
                <div class="status-progress">
                  <div class="status-progress-bar">
                    <div class="status-progress-fill" :style="{ 
                      width: status.percentage + '%', 
                      backgroundColor: status.color 
                    }"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- Quick Stats Cards - Full Width Section -->
    <div class="quick-stats-section">
      <div class="modern-quick-stats">
        <div class="modern-quick-stat-card target-card">
          <div class="quick-card-background"></div>
          <div class="quick-card-content">
            <div class="quick-header">
              <div class="quick-icon-wrapper target">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-2-8c0-1.1.9-2 2-2s2 .9 2 2-.9 2-2 2-2-.9-2-2z"/>
                </svg>
              </div>
              <div class="quick-title">Mục tiêu tháng</div>
            </div>
            <div class="quick-main-stat">75%</div>
            <div class="modern-progress-container">
              <div class="modern-progress-bar">
                <div class="modern-progress-fill target-fill" style="width: 75%"></div>
              </div>
              <div class="progress-label">Đạt được 75% mục tiêu</div>
            </div>
          </div>
        </div>

        <div class="modern-quick-stat-card pending-card">
          <div class="quick-card-background"></div>
          <div class="quick-card-content">
            <div class="quick-header">
              <div class="quick-icon-wrapper pending">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9z"/>
                </svg>
              </div>
              <div class="quick-title">Chờ xử lý</div>
            </div>
            <div class="quick-main-stat">{{ pendingOrders }}</div>
            <div class="quick-action">
              <button class="modern-action-btn pending">
                <span>Xử lý ngay</span>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
                </svg>
              </button>
            </div>
          </div>
        </div>

        <div class="modern-quick-stat-card stock-card">
          <div class="quick-card-background"></div>
          <div class="quick-card-content">
            <div class="quick-header">
              <div class="quick-icon-wrapper stock">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/>
                </svg>
              </div>
              <div class="quick-title">Sắp hết hàng</div>
            </div>
            <div class="quick-main-stat">{{ lowStockProducts }}</div>
            <div class="quick-action">
              <button class="modern-action-btn stock">
                <span>Bổ sung kho</span>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
                </svg>
              </button>
            </div>
          </div>
        </div>

        <div class="modern-quick-stat-card vip-card">
          <div class="quick-card-background"></div>
          <div class="quick-card-content">
            <div class="quick-header">
              <div class="quick-icon-wrapper vip">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                </svg>
              </div>
              <div class="quick-title">Khách VIP</div>
            </div>
            <div class="quick-main-stat">{{ vipCustomers }}</div>
            <div class="quick-action">
              <button class="modern-action-btn vip">
                <span>Xem chi tiết</span>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
                </svg>
              </button>
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

import { Chart, registerables } from 'chart.js'
import { computed, onMounted, ref, watch } from 'vue'
import { dashboardService } from '../services/response/bangDieuKhien.js'
import { exportToCSV } from '../utils/xuatCSV.js'
import { exportToExcel } from '../utils/xuatExcel.js'

Chart.register(...registerables)

// Data
const selectedPeriod = ref('THANG')
const selectedTimeframe = ref('30d')
const fromDate = ref('')
const toDate = ref('')
const chartInstance = ref(null)

// Loading states
const loading = ref(false)
const loadingMetrics = ref(false)
const loadingChart = ref(false)
const loadingProducts = ref(false)
const loadingOrderStatus = ref(false)

// API Data
const keyMetrics = ref({
  totalRevenue: 0,
  totalOrders: 0,
  totalProducts: 0,
  newCustomers: 0
})

const timeBasedStats = ref({
  today: { revenue: 0, products: 0, completedOrders: 0, cancelledOrders: 0 },
  week: { revenue: 0, products: 0, completedOrders: 0, cancelledOrders: 0 },
  month: { revenue: 0, products: 0, completedOrders: 0, cancelledOrders: 0 },
  year: { revenue: 0, products: 0, completedOrders: 0, cancelledOrders: 0 }
})

const topProductsData = ref([])
const orderStatusData = ref([])
const quickStatsData = ref({
  pendingOrders: 0,
  lowStockProducts: 0,
  vipCustomers: 0
})

const chartData = ref({
  labels: [],
  data: [],
  title: 'Doanh thu theo tháng trong năm'
})

const filterPeriods = [
  { value: 'NGAY', label: 'NGÀY', icon: '📅' },
  { value: 'TUAN', label: 'TUẦN', icon: '📆' },
  { value: 'THANG', label: 'THÁNG', icon: '📈' },
  { value: 'NAM', label: 'NĂM', icon: '📊' },
  { value: 'TUY_CHINH', label: 'TÙY CHỈNH', icon: '⚙️' }
]

// Computed properties for chart
const currentChartData = computed(() => {
  return chartData.value
})

const currentChartTitle = computed(() => {
  return chartData.value.title
})

const currentChartSubtitle = computed(() => {
  const periodLabels = {
    'NGAY': 'hôm nay',
    'TUAN': 'tuần này', 
    'THANG': 'tháng này',
    'NAM': 'các năm gần đây',
    'TUY_CHINH': `từ ${fromDate.value} đến ${toDate.value}`
  }
  const currentPeriod = selectedPeriod.value === 'TUY_CHINH' ? 'TUY_CHINH' : selectedPeriod.value
  return `Phân tích xu hướng ${periodLabels[currentPeriod] || 'tháng này'}`
})

// Key Metrics
const totalRevenue = computed(() => keyMetrics.value.totalRevenue)
const totalOrders = computed(() => keyMetrics.value.totalOrders)
const totalProducts = computed(() => keyMetrics.value.totalProducts)
const newCustomers = computed(() => keyMetrics.value.newCustomers)
const pendingOrders = computed(() => quickStatsData.value.pendingOrders)
const lowStockProducts = computed(() => quickStatsData.value.lowStockProducts)
const vipCustomers = computed(() => quickStatsData.value.vipCustomers)

// Computed properties for API data
const orderStatus = computed(() => orderStatusData.value)
const todayStats = computed(() => timeBasedStats.value.today)
const weekStats = computed(() => timeBasedStats.value.week)
const monthStats = computed(() => timeBasedStats.value.month)
const yearStats = computed(() => timeBasedStats.value.year)
const topProducts = computed(() => topProductsData.value)

const salesChart = ref(null)
const statusChart = ref(null)

// API Methods
const loadKeyMetrics = async () => {
  try {
    loadingMetrics.value = true
    const response = await dashboardService.getKeyMetrics()
    keyMetrics.value = response
  } catch (error) {
    console.error('Error loading key metrics:', error)
  } finally {
    loadingMetrics.value = false
  }
}

const loadTimeBasedStats = async () => {
  try {
    const response = await dashboardService.getTimeBasedStats()
    timeBasedStats.value = response
  } catch (error) {
    console.error('Error loading time-based stats:', error)
  }
}

const loadTopProducts = async () => {
  try {
    loadingProducts.value = true
    const response = await dashboardService.getTopProducts()
    topProductsData.value = response
  } catch (error) {
    console.error('Error loading top products:', error)
  } finally {
    loadingProducts.value = false
  }
}

const loadOrderStatusDistribution = async () => {
  try {
    loadingOrderStatus.value = true
    const response = await dashboardService.getOrderStatusDistribution()
    orderStatusData.value = response
  } catch (error) {
    console.error('Error loading order status distribution:', error)
  } finally {
    loadingOrderStatus.value = false
  }
}

const loadQuickStats = async () => {
  try {
    const response = await dashboardService.getQuickStats()
    quickStatsData.value = response
  } catch (error) {
    console.error('Error loading quick stats:', error)
  }
}

const loadChartData = async (period = null, fromDate = null, toDate = null) => {
  try {
    loadingChart.value = true
    const currentPeriod = period || selectedPeriod.value
    const response = await dashboardService.getChartData(currentPeriod, fromDate, toDate)
    chartData.value = response
  } catch (error) {
    console.error('Error loading chart data:', error)
  } finally {
    loadingChart.value = false
  }
}

const loadAllData = async () => {
  loading.value = true
  try {
    await Promise.all([
      loadKeyMetrics(),
      loadTimeBasedStats(),
      loadTopProducts(),
      loadOrderStatusDistribution(),
      loadQuickStats(),
      loadChartData()
    ])
  } catch (error) {
    console.error('Error loading dashboard data:', error)
  } finally {
    loading.value = false
  }
}

// Methods
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
    minimumFractionDigits: 0
  }).format(amount).replace('₫', 'đ')
}

const refreshData = async () => {
  await loadAllData()
}

const exportData = () => {
  try {
    
    // Create dashboard summary data
    const dashboardData = [
      {
        'Chỉ số': 'Tổng doanh thu',
        'Giá trị': totalRevenue.value,
        'Đơn vị': 'VND',
        'Thay đổi': '+12.5%'
      },
      {
        'Chỉ số': 'Tổng đơn hàng',
        'Giá trị': totalOrders.value,
        'Đơn vị': 'Đơn',
        'Thay đổi': '+8.2%'
      },
      {
        'Chỉ số': 'Sản phẩm đang bán',
        'Giá trị': totalProducts.value,
        'Đơn vị': 'Sản phẩm',
        'Thay đổi': '+15.3%'
      },
      {
        'Chỉ số': 'Khách hàng mới',
        'Giá trị': newCustomers.value,
        'Đơn vị': 'Người',
        'Thay đổi': '+22.1%'
      },
      {
        'Chỉ số': 'Đơn hàng chờ xử lý',
        'Giá trị': pendingOrders.value,
        'Đơn vị': 'Đơn',
        'Thay đổi': '-3.5%'
      },
      {
        'Chỉ số': 'Sản phẩm sắp hết hàng',
        'Giá trị': lowStockProducts.value,
        'Đơn vị': 'Sản phẩm',
        'Thay đổi': '+5.2%'
      },
      {
        'Chỉ số': 'Khách hàng VIP',
        'Giá trị': vipCustomers.value,
        'Đơn vị': 'Người',
        'Thay đổi': '+18.7%'
      }
    ]
    
    
    // Try Excel export first, with CSV fallback
    let result
    
    try {
      result = exportToExcel(
        dashboardData,
        'Dashboard_Summary',
        'Tổng quan Dashboard'
      )
    } catch (xlsxError) {
      console.warn('Excel export failed, trying CSV fallback:', xlsxError)
      result = exportToCSV(dashboardData, 'Dashboard_Summary')
    }
    
    
    if (result && result.success) {
      alert(`✅ ${result.message}`)
    } else {
      alert(`❌ ${result ? result.message : 'Có lỗi xảy ra khi xuất file'}`)
    }
  } catch (error) {
    console.error('Error in dashboard exportData:', error)
    alert(`❌ Có lỗi xảy ra khi xuất file Dashboard: ${error.message}`)
  }
}

const changeChartType = () => {
}

const updateChart = () => {
  
  if (!chartInstance.value) {
    return
  }
  

  if (!chartInstance.value.data || 
      !chartInstance.value.data.datasets || 
      chartInstance.value.data.datasets.length === 0) {
    return
  }

  const newData = currentChartData.value
  
  try {
    // Update chart data
    chartInstance.value.data.labels = [...newData.labels]
    chartInstance.value.data.datasets[0].data = [...newData.data]
    
    // Update chart with smooth animation
    chartInstance.value.update('active')
    
  } catch (error) {
    console.error('Error updating chart: ', error.message)
  }
}

// Watch for period changes and update chart automatically
watch(selectedPeriod, (newPeriod) => {
  setTimeout(() => {
    updateChart()
  }, 50)
})

const applyFilters = async () => {
  // Load new chart data based on filters
  await loadChartData(selectedPeriod.value, fromDate.value, toDate.value)
  
  // Update the chart with new data after a small delay to ensure chart is ready
  setTimeout(() => {
    updateChart()
  }, 100)
}

const resetFilters = () => {
  selectedPeriod.value = 'THANG'
  const today = new Date()
  const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000)
  
  toDate.value = today.toISOString().split('T')[0]
  fromDate.value = lastWeek.toISOString().split('T')[0]
  
  // Update chart after reset with delay
  setTimeout(() => {
    updateChart()
  }, 100)
}

// Chart initialization
onMounted(async () => {
  // Load all dashboard data first
  await loadAllData()

  // Initialize sales trend chart with delay to ensure DOM is ready
  setTimeout(() => {
    if (salesChart.value) {
      try {
        const ctx = salesChart.value.getContext('2d')
        const gradient = ctx.createLinearGradient(0, 0, 0, 400)
        gradient.addColorStop(0, 'rgba(74, 222, 128, 0.3)')
        gradient.addColorStop(1, 'rgba(74, 222, 128, 0)')

        const initialData = currentChartData.value

        chartInstance.value = new Chart(salesChart.value, {
          type: 'line',
          data: {
            labels: initialData.labels,
            datasets: [{
              label: 'Doanh thu (triệu VND)',
              data: initialData.data,
              borderColor: '#4ade80',
              backgroundColor: gradient,
              borderWidth: 3,
              fill: true,
              tension: 0.4,
              pointBackgroundColor: '#4ade80',
              pointBorderColor: '#ffffff',
              pointBorderWidth: 2,
              pointRadius: 6,
              pointHoverRadius: 8
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false
              }
            },
            scales: {
              x: {
                grid: {
                  display: false
                },
                ticks: {
                  color: '#6b7280'
                }
              },
              y: {
                beginAtZero: true,
                grid: {
                  color: '#f3f4f6'
                },
                ticks: {
                  color: '#6b7280',
                  callback: function(value) {
                    return value + 'M'
                  }
                }
              }
            },
            interaction: {
              intersect: false,
              mode: 'index'
            }
          }
        })
        
      } catch (error) {
        console.error('Error initializing sales chart:', error)
      }
    }

    // Initialize modern status chart
    if (statusChart.value) {
      try {
        const filteredStatuses = orderStatus.value.filter(s => s.count > 0)
        new Chart(statusChart.value, {
          type: 'doughnut',
          data: {
            labels: filteredStatuses.map(s => s.name),
            datasets: [{
              data: filteredStatuses.map(s => s.count),
              backgroundColor: filteredStatuses.map(s => s.color),
              borderWidth: 4,
              borderColor: '#ffffff',
              cutout: '70%',
              borderRadius: 12,
              borderJoinStyle: 'round',
              hoverBorderWidth: 6,
              hoverBorderColor: '#ffffff',
              hoverBackgroundColor: filteredStatuses.map(s => {
                // Make colors slightly lighter on hover
                const hex = s.color.replace('#', '')
                const r = parseInt(hex.substr(0, 2), 16)
                const g = parseInt(hex.substr(2, 2), 16)
                const b = parseInt(hex.substr(4, 2), 16)
                return `rgba(${r}, ${g}, ${b}, 0.8)`
              })
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: 1,
            interaction: {
              intersect: false
            },
            plugins: {
              legend: {
                display: false
              },
              tooltip: {
                backgroundColor: 'rgba(30, 41, 59, 0.95)',
                titleColor: '#ffffff',
                bodyColor: '#ffffff',
                borderColor: 'rgba(99, 102, 241, 0.3)',
                borderWidth: 2,
                cornerRadius: 12,
                displayColors: true,
                padding: 12,
                titleFont: {
                  size: 14,
                  weight: 'bold'
                },
                bodyFont: {
                  size: 13,
                  weight: '500'
                },
                callbacks: {
                  title: function(context) {
                    return context[0].label
                  },
                  label: function(context) {
                    const value = context.parsed
                    const total = context.dataset.data.reduce((a, b) => a + b, 0)
                    const percentage = Math.round((value / total) * 100)
                    return ` ${value} đơn hàng (${percentage}%)`
                  }
                }
              }
            },
            animation: {
              animateRotate: true,
              duration: 1200,
              easing: 'easeInOutQuart'
            },
            hover: {
              animationDuration: 300
            },
            elements: {
              arc: {
                borderWidth: 0
              }
            }
          }
        })
        
      } catch (error) {
        console.error('Error initializing status chart:', error)
      }
    }
  }, 200)

  // Set default dates
  const today = new Date()
  const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000)
  
  toDate.value = today.toISOString().split('T')[0]
  fromDate.value = lastWeek.toISOString().split('T')[0]
})
</script>

<style scoped>
/* Import external CSS file cho Bảng Điều Khiển */
@import '../styles/cssTrangChu/bangDieuKhien.css';

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



