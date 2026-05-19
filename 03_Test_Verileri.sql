USE YemekSiparisiDB;
GO

-- Önce eski verileri temizleyelim (Hata almamak için sýrayla)
DELETE FROM Degerlendirmeler;
DELETE FROM Odemeler;
DELETE FROM SiparisDetaylari;
DELETE FROM Siparisler;
DELETE FROM Urunler;
DELETE FROM Kategoriler;
DELETE FROM Bagislar;
DELETE FROM AskidaBasvurulari;
DELETE FROM MusteriAdresleri;
DELETE FROM Kuryeler;
DELETE FROM Restoranlar;
DELETE FROM Musteriler;
DELETE FROM Adminler;

-- 1. KATEGORÝLER
INSERT INTO Kategoriler (KategoriAdi) VALUES ('Kebaplar'), ('Pideler & Çorbalar'), ('Kahvaltý'), ('Deniz Ürünleri'), ('Burger & Fast Food');

-- 2. MÜÞTERÝLER
INSERT INTO Musteriler (Ad, Soyad, Telefon, Email, IsVerifiedNeed) VALUES 
('Ahmet', 'Yýlmaz', '05551112233', 'ahmet@email.com', 0),
('Ayþe', 'Kaya', '05552223344', 'ayse@email.com', 0),
('Mehmet', 'Demir', '05553334455', 'mehmet@email.com', 0),
('Fatma', 'Çelik', '05554445566', 'fatma@email.com', 0),
('Mustafa', 'Þahin', '05555556677', 'mustafa@email.com', 0),
('Zeynep', 'Öztürk', '05556667788', 'zeynep@email.com', 0),
('Ali', 'Arslan', '05557778899', 'ali@email.com', 0),
('Hüseyin', 'Doðan', '05558889900', 'huseyin@email.com', 0),
('Hasan', 'Kýlýç', '05559990011', 'hasan@email.com', 0),
('Ýbrahim', 'Çetin', '05551011122', 'ibrahim@email.com', 0),
('Ýsmail', 'Kara', '05551212233', 'ismail@email.com', 0),
('Osman', 'Tekin', '05551313344', 'osman@email.com', 0),
('Eda', 'Gül', '05551414455', 'eda@email.com', 0),
('Can', 'Aydýn', '05551515566', 'can@email.com', 0),
('Burak', 'Polat', '05551616677', 'burak@email.com', 0),
('Emre', 'Yýldýz', '05551717788', 'emre@email.com', 0),
('Mert', 'Erdoðan', '05551818899', 'mert@email.com', 0),
('Kemal', 'Yavuz', '05551919900', 'kemal@email.com', 1),
('Büþra', 'Güneþ', '05552020011', 'busra@email.com', 1),
('Elif', 'Korkmaz', '05552121122', 'elif@email.com', 1);

-- 3. MÜÞTERÝ ADRESLERÝ
INSERT INTO MusteriAdresleri (MusteriID, AdresBasligi, AcikAdres, Ilce) VALUES 
(1, 'Ev', 'Cumhuriyet Cad. No:12', 'Ýpekyolu'),
(1, 'Ýþ', 'Teknokent B Blok No:5', 'Tuþba'),
(2, 'Ev', 'Sahil Yolu Sokak No:45', 'Edremit'),
(18, 'Ev', 'Yedi Kilise Cad. No:89', 'Ýpekyolu');

-- 4. ADMINLER
INSERT INTO Adminler (KullaniciAdi, Sifre, Email) VALUES ('admin_samet', '123456', 'samet@sistem.com');

-- 5. RESTORANLAR
INSERT INTO Restoranlar (Ad, Sehir, Puan, Bakiye) VALUES 
('Tuþba Kebap', 'Van', 4.8, 0),
('Ýpekyolu Pide & Lahmacun', 'Van', 4.5, 0),
('Edremit Kahvaltý Salonu', 'Van', 4.9, 0),
('Van Gölü Balýkçýsý', 'Van', 4.2, 0),
('Kodlar Vadisi Burger', 'Van', 4.7, 0);

-- 6. KURYELER
INSERT INTO Kuryeler (Ad, Soyad, Telefon) VALUES 
('Selim', 'Ak', '05001112233'), ('Murat', 'Boz', '05002223344'), ('Gökhan', 'Tepe', '05003334455'),
('Serdar', 'Ortaç', '05004445566'), ('Kenan', 'Doðulu', '05005556677');

-- 7. ÜRÜNLER (KategoriID baðlantýlarýyla beraber)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Fiyat) VALUES 
(1, 1, 'Adana Kebap', 250), (1, 1, 'Urfa Kebap', 240), (1, 1, 'Ýskender', 300), (1, 1, 'Lahmacun', 80), (1, 1, 'Ayran', 30),
(2, 2, 'Kýymalý Pide', 200), (2, 2, 'Kuþbaþýlý Pide', 220), (2, 2, 'Ezogelin Çorba', 60), (2, 2, 'Sütlaç', 80), (2, 2, 'Kola', 40),
(3, 3, 'Serpme Kahvaltý', 400), (3, 3, 'Otlu Peynir Tabaðý', 150), (3, 3, 'Murtuða', 100), (3, 3, 'Menemen', 120), (3, 3, 'Semaver Çay', 150),
(4, 4, 'Ýnci Kefali Tava', 250), (4, 4, 'Levrek Izgara', 350), (4, 4, 'Balýk Çorbasý', 120), (4, 4, 'Roka Salatasý', 80), (4, 4, 'Þalgam', 40),
(5, 5, 'Klasik Burger', 220), (5, 5, 'Cheeseburger', 240), (5, 5, 'Patates Kýzartmasý', 80), (5, 5, 'Soðan Halkasý', 70), (5, 5, 'Milkshake', 90);

-- 8. BAÐIÞLAR
INSERT INTO AskidaBasvurulari (MusteriID, OnayDurumu) VALUES (18, 'Onaylandi'), (19, 'Onaylandi'), (20, 'Onaylandi');
INSERT INTO Bagislar (MusteriID, Tutar, IsAnonymous) VALUES (1, 1500, 0), (2, 2000, 1), (5, 2000, 1);

-- 9. DÖNGÜ ÝLE 100 SÝPARÝÞ, ÖDEME VE DEÐERLENDÝRME BASMA
DECLARE @i INT = 1;
DECLARE @RastMusteri INT, @RastRestoran INT, @RastKurye INT, @RastUrun INT, @Fiyat DECIMAL(10,2), @Yontem VARCHAR(50), @SipID INT;

WHILE @i <= 100
BEGIN
    SET @RastMusteri = FLOOR(RAND() * 20) + 1;
    SET @RastRestoran = FLOOR(RAND() * 5) + 1;
    SET @RastKurye = FLOOR(RAND() * 5) + 1;
    SET @Yontem = 'Kredi Kartý';
    
    SELECT TOP 1 @RastUrun = UrunID, @Fiyat = Fiyat FROM Urunler WHERE RestoranID = @RastRestoran ORDER BY NEWID();

    -- Ýlk 5 sipariþi askýda bakiye yapalým
    IF (@i <= 5)
    BEGIN
        SET @RastMusteri = FLOOR(RAND() * 3) + 18;
        SET @Yontem = 'Askýda Bakiye';
    END

    INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, ToplamTutar, SiparisDurumu, OdemeYontemi)
    VALUES (@RastMusteri, @RastRestoran, @RastKurye, @Fiyat, 'Teslim Edildi', @Yontem);
    
    SET @SipID = SCOPE_IDENTITY();

    INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, BirimFiyat) VALUES (@SipID, @RastUrun, 1, @Fiyat);
    
    -- YENÝ: Ödemeler tablosunu besliyoruz
    INSERT INTO Odemeler (SiparisID, MusteriID, Tutar, OdemeYontemi) VALUES (@SipID, @RastMusteri, @Fiyat, @Yontem);

    -- YENÝ: Rastgele deðerlendirmeler ekliyoruz (Her 3 sipariþte bir yorum yapýlsýn)
    IF (@i % 3 = 0)
    BEGIN
        INSERT INTO Degerlendirmeler (SiparisID, Puan, Yorum) 
        VALUES (@SipID, FLOOR(RAND() * 2) + 4, 'Gayet lezzetliydi, kurye çok hýzlý geldi.');
    END

    SET @i = @i + 1;
END;
GO