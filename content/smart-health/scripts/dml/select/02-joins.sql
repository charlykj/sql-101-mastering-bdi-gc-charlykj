-- ##################################################
-- # CONSULTAS CON JOINS Y AGREGACIÓN - SMART HEALTH #
-- ##################################################

-- La tercera consulta obtiene el listado de municipios y sus respectivos departamentos, 
-- uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar la localización geográfica, 
-- mostrando los 15 primeros resultados.

---INNER JOIN
--smart_health.municipalities T1
--smart_health.deparments T2
--2. llaves de cruce
--T1.departament_code
--T2.departament_code

SELECT
    T1.municipality_code As codigo_municipio,
    T1.municipality_code As Municipio,
    T2.department_name As departamnetos,

FROM municipalities T1
INNER JOIN deparments T2 ON T1.departament_code = T2.departament_code
ORDER BY T2.department_name
LIMIT 15;

--- contar los pacientes que  tengan o no tengan un numero de telefono asociado 
---

SELECT
    COUNT(DISTINCT T1.patient_id)

FROM patient_phones T1
RIGHT JOIN patients T2 ON T1.patient_id = T2.patient_id;


--contar los doctores que no tengan una especialidad 
--LEFT JOIN 
-- 1 TABLAS RELACIONADAS 
--smart_health_doctors T2
--smar_healt_specialities T1

SELECT
    COUNT(*)
FROM doctor_specialties T1
LEFT JOIN  doctors T2 ON T1.doctor_id = T2.doctor_id
WHERE T1.specialty_id= NULL;


-- 4. Mostrar las citas que se haya cancelado
-- entre el 20 de octubre del 2025 y el 23 de octubre del 2025.
-- Adicionalmente, es importante conocer, en que cuarto se iban 
-- a atender estas citas. Y la razon de la cancelacion si la hay.
-- Mostrar solo los 10 primeros registros.


-- tablas relacionadas 

SELECT
    T1.appointment_id,
    T1.appointment_date,
    T1.status,
    T1.reason  razon_cancelacion,
    T2.room_name
FROM smart_health.appointments  T1
LEFT JOIN smart_health.rooms  T2
    ON T1.room_id = T2.room_id
WHERE T1.status = 'Cancelled'
  AND T1.appointment_date BETWEEN '2025-10-20' AND '2025-10-23'
  ORDER BY T2.room_name
LIMIT 10;


 --Obtener los nombres, apellidos y número de documento de los pacientes 
 --junto con el nombre del tipo de documento al que pertenecen.
SELECT
    p.first_name,
    p.first_surname,
    p.document_number AS "Número de Documento",
    dt.type_name AS "Tipo de Documento" -- Nombre de columna corregido
FROM smart_health.patients p
JOIN smart_health.document_types dt
    ON p.document_type_id = dt.document_type_id;

    --Listar los nombres de los municipios y las direcciones registradas en cada uno, de manera que se muestren 
    --todos los municipios, incluso los que no tengan direcciones asociadas.

    SELECT
    m.municipality_name AS Municipio,
    a.address_line AS Direccion_Registrada
FROM
    smart_health.municipalities m
LEFT JOIN
    smart_health.addresses a ON m.municipality_code = a.municipality_code
ORDER BY
    m.municipality_name;


 --Consultar las citas médicas junto con el nombre y apellido del médico asignado, 
 --filtrando solo las citas con estado “Confirmed”.

 SELECT
    a.appointment_date AS Fecha_Cita,
    a.start_time AS Hora_Inicio,
    a.end_time AS Hora_Fin,
    d.first_name || ' ' || d.last_name AS Medico_Asignado,
    a.reason AS Motivo_Cita,
    a.status AS Estado
FROM
    smart_health.appointments a
JOIN
    smart_health.doctors d ON a.doctor_id = d.doctor_id
WHERE
    a.status = 'Confirmed'
ORDER BY
    a.appointment_date, a.start_time;

--Mostrar los nombres y apellidos de los pacientes junto con su dirección principal, 
--de forma que aparezcan también los pacientes sin dirección registrada.  

SELECT
    p.first_name,
    p.first_surname
FROM
    smart_health.patients p
    JOIN
    smart_health.patient_addresses pa ON p.patient_id = pa.patient_id
    WHERE
    pa.is_primary = TRUE
    GROUP BY
    p.patient_id, p.first_name, p.first_surname;

--Agrupar los pacientes por tipo de sangre y mostrar 
--la cantidad de tipos de sangre que tienen cada uno.
SELECT
    p.blood_type,
    COUNT(*) AS count
FROM
    smart_health.patients p
    GROUP BY
    p.blood_type
    ORDER BY
    count DESC;

--Obtener los nombres y apellidos de los pacientes junto con el nombre del médico que los atendió, 
--la especialidad del médico, la fecha de la cita y el departamento donde reside el paciente. 
--Aplicar condiciones para mostrar solo pacientes y doctores activos, 
--citas con estado confirmado y limitar el resultado a los 5 registros más recientes.
SELECT
    p.first_name AS Nombre_Paciente,
    p.first_surname AS Apellido_Paciente,
    d.first_name || ' ' || d.last_name AS Nombre_Medico,
    s.specialty_name AS Especialidad,
    a.appointment_date AS Fecha_Cita,
    dep.department_name AS Departamento_Residencia
FROM
    smart_health.appointments a
    JOIN
    smart_health.patients p ON a.patient_id = p.patient_id
    JOIN
    smart_health.doctors d ON a.doctor_id = d.doctor_id
    JOIN
    smart_health.doctor_specialties ds ON d.doctor_id = ds.doctor_id
    JOIN
    smart_health.specialties s ON ds.specialty_id = s.specialty_id
    EFT JOIN
    smart_health.patient_addresses pa ON p.patient_id = pa.patient_id AND pa.is_primary = TRUE
    LEFT JOIN
    smart_health.addresses addr ON pa.address_id = addr.address_id
    LEFT JOIN
    smart_health.municipalities mun ON addr.municipality_code = mun.municipality_code
    LEFT JOIN
    smart_health.departments dep ON mun.department_code = dep.department_code
    WHERE
    a.status = 'Confirmed'   
    AND p.active = TRUE      
    AND d.active = TRUE      
    ORDER BY
    a.appointment_date DESC, a.start_time DESC
    LIMIT 5;
    -- La tercera consulta obtiene el listado de municipios y sus respectivos 
-- departamentos, uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar
--  la localización geográfica, mostrando los 15 primeros resultados.

-- INNER JOIN
-- 1. Tablas asociadas
-- smart_health.municipalities T1
-- smart_health.departments T2

-- 2. Llaves de cruce
-- T1.department_code
-- T2.department_code
SELECT
    T1.municipality_code AS codigo_municipio,
    T1.municipality_name AS municipio,
    T2.department_name AS departamento

FROM municipalities T1
INNER JOIN departments T2 ON T1.department_code = T2.department_code
ORDER BY T2.department_name
LIMIT 15;

-- Contar los pacientes que tengan o no tengan
-- un numero de telefono asociado.

-- RIGTH JOIN
-- 1. Tablas asociadas
-- smart_health.patients T1
-- smart_health.patients_phones T2

-- 2. Llaves de cruce
-- T1.patient_id
-- T2.patient_id
SELECT
    COUNT(DISTINCT T1.patient_id)
FROM patient_phones T1
RIGHT JOIN patients T2 ON T1.patient_id = T2.patient_id;

-- 3.

-- Contar los doctores que no tengan una especialidad.
SELECT
    COUNT(*)
FROM doctor_specialties T1
LEFT JOIN  doctors T2 ON T1.doctor_id = T2.doctor_id
WHERE T1.specialty_id= NULL;



-- 4. Mostrar las citas que se haya cancelado
-- entre el 20 de octubre del 2025 y el 23 de octubre del 2025.
-- Adicionalmente, es importante conocer, en que cuarto se iban 
-- a atender estas citas. Y la razon de la cancelacion si la hay.
-- Mostrar solo los 10 primeros registros.
-- Rehabilitación
SELECT
    T1.appointment_date,
    T2.room_name,
    T1.appointment_type,
    T1.reason

FROM appointments T1
INNER JOIN rooms T2 ON T1.room_id = T2.room_id
WHERE appointment_date BETWEEN '2025-10-20' AND '2025-10-23'
AND T1.status = 'Cancelled'
ORDER BY T2.room_name
LIMIT 10;

-- -- 3️⃣ La tercera consulta obtiene el listado de municipios y sus respectivos 
-- departamentos, uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar la localización 
-- geográfica, mostrando los 15 primeros resultados.


-- Obtener los pacientes (primer nombre, genero, correo), con sus numeros de telefono
-- que tengan los siguientes numeros de documentos

-- '1006631391',
-- '1009149871',
-- '1298083',
-- '1004928596',
-- '1008188849',
-- '1607132',
-- '30470003'

-- INNER JOIN

-- smart_health.patients : patient_id (PK)
-- smart_health.patient_phones : patient_id (FK)

-- primer nombre
-- genero
-- correo
-- numero_telefono
SELECT
    A.first_name AS primer_nombre,
    A.gender AS genero,
    A.email AS correo,
    B.phone_number AS numero_telefono

FROM smart_health.patients A
INNER JOIN smart_health.patient_phones B 
    ON A.patient_id = B.patient_id
WHERE A.document_number IN
(
    '1006631391',
    '1009149871',
    '1298083',
    '1004928596',
    '1008188849',
    '1607132',
    '30470003'  
);

-- Obtener los pacientes (primer nombre, genero, correo), con sus numeros de telefono
-- que tengan los siguientes numeros de documentos.
-- tengan o no tengan un numero de telefono asociado.

-- '1006631391',
-- '1009149871',
-- '1298083',
-- '1004928596',
-- '1008188849',
-- '1607132',
-- '30470003'

-- RIGTH JOIN

-- smart_health.patients : patient_id (PK)
-- smart_health.patient_phones : patient_id (FK)

-- primer nombre
-- genero
-- correo
-- numero_telefono
SELECT
    B.first_name AS primer_nombre,
    B.gender AS genero,
    B.email AS correo,
    A.phone_number AS numero_telefono

FROM smart_health.patient_phones  A
RIGHT JOIN smart_health.patients B 
    ON A.patient_id = B.patient_id
WHERE B.document_number IN
(
    '30451580',
    '1006631391',
    '1009149871',
    '1298083',
    '1004928596',
    '1008188849',
    '1607132',
    '30470003'  
);

-- Obtener cuantos medicos, no tienen una direccion
-- asociada.

-- LEFT JOIN

-- smart_health.doctors: doctor_id (PK)
-- smart_health.doctor_addresses: doctor_id (PK)
SELECT
    COUNT(*) AS total_doctores_sin_direccion

FROM smart_health.doctors A
LEFT JOIN smart_health.doctor_addresses B
    ON A.doctor_id = B.doctor_id
WHERE B.doctor_id IS NULL;


-- Mostrar direccion, genero, nombre_completo, municipio, direccion
-- viven en pamplona
-- ordenar por primer nombre
-- mostrar 5

SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,
    T1.gender AS genero,
    T1.blood_type AS tipo_sangre,
    T2.address_type AS tipo_direccion,
    T3.address_line AS direccion,
    T3.postal_code AS codigo_postal,
    T4.municipality_name AS ciudad,
    T5.department_name AS departamento

FROM smart_health.patients T1
INNER JOIN smart_health.patient_addresses T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.addresses T3
    ON T3.address_id = T2.address_id
INNER JOIN smart_health.municipalities T4
    ON T4.municipality_code = T3.municipality_code
INNER JOIN smart_health.departments T5
    ON T5.department_code = T4.department_code
WHERE T4.municipality_name LIKE '%PAMPLONA%'
ORDER BY T1.first_name
LIMIT 5;

--             paciente            | genero | tipo_sangre | tipo_direccion |                         direccion                          | codigo_postal |  ciudad  |    departamento
-- --------------------------------+--------+-------------+----------------+------------------------------------------------------------+---------------+----------+--------------------
--  Adriana  Aguirre Rojas         | F      | O+          | Casa           | Limite Urbano - Urbano                                     | 251238        | PAMPLONA | NORTE DE SANTANDER
--  Adriana  Ríos Cabrera          | F      | O+          | Casa           | Rural - Municipio Belén - Mpio. Onzaga Y Coromoro          | 852050        | PAMPLONA | NORTE DE SANTANDER
--  Adriana Patricia Díaz Pérez    | F      | O+          | Casa           | Vía Ventaquemada-Tunja - Rural - Municipio Samacá          | 991058        | PAMPLONA | NORTE DE SANTANDER
--  Adriana  León Rojas            | O      | A+          | Casa           | Rural - M. Fómeque Y San Juanito - Municipio Villavicencio | 540004        | PAMPLONA | NORTE DE SANTANDER
--  Alejandro Ángel González Pérez | O      | O-          | Trabajo        | Rural - Municipio Jericó - Río Pauto Y (Permanente)        | 414047        | PAMPLONA | NORTE DE SANTANDER
-- (5 filas)

-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################