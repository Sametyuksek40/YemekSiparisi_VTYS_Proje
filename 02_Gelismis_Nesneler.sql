USE YemekSiparisiDB;
GO

-- VIEW 1: Aktif Restoranlarýn Aktif Menüleri (Kategori bilgisi de eklendi!)
CREATE OR ALTER VIEW vw_AktifRestoranMenuleri AS
SELECT 
    r.Ad AS RestoranAdi, 
    k.KategoriAdi,
    u.UrunAdi, 
    u.Fiyat
FROM Urunler u
INNER JOIN Restoranlar r ON u.RestoranID = r.RestoranID
LEFT JOIN Kategoriler k ON u.KategoriID = k.KategoriID
WHERE u.IsActive = 1 AND r.IsActive = 1;
GO

-- VIEW 2: Askýda Yemek Havuz Durumu
CREATE OR ALTER VIEW vw_AskidaYemekHavuzDurumu AS
SELECT 
    (ISNULL((SELECT SUM(Tutar) FROM Bagislar WHERE IsActive = 1), 0) - 
     ISNULL((SELECT SUM(ToplamTutar) FROM Siparisler WHERE OdemeYontemi = 'Askýda Bakiye' AND SiparisDurumu <> 'Ýptal Edildi' AND IsActive = 1), 0)) AS GuncelHavuzBakiyesi;
GO

-- INDEXLER (Performans için kritik kolonlar indekslendi)
CREATE NONCLUSTERED INDEX IX_Musteriler_Telefon ON Musteriler(Telefon);
CREATE NONCLUSTERED INDEX IX_Siparisler_Durum ON Siparisler(SiparisDurumu);
CREATE NONCLUSTERED INDEX IX_Odemeler_SiparisID ON Odemeler(SiparisID); -- YENÝ: Ödemelerde hýzlý sorgulama için
GO

-- TRIGGER 1: Sipariþ "Teslim Edildi" olduðunda Restoranýn cirosunu otomatik artýrýr
CREATE OR ALTER TRIGGER trg_SiparisTeslim_CiroGuncelle
ON Siparisler
AFTER UPDATE
AS
BEGIN
    IF UPDATE(SiparisDurumu)
    BEGIN
        UPDATE r
        SET r.Bakiye = r.Bakiye + i.ToplamTutar
        FROM Restoranlar r
        INNER JOIN inserted i ON r.RestoranID = i.RestoranID
        INNER JOIN deleted d ON i.SiparisID = d.SiparisID
        WHERE i.SiparisDurumu = 'Teslim Edildi' AND d.SiparisDurumu <> 'Teslim Edildi';
    END
END;
GO

-- TRIGGER 2: Askýda Bakiye Güvenlik Kontrolü
CREATE OR ALTER TRIGGER trg_AskidaBakiye_YetkiKontrolu
ON Siparisler
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @IzinsizGiris INT;
    SELECT @IzinsizGiris = COUNT(*)
    FROM inserted i
    INNER JOIN Musteriler m ON i.MusteriID = m.MusteriID
    WHERE i.OdemeYontemi = 'Askýda Bakiye' AND m.IsVerifiedNeed = 0;

    IF (@IzinsizGiris > 0)
    BEGIN
        RAISERROR ('HATA: Sadece onaylý ihtiyaç sahipleri Askýda Bakiye ile ödeme yapabilir!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO