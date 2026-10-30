-- 1. Bảng KhachHang 
CREATE TABLE KhachHang
(
    SDTK CHAR(15) NOT NULL PRIMARY KEY,
    TenKhach NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    HangThanhVien NVARCHAR(50)
);

-- 2. Bảng CuaHang 
CREATE TABLE CuaHang 
(
    MaCH CHAR(20) NOT NULL PRIMARY KEY,
    TenCH NVARCHAR(100),
    DiaChi NVARCHAR(200),
    SDT CHAR(15),
    MaNVQL CHAR(20)
);

-- 3. Bảng NhanVien
CREATE TABLE NhanVien
(
    MaNV CHAR(20) NOT NULL PRIMARY KEY,
    TenNV NVARCHAR(100),
    NgaySinh DATE,
    DiaChi NVARCHAR(100), 
    GioiTinh NVARCHAR(10),
    SDTNV CHAR(15),
    Luong INT,
    MaCH CHAR(20),
    FOREIGN KEY(MaCH) REFERENCES CuaHang(MaCH)
);

-- 4. Bảng NhaCungCap
CREATE TABLE NhaCungCap
(
    MaNhaCC CHAR(20) NOT NULL PRIMARY KEY,
    TenNhaCC NVARCHAR(100),
    SDT CHAR(15),
    DiaChi NVARCHAR(200)
);

-- 5. Bảng SanPham
CREATE TABLE SanPham
(
    MaSP CHAR(20) NOT NULL PRIMARY KEY,
    TenSP NVARCHAR(100),
    SoLuongTon INT,
    LoaiSP NVARCHAR(50),
    MoTa NVARCHAR(255),
    GiaSP BIGINT
);

-- 6. Bảng HoaDonNhap
CREATE TABLE HoaDonNhap (
    MaHDNhap CHAR(20) NOT NULL PRIMARY KEY,
    NgayNhap DATE,
    MaNhaCC CHAR(20),
    MaNVQL CHAR(20),
    FOREIGN KEY (MaNhaCC) REFERENCES NhaCungCap(MaNhaCC),
    FOREIGN KEY (MaNVQL) REFERENCES NhanVien(MaNV)
);

-- 7. Bảng ChiTietHDNhap
CREATE TABLE ChiTietHDNhap (
    MaHDNhap CHAR(20) NOT NULL,
    MaSP CHAR(20) NOT NULL,
    SoLuong INT,
    PRIMARY KEY (MaHDNhap, MaSP),
    FOREIGN KEY (MaHDNhap) REFERENCES HoaDonNhap(MaHDNhap),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- 8. Bảng HoaDonXuat
CREATE TABLE HoaDonXuat (
    MaHDXuat CHAR(20) NOT NULL PRIMARY KEY,
    NgayXuat DATE,
    SDTK CHAR(15),
    MaNV CHAR(20),
    FOREIGN KEY (SDTK) REFERENCES KhachHang(SDTK),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- 9. Bảng ChiTietHDXuat
CREATE TABLE ChiTietHDXuat (
    MaHDXuat CHAR(20) NOT NULL,
    MaSP CHAR(20) NOT NULL,
    SoLuong INT,
    PRIMARY KEY (MaHDXuat, MaSP),
    FOREIGN KEY (MaHDXuat) REFERENCES HoaDonXuat(MaHDXuat),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- 10. Bảng BaoHanh
CREATE TABLE BaoHanh (
    MaBH CHAR(20) NOT NULL PRIMARY KEY,
    MaHDXuat CHAR(20),
    MaSP CHAR(20),
    NgayBatDau DATE,
    NgayKetThuc DATE,
    TrangThai NVARCHAR(50),
    ThoiHanBaoHanh INT,
    FOREIGN KEY (MaHDXuat, MaSP) REFERENCES ChiTietHDXuat(MaHDXuat, MaSP)
);

-- 11. Bảng LichSuBaoHanh
CREATE TABLE LichSuBaoHanh (
    MaLSBH CHAR(20) NOT NULL PRIMARY KEY,
    MaBH CHAR(20),
    NgayTiepNhan DATETIME,
    TinhTrangBanDau NVARCHAR(255),
    NoiDungSuaChua NVARCHAR(255),
    NgayHoanThanh DATETIME,
    TrangThai NVARCHAR(50),
    MaNVBH CHAR(20),
    FOREIGN KEY (MaBH) REFERENCES BaoHanh(MaBH),
    FOREIGN KEY (MaNVBH) REFERENCES NhanVien(MaNV)
);
GO