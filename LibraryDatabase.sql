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
INSERT INTO BookTypes (TypeOfBook) VALUES ('Lektira'),('Umjetnička'),('Znanstvena'),('Biografija'),('Stručna');
INSERT INTO Genders (Gender) VALUES ('Muškarac'),('Žena'),('Nepoznato'),('Ostalo');
INSERT INTO AuthorshipTypes (TypeOfAuthorship) VALUES ('Glavni'),('Sporedni');
--------------------------------------------------------------
--Library
CREATE TABLE Libraries(
	LibraryId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	StartWorkTime TIME,
	EndWorkTime TIME
);

CREATE TABLE Countries(
	CountryId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Population INT,
	AverageSalary NUMERIC
);
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
	