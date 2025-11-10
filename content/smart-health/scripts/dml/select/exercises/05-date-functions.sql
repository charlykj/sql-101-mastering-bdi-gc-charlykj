-- ##################################################
-- # CONSULTAS DATEPART, NOW, CURRENT_DATE, EXTRACT, AGE, INTERVAL - SMART HEALTH #
-- ##################################################

-- 1. Obtener todos los pacientes que nacieron en el mes actual,
-- mostrando su nombre completo, fecha de nacimiento y edad actual en años.
-- Dificultad: BAJA
SELECT
    first_name || ' ' || first_surname || ' ' || COALESCE(second_surname, '') AS nombre_completo,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))::int AS edad_anios
    FROM
    smart_health.patients
    WHERE
    EXTRACT(MONTH FROM birth_date) = EXTRACT(MONTH FROM CURRENT_DATE)
    ORDER BY
    birth_date;


-- 2. Listar todas las citas programadas para los próximos 7 días,
-- mostrando la fecha de la cita, el nombre del paciente, el nombre del doctor,
-- y cuántos días faltan desde hoy hasta la cita.
-- Dificultad: BAJA
SELECT
    a.appointment_date,
    p.first_name || ' ' || first_surname || ' ' || COALESCE(second_surname, '') AS paciente,
    d.first_name || ' ' || d.last_name AS doctor,
    (a.appointment_date::date - CURRENT_DATE) AS dias_faltantes
    FROM
    smart_health.appointments a
    JOIN
    smart_health.patients p
    ON a.patient_id = p.patient_id
    JOIN
    smart_health.doctors d
    ON a.doctor_id = d.doctor_id
    WHERE
    a.appointment_date::date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
    ORDER BY
    a.appointment_date;


-- 3. Mostrar todos los médicos que ingresaron al hospital hace más de 5 años,
-- incluyendo su nombre completo, fecha de ingreso, y la cantidad exacta de años,
-- meses y días que han trabajado en el hospital.
-- Dificultad: BAJA-INTERMEDIA
SELECT
    d.first_name || ' ' || d.last_name AS doctor,
    d.hospital_admission_date AS fecha_ingreso,
    AGE(CURRENT_DATE, d.hospital_admission_date) AS tiempo_trabajado
    FROM
    smart_health.doctors d
    WHERE
    d.hospital_admission_date <= CURRENT_DATE - INTERVAL '5 years'
    ORDER BY
    tiempo_trabajado DESC;


-- 4. Obtener las prescripciones emitidas en el último mes,
-- mostrando la fecha de prescripción, el nombre del medicamento,
-- el nombre del paciente, cuántos días han pasado desde la prescripción,
-- y el día de la semana en que fue prescrito.
-- Dificultad: INTERMEDIA
SELECT
    p.prescription_date AS fecha_prescripcion,
    m.commercial_name AS medicamento,
    DATE_PART('day', CURRENT_DATE - p.prescription_date) AS dias_desde_prescripcion,
    TO_CHAR(p.prescription_date, 'Day') AS dia_semana
    FROM
    smart_health.prescriptions p
    JOIN
    smart_health.medications m
    ON p.medication_id = m.medication_id
    WHERE
    p.prescription_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
    AND p.prescription_date < DATE_TRUNC('month', CURRENT_DATE)
    ORDER BY
    p.prescription_date;



-- 5. Listar todos los pacientes registrados en el sistema durante el trimestre actual,
-- mostrando su nombre completo, fecha de registro, edad actual,
-- el trimestre de registro, y cuántas semanas han pasado desde su registro,
-- ordenados por fecha de registro más reciente primero.
-- Dificultad: INTERMEDIA
SELECT
    first_name || ' ' || first_surname AS nombre_completo,
    registration_date,
    DATE_PART('year', AGE(CURRENT_DATE, birth_date)) AS edad,
    EXTRACT(QUARTER FROM registration_date) AS trimestre,
    DATE_PART('week', CURRENT_DATE - registration_date) AS semanas_desde_registro
    FROM
    smart_health.patients
    WHERE
    EXTRACT(QUARTER FROM registration_date) = EXTRACT(QUARTER FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM registration_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    ORDER BY
    registration_date DESC;



-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################