/* =========================================================
   04 - TAM (FULL) Yedekleme
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   Tam yedek:
     - Veritabaninin o andaki tum verisi
     - Diger yedek turleri icin "temel" (base) olusturur
     - Ilk alinmasi gereken yedek turudur
   ========================================================= */

USE master;
GO

-- Yedek klasoru yolu (KURULUM.md'ye gore izin verilmis olmali)
DECLARE @backupPath NVARCHAR(400) = N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\';
DECLARE @file       NVARCHAR(400) = @backupPath + N'KutuphaneDB_FULL_' +
    REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), SYSDATETIME(), 126), ':',''), '-',''), 'T','_') +
    N'.bak';

PRINT '>> Hedef dosya: ' + @file;

BACKUP DATABASE KutuphaneDB
    TO DISK = @file
    WITH
        FORMAT,                 -- yedek setini sifirdan olustur
        INIT,                   -- dosyayi sifirla
        NAME = N'KutuphaneDB-Full Backup',
        DESCRIPTION = N'Proje 2 icin alinan tam yedek',
        -- COMPRESSION,         -- Express Edition bunu DESTEKLEMEZ. Developer/Standard/Enterprise'da acilabilir.
        STATS = 10,             -- %10 araliklarla ilerleme
        CHECKSUM;               -- bozulma kontrolu icin checksum uret
GO

-- Alinan yedegi msdb tablosundan dogrula
SELECT TOP 5
    database_name,
    type,
    backup_start_date,
    backup_finish_date,
    backup_size/1024.0/1024.0 AS size_mb,
    recovery_model,
    has_backup_checksums
FROM msdb.dbo.backupset
WHERE database_name = N'KutuphaneDB'
ORDER BY backup_start_date DESC;
GO

PRINT '>> Tam yedek alma islemi tamamlandi.';
GO
