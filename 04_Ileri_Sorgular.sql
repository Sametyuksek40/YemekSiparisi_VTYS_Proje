USE YemekSiparisiDB;
GO

-- Sorgu 1: Detaylý Sipariþ Fiþi ve Müþteri Adresi (Adres tablosu baðlandý!)
SELECT 
    s.SiparisID, m.Ad + ' ' + m.Soyad AS Musteri, ma.AcikAdres, r.Ad AS Restoran,
    u.UrunAdi, sd.Adet, s.ToplamTutar, o.OdemeYontemi
FROM Siparisler s
INNER JOIN Musteriler m ON s.MusteriID = m.MusteriID
LEFT JOIN MusteriAdresleri ma ON m.MusteriID = ma.MusteriID
INNER JOIN Restoranlar r ON s.RestoranID = r.RestoranID
INNER JOIN SiparisDetaylari sd ON s.SiparisID = sd.SiparisID
INNER JOIN Urunler u ON sd.UrunID = u.UrunID
INNER JOIN Odemeler o ON s.SiparisID = o.SiparisID
WHERE s.SiparisID = 1;

-- Sorgu 2: En Çok Beðenilen (Puaný Yüksek) Popüler Restoran Analizi (Deðerlendirme tablosu baðlandý!)
SELECT 
    r.Ad AS RestoranAdi, COUNT(s.SiparisID) AS ToplamSiparis,
    AVG(CAST(d.Puan AS DECIMAL(3,2))) AS MusteriPuanOrtalamasi, SUM(s.ToplamTutar) AS ToplamCiro
FROM Siparisler s
INNER JOIN Restoranlar r ON s.RestoranID = r.RestoranID
INNER JOIN Degerlendirmeler d ON s.SiparisID = d.SiparisID
GROUP BY r.Ad
HAVING COUNT(s.SiparisID) >= 2;

-- Sorgu 3: ALT SORGU (SUBQUERY) - Potansiyel Baðýþçý Hedefleme
-- Yönerge Ýsteri: IN, EXISTS veya NOT EXISTS içeren mantýksal bir alt sorgu.
-- Savunma Notu: Pazarlama departmanýnýn "Askýda Yemek" projesini tanýtmak için 
-- "Sistemimizi aktif kullanan ama henüz hiç baðýþ yapmamýþ" müþterileri bulmasýný saðlayan sorgu.

SELECT 
    m.MusteriID, 
    m.Ad, 
    m.Soyad,
    m.Telefon
FROM Musteriler m
WHERE m.IsActive = 1 
-- 1. Koþul: Sipariþler tablosunda bu müþterinin kaydý var mý? (Sistemi kullanýyor mu?)
AND EXISTS (SELECT 1 FROM Siparisler s WHERE s.MusteriID = m.MusteriID) 
-- 2. Koþul: Bagislar tablosunda bu müþterinin kaydý YOK mu? (Baðýþ yapmamýþ olmalý)
AND NOT EXISTS (SELECT 1 FROM Bagislar b WHERE b.MusteriID = m.MusteriID);