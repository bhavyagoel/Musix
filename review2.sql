CREATE DATABASE Musix1;

USE Musix1;

CREATE TABLE IF NOT EXISTS Register
(
    Name        VARCHAR(20) NOT NULL,
    Gender      CHAR(1),
    Address     VARCHAR(50) NOT NULL,
    Mobile      VARCHAR(20) NOT NULL UNIQUE,
    Email_ID    VARCHAR(20) NOT NULL CHECK (Email_ID LIKE '%@gmail.com') UNIQUE,
    Password    CHAR(10)    NOT NULL,
    Register_ID CHAR(7)     NOT NULL PRIMARY KEY UNIQUE CHECK ( Register_ID LIKE 'UID%')
);

CREATE TABLE IF NOT EXISTS User
(
    Name    VARCHAR(20) NOT NULL,
    DOB     DATE        NOT NULL,
    User_ID CHAR(7)     NOT NULL PRIMARY KEY UNIQUE CHECK ( User_ID LIKE 'UID%'),
    CONSTRAINT FOREIGN KEY (User_ID) REFERENCES Register (Register_ID)
);


CREATE TABLE IF NOT EXISTS Login
(
    Login_ID CHAR(7)  NOT NULL PRIMARY KEY UNIQUE CHECK ( Login_ID LIKE 'UID%'),
    Password CHAR(10) NOT NULL,
    CONSTRAINT FOREIGN KEY (Login_ID) REFERENCES Register (Register_ID)
);

CREATE TABLE IF NOT EXISTS Genre
(
    Genre_ID CHAR(7)     NOT NULL PRIMARY KEY UNIQUE CHECK ( Genre_ID LIKE 'GID%'),
    Name     VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Song
(
    Song_ID  CHAR(7)     NOT NULL PRIMARY KEY UNIQUE CHECK ( Song_ID LIKE 'SID%'),
    Name     VARCHAR(20) NOT NULL,
    Year     INT         NOT NULL,
    Duration DOUBLE      NOT NULL,
    Genre_ID CHAR(7)     NOT NULL CHECK ( Genre_ID LIKE 'GID%'),
    CONSTRAINT FOREIGN KEY (Genre_ID) REFERENCES Genre (Genre_ID)
);


CREATE TABLE IF NOT EXISTS Playlist
(
    Playlist_ID CHAR(7)     NOT NULL PRIMARY KEY UNIQUE CHECK ( Playlist_ID LIKE 'PID%'),
    User_ID     CHAR(7)     NOT NULL UNIQUE CHECK ( User_ID LIKE 'UID%'),
    Name        VARCHAR(20) NOT NULL,
    CONSTRAINT FOREIGN KEY (User_ID) REFERENCES User (User_ID)
);



CREATE TABLE IF NOT EXISTS Album
(
    Name     VARCHAR(20) NOT NULL,
    Album_ID CHAR(8)     NOT NULL PRIMARY KEY UNIQUE CHECK ( Album_ID LIKE 'ALID%')
);

CREATE TABLE IF NOT EXISTS Artist
(
    Name      VARCHAR(20) NOT NULL,
    Artist_ID CHAR(8)     NOT NULL PRIMARY KEY UNIQUE CHECK ( Artist_ID LIKE 'ARID%'),
    DOB       DATE        NOT NULL
);


CREATE TABLE IF NOT EXISTS User_Likes
(
    User_ID CHAR(7) NOT NULL CHECK ( User_ID LIKE 'UID%'),
    Song_ID CHAR(7) NOT NULL CHECK ( Song_ID LIKE 'SID%'),
    CONSTRAINT FOREIGN KEY (User_ID) REFERENCES User (User_ID),
    CONSTRAINT FOREIGN KEY (Song_ID) REFERENCES Song (Song_ID),
    CONSTRAINT UNIQUE (User_ID, Song_ID)
);

CREATE TABLE IF NOT EXISTS User_searches
(
    User_ID CHAR(7) NOT NULL CHECK ( User_ID LIKE 'UID%'),
    Song_ID CHAR(7) NOT NULL CHECK ( Song_ID LIKE 'SID%'),
    CONSTRAINT UNIQUE (User_ID, Song_ID),
    CONSTRAINT FOREIGN KEY (User_ID) REFERENCES User (User_ID),
    CONSTRAINT FOREIGN KEY (Song_ID) REFERENCES Song (Song_ID)
);

CREATE TABLE IF NOT EXISTS Song_Artist
(
    Song_ID   CHAR(7) NOT NULL CHECK ( Song_ID LIKE 'SID%'),
    Artist_ID CHAR(8) NOT NULL CHECK ( Artist_ID LIKE 'ARID%'),
    CONSTRAINT UNIQUE (Song_ID, Artist_ID),
    CONSTRAINT FOREIGN KEY (Song_ID) REFERENCES Song (Song_ID),
    CONSTRAINT FOREIGN KEY (Artist_ID) REFERENCES Artist (Artist_ID)
);

CREATE TABLE IF NOT EXISTS Interest_User_Genre
(
    User_ID  CHAR(7) NOT NULL CHECK ( User_ID LIKE 'UID%'),
    Genre_ID CHAR(7) NOT NULL CHECK ( Genre_ID LIKE 'GID%'),
    CONSTRAINT UNIQUE (User_ID, Genre_ID),
    CONSTRAINT FOREIGN KEY (User_ID) REFERENCES User (User_ID),
    CONSTRAINT FOREIGN KEY (Genre_ID) REFERENCES Genre (Genre_ID)
);

CREATE TABLE IF NOT EXISTS Interest_User_Artist
(
    User_ID   CHAR(7) NOT NULL CHECK ( User_ID LIKE 'UID%'),
    Artist_ID CHAR(8) NOT NULL CHECK ( Artist_ID LIKE 'ARID%'),
    CONSTRAINT UNIQUE (User_ID, Artist_ID),
    CONSTRAINT FOREIGN KEY (User_ID) REFERENCES User (User_ID),
    CONSTRAINT FOREIGN KEY (Artist_ID) REFERENCES Artist (Artist_ID)
);

CREATE TABLE IF NOT EXISTS Playlist_Song
(
    Playlist_ID CHAR(7) NOT NULL CHECK ( Playlist_ID LIKE 'PID%'),
    Song_ID     CHAR(7) NOT NULL CHECK ( Song_ID LIKE 'SID%'),
    CONSTRAINT FOREIGN KEY (Playlist_ID) REFERENCES Playlist (Playlist_ID),
    CONSTRAINT FOREIGN KEY (Song_ID) REFERENCES Song (Song_ID),
    CONSTRAINT UNIQUE (Playlist_ID, Song_ID)
);

CREATE TABLE IF NOT EXISTS Album_Song
(
    Album_ID CHAR(8) NOT NULL CHECK ( Album_ID LIKE 'ALID%'),
    Song_ID  CHAR(7) NOT NULL CHECK ( Song_ID LIKE 'SID%'),
    CONSTRAINT FOREIGN KEY (Album_ID) REFERENCES Album (Album_ID),
    CONSTRAINT FOREIGN KEY (Song_ID) REFERENCES Song (Song_ID),
    CONSTRAINT UNIQUE (Album_ID, Song_ID)
);



INSERT INTO Register(Name, Gender, Address, Mobile, Email_ID, Password, Register_ID)
VALUES ('Rajkumar', 'M', 'Hyderabad', 9876543210, 'rajkumar1@gmail.com', 'rajkumarrk', 'UID0001'),
       ('Karan Sharma', 'M', 'Delhi', 9876543444, 'karan245@gmail.com', 'karanram1', 'UID0002'),
       ('Priya Singh', 'F', 'Agra', 9867676761, 'priyas@gmail.com', 'praraphsps', 'UID0003'),
       ('Jayant Sharma', 'M', 'Noida', 9968218098, 'rockjay@gmail.com', 'rockisonja', 'UID0004'),
       ('Kajal Gupta', 'F', 'Kanpur', 9876543433, 'kajal456@gmail.com', 'kajalkgkgk', 'UID0005');



INSERT INTO User(Name, DOB, User_ID)
VALUES ('Rajkumar', '1989-05-05', 'UID0001'),
       ('Karan Sharma', '1990-06-06', 'UID0002'),
       ('Priya Singh', '1991-07-07', 'UID0003'),
       ('Jayant Sharma', '1992-08-08', 'UID0004'),
       ('Kajal Gupta', '1993-03-03', 'UID0005');



INSERT INTO Login(login_id, password)
VALUES ('UID0001', 'rajkumarrk'),
       ('UID0002', 'karanram1'),
       ('UID0003', 'praraphsps'),
       ('UID0004', 'rockisonja'),
       ('UID0005', 'kajalkgkgk');


INSERT INTO Genre(Genre_ID, Name)
VALUES ('GID0001', 'Jazz'),
       ('GID0002', 'Rock'),
       ('GID0003', 'Country Music'),
       ('GID0004', 'Pop Music'),
       ('GID0005', 'Classical Music');


INSERT INTO Song(Song_ID, Name, Year, Duration, Genre_ID)
VALUES ('SID0001', 'Memories', 2013, 3.54, 'GID0004'),
       ('SID0002', 'Woke up this morning', 1998, 4.08, 'GID0002'),
       ('SID0003', 'Choice', 2000, 3.12, 'GID0003'),
       ('SID0004', 'Take Five', 2011, 5.54, 'GID0001'),
       ('SID0005', 'Symphony', 2006, 3.47, 'GID0005');



INSERT INTO Playlist(Playlist_ID, User_ID, Name)
VALUES ('PID0001', 'UID0004', 'Love'),
       ('PID0002', 'UID0002', 'My Place'),
       ('PID0003', 'UID0003', 'Happy Spot'),
       ('PID0004', 'UID0001', 'On My Own'),
       ('PID0005', 'UID0005', 'Ready');

INSERT INTO Playlist_Song (Playlist_ID, Song_ID)
VALUES ('PID0001', 'SID0001'),
       ('PID0001', 'SID0002'),
       ('PID0001', 'SID0005'),
       ('PID0002', 'SID0002'),
       ('PID0002', 'SID0003'),
       ('PID0002', 'SID0004'),
       ('PID0003', 'SID0004'),
       ('PID0003', 'SID0001'),
       ('PID0003', 'SID0002'),
       ('PID0003', 'SID0003'),
       ('PID0004', 'SID0002'),
       ('PID0004', 'SID0005'),
       ('PID0004', 'SID0003'),
       ('PID0005', 'SID0003'),
       ('PID0005', 'SID0005');


INSERT INTO Album(Name, Album_ID)
VALUES ('Levine', 'ALID0001'),
       ('My Days', 'ALID0002'),
       ('Flow', 'ALID0003'),
       ('Sheeran', 'ALID0004'),
       ('Imagine Dragons', 'ALID0005');

INSERT INTO Album_Song (Album_ID, Song_ID)
VALUES ('ALID0001', 'SID0001'),
       ('ALID0001', 'SID0002'),
       ('ALID0001', 'SID0003'),
       ('ALID0002', 'SID0003'),
       ('ALID0002', 'SID0004'),
       ('ALID0002', 'SID0005'),
       ('ALID0003', 'SID0002'),
       ('ALID0003', 'SID0003'),
       ('ALID0003', 'SID0004'),
       ('ALID0004', 'SID0001'),
       ('ALID0004', 'SID0002'),
       ('ALID0004', 'SID0005'),
       ('ALID0005', 'SID0003'),
       ('ALID0005', 'SID0002'),
       ('ALID0005', 'SID0005');

INSERT INTO Artist(Name, Artist_ID, DOB)
Values ('Adam Levine', 'ARID0001', '1975-05-23'),
       ('Ed Sheeran', 'ARID0002', '1970-06-17'),
       ('Lady Gaga', 'ARID0003', '1972-08-11'),
       ('Florida', 'ARID0004', '1973-08-12'),
       ('Snoop Dog', 'ARID0005', '1980-03-2');

INSERT INTO User_Likes(User_ID, Song_ID)
VALUES ('UID0001', 'SID0001'),
       ('UID0001', 'SID0003'),
       ('UID0002', 'SID0001'),
       ('UID0003', 'SID0002'),
       ('UID0004', 'SID0003'),
       ('UID0004', 'SID0002'),
       ('UID0005', 'SID0005');

INSERT INTO User_searches(User_ID, Song_ID)
VALUES ('UID0001', 'SID0001'),
       ('UID0002', 'SID0001'),
       ('UID0002', 'SID0005'),
       ('UID0002', 'SID0003'),
       ('UID0003', 'SID0004'),
       ('UID0003', 'SID0001'),
       ('UID0004', 'SID0001'),
       ('UID0004', 'SID0002');

INSERT INTO Song_Artist(Song_ID, Artist_ID)
VALUES ('SID0001', 'ARID0003'),
       ('SID0001', 'ARID0001'),
       ('SID0001', 'ARID0004'),
       ('SID0002', 'ARID0002'),
       ('SID0002', 'ARID0004'),
       ('SID0003', 'ARID0003'),
       ('SID0003', 'ARID0002'),
       ('SID0003', 'ARID0004'),
       ('SID0003', 'ARID0005'),
       ('SID0004', 'ARID0003'),
       ('SID0004', 'ARID0001'),
       ('SID0004', 'ARID0004'),
       ('SID0005', 'ARID0002');

INSERT INTO Interest_User_Genre(USER_ID, GENRE_ID)
VALUES ('UID0001', 'GID0001'),
       ('UID0001', 'GID0002'),
       ('UID0001', 'GID0003'),
       ('UID0002', 'GID0001'),
       ('UID0003', 'GID0002'),
       ('UID0003', 'GID0004'),
       ('UID0004', 'GID0001'),
       ('UID0004', 'GID0004'),
       ('UID0004', 'GID0005'),
       ('UID0004', 'GID0002'),
       ('UID0005', 'GID0003'),
       ('UID0005', 'GID0002');


INSERT INTO Interest_User_Artist(User_ID, Artist_ID)
VALUES ('UID0001', 'ARID0001'),
       ('UID0002', 'ARID0001'),
       ('UID0002', 'ARID0003'),
       ('UID0002', 'ARID0004'),
       ('UID0003', 'ARID0002'),
       ('UID0003', 'ARID0005'),
       ('UID0004', 'ARID0002'),
       ('UID0005', 'ARID0003'),
       ('UID0005', 'ARID0004'),
       ('UID0005', 'ARID0005');

INSERT INTO Song(Song_ID, Name, Year, Duration, Genre_ID)
VALUES ('SID0006', 'Memories', 2020, 12.45, 'GID0004'),
       ('SID0007', 'Choice', 2019, 10.56, 'GID0003');

SELECT @@sql_mode;

SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

# Find max duration from multiple songs with name like Memories and Group By year
SELECT MAX(Duration), Name, Year
FROM Song
WHERE Name LIKE '%Memories'
GROUP BY Year;

# Nested query for finding genre id by its name and giving the songs in that particular genre
SELECT Song.Song_ID, Genre_ID, Name
FROM Song
WHERE Song.Genre_ID IN
      (
          SELECT Genre.Genre_ID
          FROM Genre
          WHERE Genre.Name LIKE 'Pop Music'
      );

# Nested Query to find song sung by a particular artist whose ID is ARID0001
SELECT DISTINCT Song.Name, Artist.Name
FROM Song,
     Artist
WHERE Song.Song_ID In
      (
          SELECT Song_Artist.Song_ID
          FROM Song_Artist
          WHERE Song_Artist.Artist_ID = 'ARID0001'
      )
GROUP BY Song.Name;

# Simulating Join using Nested Queries
SELECT User.*, User_Likes.Song_ID
FROM User,
     User_Likes
WHERE User.User_ID IN
      (
          SELECT User_Likes.User_ID
          FROM User_Likes
          WHERE User_Likes.Song_ID = 'SID0002'
            AND User_Likes.User_ID IN
                (
                    SELECT User.User_ID
                    FROM User
                    WHERE User.Name = 'Priya Singh'
                )
            AND User.User_ID = User_Likes.User_ID
      );


SELECT User.Name AS LISTENER
FROM User
WHERE User.User_ID IN
      (
          SELECT User_searches.User_ID
          FROM User_searches
          WHERE User_searches.Song_ID = 'SID0003'
      );


SELECT Artist.Name AS SINGER
FROM Artist
WHERE Artist.Artist_ID in
      (
          SELECT Song_Artist.ARTIST_ID
          FROM Song_Artist
          WHERE Song_Artist.Song_ID IN
                (
                    SELECT Song.Song_ID
                    FROM Song
                    WHERE Song.Name = 'Memories'
                )
      );


SELECT MIN(Year)
FROM Song
WHERE Song.Song_ID IN
      (
          SELECT Song_Artist.Song_ID
          FROM Song_Artist
          WHERE Song_Artist.Artist_ID = 'ARID0003'
      );

SELECT *
FROM Song
WHERE Song.Song_ID IN
      (
          SELECT Song_Artist.Song_ID
          FROM Song_Artist
          WHERE Song_Artist.Artist_ID = 'ARID0003'
      )
ORDER BY Year DESC;

SELECT Song.*, Song_Artist.Artist_ID
FROM Song,
     Song_Artist
WHERE Song.Song_ID IN
      (
          SELECT Song_Artist.Song_ID
          FROM Song_Artist
          WHERE Song_Artist.Song_ID = 'SID0003'
            AND Song_Artist.Song_ID IN
                (
                    SELECT Song.Song_ID
                    FROM Song
                    WHERE Song.Name = 'Choice'
                )
            AND Song_Artist.Song_ID = Song.Song_ID
      );

SELECT Register.Email_ID, Artist.Name AS Artist_Name
FROM Register,
     Artist
WHERE Register.Register_ID IN (
    SELECT Interest_User_Artist.User_ID
    FROM Interest_User_Artist
    WHERE Interest_User_Artist.Artist_ID IN
          (
              SELECT Artist.Artist_ID
              FROM Artist
              WHERE Artist.Name = 'Ed Sheeran'
          )
)
  AND Artist.Artist_ID IN (SELECT Artist.Artist_ID
                           FROM Artist
                           WHERE Artist.Name = 'Florida'
);

SELECT L.Login_ID, Register.Name, U.DOB
FROM Register
         INNER JOIN Login L
                    ON Register.Register_ID = L.Login_ID
         INNER JOIN User U
                    ON Register.Register_ID = U.User_ID;



SELECT L.Login_ID, Register.Name, U.DOB, R.Email_ID, L2.Password
FROM Register
         LEFT JOIN Login L
                   ON Register.Register_ID = L.Login_ID
         INNER JOIN User U
                    ON Register.Register_ID = U.User_ID
         LEFT JOIN Login L2
                   ON Register.Register_ID = L2.Login_ID
         RIGHT JOIN Register R
                    ON R.Register_ID = L.Login_ID;

SELECT G.Name, Song_Artist.Artist_ID
FROM Song_Artist,
     Song
         INNER JOIN Album_Song `AS`
                    ON Song.Song_ID = `AS`.Song_ID
         RIGHT JOIN Album A
                    ON A.Album_ID = `AS`.Album_ID
         LEFT OUTER JOIN Album A2
                         ON A2.Album_ID = `AS`.Album_ID
         RIGHT JOIN Genre G
                    ON Song.Genre_ID = G.Genre_ID
                        AND Song.Name = G.Name;

SELECT *
FROM Playlist
         JOIN User U
              ON U.User_ID = Playlist.User_ID
         RIGHT JOIN Interest_User_Artist IUA
         JOIN Artist A
              ON IUA.Artist_ID = A.Artist_ID
         JOIN Interest_User_Genre IUG
              ON IUA.User_ID = IUG.User_ID
              ON Playlist.User_ID = IUA.User_ID;

SELECT *
FROM Album
         JOIN Album_Song `AS`
              ON Album.Album_ID = `AS`.Album_ID
         RIGHT OUTER JOIN User_searches Us
         RIGHT JOIN Interest_User_Artist IUA
                    ON Us.User_ID = IUA.User_ID
         JOIN User_Likes UL
              ON Us.User_ID = UL.User_ID
                  AND Us.Song_ID = UL.Song_ID
              ON `AS`.Song_ID = Us.Song_ID;


DELIMITER //

CREATE PROCEDURE Insert_Genre(IN Name VARCHAR(20),
                              IN ID CHAR(7))
BEGIN
    INSERT INTO Genre(Genre_ID, Name)
        VALUE
        (ID, Name);
END //

SELECT *
FROM Genre;

CALL Insert_Genre('Horror', 'GID0006');


DELIMITER //
CREATE PROCEDURE Alter_Password(MobNum VARCHAR(20),
                                Email VARCHAR(20),
                                userName VARCHAR(20),
                                newPass CHAR(10))
BEGIN
    DECLARE ID CHAR(7);
    DECLARE ID_Verified CHAR(7);

    SELECT Register_ID
    INTO ID
    FROM Register
    WHERE Mobile = MobNum
      AND Email_ID = Email;

    IF ID IS NOT NULL THEN
        SELECT User_ID
        INTO ID_Verified
        FROM User
        WHERE User_ID = ID
          AND Name = userName;
    END IF;

    IF ID_Verified IS NOT NULL THEN
        UPDATE Login
        SET Password=newPass
        WHERE Login_ID = ID_Verified;
        SELECT * FROM Login WHERE Login_ID = ID_Verified;
    END IF;

    IF ID_Verified IS NULL OR ID IS NULL THEN
        SELECT "NOT AUTHORISED" AS ERROR;
    END IF;
END
//



CALL Alter_Password('9876543210', 'rajkumar1@gmail.com', 'Rajkumar', 'bhavya123');

CREATE VIEW AlbumSong
AS
SELECT Album.Name, AS.Song_ID, Album.Album_ID
FROM Album
         JOIN Album_Song `AS`
              ON Album.Album_ID = `AS`.Album_ID;

SELECT *
FROM AlbumSong;

CREATE VIEW SongYearOrder
AS
SELECT *
FROM Song
WHERE Song.Song_ID IN
      (
          SELECT Song_Artist.Song_ID
          FROM Song_Artist
          WHERE Song_Artist.Artist_ID = 'ARID0003'
      )
ORDER BY Year DESC;

SELECT *
FROM SongYearOrder;

ALTER TABLE Artist
    ADD Age INT;

DELIMITER //
CREATE TRIGGER ArtistAge
    BEFORE INSERT
    ON Artist
    FOR EACH ROW
BEGIN
    DECLARE age1 INT;
    SET NEW.Age = TIMESTAMPDIFF(MONTH, NEW.DOB, SYSDATE()) / 12;
END //

DELIMITER ;

SELECT *
FROM Artist;

INSERT INTO Artist (Name, Artist_ID, DOB, Age)
VALUES ('Salman Khan', 'ARID0006', '1976-12-10', 0);

SELECT *
FROM User,
     Login,
     Register
WHERE Login.Login_ID = User.User_ID
  AND Login.Login_ID = Register.Register_ID;


SELECT Album.Name AS AlbName, COUNT(Album_Song.Song_ID) AS SongCount, Album.Album_ID
FROM Album,
     Song,
     Album_Song
WHERE Album.Album_ID = Album_Song.Album_ID
  AND Album_Song.Song_ID = Song.Song_ID
GROUP BY Album.Album_ID;

SELECT Song.Name
FROM Album_Song,
     Song
WHERE Album_Song.Song_ID = Song.Song_ID
  AND Album_Song.Album_ID = 'ALID0001';


SELECT *
FROM Genre;

SELECT Playlist.Name AS PltName, COUNT(Playlist_Song.Song_ID) AS SongCount, Playlist.Playlist_ID
FROM Playlist,
     Song,
     Playlist_Song
WHERE Playlist.Playlist_ID = Playlist_Song.Playlist_ID
  AND Playlist_Song.Song_ID = Song.Song_ID
  AND Playlist.User_ID = 'UID0002'
GROUP BY Playlist.Playlist_ID;

SELECT *
FROM User,
     Login,
     Register
WHERE Login.Login_ID = User.User_ID
  AND Login.Login_ID = Register.Register_ID
  AND Login.Login_ID != 'UID0001';


SELECT Artist.Name
FROM Artist,
     Interest_User_Artist
WHERE Artist.Artist_ID = Interest_User_Artist.Artist_ID
  AND Interest_User_Artist.User_ID = 'UID0002';

SELECT Song.Song_ID
FROM Song,
     User_Likes
WHERE Song.Song_ID = User_Likes.Song_ID
  AND User_Likes.User_ID = 'UID0001';

