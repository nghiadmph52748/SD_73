# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Backend (Spring Boot - BE_SP/)
```bash
# Build and run backend
cd BE_SP
./mvnw spring-boot:run

# Build for production
./mvnw clean package

# Run tests
./mvnw test

# Run with specific profile
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### Frontend (Vue.js - DATN_GearUp_Ver2/)
```bash
# Install dependencies
cd DATN_GearUp_Ver2
npm install

# Development server (Vite)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run Express server (for API routes)
npm run server

# Run Express server with nodemon (development)
npm run dev:server
```

### Database
- Database: SQL Server (GearUp database)
- Default connection: localhost:1433
- Credentials in application.properties and .env files
- Schema script: SQLQuery1.sql

## Architecture Overview

### Project Structure
This is a full-stack e-commerce application for sporting goods (GearUp) with the following components:

**Backend (BE_SP/)**
- Spring Boot 3.5.4 with Java 17
- JPA/Hibernate for database access
- SQL Server database
- RESTful API architecture
- Generic CRUD service pattern with `GenericCrudService<E, ID, response, request>`
- ModelMapper for entity-DTO mapping
- Cloudinary integration for image uploads
- Spring Security for authentication
- Apache POI for Excel operations

**Frontend (DATN_GearUp_Ver2/)**
- Vue.js 3 with Composition API
- Vue Router for routing
- Vite for build tooling
- Express.js server for additional API routes
- Axios for HTTP requests
- Chart.js for analytics
- Direct SQL Server connection via mssql package

### Domain Model (Key Entities)
The application manages a sporting goods store with these core domains:

**Products**
- `san_pham` (Products) - Main product catalog
- `chi_tiet_san_pham` (Product Details) - Product variants with attributes
- `anh_san_pham` (Product Images) - Product image management
- Product attributes: `mau_sac` (Colors), `kich_thuoc` (Sizes), `chat_lieu` (Materials), `de_giay` (Sole Types), `trong_luong` (Weights)
- `nha_san_xuat` (Manufacturers), `xuat_xu` (Origins)

**Orders & Sales**
- `hoa_don` (Invoices/Orders) - Main order records
- `hoa_don_chi_tiet` (Order Details) - Order line items
- `thong_tin_don_hang` (Order Information) - Additional order data
- `trang_thai_don_hang` (Order Status) - Order state management
- Point of Sale (POS) system for in-store sales

**Users**
- `nhan_vien` (Employees) - Staff management
- `khach_hang` (Customers) - Customer management
- `dia_chi_khach_hang` (Customer Addresses)
- `quyen_han` (Permissions/Roles)

**Promotions**
- `phieu_giam_gia` (Discount Coupons)
- `phieu_giam_gia_ca_nhan` (Personal Vouchers)
- `dot_giam_gia` (Discount Campaigns)
- `chi_tiet_dot_giam_gia` (Campaign Details)

**Payments**
- `phuong_thuc_thanh_toan` (Payment Methods)
- `hinh_thuc_thanh_toan` (Payment Types)
- Multiple payment method support

### Key Architectural Patterns

**Backend Patterns:**
- Generic CRUD Service: `GenericCrudService<E, ID, response, request>` provides standardized CRUD operations
- Request/Response DTOs: Separate models for API contracts (`*Request`, `*Response`)
- Auto-generated codes: Database triggers generate codes like `SP00001`, `CTSP00001`
- Soft deletion: `deleted` field instead of hard deletes
- Audit fields: `create_at`, `create_by`, `update_at`, `update_by` on all entities
- Cross-Origin Resource Sharing (CORS) enabled for frontend communication

**Frontend Patterns:**
- Component-based architecture with `.vue` files
- Route-based code splitting
- Service layer for API communication
- Utility functions for common operations (Excel/CSV export)
- Composables for reusable logic (`useNotifications.js`)

### API Structure
- Backend APIs: `/api/*-management/*` (e.g., `/api/san-pham-management/`)
- Frontend Express APIs: `/api/*` (e.g., `/api/products`, `/api/auth`)
- CORS configured for multiple development ports (5173, 5174, 3000)

## Development Guidelines

### Code Style & Conventions
- Vietnamese variable names and comments (per Cursor rules)
- Basic CSS styling preferred over professional/complex designs
- Primary color: `#4ade80`, background: white
- No black backgrounds or gradients allowed
- No icon usage in responses to save tokens
- Create new CSS classes instead of overriding existing ones

### Database Conventions
- All tables use `id` as primary key with IDENTITY(1,1)
- Generated codes use computed columns with prefixes (SP, CTSP, CL, etc.)
- Status fields use `bit` type (`trang_thai`)
- Soft delete with `bit` type (`deleted`)
- Date fields use `date` type
- Vietnamese column names (`ten_san_pham`, `ma_san_pham`, etc.)

### API Development Rules
- Don't modify existing APIs without explicit request
- No SQL usage in frontend - use backend APIs
- Don't use SQL ở frontend (per Cursor rules)
- No unnecessary features - implement only what's requested
- Brief responses without lengthy summaries

### File Upload
- Images uploaded to Cloudinary
- Local file handling via `/uploads/**` endpoint
- File size limit: 10MB
- Supported formats configured in backend

### Testing Strategy
- Backend: Maven test runner with JUnit
- Frontend: Component testing capabilities with Vite
- Database: Test data available in SQL schema

### Development Workflow
1. Backend changes: Modify entities → services → controllers → test
2. Frontend changes: Update components → services → routing → styling
3. Database changes: Update schema → entity classes → repository methods
4. Full-stack features: Backend API → Frontend integration → testing

## Environment Configuration
- Backend config: `application.properties`
- Frontend config: `.env` files
- Database: SQL Server with `GearUp` database
- Development ports: Backend (8080), Frontend (5173), Express server (8080)
- CORS origins configured for local development