/*
  Taller Figuras
  Punto 2: Portal
  Presentado por:
  - Jesid Mejia
  - Neiro Culma
  - Cristian Quebrada
*/


CREATE TABLE my_portal (
 id NUMBER PRIMARY KEY,
 tipo VARCHAR(32),
 spat_field SDO_GEOMETRY);

SELECT * FROM my_portal;
SELECT * FROM  user_sdo_geom_metadata;

INSERT INTO user_sdo_geom_metadata
 (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID)
 VALUES ('my_portal','spat_field',
 SDO_DIM_ARRAY(-- 20X20 grid
 SDO_DIM_ELEMENT('X', 0, 20, 0.005),
 SDO_DIM_ELEMENT('Y', 0, 20, 0.005)
 ),
 NULL-- SRID
); 
commit;

SELECT * FROM user_sdo_geom_metadata;

CREATE INDEX myportal_spatial_idx
 ON my_portal(spat_field)
 INDEXTYPE IS MDSYS.SPATIAL_INDEX;

INSERT INTO my_portal VALUES(1,'Poligono Compuesto',
 SDO_GEOMETRY(2003, NULL, NULL,
 SDO_ELEM_INFO_ARRAY(1,1005,2, 1,2,1, 11,2,2),
 SDO_ORDINATE_ARRAY(1,1, 4,1, 4,3, 6,3, 6,1, 9,1, 5,6, 1,1)
 ));
commit;
