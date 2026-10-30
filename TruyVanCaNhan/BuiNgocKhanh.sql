--Mức 1: Truy vấn cơ bản 
--1.1. Hiển thị toàn bộ danh sách nhà cung cấp
SELECT * FROM NhaCungCap;

--1.2. Tìm các sản phẩm có số lượng tồn kho dưới 15 chiếc
SELECT MaSP, TenSP, SoLuongTon 
FROM SanPham 
WHERE SoLuongTon < 15;

--1.3. Tìm kiếm các khách hàng có họ Nguyễn 
SELECT SDTK, TenKhach, HangThanhVien 
FROM KhachHang 
WHERE TenKhach LIKE N'Nguyễn%';

--1.4. Lọc danh sách nhân viên nam có lương lớn hơn 10000000
SELECT MaNV, TenNV, Luong, GioiTinh, NgaySinh 
FROM NhanVien 
WHERE GioiTinh = N'Nam' AND Luong >= 10000000;

--1.5. Lấy danh sách các hóa đơn nhập được tiếp nhận 2/2026 
SELECT MaHDNhap, NgayNhap, MaNhaCC, MaNVQL
FROM HoaDonNhap 
WHERE MONTH(NgayNhap) = 2 AND YEAR(NgayNhap) = 2026;

--Mức 2: Truy vấn nhiều bảng
--1.6. Hiển thị tên sản phẩm kèm số lượng bán trong từng chi tiết hóa đơn xuất
SELECT SP.TenSP, CT.SoLuong 
FROM SanPham SP, ChiTietHDXuat CT
WHERE SP.MaSP = CT.MaSP;

--1.7. Danh sách các nhà cung cấp đã cấp hàng cho cửa hàng trong Quý 2 năm 2026
SELECT NCC.MaNhaCC, NCC.TenNhaCC, NCC.SDT, NCC.DiaChi
FROM NhaCungCap NCC, HoaDonNhap HN
WHERE NCC.MaNhaCC = HN.MaNhaCC
AND YEAR(HN.NgayNhap) = 2026 
AND MONTH(HN.NgayNhap) BETWEEN 4 AND 6;

--1.8. Xem danh sách tên cửa hàng cùng tên quản lí cửa hàng đó
SELECT CH.TenCH, NV.TenNV AS TenQuanLy 
FROM CuaHang CH, NhanVien NV
WHERE CH.MaNVQL = NV.MaNV;

--1.9.  Liệt kê các sản phẩm đã được bán thực tế
SELECT SP.MaSP, SP.TenSP, CT.MaHDXuat, CT.SoLuong, SP.GiaSP
FROM SanPham SP, ChiTietHDXuat CT
WHERE SP.MaSP = CT.MaSP;

--1.10. Hiển thị mã hóa đơn xuất, ngày lập và tên nhân viên bán hàng
SELECT HD.MaHDXuat, NV.TenNV, HD.NgayXuat 
FROM HoaDonXuat HD, NhanVien NV
WHERE HD.MaNV = NV.MaNV;

--Mức 3: Gom nhóm và thống kê, truy vấn lồng nhau
--1.11. Đưa ra tổng lương của từng nhân viên theo từng cửa hàng 
SELECT CH.MaCH, CH.TenCH, SUM(NV.Luong) AS N'Tổng lương'
FROM NhanVien NV, CuaHang CH
WHERE NV.MaCH = CH.MaCH
GROUP BY CH.MaCH, CH.TenCH;

--1.12. Thống kê số lần bán và tổng số lượng xuất kho của từng sản phẩm
SELECT MaSP, COUNT(MaHDXuat) AS SoLanXuat, SUM(SoLuong) AS TongSoLuongBan 
FROM ChiTietHDXuat 
GROUP BY MaSP;

--1.13. Thống kê mức lương trung bình, nhỏ nhất và lớn nhất theo giới tính nhân viên
SELECT GioiTinh, 
       AVG(Luong) AS LuongTrungBinh, 
       MIN(Luong) AS LuongThapNhat, 
       MAX(Luong) AS LuongCaoNhat 
FROM NhanVien 
GROUP BY GioiTinh;

--1.14. Lọc các sản phẩm có tổng số lượng nhập kho từ 50 chiếc trở lên
SELECT MaSP, SUM(SoLuong) AS TongNhap 
FROM ChiTietHDNhap 
GROUP BY MaSP 
HAVING SUM(SoLuong) >= 50;

--1.15. Tìm thông tin nhân viên có mức lương cao nhất công ty
SELECT MaNV, TenNV, Luong 
FROM NhanVien 
WHERE Luong = (SELECT MAX(Luong) FROM NhanVien);

--1.16.Chuyển họ tên nhân viên về chữ thường và đo độ dài chuỗi tên
SELECT LOWER(TenNV) AS TenThuong, LEN(TenNV) AS DoDaiTen 
FROM NhanVien;

--1.17. Lọc danh sách khách hàng có độ tuổi từ 30 tuổi trở lên 
SELECT TenKhach, NgaySinh, (YEAR(GETDATE()) - YEAR(NgaySinh)) AS Tuoi 
FROM KhachHang 
WHERE (YEAR(GETDATE()) - YEAR(NgaySinh)) >= 30;

--1.18.Tìm mã những nhân viên chưa từng lập bất kỳ một hóa đơn xuất bán nào
SELECT MaNV FROM NhanVien 
EXCEPT 
SELECT MaNV FROM HoaDonXuat;

--1.19. Tìm mã nhân viên vừa quản lý cửa hàng vừa đứng tên lập đơn nhập hàng
SELECT MaNVQL FROM CuaHang 
INTERSECT 
SELECT MaNVQL FROM HoaDonNhap;

--1.20. Hợp nhất danh bạ liên hệ của Cửa hàng và Nhà cung cấp vào một danh sách
SELECT TenCH AS TenDonVi, DiaChi, SDT FROM CuaHang 
UNION 
SELECT TenNhaCC AS TenDonVi, DiaChi, SDT FROM NhaCungCap;

--1.21. Liệt kê thông tin các sản phẩm hiện có phiếu bảo hành còn hạn
SELECT MaSP, TenSP, GiaSP 
FROM SanPham 
WHERE MaSP IN (SELECT MaSP FROM BaoHanh WHERE TrangThai = N'Còn hạn');