CREATE TABLE Sach (
    MaSach CHAR(20) PRIMARY KEY NOT NULL,
    TieuDe CHAR(50) NOT NULL,
    TacGia VARCHAR(30) NOT NULL,
    NhaXb VARCHAR(30) NOT NULL,
    SoLuong INT DEFAULT 1,
    DonGia INT DEFAULT 10
);
CREATE TABLE MuaHang (
    MaKH CHAR(6),
    MaSach CHAR(20),
    NgayMua SMALLDATETIME,
    SoLuong INT,
    PRIMARY KEY (MaKH, MaSach),
    FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)
);
CREATE TABLE KhachHang (
    MaKH CHAR(6) PRIMARY KEY NOT NULL,
    TenKH VARCHAR(30) NOT NULL,
    DiaChi VARCHAR(50),
    KhuVuc VARCHAR(30),
    TenNguoiGT VARCHAR(30)
);


----------
INSERT INTO Sach (MaSach, TieuDe, TacGia, NhaXb, SoLuong, DonGia)
VALUES 
('1', 'C#', 'ThuTV', 'LD', 5, 25000),
('2', 'Java', 'DuyDT', 'LD', 10, 40000),
('3', 'Lap Trinh C', 'LamVT', 'NXB', 4, 32000),
('4', 'Advanced Java', 'ThuTV', 'NXB', 10, 60000),
('5', 'SQL server', 'DuyDT', 'NXB', 7, 20000),
('6', '.NET', 'LamVT', 'LD', 10, 55000);
-------
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, KhuVuc, TenNguoiGT)
VALUES 
('KH1', 'A', 'HN', '1', 'X'),
('KH2', 'B', 'HP', '2', 'X'),
('KH3', 'C', 'TPHCM', '3', 'X'),
('KH4', 'D', 'HN', '1', 'X'),
('KH5', 'E', 'HP', '2', 'X');
--------
INSERT INTO MuaHang (MaKH, MaSach, NgayMua, SoLuong)
VALUES 
('KH1', '1', '2009-01-01', 2),
('KH1', '5', '2009-01-01', 1),
('KH2', '1', '2009-11-03', 1),
('KH3', '3', '2008-01-12', 5),
('KH4', '2', '2008-08-08', 2),
('KH5', '4', '2009-03-02', 1),
('KH3', '1', '2008-09-05', 3);
--
SELECT *fROM Sach;
SELECT *fROM MuaHang;
SELECT *fROM KhachHang;
--1 Hiển thị TieuDe, TacGia, DonGia của tất cả các quyển sách.
SELECT TieuDe, TacGia, DonGia
FROM Sach;


--2Hiểu thị thông tin của các quyển sách có giá > 30000
SELECT *
FROM Sach
WHERE DonGia > 30000;

--3 Hiển thị thông tin của những quyển sách có giá trong khoảng từ 30000-50000
SELECT *
FROM Sach
WHERE DonGia BETWEEN 30000 AND 50000;

--4 Đếm số lượng những quyển sách của tác giả DuyDT
SELECT COUNT(*)
FROM Sach
WHERE TacGia = 'DuyDT';

--5 Tính tổng số lượng sách đã bán
SELECT SUM(SoLuong)
FROM MuaHang;

 --6 Tính giá trung bình của những quyển sách viết bởi tác giả ThuTV
SELECT AVG(DonGia)
FROM Sach
WHERE TacGia = 'ThuTV';

--7 Hiển thị tên KH và Tên sách được mua vào năm 2009.
SELECT KhachHang.TenKH, Sach.TieuDe
FROM KhachHang, MuaHang, Sach
WHERE KhachHang.MaKH = MuaHang.MaKH
AND MuaHang.MaSach = Sach.MaSach
AND YEAR(MuaHang.NgayMua) = 2009;

--8 Đếm xem có bao nhiêu quyển sách được bán vào tháng 1 năm 2009
SELECT COUNT(*)
FROM MuaHang
WHERE MONTH(NgayMua) = 1 AND YEAR(NgayMua) = 2009;

--9  Hiển thị tên KH, tên sách, số ngày mua tính đến thời điểm hiên tại (sắp xếp theo số ngày mua)
SELECT KhachHang.TenKH, Sach.TieuDe, DATEDIFF(day, MuaHang.NgayMua, GETDATE()) AS SoNgayMua
FROM KhachHang, MuaHang, Sach
WHERE KhachHang.MaKH = MuaHang.MaKH
AND MuaHang.MaSach = Sach.MaSach
ORDER BY SoNgayMua;

--10 Hiển thị tên KH, tên sách, số ngày dc mua (tính đến ngày hiện tại) của quyển sách được bán gần đây nhất
SELECT TOP 1 KhachHang.TenKH, Sach.TieuDe, DATEDIFF(day, MuaHang.NgayMua, GETDATE()) AS SoNgayMua
FROM KhachHang, MuaHang, Sach
WHERE KhachHang.MaKH = MuaHang.MaKH
AND MuaHang.MaSach = Sach.MaSach
ORDER BY MuaHang.NgayMua DESC;

--11 Hiển thị danh sách các tác giả và giá trung bình của những quyển sách họ viết.
SELECT TacGia, AVG(DonGia) AS GiaTrungBinh
FROM Sach
GROUP BY TacGia;

--12 Hiển thị TenKH và số lượng những quyển sách họ mua
SELECT KhachHang.TenKH, COUNT(*) AS SoLuongSachMua
FROM KhachHang, MuaHang
WHERE KhachHang.MaKH = MuaHang.MaKH
GROUP BY KhachHang.TenKH;

--13 Hiển thị tên 3 quyển sách có số lượng bán ra nhiều nhất
SELECT TOP 3 TieuDe, 
    (SELECT SUM(SoLuong) FROM MuaHang WHERE MuaHang.MaSach = Sach.MaSach) AS SoLuongBanRa
FROM Sach
ORDER BY SoLuongBanRa DESC;

--14 Hiển thị TenKH mua nhiều sách nhất.
SELECT TOP 1 KhachHang.TenKH, COUNT(*) AS SoLuongSachMua
FROM KhachHang, MuaHang
WHERE KhachHang.MaKH = MuaHang.MaKH
GROUP BY KhachHang.TenKH
ORDER BY SoLuongSachMua DESC;


--15 Tìm quyển sách có giá thành đắt nhất và rẻ nhất
-- Quyển sách có giá thành đắt nhất
SELECT TOP 1 TieuDe, DonGia
FROM Sach
ORDER BY DonGia DESC;
-- Quyển sách có giá thành rẻ nhất
SELECT TOP 1 TieuDe, DonGia
FROM Sach
ORDER BY DonGia ASC;

--16 Tăng những quyển sách có giá < 50000 lên 10%.
UPDATE Sach
SET DonGia = DonGia * 1.1
WHERE DonGia < 50000;

--17 Xóa từ bảng MuaHang những quyển sách dc mua 6 tháng trở về trước.
DELETE FROM MuaHang
WHERE NgayMua < DATEADD(month, -6, GETDATE());
