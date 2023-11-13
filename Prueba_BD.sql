Elegir una banda o artista que no esté en el sistema y agregarlo, junto con un disco y las canciones correspondientes.  Elegir el género adecuado (o agregarlo si no existe)
dentro de una base de datos llamada chinook, que esta conformada por 13 tablas (albums, artists, customers, employees, genres, invoice_items, invoices, media_types, playlist_track, playlist, sqlite_sequence, sqlite_stat1, track)    

2)--Elegir una banda o artista que no esté en el sistema y agregarlo, junto con un disco y las canciones correspondientes.
--Elegir el género adecuado (o agregarlo si no existe)

INSERT INTO artists (Name)
VALUES ("Luck Ra");

INSERT INTO genres (Name)
VALUES ("Cuarteto");

INSERT INTO albums (Title, ArtistId)
VALUES ("Luck", (SELECT ArtistId FROM artists WHERE Name = "Luck Ra"));


INSERT INTO tracks (Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, UnitPrice)
VALUES 
    ("La Morocha", (SELECT 349 FROM albums WHERE Title = "Luck"), 3, (SELECT 27 FROM genres WHERE Name = "Cuarteto"), "Luck Ra", 3504000, 0.99),
    ("Quiero Creer", (SELECT 349 FROM albums WHERE Title = "Luck"), 3, (SELECT 27 FROM genres WHERE Name = "Cuarteto"), "Luck Ra", 320000, 0.99),
    ("Mentirte", (SELECT 349 FROM albums WHERE Title = "Luck"), 3, (SELECT 27 FROM genres WHERE Name = "Cuarteto"), "Luck Ra", 280000, 0.99);



3)--Imagine que en la tabla de empleados por error se cargaron los números de teléfono en la columna de número de fax y a la inversa. 
--Escriba una consulta de modificación que corrija este error.

UPDATE employees
SET Phone = Fax, Fax = Phone;

4)-- Borrar todos los géneros que tengan menos de 50 canciones (borrar todo lo necesario para poder borrar estos géneros)

DELETE FROM invoice_items
WHERE TrackId IN (
    SELECT t.TrackId
    FROM genres g
    JOIN tracks t ON g.GenreId = t.GenreId
    GROUP BY t.GenreId
    HAVING COUNT(t.TrackId) < 50 )

	
DELETE FROM playlist_track
	WHERE TrackId IN (
    SELECT TrackId
    FROM tracks
    WHERE GenreId IN (
        SELECT GenreId
        FROM tracks
        GROUP BY GenreId
        HAVING COUNT(*) < 50
    )
);

FROM tracks
WHERE GenreId IN (
    SELECT GenreId
    FROM tracks
    GROUP BY GenreId
    HAVING COUNT(*) < 50
);

DELETE FROM genres
WHERE GenreId IN (
    SELECT GenreId
    FROM tracks
    GROUP BY GenreId
    HAVING COUNT(*) < 50
);

5)--En la tabla de empleados, el jefe principal tiene NULL en el campo de reportsTo.  Modificar la tabla para que tenga su propio id de empleado en ese campo.

UPDATE employees
SET reportsTo = EmployeeId
WHERE reportsTo IS NULL;

6)--Borrar todos los clientes que no tengan facturas (invoices)

DELETE FROM customers
WHERE CustomerId NOT IN (SELECT DISTINCT CustomerId FROM invoices);

7)INSERT INTO customers (FirstName, LastName, Address, City, State, Country, PostalCode, Phone, Email, SupportRepId)
SELECT 
    FirstName, 
    LastName, 
    Address, 
    City, 
    State, 
    Country, 
    PostalCode, 
    Phone, 
    Email, 
    EmployeeId AS SupportRepId
FROM employees;


UPDATE customers
SET SupportRepId = (
    SELECT reportsTo
    FROM employees
    WHERE EmployeeId = customers.SupportRepId
);

