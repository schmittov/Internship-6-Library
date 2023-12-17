select * from authors
--ime, prezime, spol, država i prosječna plaća u toj državi svakom autoru
SELECT
    A.Name AS AuthorName,
    A.Surname AS AuthorSurname,
    C.Name AS CountryName,
    C.AverageSalary AS CountryAverageSalary
FROM
    Authors A
JOIN
    Countries C ON A.CountryId = C.CountryId;

--naziv i datum objave svake znanstvene knjige zajedno s imenima glavnih autora koji su na njoj radili, pri čemu imena autora moraju biti u jednoj ćeliji i u obliku 
SELECT
    A.Surname || ' ' || LEFT(A.Name, 1) || '.' AS AuthorName,
    B.Name AS BookName,
    B.PublicationDate AS PublicationDate
FROM
    Authors A
JOIN
    BookAuthors BA ON A.AuthorId = BA.AuthorId
JOIN
    Books B ON BA.BookId = B.BookId
WHERE 
    BA.AuthorshipTypeId = 1
    AND B.BookTypeId = 3;
	
--sve kombinacije (naslova) knjiga i posudbi istih u prosincu 2023.; u slučaju da neka nije ni jednom posuđena u tom periodu, prikaži je samo jednom (a na mjestu posudbe neka piše null)
SELECT
    B.Name AS BookTitle,
    MAX(BB.BorrowDate) AS LastBorrowDate
FROM
    Books B
LEFT JOIN
    CopyOfBooks COB ON B.BookId = COB.BookId
LEFT JOIN
    BookBorrowings BB ON COB.CopyOfBookId = BB.CopyOfBookId
                   AND EXTRACT(MONTH FROM BB.BorrowDate) = 12
                   AND EXTRACT(YEAR FROM BB.BorrowDate) = 2023
GROUP BY
    B.BookId, B.Name;
--top 3 knjižnice s najviše primjeraka knjiga
SELECT
    L.Name AS LibraryName,
    COUNT(COB.CopyOfBookId) AS NumberOfCopyOfBooks
FROM
    Libraries L
JOIN
    CopyOfBooks COB ON L.LibraryId = COB.LibraryId
GROUP BY
    L.LibraryId, L.Name
ORDER BY
    NumberOfCopyOfBooks DESC
LIMIT 3;
--sve autore kojima je bar jedna od knjiga izašla između 2019. i 2022.
SELECT DISTINCT
    A.Name AS Name,
    A.Surname AS Surname
FROM
    Authors A
JOIN
    BookAuthors BA ON A.AuthorId = BA.AuthorId
JOIN
    Books B ON BA.BookId = B.BookId
WHERE
    EXTRACT(YEAR FROM B.PublicationDate) BETWEEN 1019 AND 2022;
	
--ime države i broj umjetničkih knjiga po svakoj (ako su dva autora iz iste države, računa se kao jedna knjiga), gdje su države sortirane po broju živih autora od najveće ka najmanjoj 
SELECT
    C.Name AS CountryName,
    COUNT(DISTINCT B.BookId) AS NumberOfArtBooks
FROM
    Countries C
LEFT JOIN
    Authors A ON C.CountryId = A.CountryId
LEFT JOIN
    BookAuthors BA ON A.AuthorId = BA.AuthorId
LEFT JOIN
    Books B ON BA.BookId = B.BookId
WHERE
    B.BookTypeId = (SELECT BookTypeId FROM BookTypes WHERE TypeOfBook = 'Umjetnička')
GROUP BY
    C.CountryId, C.Name
ORDER BY
    COUNT(DISTINCT A.AuthorId) DESC, C.Name;
	
--autora i ime prve objavljene knjige istog
SELECT
    A.Name AS AuthorName,
    A.Surname AS AuthorSurname,
    MIN(B.PublicationDate) AS FirstBookPublicationDate,
    MIN(B.Name) AS FirstBookName
FROM
    Authors A
JOIN
    BookAuthors BA ON A.AuthorId = BA.AuthorId
JOIN
    Books B ON BA.BookId = B.BookId
GROUP BY
    A.AuthorId, A.Name, A.Surname
ORDER BY
    FirstBookPublicationDate;
	
--10 najbogatijih autora
WITH AuthorEarnings AS 
(
    SELECT
        A.Name AS AuthorName,
        A.Surname AS AuthorSurname,
        B.BookId,
        CAST(SQRT(COUNT(COB.CopyOfBookId)/COUNT(DISTINCT A.AuthorId)) AS DECIMAL (5,2)) AS Earnings
    FROM
        Authors A
    JOIN
        BookAuthors BA ON A.AuthorId = BA.AuthorId
    JOIN
        CopyOfBooks COB ON BA.BookId = COB.BookId
    JOIN
        Books B ON COB.BookId = B.BookId
    GROUP BY
        A.AuthorId, A.Name, A.Surname, B.BookId
)
SELECT
    AE.AuthorName ||' '|| AE.AuthorSurname AS AuthorName,
    AE.Earnings || ' €' AS Earnings
FROM
    AuthorEarnings AE
ORDER BY
    AE.Earnings DESC
LIMIT 10;

--po svakoj knjizi broj ljudi koji su je pročitali (korisnika koji posudili bar jednom)
SELECT
    B.BookId,
	B.Name AS BookName,
    COUNT(DISTINCT BB.LibraryMemberId) AS NumberOfReaders
FROM
    Books B
JOIN
    CopyOfBooks COB ON B.BookId = COB.BookId
LEFT JOIN
    BookBorrowings BB ON COB.CopyOfBookId = BB.CopyOfBookId
GROUP BY
    B.BookId, B.Name
ORDER BY
   NumberOfReaders DESC;
 --korisnici koji imaju trenutno posuđenu knjigu
SELECT
    LM.LibraryMemberId,
    LM.Name AS MemberName,
    LM.Surname AS MemberSurname
FROM
    LibraryMembers LM
JOIN
    BookBorrowings BB ON LM.LibraryMemberId = BB.LibraryMemberId
WHERE
    BB.BorrowDate <= CURRENT_DATE
    AND BB.DueDate >NOW()::DATE;
--broj aktivnih posudni
SELECT
    B.Name AS BookName,
    COUNT(BB.BookBorrowId) AS ActiveBorrowings
FROM
    Books B
LEFT JOIN
    CopyOfBooks COB ON B.BookId = COB.BookId
LEFT JOIN
    BookBorrowings BB ON COB.CopyOfBookId = BB.CopyOfBookId
GROUP BY
    B.BookId
HAVING
	COUNT(BB.BookBorrowId) >= 10;
    --COUNT(BB.BookBorrowId) >= 1;