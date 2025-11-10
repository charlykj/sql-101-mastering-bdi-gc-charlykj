-- ##################################################
-- # CONSULTAS GROUP BY QUERIES AND AGG FUNCTIONS WITH DATE AND STRING FUNCTIONS LIKE DATEPART, SPLIT, AGE, INTERVAL, UPPER, LOWER AND SO ON, USING JOINS - SMART HEALTH #
-- ##################################################

-- 1. Contar cuántos pacientes nacieron en cada mes del año,
-- mostrando el número del mes y el nombre del mes en mayúsculas,
-- junto con la cantidad total de pacientes nacidos en ese mes.
-- Dificultad: BAJA
SELECT
    EXTRACT(MONTH FROM birth_date)::int AS numero_mes,
    UPPER(TO_CHAR(birth_date, 'Month')) AS nombre_mes,
    COUNT(*) AS total_pacientes
    FROM
    smart_health.patients
    GROUP BY
    numero_mes,
    nombre_mes
    ORDER BY
    numero_mes;

-- 2. Mostrar el número de citas programadas agrupadas por día de la semana,
-- incluyendo el nombre del día en español y la cantidad de citas,
-- ordenadas por la cantidad de citas de mayor a menor.
-- Dificultad: BAJA
WITH dias AS (
    SELECT 0 AS dow, 'Domingo' AS nombre
    UNION ALL SELECT 1, 'Lunes'
    UNION ALL SELECT 2, 'Martes'
    UNION ALL SELECT 3, 'Miércoles'
    UNION ALL SELECT 4, 'Jueves'
    UNION ALL SELECT 5, 'Viernes'
    UNION ALL SELECT 6, 'Sábado'
)
SELECT
    d.nombre AS dia_semana,
    COUNT(*) AS total_citas
    FROM
    smart_health.appointments a
    JOIN
    dias d
    ON EXTRACT(DOW FROM a.appointment_date) = d.dow
    GROUP BY
    d.nombre, d.dow
    ORDER BY
    total_citas DESC;


-- 3. Calcular la cantidad de años promedio que los médicos han trabajado en el hospital,
-- agrupados por especialidad, mostrando el nombre de la especialidad en mayúsculas
-- y el promedio de años de experiencia redondeado a un decimal.
-- Dificultad: BAJA-INTERMEDIA

SELECT
    UPPER(s.specialty_name) AS especialidad,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, d.hospital_admission_date))), 1) AS promedio_anios_experiencia
    FROM
    smart_health.doctors d
    JOIN
    smart_health.doctor_specialties ds
    ON d.doctor_id = ds.doctor_id
    JOIN
    smart_health.specialties s
    ON ds.specialty_id = s.specialty_id
    GROUP BY
    s.specialty_name
    ORDER BY
    especialidad;


-- 4. Obtener el número de pacientes registrados por año,
-- mostrando el año de registro, el trimestre, y el total de pacientes,
-- solo para aquellos trimestres que tengan más de 2 pacientes registrados.
-- Dificultad: INTERMEDIA
SELECT
    EXTRACT(YEAR FROM registration_date)::int AS anio_registro,
    EXTRACT(QUARTER FROM registration_date)::int AS trimestre,
    COUNT(*) AS total_pacientes
FROM
    smart_health.patients
    GROUP BY
    anio_registro,
    trimestre
    HAVING
    COUNT(*) > 2
    ORDER BY
    anio_registro,
    trimestre;



-- 5. Listar el número de prescripciones emitidas por mes y año,
-- mostrando el mes en formato texto con la primera letra en mayúscula,
-- el año, y el total de prescripciones, junto con el nombre del medicamento más prescrito.
-- Dificultad: INTERMEDIA
SELECT
    INITCAP(TO_CHAR(DATE_TRUNC('month', t.prescription_month), 'Month')) AS mes,
    EXTRACT(YEAR FROM t.prescription_month)::int AS anio,
    t.total_prescripciones,
    m.medicamento_mas_prescrito
FROM (
    SELECT
        DATE_TRUNC('month', prescription_date) AS prescription_month,
        COUNT(*) AS total_prescripciones
    FROM smart_health.prescriptions
    GROUP BY DATE_TRUNC('month', prescription_date)
    ) t
    JOIN LATERAL (
    SELECT p.medication_id,
           me.commercial_name AS medicamento_mas_prescrito
    FROM smart_health.prescriptions p
    JOIN smart_health.medications me
      ON p.medication_id = me.medication_id
    WHERE DATE_TRUNC('month', p.prescription_date) = t.prescription_month
    GROUP BY me.commercial_name, p.medication_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
    ) m ON TRUE
    ORDER BY anio, t.prescription_month;



-- 6. Calcular la edad promedio de los pacientes agrupados por tipo de sangre,
-- mostrando el tipo de sangre, la edad mínima, la edad máxima y la edad promedio,
-- solo para grupos que tengan al menos 3 pacientes.
-- Dificultad: INTERMEDIA
SELECT
    blood_type AS tipo_sangre,
    MIN(EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))) AS edad_minima,
    MAX(EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))) AS edad_maxima,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))), 1) AS edad_promedio
FROM
    smart_health.patients
    GROUP BY
    blood_type
    HAVING
    COUNT(*) >= 3
    ORDER BY
    blood_type;


-- 7. Mostrar el número de citas por médico y por mes,
-- incluyendo el nombre completo del doctor en mayúsculas, el mes y año de la cita,
-- la duración promedio de las citas en minutos, y el total de citas realizadas,
-- solo para aquellos médicos que tengan más de 5 citas en el mes.
-- Dificultad: INTERMEDIA-ALTA
SELECT
    UPPER(d.first_name || ' ' || d.last_name) AS doctor,
    TO_CHAR(DATE_TRUNC('month', a.appointment_date), 'Month') AS mes,
    EXTRACT(YEAR FROM a.appointment_date)::int AS anio,
    ROUND(AVG(EXTRACT(EPOCH FROM (a.end_time - a.start_time)) / 60), 1) AS duracion_promedio_minutos,
    COUNT(*) AS total_citas
FROM
    smart_health.doctors d
    JOIN
    smart_health.appointments a
    ON d.doctor_id = a.doctor_id
    GROUP BY
    d.doctor_id,
    UPPER(d.first_name || ' ' || d.last_name),
    DATE_TRUNC('month', a.appointment_date),
    EXTRACT(YEAR FROM a.appointment_date)
    HAVING
    COUNT(*) > 5
    ORDER BY
    doctor,
    anio,
    DATE_TRUNC('month', a.appointment_date);

-- 8. Obtener estadísticas de alergias por severidad y mes de diagnóstico,
-- mostrando la severidad en minúsculas, el nombre del mes abreviado,
-- el total de alergias registradas, y el número de pacientes únicos afectados,
-- junto con el nombre comercial del medicamento más común en cada grupo.
-- Dificultad: INTERMEDIA-ALTA
SELECT
    LOWER(pa1.severity) AS severidad,
    TO_CHAR(pa1.mes, 'Mon') AS mes,
    COUNT(*) AS total_alergias,
    COUNT(DISTINCT pa1.patient_id) AS pacientes_unicos,
    (
        SELECT m.commercial_name
        FROM smart_health.patient_allergies pa2
        JOIN smart_health.medications m
          ON pa2.medication_id = m.medication_id
        WHERE pa2.severity = pa1.severity
          AND DATE_TRUNC('month', pa2.diagnosed_date) = pa1.mes
        GROUP BY m.commercial_name
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS medicamento_mas_comun
FROM (
    SELECT *,
           DATE_TRUNC('month', diagnosed_date) AS mes
    FROM smart_health.patient_allergies
        ) pa1
    GROUP BY
    pa1.severity,
    pa1.mes
    ORDER BY
    pa1.mes,
    severidad;


-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################