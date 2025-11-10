-- ##################################################
-- # CONSULTAS CON JOINS Y AGREGACIÓN - SMART HEALTH #
-- ##################################################

-- 1. Contar cuántos pacientes están registrados por cada tipo de documento,
-- mostrando el nombre del tipo de documento y la cantidad total de pacientes,
-- ordenados por cantidad de mayor a menor.

-- INNER JOIN
-- smart_health.patients: FK (document_type_id)
-- smart_health.document_types: PK(document_type_id)
-- AGGREGATION FUNCTION: COUNT
SELECT
    T2.type_name AS tipo_documento,
    COUNT(*) AS total_documentos


FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
GROUP BY T2.type_name
ORDER BY total_documentos DESC;




-- 2. Obtener la cantidad de citas programadas por cada médico,
-- mostrando el nombre completo del doctor y el total de citas,
-- filtrando solo médicos con más de 5 citas, ordenados por cantidad descendente.
SELECT 
    d.first_name || ' ' || d.last_name AS nombre_completo,
    COUNT(a.appointment_id) AS total_citas
    FROM 
    smart_health.doctors d
    JOIN 
    smart_health.appointments a ON d.doctor_id = a.doctor_id
    GROUP BY 
    d.doctor_id, d.first_name, d.last_name
    HAVING 
    COUNT(a.appointment_id) > 5
    ORDER BY 
    total_citas DESC;


-- 3. Contar cuántas especialidades tiene cada médico activo,
-- mostrando el nombre del doctor y el número total de especialidades,
-- ordenados por cantidad de especialidades de mayor a menor.
SELECT 
    d.first_name || ' ' || d.last_name AS nombre_doctor,
    COUNT(ds.specialty_id) AS total_especialidades
    FROM 
    smart_health.doctors d
    JOIN 
    smart_health.doctor_specialties ds ON d.doctor_id = ds.doctor_id
    WHERE 
    d.active = TRUE
    GROUP BY 
    d.doctor_id, d.first_name, d.last_name
    ORDER BY 
    total_especialidades DESC;

-- 4. Calcular cuántos pacientes residen en cada departamento,
-- mostrando el nombre del departamento y la cantidad total de pacientes,
-- filtrando solo departamentos con al menos 3 pacientes, ordenados alfabéticamente.

SELECT
    d.department_name AS departamento,
    COUNT(p.patient_id) AS total_pacientes
    FROM
    smart_health.patients p
    JOIN
    smart_health.patient_addresses pa
    ON p.patient_id = pa.patient_id
    JOIN
    smart_health.addresses a
    ON pa.address_id = a.address_id
    JOIN
    smart_health.municipalities m
    ON a.municipality_code = m.municipality_code
    JOIN
    smart_health.departments d
    ON m.department_code = d.department_code
    GROUP BY
    d.department_name
    HAVING
    COUNT(p.patient_id) >= 3
    ORDER BY
    d.department_name ASC;



-- 5. Contar cuántas citas ha tenido cada paciente por estado de cita,
-- mostrando el nombre del paciente, estado de la cita y cantidad,
-- ordenados por nombre de paciente y estado.
SELECT
    p.first_name AS paciente,
    a.status AS estado_cita,
    COUNT(a.appointment_id) AS total_citas
    FROM
    smart_health.patients p
    JOIN
    smart_health.appointments a
    ON p.patient_id = a.patient_id
    GROUP BY
    p.first_name,
    a.status
    ORDER BY
    paciente ASC,
    estado_cita ASC;

-- 6. Calcular cuántos registros médicos ha realizado cada doctor,
-- mostrando el nombre del doctor y el total de registros,
-- filtrando solo doctores con más de 10 registros, ordenados por cantidad descendente.
SELECT
    d.first_name || ' ' || d.last_name AS doctor,
    COUNT(m.medical_record_id) AS total_registros
    FROM
    smart_health.doctors d
    JOIN
    smart_health.medical_records m
    ON d.doctor_id = m.doctor_id
    GROUP BY
    d.first_name,
    d.last_name
    HAVING
    COUNT(m.medical_record_id) > 10
    ORDER BY
    total_registros DESC;


-- 7. Contar cuántas prescripciones se han emitido para cada medicamento,
-- mostrando el nombre comercial del medicamento y el total de prescripciones,
-- filtrando medicamentos con al menos 2 prescripciones, ordenados por cantidad descendente.

SELECT
    m.commercial_name AS medicamento,
    COUNT(p.prescription_id) AS total_prescripciones
    FROM
    smart_health.medications m
    JOIN
    smart_health.prescriptions p
    ON m.medication_id = p.medication_id
    GROUP BY
    m.commercial_name
    HAVING
    COUNT(p.prescription_id) >= 2
    ORDER BY
    total_prescripciones DESC;


-- 8. Calcular cuántos pacientes tienen alergias por cada medicamento,
-- mostrando el nombre del medicamento y la cantidad de pacientes alérgicos,
-- ordenados por cantidad de mayor a menor.
SELECT
    m.commercial_name AS medicamento,
    COUNT(pa.patient_id) AS total_pacientes_alergicos
    FROM
    smart_health.medications m
    JOIN
    smart_health.patient_allergies pa
    ON m.medication_id = pa.medication_id
    GROUP BY
    m.commercial_name
    ORDER BY
    total_pacientes_alergicos DESC;


-- 9. Contar cuántas direcciones tiene registrado cada paciente,
-- mostrando el nombre del paciente y el total de direcciones,
-- filtrando solo pacientes con más de 1 dirección, ordenados por cantidad descendente.
SELECT
    p.first_name AS paciente,
    COUNT(pa.address_id) AS total_direcciones
    FROM
    smart_health.patients p
    JOIN
    smart_health.patient_addresses pa
    ON p.patient_id = pa.patient_id
    GROUP BY
    p.first_name
    HAVING
    COUNT(pa.address_id) > 1
    ORDER BY
    total_direcciones DESC;

-- 10. Calcular cuántas salas de cada tipo están activas en el hospital,
-- mostrando el tipo de sala y la cantidad total,
-- filtrando solo tipos con al menos 2 salas, ordenados por cantidad descendente.
SELECT
    r.room_type AS tipo_sala,
    COUNT(*) AS total_salas
    FROM
    smart_health.rooms r
    WHERE
    r.active = TRUE
    GROUP BY
    r.room_type
    HAVING
    COUNT(*) >= 2
    ORDER BY
    total_salas DESC;


-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################