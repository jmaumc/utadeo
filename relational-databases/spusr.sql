
create table table_geo (
  id          number primary key,
  tipofigura  varchar2(32),
  campogeom   SDO_GEOMETRY);
  
  
select * from user_sdo_geom_metadata;

insert into user_sdo_geom_metadata(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID)
values ('table_geo', 'campogeom', sdo_dim_array(  --20x20 grid
  sdo_dim_element('X', 0, 20, 0.005),
  sdo_dim_element('Y', 0, 20, 0.005)),
  NULL /*SRID*/);
  
create index table_geo_spatial_idx 
  on table_geo (campogeom) 
  indextype is mdsys.spatial_index;

drop index table_geo_spatial_idx;


insert into TABLE_GEO values (1, 'Poligono', 
  sdo_geometry(2003, 
    NULL, NULL, 
    sdo_elem_info_array(1,1003,1),
    sdo_ordinate_array(5,1, 8,1, 8,6, 5,7, 5,1)
));

select * from table_geo
