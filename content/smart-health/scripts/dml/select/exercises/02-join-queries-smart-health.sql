-- ##################################################
-- #   CONSULTAS CON JOINS - SMART HEALTH          #
-- ##################################################

-- 1. Listar todos los pacientes con su tipo de documento correspondiente,
-- mostrando el nombre completo del paciente, número de documento y nombre del tipo de documento,
-- ordenados por apellido del paciente.
SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,
    T1.document_number AS numero_documento,
    T2.type_name AS tipo_documento

FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
ORDER BY T1.first_surname
LIMIT 10; 


-- 2. Consultar todas las citas médicas con la información del paciente y del doctor asignado,
-- mostrando nombres completos, fecha y hora de la cita,
-- ordenadas por fecha de cita de forma descendente.

SELECT
    T2.first_name||' '||COALESCE(T2.middle_name, '')||' '||T2.first_surname||' '||COALESCE(T2.second_surname, '') AS paciente,
    T1.appointment_date AS fecha_cita,
    T1.start_time AS hora_inicio_cita,
    T1.end_time AS hora_fin_cita,
    'Dr. '||' '||T3.first_name||' '||COALESCE(T3.last_name, '') AS doctor_asignado,
    T3.internal_code AS codigo_medico

FROM smart_health.appointments T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.doctors T3
    ON T1.doctor_id = T3.doctor_id
ORDER BY T1.appointment_date DESC
LIMIT 10;


-- 3. Obtener todas las direcciones de pacientes con información completa del municipio y departamento,
-- mostrando el nombre del paciente, dirección completa y ubicación geográfica,
-- ordenadas por departamento y municipio.
SELECT
    CONCAT(
        p.first_name, ' ',
        COALESCE(p.middle_name, ''), ' ',
        p.first_surname, ' ',
        COALESCE(p.second_surname, '')
    ) AS nombre_paciente,
    a.address_line AS direccion_completa,
    CONCAT(m.municipality_name, ', ', d.department_name) AS ubicacion_geografica
    FROM
    smart_health.patient_addresses pa
    JOIN
    smart_health.patients p
    ON pa.patient_id = p.patient_id
    JOIN
    smart_health.addresses a
    ON pa.address_id = a.address_id
    JOIN
    smart_health.municipalities m
    ON a.municipality_code = m.municipality_code
    JOIN
    smart_health.departments d
    ON m.department_code = d.department_code
    ORDER BY
    d.department_name,
    m.municipality_name;

            -- nombre_paciente             |                                       direccion_completa                                       |                         ubicacion_geografica
-----------------------------------------+------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------
 --Valeria EstefanÝa Salazar Gil           | M. Piedecuesta Y Sta. Bßrbara - Rural - RÝo Tona, (Perma.) Y Q/Da. Arenales                    | LETICIA, AMAZONAS
 --Manuel  RamÝrez Pardo                   | M. Girardot Y Ricaurte - Rural                                                                 | LETICIA, AMAZONAS
 --Santiago  Rinc¾n Vargas                 | Rural - Ca±o MatavÚn - Municipio InÝrida                                                       | LETICIA, AMAZONAS
 --Santiago Antonio Mora Ortiz             | Urbano - Limite Urbano                                                                         | LETICIA, AMAZONAS
 --Pedro ┴ngel Montoya Torres              | M. JamundÝ Y Villa Rica - VÝa S. De Quilichao-Palomera                                         | LETICIA, AMAZONAS
 --Diego  Medina Serrano                   | Ca±o Vie. De MartÝnez, Lim. U. Y RÝo (Per.) - Rural                                            | LETICIA, AMAZONAS
 --Adriana  Ruiz Gil                       | RÝo (Permanente) - Municipio Guaitarilla - Rural                                               | LETICIA, AMAZONAS
 --Juliana  DÝaz Salinas                   | Ca±o Vie. De MartÝnez, Lim. U. Y RÝo (Per.) - Rural                                            | LETICIA, AMAZONAS
 --Alejandro Alejandro PÚrez               | Rural - Q/Da. Moraria Y M. Valle De S. J.                                                      | LETICIA, AMAZONAS
 --Esteban  Pardo L¾pez                    | Limite Urbano - Urbano - Limite Urbano                                                         | LETICIA, AMAZONAS
 --Juan  GutiÚrrez Lozano                  | Municipio Olaya - M. Ebejico Y San Jerronimo - Rural                                           | LETICIA, AMAZONAS
 --Ricardo  Pe±a Rojas                     | Rural - RÝo Ca±as G. Y Relieve M. - Municipio Uramita                                          | LETICIA, AMAZONAS
 --Tatiana Isabel Reyes DÝaz               | Urbano - Kr 28D                                                                                | LETICIA, AMAZONAS
-- Más  --


-- 4. Listar todos los médicos con sus especialidades asignadas,
-- mostrando el nombre del doctor, especialidad y fecha de certificación,
-- filtrando solo especialidades activas y ordenadas por apellido del médico.
SELECT
    CONCAT(
        d.first_name, ' ',
        d.last_name
    ) AS nombre_doctor,
    s.specialty_name AS especialidad,
    ds.certification_date AS fecha_certificacion
    FROM
    smart_health.doctors d
    JOIN
    smart_health.doctor_specialties ds
    ON d.doctor_id = ds.doctor_id
    JOIN
    smart_health.specialties s
    ON ds.specialty_id = s.specialty_id
    WHERE
    d.active = TRUE
    ORDER BY
    d.last_name ASC;

   -- nombre_doctor    |            especialidad             | fecha_certificacion
---------------------+-------------------------------------+---------------------
 --Paola Aguirre       | Medicina de emergencia              | 2019-08-19
 --Manuel Aguirre      | ReumatologÝa                        | 2006-04-14
 --Rafael Aguirre      | ToxicologÝa                         | 2002-07-28
 --Valentina Aguirre   | NefrologÝa                          | 2009-03-04
 --AndrÚs Aguirre      | OtorrinolaringologÝa                | 2021-10-18
 --Esteban Aguirre     | NutriologÝa                         | 2002-08-16
 --Tatiana Aguirre     | GenÚtica mÚdica                     | 2004-09-24
 --Hernßn Aguirre      | NefrologÝa                          | 2017-07-30
 --Felipe Aguirre      | AuditorÝa mÚdica                    | 2023-06-25
 --Diego Aguirre       | NutriologÝa                         | 2005-05-10
 --Vanessa Aguirre     | Medicina de emergencia              | 2017-12-06
 --Santiago Aguirre    | DermatologÝa                        | 2008-06-11
 --M¾nica Aguirre      | PediatrÝa                           | 2018-02-02
 --Isabel Aguirre      | Medicina fÝsica y rehabilitaci¾n    | 2022-10-14
 --Angela Aguirre      | Medicina del deporte                | 2018-11-22
 --Valentina Aguirre   | Medicina preventiva y salud p·blica | 2000-10-24
 --Natalia Aguirre     | Anßlisis clÝnico                    | 2020-05-19
 --Valentina Aguirre   | HepatologÝa                         | 2020-08-11
 --Manuel Aguirre      | UrologÝa                            | 2012-02-16
 --MarÝa Aguirre       | Medicina familiar y comunitaria     | 2010-08-25
 --MarÝa Aguirre       | Medicina del trabajo                | 2017-09-11
 --M¾nica Aguirre      | HepatologÝa                         | 2011-03-22
 --Hernßn Aguirre      | GenÚtica                            | 2019-10-16
 --Manuel Aguirre      | HematologÝa                         | 2005-12-27
 --Angela Aguirre      | HematologÝa                         | 2006-12-15
 --Rafael Aguirre      | AnestesiologÝa                      | 2019-08-12
 --M¾nica Aguirre      | Medicina familiar y comunitaria     | 2011-09-18
-- Más  --

-- 7. Listar todas las prescripciones médicas con información del medicamento y registro médico asociado,
-- mostrando el paciente, medicamento prescrito, dosis y si se generó alguna alerta,
-- filtrando prescripciones con alertas generadas, ordenadas por fecha de prescripción.
SELECT
    CONCAT(
        p.first_name, ' ',
        COALESCE(p.middle_name, ''), ' ',
        p.first_surname, ' ',
        COALESCE(p.second_surname, '')
    ) AS paciente,
    m.commercial_name AS medicamento_prescrito,
    pr.dosage AS dosis,
    pr.alert_generated AS alerta,
    pr.prescription_date AS fecha_prescripcion
    FROM
    smart_health.prescriptions pr
    JOIN
    smart_health.medical_records mr
    ON pr.medical_record_id = mr.medical_record_id
    JOIN
    smart_health.patients p
    ON mr.patient_id = p.patient_id
    JOIN
    smart_health.medications m
    ON pr.medication_id = m.medication_id
    WHERE
    pr.alert_generated = TRUE
    ORDER BY
    pr.prescription_date ASC;

            -- paciente               |          medicamento_prescrito          |   dosis    | alerta | fecha_prescripcion
--------------------------------------+-----------------------------------------+------------+--------+---------------------
 --Juliana Eduardo Lozano Molina        | DIMENHIDRINATO MK                       | 5 mg       | t      | 2020-01-07 09:32:26
 --Valentina Cristina DÝaz Rojas        | PERINDOPRIL INDAPAMIDA MK               | 1 tableta  | t      | 2020-01-07 14:55:29
 --Pedro DarÝo Pardo                    | NEOMICINA MK                            | 200 mg     | t      | 2020-01-08 20:25:53
 --JosÚ Enrique Montoya JimÚnez         | TETRACICLINA OFT┴LMICA GEN╔RICO         | 10 mg      | t      | 2020-01-09 00:50:17
 --Gabriela  Torres                     | METILDOPA GENFAR                        | 200 mg     | t      | 2020-01-10 14:49:33
 --Sara Alejandra Cifuentes Rubio       | CITALOPRAM MK                           | 2 cßpsulas | t      | 2020-01-11 22:15:21
 --Sara Ivßn ┴lvarez Mora               | INSULINA GLULISINA MK                   | 2 cßpsulas | t      | 2020-01-13 11:57:02
 --Mariana  RamÝrez Castillo            | HESPERIDINA MK                          | 20 mg      | t      | 2020-01-14 05:16:24
 --Andrea  Soto Gil                     | COLCHICINA MK                           | 1 ampolla  | t      | 2020-01-14 12:22:22
 --Sara Tatiana DÝaz G¾mez              | MICOFENOLATO DE MOFETILO                | 200 mg     | t      | 2020-01-20 19:45:39
 --Lorena  Mendoza Salazar              | DASATINIB MK                            | 100 mg     | t      | 2020-01-22 22:23:53
 --Gabriela  Rojas Mora                 | METFORMINA MK                           | 10 mg      | t      | 2020-01-24 04:18:11
 --Carlos  Torres G¾mez                 | QUETIAPINA MK                           | 500 mg     | t      | 2020-01-24 17:42-- Más  --


-- 8. Consultar todas las citas con información de la sala asignada (si tiene),
-- mostrando paciente, doctor, sala y horario,
-- usando LEFT JOIN para incluir citas sin sala asignada, ordenadas por fecha y hora.
SELECT
    CONCAT(
        p.first_name, ' ',
        COALESCE(p.middle_name, ''), ' ',
        p.first_surname, ' ',
        COALESCE(p.second_surname, '')
    ) AS paciente,
    CONCAT(
        d.first_name, ' ',
        d.last_name
    ) AS doctor,
    r.room_name AS sala,
    CONCAT(a.appointment_date, ' ', a.start_time, ' - ', a.end_time) AS horario
    FROM
    smart_health.appointments a
    JOIN
    smart_health.patients p
    ON a.patient_id = p.patient_id
    JOIN
    smart_health.doctors d
    ON a.doctor_id = d.doctor_id
    LEFT JOIN
    smart_health.rooms r
    ON a.room_id = r.room_id
    ORDER BY
    a.appointment_date ASC,
    a.start_time ASC;

               -- paciente                 |       doctor        |   sala    |            horario
-----------------------------------------+---------------------+-----------+--------------------------------
 --Laura Alejandra Cifuentes Rubio         | Diego PÚrez         | Sala-0024 | 2020-01-01 07:00:00 - 07:30:00
 --Javier ┴ngel Pe±a Serrano               | Miguel RamÝrez      | Sala-0009 | 2020-01-01 07:00:00 - 07:15:00
 --Gabriela Teresa DÝaz Salinas            | Daniela Montoya     | Sala-0115 | 2020-01-01 07:30:00 - 08:00:00
 --Natalia ┴ngel Cifuentes Torres          | Lorena Cifuentes    | Sala-0022 | 2020-01-01 08:00:00 - 08:45:00
 --JosÚ  Vargas                            | Gabriela Casta±o    | Sala-0235 | 2020-01-01 08:15:00 - 09:00:00
 --Santiago Enrique MejÝa Pe±a             | Pedro Medina        | Sala-0032 | 2020-01-01 08:15:00 - 08:45:00
 --Laura SofÝa RÝos Gil                    | Daniela Rinc¾n      | Sala-0008 | 2020-01-01 08:45:00 - 09:45:00
 --JosÚ Javier MartÝnez Pineda             | Andrea Lozano       | Sala-0132 | 2020-01-01 08:45:00 - 09:45:00
 --Sebastißn Javier RamÝrez Navarro        | Luis Montoya        | Sala-0139 | 2020-01-01 09:15:00 - 09:45:00
 --Karen Alberto Mendoza Molina            | Lorena Gonzßlez     | Sala-0194 | 2020-01-01 09:30:00 - 10:30:00
 --Esteban  Sußrez Cabrera                 | Gabriela Cabrera    | Sala-0117 | 2020-01-01 09:45:00 - 10:15:00
 --Mariana  MejÝa Andrade                  | Sara Cabrera        | Sala-0004 | 2020-01-01 09:45:00 - 10:45:00
 --Ëscar  Mora                             | Valentina Ortiz     | Sala-0202 | 2020-01-01 10:00:00 - 11:00:00
 --Juliana LucÝa Morales                   | Carlos JimÚnez      | Sala-0103 | 2020-01-01 10:30:00 - 11:00:00
 --Sara  Pe±a RamÝrez                      | Jorge Rojas         | Sala-0199 | 2020-01-01 10:30:00 - 11:30:00
 --Ëscar  Cifuentes                        | Rodrigo Pe±a        | Sala-0077 | 2020-01-01 10:45:00 - 11:45:00
 --Alejandro Ricardo Pe±a                  | Alejandro Casta±o   | Sala-0224 | 2020-01-01 10:45:00 - 11:00:00
 --Jorge Armando Sußrez Herrera            | Daniela Cifuentes   | Sala-0098 | 2020-01-01 11:15:00 - 12:00:00
 --Natalia  Mendoza Cßrdenas               | Sebastißn MejÝa     | Sala-0031 | 2020-01-01 11:15:00 - 11:45:00
 --Jorge  Cßrdenas DÝaz                    | Jorge Rinc¾n        | Sala-0044 | 2020-01-01 11:30:00 - 12:00:00
 --Angela Tatiana L¾pez RamÝrez            | Valeria Cßrdenas    | Sala-0049 | 2020-01-01 11:45:00 - 12:00:00
 --Javier ┴ngel Cßrdenas L¾pez             | Ricardo ┴lvarez     | Sala-0159 | 2020-01-01 11:45:00 - 12:00:00
 --Angela Carolina Soto Salazar            | Carolina Aguirre    | Sala-0180 | 2020-01-01 12:00:00 - 13:00:00
 --Santiago  Reyes                         | Isabel GutiÚrrez    | Sala-0248 | 2020-01-01 12:15:00 - 12:30:00
 --Angela  Salazar Lozano                  | Laura Lozano        | Sala-0208 | 2020-01-01 12:30:00 - 12:45:00
 --Andrea Carolina Ruiz Molina             | Gabriela Salazar    | Sala-0177 | 2020-01-01 12:45:00 - 13:00:00
 --Manuel  MartÝnez Soto                   | Daniela Soto        | Sala-0127 | 2020-01-01 13:15:00 - 13:45:00
 --Natalia Patricia Vega Pe±a              | Julißn JimÚnez      | Sala-0211 | 2020-01-01 13:45:00 - 14:45:00
-- Más  --

-- 9. Listar todos los teléfonos de pacientes con información completa del paciente,
-- mostrando nombre, tipo de teléfono, número y si es el teléfono principal,
-- filtrando solo teléfonos móviles, ordenados por nombre del paciente.
SELECT
    CONCAT(
        p.first_name, ' ',
        COALESCE(p.middle_name, ''), ' ',
        p.first_surname, ' ',
        COALESCE(p.second_surname, '')
    ) AS nombre_paciente,
    ph.phone_type AS tipo_telefono,
    ph.phone_number AS numero,
    ph.is_primary AS telefono_principal
    FROM
    smart_health.patient_phones ph
    JOIN
    smart_health.patients p
    ON ph.patient_id = p.patient_id
    WHERE
    ph.phone_type ILIKE 'Móvil'
    ORDER BY
    nombre_paciente ASC;


-- 10. Obtener todos los doctores que NO tienen especialidades asignadas (ANTI JOIN),
-- mostrando su información básica y fecha de ingreso,
-- útil para identificar médicos que requieren actualización de información,
-- ordenados por fecha de ingreso al hospital.
SELECT
    d.doctor_id AS codigo_medico,
    CONCAT(d.first_name, ' ', d.last_name) AS nombre_completo,
    d.professional_email AS correo_profesional,
    d.hospital_admission_date AS fecha_ingreso
    FROM
    smart_health.doctors d
    LEFT JOIN
    smart_health.doctor_specialties ds
    ON d.doctor_id = ds.doctor_id
    WHERE
    ds.specialty_id IS NULL
    ORDER BY
    d.hospital_admission_date ASC;

--codigo_medico |   nombre_completo   |            correo_profesional            | fecha_ingreso
---------------+---------------------+------------------------------------------+---------------
         -- 9617 | Andrea RamÝrez      | andrea.ramirez@sura.com                  | 1995-01-05
          --5261 | Juliana Gonzßlez    | juliana.gonzalez2@saludtotal.com         | 1995-01-08
         -- 6482 | AndrÚs Casta±o      | andres.castano@hospitalcentral.com       | 1995-01-14
          --6858 | Fernando Morales    | fernando.morales3@unipamplona.com        | 1995-01-15
          --5326 | Sara Medina         | sara.medina2@saludtotal.com              | 1995-01-19
          -- 229 | Esteban Ruiz        | esteban.ruiz@unipamplona.com             | 1995-01-21
          --8714 | Sara Rojas          | sara.rojas2@positivaarl.com              | 1995-01-23
          --1672 | Daniela MejÝa       | daniela.mejia@hospitalcentral.com        | 1995-01-24
          --3329 | Daniela ┴lvarez     | daniela.alvarez@sura.com                 | 1995-01-25
          --5044 | Sebastißn PÚrez     | sebastian.perez2@medicosasociados.com    | 1995-01-28
          --5895 | Sara Vega           | sara.vega@unipamplona.com                | 1995-01-28
          --3401 | Julißn Rinc¾n       | julian.rincon2@medicosasociados.com      | 1995-01-29
          --1675 | Paola Pardo         | paola.pardo@hospitalcentral.com          | 1995-01-30
          --8617 | Valeria Rinc¾n      | valeria.rincon@saludtotal.com            | 1995-01-31
          --3895 | Juan Pardo          | juan.pardo@clinicanorte.com              | 1995-02-01
          --1836 | Andrea Sußrez       | andrea.suarez@clinicanorte.com           | 1995-02-05
          --1053 | Lorena Rinc¾n       | lorena.rincon@saludtotal.com             | 1995-02-09
          --1117 | Luis RamÝrez        | luis.ramirez@sura.com                    | 1995-02-09
          --1877 | Karen Mora          | karen.mora2@clinicanorte.com             | 1995-02-15
          --7892 | Diego Morales       | diego.morales3@medicosasociados.com      | 1995-02-16
          --9412 | MarÝa Pineda        | maria.pineda2@saludtotal.com             | 1995-02-16
          --9620 | Laura RamÝrez       | laura.ramirez2@hospitalcentral.com       | 1995-02-22
           --242 | Gabriela Casta±o    | gabriela.castano@positivaarl.com         | 1995-02-23
          --1766 | Camila Herrera      | camila.herrera@saludtotal.com            | 1995-02-23
           --175 | Carolina Pardo      | carolina.pardo@medicosasociados.com      | 1995-02-23
          --7933 | Adriana Navarro     | adriana.navarro@saludtotal.com           | 1995-02-28
          --2180 | Carlos Pineda       | carlos.pineda@positivaarl.com            | 1995-03-01
-- Más  --
-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################