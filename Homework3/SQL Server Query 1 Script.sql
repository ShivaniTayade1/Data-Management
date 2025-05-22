DROP TABLE IF EXISTS #FolderHierarchy;
GO

---------------------
---------------------
CREATE TABLE #FolderHierarchy
(
ID			INTEGER PRIMARY KEY,
Name		VARCHAR(100),
ParentID	INTEGER
);
GO

---------------------
---------------------
INSERT INTO #FolderHierarchy VALUES
(1, 'my_folder', NULL),
(2,	'my_documents', 1),
(3, 'events', 2),
(4, 'meetings', 3),
(5, 'conferences', 3),
(6, 'travel', 3),
(7, 'integration', 3),
(8, 'out_of_town', 4),
(9, 'abroad', 8),
(10, 'in_town', 4);
GO