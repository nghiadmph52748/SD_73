<template>
  <div class="date-picker" ref="pickerRoot">
    <button
      type="button"
      class="date-picker-trigger"
      @click="togglePanel"
      ref="triggerRef"
    >
      <div class="date-picker-display">
        <span v-if="formattedValue">{{ formattedValue }}</span>
        <span v-else class="placeholder">Chọn ngày</span>
      </div>
      <svg class="date-picker-icon" viewBox="0 0 24 24" aria-hidden="true">
        <path
          d="M8 7V5a1 1 0 0 1 2 0v2h4V5a1 1 0 1 1 2 0v2h1.5A2.5 2.5 0 0 1 20 9.5v9A2.5 2.5 0 0 1 17.5 21h-11A2.5 2.5 0 0 1 4 18.5v-9A2.5 2.5 0 0 1 6.5 7H8Zm-1.5 2C6.224 9 6 9.224 6 9.5V11h12V9.5c0-.276-.224-.5-.5-.5H16v1a1 1 0 1 1-2 0V9h-4v1a1 1 0 1 1-2 0V9H6.5Z"
          fill="currentColor"
        />
      </svg>
    </button>

    <teleport to="body">
      <transition name="dp-fade">
        <div
          v-if="panelOpen"
          class="date-picker-panel"
          ref="panelRef"
          :style="panelStyles"
        >
          <div class="panel-header">
            <button type="button" class="nav-btn" @click="goToPrevMonth" aria-label="Tháng trước">
              <span>&lsaquo;</span>
            </button>
            <div class="current-month">
              <span class="month">{{ currentMonthLabel }}</span>
              <span class="year">{{ currentYear }}</span>
            </div>
            <button type="button" class="nav-btn" @click="goToNextMonth" aria-label="Tháng sau">
              <span>&rsaquo;</span>
            </button>
          </div>

          <div class="panel-weekdays">
            <span v-for="day in weekDays" :key="day">{{ day }}</span>
          </div>

          <div class="panel-grid">
            <button
              v-for="day in calendarDays"
              :key="day.key"
              class="day-cell"
              type="button"
              :class="{
                'muted': !day.isCurrentMonth,
                'today': day.isToday,
                'selected': isSameDate(day.date, selectedDate),
                'disabled': day.isDisabled
              }"
              :disabled="day.isDisabled"
              @click="selectDate(day.date)"
            >
              {{ day.date.getDate() }}
            </button>
          </div>

          <!-- Time picker (Apple Clock style) -->
          <div class="panel-time" v-if="withTime">
            <div class="time-picker">
              <div class="wheel">
                <ul class="wheel-list" ref="hourListRef" @scroll="onWheelScroll('hour')">
                  <li
                    v-for="(h, idx) in hoursLoop"
                    :key="`h-${idx}`"
                    class="wheel-item"
                    :class="{ active: selectedHour === h }"
                  >
                    {{ pad(h) }}
                  </li>
                </ul>
              </div>
              <div class="wheel-sep">:</div>
              <div class="wheel">
                <ul class="wheel-list" ref="minuteListRef" @scroll="onWheelScroll('minute')">
                  <li
                    v-for="(m, idx) in minutesLoop"
                    :key="`m-${idx}`"
                    class="wheel-item"
                    :class="{ active: selectedMinute === m }"
                  >
                    {{ pad(m) }}
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Footer actions -->
          <div class="panel-footer">
            <button type="button" class="panel-btn clear" @click="clearSelection">Xóa</button>
            <div class="footer-spacer"></div>
            <button type="button" class="panel-btn today" @click="selectToday">Hôm nay</button>
          </div>
        </div>
      </transition>
    </teleport>
  </div>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue';

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  min: {
    type: String,
    default: ''
  },
  max: {
    type: String,
    default: ''
  },
  withTime: {
    type: Boolean,
    default: false
  },
  returnType: {
    // 'date' => YYYY-MM-DD, 'datetime' => YYYY-MM-DDTHH:mm
    type: String,
    default: 'date'
  }
});

const emit = defineEmits(['update:modelValue']);

const pickerRoot = ref(null);
const triggerRef = ref(null);
const panelRef = ref(null);
const panelOpen = ref(false);
const panelStyles = ref({ top: '-9999px', left: '-9999px' });

const selectedDate = ref(parseInputDate(props.modelValue));
const viewDate = ref(selectedDate.value ? new Date(selectedDate.value) : new Date());

// Time state (24h)
const selectedHour = ref(0);
const selectedMinute = ref(0);
const hourListRef = ref(null);
const minuteListRef = ref(null);

// wheel constants
const ITEM_HEIGHT = 36;
const H_COUNT = 24;
const M_COUNT = 60;
const LOOP_MULTIPLIER = 3; // create 3 loops for infinite effect

const hoursLoop = computed(() => Array.from({ length: H_COUNT * LOOP_MULTIPLIER }, (_, i) => i % H_COUNT));
const minutesLoop = computed(() => Array.from({ length: M_COUNT * LOOP_MULTIPLIER }, (_, i) => i % M_COUNT));

if (props.withTime && selectedDate.value) {
  const init = parseTimeFromInput(props.modelValue);
  selectedHour.value = init.hour;
  selectedMinute.value = init.minute;
}

const minDate = computed(() => (props.min ? parseIsoDate(props.min) : null));
const maxDate = computed(() => (props.max ? parseIsoDate(props.max) : null));

watch(
  () => props.modelValue,
  (value) => {
    if (!value) {
      selectedDate.value = null;
      if (props.withTime) {
        selectedHour.value = 0;
        selectedMinute.value = 0;
      }
      return;
    }
    const parsed = parseInputDate(value);
    if (parsed && (!selectedDate.value || parsed.getTime() !== selectedDate.value.getTime())) {
      selectedDate.value = parsed;
      viewDate.value = new Date(parsed);
      if (props.withTime) {
        const t = parseTimeFromInput(value);
        selectedHour.value = t.hour;
        selectedMinute.value = t.minute;
      }
    }
  }
);

const formattedValue = computed(() => {
  if (!selectedDate.value) return '';
  const base = selectedDate.value.toLocaleDateString('vi-VN', {
    weekday: 'short',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  });
  if (props.withTime) {
    return `${base} ${pad(selectedHour.value)}:${pad(selectedMinute.value)}`;
  }
  return base;
});

const currentMonthLabel = computed(() =>
  viewDate.value.toLocaleDateString('vi-VN', { month: 'long' })
);

const currentYear = computed(() => viewDate.value.getFullYear());

const weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

const calendarDays = computed(() => {
  const year = viewDate.value.getFullYear();
  const month = viewDate.value.getMonth();

  const startOfMonth = new Date(year, month, 1);
  const endOfMonth = new Date(year, month + 1, 0);

  const startWeekday = startOfMonth.getDay();
  const totalDays = endOfMonth.getDate();

  const days = [];

  // leading days
  for (let i = startWeekday - 1; i >= 0; i--) {
    const date = new Date(year, month, -i);
    days.push(makeDay(date, false));
  }

  // current month days
  for (let i = 1; i <= totalDays; i++) {
    const date = new Date(year, month, i);
    days.push(makeDay(date, true));
  }

  // trailing days to fill grid to complete weeks (42 cells max)
  const trailingCount = (7 - (days.length % 7)) % 7;
  for (let i = 1; i <= trailingCount; i++) {
    const date = new Date(year, month + 1, i);
    days.push(makeDay(date, false));
  }

  return days;
});

function makeDay(date, isCurrentMonth) {
  const today = new Date();
  const isToday = isSameDate(date, today);
  const disabled = isBeforeMin(date) || isAfterMax(date);
  return {
    key: `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`,
    date,
    isCurrentMonth,
    isToday,
    isDisabled: disabled
  };
}

function togglePanel() {
  panelOpen.value = !panelOpen.value;
  if (!panelOpen.value) {
    detachPositionListeners();
  }
}

function selectDate(date) {
  if (isBeforeMin(date) || isAfterMax(date)) {
    return;
  }
  selectedDate.value = new Date(date);
  if (props.withTime) {
    updateModelOutput();
    // keep panel open to allow time selection
  } else {
    emit('update:modelValue', formatIsoDate(date));
    panelOpen.value = false;
    detachPositionListeners();
  }
}

function goToPrevMonth() {
  const newDate = new Date(viewDate.value);
  newDate.setMonth(newDate.getMonth() - 1);
  viewDate.value = newDate;
}

function goToNextMonth() {
  const newDate = new Date(viewDate.value);
  newDate.setMonth(newDate.getMonth() + 1);
  viewDate.value = newDate;
}

function isSameDate(a, b) {
  if (!a || !b) return false;
  return (
    a.getFullYear() === b.getFullYear() &&
    a.getMonth() === b.getMonth() &&
    a.getDate() === b.getDate()
  );
}

function isBeforeMin(date) {
  if (!minDate.value) return false;
  return date < stripTime(minDate.value);
}

function isAfterMax(date) {
  if (!maxDate.value) return false;
  return date > stripTime(maxDate.value);
}

function stripTime(date) {
  return new Date(date.getFullYear(), date.getMonth(), date.getDate());
}

function parseIsoDate(value) {
  const parts = value?.split('-');
  if (!parts || parts.length !== 3) return null;
  const [year, month, day] = parts.map(Number);
  if (!year || !month || !day) return null;
  return new Date(year, month - 1, day);
}

// Accepts 'YYYY-MM-DD' or 'YYYY-MM-DDTHH:mm' or 'YYYY-MM-DD HH:mm'
function parseInputDate(value) {
  if (!value) return null;
  if (value.includes('T') || value.includes(' ')) {
    const sep = value.includes('T') ? 'T' : ' ';
    const [d] = value.split(sep);
    return parseIsoDate(d);
  }
  return parseIsoDate(value);
}

function parseTimeFromInput(value) {
  try {
    if (!value) return { hour: 0, minute: 0 };
    if (value.includes('T') || value.includes(' ')) {
      const sep = value.includes('T') ? 'T' : ' ';
      const [, t] = value.split(sep);
      const [hh, mm] = t.split(':').map((n) => parseInt(n, 10));
      return { hour: isNaN(hh) ? 0 : hh, minute: isNaN(mm) ? 0 : mm };
    }
  } catch (e) {}
  return { hour: 0, minute: 0 };
}

function pad(n) { return `${n}`.padStart(2, '0'); }

function formatIsoDateTime(date) {
  const yyyy = date.getFullYear();
  const mm = `${date.getMonth() + 1}`.padStart(2, '0');
  const dd = `${date.getDate()}`.padStart(2, '0');
  const hh = pad(date.getHours());
  const mi = pad(date.getMinutes());
  return `${yyyy}-${mm}-${dd}T${hh}:${mi}`;
}

function formatIsoDate(date) {
  const yyyy = date.getFullYear();
  const mm = `${date.getMonth() + 1}`.padStart(2, '0');
  const dd = `${date.getDate()}`.padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}

function handleClickOutside(event) {
  const root = pickerRoot.value;
  const panelEl = panelRef.value;
  if (!root) return;
  if (!root.contains(event.target) && !(panelEl && panelEl.contains(event.target))) {
    panelOpen.value = false;
    detachPositionListeners();
  }
}

onMounted(() => {
  document.addEventListener('mousedown', handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('mousedown', handleClickOutside);
  detachPositionListeners();
});

function updatePanelPosition() {
  const triggerEl = triggerRef.value;
  const panelEl = panelRef.value;
  if (!triggerEl || !panelEl) return;

  const triggerRect = triggerEl.getBoundingClientRect();
  const panelRect = panelEl.getBoundingClientRect();
  const viewportWidth = window.innerWidth;
  const viewportHeight = window.innerHeight;

  let top = triggerRect.bottom + 8;
  let left = triggerRect.left;

  if (left + panelRect.width > viewportWidth - 16) {
    left = Math.max(16, viewportWidth - panelRect.width - 16);
  }

  if (top + panelRect.height > viewportHeight - 16) {
    top = triggerRect.top - panelRect.height - 8;
  }

  top = Math.max(16, top);
  left = Math.max(16, left);

  panelStyles.value = {
    position: 'fixed',
    top: `${top}px`,
    left: `${left}px`
  };
}

function attachPositionListeners() {
  window.addEventListener('resize', updatePanelPosition);
  window.addEventListener('scroll', updatePanelPosition, true);
}

function detachPositionListeners() {
  window.removeEventListener('resize', updatePanelPosition);
  window.removeEventListener('scroll', updatePanelPosition, true);
}

watch(panelOpen, async (open) => {
  if (open) {
    await nextTick();
    updatePanelPosition();
    attachPositionListeners();
    if (props.withTime) {
      // center wheels to middle loop
      if (hourListRef.value) hourListRef.value.scrollTop = (H_COUNT + selectedHour.value) * ITEM_HEIGHT;
      if (minuteListRef.value) minuteListRef.value.scrollTop = (M_COUNT + selectedMinute.value) * ITEM_HEIGHT;
    }
  } else {
    detachPositionListeners();
    panelStyles.value = { top: '-9999px', left: '-9999px', position: 'fixed' };
  }
});

watch([minDate, maxDate], () => {
  if (selectedDate.value) {
    if (isBeforeMin(selectedDate.value) && minDate.value) {
      selectedDate.value = stripTime(minDate.value);
      updateModelOutput();
    }
    if (isAfterMax(selectedDate.value) && maxDate.value) {
      selectedDate.value = stripTime(maxDate.value);
      updateModelOutput();
    }
  }
});

watch([selectedHour, selectedMinute], () => {
  if (props.withTime && selectedDate.value) {
    updateModelOutput();
  }
});

function onWheelScroll(type) {
  if (!props.withTime) return;
  const list = type === 'hour' ? hourListRef.value : minuteListRef.value;
  if (!list) return;

  const UNIT = type === 'hour' ? H_COUNT : M_COUNT;
  const block = UNIT * ITEM_HEIGHT;

  // Looping logic: keep scroll within middle block
  if (list.scrollTop <= block * 0.5) {
    list.scrollTop += block;
  } else if (list.scrollTop >= block * 2.5) {
    list.scrollTop -= block;
  }

  const rawIndex = Math.round(list.scrollTop / ITEM_HEIGHT);
  const normalized = ((rawIndex % UNIT) + UNIT) % UNIT;
  if (type === 'hour') {
    selectedHour.value = normalized;
  } else {
    selectedMinute.value = normalized;
  }
}

function updateModelOutput() {
  if (!selectedDate.value) {
    emit('update:modelValue', '');
    return;
  }
  const outDate = new Date(
    selectedDate.value.getFullYear(),
    selectedDate.value.getMonth(),
    selectedDate.value.getDate(),
    props.withTime ? selectedHour.value : 0,
    props.withTime ? selectedMinute.value : 0
  );
  if (props.withTime && props.returnType === 'datetime') {
    emit('update:modelValue', formatIsoDateTime(outDate));
  } else {
    emit('update:modelValue', formatIsoDate(outDate));
  }
}

function clearSelection() {
  selectedDate.value = null;
  emit('update:modelValue', '');
  panelOpen.value = false;
  detachPositionListeners();
}

function selectToday() {
  const now = new Date();
  selectedDate.value = stripTime(now);
  if (props.withTime) {
    selectedHour.value = now.getHours();
    selectedMinute.value = now.getMinutes();
  }
  updateModelOutput();
  panelOpen.value = false;
  detachPositionListeners();
}
</script>

<style scoped>
.date-picker {
  position: relative;
  width: 100%;
}

.date-picker-trigger {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  border-radius: 12px;
  border: 1.5px solid #dbeafe;
  background: linear-gradient(135deg, rgba(219, 234, 254, 0.35) 0%, rgba(239, 246, 255, 0.75) 100%);
  color: #0f172a;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.date-picker-trigger:hover,
.date-picker-trigger:focus-visible {
  outline: none;
  border-color: #22c55e;
  box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.18);
}

.date-picker-display {
  display: flex;
  flex-direction: column;
}

.placeholder {
  color: #9ca3af;
}

.date-picker-icon {
  width: 18px;
  height: 18px;
  color: #22c55e;
}

.date-picker-panel {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 25;
  width: 280px;
  background: #ffffff;
  border-radius: 18px;
  box-shadow: 0 30px 60px -24px rgba(15, 23, 42, 0.35);
  padding: 16px 18px 18px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-weight: 600;
  color: #0f172a;
}

.nav-btn {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: none;
  background: rgba(219, 234, 254, 0.7);
  color: #0f172a;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s ease;
}

.nav-btn:hover {
  background: rgba(34, 197, 94, 0.15);
}

.current-month {
  display: flex;
  align-items: baseline;
  gap: 6px;
  text-transform: capitalize;
}

.current-month .month {
  font-size: 16px;
}

.current-month .year {
  font-size: 14px;
  color: #6b7280;
}

.panel-weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.4px;
  color: #94a3b8;
}

.panel-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 4px;
}

.day-cell {
  border: none;
  border-radius: 10px;
  padding: 8px 0;
  background: transparent;
  font-size: 13px;
  font-weight: 500;
  color: #0f172a;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease;
}

.day-cell.muted {
  color: #cbd5f5;
}

.day-cell.today {
  border: 1px solid rgba(34, 197, 94, 0.4);
}

.day-cell.selected {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.92) 0%, rgba(22, 163, 74, 0.85) 100%);
  color: #ffffff;
  box-shadow: 0 12px 24px -14px rgba(34, 197, 94, 0.6);
}

.day-cell:hover:not(.selected) {
  background: rgba(219, 234, 254, 0.6);
  transform: translateY(-1px);
}

.day-cell.disabled,
.day-cell.disabled:hover {
  background: transparent;
  color: #d1d5db;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
  border-color: transparent;
}

/* Time picker styles */
.panel-time {
  border-top: 1px solid #eef2ff;
  padding-top: 8px;
}

.time-picker {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.wheel {
  position: relative;
  width: 72px;
  height: 144px;
  overflow: hidden;
  border-radius: 12px;
  background: #f8fafc;
  border: 1px solid #e5e7eb;
}

.wheel::before {
  content: '';
  position: absolute;
  top: calc(50% - 18px);
  left: 0;
  right: 0;
  height: 36px;
  border-top: 1px solid rgba(34, 197, 94, 0.3);
  border-bottom: 1px solid rgba(34, 197, 94, 0.3);
  pointer-events: none;
}

.wheel-list {
  list-style: none;
  margin: 0;
  padding: 48px 0; /* space so center aligns */
  height: 100%;
  overflow-y: auto;
  scroll-snap-type: y mandatory;
  scrollbar-width: none; /* Firefox */
}
.wheel-list::-webkit-scrollbar { width: 0; height: 0; display: none; }

.wheel-item {
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  color: #0f172a;
  scroll-snap-align: center;
}

.wheel-item.active {
  color: #22c55e;
}

.wheel-sep {
  font-weight: 700;
  color: #0f172a;
}

.panel-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  border-top: 1px solid #eef2ff;
  margin-top: 10px;
  padding-top: 10px;
}

.panel-btn {
  border: none;
  border-radius: 10px;
  padding: 8px 12px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s ease;
}

.panel-btn.clear {
  background: rgba(239, 68, 68, 0.08);
  color: #ef4444;
}
.panel-btn.clear:hover { background: rgba(239, 68, 68, 0.16); }

.panel-btn.today {
  background: rgba(34, 197, 94, 0.1);
  color: #22c55e;
}
.panel-btn.today:hover { background: rgba(34, 197, 94, 0.18); }

.footer-spacer { flex: 1; }

.dp-fade-enter-active,
.dp-fade-leave-active {
  transition: opacity 0.15s ease, transform 0.2s ease;
}

.dp-fade-enter-from,
.dp-fade-leave-to {
  opacity: 0;
  transform: translateY(6px);
}

@media (max-width: 600px) {
  .date-picker-panel {
    width: 240px;
  }
}
</style>
