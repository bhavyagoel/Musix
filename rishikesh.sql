CREATE DATABASE IF NOT EXISTS Rishikesh;

USE Rishikesh;

create table Movie
(
    mov_id           int primary key,
    mov_title        varchar(20),
    mov_year         int,
    mov_time         int,
    mov_language     varchar(20),
    mov_industry     varchar(20),
    mov_release_date date
);

create table Actor_details
(
    act_id     int primary key,
    act_name   varchar(20),
    act_gender varchar(20),
    act_dob    date
);

create table Reviewer
(
    rev_id   int primary key,
    rev_name varchar(20)
);


create table Movie_rating
(
    mov_id      int,
    rev_id      int,
    rating_star int,
    FOREIGN KEY (mov_id) REFERENCES Movie (mov_id),
    FOREIGN KEY (rev_id) REFERENCES Reviewer (rev_id)
);

create table Movie_actor_details
(
    mov_id   int,
    actor_id int,
    FOREIGN KEY (mov_id) REFERENCES Movie (mov_id),
    FOREIGN KEY (actor_id) REFERENCES Actor_details (act_id)
);

INSERT INTO Movie(mov_id, mov_title, mov_year, mov_time, mov_language, mov_industry, mov_release_date)
VALUES (2, 'abcd2', 2019, 3, 'hindi', 'bollywood', '2019-09-21');

INSERT INTO Movie(mov_id, mov_title, mov_year, mov_time, mov_language, mov_industry, mov_release_date)
VALUES (3, 'abcd2', 2019, 3, 'hindi', 'bollywood', '2008-7-04');

INSERT INTO Actor_details(act_id, act_name, act_gender, act_dob)
VALUES (1, 'prabhas', 'male', '2008-7-04');

INSERT INTO Actor_details(act_id, act_name, act_gender, act_dob)
VALUES (2, 'amir', 'male', '2001-7-06');

INSERT INTO Actor_details(act_id, act_name, act_gender, act_dob)
VALUES (3, 'ritik', 'male', '2004-10-16');


insert into Reviewer(rev_id, rev_name)
VALUES (1, 'bhavya');
insert into Reviewer(rev_id, rev_name)
VALUES (2, 'neha')
insert into Reviewer(rev_id, rev_name)
VALUES (3, 'rishi');
insert into Movie_rating(mov_id, rev_id, rating_star)
VALUES (2, 2, 4);
insert into Movie_rating(mov_id, rev_id, rating_star)
VALUES (2, 2, 5);
insert into Movie_actor_details(mov_id, actor_id)
VALUES (3, 1);
insert into Movie_actor_details(mov_id, actor_id)
VALUES (2, 2);

insert into Movie(mov_id, mov_title, mov_year, mov_time, mov_language, mov_industry, mov_release_date)
VALUES (5, 'sky', 2012, 3, 'english', 'hollywood', '2012-12-25');
insert into Movie_rating(mov_id, rev_id, rating_star)
VALUES (5, 1, 1);

INSERT INTO Movie(mov_id, mov_title, mov_year, mov_time, mov_language, mov_industry, mov_release_date)
VALUES (6, 'abcd2', 2019, 3, 'hindi', 'bollywood', '2020-09-21');

SELECT *
FROM Movie
WHERE MONTH(mov_release_date) = MONTH(SYSDATE()) - 1
  AND YEAR(mov_release_date) = YEAR(SYSDATE());

SELECT Movie.mov_title, COUNT(Movie_rating.mov_id) AS CountRate
FROM Movie,
     Movie_rating
WHERE Movie_rating.rating_star = 4
HAVING CountRate > 1;


SELECT COUNT(Movie_actor_details.actor_id), Movie.mov_title
FROM Movie_actor_details,
     Movie
WHERE Movie.mov_id = Movie_actor_details.mov_id;


SELECT Reviewer.*
FROM Reviewer,
     Movie_rating
WHERE Movie_rating.rev_id = Reviewer.rev_id
  AND Movie_rating.rating_star < 2;

SELECT mov_title
FROM Movie,
     Movie_actor_details
WHERE Movie.mov_id = Movie_actor_details.mov_id
  AND Movie_actor_details.actor_id IN
      (
          SELECT A1.act_id
          from Actor_details A1
          WHERE A1.act_name = "amir"
      );


SELECT Actor_details.*, COUNT(Movie_actor_details.actor_id) AS movCount
FROM Actor_details,
     Movie_actor_details
WHERE Actor_details.act_id = Movie_actor_details.actor_id
HAVING movCount >= 1;

SELECT rev_name, M.mov_title
FROM Reviewer
         LEFT JOIN Movie_rating Mr on Reviewer.rev_id = Mr.rev_id
         JOIN Movie M on M.mov_id = Mr.mov_id
GROUP BY rev_name;

SELECT *
FROM Movie
WHERE mov_industry = 'hollywood'
  AND MONTH(mov_release_date) = 12
  AND DAY(mov_release_date) = 25
  AND YEAR(mov_release_date) > YEAR(SYSDATE()) - 10;

insert into Movie(mov_id, mov_title, mov_year, mov_time, mov_language, mov_industry, mov_release_date)
VALUES (8, 'hello', 2012, 3, 'english', 'hollywood', '2012-12-25');