-- Mức 1: Truy vấn cơ bản
--Câu 1: In tên sản phẩm, loại sản phẩm và giá của các sản phẩm có giá trên 20 triệu đồng
SELECT TenSP, LoaiSP, GiaSP
FROM SanPham
WHERE GiaSP > 20000000;

--Câu 2: In thông tin nhân viên có mức lương từ 9 triệu đồng trở lên, sắp xếp lương giảm dần
SELECT * 
FROM NhanVien
WHERE Luong >= 9000000
ORDER BY Luong DESC;

-- Câu 3: In tên khách hàng thuộc hạng thành viên Kim Cương
SELECT TenKhach
FROM KhachHang
WHERE HangThanhVien = N'Kim Cương';

-- Câu 4: In các sản phẩm có số lượng tồn kho dưới 15
SELECT MaSP, TenSP, SoLuongTon
FROM SanPham
WHERE SoLuongTon < 15;
 
-- Câu 5: Lọc các phiếu bảo hành đang còn hiệu lực
SELECT MaBH, MaSP, TrangThai 
FROM BaoHanh 
WHERE TrangThai = N'Còn hạn';

-- Câu 6: In tên nhân viên nữ có lương lớn hơn 8000000
SELECT TenNV, Luong, GioiTinh
FROM NhanVien 
WHERE GioiTinh = N'Nữ' AND Luong >= 8000000;

-- Câu 7: In hóa đơn xuất kèm tên khách hàng và tên nhân viên
SELECT HD.MaHDXuat, HD.NgayXuat,
KH.TenKhach, NV.TenNV
FROM HoaDonXuat HD, KhachHang KH, NhanVien NV
WHERE HD.SDTK = KH.SDTK
AND HD.MaNV = NV.MaNV;

-- Câu 8: In hóa đơn nhập kèm tên nhà cung cấp và nhân viên phụ trách
SELECT HD.MaHDNhap, HD.NgayNhap,
NCC.TenNhaCC, NV.TenNV
FROM HoaDonNhap HD, NhaCungCap NCC, NhanVien NV
WHERE HD.MaNhaCC = NCC.MaNhaCC
AND HD.MaNVQL = NV.MaNV;

-- Câu 9: In chi tiết hóa đơn xuất kèm tên sản phẩm
SELECT CT.MaHDXuat, SP.TenSP, CT.SoLuong
FROM ChiTietHDXuat CT, SanPham SP, HoaDonXuat HD
WHERE CT.MaSP = SP.MaSP
AND CT.MaHDXuat = HD.MaHDXuat;

-- Câu10: In tên cửa hàng và tên nhân viên thuộc cửa hàng
SELECT CH.TenCH, NV.TenNV
FROM CuaHang CH, NhanVien NV
WHERE CH.MaCH = NV.MaCH;

-- Câu 11: Tính tổng số lượng đã bán của từng sản phẩm
SELECT SP.MaSP, SP.TenSP,
SUM(CT.SoLuong)  AS TongSoLuongBan
FROM SanPham SP, ChiTietHDXuat CT
WHERE SP.MaSP = CT.MaSP
GROUP BY SP.MaSP, SP.TenSP;

-- Câu 12: In giá thấp nhất và cao nhất theo từng loại sản phẩm
SELECT LoaiSP, MIN(GiaSP) AS GiaThapNhat, MAX(GiaSP) AS GiaCaoNhat 
FROM SanPham 
GROUP BY LoaiSP;

-- Câu 13: In khách hàng có từ 2 hóa đơn xuất trở lên
SELECT KH.SDTK, KH.TenKhach,
COUNT(HD.MaHDXuat) AS SoHoaDon
FROM KhachHang KH, HoaDonXuat HD
WHERE KH.SDTK = HD.SDTK
GROUP BY KH.SDTK, KH.TenKhach
HAVING COUNT(HD.MaHDXuat) >= 2;

-- Câu 14: Tính tổng số lượng hàng nhập theo từng nhà cung cấp
SELECT NCC.MaNhaCC,NCC.TenNhaCC,
SUM(CT.SoLuong) AS TongSoLuongNhap
FROM NhaCungCap NCC, HoaDonNhap HD, ChiTietHDNhap CT
WHERE NCC.MaNhaCC = HD.MaNhaCC
AND HD.MaHDNhap = CT.MaHDNhap
GROUP BY NCC.MaNhaCC, NCC.TenNhaCC;

-- Câu 15: In tên nhân viên có mức lương trung bình, nhỏ nhất và lớn nhất 
SELECT TenNV
AVG(Luong) AS LuongTrungBinh, 
MIN(Luong) AS LuongThapNhat, 
MAX(Luong) AS LuongCaoNhat 
FROM NhanVien 
GROUP BY TenNV;

-- Câu 16: In số lượt bảo hành của các sản phẩm theo thứ tự tăng dần
SELECT SanPham.MaSP, SanPham.TenSP,
COUNT(BaoHanh.MaBH) AS SoLuotBaoHanh
FROM SanPham, BaoHanh
WHERE SanPham.MaSP = BaoHanh.MaSP
GROUP BY SanPham.MaSP, SanPham.TenSP
ORDER BY SoLuotBaoHanh ASC;

-- Câu 17: In lịch sử bảo hành kèm tên nhân viên và sản phẩm
SELECT LS.MaLSBH, LS.NgayTiepNhan,
LS.NoiDungSuaChua, NV.TenNV, SP.TenSP
FROM LichSuBaoHanh LS, NhanVien NV,
BaoHanh BH, SanPham SP
WHERE LS.MaNVBH = NV.MaNV
AND LS.MaBH = BH.MaBH
AND BH.MaSP = SP.MaSP;

-- Câu 18:In ra sản phẩm được bán ít nhất
SELECT MaSP, SUM(SoLuong) AS TongSoLuongBan
FROM ChiTietHDXuat
GROUP BY MaSP
HAVING SUM(SoLuong) <= ALL (
    SELECT SUM(SoLuong)
    FROM ChiTietHDXuat
    GROUP BY MaSP
);

-- Câu 19: In ra các sản phẩm của nhà cung cấp Apple
SELECT DISTINCT SP.MaSP, SP.TenSP, SP.GiaSP
FROM SanPham SP, ChiTietHDNhap CT, HoaDonNhap HD, NhaCungCap NCC
WHERE SP.MaSP = CT.MaSP
AND CT.MaHDNhap = HD.MaHDNhap
AND HD.MaNhaCC = NCC.MaNhaCC
AND NCC.TenNhaCC = N'Apple';

-- Câu 20: In thôn tin các khách hàng có họ Trần
SELECT *
FROM KhachHang 
WHERE TenKhach LIKE N'Trần%';
