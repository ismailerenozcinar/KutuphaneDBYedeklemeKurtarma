/* =========================================================
   06 - LOG (Transaction Log) Yedekleme
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   Log yedek:
     - Onceki log yedegi / tam yedekten beri olan TUM islemleri icerir
     - Point-in-Time restore icin SART
     - Sik araliklarla alinir (orn. 15 dk) -> veri kaybi riski dusuk

   On sart: Recovery model FULL, ilk tam yedek alinmis.
   ========================================================= */

USE KutuphaneDB;
GO

-- Log dolu olsun diye islemler
INSERT INTO dbo.Oduncler (KitapID, UyeID, OduncTarihi, BeklenenIadeTarihi)
VALUES (1, 1, SYSDATETIME(), DATEADD(DAY, 14, SYSDATETIME()));

UPDATE dbo.Uyeler SET Telefon = '0530-111-2233' WHERE UyeID = 1;
GO

USE master;
GO

DECLARE @backupPath NVARCHAR(400) = N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\';
DECLARE @file NVARCHAR(400) = @backupPath + N'KutuphaneDB_LOG_' +
    REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), SYSDATETIME(), 126), ':',''), '-',''), 'T','_') +
    N'.trn';

PRINT '>> Hedef dosya: ' + @file;

BACKUP LOG KutuphaneDB
    TO DISK = @file
    WITH
        FORMAT,
        INIT,
        NAME = N'KutuphaneDB-Log Backup',
        -- COMPRESSION,    -- Express Edition desteklemiyor
        STATS = 10,
        CHECKSUM;
GO

-- LSN'leri gorelim: point-in-time restore icin bunlar onemli
SELECT TOP 5
    database_name, type, backup_start_date, backup_finish_date,
    first_lsn, last_lsn,
    backup_size/1024.0 AS size_kb
FROM msdb.dbo.backupset
WHERE database_name = N'KutuphaneDB'
ORDER BY backup_start_date DESC;
GO

PRINT '>> Log yedek alma islemi tamamlandi.';
GO
