<script setup>
import logoUrl from "@/assets/gearup-logo-official.svg";
import { computed, markRaw, onMounted, onUnmounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { setGlobalNotificationInstance } from "../src/services/response/dichVuThongBao.js";
import { useAuth } from "../src/services/response/khoXacThuc.js";
import { useNotifications } from "./composables/useNotifications.js";

const router = useRouter();
const route = useRoute();
const { authState, logout: authLogout, initializeAuth } = useAuth();

const sidebarOpen = ref(localStorage.getItem("sidebarOpen") !== "false"); // Remember sidebar state
const showNotifications = ref(false);
const showUserDropdown = ref(false);
const showAllNotificationsModal = ref(false);
const isModalClosing = ref(false);
const isCountUpdating = ref(false);
const expandedMenus = ref({
  "QUẢN LÝ ĐƠN HÀNG": true,
  "QUẢN LÝ SẢN PHẨM": true,
  "GIẢM GIÁ & KHUYẾN MÃI": true,
  "NGƯỜI DÙNG": true,
});

const expandedSubMenus = ref({
  "Thuộc tính sản phẩm": false,
});

// Notifications
const {
  notifications,
  unreadCount,
  startPolling,
  markAsRead: markAsReadComposable,
  markAllAsRead: markAllAsReadComposable,
  clearAllNotifications,
  addNotification,
  createOrderNotification,
  createProductNotification,
  createCustomerNotification,
  createSystemNotification,
} = useNotifications();

const unreadNotifications = computed(() => unreadCount.value);
const previousUnreadCount = ref(0);

// Filters
const notificationFilters = markRaw([
  { key: "all", label: "Tất cả", icon: "<!-- icon: clipboard -->" },
  { key: "unread", label: "Chưa đọc", icon: "🔴" },
  { key: "order", label: "Đơn hàng", icon: "<!-- icon: cart -->" },
  { key: "inventory", label: "Kho hàng", icon: "<!-- icon: package -->" },
  { key: "review", label: "Đánh giá", icon: "<!-- icon: star -->" },
  { key: "customer", label: "Khách hàng", icon: "<!-- icon: users -->" },
  { key: "report", label: "Báo cáo", icon: "<!-- icon: chart -->" },
]);

const selectedFilter = ref("all");

// Current user data from auth state
const currentUser = computed(() => {
  if (!authState.user) {
    return {
      name: "Guest",
      role: "guest",
      fullName: "Khách",
    };
  }

  return {
    name: authState.user.hoTen || "User",
    role: authState.user.loaiNguoiDung === "nhan_vien" ? "staff" : "customer",
    fullName: authState.user.hoTen || "User",
    quyenHan: authState.user.quyenHan,
  };
});

// Check if current route is login page
const isLoginPage = computed(() => route.path === "/login");

// Compute current page title for breadcrumb
const currentPageTitle = computed(() => {
  const pathTitles = {
    // Main routes
    '/': 'Bảng điều khiển',
    '/dashboard': 'Bảng điều khiển', 
    '/login': 'Đăng nhập',

    // User Management
    '/users/nhan-vien': 'Quản lý nhân viên',
    '/users/khach-hang': 'Quản lý khách hàng',

    // Product Management
    '/products': 'Quản lý sản phẩm',
    '/products/add': 'Thêm sản phẩm mới',
    '/products/xuat-xu': 'Quản lý xuất xứ',
    '/products/nha-san-xuat': 'Quản lý nhà sản xuất', 
    '/products/mau-sac': 'Quản lý màu sắc',
    '/products/kich-thuoc': 'Quản lý kích thước',
    '/products/de-giay': 'Quản lý đế giày',
    '/products/chat-lieu': 'Quản lý chất liệu',
    '/products/trong-luong': 'Quản lý trọng lượng',
    '/products/anh-san-pham': 'Quản lý ảnh sản phẩm',

    // Sales & Orders
    '/sales/pos': 'Hệ thống bán hàng (POS)',
    '/sales/orders': 'Quản lý đơn hàng',
    '/sales/returns': 'Quản lý đơn trả hàng',

    // Marketing & Promotions
    '/marketing/discounts': 'Giảm Giá',
    '/marketing/campaigns': 'Khuyến Mãi',
    '/marketing/vouchers': 'Quản lý phiếu người dùng',

    // Customer Engagement
    '/customers/carts': 'Quản lý giỏ hàng',
    '/customers/favorites': 'Quản lý danh sách yêu thích',
    '/customers/reviews': 'Quản lý đánh giá sản phẩm',
    '/customers/comments': 'Quản lý bình luận',

    // Communication
    '/communication/notifications': 'Quản lý thông báo hệ thống',
    '/communication/contacts': 'Quản lý liên hệ khách hàng',

    // Inventory Management
    '/inventory/imports': 'Quản lý phiếu nhập kho',

    // Analytics & System
    '/analytics/price-history': 'Quản lý lịch sử giá bán',
    '/system/activity-logs': 'Nhật ký hoạt động hệ thống',

    // Legacy routes (redirected routes should show target page title)
    '/orders': 'Quản lý đơn hàng',
    '/pos': 'Hệ thống bán hàng (POS)',
    '/employees': 'Quản lý nhân viên', 
    '/customers': 'Quản lý khách hàng',
    '/discounts': 'Giảm Giá',
    '/returns': 'Quản lý đơn trả hàng',
    '/reviews': 'Quản lý đánh giá sản phẩm'
  };
  
  // Handle dynamic routes like /products/details/:id
  if (route.path.startsWith('/products/details/')) {
    return 'Chi tiết sản phẩm';
  }
  
  // Debug: Log current route to console (can be removed later)
  if (process.env.NODE_ENV === 'development') {
    console.log('Current route path:', route.path);
    console.log('Available paths:', Object.keys(pathTitles));
  }
  
  return pathTitles[route.path] || `Trang không xác định (${route.path})`;
});

// Computed for display name with role
const displayName = computed(() => {
  const user = currentUser.value;

  if (user.role === "staff") {
    // For employees, show Admin or Staff based on permission
    const roleLabel = user.quyenHan === "Admin" ? "Admin" : "Staff";
    return {
      name: user.name,
      role: roleLabel,
    };
  } else if (user.role === "customer") {
    return {
      name: user.name,
      role: "Customer",
    };
  } else {
    return {
      name: user.name,
      role: "Guest",
    };
  }
});

// Page title from route (use same titles as breadcrumb for consistency)
const pageTitle = computed(() => {
  const titleMap = {
    // Main routes
    '/': 'Bảng điều khiển',
    '/dashboard': 'Bảng điều khiển',
    '/login': 'Đăng nhập',

    // User Management
    '/users/nhan-vien': 'Quản lý nhân viên',
    '/users/khach-hang': 'Quản lý khách hàng',

    // Product Management
    '/products': 'Quản lý sản phẩm',
    '/products/add': 'Thêm sản phẩm mới',
    '/products/xuat-xu': 'Quản lý xuất xứ',
    '/products/nha-san-xuat': 'Quản lý nhà sản xuất',
    '/products/mau-sac': 'Quản lý màu sắc',
    '/products/kich-thuoc': 'Quản lý kích thước',
    '/products/de-giay': 'Quản lý đế giày',
    '/products/chat-lieu': 'Quản lý chất liệu',
    '/products/trong-luong': 'Quản lý trọng lượng',
    '/products/anh-san-pham': 'Quản lý ảnh sản phẩm',

    // Sales & Orders
    '/sales/pos': 'Hệ thống bán hàng (POS)',
    '/sales/orders': 'Quản lý đơn hàng',
    '/sales/returns': 'Quản lý đơn trả hàng',

    // Marketing & Promotions
    '/marketing/discounts': 'Giảm Giá',
    '/marketing/campaigns': 'Khuyến Mãi',
    '/marketing/vouchers': 'Quản lý phiếu người dùng',

    // Customer Engagement
    '/customers/carts': 'Quản lý giỏ hàng',
    '/customers/favorites': 'Quản lý danh sách yêu thích',
    '/customers/reviews': 'Quản lý đánh giá sản phẩm',
    '/customers/comments': 'Quản lý bình luận',

    // Communication
    '/communication/notifications': 'Quản lý thông báo hệ thống',
    '/communication/contacts': 'Quản lý liên hệ khách hàng',

    // Inventory Management
    '/inventory/imports': 'Quản lý phiếu nhập kho',

    // Analytics & System
    '/analytics/price-history': 'Quản lý lịch sử giá bán',
    '/system/activity-logs': 'Nhật ký hoạt động hệ thống',
  };
  
  // Handle dynamic routes
  if (route.path.startsWith('/products/details/')) {
    return 'Chi tiết sản phẩm';
  }
  
  return titleMap[route.path] || "GearUp Admin";
});

const menuItems = [
  // Dashboard Section
  {
    path: "/dashboard",
    name: "THỐNG KÊ & BÁO CÁO",
    iconSvg: `<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
      <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>
    </svg>`,
    hasSubmenu: false,
  },

  // Order Management Section
  {
    name: "QUẢN LÝ ĐƠN HÀNG",
    iconSvg: `<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
      <path d="M7 4V2C7 1.45 7.45 1 8 1H16C16.55 1 17 1.45 17 2V4H20C20.55 4 21 4.45 21 5S20.55 6 20 6H19V19C19 20.1 18.1 21 17 21H7C5.9 21 5 20.1 5 19V6H4C3.45 6 3 5.55 3 5S3.45 4 4 4H7ZM9 3V4H15V3H9ZM7 6V19H17V6H7Z"/>
    </svg>`,
    hasSubmenu: true,
    submenu: [
      { path: "/sales/pos", name: "Bán hàng tại quầy" },
      { path: "/sales/orders", name: "Danh sách đơn hàng" },
      { path: "/sales/returns", name: "Trả hàng & hoàn tiền" },
      { path: "/inventory/imports", name: "Nhập hàng" },
      { path: "/analytics/price-history", name: "Lịch sử giá bán" },
      { path: "/system/activity-logs", name: "Nhật ký giao dịch" },
    ],
  },

  // Product Management Section
  {
    name: "QUẢN LÝ SẢN PHẨM",
    iconSvg: `<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 2L2 7L12 12L22 7L12 2ZM2 17L12 22L22 17M2 12L12 17L22 12"/>
    </svg>`,
    hasSubmenu: true,
    submenu: [
      { path: "/products", name: "Danh sách sản phẩm" },
      {
        name: "Thuộc tính sản phẩm",
        hasSubSubmenu: true,
        subSubmenu: [
          { path: "/products/xuat-xu", name: "Xuất xứ" },
          { path: "/products/nha-san-xuat", name: "Nhà sản xuất" },
          { path: "/products/mau-sac", name: "Màu sắc" },
          { path: "/products/kich-thuoc", name: "Kích thước" },
          { path: "/products/de-giay", name: "Đế giày" },
          { path: "/products/chat-lieu", name: "Chất liệu" },
          { path: "/products/trong-luong", name: "Trọng lượng" },
          { path: "/products/anh-san-pham", name: "Ảnh sản phẩm" },
        ],
      },
    ],
  },

  // Discounts Section
  {
    name: "GIẢM GIÁ & KHUYẾN MÃI",
    iconSvg: `<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12.79 21L3 11.21V2H11.21L21 11.79L12.79 21ZM4.41 4H6.58V5.17C6.58 5.72 7.03 6.17 7.58 6.17S8.58 5.72 8.58 5.17V4H10.76L19 12.24L12.79 18.45L4.55 10.21L4.41 4Z"/>
    </svg>`,
    hasSubmenu: true,
    submenu: [
      { path: "/marketing/discounts", name: "Giảm Giá" },
      { path: "/marketing/campaigns", name: "Khuyến Mãi" },
    ],
  },

  // Users Section
  {
    name: "NHÂN VIÊN & KHÁCH HÀNG",
    iconSvg: `<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
      <path d="M16 4C18.2 4 20 5.8 20 8S18.2 12 16 12S12 10.2 12 8S13.8 4 16 4ZM4 8C4 5.8 5.8 4 8 4S12 5.8 12 8S10.2 12 8 12S4 10.2 4 8ZM8 14C12.4 14 16 16.6 16 20V22H0V20C0 16.6 3.6 14 8 14ZM24 20V22H18V20C18 18.2 17.2 16.5 15.8 15.3C17.1 14.8 18.5 14.5 20 14.5C22.2 14.5 24 17.1 24 20Z"/>
    </svg>`,
    hasSubmenu: true,
    submenu: [
      { path: "/users/nhan-vien", name: "Nhân viên" },
      { path: "/users/khach-hang", name: "Khách hàng" },
    ],
  },
];

// Computed properties for filtered notifications
const filteredNotificationsModal = computed(() => {
  const notifs = notifications.value;

  // Early return for 'all' filter to avoid unnecessary filtering
  if (selectedFilter.value === "all") {
    return [...notifs].sort((a, b) => b.timestamp - a.timestamp);
  }

  let filtered;
  if (selectedFilter.value === "unread") {
    filtered = notifs.filter((n) => !n.isRead);
  } else {
    // For type filters
    filtered = notifs.filter((n) => n.type === selectedFilter.value);
  }

  return filtered.sort((a, b) => b.timestamp - a.timestamp);
});

// Create reactive computed properties for filter counts
const filterCounts = computed(() => {
  const counts = {
    all: notifications.value.length,
    unread: notifications.value.filter((n) => !n.isRead).length,
    order: notifications.value.filter((n) => n.type === "order").length,
    inventory: notifications.value.filter((n) => n.type === "inventory").length,
    review: notifications.value.filter((n) => n.type === "review").length,
    customer: notifications.value.filter((n) => n.type === "customer").length,
    report: notifications.value.filter((n) => n.type === "report").length,
  };

  return counts;
});

// Notification functions
const toggleNotifications = () => {
  console.log(
    "Toggle notifications clicked, current state:",
    showNotifications.value
  );
  showNotifications.value = !showNotifications.value;
};

const markAsRead = async (notificationId) => {
  markAsReadComposable(notificationId);
};

const markAllAsRead = async () => {
  markAllAsReadComposable();
};

const viewAllNotifications = () => {
  showNotifications.value = false;
  showAllNotificationsModal.value = true;
};

const closeAllNotificationsModal = () => {
  isModalClosing.value = true;
  setTimeout(() => {
    showAllNotificationsModal.value = false;
    isModalClosing.value = false;
  }, 400);
};

const getUnreadCountForFilter = (filterKey) => {
  switch (filterKey) {
    case "all":
      return notifications.value.filter((n) => !n.isRead).length;
    case "unread":
      return notifications.value.filter((n) => !n.isRead).length;
    default:
      // For specific types, count unread notifications of that type
      return notifications.value.filter(
        (n) => n.type === filterKey && !n.isRead
      ).length;
  }
};

const getTypeLabel = (type) => {
  const typeLabels = {
    order: "Đơn hàng",
    inventory: "Kho hàng",
    review: "Đánh giá",
    customer: "Khách hàng",
    report: "Báo cáo",
  };
  return typeLabels[type] || "Khác";
};

const getIconClass = (type) => {
  const iconClasses = {
    order: "success-type",
    inventory: "warning-type",
    review: "info-type",
    customer: "info-type",
    report: "success-type",
    error: "error-type",
    success: "success-type",
    warning: "warning-type",
    info: "info-type",
  };
  return iconClasses[type] || "info-type";
};

const getEmptyMessage = () => {
  const filter = selectedFilter.value;
  if (filter === "all") return "Hiện tại không có thông báo nào.";
  if (filter === "unread") return "Tất cả thông báo đã được đọc.";
  const filterObj = notificationFilters.find((f) => f.key === filter);
  return `Không có thông báo ${
    filterObj ? filterObj.label.toLowerCase() : "này"
  }.`;
};

const formatTimeAgo = (timestamp) => {
  const now = new Date();
  const diff = now - timestamp;
  const minutes = Math.floor(diff / 60000);
  const hours = Math.floor(diff / 3600000);
  const days = Math.floor(diff / 86400000);

  if (minutes < 1) return "Vừa xong";
  if (minutes < 60) return `${minutes} phút trước`;
  if (hours < 24) return `${hours} giờ trước`;
  return `${days} ngày trước`;
};

const formatFullDate = (timestamp) => {
  return new Intl.DateTimeFormat("vi-VN", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(timestamp);
};

const toggleUserDropdown = () => {
  showUserDropdown.value = !showUserDropdown.value;
};

const navigateToDashboard = () => {
  router.push("/dashboard");
};

const logout = () => {
  showUserDropdown.value = false;
  authLogout();
  router.push("/login");
};

const closeMobileMenu = () => {
  // For mobile menu handling if needed
};

const toggleSubmenu = (menuName) => {
  // If sidebar is collapsed, navigate to first page in submenu instead of toggling
  if (!sidebarOpen.value) {
    const menuItem = menuItems.find(item => item.name === menuName);
    if (menuItem && menuItem.submenu && menuItem.submenu.length > 0) {
      // Find first submenu item with a path
      const firstItem = menuItem.submenu.find(subitem => subitem.path);
      if (firstItem) {
        router.push(firstItem.path);
        return;
      }
      // If no direct path found, check for sub-submenu
      const firstSubSubmenu = menuItem.submenu.find(subitem => subitem.hasSubSubmenu && subitem.subSubmenu);
      if (firstSubSubmenu && firstSubSubmenu.subSubmenu.length > 0) {
        const firstSubSubItem = firstSubSubmenu.subSubmenu.find(subsubitem => subsubitem.path);
        if (firstSubSubItem) {
          router.push(firstSubSubItem.path);
          return;
        }
      }
    }
  }
  
  // Normal toggle behavior when sidebar is open
  expandedMenus.value[menuName] = !expandedMenus.value[menuName];
};

const toggleSubSubmenu = (submenuName) => {
  expandedSubMenus.value[submenuName] = !expandedSubMenus.value[submenuName];
};

const isSubmenuExpanded = (menuName) => {
  return expandedMenus.value[menuName] || false;
};

const isSubSubmenuExpanded = (submenuName) => {
  return expandedSubMenus.value[submenuName] || false;
};

const isSubmenuItemActive = (submenu) => {
  return submenu.some((item) => {
    if (item.path) {
      return route.path === item.path;
    }
    if (item.hasSubSubmenu) {
      return item.subSubmenu.some(
        (subSubitem) => route.path === subSubitem.path
      );
    }
    return false;
  });
};

// Watch for unread count changes to trigger animation
watch(
  unreadNotifications,
  (newCount, oldCount) => {
    if (newCount !== oldCount && newCount > 0) {
      isCountUpdating.value = true;
      setTimeout(() => {
        isCountUpdating.value = false;
      }, 600);
    }
    previousUnreadCount.value = oldCount;
  },
  { immediate: false }
);

// Close dropdown when clicking outside
const closeDropdowns = (event) => {
  if (!event.target.closest(".user-profile")) {
    showUserDropdown.value = false;
  }
  if (
    showNotifications.value &&
    !event.target.closest(".notification-button") &&
    !event.target.closest(".notifications-dropdown")
  ) {
    showNotifications.value = false;
  }
  if (
    showAllNotificationsModal.value &&
    !event.target.closest(".notifications-modal")
  ) {
    closeAllNotificationsModal();
  }
};

onMounted(() => {
  document.addEventListener("click", closeDropdowns);
  document.addEventListener("keydown", handleKeydown);
  initializeAuth(); // Initialize auth state from localStorage
  startPolling(); // Start notification system

  // Set up global notification instance
  setGlobalNotificationInstance({
    addNotification,
    createOrderNotification,
    createProductNotification,
    createCustomerNotification,
    createSystemNotification,
  });

  // Auto-collapse sidebar on mobile devices
  const checkMobile = () => {
    if (window.innerWidth <= 768) {
      sidebarOpen.value = false;
      localStorage.setItem("sidebarOpen", "false");
    }
  };

  checkMobile();
  window.addEventListener("resize", checkMobile);

  // No automatic notifications - only trigger on actual changes
});

onUnmounted(() => {
  document.removeEventListener("click", closeDropdowns);
  document.removeEventListener("keydown", handleKeydown);
  window.removeEventListener("resize", checkMobile);
});

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value;
  localStorage.setItem("sidebarOpen", sidebarOpen.value.toString());
};

const handleKeydown = (event) => {
  if (event.ctrlKey && event.key === "b") {
    event.preventDefault();
    toggleSidebar();
  }
};

const checkMobile = () => {
  if (window.innerWidth <= 768) {
    sidebarOpen.value = false;
    localStorage.setItem("sidebarOpen", "false");
  }
};
</script>

<template>
  <!-- Login Page (standalone) -->
  <router-view v-if="isLoginPage" />

  <!-- Admin Layout (with sidebar and header) -->
  <div v-else class="admin-layout">
    <!-- Sidebar -->
    <div class="sidebar" :class="{ 'sidebar-collapsed': !sidebarOpen }">
      <!-- Logo -->
      <div class="logo-section">
        <div class="logo" @click="navigateToDashboard">
          <img :src="logoUrl" alt="GearUp Logo" class="logo-icon" />
        </div>
        <button
          class="sidebar-toggle"
          @click="toggleSidebar"
          :title="sidebarOpen ? 'Thu gọn menu' : 'Mở rộng menu'"
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
            <path v-if="sidebarOpen" d="M19 13H5v-2h14v2z" />
            <path v-else d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z" />
          </svg>
        </button>
      </div>

      <hr />
      <!-- Navigation Menu -->
      <nav class="nav-menu">
        <template v-for="item in menuItems" :key="item.name">
          <!-- Regular menu item -->
          <router-link
            v-if="!item.hasSubmenu"
            :to="item.path"
            class="menu-item"
            :class="{ active: route.path === item.path }"
            @click="closeMobileMenu"
            :title="!sidebarOpen ? item.name : ''"
          >
            <div
              class="menu-icon"
              v-if="item.iconSvg"
              v-html="item.iconSvg"
            ></div>
            <div class="menu-icon-placeholder" v-else></div>
            <span class="menu-text">{{ item.name }}</span>
          </router-link>

          <!-- Menu item with submenu -->
          <div v-else class="menu-group">
            <div
              class="menu-item menu-parent"
              :class="{
                active: isSubmenuItemActive(item.submenu),
                expanded: isSubmenuExpanded(item.name),
              }"
              @click="toggleSubmenu(item.name)"
            >
              <div
                class="menu-icon"
                v-if="item.iconSvg"
                v-html="item.iconSvg"
              ></div>
              <div class="menu-icon-placeholder" v-else></div>
              <span class="menu-text">{{ item.name }}</span>
              <span class="menu-arrow">
                <svg
                  width="12"
                  height="12"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path d="M7 10l5 5 5-5z" />
                </svg>
              </span>
            </div>

            <!-- Submenu items -->
            <div
              class="submenu"
              :class="{ 'submenu-expanded': isSubmenuExpanded(item.name) }"
            >
              <!-- Regular submenu items -->
              <div
                v-for="subitem in item.submenu"
                :key="subitem.path || subitem.name"
                class="submenu-item"
                :class="{
                  active: subitem.path ? route.path === subitem.path : false,
                  'has-sub-submenu': subitem.hasSubSubmenu,
                  expanded:
                    subitem.hasSubSubmenu && isSubSubmenuExpanded(subitem.name),
                }"
                @click="
                  subitem.hasSubSubmenu
                    ? toggleSubSubmenu(subitem.name)
                    : subitem.path
                    ? router.push(subitem.path)
                    : null
                "
                :title="!sidebarOpen ? subitem.name : ''"
              >
                <!-- Dấu bullet đã được ẩn bằng CSS -->
                <span class="submenu-text">{{ subitem.name }}</span>
                <span v-if="subitem.hasSubSubmenu" class="submenu-arrow-sub">
                  <svg
                    width="12"
                    height="12"
                    viewBox="0 0 24 24"
                    fill="currentColor"
                  >
                    <path d="M7 10l5 5 5-5z" />
                  </svg>
                </span>
              </div>

              <!-- Sub-submenu for Thuộc tính sản phẩm -->
              <div
                v-if="item.name === 'QUẢN LÝ SẢN PHẨM'"
                class="sub-submenu"
                :class="{
                  'sub-submenu-expanded': isSubSubmenuExpanded(
                    'Thuộc tính sản phẩm'
                  ),
                }"
                style="margin-left: 1rem"
              >
                <div
                  v-for="subSubitem in [
                    { path: '/products/xuat-xu', name: 'Xuất xứ' },
                    { path: '/products/nha-san-xuat', name: 'Nhà sản xuất' },
                    { path: '/products/mau-sac', name: 'Màu sắc' },
                    { path: '/products/kich-thuoc', name: 'Kích thước' },
                    { path: '/products/de-giay', name: 'Đế giày' },
                    { path: '/products/chat-lieu', name: 'Chất liệu' },
                    { path: '/products/trong-luong', name: 'Trọng lượng' },
                    { path: '/products/anh-san-pham', name: 'Ảnh sản phẩm' },
                  ]"
                  :key="subSubitem.path"
                  class="sub-submenu-item"
                  :class="{ active: route.path === subSubitem.path }"
                  @click="router.push(subSubitem.path)"
                  :title="!sidebarOpen ? subSubitem.name : ''"
                >
                  <!-- Dấu bullet đã được ẩn bằng CSS -->
                  <span class="sub-submenu-text">{{ subSubitem.name }}</span>
                </div>
              </div>
            </div>
          </div>
        </template>
      </nav>
    </div>

    <!-- Main Content -->
    <div
      class="main-content"
      :class="{ 'main-content-expanded': !sidebarOpen }"
    >
      <!-- Header -->
      <header class="header">
        <div class="header-left">
          <!-- Breadcrumb Navigation -->
          <nav class="breadcrumb-nav">
            <div class="breadcrumb-container">
              <a href="#" class="breadcrumb-item home" @click.prevent="router.push('/')">
                Trang chủ
              </a>
              <span class="breadcrumb-separator">/</span>
              <span class="breadcrumb-item current">{{ currentPageTitle }}</span>
            </div>
          </nav>
        </div>

        <div class="header-right">
          <!-- Notification Button moved to header-right -->
          <button class="notification-button" @click="toggleNotifications">
              <div class="bell-icon-container">
                <!-- Clean Bell Icon -->
                <svg
                  class="bell-icon"
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                >
                  <path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"></path>
                  <path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"></path>
                </svg>
                <div
                  v-if="unreadNotifications > 0"
                  :key="unreadNotifications"
                  class="notification-count"
                  :class="{ updating: isCountUpdating }"
                >
                  {{ unreadNotifications > 9 ? "9+" : unreadNotifications }}
                </div>
              </div>
          </button>

          <!-- Notifications Dropdown -->
          <div
              v-if="showNotifications"
              class="notifications-dropdown"
              @click.stop
            >
              <div class="notifications-header">
                <h3>Thông báo</h3>
                <button
                  v-if="unreadNotifications > 0"
                  class="mark-all-read"
                  @click="markAllAsRead"
                >
                  Đánh dấu đã đọc
                </button>
              </div>

              <div class="notifications-list">
                <div v-if="notifications.length === 0" class="no-notifications">
                  <i class="empty-icon"><!-- icon: empty-mailbox --></i>
                  <p>Không có thông báo mới</p>
                </div>

                <div v-else>
                  <div
                    v-for="notification in notifications"
                    :key="notification.id"
                    class="notification-item"
                    :class="{ unread: !notification.isRead }"
                    @click="markAsRead(notification.id)"
                  >
                    <div class="notification-icon">
                      {{ notification.icon }}
                    </div>
                    <div class="notification-content">
                      <div class="notification-title">
                        {{ notification.title }}
                      </div>
                      <div class="notification-message">
                        {{ notification.message }}
                      </div>
                      <div class="notification-time">
                        {{ formatTimeAgo(notification.timestamp) }}
                      </div>
                    </div>
                    <div v-if="!notification.isRead" class="unread-indicator" />
                  </div>
                </div>
              </div>

              <div class="notifications-footer">
                <button class="view-all-btn" @click="viewAllNotifications">
                  Xem tất cả thông báo
                </button>
              </div>
          </div>

          <div class="user-profile" @click="toggleUserDropdown">
            <div class="user-info">
              <div class="user-text-info" v-if="sidebarOpen">
                <div class="user-name">{{ displayName.name }}</div>
                <div class="user-role">{{ displayName.role }}</div>
              </div>
              <div class="user-avatar">
                <div class="avatar-circle">
                  <span class="avatar-initial">{{
                    displayName.name.charAt(0)
                  }}</span>
                </div>
                <div class="online-indicator"></div>
              </div>
            </div>
            <div class="user-dropdown" v-if="showUserDropdown">
              <div class="dropdown-header">
                <div class="user-role-info">
                  <div class="user-name">{{ displayName.name }}</div>
                  <div class="user-role">{{ displayName.role }}</div>
                </div>
              </div>
              <div class="dropdown-divider"></div>

              <button class="dropdown-item logout" @click="logout">
                🚪 Đăng xuất
              </button>
            </div>
          </div>
        </div>
      </header>
      <hr />
      <!-- Page Content -->
      <main class="page-content">
        <router-view />
      </main>
    </div>

    <!-- All Notifications Modal -->
    <div
      v-if="showAllNotificationsModal"
      class="modal-overlay"
      :class="{ 'modal-closing': isModalClosing }"
      @click="closeAllNotificationsModal"
    >
      <div
        class="notifications-modal"
        :class="{ 'modal-closing': isModalClosing }"
        @click.stop
      >
        <div class="modal-header-redesigned">
          <div class="header-top">
            <div class="notification-icon-redesigned">
              <svg class="bell-icon-redesigned" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"></path>
                <path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"></path>
              </svg>
            </div>
            <div class="notification-title-redesigned">
              <h2 class="notification-title-text-redesigned">Trung tâm thông báo</h2>
              <p class="notification-count-text">
                {{ notifications.length }} thông báo
                <span v-if="unreadNotifications > 0" class="unread-count-badge">
                  {{ unreadNotifications }} chưa đọc
                </span>
              </p>
            </div>
            <button class="notification-close-redesigned" @click="closeAllNotificationsModal">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
          
          <div class="header-actions-redesigned" v-if="notifications.length > 0">
            <button
              v-if="unreadNotifications > 0"
              class="action-btn primary-action"
              @click="markAllAsRead"
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="20,6 9,17 4,12"></polyline>
              </svg>
              Đánh dấu đã đọc
            </button>
            <button
              class="action-btn secondary-action"
              @click="clearAllNotifications"
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="3,6 5,6 21,6"></polyline>
                <path d="m19,6v14a2,2 0 0,1 -2,2H7a2,2 0 0,1 -2,-2V6m3,0V4a2,2 0 0,1 2,-2h4a2,2 0 0,1 2,2v2"></path>
              </svg>
              Xóa tất cả
            </button>
          </div>
        </div>

        <div class="modal-filters">
          <div class="filter-tabs">
            <button
              v-for="filter in notificationFilters"
              :key="filter.key"
              class="filter-tab"
              :class="{ active: selectedFilter === filter.key }"
              @click="selectedFilter = filter.key"
            >
              <span class="tab-label">{{ filter.label }}</span>
              <span
                v-if="filterCounts[filter.key] > 0"
                class="tab-badge"
                :class="{
                  'badge-unread': getUnreadCountForFilter(filter.key) > 0,
                  'badge-read': getUnreadCountForFilter(filter.key) === 0,
                }"
              >
                {{ filterCounts[filter.key] }}
              </span>
            </button>
          </div>
        </div>

        <div class="modal-content">
          <div
            v-if="filteredNotificationsModal.length === 0"
            class="empty-notifications"
          >
            <div class="empty-icon-container">
              <span class="empty-icon"><!-- icon: empty-mailbox --></span>
            </div>
            <h3>Không có thông báo</h3>
            <p>{{ getEmptyMessage() }}</p>
          </div>

          <div v-else class="notifications-grid">
            <div
              v-for="(notification, index) in filteredNotificationsModal"
              :key="notification.id"
              class="notification-card"
              :class="{ unread: !notification.isRead }"
              :style="{ 'animation-delay': `${index * 0.05}s` }"
              @click="markAsRead(notification.id)"
            >
              <div class="card-header">
                <div
                  class="notification-type"
                  :class="`type-${notification.type}`"
                >
                  <div class="type-icon-container">
                    <span class="type-icon" :class="getIconClass(notification.type)">{{ notification.icon }}</span>
                  </div>
                  <span class="type-label">{{
                    getTypeLabel(notification.type)
                  }}</span>
                </div>
                <div class="notification-meta">
                  <span class="notification-time-full">{{
                    formatFullDate(notification.timestamp)
                  }}</span>
                  <div v-if="!notification.isRead" class="unread-dot" />
                </div>
              </div>

              <div class="card-body">
                <h4 class="notification-title-full">
                  {{ notification.title }}
                </h4>
                <p class="notification-message-full">
                  {{ notification.message }}
                </p>
              </div>

              <div class="card-footer">
                <span class="time-ago">{{
                  formatTimeAgo(notification.timestamp)
                }}</span>
                <button
                  v-if="!notification.isRead"
                  class="mark-read-btn"
                  @click.stop="markAsRead(notification.id)"
                >
                  <i class="check-icon"><!-- icon: checkmark --></i>
                  Đánh dấu đã đọc
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.admin-layout {
  display: flex;
  height: 100vh;
  max-height: 100vh;
  overflow: hidden;
  background: #f9fafb;
  transform: translate3d(0, 0, 0);
  will-change: auto;
}

/* Sidebar */
.sidebar {
  width: 280px;
  min-width: 280px;
  height: 100vh;
  background: #ffffff;
  border-right: 1px solid #e5e7eb;
  position: relative;
  overflow-y: auto;
  z-index: 1000;
  transition: all 0.3s ease;
}

.sidebar-collapsed {
  width: 80px;
  min-width: 80px;
}

.logo-section {
  padding: 1.5rem;
  border-bottom: 1px solid #ffffff;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
}

.sidebar-toggle:hover {
  background-color: #ffffff;
  color: #374151;
}

.sidebar-toggle svg {
  transition: transform 0.2s ease;
}

.sidebar-toggle:active svg {
  transform: scale(0.95);
}

.logo {
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

/* Logo styles moved to globals.css - no local overrides needed */

.logo-icon {
  height: 40px;
  width: auto;
  transition: all 0.3s ease;
}

.logo-text {
  font-size: 1.25rem;
  font-weight: 700;
  color: #4ade80;
  font-family: 'Arial', 'Helvetica', sans-serif;
}

/* Navigation Menu */
.nav-menu {
  padding: 1rem 0;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 0.75rem 1.5rem;
  color: #374151;
  text-decoration: none;
  transition: all 0.2s ease;
  cursor: pointer;
  position: relative;
  font-weight: 500;
  font-size: 0.875rem;
  border-bottom: 1px solid transparent;
}

.sidebar-collapsed .menu-item {
  padding: 0.75rem 1rem;
  justify-content: center;
}

.sidebar-collapsed .submenu-item {
  padding: 0.5rem 1rem;
  justify-content: center;
}

.sidebar-collapsed .sub-submenu-item {
  padding: 0.4rem 1rem;
  justify-content: center;
}

.menu-item:hover {
  background-color: #ffffff;
  color: #1f2937;
}

.menu-item.active {
  background-color: #ffffff;
  color: #2563eb;
  font-weight: 600;
  border-left: 3px solid #2563eb;
}

/* Menu with submenu */
.menu-group {
  margin-bottom: 0.25rem;
}

.menu-parent {
  justify-content: space-between;
  user-select: none;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  color: #6b7280;
  padding-top: 1rem;
  padding-bottom: 0.5rem;
}

.menu-arrow {
  margin-left: auto;
  display: flex;
  align-items: center;
  transition: transform 0.3s ease;
  opacity: 0.6;
}

.menu-parent.expanded .menu-arrow {
  transform: rotate(180deg);
}

/* Submenu styles */
.submenu {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
  background-color: transparent;
}

.submenu-expanded {
  max-height: 800px;
}

.submenu-item {
  display: flex;
  align-items: center;
  padding: 0.5rem 1.5rem;
  padding-left: 3rem;
  color: #6b7280;
  text-decoration: none;
  transition: all 0.2s ease;
  cursor: pointer;
  font-size: 0.875rem;
  font-weight: 400;
  position: relative;
}

.submenu-item.has-sub-submenu {
  justify-content: space-between;
}

.submenu-item:hover {
  background-color: #ffffff;
  color: #374151;
}

.submenu-item.active {
  background-color: #ffffff;
  color: #2563eb;
  font-weight: 500;
  border-left: 3px solid #2563eb;
}

.submenu-bullet {
  margin-right: 0.75rem;
  color: #9ca3af;
  font-size: 0.75rem;
  width: 4px;
  height: 4px;
  background-color: #9ca3af;
  border-radius: 50%;
}

.submenu-text {
  color: #000000;
  flex: 1;
}

.submenu-arrow-sub {
  margin-left: auto;
  display: flex;
  align-items: center;
  transition: transform 0.3s ease;
  opacity: 0.6;
  color: #9ca3af;
}

.submenu-item.has-sub-submenu.expanded .submenu-arrow-sub {
  transform: rotate(180deg);
}

/* Sub-submenu styles */
.sub-submenu {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
  background-color: #ffffff;
  border-left: 2px solid #e5e7eb;
  margin-left: 1rem;
}

.sub-submenu-expanded {
  max-height: 800px !important;
  padding: 0.5rem 0;
}

.sub-submenu-item {
  display: flex;
  align-items: center;
  padding: 0.4rem 1.5rem;
  padding-left: 4.5rem;
  color: #6b7280;
  text-decoration: none;
  transition: all 0.2s ease;
  cursor: pointer;
  font-size: 0.8rem;
  font-weight: 400;
  border-left: 1px solid #e5e7eb;
  margin-left: 1rem;
}

.sub-submenu-item:hover {
  background-color: #ffffff;
  color: #374151;
}

.sub-submenu-item.active {
  background-color: #ffffff;
  color: #2563eb;
  font-weight: 500;
  border-left-color: #2563eb;
}

.sub-submenu-bullet {
  margin-right: 0.75rem;
  color: #d1d5db;
  font-size: 0.7rem;
  width: 3px;
  height: 3px;
  background-color: #d1d5db;
  border-radius: 50%;
}

.sub-submenu-text {
  color: #000000;
  flex: 1;
  color: #000000;
}

.menu-icon {
  width: 20px;
  height: 20px;
  opacity: 0.7;
  transition: all 0.2s ease;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #6b7280;
}

.menu-icon svg {
  width: 100%;
  height: 100%;
}

.menu-icon-placeholder {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}

.menu-item:hover .menu-icon {
  opacity: 1;
  color: #374151;
}

.menu-item.active .menu-icon {
  opacity: 1;
  color: #2563eb;
}

.menu-text {
  color: #000000;
  margin-left: 0.75rem;
  flex: 1;
  font-size: 0.875rem;
  transition: opacity 0.3s ease;
}

.sidebar-collapsed .menu-text {
  opacity: 0;
  width: 0;
  overflow: hidden;
}

.sidebar-collapsed .menu-arrow {
  opacity: 0;
}

.sidebar-collapsed .submenu-bullet {
  opacity: 0;
}

.sidebar-collapsed .submenu-text {
  opacity: 0;
  width: 0;
  overflow: hidden;
}

.sidebar-collapsed .sub-submenu-text {
  opacity: 0;
  width: 0;
  overflow: hidden;
}

.sidebar-collapsed .submenu {
  display: none;
}

.sidebar-collapsed .sub-submenu {
  display: none;
}

.sidebar-collapsed .menu-icon {
  margin: 0;
  opacity: 1;
}

.sidebar-collapsed .menu-icon-placeholder {
  margin: 0;
}

.sidebar-collapsed .menu-item:hover {
  background-color: #ffffff;
}

.sidebar-collapsed .menu-item.active {
  background-color: #ffffff;
  border-left: 3px solid #2563eb;
}

/* Add a subtle shadow to the collapsed sidebar */
.sidebar-collapsed {
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
}

/* Improve the toggle button appearance */
.sidebar-toggle {
  background: none;
  border: none;
  color: #6b7280;
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 0.375rem;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 32px;
  min-height: 32px;
}

/* Main Content */
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  transition: all 0.3s ease;
}

.main-content-expanded {
  margin-left: 0;
}

/* Header */
.header {
  background: #ffffff;
  border-bottom: 1px solid #e5e7eb;
  padding: 0.75rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  min-height: 56px;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}

/* Breadcrumb Navigation */
.breadcrumb-nav {
  display: flex;
  align-items: center;
}

.breadcrumb-container {
  display: flex;
  align-items: center;
  background: #f8f9fa;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  border: 1px solid #e9ecef;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
}

.breadcrumb-container:hover {
  background: #ffffff;
  border-color: #4ade80;
  box-shadow: 0 2px 4px 0 rgba(74, 222, 128, 0.1);
}

.breadcrumb-item {
  font-size: 0.875rem;
  font-weight: 500;
  text-decoration: none;
  transition: color 0.2s ease;
}

.breadcrumb-item.home {
  color: #6c757d;
  cursor: pointer;
}

.breadcrumb-item.home:hover {
  color: #4ade80;
  text-decoration: none;
}

.breadcrumb-item.current {
  color: #212529;
  font-weight: 600;
}

.breadcrumb-separator {
  margin: 0 0.75rem;
  color: #6c757d;
  font-weight: 400;
  user-select: none;
}

/* Responsive breadcrumb */
@media (max-width: 768px) {
  .breadcrumb-container {
    padding: 0.25rem 0.5rem;
  }
  
  .breadcrumb-item {
    font-size: 0.8125rem;
  }
  
  .breadcrumb-separator {
    margin: 0 0.5rem;
  }
}

@media (max-width: 480px) {
  .breadcrumb-container {
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
  }
  
  .breadcrumb-item {
    font-size: 0.75rem;
  }
  
  .breadcrumb-separator {
    margin: 0 0.375rem;
  }
}

.page-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  color: #000000;
  font-family: 'Arial', 'Helvetica', sans-serif;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 0.125rem;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 0.125rem;
  margin-right: 0.5rem;
  position: relative;
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 1rem;
  position: relative;
  cursor: pointer;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.25rem 0.5rem;
  border-radius: 0.5rem;
  transition: all 0.2s ease;
}

.user-info:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.user-text-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 2px;
}

.user-name {
  font-weight: 600;
  color: #000000;
  font-size: 0.875rem;
  line-height: 1.2;
  text-align: right;
}

.user-role {
  font-weight: 400;
  color: #6b7280;
  font-size: 0.75rem;
  line-height: 1.2;
  text-align: right;
  opacity: 0.8;
}

.user-dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 0.5rem;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  z-index: 1000;
  min-width: 250px;
  max-width: 300px;
}

.dropdown-header {
  padding: 1rem;
  background-color: #ffffff;
  border-bottom: 1px solid #e5e7eb;
}

.user-role-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.dropdown-header .user-name {
  font-weight: 600;
  color: #000000;
  font-size: 0.875rem;
}

.dropdown-header .user-role {
  font-size: 0.75rem;
  color: #6b7280;
}

.dropdown-divider {
  height: 1px;
  background-color: #e5e7eb;
  margin: 0;
}

.dropdown-item {
  display: block;
  width: 100%;
  padding: 0.5rem 1rem;
  text-align: left;
  background: none;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #000000;
  font-size: 0.875rem;
  border-radius: 4px;
  margin: 1px 0.25rem;
}

.dropdown-item:hover {
  background-color: #f0fdf4;
  color: #4ade80;
}

.dropdown-item.logout {
  color: #dc2626;
  margin-top: 0.25rem;
}

.dropdown-item.logout:hover {
  background-color: rgba(239, 68, 68, 0.1);
  color: #b91c1c;
}

/* Modern Notification Button */
.notification-button {
  position: relative;
  width: 44px;
  height: 44px;
  border: none;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid transparent;
  border-radius: 12px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(12px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.notification-button:hover {
  background: rgba(255, 255, 255, 1);
  border-color: #93c5fd;
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.notification-button:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.bell-icon-container {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
}

.bell-icon {
  width: 20px;
  height: 20px;
  color: #6b7280;
  transition: all 0.2s ease;
}

.notification-button:hover .bell-icon {
  color: #22c55e;
  transform: scale(1.05);
}

.notification-count {
  position: absolute;
  top: -6px;
  right: -6px;
  min-width: 20px;
  height: 20px;
  border-radius: 10px;
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  font-size: 12px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 6px;
  border: 2px solid white;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
  animation: badgeAppear 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  transform-origin: center;
  z-index: 10;
  line-height: 1;
}

@keyframes badgeAppear {
  0% {
    transform: scale(0) rotate(-180deg);
    opacity: 0;
  }
  50% {
    transform: scale(1.3) rotate(-90deg);
    opacity: 0.8;
  }
  100% {
    transform: scale(1) rotate(0deg);
    opacity: 1;
  }
}

/* Badge update animation */
@keyframes badgeUpdate {
  0% {
    transform: scale(1);
  }
  25% {
    transform: scale(0.8);
  }
  50% {
    transform: scale(1.15);
  }
  75% {
    transform: scale(0.95);
  }
  100% {
    transform: scale(1);
  }
}

/* Special animation for count updates */
.notification-count.updating {
  animation: badgeUpdate 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Hover effect for notification button affects badge */
.notification-button:hover .notification-count {
  animation-play-state: paused;
  transform: scale(1.1);
  box-shadow: 0 4px 16px rgba(239, 68, 68, 0.5);
}

.notification-button:focus-visible {
  outline: 2px solid #4ade80;
  outline-offset: 2px;
}

/* Notifications Dropdown */
.notifications-dropdown {
  position: absolute;
  top: calc(100% + 0.5rem);
  right: 0;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
    0 10px 10px -5px rgba(0, 0, 0, 0.04);
  z-index: 1000;
  min-width: 380px;
  max-width: 400px;
  overflow: hidden;
  animation: dropdownSlideIn 0.2s ease-out;
  transform-origin: top right;
}

@keyframes dropdownSlideIn {
  from {
    opacity: 0;
    transform: translateY(-10px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.notifications-header {
  padding: 1rem 1.25rem;
  border-bottom: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #f9fafb;
}

.notifications-header h3 {
  margin: 0;
  font-size: 1rem;
  font-weight: 600;
  color: #000000;
}

.mark-all-read {
  background: none;
  border: none;
  font-size: 0.875rem;
  color: #22c55e;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  transition: all 0.2s ease;
  font-weight: 500;
}

.mark-all-read:hover {
  background-color: #f0fdf4;
  color: #16a34a;
}

.notifications-list {
  max-height: 400px;
  overflow-y: auto;
}

.no-notifications {
  padding: 2rem;
  text-align: center;
  color: #6b7280;
}

.no-notifications .empty-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
  display: block;
}

.no-notifications p {
  margin: 0;
  font-size: 0.875rem;
}

.notification-item {
  display: flex;
  align-items: flex-start;
  padding: 1rem 1.25rem;
  border-bottom: 1px solid #e5e7eb;
  cursor: pointer;
  transition: background-color 0.2s ease;
  position: relative;
}

.notification-item:hover {
  background: #f9fafb;
}

.notification-item:last-child {
  border-bottom: none;
}

.notification-item.unread {
  background: #f0fdf4;
  border-left: 3px solid #4ade80;
}

.notification-icon {
  font-size: 1.25rem;
  margin-right: 0.75rem;
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f3f4f6;
  border-radius: 50%;
}

.notification-item.unread .notification-icon {
  background: #dcfce7;
}

.notification-content {
  flex: 1;
  min-width: 0;
}

.notification-title {
  font-weight: 600;
  color: #111827;
  font-size: 0.875rem;
  margin-bottom: 0.25rem;
  line-height: 1.3;
}

.notification-message {
  color: #6b7280;
  font-size: 0.8125rem;
  line-height: 1.4;
  margin-bottom: 0.5rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.notification-time {
  color: #6b7280;
  font-size: 0.75rem;
  font-weight: 500;
}

.unread-indicator {
  position: absolute;
  top: 50%;
  right: 1rem;
  transform: translateY(-50%);
  width: 8px;
  height: 8px;
  background: #4ade80;
  border-radius: 50%;
  margin-top: 0.25rem;
}

.notifications-footer {
  padding: 0.75rem 1.25rem;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.view-all-btn {
  width: 100%;
  padding: 0.5rem;
  background: none;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  color: #22c55e;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.view-all-btn:hover {
  background: #f0fdf4;
  border-color: #93c5fd;
  color: #16a34a;
}

/* Modal Overlay and Base */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(8px);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  animation: overlayFadeIn 0.3s ease-out;
}

@keyframes overlayFadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Reset any global button styles in modal */
.notifications-modal button {
  font-family: inherit;
  font-size: inherit;
  line-height: inherit;
}

/* Override the reset for specific styled buttons */
.notifications-modal .mark-all-read-modal {
  background: #4ade80 !important;
  color: white !important;
  border: 2px solid #4ade80 !important;
  padding: 0.5rem 1rem !important;
}

.notifications-modal .close-modal-btn {
  background: white !important;
  border: 2px solid #d1d5db !important;
  padding: 0 !important;
}

.notifications-modal button:focus {
  outline: 0;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: scale(0.9) translateY(-20px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.notifications-modal {
  background: white;
  border-radius: 1rem;
  box-shadow: 
    0 20px 40px -8px rgba(0, 0, 0, 0.15),
    0 0 0 1px rgba(255, 255, 255, 0.1),
    0 4px 16px rgba(0, 0, 0, 0.08);
  width: 90vw;
  max-width: 600px;
  max-height: 80vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  animation: modalSlideIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  margin: 2rem;
}

@keyframes modalSlideOut {
  from {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
  to {
    opacity: 0;
    transform: scale(0.9) translateY(-20px);
  }
}

/* Overlay closing animation */
.modal-overlay.modal-closing {
  animation: overlayFadeOut 0.4s ease-in forwards;
}

@keyframes overlayFadeOut {
  from {
    opacity: 1;
  }
  to {
    opacity: 0;
  }
}

.notifications-modal.modal-closing {
  animation: modalSlideOut 0.4s cubic-bezier(0.55, 0.055, 0.675, 0.19) forwards !important;
}

/* Modal Header */
.modal-header {
  padding: 1.5rem 2rem;
  border-bottom: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: white;
  position: relative;
}

.modal-header-redesigned {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 1.5rem;
  border-bottom: 1px solid rgba(229, 231, 235, 0.6);
}

.header-top {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  margin-bottom: 1rem;
}

.notification-icon-redesigned {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
  flex-shrink: 0;
}

.bell-icon-redesigned {
  color: white;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.notification-title-redesigned {
  flex: 1;
}

.notification-title-text-redesigned {
  margin: 0 0 0.5rem 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
  line-height: 1.2;
  letter-spacing: -0.025em;
}

.notification-count-text {
  margin: 0;
  color: #6b7280;
  font-size: 0.95rem;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.unread-count-badge {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  padding: 0.125rem 0.5rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
}

.notification-close-redesigned {
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(229, 231, 235, 0.6);
  color: #6b7280;
  padding: 0.5rem;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  backdrop-filter: blur(8px);
}

.notification-close-redesigned:hover {
  background: rgba(255, 255, 255, 0.95);
  border-color: #d1d5db;
  color: #374151;
}

.header-actions-redesigned {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.875rem;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;
  position: relative;
  overflow: hidden;
}

.action-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, transparent 0%, rgba(255, 255, 255, 0.1) 100%);
  opacity: 0;
  transition: opacity 0.2s ease;
}

.action-btn:hover::before {
  opacity: 1;
}

.primary-action {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
  color: white;
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.3);
}

.primary-action:hover {
  box-shadow: 0 4px 16px rgba(74, 222, 128, 0.4);
}

.secondary-action {
  background: rgba(249, 250, 251, 0.8);
  color: #6b7280;
  border: 1px solid rgba(229, 231, 235, 0.6);
  backdrop-filter: blur(8px);
}

.secondary-action:hover {
  background: rgba(255, 255, 255, 0.9);
  color: #374151;
  border-color: #d1d5db;
}

.modal-title-section {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.modal-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #000000;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.modal-icon {
  font-size: 1.5rem;
  color: #22c55e;
}

.notifications-count {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
}

.modal-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-shrink: 0;
}

.modal-header-new .modal-actions {
  flex-direction: column;
  align-items: flex-end;
  gap: 0.5rem;
}

.mark-all-read-modal {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: #4ade80;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.875rem;
}

.mark-all-read-modal:hover {
  background: #22c55e;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.4);
}

.mark-all-read-modal .check-icon {
  font-size: 1rem;
  font-weight: bold;
}

.clear-all-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: #ef4444;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.875rem;
}

.clear-all-btn:hover {
  background: #dc2626;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
}

.clear-all-btn .clear-icon {
  font-size: 1rem;
}

.close-modal-btn {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  border: 1px solid #d1d5db;
  background: white;
  color: #6b7280;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.close-modal-btn:hover {
  background: #f9fafb;
  border-color: #9ca3af;
  color: #374151;
}

/* Modal Filters */
.modal-filters {
  padding: 1.5rem 2rem 1rem;
  background: white;
  border-bottom: 1px solid #e5e7eb;
}

.filter-tabs {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
  padding: 0 0.5rem;
}

.notifications-modal .filter-tab {
  background: rgba(255, 255, 255, 0.7);
  border: 1px solid rgba(229, 231, 235, 0.6);
  padding: 0.75rem 1rem !important;
  border-radius: 12px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: #6b7280;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  position: relative;
  min-height: 44px;
  user-select: none;
  backdrop-filter: blur(8px);
  overflow: hidden;
}

.notifications-modal .filter-tab::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, transparent 0%, rgba(255, 255, 255, 0.1) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.notifications-modal .filter-tab:hover::before {
  opacity: 1;
}

.notifications-modal .filter-tab:hover {
  background: rgba(255, 255, 255, 0.9) !important;
  border-color: rgba(74, 222, 128, 0.4);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* Active state - higher specificity and distinct styling */
.notifications-modal .filter-tab.active {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%) !important;
  border-color: transparent !important;
  color: white !important;
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(74, 222, 128, 0.3);
}

/* Active tab hover state - slightly different from regular active */
.notifications-modal .filter-tab.active:hover {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%) !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 8px 24px rgba(74, 222, 128, 0.4) !important;
}


.tab-label {
  font-weight: inherit;
  line-height: 1;
}

.tab-badge {
  background: rgba(229, 231, 235, 0.8);
  color: #374151;
  padding: 0.25rem 0.5rem;
  border-radius: 8px;
  font-size: 0.75rem;
  font-weight: 700;
  min-width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  transition: all 0.3s ease;
  backdrop-filter: blur(4px);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.tab-badge.badge-unread {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  box-shadow: 
    0 0 0 2px rgba(239, 68, 68, 0.2),
    0 4px 12px rgba(239, 68, 68, 0.3);
  animation: pulse 2s infinite;
}

.tab-badge.badge-read {
  background: rgba(156, 163, 175, 0.8);
  color: white;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    box-shadow: 
      0 0 0 2px rgba(239, 68, 68, 0.2),
      0 4px 12px rgba(239, 68, 68, 0.3);
  }
  50% {
    transform: scale(1.05);
    box-shadow: 
      0 0 0 4px rgba(239, 68, 68, 0.3),
      0 6px 16px rgba(239, 68, 68, 0.4);
  }
}

/* Active tab badges - higher specificity */
.notifications-modal .filter-tab.active .tab-badge.badge-unread {
  background: rgba(239, 68, 68, 0.9) !important;
  color: white !important;
  box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.3) !important;
}

.notifications-modal .filter-tab.active .tab-badge.badge-read {
  background: rgba(156, 163, 175, 0.8) !important;
  color: white !important;
  box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.3) !important;
}

/* Modal Content */
.modal-content {
  flex: 1;
  padding: 0;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  width: 100%;
}

.empty-notifications {
  text-align: center;
  padding: 2rem 1.5rem;
  color: #6b7280;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1;
  width: 100%;
}

.empty-icon-container {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1rem auto;
  background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
}

.empty-notifications .empty-icon {
  font-size: 2.5rem;
  opacity: 0.7;
}

.empty-notifications h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.25rem;
  color: #374151;
}

.empty-notifications p {
  margin: 0;
  font-size: 1rem;
}

.notifications-grid {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  padding: 1rem 1.5rem;
  width: 100%;
}

.notification-card {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 0.75rem;
  padding: 1rem;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  animation: cardSlideIn 0.4s ease-out;
  width: 100%;
  box-sizing: border-box;
}

@keyframes cardSlideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.notification-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px -8px rgba(0, 0, 0, 0.1);
  border-color: #bbf7d0;
}

.notification-card.unread {
  border-left: 4px solid #4ade80;
  background: linear-gradient(135deg, #f0fdf4 0%, white 100%);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 0.5rem;
  gap: 0.5rem;
}

.notification-type {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.25rem 0.75rem;
  background: #f3f4f6;
  border-radius: 16px;
  flex-shrink: 0;
}

.type-icon-container {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-right: 0.375rem;
}

.type-icon {
  font-size: 0.625rem;
  font-weight: 600;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  line-height: 1;
  text-align: center;
  vertical-align: middle;
}

.type-icon.success-type {
  background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
  color: #166534;
}

.type-icon.error-type {
  background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
  color: #dc2626;
}

.type-icon.warning-type {
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  color: #d97706;
}

.type-icon.info-type {
  background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
  color: #2563eb;
}

.type-label {
  font-size: 0.75rem;
  font-weight: 600;
  color: #374151;
  text-transform: uppercase;
  letter-spacing: 0.025em;
}

.notification-meta {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.notification-time-full {
  font-size: 0.75rem;
  color: #6b7280;
  font-weight: 500;
}

.unread-dot {
  width: 8px;
  height: 8px;
  background: #4ade80;
  border-radius: 50%;
}

.notification-title-full {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-weight: 600;
  color: #000000;
  line-height: 1.4;
}

.notification-message-full {
  margin: 0;
  font-size: 0.875rem;
  color: #6b7280;
  line-height: 1.5;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.time-ago {
  font-size: 0.75rem;
  color: #6b7280;
  font-weight: 500;
}

.mark-read-btn {
  padding: 0.25rem 0.5rem;
  background: #f0fdf4;
  color: #22c55e;
  border: none;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.25rem;
  transition: all 0.2s ease;
}

.mark-read-btn:hover {
  background: #dcfce7;
  color: #16a34a;
}

.mark-read-btn .check-icon {
  font-size: 0.75rem;
  font-weight: bold;
}

.user-avatar {
  position: relative;
  cursor: pointer;
}

.avatar-circle {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: linear-gradient(
    135deg,
    #4ade80 0%,
    #22c55e 100%
  );
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  border: 2px solid #ffffff;
}

.avatar-circle:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.avatar-initial {
  color: #ffffff;
  font-weight: 700;
  font-size: 1.125rem;
  text-transform: uppercase;
  line-height: 1;
}

.online-indicator {
  position: absolute;
  bottom: 2px;
  right: 2px;
  width: 12px;
  height: 12px;
  background-color: #10b981;
  border: 2px solid #ffffff;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4);
  }
  70% {
    box-shadow: 0 0 0 6px rgba(16, 185, 129, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(16, 185, 129, 0);
  }
}

/* Page Content */
.page-content {
  flex: 1;
  padding: 1rem;
  overflow-y: auto;
  background-color: #ffffff;
}

/* Responsive Design */

@media (max-width: 768px) {
  .admin-layout {
    position: relative;
  }

  .sidebar {
    position: fixed;
    left: -280px;
    top: 0;
    height: 100vh;
    z-index: 1000;
    width: 280px;
    transition: left 0.3s ease;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  }

  .sidebar.mobile-open {
    left: 0;
  }

  .main-content {
    margin-left: 0;
  }

  .header {
    padding: 0.5rem 1rem;
    min-height: 50px;
  }

  .page-content {
    padding: 1rem;
  }
}

@media (max-width: 480px) {
  .page-content {
    padding: 1rem;
  }

  .header {
    padding: 0.5rem 0.75rem;
    min-height: 48px;
  }

  .page-title {
    font-size: 1.125rem;
  }

  .user-text-info {
    display: none;
  }

  .avatar-circle {
    width: 36px;
    height: 36px;
  }

  .avatar-initial {
    font-size: 0.875rem;
  }

  .online-indicator {
    width: 10px;
    height: 10px;
  }

  /* Responsive notification modal */
  .notifications-modal {
    max-width: 95vw;
    max-height: 80vh;
    border-radius: 1rem;
  }

  .modal-header-redesigned {
    padding: 1.5rem;
  }

  .header-top {
    margin-bottom: 1rem;
  }

  .notification-icon-redesigned {
    width: 48px;
    height: 48px;
    border-radius: 12px;
  }

  .notification-title-text-redesigned {
    font-size: 1.5rem;
  }

  .header-actions-redesigned {
    gap: 0.5rem;
  }

  .action-btn {
    padding: 0.5rem 0.75rem;
    font-size: 0.8125rem;
  }

  .filter-tabs {
    gap: 0.5rem;
    padding: 0 0.25rem;
  }

  .notifications-modal .filter-tab {
    padding: 0.5rem 0.75rem !important;
    font-size: 0.8125rem;
    min-height: 40px;
  }
}
</style>
