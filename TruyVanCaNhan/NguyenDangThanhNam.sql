--Mức 1: Truy vấn cơ bản
--Câu 1. Lấy toàn bộ thông tin nhân viên
SELECT * FROM NhanVien;

--Câu 2. Lọc sản phẩm có giá bán trên 10 triệu
SELECT MaSP, TenSP, GiaSP 
FROM SanPham 
WHERE GiaSP > 10000000;

--Câu 3. Sắp xếp danh sách khách hàng theo hạng thành viên giảm dần
SELECT * 
FROM KhachHang 
ORDER BY HangThanhVien DESC;

--Câu 4. Tìm kiếm các cửa hàng thuộc khu vực Hà Nội
SELECT MaCH, TenCH, DiaChi 
FROM CuaHang 
WHERE DiaChi LIKE N'%Hà Nội%';

--Câu 5. Lọc các phiếu bảo hành đang còn hiệu lực
SELECT MaBH, MaSP, TrangThai 
FROM BaoHanh 
WHERE TrangThai = N'Còn hạn';

--Mức 2: Truy vấn nhiều bảng
--Câu 6.  Lấy tên sản phẩm kèm số lượng nhập chi tiết
SELECT SP.TenSP, CT.SoLuong 
FROM SanPham SP, ChiTietHDNhap CT 
WHERE SP.MaSP = CT.MaSP;

--Câu 7. Lấy tên nhân viên và tên cửa hàng đang làm việc
SELECT NV.TenNV, CH.TenCH 
FROM NhanVien NV, CuaHang CH 
WHERE NV.MaCH = CH.MaCH;

--Câu 8. Lấy mã hóa đơn xuất, tên khách hàng và ngày xuất
SELECT HD.MaHDXuat, KH.TenKhach, HD.NgayXuat 
FROM HoaDonXuat HD, KhachHang KH 
WHERE HD.SDTK = KH.SDTK;

--Câu 9. Lấy tên nhân viên phụ trách bảo hành, nội dung sửa chữa và ngày tiếp nhận
SELECT NV.TenNV, LS.NoiDungSuaChua, LS.NgayTiepNhan 
FROM LichSuBaoHanh LS, NhanVien NV
WHERE LS.MaNVBH = NV.MaNV;

--Câu 10.  Lấy tên nhà cung cấp và ngày nhập hàng
SELECT NC.TenNhaCC, HN.NgayNhap 
FROM HoaDonNhap HN, NhaCungCap NC
WHERE HN.MaNhaCC = NC.MaNhaCC;

-- Mức 3: Gom nhóm, thống kê, tập hợp và truy vấn lồng nhau:
--Câu 11.Thống kê số lượng nhân viên và tổng quỹ lương theo từng cửa hàng
SELECT MaCH, COUNT(MaNV) AS SoLuongNV, SUM(Luong) AS TongLuong 
FROM NhanVien 
GROUP BY MaCH;

--Câu 12. Tìm giá thấp nhất và cao nhất theo từng loại sản phẩm
SELECT LoaiSP, MIN(GiaSP) AS GiaThapNhat, MAX(GiaSP) AS GiaCaoNhat 
FROM SanPham 
GROUP BY LoaiSP;

--Câu 13. Lọc các cửa hàng có từ 5 nhân viên trở lên
SELECT MaCH, COUNT(MaNV) AS SoLuongNV 
FROM NhanVien 
GROUP BY MaCH 
HAVING COUNT(MaNV) >= 5;

--Câu 14. Tìm sản phẩm có giá bán cao hơn mức giá trung bình toàn hệ thống
SELECT MaSP, TenSP, GiaSP 
FROM SanPham 
WHERE GiaSP > (SELECT AVG(GiaSP) FROM SanPham);

--Câu 15. Hiển thị tên khách hàng dạng in hoa kèm số điện thoại
SELECT UPPER(TenKhach) AS TenInHoa, SDTK 
FROM KhachHang;

--Câu 16. Tìm các khách hàng chưa từng mua hàng
SELECT SDTK FROM KhachHang 
EXCEPT 
SELECT SDTK FROM HoaDonXuat;

--Câu 17. Tìm khách hàng có tháng sinh trùng với tháng hiện tại
SELECT TenKhach, NgaySinh, SDTK 
FROM KhachHang 
WHERE MONTH(NgaySinh) = MONTH(GETDATE());

--Câu 18. Tìm danh sách các sản phẩm vừa từng được nhập vừa từng được bán
SELECT MaSP FROM ChiTietHDNhap 
INTERSECT 
SELECT MaSP FROM ChiTietHDXuat;

--Câu 19. Gộp danh bạ liên hệ giữa Nhà cung cấp và Khách hàng
SELECT SDT AS LienHe, N'Nhà Cung Cấp' AS LoaiDoiTuong FROM NhaCungCap 
UNION 
SELECT SDTK AS LienHe, N'Khách Hàng' AS LoaiDoiTuong FROM KhachHang;

--Câu 20. Tìm nhân viên có mức lương vượt mức lương trung bình toàn công ty
SELECT TenNV, Luong 
FROM NhanVien 
WHERE Luong > (SELECT AVG(Luong) FROM NhanVien);
