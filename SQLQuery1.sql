USE [master]
GO
/****** Object:  Database [GearUp]    Script Date: 9/19/2025 12:55:50 PM ******/
CREATE DATABASE [GearUp]
GO
ALTER DATABASE [GearUp] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GearUp].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [GearUp] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GearUp] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GearUp] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GearUp] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GearUp] SET ARITHABORT OFF 
GO
ALTER DATABASE [GearUp] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [GearUp] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [GearUp] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GearUp] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GearUp] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GearUp] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GearUp] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GearUp] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GearUp] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GearUp] SET  ENABLE_BROKER 
GO
ALTER DATABASE [GearUp] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GearUp] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GearUp] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GearUp] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GearUp] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GearUp] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [GearUp] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [GearUp] SET RECOVERY FULL 
GO
ALTER DATABASE [GearUp] SET  MULTI_USER 
GO
ALTER DATABASE [GearUp] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [GearUp] SET DB_CHAINING OFF 
GO
ALTER DATABASE [GearUp] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [GearUp] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [GearUp] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [GearUp] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'GearUp', N'ON'
GO
ALTER DATABASE [GearUp] SET QUERY_STORE = ON
GO
ALTER DATABASE [GearUp] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [GearUp]
GO
/****** Object:  Table [dbo].[anh_san_pham]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[anh_san_pham](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[duong_dan_anh] [varchar](255) NOT NULL,
	[loai_anh] [varchar](10) NULL,
	[mo_ta] [nvarchar](255) NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chat_lieu]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chat_lieu](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_chat_lieu]  AS ('CL'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_chat_lieu] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chi_tiet_dot_giam_gia]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chi_tiet_dot_giam_gia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_dot_giam_gia] [int] NOT NULL,
	[id_chi_tiet_san_pham] [int] NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chi_tiet_san_pham]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chi_tiet_san_pham](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_san_pham] [int] NOT NULL,
	[id_mau_sac] [int] NOT NULL,
	[id_kich_thuoc] [int] NOT NULL,
	[id_de_giay] [int] NOT NULL,
	[id_chat_lieu] [int] NOT NULL,
	[id_trong_luong] [int] NOT NULL,
	[ma_chi_tiet_san_pham]  AS ('CTSP'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[so_luong] [int] NULL,
	[gia_ban] [decimal](18, 2) NULL,
	[trang_thai] [bit] NULL,
	[ghi_chu] [nvarchar](255) NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chi_tiet_san_pham_anh]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chi_tiet_san_pham_anh](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_chi_tiet_san_pham] [int] NOT NULL,
	[id_anh_san_pham] [int] NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[de_giay]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[de_giay](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_de_giay]  AS ('DG'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_de_giay] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dia_chi_khach_hang]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dia_chi_khach_hang](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_khach_hang] [int] NOT NULL,
	[ma_dia_chi]  AS ('DC'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_dia_chi] [nvarchar](255) NULL,
	[thanh_pho] [nvarchar](255) NULL,
	[quan] [nvarchar](255) NULL,
	[phuong] [varchar](255) NULL,
	[dia_chi_cu_the] [varchar](255) NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dot_giam_gia]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dot_giam_gia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_dot_giam_gia]  AS ('DGG'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_dot_giam_gia] [nvarchar](255) NOT NULL,
	[gia_tri_giam_gia] [int] NULL,
	[ngay_bat_dau] [date] NULL,
	[ngay_ket_thuc] [date] NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hinh_thuc_thanh_toan]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hinh_thuc_thanh_toan](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_hoa_don] [int] NOT NULL,
	[id_phuong_thuc_thanh_toan] [int] NOT NULL,
	[ma_hinh_thuc_thanh_toan]  AS ('HTTT'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[tien_chuyen_khoan] [decimal](18, 2) NULL,
	[tien_mat] [decimal](18, 2) NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hoa_don]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hoa_don](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_khach_hang] [int] NOT NULL,
	[id_phieu_giam_gia] [int] NULL,
	[id_nhan_vien] [int] NULL,
	[ma_hoa_don]  AS ('HD'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_hoa_don] [nvarchar](255) NULL,
	[loai_don] [bit] NULL,
	[phi_van_chuyen] [decimal](18, 2) NULL,
	[tong_tien] [decimal](18, 2) NULL,
	[tong_tien_sau_giam] [decimal](18, 2) NULL,
	[ghi_chu] [nvarchar](255) NULL,
	[ten_khach_hang] [nvarchar](255) NULL,
	[dia_chi_khach_hang] [nvarchar](255) NULL,
	[so_dien_thoai_khach_hang] [varchar](12) NULL,
	[email_khach_hang] [varchar](255) NULL,
	[ngay_tao] [date] NULL,
	[ngay_thanh_toan] [date] NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hoa_don_chi_tiet]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hoa_don_chi_tiet](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_hoa_don] [int] NOT NULL,
	[id_chi_tiet_san_pham] [int] NOT NULL,
	[ma_hoa_don_chi_tiet]  AS ('HDCT'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[so_luong] [int] NULL,
	[gia_ban] [decimal](18, 2) NULL,
	[thanh_tien] [decimal](18, 2) NULL,
	[trang_thai] [bit] NULL,
	[ghi_chu] [nvarchar](255) NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[khach_hang]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[khach_hang](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_khach_hang]  AS ('KH'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_khach_hang] [nvarchar](255) NULL,
	[ten_tai_khoan] [varchar](255) NULL,
	[mat_khau] [varchar](255) NULL,
	[email] [varchar](255) NULL,
	[so_dien_thoai] [varchar](12) NULL,
	[gioi_tinh] [bit] NULL,
	[ngay_sinh] [date] NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[kich_thuoc]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kich_thuoc](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_kich_thuoc]  AS ('KT'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_kich_thuoc] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mau_sac]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mau_sac](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_mau_sac]  AS ('MS'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_mau_sac] [nvarchar](255) NOT NULL,
	[ma_mau] [nvarchar](8) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[nha_san_xuat]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nha_san_xuat](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_nha_san_xuat]  AS ('NSX'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_nha_san_xuat] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[nhan_vien]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nhan_vien](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_quyen_han] [int] NOT NULL,
	[ma_nhan_vien]  AS ('NV'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_nhan_vien] [nvarchar](255) NULL,
	[ten_tai_khoan] [varchar](255) NULL,
	[mat_khau] [varchar](255) NULL,
	[email] [varchar](255) NULL,
	[so_dien_thoai] [varchar](12) NULL,
	[anh_nhan_vien] [varchar](255) NULL,
	[ngay_sinh] [date] NULL,
	[ghi_chu] [nvarchar](255) NULL,
	[thanh_pho] [nvarchar](255) NULL,
	[quan] [nvarchar](255) NULL,
	[phuong] [varchar](255) NULL,
	[dia_chi_cu_the] [varchar](255) NULL,
	[gioi_tinh] [bit] NULL,
	[cccd] [varchar](20) NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phieu_giam_gia]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phieu_giam_gia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_phieu_giam_gia]  AS ('PGG'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_phieu_giam_gia] [nvarchar](255) NULL,
	[loai_phieu_giam_gia] [bit] NULL,
	[gia_tri_giam_gia] [decimal](18, 2) NULL,
	[so_tien_toi_da] [decimal](18, 2) NULL,
	[hoa_don_toi_thieu] [decimal](18, 2) NULL,
	[so_luong_dung] [int] NULL,
	[ngay_bat_dau] [date] NULL,
	[ngay_ket_thuc] [date] NULL,
	[trang_thai] [bit] NULL,
	[mo_ta] [nvarchar](255) NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phieu_giam_gia_ca_nhan]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phieu_giam_gia_ca_nhan](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_khach_hang] [int] NOT NULL,
	[id_phieu_giam_gia] [int] NOT NULL,
	[ma_phieu_giam_gia_ca_nhan]  AS ('PGGCN'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_phieu_giam_gia_ca_nhan] [nvarchar](255) NULL,
	[ngay_nhan] [date] NULL,
	[ngay_het_han] [date] NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phuong_thuc_thanh_toan]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phuong_thuc_thanh_toan](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_phuong_thuc_thanh_toan]  AS ('PTTT'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_phuong_thuc_thanh_toan] [nvarchar](255) NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[quyen_han]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[quyen_han](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_quyen_han]  AS ('QH'+right('0'+CONVERT([varchar](1),[ID]),(1))) PERSISTED,
	[ten_quyen_han] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[san_pham]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[san_pham](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_nha_san_xuat] [int] NOT NULL,
	[id_xuat_xu] [int] NOT NULL,
	[ma_san_pham]  AS ('SP'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_san_pham] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[thong_tin_don_hang]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[thong_tin_don_hang](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_hoa_don] [int] NOT NULL,
	[id_trang_thai_don_hang] [int] NOT NULL,
	[ma_thong_tin_don_hang]  AS ('TTDH'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[thoi_gian] [datetime] NULL,
	[ghi_chu] [nvarchar](255) NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trang_thai_don_hang]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trang_thai_don_hang](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_trang_thai_don_hang]  AS ('TTDH'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_trang_thai_don_hang] [nvarchar](255) NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trong_luong]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trong_luong](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_trong_luong]  AS ('TL'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_trong_luong] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[xuat_xu]    Script Date: 9/19/2025 12:55:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xuat_xu](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ma_xuat_xu]  AS ('XX'+right('00000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[ten_xuat_xu] [nvarchar](255) NOT NULL,
	[trang_thai] [bit] NULL,
	[deleted] [bit] NULL,
	[create_at] [date] NULL,
	[create_by] [int] NULL,
	[update_at] [date] NULL,
	[update_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[anh_san_pham] ON 
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (41, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757491893/SD_73/70df4c42c14bee3c2477ff3e8d942c02.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (42, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757489765/SD_73/a6c303b6dd0fb8984b72bafbe8852957.jpg', N'jpg', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (43, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757497409/SD_73/52ef6df9ef814943965b746d925071e2.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (44, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757489766/SD_73/cc60515343d8da097ac15eec7948d888.jpg', N'jpeg', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (45, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757492870/SD_73/677ecd7fbf5c9e169d12a47faf6777b6.jpg', N'jpg', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (46, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757498386/SD_73/1c249ce2a34078ef9d25a58c3269baa1.jpg', N'jpg', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (47, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757489767/SD_73/241ffa293619f76204a6aa9b13f7a765.webp', N'webp', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (48, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757498164/SD_73/eb00a459b615e7dd303eb9c878e6949b.jpg', N'jpeg', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (49, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757504943/SD_73/f99917b2a294489b9956276939b8fa29.webp', N'webp', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (50, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757504945/SD_73/5e9303ca1fb3c72504e64bdb28c52e04.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (51, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757505088/SD_73/1238c6436827992c105070878cf858f6.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (52, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757505089/SD_73/d9033257af7a55d4e6a805237ca69486.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (53, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757505509/SD_73/f56bf4bf595b613d10ff78976740cc4c.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (54, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757505515/SD_73/f0332c26825803145cd0edc5a630e4aa.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (55, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757505517/SD_73/17c63e1d70d577e24fa46d23a6790639.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
INSERT [dbo].[anh_san_pham] ([id], [duong_dan_anh], [loai_anh], [mo_ta], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (56, N'https://res.cloudinary.com/dlgbdwd96/image/upload/v1757505900/SD_73/98b9f6368a0a242ed22f1b000cf6040e.png', N'png', NULL, 1, 0, CAST(N'2025-09-10' AS Date), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[anh_san_pham] OFF
GO
SET IDENTITY_INSERT [dbo].[chat_lieu] ON 
GO
INSERT [dbo].[chat_lieu] ([id], [ten_chat_lieu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Da tổng hợp', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chat_lieu] ([id], [ten_chat_lieu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Vải canvas', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chat_lieu] ([id], [ten_chat_lieu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Vải mesh', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chat_lieu] ([id], [ten_chat_lieu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'Da thật', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chat_lieu] ([id], [ten_chat_lieu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'Vải knit', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[chat_lieu] OFF
GO
SET IDENTITY_INSERT [dbo].[chi_tiet_dot_giam_gia] ON 
GO
INSERT [dbo].[chi_tiet_dot_giam_gia] ([id], [id_dot_giam_gia], [id_chi_tiet_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, 1, 1, 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_dot_giam_gia] ([id], [id_dot_giam_gia], [id_chi_tiet_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, 1, 2, 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_dot_giam_gia] ([id], [id_dot_giam_gia], [id_chi_tiet_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, 2, 3, 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_dot_giam_gia] ([id], [id_dot_giam_gia], [id_chi_tiet_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, 3, 4, 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_dot_giam_gia] ([id], [id_dot_giam_gia], [id_chi_tiet_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, 3, 5, 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[chi_tiet_dot_giam_gia] OFF
GO
SET IDENTITY_INSERT [dbo].[chi_tiet_san_pham] ON 
GO
INSERT [dbo].[chi_tiet_san_pham] ([id], [id_san_pham], [id_mau_sac], [id_kich_thuoc], [id_de_giay], [id_chat_lieu], [id_trong_luong], [so_luong], [gia_ban], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, 1, 1, 1, 1, 1, 1, 50, CAST(2500000.00 AS Decimal(18, 2)), 1, N'Giày thể thao cao cấp', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_san_pham] ([id], [id_san_pham], [id_mau_sac], [id_kich_thuoc], [id_de_giay], [id_chat_lieu], [id_trong_luong], [so_luong], [gia_ban], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, 1, 2, 2, 1, 1, 1, 45, CAST(2500000.00 AS Decimal(18, 2)), 1, N'Giày thể thao cao cấp', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_san_pham] ([id], [id_san_pham], [id_mau_sac], [id_kich_thuoc], [id_de_giay], [id_chat_lieu], [id_trong_luong], [so_luong], [gia_ban], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, 2, 3, 3, 2, 2, 2, 40, CAST(3200000.00 AS Decimal(18, 2)), 1, N'Giày chạy bộ công nghệ cao', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_san_pham] ([id], [id_san_pham], [id_mau_sac], [id_kich_thuoc], [id_de_giay], [id_chat_lieu], [id_trong_luong], [so_luong], [gia_ban], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, 3, 4, 4, 3, 3, 3, 35, CAST(1800000.00 AS Decimal(18, 2)), 1, N'Giày thời trang thể thao', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[chi_tiet_san_pham] ([id], [id_san_pham], [id_mau_sac], [id_kich_thuoc], [id_de_giay], [id_chat_lieu], [id_trong_luong], [so_luong], [gia_ban], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, 4, 5, 5, 4, 4, 4, 30, CAST(2200000.00 AS Decimal(18, 2)), 1, N'Giày casual phong cách', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[chi_tiet_san_pham] OFF
GO
SET IDENTITY_INSERT [dbo].[de_giay] ON 
GO
INSERT [dbo].[de_giay] ([id], [ten_de_giay], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Đế cao su', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[de_giay] ([id], [ten_de_giay], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Đế EVA', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[de_giay] ([id], [ten_de_giay], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Đế PU', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[de_giay] ([id], [ten_de_giay], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'Đế TPU', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[de_giay] ([id], [ten_de_giay], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'Đế phylon', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[de_giay] OFF
GO
SET IDENTITY_INSERT [dbo].[dia_chi_khach_hang] ON 
GO
INSERT [dbo].[dia_chi_khach_hang] ([id], [id_khach_hang], [ten_dia_chi], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [trang_thai], [deleted]) VALUES (1, 1, N'Địa chỉ nhà riêng', N'Hà Nội', N'Ba Đình', N'Phúc Xá', N'S? 10 Ngõ ABC', 1, 0)
GO
INSERT [dbo].[dia_chi_khach_hang] ([id], [id_khach_hang], [ten_dia_chi], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [trang_thai], [deleted]) VALUES (2, 2, N'Địa chỉ công ty', N'Hà Nội', N'Hai Bà Trưng', N'B?ch Mai', N'S? 20 Ðu?ng XYZ', 1, 0)
GO
INSERT [dbo].[dia_chi_khach_hang] ([id], [id_khach_hang], [ten_dia_chi], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [trang_thai], [deleted]) VALUES (3, 3, N'Địa chỉ nhà bố mẹ', N'Hà Nội', N'Tây Hồ', N'Phú Thu?ng', N'S? 30 Ngõ DEF', 1, 0)
GO
SET IDENTITY_INSERT [dbo].[dia_chi_khach_hang] OFF
GO
SET IDENTITY_INSERT [dbo].[dot_giam_gia] ON 
GO
INSERT [dbo].[dot_giam_gia] ([id], [ten_dot_giam_gia], [gia_tri_giam_gia], [ngay_bat_dau], [ngay_ket_thuc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Khuyến mãi mùa hè', 20, CAST(N'2025-09-15' AS Date), CAST(N'2025-11-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[dot_giam_gia] ([id], [ten_dot_giam_gia], [gia_tri_giam_gia], [ngay_bat_dau], [ngay_ket_thuc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Khuyến mãi cuối năm', 25, CAST(N'2025-10-15' AS Date), CAST(N'2025-12-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[dot_giam_gia] ([id], [ten_dot_giam_gia], [gia_tri_giam_gia], [ngay_bat_dau], [ngay_ket_thuc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Khuyến mãi sinh nhật', 30, CAST(N'2025-09-15' AS Date), CAST(N'2025-10-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[dot_giam_gia] OFF
GO
SET IDENTITY_INSERT [dbo].[hinh_thuc_thanh_toan] ON 
GO
INSERT [dbo].[hinh_thuc_thanh_toan] ([id], [id_hoa_don], [id_phuong_thuc_thanh_toan], [tien_chuyen_khoan], [tien_mat], [trang_thai], [deleted]) VALUES (1, 1, 2, CAST(2277000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, 0)
GO
INSERT [dbo].[hinh_thuc_thanh_toan] ([id], [id_hoa_don], [id_phuong_thuc_thanh_toan], [tien_chuyen_khoan], [tien_mat], [trang_thai], [deleted]) VALUES (2, 2, 2, CAST(3030000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, 0)
GO
INSERT [dbo].[hinh_thuc_thanh_toan] ([id], [id_hoa_don], [id_phuong_thuc_thanh_toan], [tien_chuyen_khoan], [tien_mat], [trang_thai], [deleted]) VALUES (3, 3, 1, CAST(0.00 AS Decimal(18, 2)), CAST(1530000.00 AS Decimal(18, 2)), 1, 0)
GO
SET IDENTITY_INSERT [dbo].[hinh_thuc_thanh_toan] OFF
GO
SET IDENTITY_INSERT [dbo].[hoa_don] ON 
GO
INSERT [dbo].[hoa_don] ([id], [id_khach_hang], [id_phieu_giam_gia], [id_nhan_vien], [ten_hoa_don], [loai_don], [phi_van_chuyen], [tong_tien], [tong_tien_sau_giam], [ghi_chu], [ten_khach_hang], [dia_chi_khach_hang], [so_dien_thoai_khach_hang], [email_khach_hang], [ngay_tao], [ngay_thanh_toan], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, 1, 1, 2, N'Đơn hàng giày Nike', 0, CAST(30000.00 AS Decimal(18, 2)), CAST(2530000.00 AS Decimal(18, 2)), CAST(2277000.00 AS Decimal(18, 2)), N'Giao hàng trong ngày', N'Phạm Văn Khách', N'Số 10 Ngõ ABC, Phúc Xá, Ba Đình, Hà Nội', N'0123456780', N'khach1@gmail.com', CAST(N'2025-09-15' AS Date), CAST(N'2025-09-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[hoa_don] ([id], [id_khach_hang], [id_phieu_giam_gia], [id_nhan_vien], [ten_hoa_don], [loai_don], [phi_van_chuyen], [tong_tien], [tong_tien_sau_giam], [ghi_chu], [ten_khach_hang], [dia_chi_khach_hang], [so_dien_thoai_khach_hang], [email_khach_hang], [ngay_tao], [ngay_thanh_toan], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, 2, 2, 2, N'Đơn hàng giày Adidas', 0, CAST(30000.00 AS Decimal(18, 2)), CAST(3230000.00 AS Decimal(18, 2)), CAST(3030000.00 AS Decimal(18, 2)), N'Giao hàng sáng mai', N'Hoàng Thị Mua', N'Số 20 Đường XYZ, Bạch Mai, Hai Bà Trưng, Hà Nội', N'0987654320', N'khach2@gmail.com', CAST(N'2025-09-15' AS Date), CAST(N'2025-09-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[hoa_don] ([id], [id_khach_hang], [id_phieu_giam_gia], [id_nhan_vien], [ten_hoa_don], [loai_don], [phi_van_chuyen], [tong_tien], [tong_tien_sau_giam], [ghi_chu], [ten_khach_hang], [dia_chi_khach_hang], [so_dien_thoai_khach_hang], [email_khach_hang], [ngay_tao], [ngay_thanh_toan], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, 3, 3, 2, N'Đơn hàng giày Puma', 1, CAST(0.00 AS Decimal(18, 2)), CAST(1800000.00 AS Decimal(18, 2)), CAST(1530000.00 AS Decimal(18, 2)), N'Mua tại cửa hàng', N'Vũ Đức Mua', N'Số 30 Ngõ DEF, Phú Thượng, Tây Hồ, Hà Nội', N'0111222000', N'khach3@gmail.com', CAST(N'2025-09-15' AS Date), CAST(N'2025-09-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[hoa_don] OFF
GO
SET IDENTITY_INSERT [dbo].[hoa_don_chi_tiet] ON 
GO
INSERT [dbo].[hoa_don_chi_tiet] ([id], [id_hoa_don], [id_chi_tiet_san_pham], [so_luong], [gia_ban], [thanh_tien], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, 1, 1, 1, CAST(2500000.00 AS Decimal(18, 2)), CAST(2500000.00 AS Decimal(18, 2)), 1, N'Giày Nike Air Max 270 đen size 39', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[hoa_don_chi_tiet] ([id], [id_hoa_don], [id_chi_tiet_san_pham], [so_luong], [gia_ban], [thanh_tien], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, 2, 3, 1, CAST(3200000.00 AS Decimal(18, 2)), CAST(3200000.00 AS Decimal(18, 2)), 1, N'Giày Adidas Ultraboost 22 đỏ size 41', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[hoa_don_chi_tiet] ([id], [id_hoa_don], [id_chi_tiet_san_pham], [so_luong], [gia_ban], [thanh_tien], [trang_thai], [ghi_chu], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, 3, 4, 1, CAST(1800000.00 AS Decimal(18, 2)), CAST(1800000.00 AS Decimal(18, 2)), 1, N'Giày Puma RS-X xanh size 42', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[hoa_don_chi_tiet] OFF
GO
SET IDENTITY_INSERT [dbo].[khach_hang] ON 
GO
INSERT [dbo].[khach_hang] ([id], [ten_khach_hang], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [gioi_tinh], [ngay_sinh], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Phạm Văn Khách', N'khach1', N'khach123', N'khach1@gmail.com', N'0123456780', 1, CAST(N'1998-03-10' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[khach_hang] ([id], [ten_khach_hang], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [gioi_tinh], [ngay_sinh], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Hoàng Thị Mua', N'khach2', N'khach123', N'khach2@gmail.com', N'0987654320', 0, CAST(N'1996-07-25' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[khach_hang] ([id], [ten_khach_hang], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [gioi_tinh], [ngay_sinh], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Vũ Đức Mua', N'khach3', N'khach123', N'khach3@gmail.com', N'0111222000', 1, CAST(N'1994-12-05' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[khach_hang] OFF
GO
SET IDENTITY_INSERT [dbo].[kich_thuoc] ON 
GO
INSERT [dbo].[kich_thuoc] ([id], [ten_kich_thuoc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'39', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[kich_thuoc] ([id], [ten_kich_thuoc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'40', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[kich_thuoc] ([id], [ten_kich_thuoc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'41', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[kich_thuoc] ([id], [ten_kich_thuoc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'42', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[kich_thuoc] ([id], [ten_kich_thuoc], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'43', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[kich_thuoc] OFF
GO
SET IDENTITY_INSERT [dbo].[mau_sac] ON 
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Đen', N'#000000', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Trắng', N'#FFFFFF', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Đỏ', N'#FF0000', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'Xanh dương', N'#0000FF', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'Xanh lá', N'#00FF00', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (6, N'Vàng', N'#FFFF00', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (7, N'Cam', N'#FFA500', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (8, N'Tím', N'#800080', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (9, N'Hồng', N'#FFC0CB', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (10, N'Nâu', N'#A52A2A', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (11, N'Xám', N'#808080', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (12, N'Bạc', N'#C0C0C0', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (13, N'Vàng gold', N'#FFD700', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (14, N'Xanh navy', N'#000080', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[mau_sac] ([id], [ten_mau_sac], [ma_mau], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (15, N'Xanh mint', N'#98FB98', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[mau_sac] OFF
GO
SET IDENTITY_INSERT [dbo].[nha_san_xuat] ON 
GO
INSERT [dbo].[nha_san_xuat] ([id], [ten_nha_san_xuat], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Nike', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nha_san_xuat] ([id], [ten_nha_san_xuat], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Adidas', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nha_san_xuat] ([id], [ten_nha_san_xuat], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Puma', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nha_san_xuat] ([id], [ten_nha_san_xuat], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'New Balance', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nha_san_xuat] ([id], [ten_nha_san_xuat], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'Converse', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[nha_san_xuat] OFF
GO
SET IDENTITY_INSERT [dbo].[nhan_vien] ON 
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, 2, N'Nguyễn Văn Admin', N'admin', N'admin123', N'admin@gearup.com', N'0123456789', NULL, CAST(N'1990-01-01' AS Date), N'Quản trị viên hệ thống', N'Hà Nội', N'Cầu Giấy', N'D?ch V?ng', N'S? 1 Ðu?ng ABC', 1, N'123456789012', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, 1, N'Trần Thị Bán Hàng', N'banhang', N'banhang123', N'banhang@gearup.com', N'0987654321', NULL, CAST(N'1995-05-15' AS Date), N'Nhân viên bán hàng', N'Hà Nội', N'Đống Đa', N'Láng H?', N'S? 2 Ðu?ng XYZ', 0, N'987654321098', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, 1, N'Lê Văn Kho', N'kho', N'kho123', N'kho@gearup.com', N'0111222333', NULL, CAST(N'1992-08-20' AS Date), N'Nhân viên quản lý kho', N'Hà Nội', N'Thanh Xuân', N'Thanh Xuân B?c', N'S? 3 Ðu?ng DEF', 1, N'456789123012', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, 2, N'Phạm Thị Quản Lý', N'quanly', N'quanly123', N'quanly@gearup.com', N'0333444555', NULL, CAST(N'1988-12-10' AS Date), N'Quản lý chi nhánh', N'Hà Nội', N'Hoàn Kiếm', N'Hàng Bài', N'S? 4 Ðu?ng GHI', 0, N'789123456789', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, 1, N'Hoàng Văn Tư Vấn', N'tuvan', N'tuvan123', N'tuvan@gearup.com', N'0555666777', NULL, CAST(N'1997-03-25' AS Date), N'Nhân viên tư vấn khách hàng', N'Hà Nội', N'Hai Bà Trưng', N'B?ch Mai', N'S? 5 Ðu?ng JKL', 1, N'321654987321', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (6, 1, N'Nguyễn Thị Thu', N'thu.nguyen', N'thu123', N'thu.nguyen@gearup.com', N'0666777888', NULL, CAST(N'1993-06-12' AS Date), N'Nhân viên bán hàng online', N'Hồ Chí Minh', N'Quận 1', N'B?n Nghé', N'S? 6 Ðu?ng MNO', 0, N'654987321654', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (7, 1, N'Trần Văn Minh', N'minh.tran', N'minh123', N'minh.tran@gearup.com', N'0777888999', NULL, CAST(N'1991-09-08' AS Date), N'Nhân viên thu ngân', N'Hải Phòng', N'Hồng Bàng', N'H? Lý', N'S? 7 Ðu?ng PQR', 1, N'987321654987', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (8, 2, N'Lê Thị Hoa', N'hoa.le', N'hoa123', N'hoa.le@gearup.com', N'0888999000', NULL, CAST(N'1987-11-22' AS Date), N'Quản lý bán hàng', N'Đà Nẵng', N'Hải Châu', N'H?i Châu 1', N'S? 8 Ðu?ng STU', 0, N'321654987654', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (9, 1, N'Phạm Văn Tùng', N'tung.pham', N'tung123', N'tung.pham@gearup.com', N'0999000111', NULL, CAST(N'1994-02-14' AS Date), N'Nhân viên marketing', N'Cần Thơ', N'Ninh Kiều', N'An Cu', N'S? 9 Ðu?ng VWX', 1, N'654321987654', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (10, 1, N'Đinh Thị Linh', N'linh.dinh', N'linh123', N'linh.dinh@gearup.com', N'0111122222', NULL, CAST(N'1996-04-28' AS Date), N'Nhân viên chăm sóc khách hàng', N'Hà Nội', N'Nam Từ Liêm', N'C?u Di?n', N'S? 10 Ðu?ng YZA', 0, N'987654321987', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (11, 2, N'Bùi Văn Sơn', N'son.bui', N'son123', N'son.bui@gearup.com', N'0222233333', NULL, CAST(N'1989-07-05' AS Date), N'Quản lý kho bãi', N'Hồ Chí Minh', N'Quận 7', N'Phú M?', N'S? 11 Ðu?ng BCD', 1, N'321987654321', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (12, 1, N'Ngô Thị Mai', N'mai.ngo', N'mai123', N'mai.ngo@gearup.com', N'0333344444', NULL, CAST(N'1995-10-18' AS Date), N'Nhân viên kế toán', N'Hà Nội', N'Hoàng Mai', N'Giáp Bát', N'S? 12 Ngõ 123 Giáp Bát', 0, N'654321987321', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (13, 1, N'Vũ Văn Đức', N'duc.vu', N'duc123', N'duc.vu@gearup.com', N'0444455555', NULL, CAST(N'1992-12-30' AS Date), N'Nhân viên kỹ thuật', N'Bắc Ninh', N'Bắc Ninh', N'Su Ph?m', N'S? 13 Ðu?ng EFG', 1, N'987321654987', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (14, 2, N'Hoàng Thị Lan', N'lan.hoang', N'lan123', N'lan.hoang@gearup.com', N'0555566666', NULL, CAST(N'1986-03-17' AS Date), N'Quản lý nhân sự', N'Hà Nội', N'Tây Hồ', N'Phú Thu?ng', N'S? 14 Ðu?ng HIJ', 0, N'321654987321', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (15, 1, N'Tô Văn Tùng', N'tung.to', N'tung123', N'tung.to@gearup.com', N'0666677777', NULL, CAST(N'1998-05-09' AS Date), N'Nhân viên giao hàng', N'Hà Nội', N'Long Biên', N'Gia Th?y', N'S? 15 Ðu?ng KLM', 1, N'654987321654', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (16, 1, N'Đỗ Văn Anh', N'anh.do', N'anh123', N'anh.do@gearup.com', N'0777788888', NULL, CAST(N'1999-08-15' AS Date), N'Nhân viên bán hàng', N'Hà Nội', N'Ba Đình', N'Ng?c Khánh', N'S? 16 Ðu?ng NOP', 1, N'789654123987', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (17, 1, N'Mai Thị Hương', N'huong.mai', N'huong123', N'huong.mai@gearup.com', N'0888899999', NULL, CAST(N'1994-11-20' AS Date), N'Nhân viên tư vấn', N'Hồ Chí Minh', N'Quận 3', N'Võ Th? Sáu', N'S? 17 Ðu?ng QRS', 0, N'456123789654', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (18, 2, N'Nguyễn Văn Bình', N'binh.nguyen', N'binh123', N'binh.nguyen@gearup.com', N'0999900000', NULL, CAST(N'1985-01-30' AS Date), N'Quản lý khu vực', N'Hải Phòng', N'Ngô Quyền', N'Máy To', N'S? 18 Ðu?ng TUV', 1, N'321456987123', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (19, 1, N'Trần Thị Dung', N'dung.tran', N'dung123', N'dung.tran@gearup.com', N'0111112222', NULL, CAST(N'1997-05-25' AS Date), N'Nhân viên thu ngân', N'Đà Nẵng', N'Sơn Trà', N'An H?i B?c', N'S? 19 Ðu?ng WXY', 0, N'654789321456', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[nhan_vien] ([id], [id_quyen_han], [ten_nhan_vien], [ten_tai_khoan], [mat_khau], [email], [so_dien_thoai], [anh_nhan_vien], [ngay_sinh], [ghi_chu], [thanh_pho], [quan], [phuong], [dia_chi_cu_the], [gioi_tinh], [cccd], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (20, 1, N'Lê Văn Hải', N'hai.le', N'hai123', N'hai.le@gearup.com', N'0222223333', NULL, CAST(N'1993-09-10' AS Date), N'Nhân viên kỹ thuật', N'Cần Thơ', N'Cái Răng', N'Lê Bình', N'S? 20 Ðu?ng ZAB', 1, N'987456123789', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[nhan_vien] OFF
GO
SET IDENTITY_INSERT [dbo].[phieu_giam_gia] ON 
GO
INSERT [dbo].[phieu_giam_gia] ([id], [ten_phieu_giam_gia], [loai_phieu_giam_gia], [gia_tri_giam_gia], [so_tien_toi_da], [hoa_don_toi_thieu], [so_luong_dung], [ngay_bat_dau], [ngay_ket_thuc], [trang_thai], [mo_ta], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Giảm giá 10% cho đơn hàng đầu tiên', 0, CAST(10.00 AS Decimal(18, 2)), CAST(500000.00 AS Decimal(18, 2)), CAST(1000000.00 AS Decimal(18, 2)), 100, CAST(N'2025-09-15' AS Date), CAST(N'2025-12-15' AS Date), 1, N'Áp dụng cho khách hàng mới', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[phieu_giam_gia] ([id], [ten_phieu_giam_gia], [loai_phieu_giam_gia], [gia_tri_giam_gia], [so_tien_toi_da], [hoa_don_toi_thieu], [so_luong_dung], [ngay_bat_dau], [ngay_ket_thuc], [trang_thai], [mo_ta], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Giảm giá 200.000đ cho đơn hàng từ 2 triệu', 1, CAST(200000.00 AS Decimal(18, 2)), CAST(200000.00 AS Decimal(18, 2)), CAST(2000000.00 AS Decimal(18, 2)), 50, CAST(N'2025-09-15' AS Date), CAST(N'2025-11-15' AS Date), 1, N'Áp dụng cho tất cả khách hàng', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[phieu_giam_gia] ([id], [ten_phieu_giam_gia], [loai_phieu_giam_gia], [gia_tri_giam_gia], [so_tien_toi_da], [hoa_don_toi_thieu], [so_luong_dung], [ngay_bat_dau], [ngay_ket_thuc], [trang_thai], [mo_ta], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Giảm giá 15% cho giày thể thao', 0, CAST(15.00 AS Decimal(18, 2)), CAST(300000.00 AS Decimal(18, 2)), CAST(1500000.00 AS Decimal(18, 2)), 30, CAST(N'2025-09-15' AS Date), CAST(N'2025-10-15' AS Date), 1, N'Chỉ áp dụng cho giày thể thao', 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[phieu_giam_gia] OFF
GO
SET IDENTITY_INSERT [dbo].[phieu_giam_gia_ca_nhan] ON 
GO
INSERT [dbo].[phieu_giam_gia_ca_nhan] ([id], [id_khach_hang], [id_phieu_giam_gia], [ten_phieu_giam_gia_ca_nhan], [ngay_nhan], [ngay_het_han], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, 1, 1, N'Phiếu giảm giá cá nhân - Khách 1', CAST(N'2025-09-15' AS Date), CAST(N'2025-12-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[phieu_giam_gia_ca_nhan] ([id], [id_khach_hang], [id_phieu_giam_gia], [ten_phieu_giam_gia_ca_nhan], [ngay_nhan], [ngay_het_han], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, 2, 2, N'Phiếu giảm giá cá nhân - Khách 2', CAST(N'2025-09-15' AS Date), CAST(N'2025-11-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[phieu_giam_gia_ca_nhan] ([id], [id_khach_hang], [id_phieu_giam_gia], [ten_phieu_giam_gia_ca_nhan], [ngay_nhan], [ngay_het_han], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, 3, 3, N'Phiếu giảm giá cá nhân - Khách 3', CAST(N'2025-09-15' AS Date), CAST(N'2025-10-15' AS Date), 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[phieu_giam_gia_ca_nhan] OFF
GO
SET IDENTITY_INSERT [dbo].[phuong_thuc_thanh_toan] ON 
GO
INSERT [dbo].[phuong_thuc_thanh_toan] ([id], [ten_phuong_thuc_thanh_toan], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Tiền mặt', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[phuong_thuc_thanh_toan] ([id], [ten_phuong_thuc_thanh_toan], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Chuyển khoản ngân hàng', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[phuong_thuc_thanh_toan] ([id], [ten_phuong_thuc_thanh_toan], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Ví điện tử', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[phuong_thuc_thanh_toan] ([id], [ten_phuong_thuc_thanh_toan], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'Thẻ tín dụng', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[phuong_thuc_thanh_toan] OFF
GO
SET IDENTITY_INSERT [dbo].[quyen_han] ON 
GO
INSERT [dbo].[quyen_han] ([id], [ten_quyen_han], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Nhân viên', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[quyen_han] ([id], [ten_quyen_han], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Quản lý', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[quyen_han] OFF
GO
SET IDENTITY_INSERT [dbo].[san_pham] ON 
GO
INSERT [dbo].[san_pham] ([id], [id_nha_san_xuat], [id_xuat_xu], [ten_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, 1, 1, N'Giày Nike Air Max 270', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[san_pham] ([id], [id_nha_san_xuat], [id_xuat_xu], [ten_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, 2, 2, N'Giày Adidas Ultraboost 22', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[san_pham] ([id], [id_nha_san_xuat], [id_xuat_xu], [ten_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, 3, 3, N'Giày Puma RS-X', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[san_pham] ([id], [id_nha_san_xuat], [id_xuat_xu], [ten_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, 4, 4, N'Giày New Balance 574', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[san_pham] ([id], [id_nha_san_xuat], [id_xuat_xu], [ten_san_pham], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, 5, 5, N'Giày Converse Chuck Taylor', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[san_pham] OFF
GO
SET IDENTITY_INSERT [dbo].[thong_tin_don_hang] ON 
GO
INSERT [dbo].[thong_tin_don_hang] ([id], [id_hoa_don], [id_trang_thai_don_hang], [thoi_gian], [ghi_chu], [trang_thai], [deleted]) VALUES (1, 1, 1, CAST(N'2025-09-15T08:28:43.340' AS DateTime), N'Đơn hàng mới được tạo', 1, 0)
GO
INSERT [dbo].[thong_tin_don_hang] ([id], [id_hoa_don], [id_trang_thai_don_hang], [thoi_gian], [ghi_chu], [trang_thai], [deleted]) VALUES (2, 1, 2, CAST(N'2025-09-15T08:33:43.340' AS DateTime), N'Đơn hàng đã được xác nhận', 1, 0)
GO
INSERT [dbo].[thong_tin_don_hang] ([id], [id_hoa_don], [id_trang_thai_don_hang], [thoi_gian], [ghi_chu], [trang_thai], [deleted]) VALUES (3, 1, 3, CAST(N'2025-09-15T08:38:43.340' AS DateTime), N'Đơn hàng đang được xử lý', 1, 0)
GO
INSERT [dbo].[thong_tin_don_hang] ([id], [id_hoa_don], [id_trang_thai_don_hang], [thoi_gian], [ghi_chu], [trang_thai], [deleted]) VALUES (4, 2, 1, CAST(N'2025-09-15T08:28:43.340' AS DateTime), N'Đơn hàng mới được tạo', 1, 0)
GO
INSERT [dbo].[thong_tin_don_hang] ([id], [id_hoa_don], [id_trang_thai_don_hang], [thoi_gian], [ghi_chu], [trang_thai], [deleted]) VALUES (5, 2, 2, CAST(N'2025-09-15T08:31:43.340' AS DateTime), N'Đơn hàng đã được xác nhận', 1, 0)
GO
INSERT [dbo].[thong_tin_don_hang] ([id], [id_hoa_don], [id_trang_thai_don_hang], [thoi_gian], [ghi_chu], [trang_thai], [deleted]) VALUES (6, 3, 1, CAST(N'2025-09-15T08:28:43.340' AS DateTime), N'Đơn hàng mới được tạo', 1, 0)
GO
INSERT [dbo].[thong_tin_don_hang] ([id], [id_hoa_don], [id_trang_thai_don_hang], [thoi_gian], [ghi_chu], [trang_thai], [deleted]) VALUES (7, 3, 5, CAST(N'2025-09-15T08:43:43.340' AS DateTime), N'Đơn hàng đã hoàn thành', 1, 0)
GO
SET IDENTITY_INSERT [dbo].[thong_tin_don_hang] OFF
GO
SET IDENTITY_INSERT [dbo].[trang_thai_don_hang] ON 
GO
INSERT [dbo].[trang_thai_don_hang] ([id], [ten_trang_thai_don_hang], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Chờ xác nhận', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trang_thai_don_hang] ([id], [ten_trang_thai_don_hang], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Đã xác nhận', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trang_thai_don_hang] ([id], [ten_trang_thai_don_hang], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Đang xử lý', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trang_thai_don_hang] ([id], [ten_trang_thai_don_hang], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'Đang giao hàng', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trang_thai_don_hang] ([id], [ten_trang_thai_don_hang], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'Đã giao hàng', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trang_thai_don_hang] ([id], [ten_trang_thai_don_hang], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (6, N'Đã hủy', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[trang_thai_don_hang] OFF
GO
SET IDENTITY_INSERT [dbo].[trong_luong] ON 
GO
INSERT [dbo].[trong_luong] ([id], [ten_trong_luong], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'250g', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trong_luong] ([id], [ten_trong_luong], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'300g', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trong_luong] ([id], [ten_trong_luong], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'350g', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trong_luong] ([id], [ten_trong_luong], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'400g', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[trong_luong] ([id], [ten_trong_luong], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'450g', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[trong_luong] OFF
GO
SET IDENTITY_INSERT [dbo].[xuat_xu] ON 
GO
INSERT [dbo].[xuat_xu] ([id], [ten_xuat_xu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (1, N'Việt Nam', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[xuat_xu] ([id], [ten_xuat_xu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (2, N'Trung Quốc', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[xuat_xu] ([id], [ten_xuat_xu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (3, N'Thái Lan', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[xuat_xu] ([id], [ten_xuat_xu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (4, N'Indonesia', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
INSERT [dbo].[xuat_xu] ([id], [ten_xuat_xu], [trang_thai], [deleted], [create_at], [create_by], [update_at], [update_by]) VALUES (5, N'Malaysia', 1, 0, CAST(N'2025-09-15' AS Date), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[xuat_xu] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__anh_san___F73EF501BE282FE0]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[anh_san_pham] ADD UNIQUE NONCLUSTERED 
(
	[duong_dan_anh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__chat_lie__47FA2872C652289D]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[chat_lieu] ADD UNIQUE NONCLUSTERED 
(
	[ten_chat_lieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__de_giay__C3D40955F6AF91F1]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[de_giay] ADD UNIQUE NONCLUSTERED 
(
	[ten_de_giay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__dot_giam__E885712BBE1307A4]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[dot_giam_gia] ADD UNIQUE NONCLUSTERED 
(
	[ten_dot_giam_gia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__khach_ha__17112F09BDAA44D7]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[khach_hang] ADD UNIQUE NONCLUSTERED 
(
	[ten_tai_khoan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__khach_ha__AB6E616481E1ADA2]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[khach_hang] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__khach_ha__BD03D94C13CC7B0D]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[khach_hang] ADD UNIQUE NONCLUSTERED 
(
	[so_dien_thoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__kich_thu__06BE2795282D0D8E]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[kich_thuoc] ADD UNIQUE NONCLUSTERED 
(
	[ten_kich_thuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__mau_sac__25764485F3EFD87E]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[mau_sac] ADD UNIQUE NONCLUSTERED 
(
	[ten_mau_sac] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__nha_san___700B09053E3804DC]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[nha_san_xuat] ADD UNIQUE NONCLUSTERED 
(
	[ten_nha_san_xuat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__nhan_vie__17112F0974DF6342]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[nhan_vien] ADD UNIQUE NONCLUSTERED 
(
	[ten_tai_khoan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__nhan_vie__AB6E61641C5B23D0]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[nhan_vien] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__nhan_vie__BD03D94C05C0F351]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[nhan_vien] ADD UNIQUE NONCLUSTERED 
(
	[so_dien_thoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__quyen_ha__1EABFF490C4A356E]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[quyen_han] ADD UNIQUE NONCLUSTERED 
(
	[ten_quyen_han] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__san_pham__BA66C0312C7328F1]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[san_pham] ADD UNIQUE NONCLUSTERED 
(
	[ten_san_pham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__trong_lu__399742A04C111D97]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[trong_luong] ADD UNIQUE NONCLUSTERED 
(
	[ten_trong_luong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__xuat_xu__BA9B892467EC6803]    Script Date: 9/19/2025 12:55:50 PM ******/
ALTER TABLE [dbo].[xuat_xu] ADD UNIQUE NONCLUSTERED 
(
	[ten_xuat_xu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[anh_san_pham] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[anh_san_pham] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[chat_lieu] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[chat_lieu] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[chi_tiet_dot_giam_gia] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[chi_tiet_dot_giam_gia] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[chi_tiet_san_pham] ADD  DEFAULT ((0)) FOR [so_luong]
GO
ALTER TABLE [dbo].[chi_tiet_san_pham] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[chi_tiet_san_pham] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[chi_tiet_san_pham_anh] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[chi_tiet_san_pham_anh] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[de_giay] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[de_giay] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[dia_chi_khach_hang] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[dia_chi_khach_hang] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[dot_giam_gia] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[dot_giam_gia] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[hinh_thuc_thanh_toan] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[hinh_thuc_thanh_toan] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[hoa_don] ADD  DEFAULT ((0)) FOR [loai_don]
GO
ALTER TABLE [dbo].[hoa_don] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[hoa_don] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet] ADD  DEFAULT ((0)) FOR [so_luong]
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[khach_hang] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[khach_hang] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[kich_thuoc] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[kich_thuoc] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[mau_sac] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[mau_sac] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[nha_san_xuat] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[nha_san_xuat] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[nhan_vien] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[nhan_vien] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[phieu_giam_gia] ADD  DEFAULT ((0)) FOR [loai_phieu_giam_gia]
GO
ALTER TABLE [dbo].[phieu_giam_gia] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[phieu_giam_gia] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[phieu_giam_gia_ca_nhan] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[phieu_giam_gia_ca_nhan] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[phuong_thuc_thanh_toan] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[phuong_thuc_thanh_toan] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[quyen_han] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[quyen_han] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[san_pham] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[san_pham] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[thong_tin_don_hang] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[thong_tin_don_hang] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[trang_thai_don_hang] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[trang_thai_don_hang] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[trong_luong] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[trong_luong] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[xuat_xu] ADD  DEFAULT ((1)) FOR [trang_thai]
GO
ALTER TABLE [dbo].[xuat_xu] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[chi_tiet_dot_giam_gia]  WITH CHECK ADD FOREIGN KEY([id_chi_tiet_san_pham])
REFERENCES [dbo].[chi_tiet_san_pham] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_dot_giam_gia]  WITH CHECK ADD FOREIGN KEY([id_dot_giam_gia])
REFERENCES [dbo].[dot_giam_gia] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD FOREIGN KEY([id_chat_lieu])
REFERENCES [dbo].[chat_lieu] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD FOREIGN KEY([id_de_giay])
REFERENCES [dbo].[de_giay] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD FOREIGN KEY([id_kich_thuoc])
REFERENCES [dbo].[kich_thuoc] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD FOREIGN KEY([id_mau_sac])
REFERENCES [dbo].[mau_sac] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD FOREIGN KEY([id_san_pham])
REFERENCES [dbo].[san_pham] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD FOREIGN KEY([id_trong_luong])
REFERENCES [dbo].[trong_luong] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham_anh]  WITH CHECK ADD FOREIGN KEY([id_anh_san_pham])
REFERENCES [dbo].[anh_san_pham] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham_anh]  WITH CHECK ADD FOREIGN KEY([id_chi_tiet_san_pham])
REFERENCES [dbo].[chi_tiet_san_pham] ([id])
GO
ALTER TABLE [dbo].[dia_chi_khach_hang]  WITH CHECK ADD FOREIGN KEY([id_khach_hang])
REFERENCES [dbo].[khach_hang] ([id])
GO
ALTER TABLE [dbo].[hinh_thuc_thanh_toan]  WITH CHECK ADD FOREIGN KEY([id_hoa_don])
REFERENCES [dbo].[hoa_don] ([id])
GO
ALTER TABLE [dbo].[hinh_thuc_thanh_toan]  WITH CHECK ADD FOREIGN KEY([id_phuong_thuc_thanh_toan])
REFERENCES [dbo].[phuong_thuc_thanh_toan] ([id])
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD FOREIGN KEY([id_khach_hang])
REFERENCES [dbo].[khach_hang] ([id])
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD FOREIGN KEY([id_nhan_vien])
REFERENCES [dbo].[nhan_vien] ([id])
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD FOREIGN KEY([id_phieu_giam_gia])
REFERENCES [dbo].[phieu_giam_gia] ([id])
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet]  WITH CHECK ADD FOREIGN KEY([id_chi_tiet_san_pham])
REFERENCES [dbo].[chi_tiet_san_pham] ([id])
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet]  WITH CHECK ADD FOREIGN KEY([id_hoa_don])
REFERENCES [dbo].[hoa_don] ([id])
GO
ALTER TABLE [dbo].[nhan_vien]  WITH CHECK ADD FOREIGN KEY([id_quyen_han])
REFERENCES [dbo].[quyen_han] ([id])
GO
ALTER TABLE [dbo].[phieu_giam_gia_ca_nhan]  WITH CHECK ADD FOREIGN KEY([id_khach_hang])
REFERENCES [dbo].[khach_hang] ([id])
GO
ALTER TABLE [dbo].[phieu_giam_gia_ca_nhan]  WITH CHECK ADD FOREIGN KEY([id_phieu_giam_gia])
REFERENCES [dbo].[phieu_giam_gia] ([id])
GO
ALTER TABLE [dbo].[san_pham]  WITH CHECK ADD FOREIGN KEY([id_nha_san_xuat])
REFERENCES [dbo].[nha_san_xuat] ([id])
GO
ALTER TABLE [dbo].[san_pham]  WITH CHECK ADD FOREIGN KEY([id_xuat_xu])
REFERENCES [dbo].[xuat_xu] ([id])
GO
ALTER TABLE [dbo].[thong_tin_don_hang]  WITH CHECK ADD FOREIGN KEY([id_hoa_don])
REFERENCES [dbo].[hoa_don] ([id])
GO
ALTER TABLE [dbo].[thong_tin_don_hang]  WITH CHECK ADD FOREIGN KEY([id_trang_thai_don_hang])
REFERENCES [dbo].[trang_thai_don_hang] ([id])
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD CHECK  (([gia_ban]>=(0)))
GO
ALTER TABLE [dbo].[chi_tiet_san_pham]  WITH CHECK ADD CHECK  (([so_luong]>=(0)))
GO
ALTER TABLE [dbo].[dot_giam_gia]  WITH CHECK ADD CHECK  (([gia_tri_giam_gia]>=(0)))
GO
ALTER TABLE [dbo].[dot_giam_gia]  WITH CHECK ADD CHECK  (([ngay_ket_thuc]>[ngay_bat_dau]))
GO
ALTER TABLE [dbo].[hinh_thuc_thanh_toan]  WITH CHECK ADD CHECK  (([tien_chuyen_khoan]>=(0)))
GO
ALTER TABLE [dbo].[hinh_thuc_thanh_toan]  WITH CHECK ADD CHECK  (([tien_mat]>=(0)))
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD CHECK  (([ngay_thanh_toan]>=[ngay_tao]))
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD CHECK  (([tong_tien_sau_giam]<=[tong_tien]))
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD CHECK  (([phi_van_chuyen]>=(0)))
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD CHECK  (([tong_tien]>=(0)))
GO
ALTER TABLE [dbo].[hoa_don]  WITH CHECK ADD CHECK  (([tong_tien_sau_giam]>=(0)))
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet]  WITH CHECK ADD CHECK  (([gia_ban]>=(0)))
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet]  WITH CHECK ADD CHECK  (([so_luong]>=(0)))
GO
ALTER TABLE [dbo].[hoa_don_chi_tiet]  WITH CHECK ADD CHECK  (([thanh_tien]>=(0)))
GO
ALTER TABLE [dbo].[phieu_giam_gia]  WITH CHECK ADD CHECK  (([gia_tri_giam_gia]>=(0)))
GO
ALTER TABLE [dbo].[phieu_giam_gia]  WITH CHECK ADD CHECK  (([hoa_don_toi_thieu]>=(0)))
GO
ALTER TABLE [dbo].[phieu_giam_gia]  WITH CHECK ADD CHECK  (([so_luong_dung]>=(0)))
GO
ALTER TABLE [dbo].[phieu_giam_gia]  WITH CHECK ADD CHECK  (([so_tien_toi_da]>=(0)))
GO
ALTER TABLE [dbo].[phieu_giam_gia]  WITH CHECK ADD CHECK  (([ngay_ket_thuc]>[ngay_bat_dau]))
GO
ALTER TABLE [dbo].[phieu_giam_gia_ca_nhan]  WITH CHECK ADD CHECK  (([ngay_het_han]>[ngay_nhan]))
GO
USE [master]
GO
ALTER DATABASE [GearUp] SET  READ_WRITE 
GO
