<template>
    <!-- Search and Filter Section -->
    <div class="filter-section">
      <div class="search-controls">
        <div class="search-box">
          <input
            type="text"
            placeholder="Nhập tên hoặc sdt hoặc email"
            v-model="searchQuery"
            class="form-control"
          />
        </div>

        <div class="filter-controls">
          <select v-model="selectedRole" class="form-control">
            <option value="">Chức vụ: Tất cả</option>
            <option
              v-for="value in quyenHans"
              :key="value.id"
              :value="value.tenQuyenHan"
            >
              {{ value.tenQuyenHan }}
            </option>
          </select>

          <select v-model="selectedStatus" class="form-control">
            <option value="">Trạng thái: Tất cả</option>
            <option value="active">Hoạt động</option>
            <option value="inactive">Ngừng hoạt động</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Employees Table -->
     <!-- Action Buttons Section -->
      <!-- Tiêu đề và đường kẻ ngang -->
      <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
        <div style="font-weight: bold; font-size: 16px; display: flex; align-items: center; gap: 6px;">
          <img :src="ClipboardIcon" alt="Clipboard" class="icon-sm" /> Danh sách nhân viên
        </div>
      </div>
      <hr style="margin-top: 0; margin-bottom: 15px;" />

      <div style="display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 20px;">
    <button class="custom-button" @click="showAddModal = true">
      <img :src="PlusIcon" alt="Plus" class="icon-sm" /> Thêm nhân viên
    </button>
    <button class="custom-button" @click="exportToExcel">
      <img :src="ExcelIcon" alt="Excel" class="icon-sm" /> Download template
    </button>
    </div>


    <div class="card">
      <div class="card-body">
        <div class="table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th>STT</th>
                <th>Ảnh</th>
                <th>Mã nhân viên</th>
                <th>Tên nhân viên</th>
                <th>Email</th>
                <!-- <th>SĐT</th>
                <th>Ngày sinh</th>
                <th>CCCD</th>
                <th>Địa chỉ</th> -->
                <th>Chức vụ</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="(employee, index) in filteredEmployees"
                :key="employee.id"
              >
                <td data-label="STT">
                  {{ startIndex + index + 1 }}
                </td>
                <td data-label="Ảnh">
                  <div class="employee-avatar">
                    <img
                      v-if="employee.anhNhanVien"
                      :src="'http://localhost:8080' + employee.anhNhanVien"
                      :alt="employee.tenNhanVien"
                    />
                    <div v-else class="placeholder-avatar"><img :src="ProfileIcon" alt="User" class="icon-sm" /></div>
                  </div>
                </td>
                <td data-label="Mã nhân viên" class="employee-code">
                  {{ employee.maNhanVien }}
                </td>
                <td data-label="Tên nhân viên" class="employee-name">
                  {{ employee.tenNhanVien }}
                </td>
                <td data-label="Email">{{ employee.email }}</td>
                <!-- <td data-label="SĐT">{{ employee.soDienThoai }}</td>
                <td data-label="Ngày sinh">{{ employee.ngaySinh }}</td>
                <td data-label="CCCD">{{ employee.cccd }}</td>
                <td data-label="Địa chỉ">
                  {{
                    employee.thanhPho +
                    ", " +
                    employee.quan +
                    ", " +
                    employee.phuong +
                    ", " +
                    employee.diaChiCuThe
                  }}
                </td> -->
                <td data-label="Chức vụ">{{ employee.tenQuyenHan }}</td>
                <td data-label="Trạng thái">
                  <span
                    :class="[
                      'badge',
                      employee.trangThai === true
                        ? 'badge-success'
                        : 'badge-danger',
                    ]"
                  >
                    {{ employee.trangThai ? "Hoạt động" : "Ngừng hoạt động" }}
                  </span>
                </td>
                    <td data-label="Thao tác">
                   <ButtonGroup spacing="xs" class="action-buttons">
                     <button class="btn-detail" @click="viewEmployee(employee)">
                       <span class="btn-icon"><img :src="ViewIcon" alt="View" class="icon-sm" /></span>
                     </button>
                     <button class="btn-update" @click="editEmployee(employee)">
                       <span class="btn-icon"><img :src="EditIcon" alt="Edit" class="icon-sm" /></span>
                       
                     </button>
                   </ButtonGroup>
                 </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị {{ startIndex + 1 }} - {{ endIndex }} của
            {{ totalEmployees }} nhân viên
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

    <!-- Add Employee Modal -->
    <div
      v-if="showAddModal"
      class="modal-overlay"
      @click="showAddModal = false"
    >
      <div class="modal-content add-modal" @click.stop>
        <div class="modal-header add-header">
          <h3>Thông tin nhân viên</h3>
          <button class="modal-close" @click="showAddModal = false">✕</button>
        </div>

        <div class="modal-body add-body">
          <div class="form-sections">
            <div class="form-section">
              <h4 class="section-title">Thông tin chi tiết</h4>
              <div class="avatar-upload">
                <div class="avatar-preview">
                  <img v-if="avatarPreview" :src="avatarPreview" alt="Avatar" />
                  <div v-else class="placeholder-avatar large">
                    
                    <span>Chọn ảnh</span>
                  </div>
                </div>
                <input
                  type="file"
                  @change="handleAvatarUpload"
                  accept="image/*"
                  class="file-input"
                />
              </div>
            </div>

            <div class="form-section">
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Số CCCD</label>
                  <input
                    type="text"
                    v-model="employeeForm.cccd"
                    class="form-control add-input"
                    required
                  />
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">*Ngày sinh</label>
                <input
                  type="date"
                  v-model="employeeForm.ngaySinh"
                  class="form-control add-input"
                  required
                />
              </div>

              <div class="form-group">
                <label class="form-label">*Email</label>
                <input
                  type="email"
                  v-model="employeeForm.email"
                  class="form-control add-input"
                  required
                />
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Họ Và Tên</label>
                  <input
                    type="text"
                    v-model="employeeForm.tenNhanVien"
                    class="form-control add-input"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Tỉnh/thành phố</label>
                  <input
                    type="text"
                    v-model="employeeForm.thanhPho"
                    class="form-control add-input"
                    placeholder="Nhập tên tỉnh/thành phố"
                    required
                  />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Quận/huyện</label>
                  <input
                    type="text"
                    v-model="employeeForm.quan"
                    class="form-control add-input"
                    placeholder="Nhập tên quận/huyện"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Xã/phường/thị trấn</label>
                  <input
                    type="text"
                    v-model="employeeForm.phuong"
                    class="form-control add-input"
                    placeholder="Nhập tên xã/phường/thị trấn"
                    required
                  />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Số Điện Thoại</label>
                  <input
                    type="tel"
                    v-model="employeeForm.soDienThoai"
                    class="form-control add-input"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Địa chỉ cụ thể</label>
                  <input
                    type="text"
                    v-model="employeeForm.diaChiCuThe"
                    class="form-control add-input"
                    required
                  />
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">*Tài khoản</label>
                <input
                  type="text"
                  v-model="employeeForm.tenTaiKhoan"
                  class="form-control bright-input"
                  required
                />
              </div>
              <div class="form-group">
                <label class="form-label">*Mật khẩu</label>
                <input
                  type="password"
                  v-model="employeeForm.matKhau"
                  class="form-control bright-input"
                  required
                />
              </div>
              <div class="form-group">
                <label class="form-label">*Quyền hạn</label>
                <select
                  v-model="employeeForm.idQuyenHan"
                  class="form-control add-input"
                  required
                >
                  <option value="">Chọn quyền hạn</option>
                  <option
                    v-for="value in quyenHans"
                    :key="value.id"
                    :value="value.id"
                  >
                    {{ value.tenQuyenHan }}
                  </option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer add-footer">
          <button
            type="button"
            class="btn-cancel"
            @click="showAddModal = false"
          >
            Hủy
          </button>
          <button
            type="submit"
            class="btn-submit"
            @click="saveEmployee"
          >
            Thêm Nhân Viên
          </button>
        </div>

      </div>
    </div>

    <!-- Edit Employee Modal -->
    <div
      v-if="showEditModal"
      class="modal-overlay"
      @click="showEditModal = false"
    >
      <div class="modal-content edit-modal" @click.stop>
        <div class="modal-header edit-header">
          <h3>Cập nhật thông tin nhân viên</h3>
          <button class="modal-close" @click="showEditModal = false">✕</button>
        </div>

        <div class="modal-body edit-body">
          <div class="form-sections">
            <div class="form-section">
              <h4 class="section-title">Thông tin chi tiết</h4>
              <div class="avatar-upload">
                <div class="avatar-preview">
                  <img v-if="avatarPreview" :src="avatarPreview" alt="Avatar" />
                  <div v-else class="placeholder-avatar large">
                    
                    <span>Chọn ảnh</span>
                  </div>
                </div>
                <input
                  type="file"
                  @change="handleAvatarUpload"
                  accept="image/*"
                  class="file-input"
                />
              </div>
            </div>

             <div class="form-section">
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Số CCCD</label>
                  <input
                    type="text"
                    v-model="employeeForm.cccd"
                    class="form-control edit-input"
                    required
                  />
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">*Ngày sinh</label>
                <input
                  type="date"
                  v-model="employeeForm.ngaySinh"
                  class="form-control edit-input"
                  required
                />
              </div>

              <div class="form-group">
                <label class="form-label">*Email</label>
                <input
                  type="email"
                  v-model="employeeForm.email"
                  class="form-control edit-input"
                  required
                />
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Họ Và Tên</label>
                  <input
                    type="text"
                    v-model="employeeForm.tenNhanVien"
                    class="form-control edit-input"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Tỉnh/thành phố</label>
                  <input
                    type="text"
                    v-model="employeeForm.thanhPho"
                    class="form-control edit-input"
                    placeholder="Nhập tên tỉnh/thành phố"
                    required
                  />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Quận/huyện</label>
                  <input
                    type="text"
                    v-model="employeeForm.quan"
                    class="form-control edit-input"
                    placeholder="Nhập tên quận/huyện"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Xã/phường/thị trấn</label>
                  <input
                    type="text"
                    v-model="employeeForm.phuong"
                    class="form-control edit-input"
                    placeholder="Nhập tên xã/phường/thị trấn"
                    required
                  />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">*Số Điện Thoại</label>
                  <input
                    type="tel"
                    v-model="employeeForm.soDienThoai"
                    class="form-control edit-input"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">*Địa chỉ cụ thể</label>
                  <input
                    type="text"
                    v-model="employeeForm.diaChiCuThe"
                    class="form-control edit-input"
                    required
                  />
                </div>
              </div> 

               <div class="form-group">
                <label class="form-label">*Tài khoản</label>
                <input
                  type="text"
                  v-model="employeeForm.tenTaiKhoan"
                  class="form-control"
                  required
                />
              </div> 
               <div class="form-group">
                <label class="form-label">*Mật khẩu</label>
                <input
                  type="password"
                  v-model="employeeForm.matKhau"
                  class="form-control"
                  required
                />
              </div> 
               <div class="form-group">
                <label class="form-label">*Quyền hạn</label>
                <select
                  v-model="employeeForm.idQuyenHan"
                  class="form-control edit-input"
                  required
                >
                  <option value="">Chọn quyền hạn</option>
                  <option
                    v-for="value in quyenHans"
                    :key="value.id"
                    :value="value.id"
                  >
                    {{ value.tenQuyenHan }}
                  </option>
                </select>
              </div> 

               <div class="form-group">
                <label class="form-label">*Trạng thái</label>
                <select v-model="employeeForm.trangThai" class="form-control edit-input">
                  <option :value="true">Hoạt động</option>
                  <option :value="false">Ngừng hoạt động</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer edit-footer">
          <button
            type="button"
            class="btn btn-secondary"
            @click="showEditModal = false"
          >
            Hủy
          </button>
          <button type="submit" class="btn btn-primary" @click="saveEmployee">
            Cập nhật nhân viên
          </button>
        </div>
      </div>
    </div>

    <!-- Employee Detail Modal -->
    <div
      v-if="showDetailModal"
      class="modal-overlay"
      @click="showDetailModal = false"
    >
      <div class="modal-content detail-modal" @click.stop>
        <div class="modal-header detail-header">
          <h3>Chi tiết nhân viên</h3>
          <button class="modal-close" @click="showDetailModal = false">
            ✕
          </button>
        </div>

        <div class="modal-body detail-body" v-if="selectedEmployee">
          <div class="employee-detail">
            <div class="employee-avatar-section">
              <div class="employee-avatar large">
                <img
                  v-if="selectedEmployee.anhNhanVien"
                  :src="'http://localhost:8080' + selectedEmployee.anhNhanVien"
                  alt="Ảnh nhân viên"
                />
                <div v-else class="placeholder-avatar large"><img :src="ProfileIcon" alt="User" class="icon-sm" /></div>
              </div>
              <h4 class="employee-name-title">{{ selectedEmployee.tenNhanVien }}</h4>
            </div>

            <div class="employee-info">
              <div class="info-grid">
                <div class="info-item">
                  <label>Mã nhân viên:</label>
                  <span class="info-value">{{ selectedEmployee.maNhanVien }}</span>
                </div>
                <div class="info-item">
                  <label>Email:</label>
                  <span class="info-value">{{ selectedEmployee.email }}</span>
                </div>
                <div class="info-item">
                  <label>Số điện thoại:</label>
                  <span class="info-value">{{ selectedEmployee.soDienThoai }}</span>
                </div>
                <div class="info-item">
                  <label>Ngày sinh:</label>
                  <span class="info-value">{{ selectedEmployee.ngaySinh }}</span>
                </div>
                <div class="info-item">
                  <label>Tỉnh/Thành phố:</label>
                  <span class="info-value">{{
                    selectedEmployee.thanhPho || "Chưa cập nhật"
                  }}</span>
                </div>
                <div class="info-item">
                  <label>Quận/Huyện:</label>
                  <span class="info-value">{{ selectedEmployee.quan || "Chưa cập nhật" }}</span>
                </div>
                <div class="info-item">
                  <label>Phường/Xã:</label>
                  <span class="info-value">{{ selectedEmployee.phuong || "Chưa cập nhật" }}</span>
                </div>
                <div class="info-item">
                  <label>Địa chỉ cụ thể:</label>
                  <span class="info-value">{{
                    selectedEmployee.diaChiCuThe || "Chưa cập nhật"
                  }}</span>
                </div>
                <div class="info-item">
                  <label>CCCD:</label>
                  <span class="info-value">{{ selectedEmployee.cccd }}</span>
                </div>
                <div class="info-item">
                  <label>Tài khoản:</label>
                  <span>{{ selectedEmployee.tenTaiKhoan }}</span>
                </div>
                <div class="info-item">
                  <label>Mật khẩu:</label>
                  <span>{{ selectedEmployee.matKhau }}</span>
                </div>
                <div class="info-item">
                  <label>Chức vụ:</label>
                  <span class="info-value">{{ selectedEmployee.tenQuyenHan }}</span>
                </div>
                <div class="info-item">
                  <label>Trạng thái:</label>
                  <span class="info-value status-badge" :class="{
                    'status-active': selectedEmployee.trangThai,
                    'status-inactive': !selectedEmployee.trangThai
                  }">{{
                    selectedEmployee.trangThai ? "Hoạt động" : "Ngừng hoạt động"
                  }}</span>
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
import { computed, onMounted, ref } from "vue";
import * as XLSX from "xlsx";
import {
    fetchAllNhanVien,
    fetchCreateNhanVien,
    fetchUpdateNhanVien,
} from "../../services/NhanVien/NhanVienService";
import { fetchAllQuyenHan } from "../../services/NhanVien/QuyenHanService";

// Data
const searchQuery = ref("");
const selectedRole = ref("");
const selectedStatus = ref("");
const showAddModal = ref(false);
const showDetailModal = ref(false);
const showEditModal = ref(false);
const avatarPreview = ref("");
const selectedEmployee = ref({});

// Pagination data
const currentPage = ref(1);
const itemsPerPage = ref(10);

// Dữ liệu form nhân viên
const employeeForm = ref({
  tenNhanVien: "",
  cccd: "",
  ngaySinh: "",
  email: "",
  soDienThoai: "",
  thanhPho: "",
  quan: "",
  phuong: "",
  diaChiCuThe: "",
  tenQuyenHan: "",
  idQuyenHan: "",
  trangThai: true,
  delete: false,
  tenTaiKhoan: "",
  matKhau: "",
});

// Mock data
const nhanViens = ref([]);
const quyenHans = ref([]);
const fetchAll = async () => {
  try {
    const res = await fetchAllNhanVien();
    nhanViens.value = res.data;
  } catch (res) {
  }
};
const fetchQuyenHan = async () => {
  try {
    const res = await fetchAllQuyenHan();
    quyenHans.value = res.data;
  } catch (res) {
  }
};
// Computed
const filteredEmployees = computed(() => {
  let filtered = nhanViens.value;

  if (searchQuery.value) {
    filtered = filtered.filter(
      (employee) =>
        employee.tenNhanVien
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        employee.email
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        employee.soDienThoai.includes(searchQuery.value)
    );
  }

  if (selectedRole.value) {
    filtered = filtered.filter(
      (employee) => employee.tenQuyenHan === selectedRole.value
    );
  }

  if (selectedStatus.value) {
    const isActive = selectedStatus.value === "active";
    filtered = filtered.filter((employee) => employee.trangThai === isActive);
  }

  return filtered.slice(startIndex.value, endIndex.value);
});

const totalEmployees = computed(() => {
  let filtered = nhanViens.value;

  if (searchQuery.value) {
    filtered = filtered.filter(
      (employee) =>
        employee.tenNhanVien
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        employee.email
          .toLowerCase()
          .includes(searchQuery.value.toLowerCase()) ||
        employee.soDienThoai.includes(searchQuery.value)
    );
  }

  if (selectedRole.value) {
    filtered = filtered.filter(
      (employee) => employee.tenQuyenHan === selectedRole.value
    );
  }

  if (selectedStatus.value) {
    const isActive = selectedStatus.value === "active";
    filtered = filtered.filter((employee) => employee.trangThai === isActive);
  }

  return filtered.length;
});

const totalPages = computed(() =>
  Math.ceil(totalEmployees.value / itemsPerPage.value)
);

const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value);
const endIndex = computed(() =>
  Math.min(startIndex.value + itemsPerPage.value, totalEmployees.value)
);

// Methods
const viewEmployee = (employee) => {
  selectedEmployee.value = { ...employee };
  showDetailModal.value = true;
};

const editEmployee = async (data) => {
  employeeForm.value = { ...data, file: null };

  if (data.anhNhanVien) {
    avatarPreview.value = "http://localhost:8080" + data.anhNhanVien;
  } else {
    avatarPreview.value = "";
  }

  showEditModal.value = true;
};

const handleAvatarUpload = (event) => {
  const file = event.target.files[0];
  if (file) {
    employeeForm.value.file = file; // lưu file vào form
    avatarPreview.value = URL.createObjectURL(file); // preview
  }
};

const saveEmployee = async () => {
  try {
    let newImageUrl = employeeForm.value.anhNhanVien; // mặc định giữ ảnh cũ

    // Nếu có file mới thì upload
    if (employeeForm.value.file) {
      const formData = new FormData();
      formData.append("file", employeeForm.value.file);

      const res = await fetch("http://localhost:8080/api/upload/avatar", {
        method: "POST",
        body: formData,
      });

      if (!res.ok) throw new Error("Upload ảnh thất bại");

      // Backend trả về đường dẫn, ví dụ: "/uploads/avatar123.jpg"
      const fileUrl = await res.text();
      newImageUrl = fileUrl;

      // cập nhật preview bằng link server thật
      avatarPreview.value = "http://localhost:8080" + fileUrl;
    }

    // Payload gửi đi
    const payload = {
      ...employeeForm.value,
      anhNhanVien: newImageUrl,
    };
    delete payload.file; // xoá file khỏi payload vì file đã upload riêng

    if (showAddModal.value) {
      await fetchCreateNhanVien(payload); // thêm mới
      currentPage.value = 1;
    } else if (showEditModal.value) {
      await fetchUpdateNhanVien(employeeForm.value.id, payload); // sửa
    }

    showAddModal.value = false;
    showEditModal.value = false;
    await fetchAll();
    resetForm();
  } catch (err) {
    console.error("Lỗi:", err.message);
    alert(err.message);
  }
};


const resetForm = (resetAvatar = true) => {
  employeeForm.value = {
    tenNhanVien: "",
    cccd: "",
    ngaySinh: "",
    email: "",
    soDienThoai: "",
    thanhPho: "",
    quan: "",
    phuong: "",
    diaChiCuThe: "",
    tenQuyenHan: "",
    idQuyenHan: "",
    trangThai: true,
    delete: false,
  };
  if (resetAvatar) {
    avatarPreview.value = "";
  }
};


const openAddModal = () => {
  resetForm();
  showAddModal.value = true;
};

const searchEmployees = () => {
  // Search is handled by computed property filteredEmployees
  // This function can be used for additional search functionality if needed
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

const exportData = () => {
  alert("Chức năng xuất báo cáo đang được phát triển");
};

const exportToExcel = () => {
  try {
    const ws = XLSX.utils.json_to_sheet(filteredEmployees.value);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Nhân viên");
    XLSX.writeFile(wb, "DanhSachNhanVien.xlsx");
    alert("✅ Xuất file Excel thành công!");
  } catch (error) {
    console.error("Error exporting to Excel:", error);
    alert("❌ Có lỗi xảy ra khi xuất file Excel");
  }
};


// Khởi tạo dữ liệu khi component được mount
onMounted(() => {
  fetchAll();
  fetchQuyenHan();
});

</script>


<style scoped>
/* Import external CSS file */
@import '../../styles/cssQuanLy/nhanVien.css';

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
