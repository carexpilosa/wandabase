

CREATE database wanderbase;

create USER 'markus'@'localhost' IDENTIFIED BY 'markus';
GRANT ALL PRIVILEGES ON wanderbase . * TO 'markus'@'localhost';

CREATE TABLE members (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),
  username VARCHAR (50) NOT NULL UNIQUE,
  password VARCHAR (56) NOT NULL,
  gender ENUM ('f', 'm', 'i'),
  date_of_membership DATE NOT NULL,
  is_admin TINYINT(1),
  motto TEXT,
  token VARCHAR(50),
  token_created DATETIME
);

INSERT INTO members (username, password, gender, date_of_membership, is_admin, motto)
             VALUES ('markus', 'markus', 'm',    '2017-11-21',       0,        'Laufschritt, Laufschritt macht Vergnügen!');

CREATE TABLE events (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),
  title VARCHAR (100) NOT NULL,
  description TEXT NOT NULL,
  created DATETIME NOT NULL,
  starttime DATETIME NOT NULL, -- DATETIME values in 'YYYY-MM-DD HH:MM:SS',
  startlocation VARCHAR(256)
);

CREATE TABLE comments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),
  content TEXT NOT NULL,
  created DATETIME NOT NULL,
  member_id INT UNSIGNED NOT NULL,
  event_id INT UNSIGNED NOT NULL,
  predecessor_id INT UNSIGNED
);

*************************
INSERT INTO members (id, username) VALUES (1, 'horst');
ALTER TABLE members ADD token_created DATETIME NOT NULL;
ALTER TABLE comments ADD predecessor_id INT UNSIGNED;