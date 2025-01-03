---Creation of user
CREATE USER Admin_KarenOrtiz
IDENTIFIED BY clvbib;
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

--Assign the DBA role to the user
GRANT dba TO  Admin_KarenOrtiz;

SELECT USER FROM dual;

---Creation of tables
CREATE TABLE Autores(
    aut_clave NUMERIC(4,0),
    aut_nombre VARCHAR(60) NOT NULL,
    aut_apellido VARCHAR(60) NOT NULL,
    aut_nacionalidad VARCHAR(80),
    aut_fecha DATE,
    CONSTRAINT aut_aut_clave_pk PRIMARY KEY (aut_clave)
);

CREATE TABLE Libros(
    lib_clave NUMERIC(4,0),
    lib_titulo VARCHAR(100) NOT NULL,
    lib_fecha DATE,
    aut_clave NUMERIC(4,0),
    CONSTRAINT lib_lib_clave_pk PRIMARY KEY (lib_clave),
    CONSTRAINT lib_aut_clave_fk FOREIGN KEY (aut_clave) REFERENCES Autores(aut_clave)
);

CREATE TABLE Usuarios(
    usu_clave NUMERIC(4,0),
    usu_nombre VARCHAR(60) NOT NULL,
    usu_apellido VARCHAR(60) NOT NULL,
    usu_mail VARCHAR(80) NOT NULL,
    lib_fecha DATE NOT NULL,
    CONSTRAINT usu_usu_clave_pk PRIMARY KEY (usu_clave)
);

CREATE TABLE Prestamos(
    pres_clave NUMERIC(4,0),
    pres_fecha_prestamo DATE NOT NULL,
    pres_fecha_devolucion DATE,
    usu_clave NUMERIC(4,0),
    lib_clave NUMERIC(4,0),
    CONSTRAINT pres_pres_clave_pk PRIMARY KEY (pres_clave),
    CONSTRAINT pres_usu_clave_fk FOREIGN KEY (usu_clave) REFERENCES Usuarios(usu_clave),
    CONSTRAINT pres_lib_clave_fk FOREIGN KEY (lib_clave) REFERENCES Libros(lib_clave)
);

---Foreign keys must be mandatory
ALTER TABLE Libros 
MODIFY aut_clave NUMERIC(4,0) NOT NULL;

ALTER TABLE Prestamos 
MODIFY usu_clave NUMERIC(4,0) NOT NULL;

ALTER TABLE Prestamos 
MODIFY lib_clave NUMERIC(4,0) NOT NULL;

---Insert data into tables
INSERT INTO Autores VALUES (1, 'Gabriel', 'Garcia Marquez', 'Colombian', TO_DATE('1927-03-06', 'YYYY-MM-DD'));
INSERT INTO Autores VALUES (2, 'J.K.', 'Rowling', 'British', TO_DATE('1965-07-31', 'YYYY-MM-DD'));
INSERT INTO Autores VALUES (3, 'Haruki', 'Murakami', 'Japanese', TO_DATE('1949-01-12', 'YYYY-MM-DD'));

INSERT INTO Libros VALUES (1, 'One Hundred Years of Solitude', TO_DATE('1967-06-05', 'YYYY-MM-DD'), 1);
INSERT INTO Libros VALUES (2, 'Harry Potter and the Philosopher\'s Stone', TO_DATE('1997-06-26', 'YYYY-MM-DD'), 2);
INSERT INTO Libros VALUES (3, 'Kafka on the Shore', TO_DATE('2002-05-29', 'YYYY-MM-DD'), 3);

INSERT INTO Usuarios VALUES (1, 'Carlos', 'Pérez', 'carlos.perez@example.com', TO_DATE('2024-11-01', 'YYYY-MM-DD'));
INSERT INTO Usuarios VALUES (2, 'Ana', 'Martínez', 'ana.martinez@example.com', TO_DATE('2023-11-05', 'YYYY-MM-DD'));
INSERT INTO Usuarios VALUES (3, 'Luis', 'Gómez', 'luis.gomez@example.com', TO_DATE('2020-11-07', 'YYYY-MM-DD'));

INSERT INTO Prestamos VALUES (1, TO_DATE('2024-11-10', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'), 1, 1);
INSERT INTO Prestamos VALUES (2, TO_DATE('2024-11-09', 'YYYY-MM-DD'), TO_DATE('2024-12-09', 'YYYY-MM-DD'), 2, 2);
INSERT INTO Prestamos VALUES (3, TO_DATE('2024-11-08', 'YYYY-MM-DD'), TO_DATE('2024-12-08', 'YYYY-MM-DD'), 3, 3);

---View all data inserted into each table
SELECT * FROM Autores;
SELECT * FROM Libros;
SELECT * FROM Usuarios;
SELECT * FROM Prestamos;

---Modification, ISBN of books must be unique
ALTER TABLE Libros ADD lib_isbn VARCHAR(13) UNIQUE;

---Updated the inserted data of books, added ISBNs
UPDATE Libros 
SET lib_isbn = '0000000000000' 
WHERE lib_clave = 1;
UPDATE Libros 
SET lib_isbn = '0000000000001' 
WHERE lib_clave = 2;
UPDATE Libros 
SET lib_isbn = '0000000000002' 
WHERE lib_clave = 3;

---Modified the ISBN attribute of books to make it mandatory
ALTER TABLE Libros MODIFY lib_isbn VARCHAR(13) NOT NULL;
---In users, added the phone attribute
ALTER TABLE Usuarios ADD usu_telefono VARCHAR(15);
---Modified the length of the nationality attribute in authors, from VARCHAR(80) to VARCHAR(200)
ALTER TABLE Autores MODIFY aut_nacionalidad VARCHAR(200);

---Statements to delete tables
--DROP TABLE Libros;
--DROP TABLE Autores;
--SELECT * FROM Prestamos;
--SELECT * FROM Usuarios;

---Validation that the publication date of a book cannot exceed the current date
CREATE OR REPLACE TRIGGER trg_validar_fecha_libros
BEFORE INSERT OR UPDATE ON Libros
FOR EACH ROW
BEGIN
  IF :NEW.lib_fecha > SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20001, 'The publication date cannot be later than the current date.');
  END IF;
END;
/

---Added constraint that the return date must be greater than or equal to the loan date
ALTER TABLE Prestamos ADD CONSTRAINT pres_fecha_devolucion_ck CHECK (pres_fecha_devolucion >= pres_fecha_prestamo);
---Constraint, user email must be unique
ALTER TABLE Usuarios ADD CONSTRAINT usu_mail_uq UNIQUE (usu_mail);

INSERT INTO Libros VALUES (4, 'One Hundred Years of Solitude', TO_DATE('2025-11-29', 'YYYY-MM-DD'), 1, '0000000000004');
INSERT INTO Prestamos VALUES (4, TO_DATE('2024-11-10', 'YYYY-MM-DD'), TO_DATE('2024-10-10', 'YYYY-MM-DD'), 1, 1);
INSERT INTO Usuarios VALUES (4, 'Pedro', 'López', 'carlos.perez@example.com', TO_DATE('2024-11-10', 'YYYY-MM-DD'));

---Queries
--Authors with their nationalities
SELECT aut_nombre, aut_apellido, aut_nacionalidad FROM Autores;

--All books and their corresponding authors:
SELECT Libros.lib_titulo, Autores.aut_nombre, Autores.aut_apellido
FROM Libros
INNER JOIN Autores ON Libros.aut_clave = Autores.aut_clave;

--Loans with user information and the borrowed book
SELECT Prestamos.pres_clave, Usuarios.usu_nombre, Usuarios.usu_apellido, Libros.lib_titulo, Prestamos.pres_fecha_prestamo, Prestamos.pres_fecha_devolucion
FROM Prestamos
INNER JOIN Usuarios ON Prestamos.usu_clave = Usuarios.usu_clave
INNER JOIN Libros ON Prestamos.lib_clave = Libros.lib_clave;

--Number of existing books
SELECT COUNT(*) AS Total_Libros FROM Libros;

--Users with duplicate emails
SELECT usu_mail, COUNT(*)
FROM Usuarios
GROUP BY usu_mail
HAVING COUNT(*) > 1;
