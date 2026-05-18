USE YemekSiparisiDB;
GO


-- 1. Müþteriler Tablosu
CREATE TABLE Musteriler (
    MusteriID INT IDENTITY(1,1) PRIMARY KEY, -- Otomatik artan ID
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE NOT NULL, -- Tekrarlanamaz ve boþ geçilemez
    Email VARCHAR(100) UNIQUE,
    IsVerifiedNeed BIT DEFAULT 0, -- 1: Ýhtiyaç sahibi, 0: Normal müþteri
    IsActive BIT DEFAULT 1 -- Soft delete için 
);

-- 2. Restoranlar Tablosu
CREATE TABLE Restoranlar (
    RestoranID INT IDENTITY(1,1) PRIMARY KEY,
    Ad VARCHAR(100) NOT NULL,
    Sehir VARCHAR(50) NOT NULL,
    Puan DECIMAL(3,2) CHECK (Puan BETWEEN 1 AND 5), -- Yönergede istenen CHECK kýsýtlamasý 
    Bakiye DECIMAL(10,2) DEFAULT 0 CHECK (Bakiye >= 0), -- Eksi bakiye olamaz
    IsActive BIT DEFAULT 1
);

-- 3. Kuryeler Tablosu
CREATE TABLE Kuryeler (
    KuryeID INT IDENTITY(1,1) PRIMARY KEY,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE NOT NULL,
    Durum VARCHAR(20) DEFAULT 'Musait', -- Musait, Yolda, Mesgul vs.
    IsActive BIT DEFAULT 1
);

-- 4. Askýda Yemek Baþvurularý Tablosu (Ýhtiyaç Sahiplerini Doðrulamak Ýçin)
CREATE TABLE AskidaBasvurulari (
    BasvuruID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT FOREIGN KEY REFERENCES Musteriler(MusteriID), -- Müþteri tablosuna FK baðlantýsý [cite: 13]
    BasvuruTarihi DATETIME DEFAULT GETDATE(),
    OnayDurumu VARCHAR(20) DEFAULT 'Bekliyor', -- Bekliyor, Onaylandi, Reddedildi
    IsActive BIT DEFAULT 1
);

-- 5. Baðýþlar Tablosu (Askýda Bakiye Havuzu)
CREATE TABLE Bagislar (
    BagisID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT FOREIGN KEY REFERENCES Musteriler(MusteriID),
    Tutar DECIMAL(10,2) NOT NULL CHECK (Tutar > 0), -- 0 veya negatif baðýþ yapýlamaz [cite: 14]
    BagisTarihi DATETIME DEFAULT GETDATE(),
    IsAnonymous BIT DEFAULT 0, -- 1 ise isim gizli, 0 ise açýk [cite: 7]
    IsActive BIT DEFAULT 1
);



-- 6. Ürünler (Menü) Tablosu
CREATE TABLE Urunler (
    UrunID INT IDENTITY(1,1) PRIMARY KEY,
    RestoranID INT FOREIGN KEY REFERENCES Restoranlar(RestoranID),
    UrunAdi VARCHAR(100) NOT NULL,
    Fiyat DECIMAL(10,2) NOT NULL CHECK (Fiyat > 0), 
    IsActive BIT DEFAULT 1
);

-- 7. Sipariþler Tablosu
CREATE TABLE Siparisler (
    SiparisID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT FOREIGN KEY REFERENCES Musteriler(MusteriID),
    RestoranID INT FOREIGN KEY REFERENCES Restoranlar(RestoranID),
    KuryeID INT FOREIGN KEY REFERENCES Kuryeler(KuryeID), 
    ToplamTutar DECIMAL(10,2) NOT NULL CHECK (ToplamTutar >= 0),
    SiparisTarihi DATETIME DEFAULT GETDATE(),
    SiparisDurumu VARCHAR(50) DEFAULT 'Hazýrlanýyor',
    OdemeYontemi VARCHAR(50) DEFAULT 'Kredi Kartý',
    IsActive BIT DEFAULT 1
);

-- 8. Sipariþ Detaylarý Tablosu (M:N Ýliþkisini Çözen Köprü Tablo)
CREATE TABLE SiparisDetaylari (
    DetayID INT IDENTITY(1,1) PRIMARY KEY,
    SiparisID INT FOREIGN KEY REFERENCES Siparisler(SiparisID),
    UrunID INT FOREIGN KEY REFERENCES Urunler(UrunID),
    Adet INT NOT NULL CHECK (Adet > 0),
    BirimFiyat DECIMAL(10,2) NOT NULL CHECK (BirimFiyat > 0) 
);


-- 9. Kategoriler Tablosu 
CREATE TABLE Kategoriler (
    KategoriID INT IDENTITY(1,1) PRIMARY KEY,
    KategoriAdi VARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1
);

-- ÖNEMLÝ HAMLE: Mevcut Urunler tablosunu silmeden, içine KategoriID kolonunu ve iliþkisini (Foreign Key) ekliyoruz.
ALTER TABLE Urunler 
ADD KategoriID INT FOREIGN KEY REFERENCES Kategoriler(KategoriID);

-- 10. Müþteri Adresleri Tablosu (1 Müþterinin N tane adresi olabilir)
CREATE TABLE MusteriAdresleri (
    AdresID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT FOREIGN KEY REFERENCES Musteriler(MusteriID),
    AdresBasligi VARCHAR(50) DEFAULT 'Ev', -- Ev, Ýþ, Okul vb.
    AcikAdres VARCHAR(250) NOT NULL,
    Ilce VARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1
);

-- 11. Deðerlendirmeler Tablosu (Sipariþ bazlý restoran deðerlendirmesi)
CREATE TABLE Degerlendirmeler (
    DegerlendirmeID INT IDENTITY(1,1) PRIMARY KEY,
    SiparisID INT FOREIGN KEY REFERENCES Siparisler(SiparisID),
    Puan INT NOT NULL CHECK (Puan BETWEEN 1 AND 5), -- Yönergedeki CHECK kýsýtlamasýna ek bir örnek daha
    Yorum VARCHAR(500),
    DegerlendirmeTarihi DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);



-- 12. Adminler Tablosu (Sistem yöneticileri için baðýmsýz tablo)
CREATE TABLE Adminler (
    AdminID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciAdi VARCHAR(50) UNIQUE NOT NULL,
    Sifre VARCHAR(100) NOT NULL, -- Gerçek hayatta hashlenir
    Email VARCHAR(100) UNIQUE NOT NULL,
    IsActive BIT DEFAULT 1
);

-- 13. Ödemeler Tablosu (Her sipariþin mali hareketini tutar)
CREATE TABLE Odemeler (
    OdemeID INT IDENTITY(1,1) PRIMARY KEY,
    SiparisID INT FOREIGN KEY REFERENCES Siparisler(SiparisID),
    MusteriID INT FOREIGN KEY REFERENCES Musteriler(MusteriID),
    Tutar DECIMAL(10,2) NOT NULL CHECK (Tutar >= 0),
    OdemeYontemi VARCHAR(50) NOT NULL, -- Kredi Kartý, Nakit, Askýda Bakiye
    OdemeDurumu VARCHAR(20) DEFAULT 'Onaylandý', -- Onaylandý, Reddedildi
    OdemeTarihi DATETIME DEFAULT GETDATE()
);