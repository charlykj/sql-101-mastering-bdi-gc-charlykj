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

