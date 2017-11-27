CREATE TABLE members (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),
  username VARCHAR (50) NOT NULL,
  password VARCHAR (56) NOT NULL,
  gender ENUM ('f', 'm', 'i'),
  date_of_membership DATE NOT NULL,
  is_admin TINYINT(1),
  motto TEXT
);

INSERT INTO members (id, username) VALUES (1, 'horst');

INSERT INTO members (username, password, gender, date_of_membership, is_admin)
  VALUES ('meyerklein', '123', 'm', '2017-11-21', 0, 'Laufschritt, Laufschritt macht Vergnügen!');


create USER 'markus'@'localhost' IDENTIFIED BY 'markus';
GRANT ALL PRIVILEGES ON wanderbase . * TO 'markus'@'localhost';

