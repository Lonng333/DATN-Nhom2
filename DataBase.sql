
CREATE DATABASE VuxGymDB;
GO

USE VuxGymDB;
GO

CREATE TABLE NguoiDung (
    MaNguoiDung BIGINT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    TenDangNhap VARCHAR(100) NOT NULL UNIQUE,
    MatKhau VARCHAR(100) NOT NULL,
    MaNhom BIGINT NOT NULL,
    GhiChu NVARCHAR(500) NULL,
    TrangThai INT DEFAULT 1
);
GO


INSERT INTO NguoiDung (HoTen, TenDangNhap, MatKhau, MaNhom, GhiChu, TrangThai)
VALUES (N'Nguyễn Hoàng Vũ', 'admin', '123456', 1, N'Quản trị hệ thống', 1);


INSERT INTO NguoiDung (HoTen, TenDangNhap, MatKhau, MaNhom, GhiChu, TrangThai)
VALUES (N'Nguyễn Nhật Minh', 'letan', '123456', 2, N'Lễ tân ca sáng', 1);


INSERT INTO NguoiDung (HoTen, TenDangNhap, MatKhau, MaNhom, GhiChu, TrangThai)
VALUES (N'Trần Gia Khánh', 'pt_khanh', '123456', 3, N'Cardio & Kháng lực', 1);

INSERT INTO NguoiDung (HoTen, TenDangNhap, MatKhau, MaNhom, GhiChu, TrangThai)
VALUES (N'Phạm Đức Anh', 'pt_ducanh', '123456', 3, N'Tăng cơ - Giảm mỡ nhanh', 1);

INSERT INTO NguoiDung (HoTen, TenDangNhap, MatKhau, MaNhom, GhiChu, TrangThai)
VALUES (N'Lê Văn Đạt', 'pt_dat', '123456', 3, N'Yoga & Pilates Instructor', 0);

INSERT INTO NguoiDung (HoTen, TenDangNhap, MatKhau, MaNhom, GhiChu, TrangThai)
VALUES (N'Hoàng Thúy Vi', 'pt_vi', '123456', 3, N'Boxing & KickFit', 1);
GO

SELECT * FROM NguoiDung;


CREATE TABLE KhachHang (
    MaKhachHang BIGINT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SoDienThoai VARCHAR(20),
    Email VARCHAR(255),
    DiaChi NVARCHAR(255),
    PTPhuTrach NVARCHAR(255),
    GoiTap NVARCHAR(255),
    HanSuDung DATE,
    TrangThai NVARCHAR(50)
);
INSERT INTO KhachHang (HoTen, GioiTinh, NgaySinh, SoDienThoai, Email, DiaChi, PTPhuTrach, GoiTap, HanSuDung, TrangThai) VALUES
(N'Phan Anh Vũ', N'Nam', '2002-06-10', '0982111222', 'vu@gmail.com', N'Hà Nội', N'Nguyễn Nhật Minh', N'VIP 12 tháng', '2027-06-30', N'Đang hoạt động'),
(N'Nguyễn Gia Phát', N'Nữ', '2001-09-15', '0978333444', 'phat@gmail.com', N'Hải Phòng', N'Trần Gia Khánh', N'PT Premium', '2026-12-31', N'Sắp hết hạn'),
(N'Nguyễn Nhật Long', N'Nam', '1998-04-20', '0911222333', 'long@gmail.com', N'Hà Nam', N'Hoàng Thúy Vi', N'Gym 6 tháng', '2026-09-20', N'Đang hoạt động'),
(N'Phạm Thu Hà', N'Nữ', '1999-11-12', '0966444555', 'ha@gmail.com', N'Hà Nội', N'Phạm Đức Anh', N'Yoga', '2026-08-15', N'Đã ngừng');
SELECT * FROM KhachHang