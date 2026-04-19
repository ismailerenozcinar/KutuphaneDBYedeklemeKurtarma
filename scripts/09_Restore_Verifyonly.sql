/* =========================================================
   09 - TEST YEDEKLEME SENARYOLARI (Verify + Header + CheckSum)
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   "Yedegim var" demek yeterli degil; yedegin RESTORE edilebilir oldugunu
   GARANTI eden kontrolleri burada yapiyoruz:
     1) RESTORE VERIFYONLY      -> dosyanin kurtarilabilir durumda oldugunu test eder
     2) RESTORE HEADERONLY      -> yedek metadatasini gorur (icinde ne var?)
     3) RESTORE FILELISTONLY    -> MDF/LDF mantiksal dosya adlarini listeler
     4) BACKUP ... WITH CHECKSUM + RESTORE VERIFYONLY -> checksum dogrulama
   ========================================================= */

USE master;
GO

DECLARE @fullBak NVARCHAR(400) =
    N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_FULL_YYYYMMDD_HHMMSS.bak';

-- 1) Dosyanin bozuk olup olmadigini test et
PRINT N'--- RESTORE VERIFYONLY ---';
RESTORE VERIFYONLY
    FROM DISK = @fullBak
    WITH CHECKSUM;
GO

-- 2) Yedek metadatasi: kim, ne zaman, hangi DB, hangi tip?
PRINT N'--- RESTORE HEADERONLY ---';
DECLARE @fullBak NVARCHAR(400) =
    N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_FULL_YYYYMMDD_HHMMSS.bak';
RESTORE HEADERONLY FROM DISK = @fullBak;
GO

-- 3) Icindeki mantiksal dosyalar (MDF/LDF isimleri -> MOVE ile restore icin gerekli)
PRINT N'--- RESTORE FILELISTONLY ---';
DECLARE @fullBak NVARCHAR(400) =
    N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_FULL_YYYYMMDD_HHMMSS.bak';
RESTORE FILELISTONLY FROM DISK = @fullBak;
GO

-- 4) Tarihsel basari/hata gorunumu (son 20 yedek)
PRINT N'--- Yedek gecmisi ---';
SELECT TOP 20
    bs.database_name,
    bs.type,                           -- D=Full, I=Diff, L=Log
    bs.backup_start_date,
    bs.backup_finish_date,
    bs.is_damaged,
    bs.has_backup_checksums,
    bmf.physical_device_name,
    bs.backup_size/1024.0/1024.0 AS size_mb
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf ON bmf.media_set_id = bs.media_set_id
WHERE bs.database_name = N'KutuphaneDB'
ORDER BY bs.backup_start_date DESC;
GO

PRINT '>> Yedek dogrulama testleri tamamlandi. is_damaged sutunu 0 olmalidir.';
GO
