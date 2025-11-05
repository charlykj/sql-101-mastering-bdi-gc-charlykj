--1, cuantos doctores hay ordenar por le primer nombre de forma desendente .
--solo motrasr los primeros 10 resultados 
SELECT
    'Dr.'||first_name||' '||last_name AS fullmane,
    medical_license_number
FROM smart_health.doctors 
WHERE active = TRUE
ORDER BY first_name 
LIMIT 10;

----La primera consulta obtiene los nombres y apellidos de los pacientes registrados, 
---junto con su correo electrónico y fecha de nacimiento, 
--ordenados por fecha de registro de manera descendente para visualizar los más recientes primero.
-- Esta consulta usa un alias para facilitar la lectura de las columnas en la salida y un límite para mostrar solo los diez registros más recientes.
SELECT
    first_name || ' ' || first_surname AS fullname,
    email AS "Correo Electrónico",
    birth_date AS "Fecha de Nacimiento"
FROM
    smart_health.patients
ORDER BY
    registration_date DESC
LIMIT 10;
----La segunda consulta selecciona los nombres completos de los médicos activos junto con su número de licencia médica,
-- ordenando alfabéticamente por apellidos. También aplica alias a las columnas para mostrar 
---un encabezado más legible y limita el resultado a los primeros 20 doctores.

SELECT
    'Dr. ' || first_name || ' ' || last_name AS "Nombre Completo",
    medical_license_number AS "Número de Licencia"
FROM smart_health.doctors
WHERE active = TRUE
ORDER BY last_name
LIMIT 20;


-- La tercera consulta obtiene el listado de municipios y sus respectivos departamentos, 
-- uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar la localización geográfica, 
-- mostrando los 15 primeros resultados.

SELECT
    m.municipality_name AS "Municipio",
    d.department_name AS "Departamento"
FROM 
    smart_health.municipalities m, 
    smart_health.departments d
WHERE 
    m.department_code = d.department_code
ORDER BY 
    d.department_name
LIMIT 15;

-- La cuarta consulta selecciona las citas médicas programadas (tabla appointments), 
-- mostrando el tipo de cita, el estado actual y la fecha correspondiente. 
-- Se utiliza un alias para cada campo y se ordena por fecha de cita en orden ascendente, 
-- limitando la salida a las próximas 10 citas.

SELECT
    appointment_type AS "Tipo de Cita",
    status AS "Estado Actual",
    appointment_date AS "Fecha de Cita"
FROM 
    smart_health.appointments
ORDER BY 
    appointment_date ASC
LIMIT 10;

-- Finalmente, la quinta consulta obtiene los nombres comerciales de los medicamentos 
-- junto con su ingrediente activo, presentándolos de forma alfabética. 
-- Se usa alias para mejorar la presentación de los encabezados 
-- y un límite de 25 registros, ideal para una vista rápida del catálogo farmacológico disponible.

SELECT
    commercial_name AS "Nombre Comercial",
    active_ingredient AS "Ingrediente Activo"
FROM 
    smart_health.medications
ORDER BY 
    commercial_name ASC
LIMIT 25;