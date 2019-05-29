PRAGMA foreign_keys = ON; 
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255), 
  lname VARCHAR(255)
);



CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body TEXT,
  author VARCHAR(255),
  author_id INTEGER, 
  FOREIGN KEY(author_id) REFERENCES users(id)
);



CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY, 
  question_id INTEGER,
  follower_id INTEGER,
  FOREIGN KEY(follower_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
 );



CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  parent_id INTEGER, 
  replier_id INTEGER, 
  title VARCHAR(255),
  body TEXT, 
  question_id INTEGER,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id),
  FOREIGN KEY(replier_id) REFERENCES users(id)
);




CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY, 
  question_id INTEGER, 
  liker_id INTEGER, 
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(liker_id) REFERENCES users(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Helen', 'Yu'), 
  ('Ellie', 'Lee'), 
  ('Ronil', 'Bhatia');


INSERT INTO
  questions (title, body, author, author_id)
VALUES
  ('Why is the Earth round?', 'Hey y''all, I''m struggling to understand this. Help.', 'Helen', 1), 
  ('How many software engineers does it take to screw a lightbulb?', 'None, because they would be too busy implementing code and not the actual thing.', 'Ronil', 3);

INSERT INTO
  question_follows (question_id, follower_id)
VALUES
  (1, 2),
  (2, 2),
  (2, 1); 

INSERT INTO
  replies (replier_id, title, body, question_id)
VALUES 
  (2, 'Hey you know what?', 'It doesn''t really matter Helen, look it up yourself - you''re a software engineer.', 1), 
  (1, 'Haha Ronil', 'Not funny.', 2);

INSERT INTO
  question_likes (question_id, liker_id)
VALUES 
  (1, 3), 
  (2, 2);

/*
(SELECT id FROM users WHERE fname = 'Helen' AND lname = 'Yu')
(SELECT id FROM users WHERE fname = 'Ronil' AND lname = 'Bhatia');
*/