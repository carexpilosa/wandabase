CREATE TABLE members (
  id INT NOT NULL,
  username VARCHAR (50) NOT NULL
);

INSERT INTO members (id, username) VALUES (1, 'horst');

create USER 'markus'@'localhost' IDENTIFIED BY 'markus';
GRANT ALL PRIVILEGES ON meineDB . * TO 'markus'@'localhost';

