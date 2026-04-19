/* =========================================================
   05 - FARK (DIFFERENTIAL) Yedekleme
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   Fark yedek:
     - SON TAM yedekten bu yana DEGISMIS data page'lerini icerir
     - Tam yedekten kucuktur, restore sirasinda ikinci adim olarak uygulanir
     - Cakisan bir fark yedek, kendinden onceki fark yedegi "geride birakir"

   On hazirlik: 04 scripti ile tam yedek alinmis olmali.
   Demo amaciyla bazi degisiklikler yapiyoruz ki fark yedegi dolu olsun.
   ========================================================= */

USE KutuphaneDB;
GO

-- Fark yedek dolu olsun diye birkac degisiklik
INSERT INTO dbo.Kategoriler (Ad, Aciklama)
VALUES (N'Siir', N'Siir ve sair antolojileri');

UPDATE dbo.Kitaplar SET StokAdedi = StokAdedi + 1 WHERE KitapID <= 5;

INSERT INTO dbo.Uyeler (TCKimlikNo, Ad, Soyad, Email) VALUES
('10000000031', N'Gokhan', N'Aydogdu', 'gokhan.aydogdu@ornek.com');
GO

USE master;
GO

DECLARE @backupPath NVARCHAR(400) = N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\';
DECLARE @file NVARCHAR(400) = @backupPath + N'KutuphaneDB_DIFF_' +
    REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), SYSDATETIME(), 126), ':',''), '-',''), 'T','_') +
    N'.bak';

PRINT '>> Hedef dosya: ' + @file;

BACKUP DATABASE KutuphaneDB
    TO DISK = @file
    WITH
        DIFFERENTIAL,           -- *** fark yedek anahtari ***
        FORMAT,
        INIT,
        NAME = N'KutuphaneDB-Differential Backup',
        -- COMPRESSION,    -- Express Edition desteklemiyor
        STATS = 10,
        CHECKSUM;
GO

-- Yedek gecmisini listele (FULL 'D', DIFFERENTIAL 'I', LOG 'L')
SELECT TOP 5
    database_name, type, backup_start_date, backup_finish_date,
    backup_size/1024.0/1024.0 AS size_mb
FROM msdb.dbo.backupset
WHERE database_name = N'KutuphaneDB'
ORDER BY backup_start_date DESC;
GO

PRINT '>> Fark yedek alma islemi tamamlandi.';
GO
