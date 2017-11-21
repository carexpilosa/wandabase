CREATE TABLE members (
  id INT NOT NULL,
  username VARCHAR (50) NOT NULL
);

INSERT INTO members (id, username) VALUES (1, 'horst');

INSERT INTO members (id, username, password, gender, date_of_membership, is_admin)
              VALUES(2, 'meyerklein', '123', 'm', '2017-11-21', 0);

create USER 'markus'@'localhost' IDENTIFIED BY 'markus';
GRANT ALL PRIVILEGES ON meineDB . * TO 'markus'@'localhost';

