-- ##################################################
-- # CONSULTAS UPPER, LOWER, CONCAT, LENGTH, SUBSTRING - SMART HEALTH #
-- ##################################################

-- 1. Mostrar el nombre completo de todos los pacientes en mayúsculas,
-- junto con la longitud total de su nombre completo,
-- ordenados por la longitud del nombre de mayor a menor.
-- Dificultad: BAJA
SELECT
    UPPER(first_name || ' ' || first_surname || ' ' || COALESCE(second_surname, '')) AS nombre_completo,
    LENGTH(first_name || ' ' || first_surname || ' ' || COALESCE(second_surname, '')) AS longitud_nombre
    FROM
    smart_health.patients
    ORDER BY
    longitud_nombre DESC;


-- 2. Listar todos los médicos mostrando su nombre en minúsculas,
-- su apellido en mayúsculas, y el correo electrónico profesional
-- con el dominio extraído después del símbolo '@'.
-- Dificultad: BAJA
SELECT
    LOWER(first_name) AS nombre,
    UPPER(last_name) AS apellido,
    professional_email,
    SPLIT_PART(professional_email, '@', 2) AS dominio_email
FROM
    smart_health.doctors;


-- 3. Obtener los nombres comerciales de todos los medicamentos en formato título
-- (primera letra mayúscula), junto con las primeras 3 letras del código ATC,
-- y la longitud del principio activo.
-- Dificultad: BAJA-INTERMEDIA
SELECT
    INITCAP(commercial_name) AS nombre_comercial,
    LEFT(atc_code, 3) AS codigo_atc_corto,
    LENGTH(active_ingredient) AS longitud_principio_activo
FROM
    smart_health.medications;


-- 4. Mostrar el nombre completo de los pacientes concatenado con su tipo de documento,
-- las iniciales del paciente en mayúsculas (primera letra del nombre y apellido),
-- y los últimos 4 dígitos de su número de documento.
-- Dificultad: INTERMEDIA
SELECT
    CONCAT(first_name, ' ', first_surname, ' (', document_type_id, ')') AS nombre_documento,
    UPPER(SUBSTRING(first_name FROM 1 FOR 1) || SUBSTRING(first_surname FROM 1 FOR 1)) AS iniciales,
    RIGHT(document_number, 4) AS ultimos_4_digitos
FROM
    smart_health.patients;


-- 5. Listar las especialidades médicas mostrando el nombre en mayúsculas,
-- los primeros 10 caracteres de la descripción, la longitud total de la descripción,
-- y un código generado con las primeras 3 letras de la especialidad en mayúsculas.
-- Dificultad: INTERMEDIA
SELECT
    UPPER(specialty_name) AS nombre_especialidad,
    SUBSTRING(description FROM 1 FOR 10) AS descripcion_corta,
    LENGTH(description) AS longitud_descripcion,
    UPPER(SUBSTRING(specialty_name FROM 1 FOR 3)) AS codigo_especialidad
FROM
    smart_health.specialties;



-- 6. Obtener información de las citas mostrando el nombre del paciente en formato título,
-- el tipo de cita en minúsculas, el motivo con solo los primeros 20 caracteres,
-- y un código de referencia concatenando el ID de la cita con las iniciales del doctor.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    INITCAP(p.first_name || ' ' || p.first_surname) AS nombre_paciente,
    LOWER(a.appointment_type) AS tipo_cita,
    SUBSTRING(a.reason FROM 1 FOR 20) AS motivo_corto,
    a.appointment_id || UPPER(SUBSTRING(d.first_name FROM 1 FOR 1)) || UPPER(SUBSTRING(d.last_name FROM 1 FOR 1)) AS codigo_referencia
FROM
    smart_health.appointments a
    JOIN
    smart_health.patients p
    ON a.patient_id = p.patient_id
    JOIN
    smart_health.doctors d
    ON a.doctor_id = d.doctor_id;



-- 7. Mostrar las direcciones completas concatenando todos sus componentes,
-- el código del municipio en mayúsculas, los primeros 5 caracteres de la línea de dirección,
-- la longitud de la dirección completa, y el código postal formateado en minúsculas,
-- junto con el nombre del municipio y departamento en formato título.
-- Dificultad: ALTA
SELECT
    a.address_line AS direccion_completa,
    UPPER(a.municipality_code) AS codigo_municipio,
    SUBSTRING(a.address_line FROM 1 FOR 5) AS primeros_5_chars,
    LENGTH(a.address_line) AS longitud_direccion,
    LOWER(a.postal_code) AS codigo_postal,
    INITCAP(m.municipality_name) AS municipio,
    INITCAP(d.department_name) AS departamento
FROM
    smart_health.addresses a
    JOIN
    smart_health.municipalities m
    ON a.municipality_code = m.municipality_code
    JOIN
    smart_health.departments d
    ON m.department_code = d.department_code;


-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################