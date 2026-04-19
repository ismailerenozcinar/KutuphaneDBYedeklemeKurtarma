/* =========================================================
   03 - Recovery Model'i FULL'e cek
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   Neden?
   - SIMPLE modda transaction log backup alinmaz
   - Point-in-Time Restore icin FULL mod zorunludur
   ========================================================= */

USE master;
GO

-- Mevcut durumu gor
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = N'KutuphaneDB';

-- FULL recovery modeline al
ALTER DATABASE KutuphaneDB SET RECOVERY FULL;
GO

-- Degisimi dogrula
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = N'KutuphaneDB';
GO

PRINT '>> KutuphaneDB FULL recovery modeline alindi.';
GO
