-- Mức 1: Truy vấn cơ bản 
--Câu 1. Hiển thị danh sách khách hàng
SELECT *
FROM KhachHang;

-- Câu 2. Tìm các sản phẩm có giá trên 25 triệu đồng
SELECT MaSP, TenSP, GiaSP
FROM SanPham
WHERE GiaSP > 25000000;

-- Câu 3. Hiển thị danh sách sản phẩm iPhone
SELECT MaSP, TenSP, GiaSP
FROM SanPham
WHERE TenSP LIKE 'iPhone%';

-- Câu 4. Hiển thị nhân viên nữ có lương trên 9 triệu đồng
SELECT MaNV, TenNV, GioiTinh, Luong
FROM NhanVien
WHERE GioiTinh = 'Nữ' AND Luong > 9000000;

-- Câu 5. Hiển thị các hóa đơn xuất trong tháng 2 năm 2026
SELECT MaHDXuat, NgayXuat, SDTK
FROM HoaDonXuat
WHERE NgayXuat >= '2026-02-01' AND NgayXuat < '2026-03-01';


-- Mức 2: Truy vấn nhiều bảng sử dụng where và and
-- Câu 6. Hiển thị thông tin khách hàng và ngày mua hàng
SELECT kh.SDTK, kh.TenKhach, hd.MaHDXuat, hd.NgayXuat
FROM KhachHang kh, HoaDonXuat hd
WHERE kh.SDTK = hd.SDTK;

-- Câu 7. Hiển thị tên sản phẩm và số lượng đã bán
SELECT sp.MaSP, sp.TenSP, ct.SoLuong
FROM SanPham sp, ChiTietHDXuat ct
WHERE sp.MaSP = ct.MaSP;

-- Câu 8. Hiển thị thông tin hóa đơn xuất và nhân viên bán hàng
SELECT hd.MaHDXuat, hd.NgayXuat, nv.MaNV, nv.TenNV
FROM HoaDonXuat hd, NhanVien nv
WHERE hd.MaNV = nv.MaNV;

-- Câu 9. Hiển thị khách hàng, sản phẩm đã mua và số lượng
SELECT kh.TenKhach, sp.TenSP, ct.SoLuong
FROM KhachHang kh, HoaDonXuat hd, ChiTietHDXuat ct, SanPham sp
WHERE kh.SDTK = hd.SDTK
  AND hd.MaHDXuat = ct.MaHDXuat
  AND ct.MaSP = sp.MaSP;

-- Câu 10. Hiển thị nhân viên và cửa hàng làm việc
SELECT nv.MaNV, nv.TenNV, ch.MaCH, ch.TenCH
FROM NhanVien nv, CuaHang ch
WHERE nv.MaCH = ch.MaCH;


-- Mức 3: Gom nhóm, thống kê và truy vấn lồng nhau
-- Câu 11. Đếm số lượng nhân viên tại mỗi cửa hàng
SELECT MaCH, COUNT(*) AS SoNhanVien
FROM NhanVien
GROUP BY MaCH;

-- Câu 12. Tính tổng số lượng bán của từng sản phẩm, chỉ lấy sản phẩm bán từ 3 chiếc trở lên
SELECT sp.MaSP, sp.TenSP, SUM(ct.SoLuong) AS TongSoLuongBan
FROM SanPham sp, ChiTietHDXuat ct
WHERE sp.MaSP = ct.MaSP
GROUP BY sp.MaSP, sp.TenSP
HAVING SUM(ct.SoLuong) >= 3;

-- Câu 13. Tính lương trung bình của nhân viên tại mỗi cửa hàng, chỉ lấy cửa hàng có lương trung bình trên 8 triệu
SELECT MaCH, AVG(Luong) AS LuongTrungBinh
FROM NhanVien
GROUP BY MaCH
HAVING AVG(Luong) > 8000000;

-- Câu 14. Tìm sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT MaSP, TenSP, GiaSP
FROM SanPham
WHERE GiaSP > (
    SELECT AVG(GiaSP)
    FROM SanPham
);

-- Câu 15. Tính tổng tiền từng hóa đơn xuất, chỉ lấy hóa đơn trên 50 triệu đồng
SELECT ct.MaHDXuat, SUM(ct.SoLuong * sp.GiaSP) AS TongTien
FROM ChiTietHDXuat ct, SanPham sp
WHERE ct.MaSP = sp.MaSP
GROUP BY ct.MaHDXuat
HAVING SUM(ct.SoLuong * sp.GiaSP) > 50000000
ORDER BY TongTien DESC;
