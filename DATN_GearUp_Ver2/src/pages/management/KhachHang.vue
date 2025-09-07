<template>
  <div class="customer-management">
    <!-- Search and Filter Section -->
    <div class="filter-section">
      <div class="search-controls">
        <div class="search-box">
          <input
            type="text"
            placeholder="Tìm kiếm tên hoặc sdt hoặc email"
            v-model="searchQuery"
            class="form-control"
          />
        </div>

        <div class="filter-controls">
          <select v-model="selectedGender" class="form-control">
            <option value="">Giới tính: Tất cả</option>
            <option value="Nam">Nam</option>
            <option value="Nữ">Nữ</option>
          </select>

          <select v-model="selectedStatus" class="form-control">
            <option value="">Trạng thái: Tất cả</option>
            <option value="active">Hoạt động</option>
            <option value="inactive">Ngừng hoạt động</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Customers Table -->
    <div
      style="
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 10px;
      "
    >
      <div
        style="
          font-weight: bold;
          font-size: 16px;
          display: flex;
          align-items: center;
          gap: 6px;
        "
      >
        <img :src="ClipboardIcon" alt="Clipboard" class="icon-sm" /> Danh sách Khách Hàng
      </div>
    </div>
    <hr style="margin-top: 0; margin-bottom: 15px" />

    <div style="display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 20px">
      <button class="custom-button" @click="showAddModal = true">
        <img :src="PlusIcon" alt="Plus" class="icon-sm" /> Thêm khách hàng
      </button>
      <button class="custom-button" @click="exportToExcel">
        <img :src="ExcelIcon" alt="Excel" class="icon-sm" /> Download template
      </button>
    </div>
    <div class="card">
      <div class="card-body">
        <table class="table">
          <thead>
            <tr>
              <th>STT</th>
              <th>Tên khách hàng</th>
              <th>Email</th>
              <th>Số điện thoại</th>
              <th>Giới tính</th>
              <th>Ngày sinh</th>
              <th>Địa chỉ</th>
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
              <td class="customer-name">{{ customer.tenKhachHang }}</td>
              <td>{{ customer.email }}</td>
              <td>{{ customer.soDienThoai }}</td>
              <td>{{ customer.gioiTinh ? "Nam" : "Nữ" }}</td>
              <td>{{ customer.ngaySinh }}</td>
              <td>
                {{
                  customer.listDiaChi && customer.listDiaChi.length > 0
                    ? customer.listDiaChi[0].diaChiCuThe +
                      ", " +
                      customer.listDiaChi[0].phuong +
                      ", " +
                      customer.listDiaChi[0].quan +
                      ", " +
                      customer.listDiaChi[0].thanhPho
                    : "Chưa cập nhật"
                }}
              </td>
              <td>
                <span
                  :class="[
                    'badge',
                    customer.deleted === false
                      ? 'badge-success'
                      : 'badge-danger',
                  ]"
                >
                  {{
                    customer.deleted === false ? "Hoạt động" : "Ngừng hoạt động"
                  }}
                </span>
              </td>
              <td>
                <ButtonGroup spacing="xs">
                  <ActionButton
                    icon="view"
                    variant="info"
                    size="sm"
                    tooltip="Xem chi tiết"
                    class="action-button-info"
                    @click="viewCustomer(customer)"
                  />
                  <ActionButton
                    icon="edit"
                    variant="warning"
                    size="sm"
                    tooltip="Chỉnh sửa thông tin"
                    class="action-button-warning"
                    @click="editCustomer(customer)"
                  />
                  <ActionButton
                    icon="delete"
                    variant="danger"
                    size="sm"
                    tooltip="Xóa khách hàng"
                    class="action-button-danger"
                    @click="deleteCustomer(customer.id)"
                  />
                </ButtonGroup>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Pagination -->
        <div class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của
            {{ totalCustomers }} khách hàng
          </div>
          <div class="pagination">
            <button
              class="btn btn-outline btn-sm"
              @click="previousPage"
              :disabled="currentPage === 1"
            >
              ❮ Trước
            </button>
            <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
            <button
              class="btn btn-outline btn-sm"
              @click="nextPage"
              :disabled="currentPage === totalPages"
            >
              Sau ❯
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Customer Detail Modal -->
    <div
      v-if="showDetailModal"
      class="modal-overlay"
      @click="showDetailModal = false"
    >
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Chi tiết khách hàng</h3>
          <button class="modal-close" @click="showDetailModal = false">
            ✕
          </button>
        </div>

        <div class="modal-body" v-if="selectedCustomer">
          <div class="customer-detail">
            <div class="customer-info">
              <h4>{{ selectedCustomer.tenKhachHang }}</h4>
              <div class="info-grid">
                <div class="info-box">
                  <label>Email:</label>
                  <span>{{ selectedCustomer.email }}</span>
                </div>
                <div class="info-box">
                  <label>Số điện thoại:</label>
                  <span>{{ selectedCustomer.soDienThoai }}</span>
                </div>
                <div class="info-box">
                  <label>Ngày sinh:</label>
                  <span>{{ selectedCustomer.ngaySinh }}</span>
                </div>
                <div class="info-box">
                  <label>Giới tính:</label>
                  <span>{{ selectedCustomer.gioiTinh ? "Nam" : "Nữ" }}</span>
                </div>
                <div class="info-box">
                  <label>Tài khoản:</label>
                  <span>{{ selectedCustomer.tenTaiKhoan }}</span>
                </div>
                <div class="info-box">
                  <label>Mật khẩu:</label>
                  <span>{{ selectedCustomer.matKhau }}</span>
                </div>
                <div class="info-item address-list-item">
                  <label>Địa chỉ:</label>
                  <div
                    v-if="
                      selectedCustomer.listDiaChi &&
                      selectedCustomer.listDiaChi.length > 0
                    "
                    class="address-list"
                  >
                    <div
                      v-for="(address, index) in selectedCustomer.listDiaChi"
                      :key="index"
                      class="address-detail-item"
                    >
                      <span class="address-label"
                        >Địa chỉ {{ index + 1 }}:</span
                      >
                      <span class="address-value">
                        {{
                          address.diaChiCuThe +
                          ", " +
                          address.phuong +
                          ", " +
                          address.quan +
                          ", " +
                          address.thanhPho
                        }}
                      </span>
                    </div>
                  </div>
                  <span v-else>Chưa cập nhật</span>
                </div>
                <div class="info-item">
                  <label>Trạng thái:</label>
                  <span
                    :class="[
                      'badge',
                      selectedCustomer.deleted === false
                        ? 'badge-success'
                        : 'badge-danger',
                    ]"
                  >
                    {{
                      selectedCustomer.deleted === false
                        ? "Hoạt động"
                        : "Ngừng hoạt động"
                    }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Customer Modal -->
    <div
      v-if="showAddModal"
      class="modal-overlay"
      @click="showAddModal = false"
    >
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>Thông tin khách hàng</h3>
          <button class="modal-close" @click="showAddModal = false">✕</button>
        </div>

        <div class="modal-body">
          <div class="form-sections">
            <div class="form-section">
              <h4>Thông tin cá nhân</h4>

              <div class="form-group">
                <label class="form-label">*Họ và tên</label>
                <input
                  type="text"
                  v-model="customerForm.tenKhachHang"
                  class="form-control"
                  required
                />
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Email</label>
                  <input
                    type="email"
                    v-model="customerForm.email"
                    class="form-control"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Số điện thoại</label>
                  <input
                    type="tel"
                    v-model="customerForm.soDienThoai"
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
                    v-model="customerForm.ngaySinh"
                    class="form-control"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Giới tính</label>
                  <select v-model="customerForm.gioiTinh" class="form-control">
                    <option :value="true">Nam</option>
                    <option :value="false">Nữ</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="form-section">
              <h4>Thông tin tài khoản</h4>
            </div>
            <div class="form-group">
              <label class="form-label">*Tài khoản</label>
              <input
                type="text"
                v-model="customerForm.tenTaiKhoan"
                class="form-control"
                required
              />
            </div>
            <div class="form-group">
              <label class="form-label">*Mật khẩu</label>
              <input
                type="password"
                v-model="customerForm.matKhau"
                class="form-control"
                required
              />
            </div>
          </div>

          <div class="form-section">
            <div class="address-header">
              <h4>Địa chỉ</h4>
              <button
                type="button"
                class="btn-add-address"
                @click="addAddress"
                title="Thêm địa chỉ"
              >
                <span class="btn-icon"><img :src="PlusIcon" alt="Plus" class="icon-sm" /></span>
                Thêm địa chỉ
              </button>
            </div>

            <div
              v-for="(address, index) in customerForm.listDiaChi"
              :key="index"
              class="address-item"
            >
              <div class="address-item-header">
                <h5>Địa chỉ {{ index + 1 }}</h5>
                <button
                  v-if="customerForm.listDiaChi.length > 1"
                  type="button"
                  class="btn-remove-address"
                  @click="removeAddress(index)"
                  title="Xóa địa chỉ"
                >
                  <span class="btn-icon">❌</span>
                </button>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Tỉnh/thành phố</label>
                  <input
                    type="text"
                    v-model="address.thanhPho"
                    class="form-control"
                    placeholder="Nhập tên tỉnh/thành phố"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Quận/huyện</label>
                  <input
                    type="text"
                    v-model="address.quan"
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
                    v-model="address.phuong"
                    class="form-control"
                    placeholder="Nhập tên xã/phường/thị trấn"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Địa chỉ cụ thể</label>
                  <input
                    type="text"
                    v-model="address.diaChiCuThe"
                    class="form-control"
                    required
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button
            type="button"
            class="btn btn-secondary"
            @click="showAddModal = false"
          >
            Hủy
          </button>
          <button type="submit" class="btn btn-primary" @click="saveCustomer">
            Thêm khách hàng
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Edit Customer Modal -->
  <div
    v-if="showEditModal"
    class="modal-overlay"
    @click="showEditModal = false"
  >
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3>Cập nhật thông tin khách hàng</h3>
        <button class="modal-close" @click="showEditModal = false">✕</button>
      </div>
      <div class="modal-body">
        <div class="form-sections">
          <div class="form-section">
            <h4>Thông tin cá nhân</h4>
            <div class="form-group">
              <label class="form-label">*Họ và tên</label>
              <input
                type="text"
                v-model="customerForm.tenKhachHang"
                class="form-control"
                required
              />
            </div>
            <div class="form-row">
              <div class="form-group">
                <label class="form-label">*Email</label>
                <input
                  type="email"
                  v-model="customerForm.email"
                  class="form-control"
                  required
                />
              </div>
              <div class="form-group">
                <label class="form-label">*Số điện thoại</label>
                <input
                  type="tel"
                  v-model="customerForm.soDienThoai"
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
                  v-model="customerForm.ngaySinh"
                  class="form-control"
                  required
                />
              </div>
              <div class="form-group">
                <label class="form-label">*Giới tính</label>
                <select v-model="customerForm.gioiTinh" class="form-control">
                  <option :value="true">Nam</option>
                  <option :value="false">Nữ</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">*Tài khoản</label>
              <input
                type="text"
                v-model="customerForm.tenTaiKhoan"
                class="form-control"
                required
              />
            </div>
            <div class="form-group"></div>
            <label class="form-label">*Mật khẩu</label>
            <input
              type="password"
              v-model="customerForm.matKhau"
              class="form-control"
              required
            />
          </div>
          <div class="form-group">
            <label class="form-label">*Trạng thái</label>
            <select v-model="customerForm.deleted" class="form-control">
              <option :value="false">Hoạt động</option>
              <option :value="true">Ngừng hoạt động</option>
            </select>
          </div>
        </div>

        <div class="form-section">
          <div class="address-header">
            <h4>Địa chỉ</h4>
            <button
              type="button"
              class="btn-add-address"
              @click="addAddress"
              title="Thêm địa chỉ"
            >
              <span class="btn-icon"><img :src="PlusIcon" alt="Plus" class="icon-sm" /></span>
              Thêm địa chỉ
            </button>
          </div>

          <div
            v-for="(address, index) in customerForm.listDiaChi"
            :key="index"
            class="address-item"
          >
            <div class="address-item-header">
              <h5>Địa chỉ {{ index + 1 }}</h5>
              <button
                v-if="customerForm.listDiaChi.length > 1"
                type="button"
                class="btn-remove-address"
                @click="removeAddress(index)"
                title="Xóa địa chỉ"
              >
                <span class="btn-icon">❌</span>
              </button>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label class="form-label">*Tỉnh/thành phố</label>
                <input
                  type="text"
                  v-model="address.thanhPho"
                  class="form-control"
                  placeholder="Nhập tên tỉnh/thành phố"
                  required
                />
              </div>
              <div class="form-group">
                <label class="form-label">*Quận/huyện</label>
                <input
                  type="text"
                  v-model="address.quan"
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
                  v-model="address.phuong"
                  class="form-control"
                  placeholder="Nhập tên xã/phường/thị trấn"
                  required
                />
              </div>
              <div class="form-group">
                <label class="form-label">*Địa chỉ cụ thể</label>
                <input
                  type="text"
                  v-model="address.diaChiCuThe"
                  class="form-control"
                  required
                />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button
          type="button"
          class="btn btn-secondary"
          @click="showEditModal = false"
        >
          Hủy
        </button>
        <button type="submit" class="btn btn-primary" @click="saveCustomer">
          Cập nhật khách hàng
        </button>
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

import ButtonGroup from "@/components/ui/NhomNut.vue";
import ActionButton from "@/components/ui/NutHanhDong.vue";
import { saveAs } from "file-saver";
import { computed, onMounted, ref } from "vue";
import * as XLSX from "xlsx";

import {
    fetchAllKhachHang,
    fetchCreateKhachHang,
    fetchUpdateKhachHang,
    fetchUpdateStatusKhachHang,
} from "../../services/KhachHang/KhachHangService";

// Data
const searchQuery = ref("");
const selectedGender = ref("");
const selectedStatus = ref("");
const showDetailModal = ref(false);
const showAddModal = ref(false);
const showEditModal = ref(false);
const selectedCustomer = ref({});

// Pagination data
const currentPage = ref(1);
const itemsPerPage = ref(10);

// Dữ liệu form khách hàng
const customerForm = ref({
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

// Mock data
const customers = ref([]);
const fetchAll = async () => {
  try {
    const response = await fetchAllKhachHang();
    customers.value = response.data; // giữ nguyên tất cả, lọc ở computed
  } catch (res) {}
};

// Computed
const filteredCustomers = computed(() => {
  let filtered = customers.value;

  if (searchQuery.value) {
    filtered = filtered.filter(
      (customer) =>
        customer.tenKhachHang
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        customer.email
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        customer.soDienThoai.includes(searchQuery.value)
    );
  }

  if (selectedGender.value) {
    const isNam = selectedGender.value === "Nam";
    filtered = filtered.filter((customer) => customer.gioiTinh === isNam);
  }

  if (selectedStatus.value) {
    const isActive = selectedStatus.value === "active";
    filtered = filtered.filter((customer) => customer.deleted === !isActive);
  }

  return filtered.slice(startIndex.value, endIndex.value);
});

const totalCustomers = computed(() => {
  let filtered = customers.value;

  if (searchQuery.value) {
    filtered = filtered.filter(
      (customer) =>
        customer.tenKhachHang
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        customer.email
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        customer.soDienThoai.includes(searchQuery.value)
    );
  }

  if (selectedGender.value) {
    const isNam = selectedGender.value === "Nam";
    filtered = filtered.filter((customer) => customer.gioiTinh === isNam);
  }

  if (selectedStatus.value) {
    const isActive = selectedStatus.value === "active";
    filtered = filtered.filter((customer) => customer.deleted === !isActive);
  }

  return filtered.length;
});

const totalPages = computed(() =>
  Math.ceil(totalCustomers.value / itemsPerPage.value)
);

const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value);
const endIndex = computed(() =>
  Math.min(startIndex.value + itemsPerPage.value, totalCustomers.value)
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

const viewCustomer = (customer) => {
  selectedCustomer.value = { ...customer };
  showDetailModal.value = true;
};

const editCustomer = (customer) => {
  // Điền dữ liệu khách hàng vào form
  customerForm.value = {
    ...customer,
    listDiaChi:
      customer.listDiaChi && customer.listDiaChi.length > 0
        ? customer.listDiaChi
        : [
            {
              diaChiCuThe: "",
              thanhPho: "",
              quan: "",
              phuong: "",
            },
          ],
  };
  showEditModal.value = true;
};

const addCustomer = () => {
  resetForm();
  showAddModal.value = true;
};

const saveCustomer = async () => {
  try {
    if (showAddModal.value) {
      await fetchCreateKhachHang(customerForm.value);
      currentPage.value = 1;
    } else if (showEditModal.value) {
      await fetchUpdateKhachHang(customerForm.value.id, customerForm.value);
    }
    showAddModal.value = false;
    showEditModal.value = false;
    await fetchAll();
    resetForm();
  } catch (res) {
    alert("Có lỗi xảy ra khi lưu thông tin khách hàng");
  }
};

const deleteCustomer = async (id) => {
  const confirmDelete = window.confirm(
    "Bạn có chắc chắn muốn xoá khách hàng này không?"
  );
  if (!confirmDelete) return;

  try {
    await fetchUpdateStatusKhachHang(id); // cập nhật deleted = true
    customers.value = customers.value.filter((c) => c.id !== id); // ẩn ngay khỏi bảng
    alert("✅ Đã xoá khách hàng khỏi danh sách hiển thị.");
  } catch (error) {
    console.error("❌ Lỗi khi xoá khách hàng:", error.message);
    alert("❌ Có lỗi xảy ra khi xoá khách hàng.");
  }
};

const addAddress = () => {
  customerForm.value.listDiaChi.push({
    diaChiCuThe: "",
    thanhPho: "",
    quan: "",
    phuong: "",
  });
};

const removeAddress = (index) => {
  if (customerForm.value.listDiaChi.length > 1) {
    customerForm.value.listDiaChi.splice(index, 1);
  }
};

const resetForm = () => {
  customerForm.value = {
    tenKhachHang: "",
    email: "",
    soDienThoai: "",
    tenTaiKhoan: "",
    matKhau: "",
    gioiTinh: true,
    ngaySinh: "",
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

const refreshData = async () => {
  await fetchAll();
};

const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

const exportToExcel = () => {
  try {
    const headerMapping = {
      tenKhachHang: "Họ tên",
      email: "Email",
      soDienThoai: "Số điện thoại",
      ngaySinh: "Ngày sinh",
      gioiTinh: "Giới tính",
      deleted: "Trạng thái",
    };

    const filteredData = filteredCustomers.value.map((item) => ({
      [headerMapping.tenKhachHang]: item.tenKhachHang || "N/A",
      [headerMapping.email]: item.email || "N/A",
      [headerMapping.soDienThoai]: item.soDienThoai || "N/A",
      [headerMapping.ngaySinh]: item.ngaySinh
        ? formatDate(item.ngaySinh)
        : "N/A",
      [headerMapping.gioiTinh]: item.gioiTinh ? "Nam" : "Nữ",
      [headerMapping.deleted]: item.deleted ? "Ngừng hoạt động" : "Hoạt động",
    }));

    // Tạo worksheet & workbook
    const worksheet = XLSX.utils.json_to_sheet(filteredData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "KhachHang");

    // Xuất file
    const excelBuffer = XLSX.write(workbook, {
      bookType: "xlsx",
      type: "array",
    });
    const data = new Blob([excelBuffer], { type: "application/octet-stream" });
    saveAs(data, "DanhSachKhachHang.xlsx");

    alert("✅ Xuất file Excel thành công!");
  } catch (error) {
    console.error("Error exporting to Excel:", error);
    alert("❌ Có lỗi xảy ra khi xuất file Excel");
  }
};

onMounted(fetchAll);
</script>

<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/khachHang.css';

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

/* Button icon alignment */
.custom-button {
  display: flex;
  align-items: center;
  gap: 8px;
}

.custom-button img {
  flex-shrink: 0;
}

</style>
