/* =========================================================
   01 - KutuphaneDB Olusturma ve Semasi
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   Bu script; veritabanini, semayi ve constraint'leri olusturur.
   Calistirma: SSMS 'master' uzerinde F5, ya da:
     sqlcmd -S localhost\SQLEXPRESS -E -i 01_KutuphaneDB_Olustur.sql
   ========================================================= */

USE master;
GO

-- Varsa eskisini bosalt (test tekrarlari icin)
IF DB_ID(N'KutuphaneDB') IS NOT NULL
BEGIN
    ALTER DATABASE KutuphaneDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE KutuphaneDB;
END
GO

-- Veritabani olustur (data ve log dosyalari varsayilan konumda)
CREATE DATABASE KutuphaneDB;
GO

USE KutuphaneDB;
GO

-- ===========================
-- Tablolar
-- ===========================

CREATE TABLE dbo.Kategoriler (
    KategoriID   INT IDENTITY(1,1) PRIMARY KEY,
    Ad           NVARCHAR(80)  NOT NULL UNIQUE,
    Aciklama     NVARCHAR(255) NULL
);

CREATE TABLE dbo.Yazarlar (
    YazarID      INT IDENTITY(1,1) PRIMARY KEY,
    Ad           NVARCHAR(80)  NOT NULL,
    Soyad        NVARCHAR(80)  NOT NULL,
    DogumYili    INT           NULL,
    Ulke         NVARCHAR(60)  NULL
);

CREATE TABLE dbo.Kitaplar (
    KitapID      INT IDENTITY(1,1) PRIMARY KEY,
    ISBN         VARCHAR(20)   NOT NULL UNIQUE,
    Baslik       NVARCHAR(200) NOT NULL,
    YazarID      INT           NOT NULL REFERENCES dbo.Yazarlar(YazarID),
    KategoriID   INT           NOT NULL REFERENCES dbo.Kategoriler(KategoriID),
    YayinYili    INT           NULL,
    SayfaSayisi  INT           NULL,
    StokAdedi    INT           NOT NULL DEFAULT 1,
    EklenmeTarihi DATETIME2    NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Uyeler (
    UyeID        INT IDENTITY(1,1) PRIMARY KEY,
    TCKimlikNo   CHAR(11)      NOT NULL UNIQUE,
    Ad           NVARCHAR(80)  NOT NULL,
    Soyad        NVARCHAR(80)  NOT NULL,
    Email        NVARCHAR(120) NULL UNIQUE,
    Telefon      VARCHAR(20)   NULL,
    KayitTarihi  DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    Aktif        BIT           NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Oduncler (
    OduncID          INT IDENTITY(1,1) PRIMARY KEY,
    KitapID          INT       NOT NULL REFERENCES dbo.Kitaplar(KitapID),
    UyeID            INT       NOT NULL REFERENCES dbo.Uyeler(UyeID),
    OduncTarihi      DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    BeklenenIadeTarihi DATETIME2 NOT NULL,
    GercekIadeTarihi DATETIME2 NULL,
    Notlar           NVARCHAR(255) NULL
);

-- Sorgu performansi icin temel indeksler (projenin temel konusu degil ama iyi pratik)
CREATE INDEX IX_Kitaplar_YazarID     ON dbo.Kitaplar(YazarID);
CREATE INDEX IX_Kitaplar_KategoriID  ON dbo.Kitaplar(KategoriID);
CREATE INDEX IX_Oduncler_UyeID       ON dbo.Oduncler(UyeID);
CREATE INDEX IX_Oduncler_KitapID     ON dbo.Oduncler(KitapID);
GO

PRINT '>> KutuphaneDB ve tablolari basariyla olusturuldu.';
GO
