/* =========================================================
   08 - POINT-IN-TIME RESTORE
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   Amac: 07'deki "yanlislikla silme" felaketinden hemen onceki ana donmek.

   Restore adim sirasi (FULL recovery modelinde):
     a) TAIL-LOG yedegi al     -> felaketten sonraki log'u da korur
     b) FULL yedek restore     -> WITH NORECOVERY
     c) DIFF yedek restore     -> WITH NORECOVERY      (varsa)
     d) Aradaki LOG yedekleri  -> WITH NORECOVERY      (varsa)
     e) Son LOG yedegi         -> WITH STOPAT = 'felaket_oncesi_zaman', RECOVERY

   Asagidaki adimlari SSMS'de tek tek calistirin; her blok arasinda sonucu kontrol edin.
   Cogu yol parametriktir; SIZIN YEDEK DOSYA ADLARINIZA gore duzenleyin.
   ========================================================= */

USE master;
GO

-- ==============================================================
-- a) TAIL-LOG yedek (felaketten sonra kalmis log'u emniyete al)
-- ==============================================================
DECLARE @tail NVARCHAR(400) =
    N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_TAIL_' +
    REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), SYSDATETIME(), 126), ':',''), '-',''), 'T','_') +
    N'.trn';

BACKUP LOG KutuphaneDB
    TO DISK = @tail
    WITH
        NO_TRUNCATE,           -- veritabani bozuk bile olsa log'u oku
        NORECOVERY,            -- veritabani "restoring" durumuna gecer
        NAME = N'KutuphaneDB-Tail Log',
        STATS = 10;
GO

-- ==============================================================
-- b) FULL yedek restore (NORECOVERY: baska yedekler gelecek)
--    Dosya adini kendi yedek klasorunuzdekiyle DEGISTIRIN:
-- ==============================================================
/* ORNEK: asagidaki sabit dosya yolunu kendi aldiginiz FULL .bak ile degistirin */
RESTORE DATABASE KutuphaneDB
    FROM DISK = N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_FULL_YYYYMMDD_HHMMSS.bak'
    WITH
        REPLACE,
        NORECOVERY,
        STATS = 10;
GO

-- ==============================================================
-- c) DIFF yedek restore (varsa) - NORECOVERY
-- ==============================================================
RESTORE DATABASE KutuphaneDB
    FROM DISK = N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_DIFF_YYYYMMDD_HHMMSS.bak'
    WITH NORECOVERY, STATS = 10;
GO

-- ==============================================================
-- d) Log yedekleri - hepsi sirasiyla NORECOVERY
--    (Birden fazlaysa ZAMAN SIRASIYLA ekleyin)
-- ==============================================================
RESTORE LOG KutuphaneDB
    FROM DISK = N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_LOG_YYYYMMDD_HHMMSS.trn'
    WITH NORECOVERY, STATS = 10;
GO

-- ==============================================================
-- e) SON log yedegi -> STOPAT ile felaket oncesine don, RECOVERY
--    STOPAT zamanini 07 scripti "Felaket ONCESI" ciktisindan alin.
-- ==============================================================
RESTORE LOG KutuphaneDB
    FROM DISK = N'C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_TAIL_YYYYMMDD_HHMMSS.trn'
    WITH
        STOPAT = '2026-04-19 12:34:56',   -- <-- KENDI "felaket oncesi" anini yazin
        RECOVERY,
        STATS = 10;
GO

-- ==============================================================
-- DOGRULAMA: uyeler geri geldi mi?
-- ==============================================================
USE KutuphaneDB;
GO

SELECT COUNT(*) AS UyeSayisi       FROM dbo.Uyeler;
SELECT COUNT(*) AS OduncSayisi     FROM dbo.Oduncler;
SELECT TOP 5 * FROM dbo.Uyeler ORDER BY UyeID;
GO

PRINT '>> Point-in-Time restore tamamlandi. Silinen uye/odunc kayitlari geri gelmis olmali.';
GO
