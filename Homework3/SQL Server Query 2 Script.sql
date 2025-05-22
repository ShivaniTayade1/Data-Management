DROP TABLE IF EXISTS #Destination;
GO

---------------------
CREATE TABLE #Destination
(
ID			INTEGER PRIMARY KEY,
Name		VARCHAR(100)
);
GO

---------------------
INSERT INTO #Destination VALUES
(1, 'Warsaw'),
(2,	'Berlin'),
(3, 'Bucharest'),
(4, 'Prague');
GO

DROP TABLE IF EXISTS #Ticket;
GO

---------------------
CREATE TABLE #Ticket
(
CityFrom	INTEGER,
CityTo		INTEGER,
Cost		INTEGER
);
GO

---------------------
INSERT INTO #Ticket VALUES
(1, 2, 350),
(1, 3, 80),
(1, 4, 220),
(2, 3, 410),
(2, 4, 230),
(3, 2, 160),
(3, 4, 110),
(4, 2, 140),
(4, 3, 75);
GO