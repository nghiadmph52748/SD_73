<template>
  <!-- Toast thông báo -->
<div v-if="toast.show" class="toast" :class="toast.type">
  {{ toast.message }}
</div>

<div class="card mb-3 p-3">
<div class="d-flex gap-2 action-bar">
    <ActionButton
      icon="add"
      variant="success"
      size="md"
      label="Thêm Khách Hàng"
      :showLabel="true"
      tooltip="Thêm Khách Hàng mới"
      @click="showAddModal = true"
    />

    <ActionButton
      icon="download"
      variant="primary"
      size="md"
      label="Xuất"
      :showLabel="true"
      tooltip="Xuất Excel"
      @click="exportToExcel"
    />
  </div> 
</div>



    <div class="card">
    <div class="filter-group">
    <!-- Ô tìm kiếm -->
    <input
      type="text"
      placeholder="Tìm Kiếm Người Dùng..."
      v-model="searchQuery"
      class="form-control filter-input"
    />

    <!-- Dropdown giới tính -->
    <select v-model="selectedGender" class="form-control filter-input">
      <option value="">Giới tính: Tất cả</option>
      <option value="Nam">Nam</option>
      <option value="Nữ">Nữ</option>
    </select>

    <!-- Dropdown trạng thái -->
    <select v-model="selectedStatus" class="form-control filter-input">
      <option value="">Trạng thái: Tất cả</option>
      <option value="active">Hoạt động</option>
      <option value="inactive">Ngừng hoạt động</option>
    </select>
  </div>
          
      <div class="card-body">
        <table class="table">
          <thead>
            <tr>
              <th>#</th>
              <th>Mã</th>
              <th>Tên khách hàng</th>
              <th>Email</th>
              <th>Số điện thoại</th>
              <th>Giới tính</th>
              <th>Ngày sinh</th>
              <!-- <th>Địa chỉ</th> -->
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
              <td>{{ customer.maKhachHang }}</td>
              <td class="customer-name">{{ customer.tenKhachHang }}</td>
              <td>{{ customer.email }}</td>
              <td>{{ customer.soDienThoai }}</td>
              <td><span :class="[
                    'badge',
                    customer.gioiTinh === false
                       ? 'badge-success'
                       : 'badge-danger',
                  ]"
                  >
                {{ customer.gioiTinh ? "Nam" : "Nữ" }}
              </span></td>
              <td>{{ customer.ngaySinh }}</td>
              <!-- <td>
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
              </td> -->
              <td>
                <span
                  :class="[
                    'bade',
                    customer.deleted === false
                      ? 'bade-success'
                      : 'bade-danger',
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
                    variant="info"
                    size="sm"
                    tooltip="Chỉnh sửa thông tin"
                    class="action-button-warning"
                   @click="editCustomer(customer)"
                  />
                  <ActionButton
                    icon="delete"
                    variant="info"
                    size="sm"
                    tooltip="Xóa khách hàng"
                    class="action-button-danger"
                    @click="confirmDeleteCustomer(customer.id)"
                  />
                </ButtonGroup>
              </td>
            </tr>
          </tbody>
        </table>
     <!-- Modal xác nhận xoá -->
<div
  v-if="showDeleteConfirmModal"
  class="confirm-dialog-overlay"
  @click="showDeleteConfirmModal = false"
>
  <div class="confirm-dialog-box" @click.stop>
    <div class="confirm-dialog-header">
      <h3>Xác nhận xoá</h3>
    </div>
    <div class="confirm-dialog-body">
      <p>Bạn có chắc chắn muốn xoá khách hàng này không?</p>
    </div>
    <div class="confirm-dialog-footer">
      <button class="confirm-btn" @click="showDeleteConfirmModal = false">
        Hủy
      </button>
      <button class="confirm-btn confirm-btn-ok" @click="handleConfirmDelete">
        Xác nhận
      </button>
    </div>
  </div>
</div>

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
              Trước
            </button>
            <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
            <button
              class="btn btn-outline btn-sm"
              @click="nextPage"
              :disabled="currentPage === totalPages"
            >
              Tiếp
            </button>
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
                <div class="">
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
      <span class="btn-icon">➕</span>
      Thêm địa chỉ
    </button>
  </div>

  <div
    v-for="(address, index) in customerForm.listDiaChi"
    :key="address.id"
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
        <select
          v-model="address.thanhPho"
          @change="onProvinceChange(index)"
          class="form-control"
          required
        >
          <option value="">-- Chọn tỉnh/thành phố --</option>
          <option v-for="p in provinces" :key="p.code" :value="p.name">
            {{ p.name }}
          </option>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">*Quận/huyện</label>
        <select
          v-model="address.quan"
          @change="onDistrictChange(index)"
          class="form-control"
          required
        >
          <option value="">-- Chọn quận/huyện --</option>
          <option v-for="d in districts[index]" :key="d.code" :value="d.name">
            {{ d.name }}
          </option>
        </select>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label">*Xã/phường/thị trấn</label>
        <select v-model="address.phuong" class="form-control" required>
          <option value="">-- Chọn xã/phường/thị trấn --</option>
          <option v-for="w in wards[index]" :key="w.code" :value="w.name">
            {{ w.name }}
          </option>
        </select>
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
          class="btn"
          @click="showAddModal = false"
        >
          Hủy
        </button>
        <button type="submit" class="btn" @click="showConfirmModal = true" >
          Thêm khách hàng
        </button>
        <div v-if="showConfirmModal" class="confirm-dialog-overlay" @click="showConfirmModal = false">
          <div class="confirm-dialog-box" @click.stop>
            <div class="confirm-dialog-header">
              <h3>Xác nhận</h3>
            </div>
            <div class="confirm-dialog-body">
              <p>Bạn có muốn thêm khách hàng không?</p>
            </div>
            <div class="confirm-dialog-footer">
              <button class="confirm-btn" @click="showConfirmModal = false">Hủy</button>
              <button class="confirm-btn confirm-btn-ok" @click="handleConfirmAdd">Xác nhận</button>
            </div>
          </div>
        </div>
        
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
              <span class="btn-icon">➕</span>
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
    <select v-model="address.thanhPho" @change="onProvinceChange(index)" class="form-control" required>
      <option value="">-- Chọn tỉnh/thành phố --</option>
      <option v-for="p in provinces" :key="p.code" :value="p.name">
        {{ p.name }}
      </option>
    </select>
  </div>
  <div class="form-group">
    <label class="form-label">*Quận/huyện</label>
    <select v-model="address.quan" @change="onDistrictChange(index)" class="form-control" required>
      <option value="">-- Chọn quận/huyện --</option>
      <option 
        v-for="d in districts[index]" 
        :key="d.code" 
        :value="d.name">
        {{ d.name }}
      </option>
    </select>
  </div>
</div>

<div class="form-row">
  <div class="form-group">
    <label class="form-label">*Xã/phường/thị trấn</label>
    <select v-model="address.phuong" class="form-control" required>
      <option value="">-- Chọn xã/phường/thị trấn --</option>
      <option 
        v-for="w in wards[index]" 
        :key="w.code" 
        :value="w.name">
        {{ w.name }}
      </option>
    </select>
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
    class="btn"
    @click="showEditModal = false"
  >
    Hủy
  </button>
  <button
    type="submit"
    class="btn"
    @click="showEditConfirmModal = true"
  >
    Cập nhật khách hàng
  </button>
</div>
<!-- Modal xác nhận cập nhật -->
<div
  v-if="showEditConfirmModal"
  class="confirm-dialog-overlay"
  @click="showEditConfirmModal = false"
>
  <div class="confirm-dialog-box" @click.stop>
    <div class="confirm-dialog-header">
      <h3>Xác nhận</h3>
    </div>
    <div class="confirm-dialog-body">
      <p>Bạn có chắc muốn cập nhật khách hàng này không?</p>
    </div>
    <div class="confirm-dialog-footer">
      <button class="confirm-btn" @click="showEditConfirmModal = false">
        Hủy
      </button>
      <button class="confirm-btn confirm-btn-ok" @click="handleConfirmEdit">
        Xác nhận
      </button>
    </div>
  </div>
    </div>
</div>
  </div>
  
   
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import ActionButton from "@/components/ui/NutHanhDong.vue";
import ButtonGroup from "@/components/ui/NhomNut.vue";
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";


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
const provinces = ref([]);
const districts = ref([]);
const wards = ref([]);


const onProvinceChange = async (index) => {
  districts.value[index] = [];
  wards.value[index] = [];
  customerForm.value.listDiaChi[index].quan = "";
  customerForm.value.listDiaChi[index].phuong = "";

  const provinceName = customerForm.value.listDiaChi[index].thanhPho;
  const province = provinces.value.find(p => p.name === provinceName);

  if (province) {
    const res = await fetch(`https://provinces.open-api.vn/api/p/${province.code}?depth=2`);
    const data = await res.json();

    // Lưu luôn districts vào mảng districts
    districts.value[index] = data.districts || [];

    // ⚡ Cập nhật lại province để sau này tìm quận sẽ có danh sách đầy đủ
    province.districts = data.districts || [];
  }
};

const onDistrictChange = async (index) => {
  wards.value[index] = [];
  customerForm.value.listDiaChi[index].phuong = "";

  const provinceName = customerForm.value.listDiaChi[index].thanhPho;
  const districtName = customerForm.value.listDiaChi[index].quan;

  const province = provinces.value.find(p => p.name === provinceName);

  if (!province || !province.districts) return;

  const district = province.districts.find(d => d.name === districtName);

  if (!district) return;

  // Lấy xã/phường từ API
  const res = await fetch(`https://provinces.open-api.vn/api/d/${district.code}?depth=2`);
  const data = await res.json();

  // Gán danh sách xã/phường
  wards.value[index] = data.wards || [];
};

const showConfirmModal = ref(false);

const handleConfirmAdd = async () => {
  showConfirmModal.value = false;

  try {
    if (!validateCustomerForm()) return; // 🚨 validate trước khi gọi API

    const result = await saveCustomer();
    if (result) {
      showToast("Thêm khách hàng thành công!", "success");
      showAddModal.value = false;
    } else {
      showToast("Thêm khách hàng thất bại!", "error");
    }
  } catch (e) {
    showToast("Có lỗi xảy ra khi thêm khách hàng!", "error");
  }
};

function showToast(message, type = "success") {
  toast.value = { show: true, message, type };
  setTimeout(() => {
    toast.value.show = false;
  }, 7000); // 4 giây
}
const toast = ref({
  show: false,
  message: "",
  type: "success" // success | error
});
const validateCustomerForm = () => {
  if (!customerForm.value.tenKhachHang || customerForm.value.tenKhachHang.trim() === "") {
    showToast("Vui lòng nhập Họ tên!", "error");
    return false;
  }

  if (!customerForm.value.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(customerForm.value.email)) {
    showToast("Vui lòng nhập Email hợp lệ!", "error");
    return false;
  }

  if (!customerForm.value.soDienThoai || !/^[0-9]{9,11}$/.test(customerForm.value.soDienThoai)) {
    showToast("Vui lòng nhập Số điện thoại hợp lệ (9-11 số)!", "error");
    return false;
  }

  if (!customerForm.value.tenTaiKhoan || customerForm.value.tenTaiKhoan.trim() === "") {
    showToast("Vui lòng nhập Tên tài khoản!", "error");
    return false;
  }

  if (showAddModal.value && (!customerForm.value.matKhau || customerForm.value.matKhau.length < 6)) {
    showToast("Mật khẩu phải có ít nhất 6 ký tự!", "error");
    return false;
  }

  if (!customerForm.value.listDiaChi || customerForm.value.listDiaChi.length === 0) {
    showToast("Vui lòng nhập ít nhất một địa chỉ!", "error");
    return false;
  }

  for (let dc of customerForm.value.listDiaChi) {
    if (!dc.diaChiCuThe || !dc.thanhPho || !dc.quan || !dc.phuong) {
      showToast("Vui lòng nhập đầy đủ thông tin địa chỉ!", "error");
      return false;
    }
  }

  return true;
};


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
      id: Date.now(), // key duy nhất
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
  } catch (res) {
    console.log(res.message);
  }
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
  customerForm.value = {
    ...customer,
    // ✅ clone sâu (deep clone), tránh tham chiếu
    listDiaChi:
      customer.listDiaChi && customer.listDiaChi.length > 0
        ? customer.listDiaChi.map(dc => ({ ...dc }))
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
const showEditConfirmModal = ref(false);

const handleConfirmEdit = async () => {
  showEditConfirmModal.value = false;

  try {
    if (!validateCustomerForm()) return; // 🚨 validate trước

    const result = await saveCustomer();
    if (result) {
      showToast("Cập nhật khách hàng thành công!", "success");
      showEditModal.value = false;
    } else {
      showToast("Cập nhật khách hàng thất bại!", "error");
    }
  } catch (e) {
    showToast("Có lỗi xảy ra khi cập nhật khách hàng!", "error");
  }
};


const saveCustomer = async () => {
  try {
    // ✅ lọc bỏ địa chỉ rỗng
    customerForm.value.listDiaChi = customerForm.value.listDiaChi.filter(
      (dc) => dc.diaChiCuThe || dc.thanhPho || dc.quan || dc.phuong
    );

    if (showAddModal.value) {
      await fetchCreateKhachHang(customerForm.value);
      currentPage.value = 1;
      showToast("Thêm khách hàng thành công!", "success");
    } else if (showEditModal.value) {
      await fetchUpdateKhachHang(customerForm.value.id, customerForm.value);
      showToast("Cập nhật khách hàng thành công!", "success");
    }

    // ✅ luôn reset để không bị cộng dồn
    resetForm();
    showAddModal.value = false;
    showEditModal.value = false;
    await fetchAll();

    return true;
  } catch (err) {
    console.error("❌ saveCustomer error:", err.message);
    showToast("Có lỗi xảy ra khi lưu thông tin khách hàng!", "error");
    return false;
  }
};



const deleteCustomer = async (id) => {
  const confirmDelete = window.confirm("Bạn có chắc chắn muốn xoá khách hàng này không?");
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
const showDeleteConfirmModal = ref(false);
const customerToDelete = ref(null);

const confirmDeleteCustomer = (id) => {
  customerToDelete.value = id;
  showDeleteConfirmModal.value = true;
};

const handleConfirmDelete = async () => {
  showDeleteConfirmModal.value = false;

  try {
    await fetchUpdateStatusKhachHang(customerToDelete.value);
    customers.value = customers.value.filter(
      (c) => c.id !== customerToDelete.value
    );

    showToast("Xóa khách hàng thành công!", "success");
  } catch (error) {
    console.error("❌ Lỗi khi xóa khách hàng:", error.message);
    showToast("Có lỗi xảy ra khi xóa khách hàng!", "error");
  } finally {
    customerToDelete.value = null;
  }
};



// ➕ Thêm địa chỉ
const addAddress = () => {
  customerForm.value.listDiaChi.push({
    id: Date.now() + Math.random(), // đảm bảo luôn duy nhất
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

    const worksheet = XLSX.utils.json_to_sheet(filteredData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "KhachHang");

    const excelBuffer = XLSX.write(workbook, { bookType: "xlsx", type: "array" });
    const data = new Blob([excelBuffer], { type: "application/octet-stream" });
    saveAs(data, "DanhSachKhachHang.xlsx");

    showToast("Xuất file Excel thành công!", "success");
  } catch (error) {
    console.error("Error exporting to Excel:", error);
    showToast("Có lỗi xảy ra khi xuất file Excel!", "error");
  }
};


onMounted(async () => {
fetchAll();
const res = await fetch("https://provinces.open-api.vn/api/p/");
  provinces.value = await res.json();
});
</script>

<style scoped>
/* Giới tính */
.table th:nth-child(6),
.table td:nth-child(6) {
  text-align: center;
  vertical-align: middle;
}

/* Trạng thái */
.table th:nth-child(8),
.table td:nth-child(8) {
  text-align: center;
  vertical-align: middle;
}

/* Thao tác */
.table th:nth-child(9) {
  text-align: center;
  vertical-align: middle;
}
/* Căn giữa cả chiều ngang và dọc cho cột thao tác */
.table td:nth-child(9) {
  text-align: center;
  vertical-align: middle;
  display: flex;
  justify-content: center;
  align-items: center;
}


.customer-management {
  max-width: 1800px;
  margin: 0 auto;
}

/* page-header styles are now defined in globals.css */
.confirm-dialog-overlay {
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.3);
  z-index: 3000; /* cao hơn modal cha */
}

.confirm-dialog-box {
  background: #fff;
  border-radius: 8px;
  width: 360px;
  max-width: calc(100% - 40px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
  animation: fadeIn 0.18s ease-in-out;
  overflow: hidden;
}

.confirm-dialog-header {
  padding: 12px 16px;
  border-bottom: 1px solid #eee;
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.confirm-dialog-body {
  padding: 16px;
  font-size: 14px;
  color: #444;
}

.confirm-dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  padding: 12px 16px;
  border-top: 1px solid #f1f1f1;
}

.confirm-btn {
  padding: 6px 14px;
  font-size: 14px;
  border-radius: 6px;
  border: 1px solid #ccc;
  background: #fafafa;
  cursor: pointer;
  transition: background 0.2s;
}

.confirm-btn:hover {
  background: #eee;
}

.confirm-btn-ok {
  font-weight: 500;
}

@keyframes fadeIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
.toast {
  position: fixed;
  top: 20px;
  right: 20px;
  min-width: 250px;
  padding: 12px 16px;
  border-radius: 8px;
  color: #fff;
  font-weight: 500;
  box-shadow: 0 4px 6px rgba(0,0,0,0.2);
  z-index: 9999;
  animation: fadeInOut 4s forwards;
}

/* màu thành công */
.toast.success {
  background-color: #28a745;
}

/* màu lỗi */
.toast.error {
  background-color: #dc3545;
}

/* hiệu ứng hiện lên rồi biến mất */
@keyframes fadeInOut {
  0%   { opacity: 0; transform: translateY(-20px); }
  10%  { opacity: 1; transform: translateY(0); }
  90%  { opacity: 1; transform: translateY(0); }
  100% { opacity: 0; transform: translateY(-20px); }
}

/* Filter Section */
.filter-section {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  box-shadow: var(--shadow);
}

.search-controls {
  display: flex;
  gap: 1rem;
  align-items: center;
  flex-wrap: wrap;
}

.search-box {
  display: flex;
  gap: 0.5rem;
  flex: 1;
  min-width: 300px;
}
.filter-controls {
  display: flex;
  gap: 1rem;
  flex-wrap: nowrap;
}

.filter-controls select {
  min-width: 150px;
  padding: 12px 16px;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  font-size: 14px;
  background-color: #f8fff9;
  transition: all 0.3s ease;
  cursor: pointer;
  box-sizing: border-box;
}

.filter-controls select:focus {
  outline: none;
  border-color: #5ebe81;
  background-color: #ffffff;
  box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.1);
  transform: translateY(-1px);
}

.filter-controls select:hover {
  border-color: #d1d5db;
  background-color: #f9fafb;
}



/* Table Styles */
.table th {
  background-color: #ececec;
  color: rgb(18, 15, 15);
  font-weight: 600;
  padding: 1rem;
  text-align: center;
  font-size: 0.875rem;
  white-space: nowrap;
  position: sticky;
  top: 0;
  z-index: 10;
}

.table td {
  padding: 1rem;
  text-align: center;
  vertical-align: middle;
  border-bottom: 1px solid var(--border-color);
  font-size: 0.875rem;
}

.customer-name {
  font-weight: 500;
  text-align: left;
}

/* Pagination */
.pagination-wrapper {
  display: flex;
  justify-content: space-between; /* info bên trái, nút phân trang bên phải */
  align-items: center;
  margin-top: 3px;  /* cách bảng phía trên */
  padding: 8px 12px;
  font-size: 14px;
}

.pagination {
  display: flex;
  align-items: center;
  gap: 8px; /* tạo khoảng cách giữa nút và số trang */
  font-size: 14px;
  
}
.pagination .btn {
  border-radius: 6px;
  padding: 4px 10px;
}

.page-info {
  margin: 0 0.75rem;
  padding: 0.25rem 0.75rem;
  background-color: #e9f3ff; /* xanh nhạt */
  color: #0056b3;            /* xanh đậm */
  border-radius: 6px;
  font-weight: 600;
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
  display: flex;
  flex-direction: column;
  max-height: 90vh;        /* modal không vượt màn hình */
  width: 800px;            /* hoặc tùy bạn */
  background: #fff;
  border-radius: 8px;
  overflow: hidden;        /* tránh tràn */

}
/* .modal-content {
  width: 80vw;
  max-width: 900px;
  max-height: 85vh;
  overflow-y: auto;
  padding: 24px;
  font-size: 16px;
  box-sizing: border-box;
} */
.modal-header {
  flex-shrink: 0;
  position: sticky;
  top: 0;
  background: #fff;
  z-index: 10;
  padding: 1rem;
  border-bottom: 1px solid #ddd;
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
  flex: 1;
  overflow-y: auto;
  padding: 1rem;
}

/* Customer Detail */
.customer-detail {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.customer-info h4 {
  text-align: center;
  margin: 0 0 2rem 0;
  color: var(--secondary-color);
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.info-item label {
  font-weight: 500;
  color: var(--medium-gray);
  font-size: 0.875rem;
}

.info-item span {
  color: var(--secondary-color);
}

.total-orders {
  font-weight: 600;
  color: var(--info-color);
}

.total-spent {
  font-weight: 600;
  color: var(--success-color);
}

/* Modal Footer */
.modal-footer {
   flex-shrink: 0;
  position: sticky;
  bottom: 0;
  background: #fff;
  z-index: 10;
  padding: 0.75rem 1rem;
  border-top: 1px solid #ddd;
  display: flex;
  justify-content: flex-end;
  gap: 0.5rem;
}

/* Form Sections */
.form-sections {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.form-section h4 {
  margin: 0 0 1rem 0;
  color: var(--secondary-color);
  font-size: 1.125rem;
}

.form-row {
  flex: 1; /* Mỗi cột chiếm đều nhau */
  display: flex;
  flex-direction: column;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-label {
  font-weight: 500;
  color: var(--medium-gray);
  font-size: 0.875rem;
}

.form-control {
  width: 100%;
  padding: 12px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
}

.form-control:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
}

/* Address Components */
.address-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.btn-add-address {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background-color: #4ade80;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.875rem;
  transition: background-color 0.3s ease;
}

.address-item {
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 1rem;
  background-color: #f9fafb;
}

.address-item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.address-item-header h5 {
  margin: 0;
  color: var(--secondary-color);
  font-size: 1rem;
  font-weight: 600;
}

.btn-remove-address {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  background-color: #ef4444;
  color: white;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  font-size: 0.75rem;
  transition: background-color 0.3s ease;
}

.btn-remove-address:hover {
  background-color: #b27171;
}

.btn-remove-address .btn-icon {
  font-size: 0.875rem;
}

/* Address Detail Display */
.address-list-item {
  grid-column: 1 / -1;
}

.address-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.address-detail-item {
  padding: 0.75rem;
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.address-label {
  font-weight: 500;
  color: var(--medium-gray);
  font-size: 0.8rem;
}

.address-value {
  color: var(--secondary-color);
  font-size: 0.875rem;
}

.table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
  font-size: 14px;
}

.table th,
.table td {
  padding: 0.75rem;
  text-align: left;
  border: 1px solid #dee2e6;
  vertical-align: middle;
}

.table th {
  background-color: #f8f9fa;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 13px;
  color: #495057;
}

.table td {
  color: #212529;
}
.action-buttons-section .btn {
  padding: 8px 12px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary {
  background-color: #1f3e72;
  color: white;
}

.btn-secondary {
  background-color: #0f0d24;
  color: white;
}

.custom-button {
  background-color: #1e2d50;  /* Màu xanh đậm */
  color: #ffffff;
  border: 1px solid #1e2d50;
  border-radius: 6px;
  padding: 8px 16px;
  font-weight: 500;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease-in-out;
}

.custom-button i {
  font-size: 16px;
}
::v-deep label.form-label {
  color: #000000;
  font-weight: 600;
}
::v-deep input.form-control,
::v-deep select.form-control,
::v-deep textarea.form-control {
  color: #000000;
  font-weight: 500;
}
::v-deep input::placeholder,
::v-deep textarea::placeholder {
  color: #555555;
  opacity: 1;
}
/* Ví dụ style nút "Xem chi tiết" */

/* Nút xem chi tiết */
/* Nút Xem chi tiết */
.action-button-info {
  background-color: #ffffff; /* xanh đậm */
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}

/* Nút Chỉnh sửa */
.action-button-warning {
  background-color: #ffffff; /* xanh đậm */
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}


/* Nút Xóa */
.action-button-danger {
 background-color: #ffffff; /* xanh đậm */
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}

/* các nút kích thước bằng nhau */



.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  padding: 16px;
  background-color: #f9f9f9;
}

.info-box {
  background-color: #fff;
  padding: 12px 16px;
  border-radius: 8px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.08);
  font-size: 14px;
}

.info-box label {
  font-weight: bold;
  margin-bottom: 4px;
  color: #555;
}
.info-box span {
  color: #333;
  word-break: break-word;
}

.customer-name {
  text-align: center;
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 12px;
}

.address-label {
  font-weight: bold;
}

.address-value {
  display: block;
  margin-left: 8px;
}

.info-box strong {
  color: #444;
  font-weight: 600;
  margin-right: 4px;
}
.bade {
  display: inline-block;
  padding: 4px 8px;
  font-size: 12px;
  font-weight: 700;
  border-radius: 5px;
  color: #212529;
  background-color: #f8f9fa;
  
}
.bade-success {
  background-color: #aef5bf;
  color: #28a745 !important;
  border: none;
}

.bade-danger {
  background-color: #f17171;
  color: #9e1d1d;
  border: none;
}
.badge {
  display: inline-block;
  padding: 4px 8px;
  font-size: 12px;
  font-weight: 700;
  border-radius: 5px;
  color: #212529;
  background-color: #f8f9fa;
  
}


.badge-success {
  background-color: #aef5bf;
  color: #28a745 !important;
  border: none;
}

.badge-danger {
  background-color: #71b3f1;
  color: #1d699e;
  border: none;
}
.badge-active {
  background-color: #71b3f1;
  color: #1d699e;
  border: none;
}
.badge-inactive {
  border-color: #dc3545;
  color: #dc3545;
  border: none;
}
.breadcrumb {
  font-size: 24px;
  margin-bottom: 16px;
}
.breadcrumb ol {
  display: flex;
  list-style: none;
  padding: 0;
  margin: 0;
}
.breadcrumb li {
  margin-right: 8px;
}
.breadcrumb li::after {
  content: "›";
  margin-left: 8px;
}
.breadcrumb li:last-child::after {
  content: "";
}
.breadcrumb .active {
  font-weight: bold;
  color: #333;
}

.modal-content h3,
.modal-content h4 {
  font-weight: 700; /* Tiêu đề đậm hơn */
  color: #111;
}

.modal-content label {
  font-weight: 700; /* Các nhãn (label) đậm */
  color: #333;
  display: inline-block;
  width: 120px; /* Giữ khoảng cách đều */
}

.modal-content span {
  font-weight: 600; /* Nội dung đậm vừa phải */
  color: #444;
}

.address-label {
  font-weight: 700;
  color: #333;
}


.badge-success {
  font-weight: 700;
  padding: 4px 14px;
}
.filter-group {
  display: flex;
  gap: 16px;
}

.filter-input {
  width: auto;         /* không chiếm full */
  min-width: 150px;    /* độ rộng tối thiểu */
  max-width: 200px;    /* độ rộng tối đa */
  padding: 4px 8px;    /* padding gọn hơn */
  font-size: 14px;     /* chữ nhỏ gọn */
}

.toast-container {
  position: fixed;
  top: 20px;
  right: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px; /* khoảng cách giữa các toast */
  z-index: 9999;
}

.toast {
  background: #fff;
  border-left: 4px solid #e63946; /* viền trái màu đỏ */
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  padding: 10px 14px;
  width: 300px;
  animation: slideIn 0.3s ease-out;
}

.toast-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.toast-body {
  font-size: 14px;
  color: #555;
}

.toast button {
  background: none;
  border: none;
  font-size: 16px;
  cursor: pointer;
  color: #888;
}

@keyframes slideIn {
  from {
    transform: translateX(120%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}


.action-bar :deep(.action-button) { min-width: 180px; height: 42px; border-radius: 10px; }
.action-bar :deep(.action-button .label) { font-size: 14px; font-weight: 600; }
.action-bar { gap: 12px !important; }
</style>
