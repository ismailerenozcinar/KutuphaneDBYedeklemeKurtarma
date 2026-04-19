/* =========================================================
   10 - ZAMANLAYICILARLA OTOMATIK YEDEKLEME
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   SEÇENEK A: SQL Server Agent Job (Developer/Standard/Enterprise)
   SEÇENEK B: Windows Task Scheduler + sqlcmd (Express icin)

   ASAGIDAKI KOD SEÇENEK A icindir. Express'te Agent olmadigi icin
   asagida B secenegi "ornek komut satiri" olarak anlatildi.
   ========================================================= */

USE msdb;
GO

-- Eger ayni adli job varsa once sil
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'KutuphaneDB - Gunluk Full Yedek')
    EXEC msdb.dbo.sp_delete_job @job_name = N'KutuphaneDB - Gunluk Full Yedek';
GO

DECLARE @jobId UNIQUEIDENTIFIER;

EXEC msdb.dbo.sp_add_job
    @job_name = N'KutuphaneDB - Gunluk Full Yedek',
    @enabled = 1,
    @description = N'Proje 2: Her gece 02:00''de KutuphaneDB tam yedegi',
    @job_id = @jobId OUTPUT;

EXEC msdb.dbo.sp_add_jobstep
    @job_id = @jobId,
    @step_name = N'Full Backup Adimi',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'
DECLARE @file NVARCHAR(400) =
    N''C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_FULL_'' +
    REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), SYSDATETIME(), 126), '':'',''''), ''-'',''''), ''T'',''_'') + N''.bak'';
BACKUP DATABASE KutuphaneDB TO DISK = @file
WITH INIT, FORMAT, CHECKSUM, STATS = 10;   -- COMPRESSION: Express''te desteklenmiyor, kaldirildi
',
    @on_success_action = 1,   -- quit with success
    @on_fail_action    = 2;   -- quit with failure (job history'de gorunur)

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'HerGunSaat02',
    @freq_type = 4,            -- daily
    @freq_interval = 1,        -- her gun
    @active_start_time = 020000;   -- 02:00:00

EXEC msdb.dbo.sp_attach_schedule
    @job_id = @jobId,
    @schedule_name = N'HerGunSaat02';

EXEC msdb.dbo.sp_add_jobserver
    @job_id = @jobId,
    @server_name = N'(LOCAL)';

PRINT '>> Agent Job olusturuldu: "KutuphaneDB - Gunluk Full Yedek"';
GO


/* =========================================================
   SEÇENEK B: Express icin Windows Task Scheduler + sqlcmd
   ---------------------------------------------------------
   1) .bat dosyasi olustur (yedek_al.bat):

       @echo off
       set STAMP=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
       set STAMP=%STAMP: =0%
       sqlcmd -S localhost\SQLEXPRESS -E -Q ^
        "BACKUP DATABASE KutuphaneDB TO DISK='C:\agtabanli\Proje2-VeritabaniYedeklemeVeKurtarma\backups\KutuphaneDB_FULL_%STAMP%.bak' WITH INIT, CHECKSUM;"

   2) Task Scheduler:
       - Create Basic Task -> "KutuphaneDB Yedek"
       - Trigger: Daily, 02:00
       - Action: Start a program -> yedek_al.bat

   3) Kontrol:
       - Task Scheduler History sekmesi -> son calistirilma durumu
       - backups klasorunde yeni .bak dosyasi
   ========================================================= */
