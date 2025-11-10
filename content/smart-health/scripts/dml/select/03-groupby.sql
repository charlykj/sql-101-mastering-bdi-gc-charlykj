-- ##################################################
-- # CONSULTAS GROUP BY QUERIES - SMART HEALTH #
-- ##################################################
SELECT
  T1.patient_id,
  T1.first_name,
  T1.first_surname,
  T1.birth_date,
  DATE_PART('year', AGE(CURRENT_DATE, T1.birth_date)) AS age,
  T2.appointment_date
FROM smart_health.patients AS T1
JOIN smart_health.appointments AS T2
  ON T1.patient_id = T2.patient_id
WHERE
  --DATE_PART('year', AGE(CURRENT_DATE, T1.birth_date)) BETWEEN 20 AND 25
  T2.appointment_date >= TO_DATE('2025-09-01','YYYY-MM-DD') - INTERVAL '3 months'
ORDER BY T2.appointment_date
LIMIT 10;

SELECT
  T2.appointment_date,
  COUNT(*)
FROM smart_health.patients AS T1
JOIN smart_health.appointments AS T2
  ON T1.patient_id = T2.patient_id
WHERE
  --DATE_PART('year', AGE(CURRENT_DATE, T1.birth_date)) BETWEEN 20 AND 25
  --T2.appointment_date >= TO_DATE('2025-10-01','YYYY-MM-DD') - INTERVAL '3 months'
  T2.appointment_date BETWEEN TO_DATE('2025-10-01','YYYY-MM-DD') - INTERVAL '3 months' AND TO_DATE('2025-10-01','YYYY-MM-DD')
GROUP BY T2.appointment_date
ORDER BY T2.appointment_date;

-- 1. Contar cuántos pacientes están registrados por cada tipo de documento,
-- mostrando el nombre del tipo de documento y la cantidad total de pacientes,
-- ordenados por cantidad de mayor a menor.
-- Dificultad: BAJA
SELECT
    td.type_name AS tipo_documento,
    COUNT(p.patient_id) AS total_pacientes
    FROM
    smart_health.patients p
    JOIN
    smart_health.document_types td
    ON p.document_type_id = td.document_type_id
    GROUP BY
    td.type_name
    ORDER BY
    total_pacientes DESC;
  
                       -- tipo_documento                            | total_pacientes
---------------------------------------------------------------------+-----------------
 --CÚdula de CiudadanÝa                                                |            7630
 --N·mero ┌nico de Identificaci¾n Personal (NUIP)                      |            7594
 --Registro Civil de Nacimiento                                        |            7490
 --CÚdula de ExtranjerÝa / Identificaci¾n de ExtranjerÝa               |            7482
 --Tarjeta de Identidad                                                |            7481
 --N·mero de Identificaci¾n establecido por la SecretarÝa de Educaci¾n |            7457
 --Certificado Cabildo                                                 |            7450
 --N·mero de Identificaci¾n Personal (NIP)                             |            7416
--(8 filas)


-- 2. Mostrar el número de citas programadas por cada médico,
-- incluyendo el nombre completo del doctor y el total de citas,
-- ordenadas alfabéticamente por apellido del médico.
-- Dificultad: BAJA
SELECT
    d.last_name || ' ' || d.first_name AS nombre_completo_doctor,
    COUNT(a.appointment_id) AS total_citas
    ROM
    smart_health.appointments a
    JOIN
    smart_health.doctors d
    ON a.doctor_id = d.doctor_id
    GROUP BY
    d.last_name, d.first_name
    ORDER BY
    d.last_name ASC;

--nombre_completo_doctor | total_citas
------------------------+-------------
 --Aguirre Mauricio       |          19
 --Aguirre Juan           |          31
 --Aguirre Rodrigo        |          45
 --Aguirre Alejandro      |          77
 --Aguirre Vanessa        |          31
 --Aguirre Paola          |          33
 --Aguirre MarÝa          |          47
 --Aguirre Fernando       |          61
 --Aguirre Camila         |          47
 --Aguirre Esteban        |          28
 --Aguirre Laura          |          16
 --Aguirre Adriana        |          55
 --Aguirre Gabriela       |          37
 --Aguirre Carlos         |          21
 --Aguirre Pedro          |          44
 --Aguirre Ricardo        |          71
 --Aguirre Manuel         |          67
 --Aguirre Julißn         |          36
 --Aguirre Felipe         |          42
 --Aguirre AndrÚs         |          44
 --Aguirre Santiago       |          23
 --Aguirre Mariana        |          45
 --Aguirre Hernßn         |          46
 --Aguirre Miguel         |          15
 --Aguirre Natalia        |          75
 --Aguirre Isabel         |          43
 --Aguirre Cristian       |          29
 --Aguirre Juliana        |          43


-- 3. Calcular el promedio de edad de los pacientes agrupados por género,
-- mostrando el género y la edad promedio redondeada a dos decimales.
-- Dificultad: INTERMEDIA
SELECT
    p.gender AS genero,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date))), 2) AS edad_promedio
    FROM
    smart_health.patients p
    GROUP BY
    p.gender
    ORDER BY
    p.gender;

-- genero | edad_promedio
--------+---------------
-- F      |         41.96
 --M      |         41.90
 --O      |         41.87
--(3 filas)


-- 4. Obtener el número total de prescripciones realizadas por cada medicamento,
-- mostrando el nombre comercial del medicamento, el principio activo,
-- y la cantidad de veces que ha sido prescrito, solo para aquellos medicamentos
-- que tengan al menos 5 prescripciones.
-- Dificultad: INTERMEDIA
SELECT
    m.commercial_name AS nombre_comercial,
    m.active_ingredient AS principio_activo,
    COUNT(p.prescription_id) AS total_prescripciones
    FROM
    smart_health.prescriptions p
    JOIN
    smart_health.medications m
    ON p.medication_id = m.medication_id
    GROUP BY
    m.commercial_name, m.active_ingredient
    HAVING
    COUNT(p.prescription_id) >= 5
    ORDER BY
    total_prescripciones DESC;
            --nombre_comercial             |       principio_activo           | total_prescripciones
-----------------------------------------+-------------------------------------+----------------------
 --OXIMETAZOLINA MK                        | OXIMETAZOLINA                       |                   77
 --METOCLOPRAMIDA MK                       | METOCLOPRAMIDA                      |                   76
 --ACETILCISTE═NA MK                       | ACETILCISTE═NA                      |                   72
 --DILTIAZEM MK                            | DILTIAZEM                           |                   64
 --DIGOXINA MK                             | DIGOXINA                            |                   63
 --ENTACAPONA MK                           | ENTACAPONA                          |                   59
 --SUNITINIB MK                            | SUNITINIB                           |                   56
 --OXITOCINA MK                            | OXITOCINA                           |                   54
 --TOPIRAMATO MK                           | TOPIRAMATO                          |                   54
 --MOMETASONA MK                           | MOMETASONA                          |                   53
 --TRIAMCINOLONA MK                        | TRIAMCINOLONA                       |                   52
 --LIOTIRONINA MK                          | LIOTIRONINA                         |                   52
 --BISACODILO MK                           | BISACODILO                          |                   51
 --NISTATINA MK                            | NISTATINA                           |                   51
 --HIDROCORTISONA MK                       | HIDROCORTISONA                      |                   49
 --DESMOPRESINA MK                         | DESMOPRESINA                        |                   48
 --DIAZEPAM MK                             | DIAZEPAM                            |                   48
 --METRONIDAZOL MK                         | METRONIDAZOL                        |                   48
 --CLORHEXIDINA MK                         | CLORHEXIDINA                        |                   48
 --COLCHICINA MK                           | COLCHICINA                          |                   47
 --ATENOLOL MK                             | ATENOLOL                            |                   46
 --ALPRAZOLAM MK                           | ALPRAZOLAM                          |                   46
 --CEFALOTINA MK                           | CEFALOTINA                          |                   46
 --FENTANILO MK                            | FENTANILO                           |                   45
 --PACLITAXEL MK                           | PACLITAXEL                          |                   45
 --VERAPAMILO MK                           | VERAPAMILO                          |                   44
 --FLUCONAZOL MK                           | FLUCONAZOL                          |                   44
 --TELMISART┴N MK                          | TELMISART┴N                         |                   43
-- Más  --


-- 5. Listar el número de citas por estado y tipo de cita,
-- mostrando cuántas citas existen para cada combinación de estado y tipo,
-- ordenadas primero por estado y luego por la cantidad de citas de mayor a menor,
-- incluyendo solo aquellas combinaciones que tengan más de 3 citas.
-- Dificultad: INTERMEDIA-ALTA
SELECT
    a.status AS estado_cita,
    a.appointment_type AS tipo_cita,
    COUNT(a.appointment_id) AS total_citas
    FROM
    smart_health.appointments a
    GROUP BY
    a.status, a.appointment_type
    HAVING
    COUNT(a.appointment_id) > 3
    ORDER BY
    a.status ASC,
    total_citas DESC;

 --estado_cita |        tipo_cita        | total_citas
-------------+-------------------------+-------------
-- Attended    | Examen MÚdico           |        2189
 --Attended    | Consulta General        |        2183
 --Attended    | Nutrici¾n               |        2162
 --Attended    | Teleconsulta            |        2152
 --Attended    | Control                 |        2150
 --Attended    | PsicologÝa              |        2139
 --Attended    | Vacunaci¾n              |        2130
 --Attended    | Emergencia              |        2118
 --Attended    | Terapia                 |        2115
 --Attended    | Revisi¾n Postoperatoria |        2066
 --Cancelled   | Control                 |        1317
 --Cancelled   | PsicologÝa              |        1306
 --Cancelled   | Emergencia              |        1301
 --Cancelled   | Consulta General        |        1300
 --Cancelled   | Teleconsulta            |        1281
 --Cancelled   | Examen MÚdico           |        1279
 --Cancelled   | Vacunaci¾n              |        1276
 --Cancelled   | Revisi¾n Postoperatoria |        1263
 --Cancelled   | Nutrici¾n               |        1255
 --Cancelled   | Terapia                 |        1231
 --Confirmed   | Examen MÚdico           |        2145
 --Confirmed   | Vacunaci¾n              |        2142
 --Confirmed   | Consulta General        |        2111
 --Confirmed   | Revisi¾n Postoperatoria |        2109
 --Confirmed   | Emergencia              |        2108
 --Confirmed   | PsicologÝa              |        2105
 --Confirmed   | Terapia                 |        2103
-- Más  --


-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################