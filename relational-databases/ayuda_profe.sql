CREATE TABLE waze
( id number(5),
  nodo varchar(1),
  ruta number(2),
  latitud number(6,3),
  longitud number(6,3),
  velocidad number(2)
);


INSERT INTO waze VALUES (1,'I',2,4.607,-74.068, 5);
INSERT INTO waze VALUES (2,'C',2,4.606,-74.068, 10);
INSERT INTO waze VALUES (3,'C',2,4.608,-74.071, 5);
INSERT INTO waze VALUES (4,'C',2,4.600,-74.076, 10);
INSERT INTO waze VALUES (5,'F',2,4.599,-74.075, 5);


INSERT INTO waze VALUES (6,'I',3,4.605,-74.063, 4);
INSERT INTO waze VALUES (7,'C',3,4.604,-74.062, 8);
INSERT INTO waze VALUES (8,'C',3,4.607,-74.071, 10);
INSERT INTO waze VALUES (9,'C',3,4.600,-74.076, 10);
INSERT INTO waze VALUES (10,'F',3,4.599,-74.075, 5);

COMMIT;


------------------------------------------------------------------------------------------------
-------------------PROCEDIMIENTO ---------------------------------------------------------------
--------Tiene un ciclo de 2 a 3 para recorrer las rutas-----------------------------------------
-- Tiene dentro un ciclo for con un CURSOR que selecciona los registros de la ruta(i)------------
------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE EjemploTareaDistancias
IS
   i NUMBER := 2;
   Vruta number(2);
   Vvelocidad number(2);
   Vtotal number(2);
   Vregistro WAZE%ROWTYPE;
   
BEGIN
   
   WHILE i <= 3 LOOP
       Vtotal:=0;    
       FOR Vregistro IN ( SELECT ruta, velocidad FROM waze WHERE ruta=i ) LOOP
          DBMS_OUTPUT.PUT_LINE('Ruta: ' || Vregistro.ruta || ' - Velocidad: ' || Vregistro.Velocidad);      
          Vtotal:=Vtotal+Vregistro.velocidad;
          
       END LOOP;
       i := i + 1;
       DBMS_OUTPUT.PUT_LINE('Total Velocidad: ' || Vtotal);      
       
   END LOOP;
END;

------------------------------------------------------------------------------------------------------
---------------------EJEMPLO PARA EJECUTAR EL PROCEDIMIENTO-------------------------------------------
------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
BEGIN
      EjemploTareaDistancias;
END;
