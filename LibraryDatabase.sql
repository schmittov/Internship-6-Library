CREATE TABLE BookTypes(
	BookTypeId SERIAL PRIMARY KEY,
	TypeOfBook VARCHAR(30) NOT NULL
);
CREATE TABLE Genders(
	GenderId SERIAL PRIMARY KEY,
	Gender VARCHAR(30) NOT NULL
);
CREATE TABLE AuthorshipTypes(
	AuthorshipTypeId SERIAL PRIMARY KEY,
	TypeOfAuthorship VARCHAR(30) NOT NULL
);
CREATE TABLE Tariffs(
	TariffId SERIAL PRIMARY KEY,
	TariffType VARCHAR(30) NOT NULL,
	TarriffStart DATE,
	TarriffEnd DATE,
	
	TariffWorkDayPrice NUMERIC NOT NULL,
	TariffWeekendPrice NUMERIC NOT NULL
);
INSERT INTO BookTypes (TypeOfBook) VALUES ('Lektira'),('Umjetnička'),('Znanstvena'),('Biografija'),('Stručna');
INSERT INTO Genders (Gender) VALUES ('Muškarac'),('Žena'),('Nepoznato'),('Ostalo');
INSERT INTO AuthorshipTypes (TypeOfAuthorship) VALUES ('Glavni'),('Sporedni');

INSERT INTO Tariffs (TariffType, TarriffStart, TarriffEnd, TariffWorkDayPrice, TariffWeekendPrice)
VALUES
    ('Ljetna', '2023-06-01', '2023-09-30', 0.30, 0.20),
    ('Radna', '2023-10-01', '2023-05-31', 0.40, 0.20);
------------------------------------------------------------------------------------------------------------------
--Library
CREATE TABLE Libraries(
	LibraryId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	StartWorkTime TIME,
	EndWorkTime TIME
);
--StartWorkTime<EndWorkTime
CREATE TABLE Countries(
	CountryId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Population INT,
	AverageSalary NUMERIC
);
--population >0
--average salary>0

--Librarian
CREATE TABLE Librarians(
	LibrarianId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	LibraryId INT REFERENCES Libraries(LibraryId)
);

CREATE TABLE LibraryMembers(
	LibraryMemberId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	LibraryId INT REFERENCES Libraries(LibraryId)
);

CREATE TABLE Authors(
	AuthorId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	DateOfBirth DATE NOT NULL,
	CountryId INT REFERENCES Countries(CountryId),
	GenderId INT REFERENCES Genders(GenderId);
);

CREATE TABLE Books(
	BookId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	BookTypeId INT REFERENCES BookTypes(BookTypeId)
);

CREATE TABLE CopyOfBooks(
	CopyOfBookId SERIAL PRIMARY KEY,
	Availability BOOL NOT NULL,
	
	BookId INT REFERENCES Books(BookId),
	LibraryId INT REFERENCES Libraries(LibraryId)
);

--connect books and authors
CREATE TABLE BookAuthors(
	BookAuthorID SERIAL PRIMARY KEY,
	AuthorshipTypeId INT REFERENCES AuthorshipTypes(AuthorshipTypeId),
	AuthorId INT REFERENCES Authors(AuthorId),
	BookId INT REFERENCES Books(BookId)
);

CREATE TABLE BookBorrowings (
    BookBorrowId SERIAL PRIMARY KEY,
    CopyOfBookId INT REFERENCES CopyOfBooks(CopyOfBookId),
    LibraryMemberId INT REFERENCES LibraryMembers(LibraryMemberId),
    
	BorrowDate DATE DEFAULT CURRENT_DATE,
   	DueDate DATE DEFAULT (CURRENT_DATE + INTERVAL '20' DAY),
	CHECK (DueDate >= BorrowDate + INTERVAL '20' DAY AND DueDate <= BorrowDate + INTERVAL '60' DAY)
);

CREATE TABLE ReturnDelay (
    ReturnDelayId SERIAL PRIMARY KEY,
	TariffId INT REFERENCES Tariffs(TariffId),

    Description VARCHAR(30) NOT NULL,
    AmountPerDay NUMERIC NOT NULL,
    DurationInDays INT NOT NULL
);
	