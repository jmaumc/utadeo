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
    dbms_output.put_line(var_d);
return var_d;
end haversine;

create or replace procedure calcular_ruta
is
    acum_distance    number := 0;
    lat    number := 0;
    lon    number := 0;
    next_lat    number := 0;
    next_lon    number := 0;
    --cursor cur_sitio is select latitud, longitud from sitio;
begin
    for i in 1..3 loop
        select s.latitud 
          into lat 
          from waze s 
          where s.id_sitio = i;
        select s.longitud 
          into lon 
          from waze s 
          where s.id_sitio = i;
        select s.latitud 
          into next_lat 
          from waze s 
          where s.id_sitio = i+1;
        select s.longitud 
          into next_lon 
          from waze s 
          where s.id_sitio = i+1;
        acum_distance := acum_distance + haversine(lat,lon,next_lat,next_lon);
        dbms_output.put_line('acum_distance:='||acum_distance);
    end loop;
    dbms_output.put_line('acum_distance:='||acum_distance);
end;

begin
calcular_ruta;
end;
--------------------------------------------------------------------------------
