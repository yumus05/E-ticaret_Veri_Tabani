/* =========================================================
   NOVASTORE E-TICARET VERI YONETIM SISTEMI
   SQL Server / T-SQL Proje Dosyasi
   ========================================================= */

-- 1) VERITABANI OLUSTURMA
IF DB_ID('NovaStoreDB') IS NULL
BEGIN
    CREATE DATABASE NovaStoreDB;
END;
GO

USE NovaStoreDB;
GO

-- 2) TABLOLARI OLUSTURMA


IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
GO

-- Categories
CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);
GO

-- Customers
CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);
GO

-- Products
CREATE TABLE Products
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- Orders
CREATE TABLE Orders
(
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- OrderDetails
CREATE TABLE OrderDetails
(
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- 3) KATEGORI VERILERI
INSERT INTO Categories (CategoryName)
VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yasam');
GO

-- 4) URUN VERILERI
INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES
('Laptop', 25000.00, 15, 1),
('Telefon', 18000.00, 30, 1),
('Kulaklik', 1200.00, 10, 1),
('Tisort', 300.00, 50, 2),
('Kot Pantolon', 800.00, 25, 2),
('Roman Kitap', 150.00, 40, 3),
('Bilim Kitabi', 220.00, 12, 3),
('Parfum', 900.00, 8, 4),
('Krem', 200.00, 60, 4),
('Kahve Makinesi', 3500.00, 5, 5),
('Masa Lambasi', 450.00, 18, 5);
GO

-- 5) MUSTERI VERILERI
INSERT INTO Customers (FullName, City, Email)
VALUES
('Ahmet Yilmaz', 'Istanbul', 'ahmet@gmail.com'),
('Ayse Demir', 'Ankara', 'ayse@gmail.com'),
('Mehmet Kaya', 'Izmir', 'mehmet@gmail.com'),
('Zeynep Arslan', 'Bursa', 'zeynep@gmail.com'),
('Ali Can', 'Antalya', 'ali@gmail.com'),
('Fatma Kurt', 'Adana', 'fatma@gmail.com');
GO

-- 6) SIPARIS VERILERI
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2026-04-01', 26200.00),
(2, '2026-04-03', 600.00),
(3, '2026-04-05', 750.00),
(1, '2026-04-07', 1200.00),
(4, '2026-04-10', 900.00),
(5, '2026-04-12', 3500.00),
(2, '2026-04-14', 450.00),
(6, '2026-04-15', 220.00),
(3, '2026-04-16', 18000.00),
(1, '2026-04-17', 300.00);
GO


-- 7) SIPARIS DETAY VERILERI
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
(1, 1, 1),   -- Laptop
(1, 3, 1),   -- Kulaklik
(2, 4, 2),   -- Tisort
(3, 6, 5),   -- Roman Kitap
(4, 3, 1),   -- Kulaklik
(5, 8, 1),   -- Parfum
(6, 10, 1),  -- Kahve Makinesi
(7, 11, 1),  -- Masa Lambasi
(8, 7, 1),   -- Bilim Kitabi
(9, 2, 1),   -- Telefon
(10, 4, 1);  -- Tisort
GO

-- 8) KONTROL AMACLI TABLO LISTELEME
SELECT * FROM Categories;
SELECT * FROM Products;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
GO

-- 9) SORU 1
-- Stok miktari 20'den az olan urunlerin adini ve stok miktarini,
-- stok miktarina gore azalan sirada listeleme
SELECT
    ProductName,
    Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;
GO

-- 10) SORU 2
-- Hangi musteri, hangi tarihte siparis vermis?
-- Sonucta musteri adi, sehir, siparis tarihi ve toplam tutar
SELECT
    c.FullName,
    c.City,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID;
GO

-- 11) SORU 3
-- Ahmet Yilmaz isimli musterinin aldigi urunlerin isimleri,
-- fiyatlari ve kategorileri
SELECT
    c.FullName,
    p.ProductName,
    p.Price,
    cat.CategoryName
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p
    ON od.ProductID = p.ProductID
INNER JOIN Categories cat
    ON p.CategoryID = cat.CategoryID
WHERE c.FullName = 'Ahmet Yilmaz';
GO

-- 12) SORU 4
-- Hangi kategoride toplam kac adet urun var?
SELECT
    cat.CategoryName,
    COUNT(p.ProductID) AS UrunSayisi
FROM Categories cat
LEFT JOIN Products p
    ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName;
GO

-- 13) SORU 5
-- Her musterinin sirkete kazandirdigi toplam ciro
SELECT
    c.FullName,
    SUM(o.TotalAmount) AS ToplamCiro
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY ToplamCiro DESC;
GO

-- 14) SORU 6
-- Bugunun tarihine gore siparislerin uzerinden kac gun gecti?
SELECT
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS GecenGunSayisi
FROM Orders;
GO

-- 15) VIEW OLUSTURMA
-- Musteri adi, siparis tarihi, urun adi ve adet bilgilerini
-- tek tablodaymis gibi gosteren gorunum
IF OBJECT_ID('vw_SiparisOzet', 'V') IS NOT NULL
    DROP VIEW vw_SiparisOzet;
GO

CREATE VIEW vw_SiparisOzet
AS
SELECT
    c.FullName AS MusteriAdi,
    o.OrderDate AS SiparisTarihi,
    p.ProductName AS UrunAdi,
    od.Quantity AS Adet
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p
    ON od.ProductID = p.ProductID;
GO

-- View sonucu
SELECT * FROM vw_SiparisOzet;
GO

-- 16) BACKUP KOMUTU
-- NovaStoreDB veritabaninin yedegini alma
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH FORMAT,
     INIT,
     NAME = 'NovaStoreDB-Full Backup';
GO