/* =========================================================
   02 - Ornek Veri Ekleme
   Proje 2: Yedekleme ve Felaketten Kurtarma
   -----------------------------------------
   KutuphaneDB'ye gercekci demo verisi yukler.
   ========================================================= */

USE KutuphaneDB;
GO

-- ===========================
-- Kategoriler
-- ===========================
INSERT INTO dbo.Kategoriler (Ad, Aciklama) VALUES
(N'Roman',            N'Kurgu edebiyat eserleri'),
(N'Bilim Kurgu',      N'Bilim kurgu ve fantastik eserler'),
(N'Tarih',            N'Tarihsel eserler ve biyografi'),
(N'Bilgisayar',       N'Yazilim, donanim, ag teknolojileri'),
(N'Felsefe',          N'Dusunce tarihi ve felsefi akimlar'),
(N'Cocuk',            N'0-12 yas cocuk kitaplari');
GO

-- ===========================
-- Yazarlar
-- ===========================
INSERT INTO dbo.Yazarlar (Ad, Soyad, DogumYili, Ulke) VALUES
(N'Orhan',   N'Pamuk',      1952, N'Turkiye'),
(N'Sabahattin', N'Ali',     1907, N'Turkiye'),
(N'Isaac',   N'Asimov',     1920, N'ABD'),
(N'Yuval Noah', N'Harari',  1976, N'Israil'),
(N'Andrew',  N'Tanenbaum',  1944, N'ABD'),
(N'Friedrich', N'Nietzsche', 1844, N'Almanya'),
(N'J. K.',   N'Rowling',    1965, N'Birlesik Krallik');
GO

-- ===========================
-- Kitaplar
-- ===========================
INSERT INTO dbo.Kitaplar (ISBN, Baslik, YazarID, KategoriID, YayinYili, SayfaSayisi, StokAdedi) VALUES
('978-975-08-0001-1', N'Benim Adim Kirmizi',          1, 1, 1998, 472, 5),
('978-975-08-0002-2', N'Kar',                         1, 1, 2002, 544, 3),
('978-975-08-0010-4', N'Kurk Mantolu Madonna',        2, 1, 1943, 160, 7),
('978-975-08-0011-1', N'Icimizdeki Seytan',           2, 1, 1940, 320, 4),
('978-0-553-29335-0', N'Foundation',                  3, 2, 1951, 255, 6),
('978-0-553-29336-7', N'I, Robot',                    3, 2, 1950, 224, 4),
('978-0-06-231609-7', N'Sapiens',                     4, 3, 2011, 464, 10),
('978-0-06-246731-4', N'Homo Deus',                   4, 3, 2016, 450,  8),
('978-0-13-600663-3', N'Computer Networks',           5, 4, 2010, 960,  2),
('978-0-13-359162-0', N'Modern Operating Systems',    5, 4, 2014, 1136, 2),
('978-975-08-0050-0', N'Boyle Buyurdu Zerdust',       6, 5, 1883, 352,  3),
('978-0-7475-3269-9', N'Harry Potter ve Felsefe Tasi',7, 6, 1997, 223,  9);
GO

-- ===========================
-- Uyeler (30 adet sentetik uye)
-- ===========================
INSERT INTO dbo.Uyeler (TCKimlikNo, Ad, Soyad, Email, Telefon) VALUES
('10000000001', N'Ahmet',   N'Yilmaz',   'ahmet.yilmaz@ornek.com',    '0530-000-0001'),
('10000000002', N'Mehmet',  N'Kaya',     'mehmet.kaya@ornek.com',     '0530-000-0002'),
('10000000003', N'Ayse',    N'Demir',    'ayse.demir@ornek.com',      '0530-000-0003'),
('10000000004', N'Fatma',   N'Celik',    'fatma.celik@ornek.com',     '0530-000-0004'),
('10000000005', N'Ali',     N'Sahin',    'ali.sahin@ornek.com',       '0530-000-0005'),
('10000000006', N'Zeynep',  N'Koc',      'zeynep.koc@ornek.com',      '0530-000-0006'),
('10000000007', N'Mustafa', N'Arslan',   'mustafa.arslan@ornek.com',  '0530-000-0007'),
('10000000008', N'Elif',    N'Dogan',    'elif.dogan@ornek.com',      '0530-000-0008'),
('10000000009', N'Hasan',   N'Kilic',    'hasan.kilic@ornek.com',     '0530-000-0009'),
('10000000010', N'Hatice',  N'Aslan',    'hatice.aslan@ornek.com',    '0530-000-0010'),
('10000000011', N'Ibrahim', N'Yildiz',   'ibrahim.yildiz@ornek.com',  '0530-000-0011'),
('10000000012', N'Emine',   N'Polat',    'emine.polat@ornek.com',     '0530-000-0012'),
('10000000013', N'Osman',   N'Kurt',     'osman.kurt@ornek.com',      '0530-000-0013'),
('10000000014', N'Havva',   N'Erdogan',  'havva.erdogan@ornek.com',   '0530-000-0014'),
('10000000015', N'Yusuf',   N'Aydin',    'yusuf.aydin@ornek.com',     '0530-000-0015'),
('10000000016', N'Rabia',   N'Ozdemir',  'rabia.ozdemir@ornek.com',   '0530-000-0016'),
('10000000017', N'Kemal',   N'Akin',     'kemal.akin@ornek.com',      '0530-000-0017'),
('10000000018', N'Selin',   N'Tas',      'selin.tas@ornek.com',       '0530-000-0018'),
('10000000019', N'Murat',   N'Ozturk',   'murat.ozturk@ornek.com',    '0530-000-0019'),
('10000000020', N'Leyla',   N'Avci',     'leyla.avci@ornek.com',      '0530-000-0020'),
('10000000021', N'Can',     N'Ercan',    'can.ercan@ornek.com',       '0530-000-0021'),
('10000000022', N'Deniz',   N'Soylu',    'deniz.soylu@ornek.com',     '0530-000-0022'),
('10000000023', N'Burak',   N'Simsek',   'burak.simsek@ornek.com',    '0530-000-0023'),
('10000000024', N'Seda',    N'Ergun',    'seda.ergun@ornek.com',      '0530-000-0024'),
('10000000025', N'Emre',    N'Korkmaz',  'emre.korkmaz@ornek.com',    '0530-000-0025'),
('10000000026', N'Esra',    N'Gunes',    'esra.gunes@ornek.com',      '0530-000-0026'),
('10000000027', N'Oguz',    N'Keskin',   'oguz.keskin@ornek.com',     '0530-000-0027'),
('10000000028', N'Pelin',   N'Ogut',     'pelin.ogut@ornek.com',      '0530-000-0028'),
('10000000029', N'Tolga',   N'Tekin',    'tolga.tekin@ornek.com',     '0530-000-0029'),
('10000000030', N'Naz',     N'Guler',    'naz.guler@ornek.com',       '0530-000-0030');
GO

-- ===========================
-- Odunc Kayitlari (rastgele ama deterministik)
-- ===========================
DECLARE @i INT = 1;
WHILE @i <= 60
BEGIN
    DECLARE @kitap INT = ((@i * 7) % 12) + 1;
    DECLARE @uye   INT = ((@i * 3) % 30) + 1;
    DECLARE @odunc DATETIME2 = DATEADD(DAY, -((@i * 2) % 120), SYSDATETIME());
    DECLARE @bekle DATETIME2 = DATEADD(DAY, 14, @odunc);
    DECLARE @iade  DATETIME2 = CASE WHEN @i % 3 = 0 THEN NULL ELSE DATEADD(DAY, (@i % 10), @bekle) END;

    INSERT INTO dbo.Oduncler (KitapID, UyeID, OduncTarihi, BeklenenIadeTarihi, GercekIadeTarihi)
    VALUES (@kitap, @uye, @odunc, @bekle, @iade);

    SET @i = @i + 1;
END;
GO

PRINT '>> Ornek veriler yuklendi.';
PRINT '>> Kategori : ' + CAST((SELECT COUNT(*) FROM dbo.Kategoriler) AS VARCHAR);
PRINT '>> Yazar    : ' + CAST((SELECT COUNT(*) FROM dbo.Yazarlar) AS VARCHAR);
PRINT '>> Kitap    : ' + CAST((SELECT COUNT(*) FROM dbo.Kitaplar) AS VARCHAR);
PRINT '>> Uye      : ' + CAST((SELECT COUNT(*) FROM dbo.Uyeler) AS VARCHAR);
PRINT '>> Odunc    : ' + CAST((SELECT COUNT(*) FROM dbo.Oduncler) AS VARCHAR);
GO
