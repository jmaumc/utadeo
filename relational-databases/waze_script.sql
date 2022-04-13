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

create or replace function haversine(lat1 in number, long1 in number, lat2 in number, long2 in number)
return number
is
    distance      number;
    delta_lat     number;
    delta_long    number;
    var_a         number;
    var_c         number;
    var_d         number;
begin
    select (lat2 - lat1) * (3.141592653589793116/180) 
      into delta_lat 
      from dual;
    select (long2 - long1) * (3.141592653589793116/180) 
      into delta_long 
      from dual;
    select POWER(SIN(delta_lat/2), 2) + 
      (COS(lat1)*COS(lat2) * POWER(SIN(delta_long/2), 2)) 
      into var_a 
      from dual;
    select 2 * ATAN2(SQRT(var_a), SQRT(1-var_a)) 
      into var_c 
      from dual;
    select 6378 * var_c 
      into var_d 
      from dual;
    --dbms_output.put_line(var_d);
return var_d;
end haversine;


-- Final Procedure
CREATE OR REPLACE PROCEDURE CalcularRuta
IS
    i             NUMBER := 2;
    lat           number := 0;
    lon           number := 0;
    next_lat      number := 0;
    next_lon      number := 0;
    Vruta         number(2);
    Vvelocidad    number;
    Vtotal_velo   number;
    Vtotal_dist   number;
    Vnum_nodos  number(2);
    Vregistro WAZE%ROWTYPE;
   
BEGIN
   
   WHILE i <= 3 LOOP
       Vtotal_velo:=0;  
       Vtotal_dist:=0;
       FOR Vregistro IN ( SELECT ruta, velocidad FROM waze WHERE ruta=i ) LOOP
          DBMS_OUTPUT.PUT_LINE('Ruta: ' || Vregistro.ruta || ' - Velocidad: ' || Vregistro.Velocidad);      
          Vtotal_velo := Vtotal_velo+Vregistro.velocidad;
       END LOOP;
       
       SELECT COUNT(*)-1 INTO Vnum_nodos FROM waze WHERE ruta=i;
       
       FOR j in 1..Vnum_nodos LOOP
          select s.latitud 
          into lat 
          from waze s 
          where s.id = j;
        select s.longitud 
          into lon 
          from waze s 
          where s.id = j;
        select s.latitud 
          into next_lat 
          from waze s 
          where s.id = j+1;
        select s.longitud 
          into next_lon 
          from waze s 
          where s.id = j+1;
          Vtotal_dist := Vtotal_dist + haversine(lat,lon,next_lat,next_lon);
          DBMS_OUTPUT.PUT_LINE('Ruta: ' || i || ' - Distancia: ' || haversine(lat,lon,next_lat,next_lon));  
       END LOOP;
       
       
       i := i + 1;
       DBMS_OUTPUT.PUT_LINE('Total Velocidad: ' || Vtotal_velo);      
       DBMS_OUTPUT.PUT_LINE('Total Distancia: ' || Vtotal_dist); 
       
   END LOOP;
END;

SET SERVEROUTPUT ON
begin
CalcularRuta;
end;
--------------------------------------------------------------------------------
