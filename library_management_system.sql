CREATE DATABASE library;
USE library;
CREATE TABLE Novels (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    genre TEXT,
    published_year INTEGER,
    copies_available INTEGER
);
INSERT INTO Novels (book_id, title, author, genre, published_year, copies_available) VALUES
(1, 'The Alchemist', 'Paulo Coelho', 'Adventure, philosophical fiction', 1988, 7),
(2, 'Harry potter and the philospher stone', 'J.K Rowling', 'Fantasy', 1997, 10),
(3, 'To Kill a Mockingbird', 'Harper Lee', 'Classic', 1960, 4),
(4, 'Dune', 'Frank Herbert', 'Sci-Fi', 1965, 1),
(5, 'The God of small things', 'Arundhati Roy', 'Literary fiction', 1997, 0),
(6, 'A suitable boy', 'Vikram seth', 'Literary fiction', 1993, 2),
(7, 'The Hunger Games', 'Suzanne Collins', 'Sci-Fi', 2008, 3);
SELECT * FROM Novels;
CREATE TABLE Members (
    member_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    join_date DATE
);
INSERT INTO Members (member_id, name, email, join_date) VALUES
(1, 'Aisha', 'aisha@email.com', '2025-01-15'),
(2, 'Rahul', 'ravi@email.com', '2025-03-22'),
(3, 'Maria Gomez', 'maria@email.com', '2025-05-10'),
(4, 'Liam Chen', 'liam@email.com', '2026-01-05');
SELECT * FROM Members;
CREATE TABLE Loan  (
    loan_id INTEGER PRIMARY KEY,
    book_id INTEGER,
    member_id INTEGER,
    loan_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
INSERT INTO Loan (loan_id, book_id, member_id, loan_date, return_date) VALUES
(1, 1, 1, '2026-02-01', '2026-02-15'),
(2, 2, 2, '2026-02-05', NULL),
(3, 3, 1, '2026-02-10', '2026-02-20'),
(4, 5, 3, '2026-02-12', NULL),
(5, 4, 4, '2026-02-15', NULL),
(6, 2, 3, '2026-03-01', '2026-03-10'),
(7, 6, 2, '2026-03-05', NULL);
SELECT * FROM Loan;

SELECT title, author FROM Novels;

SELECT * FROM Novels WHERE published_year > 1950;

SELECT * FROM Novels WHERE genre = 'Literary fiction';

SELECT * FROM Novels ORDER BY published_year ASC;

SELECT COUNT(*) AS total_books FROM Novels;

SELECT AVG(1993) AS avg_year FROM Novels;

SELECT * FROM Novels WHERE copies_available = 0;

SELECT genre, COUNT(*) AS num_books FROM Novels GROUP BY genre;

SELECT m.name, b.title, l.loan_date, l.return_date
FROM Loans l
JOIN Members m ON l.member_id = m.member_id
JOIN Novels b ON l.book_id = l.book_id;

SELECT * FROM Novels
WHERE book_id NOT IN (SELECT DISTINCT book_id FROM Loans);
SELECT DISTINCT m.name
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
WHERE l.return_date IS NULL;

SELECT book_id, COUNT(DISTINCT member_id) AS distinct_borrowers
FROM Loans
GROUP BY book_id
HAVING COUNT(DISTINCT member_id) > 1;

SELECT m.name, COUNT(l.loan_id) AS total_loans
FROM Members m
LEFT JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.name;

SELECT genre, COUNT(*) AS num_books
FROM Novels
GROUP BY genre
ORDER BY num_books DESC
LIMIT 1;

SELECT b.title, COUNT(l.loan_id) AS times_borrowed
FROM Loan l
JOIN Novels b ON l.book_id = b.book_id
GROUP BY b.title
ORDER BY times_borrowed DESC
LIMIT 1;

CREATE TABLE Fines (
    fine_id INTEGER PRIMARY KEY,
    loan_id INTEGER,
    amount DECIMAL(5,2),
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id)
);


SELECT loan_id,
       DATEDIFF(return_date, loan_date) AS days_held,
       CASE
           WHEN DATEDIFF(return_date, loan_date) > 14
           THEN (DATEDIFF(return_date, loan_date) - 14) * 0.50
           ELSE 0
       END AS fine_amount
FROM Loan
WHERE return_date IS NOT NULL;

CREATE TABLE Reservations (
    reservation_id INTEGER PRIMARY KEY,
    book_id INTEGER,
    member_id INTEGER,
    reservation_date DATE,
    FOREIGN KEY (book_id) REFERENCES Novels(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

SELECT book_id, title
FROM Novels
WHERE copies_available = 0;

SELECT title
FROM Novels
WHERE book_id IN (
    SELECT book_id FROM Loan WHERE return_date IS NULL
);