-- schema.sql
-- Chinook Database Schema Overview and Documentation

/*
The Chinook data model represents a digital media store, including tables for artists, 
albums, media tracks, invoices, and customers.
*/

-- 1. [Artist] table: Stores the names of music artists.
-- Primary Key: ArtistId
CREATE TABLE [Artist] (
    [ArtistId] INTEGER PRIMARY KEY,
    [Name] NVARCHAR(120)
);

-- 2. [Album] table: Stores music albums by various artists.
-- Primary Key: AlbumId
-- Foreign Key: ArtistId -> Artist(ArtistId)
CREATE TABLE [Album] (
    [AlbumId] INTEGER PRIMARY KEY,
    [Title] NVARCHAR(160) NOT NULL,
    [ArtistId] INTEGER NOT NULL,
    FOREIGN KEY ([ArtistId]) REFERENCES [Artist] ([ArtistId])
);

-- 3. [Track] table: Stores individual music/video tracks.
-- Primary Key: TrackId
-- Foreign Keys: AlbumId -> Album(AlbumId), GenreId -> Genre(GenreId), MediaTypeId -> MediaType(MediaTypeId)
CREATE TABLE [Track] (
    [TrackId] INTEGER PRIMARY KEY,
    [Name] NVARCHAR(200) NOT NULL,
    [AlbumId] INTEGER,
    [MediaTypeId] INTEGER NOT NULL,
    [GenreId] INTEGER,
    [Composer] NVARCHAR(220),
    [Milliseconds] INTEGER NOT NULL,
    [Bytes] INTEGER,
    [UnitPrice] NUMERIC(10,2) NOT NULL,
    FOREIGN KEY ([AlbumId]) REFERENCES [Album] ([AlbumId]),
    FOREIGN KEY ([GenreId]) REFERENCES [Genre] ([GenreId]),
    FOREIGN KEY ([MediaTypeId]) REFERENCES [MediaType] ([MediaTypeId])
);

-- 4. [Genre] table: List of music genres (e.g., Rock, Jazz, Metal).
-- Primary Key: GenreId
CREATE TABLE [Genre] (
    [GenreId] INTEGER PRIMARY KEY,
    [Name] NVARCHAR(120)
);

-- 5. [MediaType] table: Types of media files (e.g., MPEG, AAC).
-- Primary Key: MediaTypeId
CREATE TABLE [MediaType] (
    [MediaTypeId] INTEGER PRIMARY KEY,
    [Name] NVARCHAR(120)
);

-- 6. [Playlist] table / [PlaylistTrack]: Playlists and their association with Tracks.
CREATE TABLE [Playlist] (
    [PlaylistId] INTEGER PRIMARY KEY,
    [Name] NVARCHAR(120)
);
CREATE TABLE [PlaylistTrack] (
    [PlaylistId] INTEGER NOT NULL,
    [TrackId] INTEGER NOT NULL,
    PRIMARY KEY ([PlaylistId], [TrackId]),
    FOREIGN KEY ([PlaylistId]) REFERENCES [Playlist] ([PlaylistId]),
    FOREIGN KEY ([TrackId]) REFERENCES [Track] ([TrackId])
);

-- 7. [Customer] table: Customer contact information.
-- Primary Key: CustomerId
-- Foreign Key: SupportRepId -> Employee(EmployeeId)
CREATE TABLE [Customer] (
    [CustomerId] INTEGER PRIMARY KEY,
    [FirstName] NVARCHAR(40) NOT NULL,
    [LastName] NVARCHAR(20) NOT NULL,
    [Country] NVARCHAR(40),
    [Email] NVARCHAR(60) NOT NULL,
    [SupportRepId] INTEGER,
    FOREIGN KEY ([SupportRepId]) REFERENCES [Employee] ([EmployeeId])
);

-- 8. [Employee] table: Company staff and management hierarchy.
-- Primary Key: EmployeeId
-- Foreign Key: ReportsTo -> Employee(EmployeeId) (Self-referential)
CREATE TABLE [Employee] (
    [EmployeeId] INTEGER PRIMARY KEY,
    [LastName] NVARCHAR(20) NOT NULL,
    [FirstName] NVARCHAR(20) NOT NULL,
    [Title] NVARCHAR(30),
    [ReportsTo] INTEGER,
    [HireDate] DATETIME,
    FOREIGN KEY ([ReportsTo]) REFERENCES [Employee] ([EmployeeId])
);

-- 9. [Invoice] / [InvoiceLine]: Sales data, billing details, and itemized tracks.
CREATE TABLE [Invoice] (
    [InvoiceId] INTEGER PRIMARY KEY,
    [CustomerId] INTEGER NOT NULL,
    [InvoiceDate] DATETIME NOT NULL,
    [BillingCountry] NVARCHAR(40),
    [Total] NUMERIC(10,2) NOT NULL,
    FOREIGN KEY ([CustomerId]) REFERENCES [Customer] ([CustomerId])
);
CREATE TABLE [InvoiceLine] (
    [InvoiceLineId] INTEGER PRIMARY KEY,
    [InvoiceId] INTEGER NOT NULL,
    [TrackId] INTEGER NOT NULL,
    [UnitPrice] NUMERIC(10,2) NOT NULL,
    [Quantity] INTEGER NOT NULL,
    FOREIGN KEY ([InvoiceId]) REFERENCES [Invoice] ([InvoiceId]),
    FOREIGN KEY ([TrackId]) REFERENCES [Track] ([TrackId])
);
