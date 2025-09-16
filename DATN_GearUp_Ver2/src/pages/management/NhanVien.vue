<template>
  
 <div class="page-container">
  <div class="card mb-3 p-3">
  
  <div class="d-flex gap-2">
    <ActionButton
      icon="add"
      variant="success"
      size="md"
      label="Thêm nhân viên"
      :showLabel="true"
      tooltip="Thêm nhân viên mới"
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
    <div class="card-header">
    <div class="filter-row">
      <input
      type="text"
      placeholder="Tìm Kiếm Người Dùng..."
      v-model="searchQuery"
      class="form-control filter-input"
    />
      <select class="form-control filter-input" v-model="selectedRole">
        <option value="">Chức vụ: Tất cả</option>
        <option
          v-for="value in quyenHans"
          :key="value.id"
          :value="value.tenQuyenHan"
        >
          {{ value.tenQuyenHan }}
        </option>
      </select>
      <select class="form-control filter-input" v-model="selectedStatus">
        <option value="">Trạng thái: Tất cả</option>
        <option value="active">Hoạt động</option>
        <option value="inactive">Ngừng hoạt động</option>
      </select>
      <select v-model="selectedGender" class="form-control filter-input">
        <option value="">Giới tính: Tất cả</option>
        <option :value="true">Nam</option>
        <option :value="false">Nữ</option>
      </select>
    </div>
  </div>
          
            
        <div class="card-body">
          <div class="table-responsive">
            <table class="table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Mã </th>
                  <th>Họ Tên</th>
                  <th>Email</th>
                  <th>SĐT</th>
                  <th>Ngày sinh</th>
                  <th>Giới Tính</th>
                  <th>CCCD</th>
                  <!-- <th>Địa chỉ</th>  -->
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
                  <td data-label="Mã nhân viên" class="employee-code">
                    {{ employee.maNhanVien }}
                  </td>
                  <td data-label="Tên nhân viên" class="employee-name">
                  <div class="employee-info">
                    <div class="employee-avatar">
                      <img
                        v-if="employee.anhNhanVien"
                        :src="'http://localhost:8080' + employee.anhNhanVien"
                        :alt="employee.tenNhanVien"
                      />
                      <div v-else class="placeholder-avatar">👤</div>
                    </div>
                    <span>{{ employee.tenNhanVien }}</span>
                  </div>
                </td> 
                  <td data-label="Email">{{ employee.email }}</td>
                  <td data-label="SĐT">{{ employee.soDienThoai }}</td>
                  <td data-label="Ngày sinh">{{ employee.ngaySinh }}</td>
                  <td data-label="Giới Tính" >
                    <span 
                    :class="[
                        'badge',
                        employee.gioiTinh === true
                          ? 'badge-danger'
                          : 'badge-success',
                      ]"
                      >
                      {{ employee.gioiTinh === true ? "Nam" : "Nữ" }}
                    </span>
                    
                  </td>

                  <td data-label="CCCD">{{ employee.cccd }}</td>
                  
                  <!-- <td data-label="Địa chỉ">
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
                        'bade',
                        employee.trangThai === true
                          ? 'bade-success'
                          : 'bade-danger',
                      ]"
                    >
                      {{ employee.trangThai ? "Hoạt động" : "Ngừng hoạt động" }}
                    </span>
                  </td>
                  <td data-label="Thao tác">
                  <ButtonGroup spacing="xs" class="action-buttons">
                    <ActionButton
                      icon="view"
                      variant="info"
                      size="sm"
                      tooltip="Xem chi tiết"
                      class="action-button-info"
                      @click="viewEmployee(employee)"
                    />
                    <ActionButton
                      icon="edit"
                      variant="info"
                      size="sm"
                      tooltip="Chỉnh sửa thông tin"
                      class="action-button-warning"
                      @click="editEmployee(employee)"
                    />
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
      </div>

      <!-- Thêm Nhân Viên -->
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
                <h4 class="">Thông tin chi tiết</h4>
                <div class="avatar-upload">
                  <div class="avatar-preview">
                    <img v-if="avatarPreview" :src="avatarPreview" alt="Avatar" />
                    <div v-else class="placeholder-avatar large">
                      📷
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
                  <label class="form-label">*Giới tính</label>
                  <select v-model="employeeForm.gioiTinh" class="form-control add-input" required>
                    <option :value="true">Nam</option>
                    <option :value="false">Nữ</option>
                  </select>
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
                  
                </div>

  <div class="form-row">
  <div class="form-group">
    <label class="form-label">*Tỉnh/thành phố</label>
    <select
      v-model="employeeForm.thanhPho"
      class="form-control add-input"
      @change="onProvinceChange"
      required
    >
      <option value="">Chọn tỉnh/thành phố</option>
      <option v-for="t in provinces" :key="t.code" :value="t.name">
        {{ t.name }}
      </option>
    </select>
  </div>

  <div class="form-group">
    <label class="form-label">*Quận/huyện</label>
    <select
      v-model="employeeForm.quan"
      class="form-control add-input"
      @change="onDistrictChange"
      required
    >
      <option value="">Chọn quận/huyện</option>
      <option v-for="q in districts" :key="q.code" :value="q.name">
        {{ q.name }}
      </option>
    </select>
  </div>
</div>

<div class="form-row">
  <div class="form-group">
    <label class="form-label">*Xã/phường/thị trấn</label>
    <select
      v-model="employeeForm.phuong"
      class="form-control add-input"
      required
    >
      <option value="">Chọn xã/phường/thị trấn</option>
      <option v-for="p in wards" :key="p.code" :value="p.name">
        {{ p.name }}
      </option>
    </select>
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
                @click="showConfirmAddEmployee = true"
              >
                Thêm Nhân Viên
              </button>
            </div>

            <!-- Modal xác nhận thêm nhân viên -->
            <div
              v-if="showConfirmAddEmployee"
              class="confirm-dialog-overlay"
              @click="showConfirmAddEmployee = false"
            >
              <div class="confirm-dialog-box" @click.stop>
                <div class="confirm-dialog-header">
                  <h3>Xác nhận</h3>
                </div>
                <div class="confirm-dialog-body">
                  <p>Bạn có muốn thêm nhân viên này không?</p>
                </div>
                <div class="confirm-dialog-footer">
                  <button class="confirm-btn" @click="showConfirmAddEmployee = false">
                    Hủy
                  </button>
                  <button class="confirm-btn confirm-btn-ok" @click="handleConfirmAddEmployee">
                    Xác nhận
                  </button>
                </div>
              </div>
            </div>

            <!-- Toast -->
            <div v-if="toast.show" :class="['toast', toast.type]">
              {{ toast.message }}
            </div>


        </div>
      </div>
      

      <!-- update nhân viên -->
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
                      📷
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
                  <label class="form-label">*Giới tính</label>
                  <select v-model="employeeForm.gioiTinh" class="form-control edit-input" required>
                    <option :value="true">Nam</option>
                    <option :value="false">Nữ</option>
                  </select>
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
                  
                
                </div>

       <div class="form-row">
  <!-- Tỉnh/Thành phố -->
  <div class="form-group">
    <label class="form-label">*Tỉnh/Thành phố</label>
    <select
      v-model="employeeForm.thanhPho"
      class="form-control edit-input"
      @change="onProvinceChange"
      required
    >
      <option value="">-- Chọn tỉnh/thành phố --</option>
      <option
        v-for="tp in provinces"
        :key="tp.code"
        :value="tp.name"
      >
        {{ tp.name }}
      </option>
    </select>
  </div>

  <!-- Quận/Huyện -->
  <div class="form-group">
    <label class="form-label">*Quận/Huyện</label>
    <select
      v-model="employeeForm.quan"
      class="form-control edit-input"
      @change="onDistrictChange"
      required
    >
      <option value="">-- Chọn quận/huyện --</option>
      <option
        v-for="q in districts"
        :key="q.code"
        :value="q.name"
      >
        {{ q.name }}
      </option>
    </select>
  </div>
</div>

<div class="form-row">
  <!-- Xã/Phường -->
  <div class="form-group">
    <label class="form-label">*Xã/Phường/Thị trấn</label>
    <select
      v-model="employeeForm.phuong"
      class="form-control edit-input"
      placeholder="Nhập số nhà, ngõ, đường..."
      required
    >
      <option value="">-- Chọn xã/phường --</option>
      <option
        v-for="p in wards"
        :key="p.code"
        :value="p.name"
      >
        {{ p.name }}
      </option>
    </select>
  </div>

  <!-- Địa chỉ cụ thể -->
  <div class="form-group">
    <label class="form-label">*Địa chỉ cụ thể</label>
    <input
      type="text"
      v-model="employeeForm.diaChiCuThe"
      class="form-control edit-input"
      placeholder="Nhập số nhà, ngõ, đường..."
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
              class="btn-cancel"
              @click="showEditModal = false"
            >
              Hủy
            </button>
            <button
              type="submit"
              class="btn-submit"
              @click="showConfirmEditEmployee = true"
            >
              Cập nhật nhân viên
            </button>
          </div>

          <!-- Modal xác nhận cập nhật -->
          <div
            v-if="showConfirmEditEmployee"
            class="confirm-dialog-overlay"
            @click="showConfirmEditEmployee = false"
          >
            <div class="confirm-dialog-box" @click.stop>
              <div class="confirm-dialog-header">
                <h3>Xác nhận</h3>
              </div>
              <div class="confirm-dialog-body">
                <p>Bạn có muốn cập nhật thông tin nhân viên này không?</p>
              </div>
              <div class="confirm-dialog-footer">
                <button class="confirm-btn" @click="showConfirmEditEmployee = false">
                  Hủy
                </button>
                <button class="confirm-btn confirm-btn-ok" @click="handleConfirmEditEmployee">
                  Xác nhận
                </button>
              </div>
            </div>
          </div>

          <!-- Inline message -->
          <p v-if="editMessage" class="inline-message">{{ editMessage }}</p>

        </div>
      </div>

      <!-- Employee Detail Modal -->
      <div
        v-if="showDetailModal"
        class="modal-overlay"
        @click="showDetailModal = false"
      >
        <div class="modal-content detail-modal" @click.stop>
          <div class="modal-header ">
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
                  <div v-else class="placeholder-avatar large">👤</div>
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
    </div>

</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import ActionButton from "@/components/ui/NutHanhDong.vue";
import ButtonGroup from "@/components/ui/NhomNut.vue";
import * as XLSX from "xlsx";
import {
  fetchAllNhanVien,
  fetchUpdateNhanVien,
  fetchCreateNhanVien,
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
const provinces = ref([]);
const districts = ref([]);
const wards = ref([]);
const selectedGender = ref(""); // mặc định tất cả
// abc
const showConfirmAddEmployee = ref(false);

const handleConfirmAddEmployee = async () => {
  showConfirmAddEmployee.value = false;

  try {
    const result = await saveEmployee(); // gọi API thêm nhân viên

    if (result) {
      showToast("Thêm nhân viên thành công!", "success");
      showAddModal.value = false; // đóng form
    } else {
      showToast("Thêm nhân viên thất bại!", "error");
    }
  } catch (e) {
    showToast("Có lỗi xảy ra khi thêm nhân viên!", "error");
  }
};
function showToast(message, type = "success") {
  toast.value = { show: true, message, type };
  setTimeout(() => {
    toast.value.show = false;
  }, 4000); // 4 giây
}

const toast = ref({
  show: false,
  message: "",
  type: "success" // success | error
});
//abcd
const showConfirmEditEmployee = ref(false);
const editMessage = ref("");

const handleConfirmEditEmployee = async () => {
  showConfirmEditEmployee.value = false;

  try {
    const result = await saveEmployee(); // hàm cập nhật

    if (result) {
      editMessage.value = "✅ Cập nhật nhân viên thành công!";
      showEditModal.value = false; // đóng modal sau khi xong
    } else {
      editMessage.value = "";
    }
  } catch (e) {
    editMessage.value = "⚠️ Có lỗi xảy ra khi cập nhật nhân viên!";
  }
};

// Pagination data
const currentPage = ref(1);
const itemsPerPage = ref(10);

const onProvinceChange = async () => {
  districts.value = [];
  wards.value = [];
  employeeForm.value.quan = "";
  employeeForm.value.phuong = "";

  const province = provinces.value.find(
    (p) => p.name === employeeForm.value.thanhPho
  );
  if (province) {
    const res = await fetch(`https://provinces.open-api.vn/api/p/${province.code}?depth=2`);
    const data = await res.json();
    districts.value = data.districts;
  }
};

// Khi chọn quận -> load xã
const onDistrictChange = async () => {
  wards.value = [];
  employeeForm.value.phuong = "";

  const district = districts.value.find(
    (d) => d.name === employeeForm.value.quan
  );
  if (district) {
    const res = await fetch(`https://provinces.open-api.vn/api/d/${district.code}?depth=2`);
    const data = await res.json();
    wards.value = data.wards;
  }
};
// Dữ liệu form nhân viên
const employeeForm = ref({
  tenNhanVien: "",
  cccd: "",
  ngaySinh: "",
  gioiTinh: true,
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
    console.log(res.message);
  }
};
const fetchQuyenHan = async () => {
  try {
    const res = await fetchAllQuyenHan();
    quyenHans.value = res.data;
  } catch (res) {
    console.log(res.message);
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
 if (selectedGender.value !== "") {
  filtered = filtered.filter(
    (employee) => employee.gioiTinh === selectedGender.value
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
onMounted(async () => {
  fetchAll();
  fetchQuyenHan();
    // Load danh sách tỉnh/thành phố
  const res = await fetch("https://provinces.open-api.vn/api/p/");
  provinces.value = await res.json();
});
defineProps({
  parent: {
    type: Object,
    default: null, // { label: "Nhân viên", link: "/nhan-vien" }
  },
  current: {
    type: String,
    required: true, // "Thêm nhân viên"
  },
  
});

</script>


<style scoped>

.form-control {
  width: 100%;
  padding: 12px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
}

.filter-input {
  width: auto;         /* không chiếm full */
  min-width: 150px;    /* độ rộng tối thiểu */
  max-width: 200px;    /* độ rộng tối đa */
  padding: 4px 8px;    /* padding gọn hơn */
  font-size: 14px;     /* chữ nhỏ gọn */
}


.filter-row {
  display: flex;
  gap: 16px;      
  flex-wrap: wrap;  
  align-items: center;
  margin-bottom: 1px;
}

.filter-row .search-input {
  min-width: 220px;  
  max-width: 300px;
  padding: 6px 10px;
  font-size: 14px;
}

.filter-row .form-select {
  min-width: 150px;  
  max-width: 200px;
  padding: 12px 10px;
  font-size: 14px;
}



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
.page-container {
  max-width: 1800px; /* hoặc 1000px nếu bạn muốn hẹp hơn */
  margin: 0 auto;
  
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
  background-color: #2ccf83; 
  color: #ffffff;
  border: 1px solid #66c079;
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
.custom-button1 {
  background-color: #dbdbdb; 
  color: #000000;
  border: 1px solid #dbdbdb;
  border-radius: 3px;
  padding: 8px 16px;
  font-weight: 500;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease-in-out;
}

/* .custom-button:hover {
  background-color: #24365e;  
  border-color: #24365e;
} */

.custom-button i {
  font-size: 16px;
}

.employee-management {
  max-width: 1400px;
  margin: 0 auto;
}
.bright-input {
  background-color: #ffffff;      /* nền trắng */
  border: 2px solid #dce1e6;      /* viền xanh sáng */
  color: #000000;                 /* chữ đen */
  font-weight: 500;
  transition: 0.3s ease;
}

.bright-input:focus {
  outline: none;
  border-color: #eef1f3;         /* viền khi focus */
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
}
/* page-header styles are now defined in globals.css */

/* Filter Section */
.filter-section {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  box-shadow: var(--shadow);
  padding: 16px;
}


.avatar {
  border-radius: 50%;
  width: 40px;
  height: 40px;
  object-fit: cover;
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
  font-weight: 700;
  padding: 4px 14px;
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
   background-color: #aef5bf;
  color: #10822e;
  border: none;
}
.badge-inactive {
  background-color: #71b3f1;
  color: #1d699e;
  border: none;
}

.table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
  font-size: 14px;
  
}

.table th,
.table td {
  padding: 12px 16px;
  text-align: left;
  border: 1px solid #dee2e6;
  vertical-align: middle;
  
}

.table th {
  background-color: #f8f9fa;
  font-weight: 700;
  text-transform: uppercase;
  font-size: 13px;
  color: #495057;
}

.table td {
  color: #212529;
}

/* Căn trái riêng cho cột tên nhân viên */
/* Cột ảnh căn giữa (để avatar không lệch) */
/* Cột ảnh */
/* Cột ảnh */
.table th:nth-child(2),
.table td:nth-child(2) {
  width: 60px;
  text-align: center;
}
/* Container ảnh luôn là hình vuông, căn giữa */
.employee-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f0f0f0;
}
.employee-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.placeholder-avatar {
  font-size: 18px;
  color: #888;
}


/* Cột email căn trái cho dễ đọc */
.table th:nth-child(4),
.table td:nth-child(4) {
  text-align: left;
  padding-left: 8px;
}

.table th:nth-child(6),
.table td:nth-child(6) {
  text-align: left;
  padding-left: 8px;
}



.table th:nth-child(8),
.table td:nth-child(8) {
  text-align: center;
  padding-left: 8px;
}

.table th:nth-child(9),
.table td:nth-child(9) {
  text-align: center;
  padding-left: 8px;
}


.employee-avatar {
 width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f0f0f0;
}

.employee-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.placeholder-avatar {
  font-size: 18px;
  color: #888;
}

.placeholder-avatar {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--light-gray);
  font-size: 1.5rem;
  flex-direction: column;
}

.placeholder-avatar.large {
  font-size: 2rem;
}

.placeholder-avatar span {
  font-size: 0.75rem;
  margin-top: 0.25rem;
}


.employee-name {
  font-weight: 500;
  text-align: left;
}
.action-button-info {
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}


/* Nút Chỉnh sửa */
.action-button-warning {
  color: #0a0909;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s ease;
}



/* Compact action buttons */
/* Giả sử phần chứa 2 nút có class .action-buttons hoặc tương tự */
.action-buttons {
    display: flex;
  justify-content: center; /* Căn giữa theo chiều ngang */
  align-items: center;     /* Căn giữa theo chiều dọc nếu cần */
  gap: 0.25rem;            /* Khoảng cách giữa 2 nút */
}

.btn-icon {
  font-size: 0.875rem !important;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}

/* Pagination */
.pagination-wrapper {
  display: flex;
  justify-content: space-between; /* info bên trái, nút phân trang bên phải */
  align-items: center;
  margin-top: 3px;  /* cách bảng phía trên */
  padding: 8px 12px;
}

.pagination {
  display: flex;
  align-items: center;
  gap: 8px; /* tạo khoảng cách giữa nút và số trang */
}
.pagination .btn {
  border-radius: 6px;
  padding: 4px 10px;
  font-size: 14px;
}

.page-info {
  font-weight: 600;
  color: var(--secondary-color);
}
.btn-cancel {

  padding: 0.6rem 1.2rem;
  font-weight: 500;

}



.btn-submit {
  background: linear-gradient(135deg, #979797 0%, #979797 100%);
  color: white;
  border: none;
  padding: 0.6rem 1.2rem;
  border-radius: 6px;
  font-weight: 500;
  transition: all 0.3s ease;
  cursor: pointer;
}


/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5);
  overflow-x: hidden; /* Ẩn scroll ngang toàn bộ */
  overflow-y: auto;   /* Cho phép scroll dọc nếu modal cao quá */
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  box-sizing: border-box;
}


.modal-content {
 background-color: #fff;
  border-radius: 8px;
  max-width: 700px; /* Giới hạn chiều ngang modal */
  width: 100%;
  max-height: 80vh; /* Giới hạn chiều cao modal */
  display: flex;
  flex-direction: column;
  overflow: hidden; /* Ẩn tất cả cuộn bên ngoài modal */
  box-sizing: border-box;
}
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px 30px;
  word-break: break-word; /* Ngắt dòng nếu quá dài */
  overflow-wrap: break-word;
}


.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 2px solid rgba(74, 222, 128, 0.2);
  background: linear-gradient(135deg, #b6b6b6 0%, #b6b6b6 100%);
  border-radius: 16px 16px 0 0;
  margin: -2px -2px 0 -2px;
}

.modal-header h3 {
  margin: 0;
  color: white;
  font-size: 1.25rem;
  font-weight: 600;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.modal-close {
  background: rgba(255, 255, 255, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.3);
  font-size: 1.25rem;
  cursor: pointer;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s ease;
  color: white;
}


.modal-body {
  padding: 1.5rem;
  max-height: 60vh;    /* Giới hạn chiều cao để bật scroll */
  overflow-y: auto;    /* Bật scroll dọc khi nội dung vượt quá */
  box-sizing: border-box;
}

.modal-footer {
  display: flex;
  justify-content: center;
  gap: 1rem;
  padding: 1.5rem;
}

/* Form Sections */
.form-sections {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}
td[data-label="Trạng thái"] {
  text-align: center;
  vertical-align: middle;
}


.form-section h4 {
  margin: 0 0 1rem 0;
  color: var(--secondary-color);
  font-size: 1.125rem;
}

.avatar-upload {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.avatar-preview {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid var(--border-color);
  cursor: pointer;
}

.avatar-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.file-input {
  max-width: 200px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}


/* Employee Detail */
.employee-detail {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem;
}

.employee-avatar-section {
   display: flex;
  flex-direction: column;
  align-items: center;
}

.employee-name-title {
   margin-top: 1rem;
  font-size: 1.75rem;
  font-weight: bold;
  text-align: center;
}

.employee-info {
 display: flex;
  align-items: center;
  gap: 8px;
  
}

/* Detail Modal Specific Styles */
.detail-modal {
   max-width: 55vw; 
  width: 55vw ;
}

.detail-header {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
}

.detail-body {
  padding: 2rem;
  max-height: 80vh;   /* tránh tràn màn hình */
  overflow-y: auto;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
}
th:nth-child(11), /* cột Trạng Thái */
td:nth-child(11),
th:nth-child(12), /* cột Thao Tác */
td:nth-child(13) {
  text-align: center;
  vertical-align: middle;
}


.info-item {
  background: #fff;
  padding: 1rem;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}

.info-item label {
   font-weight: 600;
  color: #6b7280;
  font-size: 0.875rem;
  margin-bottom: 0.25rem;
}

.info-value {
  font-size: 1rem;
  font-weight: 500;
  color: #111827;
}

.status-badge {
  padding: 6px 12px;
  border-radius: 999px;
  font-size: 0.875rem;
  font-weight: 600;
}

.status-active {
    background: #258848;
    color: white;
}

.status-inactive {
  background: #fee2e2;
  color: #991b1b;
}
.employee-avatar.large {
  width: 140px;
  height: 140px;
  border-radius: 50%;
  border: 1px solid ;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #000000;
  font-size: 0.875rem;
}




</style>  
