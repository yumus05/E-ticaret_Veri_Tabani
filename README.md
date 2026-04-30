# E-Ticaret Veri Yönetim Sistemi

## Proje Hakkında
Bu proje, Microsoft SQL Server kullanılarak geliştirilmiş basit bir e-ticaret veri tabanı sistemidir. 
Proje kapsamında müşteri, ürün, kategori ve sipariş verileri ilişkisel olarak tasarlanmış ve çeşitli SQL sorguları ile analiz edilmiştir.

---

## Kullanılan Teknolojiler
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL

---

## Veri Tabanı Yapısı

Proje aşağıdaki tablolardan oluşmaktadır:

- **Categories** → Ürün kategorileri
- **Products** → Ürün bilgileri
- **Customers** → Müşteri bilgileri
- **Orders** → Siparişler
- **OrderDetails** → Sipariş detayları

Tablolar arasında Foreign Key ilişkileri kurulmuştur.

---

## Yapılan İşlemler

### Veri Tabanı Oluşturma
NovaStoreDB isimli veri tabanı oluşturulmuştur.

### Tablo Oluşturma
Tüm tablolar PRIMARY KEY ve FOREIGN KEY yapıları ile oluşturulmuştur.

### Veri Girişi
- 5 kategori
- 10+ ürün
- 6 müşteri
- 10 sipariş

örnek veriler eklenmiştir.

### SQL Sorguları
Aşağıdaki analizler gerçekleştirilmiştir:

1. Stok miktarı düşük ürünler listelenmiştir  
2. Müşteri sipariş bilgileri görüntülenmiştir  
3. Belirli bir müşterinin satın aldığı ürünler analiz edilmiştir  
4. Kategorilere göre ürün sayıları hesaplanmıştır  
5. Müşteri bazlı toplam ciro hesaplanmıştır  
6. Siparişlerin üzerinden geçen gün sayısı hesaplanmıştır  

---

## VIEW Kullanımı

`vw_SiparisOzet` isimli view oluşturulmuştur.

Bu view sayesinde:
- Müşteri adı
- Sipariş tarihi
- Ürün adı
- Adet

tek sorgu ile görüntülenebilmektedir.

---

## Backup İşlemi

Veri tabanı aşağıdaki komut ile yedeklenmiştir:

```sql
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH FORMAT, INIT;
