/*
  Taller Figuras
  Punto 1: Cristal
  Presentado por:
  - Cristian Quebrada
  - Jesid Mejia
  - Neiro Culma
*/


CREATE TABLE my_cristal (
    id NUMBER PRIMARY KEY,
    tipo VARCHAR2(32),
    spat_field SDO_GEOMETRY
);

SELECT * FROM USER_SDO_GEOM_METADATA;

INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID)
VALUES ('MY_CRISTAL','SPAT_FIELD',
        SDO_DIM_ARRAY(
            SDO_DIM_ELEMENT('X',0,22,0.005),
            SDO_DIM_ELEMENT('Y',0,22,0.005)),
        NULL);
COMMIT;

delete USER_SDO_GEOM_METADATA s where s.TABLE_NAME = 'CRISTAL';

CREATE INDEX my_cristal_spatial_idx 
ON my_cristal(spat_field) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

insert into MY_CRISTAL values (1, 'Contorno 1',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,1003,1),
    sdo_ordinate_array(9,1, 1,17, 9,15, 17,17, 9,1)));
commit;
    
insert into MY_CRISTAL values (2, 'Contorno 2',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,1003,1),
    sdo_ordinate_array(9,10, 2,15, 16,15, 9,10)));
commit;

insert into MY_CRISTAL values (3, 'Linea 1',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(9,21, 9,1)));
commit;

insert into MY_CRISTAL values (14, 'Linea 2',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(9,10, 17,4)));
insert into MY_CRISTAL values (15, 'Linea 3',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(9,10, 1,4)));
commit;
    
insert into MY_CRISTAL values (6, 'Linea 4',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(9,21, 5,16)));
insert into MY_CRISTAL values (7, 'Linea 5',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(9,21, 13,16)));
commit;
    
    
insert into MY_CRISTAL values (8, 'Linea 6',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(1,17, 6,17)));
insert into MY_CRISTAL values (9, 'Linea 7',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(12,17, 17,17)));
commit;

insert into MY_CRISTAL values (10, 'Linea 8',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(4,11, 1,4, 7,5)));
insert into MY_CRISTAL values (11, 'Linea 9',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(14,11, 17,4, 11,5)));
commit;

insert into MY_CRISTAL values (12, 'Linea 10',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(2,15, 5,16)));
insert into MY_CRISTAL values (13, 'Linea 11',
    SDO_GEOMETRY(2003,
    null,
    null,
    sdo_elem_info_array(1,2,1),
    sdo_ordinate_array(13,16, 16,15)));
commit;

select * from cristal;