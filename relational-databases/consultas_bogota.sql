/* Taller Consultas Bogota
  Presentado por: Grupo T
  * Neiro Culma
  * Cristian Quebrada
  * Jesid Mejia
*/


---1. Muestre la localidad con mayor área---
SELECT locnombre,SDO_GEOM.SDO_AREA(geometry, 0.005) Area
FROM LOCA
WHERE SDO_GEOM.SDO_AREA(geometry, 0.005)=(
SELECT MAX(SDO_GEOM.SDO_AREA(geometry, 0.005))
FROM LOCA);

---2. Muestre las localidades y el número total de barrios que hay en ella--
SELECT  l.LOCNOMBRE NOMBRE_LOCALIDAD, COUNT(AU.AURCODIGO) NUMERO_BARRIOS
FROM TABLE(SDO_JOIN('LOCA', 'GEOMETRY',
                    'AURB', 'GEOMETRY',
                    'mask=ANYINTERACT')) c,LOCA l,AURB AU
WHERE C.ROWID1 = L.ROWID AND C.ROWID2 = AU.ROWID
AND AU.aurnombre like 'BARRIO%'
GROUP BY L.LOCNOMBRE
ORDER BY COUNT(AU.AURCODIGO) DESC;

---3.Muestre las localidades y el número total de sitios de interés que hay en ella---
SELECT  L.LOCNOMBRE NOMBRE_LOCALIDAD, COUNT(S.SINCODIGO) CANTIDAD_SITIOS_INTERES
FROM TABLE(SDO_JOIN('LOCA', 'GEOMETRY',
                    'SINT', 'GEOMETRY',
                    'mask=ANYINTERACT')) C, LOCA L, SINT S
WHERE C.ROWID1 = L.ROWID AND C.ROWID2 = S.ROWID
GROUP BY L.LOCNOMBRE
ORDER BY COUNT(S.SINCODIGO) DESC;

---4.Muestre los sitios de interés que no están asociados a ninguna localidad---
SELECT SINNOMBRE NINGUNA_LOCALIDAD
FROM SINT
WHERE SINCODIGO NOT IN (SELECT S.SINCODIGO
                        FROM LOCA L, SINT S
                        WHERE SDO_GEOM.SDO_INTERSECTION(L.GEOMETRY,S.GEOMETRY,0.005) IS NOT NULL);

---5.Muestre la localidad con mayor número de sitios de interés--
SELECT  L.NOMBRE_LOCALIDAD NOMBRE_LOCALIDAD
FROM (SELECT  L.LOCNOMBRE NOMBRE_LOCALIDAD, COUNT(S.SINCODIGO) CANTIDAD_SITIOS_INTERES
      FROM TABLE(SDO_JOIN(  'LOCA','GEOMETRY',
                            'SINT','GEOMETRY',
                            'mask=ANYINTERACT')) C, LOCA L, SINT S
                            WHERE C.ROWID1 = L.ROWID AND C.ROWID2 = S.ROWID
                            GROUP BY L.LOCNOMBRE
                            ORDER BY 2 DESC) L
                            WHERE ROWNUM = 1;
                            
---6.Muestre la localidad con menor número de sitios de interés---
SELECT  L.NOMBRE_LOCALIDAD  NOMBRE_LOCALIDAD
FROM    (SELECT  L.LOCNOMBRE NOMBRE_LOCALIDAD, COUNT(S.SINCODIGO) CANTIDAD_SITIOS
        FROM TABLE(SDO_JOIN('LOCA', 'GEOMETRY',
                            'SINT', 'GEOMETRY',
                            'mask=ANYINTERACT')) C, LOCA L, SINT S
                            WHERE C.ROWID1 = L.ROWID AND C.ROWID2 = S.ROWID
                            GROUP BY L.LOCNOMBRE
                            ORDER BY 2 ASC) L
                            WHERE ROWNUM = 1;

---7.Muestre las localidades que son vecinas de la localidad "PUENTE ARANDA"---
SELECT L.LOCNOMBRE
FROM   LOCA L, LOCA PA
        WHERE L.LOCCODIGO != PA.LOCCODIGO 
        AND SDO_RELATE(L.GEOMETRY, PA.GEOMETRY,'mask=ANYINTERACT') = 'TRUE'
        AND PA.LOCNOMBRE LIKE '%PUENTE ARANDA%';

---8. Mostrar los barrios con mayor perímetro---
SELECT AU.AURNOMBRE NOMBRE_BARRIO_MAS_GRANDE
FROM (  SELECT AU.AURNOMBRE, SDO_GEOM.SDO_LENGTH(AU.GEOMETRY, M.DIMINFO)
                    FROM AURB AU, USER_SDO_GEOM_METADATA M 
                    WHERE M.TABLE_NAME = 'AURB' 
                    AND M.COLUMN_NAME = 'GEOMETRY'
                    ORDER BY 2 DESC) AU 
                    WHERE ROWNUM = 1;

---9.Muestre las localidades por donde pasa la cicloruta más larga---
SELECT DISTINCT L.LOCNOMBRE LOCALIDAD_CICLORUTA_MAS_LARGA
FROM TABLE(SDO_JOIN('LOCA', 'GEOMETRY',
                    'CICL', 'GEOMETRY',
                    'mask=ANYINTERACT')) C, LOCA L, CICL CI
                    WHERE C.ROWID1 = L.ROWID AND C.ROWID2 = CI.ROWID
                    AND CI.SHAPE_LENG = (SELECT MAX(SHAPE_LENG) FROM CICL)
                    ORDER BY L.LOCNOMBRE;

---10.Muestre las localidades que tienen mayor número de iglesias---
SELECT NOMBRE, IGLESIAS NUM_IGELSIAS
FROM (SELECT L.LOCNOMBRE NOMBRE,COUNT (*) IGLESIAS
        FROM SINT S,LOCA L
        WHERE UPPER(S.SINNOMBRE) LIKE '%IGLESIA%'
        AND SDO_RELATE(S.GEOMETRY, L.GEOMETRY,'mask=ANYINTERACT') = 'TRUE'
        GROUP BY L.LOCNOMBRE
        ORDER BY 2 DESC)
        WHERE ROWNUM = 1;   

---11.Muestre las localidades que tienen más colegios y por donde no pasa ninguna cicloruta--
SELECT L.LOCNOMBRE NOMBRE,COUNT (*)COLEGIOS
        FROM SINT S,LOCA L
        WHERE UPPER(S.SINNOMBRE) LIKE '%COLEGIO%'
        AND SDO_RELATE(S.GEOMETRY, L.GEOMETRY,'mask=ANYINTERACT') = 'TRUE'
        AND L.LOCCODIGO NOT IN (SELECT DISTINCT L.LOCCODIGO
                                FROM TABLE(SDO_JOIN('LOCA', 'GEOMETRY',
                                                    'CICL', 'GEOMETRY',
                                                    'mask=ANYINTERACT')) C,
                                                    LOCA L, CICL CI
                                WHERE C.ROWID1 = L.ROWID AND C.ROWID2 = CI.ROWID)
                                GROUP BY L.LOCNOMBRE
                                ORDER BY COLEGIOS DESC;

---12.Muestre los sitios de interés que tiene mayor distancia entre sí---
SELECT C_B.SINNOMBRE SITIO_UNO, C_D.SINNOMBRE SITIO_DOS, 
SDO_GEOM.SDO_DISTANCE(C_B.GEOMETRY, C_D.GEOMETRY, 0.005) 
DISTANCIA FROM  SINT C_B, SINT C_D
WHERE C_B.SINCODIGO != C_D.SINCODIGO
AND SDO_GEOM.SDO_DISTANCE(C_B.GEOMETRY, C_D.GEOMETRY, 0.005) = 
(SELECT MAX(SDO_GEOM.SDO_DISTANCE(C_B.GEOMETRY, C_D.GEOMETRY, 0.005))
FROM SINT C_B, SINT C_D
WHERE C_B.SINCODIGO != C_D.SINCODIGO)
AND ROWNUM = 1;

---13.Muestre los barrios que no contienen ningún Hotel---
SELECT AURNOMBRE
FROM AURB 
WHERE UPPER(AURNOMBRE) LIKE 'BARRIO %'
AND AURCODIGO NOT IN (SELECT AU.AURCODIGO
                      FROM SINT S, AURB AU
                      WHERE UPPER(S.SINNOMBRE) LIKE '%Hotel%'
                      AND SDO_RELATE(S.GEOMETRY, AU.GEOMETRY,'mask=ANYINTERACT querytype=WINDOW') = 'TRUE');

---14.	Muestre las estaciones de policía que estén dentro de un rango de 5 km del Estadio Nemesio Camacho El Campin--

SELECT * FROM 
    (SELECT * FROM sint  
          WHERE UPPER(sinnombre) like 'ESTA%POL%') a, 
         (SELECT * FROM sint
          WHERE UPPER(sinnombre) like '%ESTADIO NEMESIO CAMACHO EL CAMP%')b
    WHERE SDO_WITHIN_DISTANCE(a.GEOMETRY,b.GEOMETRY, 'distance=5000') = 'TRUE';

--15.Cuáles son los barrios que más ciclorutas la cruzan---

SELECT A.AURNOMBRE NOMBRE_BARRIO, COUNT (*)NUM_CICLIORRUTAS
        FROM SINT S,AURB A
        WHERE UPPER(A.AURNOMBRE) LIKE 'BARRIO%'
        AND SDO_RELATE(S.GEOMETRY, A.GEOMETRY,'MASK=ANYINTERACT') = 'TRUE'
        AND A.AURCODIGO NOT IN (SELECT DISTINCT A.AURCODIGO
                                FROM TABLE(SDO_JOIN('AURB', 'GEOMETRY',
                                                    'CICL', 'GEOMETRY',
                                                    'MASK=ANYINTERACT')) C,
                                                    AURB A, CICL CI
                                WHERE C.ROWID1 = A.ROWID AND C.ROWID2 = CI.ROWID)
                                GROUP BY A.AURNOMBRE
                                ORDER BY NUM_CICLIORRUTAS DESC;
                                
---16.Muestre el barrio con mayor número de estaciones de policía--
SELECT A.AURNOMBRE BARRIO
  FROM TABLE (SDO_JOIN('AURB','GEOMETRY','SINT','GEOMETRY','mask=ANYINTERACT')) C, AURB A, SINT S
 WHERE C.ROWID1 = A.ROWID 
   AND C.ROWID2 = S.ROWID
   AND UPPER(S.SINNOMBRE) LIKE 'ESTACI%POLIC%' 
 GROUP BY A.AURNOMBRE
HAVING COUNT(S.SINCODIGO) = (SELECT MAX(CUENTA) 
                               FROM (SELECT A.AURNOMBRE BARRIO, COUNT(S.SINCODIGO) CUENTA
                                       FROM TABLE (SDO_JOIN('AURB','GEOMETRY','SINT','GEOMETRY','mask=ANYINTERACT')) C, AURB A, SINT S
                                      WHERE C.ROWID1 = A.ROWID 
                                        AND C.ROWID2 = S.ROWID
                                        AND UPPER(S.SINNOMBRE) LIKE 'ESTACI%POLIC%' 
                                      GROUP BY A.AURNOMBRE)); 

---17.Muestre la localidad con mayor número de centros comerciales---
SELECT  l.NOMBRE_LOCALIDAD FROM
    (SELECT  l.LOCNOMBRE NOMBRE_LOCALIDAD, COUNT(s.SINCODIGO) CANTIDAD_SITIOS
    FROM TABLE(SDO_JOIN('LOCA', 'GEOMETRY',
                        'SINT', 'GEOMETRY',
                        'mask=ANYINTERACT')) c, LOCA l, SINT s
                WHERE c.rowid1 = l.rowid AND c.rowid2 = s.rowid and SINNOMBRE like '%Centro%Comercial%'
                GROUP BY l.LOCNOMBRE
                ORDER BY 2 DESC) l
                WHERE ROWNUM = 1;

--18.	Muestre la localidad que tengan mayor número de hotel, pero menor estaciones de policía.

SELECT LOCA
FROM ( SELECT H.LOCA, CUENTA_HOS, CUENTA_EST, (CUENTA_EST/CUENTA_HOS) AS RELACION
FROM  (SELECT L.LOCNOMBRE  LOCA, COUNT(S.SINCODIGO) CUENTA_HOS
FROM TABLE (SDO_JOIN('LOCA','GEOMETRY','SINT','GEOMETRY','mask=ANYINTERACT')) C, LOCA L, SINT S
 		WHERE C.ROWID1 = L.ROWID AND C.ROWID2 = S.ROWID
   		AND UPPER(S.SINNOMBRE) LIKE '%HOTEL%' GROUP BY L.LOCNOMBRE) H,
(SELECT L.LOCNOMBRE LOCA, COUNT(S.SINCODIGO) CUENTA_EST
 FROM TABLE (SDO_JOIN('LOCA','GEOMETRY','SINT','GEOMETRY','mask=ANYINTERACT')) C, LOCA L, SINT S
 		 WHERE C.ROWID1 = L.ROWID 
  		 AND C.ROWID2 = S.ROWID
   		AND UPPER(S.SINNOMBRE) LIKE 'ESTACI%POLIC%' GROUP BY L.LOCNOMBRE) L
WHERE h.loca= L.LOCA
ORDER BY CUENTA_EST/CUENTA_HOS)
WHERE ROWNUM = 1;

--19.	Mostrar los barrios que en el nombre tengan la palabra “Urbanización” y que estén en la localidad de Engativá.

SELECT  a.AURNOMBRE NOMBRE_BARRIOS_ENGATIVA
FROM TABLE(
        SDO_JOIN('LOCA', 'GEOMETRY','AURB', 'GEOMETRY','mask=ANYINTERACT')) c, LOCA L, AURB a
WHERE c.rowid1 = l.rowid AND c.rowid2 = a.rowid
AND UPPER(a.AURNOMBRE) like '%URBANIZACION%'
AND UPPER(L.LOCNOMBRE) = 'ENGATIVA'
GROUP BY a.AURNOMBRE;

--20.	Mostrar los barrios que tengan el mismo nombre en diferentes localidades.

SELECT S.AURNOMBRE NOM_BARRIO, COUNT(L.LOCNOMBRE) NUM_REPETICIONES
 FROM TABLE (SDO_JOIN('LOCA','GEOMETRY','AURB','GEOMETRY','mask=ANYINTERACT')) C, LOCA L, AURB S
                WHERE C.ROWID1 = L.ROWID 
                  AND C.ROWID2 = S.ROWID
                  AND AURNOMBRE <> '.'
                GROUP BY S.AURNOMBRE
                HAVING COUNT(L.LOCNOMBRE) > 1
                ORDER BY NUM_REPETICIONES DESC;