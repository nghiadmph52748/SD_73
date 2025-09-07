<template>
  <img 
    :src="iconPath" 
    :alt="name"
    :class="['icon', sizeClass, className]"
    :style="{ width: customSize, height: customSize }"
  />
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  name: {
    type: String,
    required: true
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['xs', 'sm', 'md', 'lg', 'xl'].includes(value)
  },
  customSize: {
    type: String,
    default: ''
  },
  className: {
    type: String,
    default: ''
  }
})

// Map icon names to file names
const iconMap = {
  // Dashboard & Analytics
  'money': 'Revenue.svg',
  'revenue': 'Revenue.svg',
  'package': 'Orders.svg',
  'orders': 'Orders.svg',
  'product': 'Shoes.svg',
  'shoes': 'Shoes.svg',
  'users': 'Users.svg',
  'calendar': 'Date.svg',
  'date': 'Date.svg',
  'chart-up': 'Growth.svg',
  'growth': 'Growth.svg',
  'chart': 'Statistics.svg',
  'statistics': 'Statistics.svg',
  'chart-down': 'ChartDown.svg',
  'target': 'Goal.svg',
  'goal': 'Goal.svg',
  
  // Actions
  'refresh': 'Reload.svg',
  'reload': 'Reload.svg',
  'search': 'Find.svg',
  'find': 'Find.svg',
  'plus': 'Plus.svg',
  'add': 'Plus.svg',
  'edit': 'Edit.svg',
  'delete': 'Trash.svg',
  'trash': 'Trash.svg',
  'view': 'View.svg',
  'eye': 'View.svg',
  'camera': 'Camera.svg',
  'photo': 'Photo.svg',
  'check': 'Success.svg',
  'success': 'Success.svg',
  'close': 'Cancel.svg',
  'cancel': 'Cancel.svg',
  'warning': 'Warning.svg',
  'alert': 'Alert.svg',
  
  // Files & Documents
  'excel': 'Excel.svg',
  'document': 'Document.svg',
  'folder': 'Folder.svg',
  'save': 'Save.svg',
  'export': 'Export.svg',
  'import': 'Import.svg',
  'print': 'Print.svg',
  'clipboard': 'Clipboard.svg',
  
  // E-commerce
  'cart': 'ShoppingCart.svg',
  'shopping-cart': 'ShoppingCart.svg',
  'credit-card': 'CreditCard.svg',
  'tag': 'Tag:Label.svg',
  'label': 'Tag:Label.svg',
  'gift': 'Gift.svg',
  'promotion': 'Promotion.svg',
  'shipping': 'Shipping.svg',
  'truck': 'Shipping.svg',
  'delivery': 'Shipping.svg',
  'shop': 'Shop.svg',
  'store': 'Shop.svg',
  'shopping-bag': 'Shop.svg',
  'free-shipping': 'FreeShipping.svg',
  
  // User & Account
  'user': 'Profile.svg',
  'profile': 'Profile.svg',
  'admin': 'Manager:staff.svg',
  'manager': 'Manager:staff.svg',
  'staff': 'Manager:staff.svg',
  'employee': 'Manager:staff.svg',
  'login': 'Login.svg',
  'logout': 'Logout.svg',
  'lock': 'Lock.svg',
  
  // Communication
  'phone': 'Phone.svg',
  'email': 'Email.svg',
  'message': 'Chat.svg',
  'chat': 'Chat.svg',
  'bell': 'Notification.svg',
  'notification': 'Notification.svg',
  'announcement': 'Announcement.svg',
  
  // System & Settings
  'settings': 'Settings.svg',
  'home': 'Dashboard.svg',
  'dashboard': 'Dashboard.svg',
  'globe': 'Website.svg',
  'website': 'Website.svg',
  'lightbulb': 'Idea.svg',
  'idea': 'Idea.svg',
  
  // Status
  'pending': 'Pending.svg',
  'completed': 'Completed.svg',
  'failed': 'Failed.svg',
  'cancelled': 'Failed.svg',
  'important': 'Important.svg',
  'pin': 'Important.svg',
  
  // Special
  'star': 'Rating.svg',
  'rating': 'Rating.svg',
  'heart': 'Like.svg',
  'like': 'Like.svg',
  'thumbs-up': 'ThumbUp.svg',
  'thumbs-down': 'ThumbDown.svg',
  'trophy': 'Achievement.svg',
  'achievement': 'Achievement.svg',
  'celebration': 'Celebration.svg',
  'location': 'Location.svg',
  'clock': 'Clock.svg',
  'timer': 'Clock.svg',
  'note': 'Note.svg',
  'link': 'Link.svg',
  
  // Pagination
  'chevron-left': 'ChartDown.svg', // You may need specific chevron icons
  'chevron-right': 'Growth.svg',
  'chevrons-left': 'ChartDown.svg',
  'chevrons-right': 'Growth.svg'
}

const iconPath = computed(() => {
  const fileName = iconMap[props.name] || 'Warning.svg'
  return new URL(`../../assets/${fileName}`, import.meta.url).href
})

const sizeClass = computed(() => {
  const sizes = {
    xs: 'icon-xs',
    sm: 'icon-sm',
    md: 'icon-md',
    lg: 'icon-lg',
    xl: 'icon-xl'
  }
  return sizes[props.size] || 'icon-md'
})
</script>

<style scoped>
.icon {
  display: inline-block;
  vertical-align: middle;
  flex-shrink: 0;
}

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
