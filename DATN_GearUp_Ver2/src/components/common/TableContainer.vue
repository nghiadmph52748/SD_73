<template>
  <div class="table-container">
    <div class="table-wrapper">
      <!-- Keep the legacy class name for backward compatibility -->
      <table class="coupons-table app-table">
        <slot />
      </table>
    </div>
  </div>
</template>

<script setup>
// Presentational container for data tables.
// Provide <thead> and <tbody> via the default slot.
</script>

<style>
/* Design tokens (scoped to container to avoid global bleed) */
.table-container {
  --radius: 12px;
  --border: #e5e7eb;
  --bg: #ffffff;
  --header-bg: #f8fafc;
  --header-text: #475569;
  --cell-text: #111827;
  --muted-text: #64748b;
  --row-hover: #f9fafb;
  --shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  --cell-pad-y: 6px;
  --cell-pad-x: 8px;
  --font-size: 0.8125rem;

  width: 100%;
  margin: 0 1rem;
}

.table-wrapper {
  width: 100%;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  border-radius: var(--radius);
  background: var(--bg);
  box-shadow: var(--shadow);
}

/* Base table styles (keep legacy .coupons-table for compatibility) */
.app-table,
.coupons-table {
  width: 100%;
  border-collapse: separate; /* better radius + sticky */
  border-spacing: 0;
  table-layout: fixed; /* predictable column widths */
  min-width: 100%; /* shrink to container width */
  font-size: var(--font-size);
  color: var(--cell-text);
}

.app-table th,
.app-table td,
.coupons-table th,
.coupons-table td {
  padding: var(--cell-pad-y) var(--cell-pad-x);
  line-height: 1.35;
  vertical-align: middle;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Header */
.app-table thead th,
.coupons-table thead th {
  position: sticky;
  top: 0;
  z-index: 2;
  background: var(--header-bg);
  color: var(--header-text);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 600;
  border-bottom: 1px solid var(--border);
}

/* Body */
.app-table tbody tr,
.coupons-table tbody tr {
  border-bottom: 1px solid var(--border);
  transition: background-color 0.18s ease;
}

.app-table tbody tr:hover,
.coupons-table tbody tr:hover {
  background: var(--row-hover);
}

/* Zebra (optional subtle) */
.app-table tbody tr:nth-child(odd) { background-color: rgba(0,0,0,0.01); }

/* Rounded corners on first/last row when header is sticky */
.app-table thead th:first-child { border-top-left-radius: var(--radius); }
.app-table thead th:last-child { border-top-right-radius: var(--radius); }

/* Align utilities */
.ta-left { text-align: left; }
.ta-center { text-align: center; }
.ta-right { text-align: right; }
.nowrap { white-space: nowrap; }
.truncate { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

/* Generic width utilities to standardize sizing (responsive-friendly) */
.col-xs { min-width: 36px; }
.col-sm { min-width: 60px; }
.col-md { min-width: 96px; }
.col-lg { min-width: 128px; }
.col-xl { min-width: 160px; }

/* Sticky column helpers (opt-in) */
.sticky-left { position: sticky; left: 0; z-index: 3; background: var(--bg); box-shadow: 1px 0 0 var(--border); }
.sticky-right { position: sticky; right: 0; z-index: 3; background: var(--bg); box-shadow: -1px 0 0 var(--border); }

/* Density variants (opt-in) */
.app-table.density-compact th,
.app-table.density-compact td { padding: 8px 10px; }
.app-table.density-comfortable th,
.app-table.density-comfortable td { padding: 12px 16px; }

/* Legacy column helpers kept for backward compatibility */
/* Converted to min-width only so columns can shrink to fit and avoid scroll */
.col-checkbox { min-width: 32px; text-align: center; }
.col-stt { min-width: 40px; text-align: center; }
.col-ma { min-width: 72px; text-align: center; }
.col-ten { min-width: 120px; text-align: left; }
.col-loai { min-width: 90px; text-align: center; }
.col-giatri { min-width: 72px; text-align: center; }
.col-batdau { min-width: 100px; text-align: center; }
.col-ketthuc { min-width: 100px; text-align: center; }
.col-soluong { min-width: 56px; text-align: center; }
.col-trangthai { min-width: 100px; text-align: center; }
.col-hanhdong { min-width: 120px; text-align: center; }

/* Responsive tweaks */
@media (max-width: 1024px) {
  .table-container { margin: 0 0.5rem; }
}

@media (max-width: 768px) {
  .app-table th, .app-table td,
  .coupons-table th, .coupons-table td { padding: 6px 8px; }
}

@media (max-width: 640px) {
  .app-table th, .app-table td,
  .coupons-table th, .coupons-table td { padding: 4px 6px; font-size: 0.78rem; }
}
</style>
