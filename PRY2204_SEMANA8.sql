-- ..:: CASO 1 ::..

-- Elimina primero las tablas dependientes
DROP TABLE DETALLE_SERVICIO CASCADE CONSTRAINTS;
DROP TABLE MANTENCION CASCADE CONSTRAINTS;
DROP TABLE ESTANDAR CASCADE CONSTRAINTS;
DROP TABLE PREMIUM CASCADE CONSTRAINTS;
DROP TABLE AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE SERVICIO CASCADE CONSTRAINTS;
DROP TABLE MECANICO CASCADE CONSTRAINTS;

-- Luego las tablas fuertes
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE TIPO_AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE MODELO CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE PAIS CASCADE CONSTRAINTS;

-- PAIS
CREATE TABLE PAIS (
    id_pais NUMBER(3) GENERATED ALWAYS AS IDENTITY
        (START WITH 9 INCREMENT BY 3),
    nom_pais VARCHAR2(30) NOT NULL,
    CONSTRAINT PAIS_PK PRIMARY KEY (id_pais)
);

-- CIUDAD
CREATE TABLE CIUDAD (
    id_ciudad NUMBER(3),
    nom_ciudad VARCHAR2(30) NOT NULL,
    cod_pais NUMBER(3) NOT NULL,
    CONSTRAINT CIUDAD_PK PRIMARY KEY (id_ciudad),
    CONSTRAINT CIUDAD_FK_PAIS FOREIGN KEY (cod_pais) REFERENCES PAIS(id_pais)
);

-- SUCURSAL
CREATE TABLE SUCURSAL (
    id_sucursal CHAR(3),
    nom_sucursal VARCHAR2(20) NOT NULL,
    calle VARCHAR2(20),
    num_calle NUMBER(4),
    cod_ciudad NUMBER(3) NOT NULL,
    CONSTRAINT SUCURSAL_PK PRIMARY KEY (id_sucursal),
    CONSTRAINT SUCURSAL_FK_CIUDAD FOREIGN KEY (cod_ciudad) REFERENCES CIUDAD(id_ciudad)
);

-- MARCA
CREATE TABLE MARCA (
    id_marca NUMBER(2),
    descripcion VARCHAR2(20) NOT NULL,
    CONSTRAINT MARCA_PK PRIMARY KEY (id_marca)
);

-- MODELO
CREATE TABLE MODELO (
    id_modelo NUMBER(5),
    marca_id NUMBER(2) NOT NULL,
    descripcion VARCHAR2(20) NOT NULL,
    CONSTRAINT MODELO_PK PRIMARY KEY (id_modelo, marca_id),
    CONSTRAINT MODELO_FK_MARCA FOREIGN KEY (marca_id) REFERENCES MARCA(id_marca)
);

-- TIPO_AUTOMOVIL
CREATE TABLE TIPO_AUTOMOVIL (
    id_tipo CHAR(3),
    descripcion VARCHAR2(20) NOT NULL,
    CONSTRAINT TIPO_AUTOMOVIL_PK PRIMARY KEY (id_tipo)
);

-- CLIENTE
CREATE TABLE CLIENTE (
    rut NUMBER(8),
    dv CHAR(1) NOT NULL,
    pnombre VARCHAR2(20),
    snombre VARCHAR2(20),
    apat VARCHAR2(20),
    amat VARCHAR2(20),
    telefono VARCHAR2(12),
    email VARCHAR2(40),
    tipo_cl CHAR(1),
    CONSTRAINT CLIENTE_PK PRIMARY KEY (rut),
    CONSTRAINT CLIENTE_CK_TIPO CHECK (tipo_cl IN ('E','P'))
);

-- AUTOMOVIL
CREATE TABLE AUTOMOVIL (
    patente CHAR(8),
    anio NUMBER(4),
    cant_puertas NUMBER(1),
    km NUMBER(6),
    color VARCHAR2(10),
    cod_tipo_auto CHAR(3) NOT NULL,
    cod_modelo NUMBER(5) NOT NULL,
    cod_marca NUMBER(2) NOT NULL,
    cl_rut NUMBER(8) NOT NULL,
    CONSTRAINT AUTOMOVIL_PK PRIMARY KEY (patente),
    CONSTRAINT AUTOMOVIL_FK_TIPO FOREIGN KEY (cod_tipo_auto) REFERENCES TIPO_AUTOMOVIL(id_tipo),
    CONSTRAINT AUTOMOVIL_FK_MODELO FOREIGN KEY (cod_modelo, cod_marca) REFERENCES MODELO(id_modelo, marca_id),
    CONSTRAINT AUTOMOVIL_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE(rut)
);

-- MECANICO
CREATE TABLE MECANICO (
    cod_mecanico NUMBER(5) GENERATED ALWAYS AS IDENTITY
        (START WITH 460 INCREMENT BY 7),
    pnombre VARCHAR2(20),
    snombre VARCHAR2(20),
    apat VARCHAR2(20),
    amat VARCHAR2(20),
    bono_jefatura NUMBER(10),
    sueldo NUMBER(10),
    monto_impuestos NUMBER(10),
    cod_supervisor NUMBER(5),
    CONSTRAINT MECANICO_PK PRIMARY KEY (cod_mecanico),
    CONSTRAINT MECANICO_FK_SUPERVISOR FOREIGN KEY (cod_supervisor) REFERENCES MECANICO(cod_mecanico)
);

-- SERVICIO
CREATE TABLE SERVICIO (
    id_servicio NUMBER(3),
    descripcion VARCHAR2(100),
    costo NUMBER(7),
    CONSTRAINT SERVICIO_PK PRIMARY KEY (id_servicio)
);

-- MANTENCION
CREATE TABLE MANTENCION (
    num_mantencion NUMBER(4),
    cod_sucursal CHAR(3) NOT NULL,
    fecha_ingreso DATE,
    fecha_salida DATE,
    patente_auto CHAR(8) NOT NULL,
    cod_mecanico NUMBER(5) NOT NULL,
    costo_total NUMBER(7),
    estado VARCHAR2(15),
    CONSTRAINT MANTENCION_PK PRIMARY KEY (num_mantencion),
    CONSTRAINT MANT_FK_AUTOMOVIL FOREIGN KEY (patente_auto) REFERENCES AUTOMOVIL(patente),
    CONSTRAINT MANT_FK_MECANICO FOREIGN KEY (cod_mecanico) REFERENCES MECANICO(cod_mecanico),
    CONSTRAINT MANT_FK_SUCURSAL FOREIGN KEY (cod_sucursal) REFERENCES SUCURSAL(id_sucursal)
);

-- DETALLE_SERVICIO
CREATE TABLE DETALLE_SERVICIO (
    mantencion_num NUMBER(4),
    cod_servicio NUMBER(3),
    descuento_serv NUMBER(4,3),
    cantidad NUMBER(3),
    CONSTRAINT DETALLE_SERVICIO_PK PRIMARY KEY (mantencion_num, cod_servicio),
    CONSTRAINT DET_SERV_FK_MANTENCION FOREIGN KEY (mantencion_num) REFERENCES MANTENCION(num_mantencion),
    CONSTRAINT DET_SERV_FK_SERVICIO FOREIGN KEY (cod_servicio) REFERENCES SERVICIO(id_servicio)
);

-- ESTANDAR
CREATE TABLE ESTANDAR (
    cl_rut NUMBER(8),
    puntaje_fidelidad NUMBER(10),
    CONSTRAINT ESTANDAR_PK PRIMARY KEY (cl_rut),
    CONSTRAINT ESTANDAR_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE(rut)
);

-- PREMIUM
CREATE TABLE PREMIUM (
    cl_rut NUMBER(8),
    pesos_clientes NUMBER(10),
    monto_credito NUMBER(10),
    CONSTRAINT PREMIUM_PK PRIMARY KEY (cl_rut),
    CONSTRAINT PREMIUM_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE(rut)
);

-- ..:: CASO 2 ::..

 -- Eliminar columna costo_total de MANTENCION
ALTER TABLE MANTENCION DROP COLUMN costo_total;

-- Primero eliminar la FK en DETALLE_SERVICIO que depende de MANTENCION
ALTER TABLE DETALLE_SERVICIO DROP CONSTRAINT DET_SERV_FK_MANTENCION;

-- Ahora eliminar la PK actual de MANTENCION
ALTER TABLE MANTENCION DROP CONSTRAINT MANTENCION_PK;

-- Crear la nueva PK compuesta
ALTER TABLE MANTENCION ADD CONSTRAINT MANTENCION_PK 
PRIMARY KEY (num_mantencion, cod_sucursal);

-- Primero, DETALLE_SERVICIO necesita tener la columna cod_sucursal
ALTER TABLE DETALLE_SERVICIO ADD cod_sucursal CHAR(3);

-- Crear la FK compuesta hacia MANTENCION
ALTER TABLE DETALLE_SERVICIO ADD CONSTRAINT DET_SERV_FK_MANTENCION
FOREIGN KEY (mantencion_num, cod_sucursal)
REFERENCES MANTENCION(num_mantencion, cod_sucursal);

-- Email en CLIENTE debe ser único si se registra
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_UN_EMAIL UNIQUE (email);

-- Dígito verificador (dv) debe estar en 0–9 o 'K'
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_CK_DV 
CHECK (dv IN ('0','1','2','3','4','5','6','7','8','9','K'));

-- Sueldo de MECANICO no puede ser inferior a 510000
ALTER TABLE MECANICO ADD CONSTRAINT MECANICO_CK_SUELDO 
CHECK (sueldo >= 510000);

-- Estado de MANTENCION debe ser uno de los valores permitidos
ALTER TABLE MANTENCION ADD CONSTRAINT MANTENCION_CK_ESTADO
CHECK (estado IN ('Reserva','Ingresado','Entregado','Anulado'));

-- ..:: CASO 3 ::..

-- SECUENCIAS

-- Secuencia para SERVICIO (desde 400, incremento 2)
CREATE SEQUENCE SEQ_SERVICIO START WITH 400 INCREMENT BY 2;

-- Secuencia para CIUDAD (desde 165, incremento 5)
CREATE SEQUENCE SEQ_CIUDAD START WITH 165 INCREMENT BY 5;

-- POBLAR TABLAS

-- PAIS
INSERT INTO PAIS (nom_pais) VALUES ('Chile');
INSERT INTO PAIS (nom_pais) VALUES ('Perú');
INSERT INTO PAIS (nom_pais) VALUES ('Colombia');

-- CIUDAD
INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL, 'Santiago', 9);

INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL, 'Lima', 12);

INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL, 'Bogotá', 15);

-- SUCURSAL
INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES ('S01', 'Providencia', 'Av. A. Varas', 234, 165);

INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES ('S02', 'Las 4 Esquinas', 'Av. Latina', 669, 170);

INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES ('S03', 'El Cafetero', 'Av. El Faro', 900, 175);

-- SERVICIO
INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Luces', 45000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Desabolladura', 67000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Revisión Frenos', 30000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Puerta Trasera', 50000);

-- MECANICO
-- Jorge Pablo Soto Sierpe
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, NULL);

-- Pedro Jose Manriquez Corral
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Pedro', 'Jose', 'Manriquez', 'Corral', NULL, 759000, 23980, NULL);

-- Sandra Josefa Letelier S.
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);

-- Felipe M. Vidal A.
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Felipe', 'M.', 'Vidal', 'A.', NULL, 759000, 23580, 460);

-- Jose Miguel Troncoso B.
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jose', 'Miguel', 'Troncoso', 'B.', NULL, 659000, 44580, 474);

-- Juan Pablo Sánchez R.
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Juan', 'Pablo', 'Sánchez', 'R.', NULL, 859000, 23380, 474);

-- Carlos Felipe Soto J.
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);

-- Alberto P. Cerda Ramírez
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alberto', 'P.', 'Cerda', 'Ramírez', NULL, 559000, 22380, 460);

-- Alejandra Gabriela Infanti R.
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alejandra', 'Gabriela', 'Infanti', 'R.', NULL, 659000, 22380, 460);

-- Roberto Patricio Gutierrez Sosa
INSERT INTO MECANICO (pnombre, snombre, apat, amat, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', NULL, 859000, 22380, 460);

-- TIPO_AUTOMOVIL
INSERT INTO TIPO_AUTOMOVIL (id_tipo, descripcion)
VALUES ('T01', 'Sedán');

INSERT INTO TIPO_AUTOMOVIL (id_tipo, descripcion)
VALUES ('T02', 'SUV');

INSERT INTO TIPO_AUTOMOVIL (id_tipo, descripcion)
VALUES ('T03', 'Hatchback');

-- MARCA
INSERT INTO MARCA (id_marca, descripcion)
VALUES (1, 'Toyota');

INSERT INTO MARCA (id_marca, descripcion)
VALUES (2, 'Hyundai');

INSERT INTO MARCA (id_marca, descripcion)
VALUES (3, 'Chevrolet');

INSERT INTO MARCA (id_marca, descripcion)
VALUES (4, 'Nissan');

INSERT INTO MARCA (id_marca, descripcion)
VALUES (5, 'Mazda');

-- MODELO
INSERT INTO MODELO (id_modelo, marca_id, descripcion)
VALUES (100, 1, 'Corolla');

INSERT INTO MODELO (id_modelo, marca_id, descripcion)
VALUES (101, 2, 'Accent');

INSERT INTO MODELO (id_modelo, marca_id, descripcion)
VALUES (102, 3, 'Spark');

INSERT INTO MODELO (id_modelo, marca_id, descripcion)
VALUES (103, 4, 'Sentra');

INSERT INTO MODELO (id_modelo, marca_id, descripcion)
VALUES (104, 5, 'CX-5');

-- CLIENTE 
INSERT INTO CLIENTE (rut, dv, pnombre, snombre, apat, amat, telefono, email, tipo_cl)
VALUES (12345678, '9', 'Juan', NULL, 'Pérez', NULL, '987654321', 'juan.perez@example.com', 'P');

INSERT INTO CLIENTE (rut, dv, pnombre, snombre, apat, amat, telefono, email, tipo_cl)
VALUES (87654321, 'K', 'María', NULL, 'González', NULL, '912345678', 'maria.gonzalez@example.com', 'E');

INSERT INTO CLIENTE (rut, dv, pnombre, snombre, apat, amat, telefono, email, tipo_cl)
VALUES (11223344, '5', 'Pedro', 'Luis', 'Ramírez', 'Soto', '911223344', 'pedro.ramirez@example.com', 'P');

INSERT INTO CLIENTE (rut, dv, pnombre, snombre, apat, amat, telefono, email, tipo_cl)
VALUES (55667788, '2', 'Ana', NULL, 'Fernández', 'López', '956677889', 'ana.fernandez@example.com', 'E');

-- AUTOMOVIL
INSERT INTO AUTOMOVIL (patente, anio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut)
VALUES ('AAAA11', 2020, 4, 45000, 'Rojo', 'T01', 100, 1, 12345678);  -- Cliente Juan

INSERT INTO AUTOMOVIL (patente, anio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut)
VALUES ('BBBB22', 2019, 4, 60000, 'Azul', 'T01', 101, 2, 87654321);  -- Cliente María

INSERT INTO AUTOMOVIL (patente, anio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut)
VALUES ('CCCC33', 2021, 5, 30000, 'Negro', 'T02', 102, 3, 11223344); -- Cliente Pedro

INSERT INTO AUTOMOVIL (patente, anio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut)
VALUES ('DDDD44', 2018, 4, 80000, 'Blanco', 'T01', 103, 4, 55667788); -- Cliente Ana

-- MANTENCION
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (101, 'S01', TO_DATE('12-04-2023','DD-MM-YYYY'), NULL, 'AAAA11', 481, 'Reserva');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (102, 'S02', TO_DATE('21-02-2023','DD-MM-YYYY'), TO_DATE('21-02-2023','DD-MM-YYYY'), 'BBBB22', 502, 'Entregado');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (103, 'S02', TO_DATE('09-10-2023','DD-MM-YYYY'), NULL, 'CCCC33', 502, 'Anulado');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (104, 'S03', TO_DATE('11-08-2023','DD-MM-YYYY'), TO_DATE('18-08-2023','DD-MM-YYYY'), 'DDDD44', 509, 'Entregado');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (105, 'S03', TO_DATE('03-12-2023','DD-MM-YYYY'), NULL, 'CCCC33', 509, 'Ingresado');

-- ..:: CASO 4 ::..