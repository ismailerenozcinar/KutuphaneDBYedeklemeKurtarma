/* =========================================================
   07 - FELAKET SENARYOSU
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   Simulasyon:
     "Operatorun biri WHERE unutarak DELETE atti."
     Simdi KutuphaneDB'deki tum Uyeler silinmis gibi davranacagiz.

   ONEMLI: Bu scripti demo ortaminda calistirin. Calistirmadan ONCE
   kritik bir zamani not alin -> point-in-time restore bu noktaya donecek.
   ========================================================= */

USE KutuphaneDB;
GO

-- 1) Felaketten ONCEKI durumu gozleyelim ve zamani not alalim
DECLARE @feci_saat DATETIME2 = SYSDATETIME();
PRINT '>> Felaket ONCESI zaman damgasi: ' + CONVERT(VARCHAR(30), @feci_saat, 121);
PRINT '>> Bu zamana kadar OLAN durumu point-in-time ile geri alacagiz.';

SELECT COUNT(*) AS OncesindeUyeSayisi FROM dbo.Uyeler;

-- 2) Biraz bekleyip felaket oncesi ile sonrasi arasinda LSN/zaman farki olusturalim
WAITFOR DELAY '00:00:05';
GO

-- 3) FELAKET: "yanlislikla" tum uyeleri sil
BEGIN TRAN;
    DELETE FROM dbo.Oduncler;   -- FK yuzunden once cocuk kayitlar
    DELETE FROM dbo.Uyeler;
COMMIT;
GO

SELECT COUNT(*) AS SonrasindaUyeSayisi   FROM dbo.Uyeler;
SELECT COUNT(*) AS SonrasindaOduncSayisi FROM dbo.Oduncler;
GO

PRINT '>> FELAKET tamamlandi. Simdi 08 scripti ile point-in-time restore yapacagiz.';
PRINT '>> Restore STOPAT parametresi icin yukarida yazdirilan "Felaket ONCESI" zamani kullanin.';
GO

/* =========================================================
   SONRAKI ADIM:
   1) Once bir "TAIL-LOG" yedegi alinmali ki felaket sonrasi log da korunsun.
      Bunu 08 scriptinde yapiyoruz (NORECOVERY ile).
   2) Sonra: FULL (NORECOVERY) -> DIFF (NORECOVERY) -> LOG'lar -> LOG (STOPAT=...)
   ========================================================= */
