-- Câu 1: In danh sách các sản phẩm
SELECT * FROM SanPham;

-- Câu 2: In địa chỉ các cửa hàng
SELECT DiaChi FROM CuaHang;

-- Câu 3: In ra các sản phẩm của Samsung
SELECT * FROM SanPham WHERE TenSP LIKE '%Samsung%';

-- Câu 4: In ra các nhân viên nam
SELECT * FROM NhanVien WHERE GioiTinh = N'Nam';

-- Câu 5: Thay đổi giá sản phẩm "VVX200PR" thành 25400000
UPDATE SanPham SET GiaSP = 25400000 WHERE MaSP = 'VVX200PR';

-- Câu 6: Cập nhật thêm sản phẩm
INSERT INTO SanPham (MaSP, TenSP, SoLuongTon, Mota, GiaSP) 
VALUES ('SN1M8', 'Sony Xperia 1 VIII', 9, N'không', 3800000);

-- Câu 7: In danh sách các nhà cung cấp ở 'TP. Hồ Chí Minh'
SELECT * FROM NhaCungCap WHERE DiaChi LIKE N'%TP. Hồ Chí Minh%';

-- Câu 8: Khách hàng mua 1 trong 2 sản phẩm S25U hoặc 17PRM (Giả sử dựa vào mã sản phẩm)
SELECT DISTINCT kh.* 
FROM KhachHang kh
JOIN HoaDonXuat hdx ON kh.SDTK = hdx.SDTK
JOIN ChiTietHDXuat ctx ON hdx.MaHDXuat = ctx.MaHDXuat
WHERE ctx.MaSP IN ('S25U', '17PRM');

-- Câu 9: Liệt kê các sản phẩm chưa từng được bán
SELECT * FROM SanPham WHERE MaSP NOT IN (SELECT MaSP FROM ChiTietHDXuat);

-- Câu 10: In ra các nhân viên nữ của cửa hàng 456 Thái Hà
SELECT nv.* 
FROM NhanVien nv
JOIN CuaHang ch ON nv.MaCH = ch.MaCH
WHERE nv.GioiTinh = N'Nữ' AND ch.DiaChi LIKE N'%456 Thái Hà%';

-- Câu 11:  In ra các sản phẩm của nhà cung cấp Apple
SELECT DISTINCT sp.* 
FROM SanPham sp
JOIN ChiTietHDNhap ctn ON sp.MaSP = ctn.MaSP
JOIN HoaDonNhap hdn ON ctn.MaHDNhap = hdn.MaHDNhap
JOIN NhaCungCap ncc ON hdn.MaNhaCC = ncc.MaNhaCC
WHERE ncc.TenNhaCC LIKE '%Apple%';

-- Câu 12: In ra các mã hoá đơn, tên sản phẩm, giá gốc, giá được giảm 20% cho hoá đơn ngày 8-3
SELECT hdx.MaHDXuat, sp.TenSP, sp.GiaSP AS GiaGoc, (sp.GiaSP * 0.8) AS GiaGiam20
FROM HoaDonXuat hdx
JOIN ChiTietHDXuat ctx ON hdx.MaHDXuat = ctx.MaHDXuat
JOIN SanPham sp ON ctx.MaSP = sp.MaSP
WHERE DAY(hdx.NgayXuat) = 8 AND MONTH(hdx.NgayXuat) = 3;

-- Câu 13: Số lượt các sản phẩm phải bảo hành từ lớn đến bé
SELECT sp.MaSP, sp.TenSP, COUNT(bh.MaBH) AS SoLuotBaoHanh
FROM SanPham sp
JOIN BaoHanh bh ON sp.MaSP = bh.MaSP
GROUP BY sp.MaSP, sp.TenSP
ORDER BY SoLuotBaoHanh DESC;

-- Câu 14: Đưa ra mức lương trung bình và các nhân viên có mức lương lớn hơn lương trung bình
SELECT *, (SELECT AVG(Luong) FROM NhanVien) AS LuongTrungBinh
FROM NhanVien
WHERE Luong > (SELECT AVG(Luong) FROM NhanVien);

-- Câu 15: Thông tin khách hàng, giá gốc và giá khuyến mại 10% cho các hoá đơn mua từ 3 sản phẩm trở lên
SELECT kh.SDTK, kh.TenKhach, hdx.MaHDXuat, 
       SUM(ctx.SoLuong * sp.GiaSP) AS GiaGoc, 
       SUM(ctx.SoLuong * sp.GiaSP) * 0.9 AS GiaKhuyenMai
FROM KhachHang kh
JOIN HoaDonXuat hdx ON kh.SDTK = hdx.SDTK
JOIN ChiTietHDXuat ctx ON hdx.MaHDXuat = ctx.MaHDXuat
JOIN SanPham sp ON ctx.MaSP = sp.MaSP
GROUP BY kh.SDTK, kh.TenKhach, hdx.MaHDXuat
HAVING SUM(ctx.SoLuong) >= 3;

-- Câu 16: Sản phẩm được bán ít nhất 
SELECT sp.MaSP, sp.TenSP, SUM(ctx.SoLuong) AS TongSoLuongBan
FROM SanPham sp
JOIN ChiTietHDXuat ctx ON sp.MaSP = ctx.MaSP
GROUP BY sp.MaSP, sp.TenSP
HAVING SUM(ctx.SoLuong) <= ALL (
    SELECT SUM(SoLuong) 
    FROM ChiTietHDXuat 
    GROUP BY MaSP
);

-- Câu 17: Khách hàng mua nhiều nhất 
SELECT kh.SDTK, kh.TenKhach, SUM(ctx.SoLuong) AS TongSoLuongMua
FROM KhachHang kh
JOIN HoaDonXuat hdx ON kh.SDTK = hdx.SDTK
JOIN ChiTietHDXuat ctx ON hdx.MaHDXuat = ctx.MaHDXuat
GROUP BY kh.SDTK, kh.TenKhach
HAVING SUM(ctx.SoLuong) >= ALL (
    SELECT SUM(ct2.SoLuong) 
    FROM HoaDonXuat hd2 
    JOIN ChiTietHDXuat ct2 ON hd2.MaHDXuat = ct2.MaHDXuat 
    GROUP BY hd2.SDTK
);

-- Câu 18: Khách hàng có tổng giá trị hoá đơn lớn nhất
SELECT kh.SDTK, kh.TenKhach, SUM(ctx.SoLuong * sp.GiaSP) AS TongGiaTri
FROM KhachHang kh
JOIN HoaDonXuat hdx ON kh.SDTK = hdx.SDTK
JOIN ChiTietHDXuat ctx ON hdx.MaHDXuat = ctx.MaHDXuat
JOIN SanPham sp ON ctx.MaSP = sp.MaSP
GROUP BY kh.SDTK, kh.TenKhach
HAVING SUM(ctx.SoLuong * sp.GiaSP) >= ALL (
    SELECT SUM(ct2.SoLuong * sp2.GiaSP)
    FROM HoaDonXuat hd2
    JOIN ChiTietHDXuat ct2 ON hd2.MaHDXuat = ct2.MaHDXuat
    JOIN SanPham sp2 ON ct2.MaSP = sp2.MaSP
    GROUP BY hd2.SDTK
);

-- Câu 19: Tìm nhân viên bán được nhiều nhất ở cửa hàng Đống Đa kèm số hoá đơn đã bán
SELECT nv.MaNV, nv.TenNV, COUNT(hdx.MaHDXuat) AS SoHoaDonDaBan
FROM NhanVien nv
JOIN CuaHang ch ON nv.MaCH = ch.MaCH
JOIN HoaDonXuat hdx ON nv.MaNV = hdx.MaNV
WHERE ch.TenCH LIKE N'%Đống Đa%' OR ch.DiaChi LIKE N'%Đống Đa%'
GROUP BY nv.MaNV, nv.TenNV
HAVING COUNT(hdx.MaHDXuat) >= ALL (
    SELECT COUNT(hd2.MaHDXuat)
    FROM NhanVien nv2
    JOIN CuaHang ch2 ON nv2.MaCH = ch2.MaCH
    JOIN HoaDonXuat hd2 ON nv2.MaNV = hd2.MaNV
    WHERE ch2.TenCH LIKE N'%Đống Đa%' OR ch2.DiaChi LIKE N'%Đống Đa%'
    GROUP BY nv2.MaNV
);
