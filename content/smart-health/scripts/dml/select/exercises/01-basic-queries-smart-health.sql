-- ##################################################
-- #     CONSULTAS DE PRÁCTICA - SMART HEALTH      #
-- ##################################################

-- 1. Listar todos los pacientes de género femenino registrados en el sistema,
-- mostrando su nombre completo, correo electrónico y fecha de nacimiento,
-- ordenados por apellido de forma ascendente.

SELECT
    first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '') AS paciente,
    email AS correo_electronico,
    birth_date AS fecha_nacimiento
FROM smart_health.patients
WHERE gender = 'F'
ORDER BY first_name, first_surname
LIMIT 5;

-- 2. Consultar todos los médicos que ingresaron al hospital después del año 2020,
-- mostrando su código interno, nombre completo y fecha de admisión,
-- ordenados por fecha de ingreso de más reciente a más antiguo.
SELECT
    internal_code AS codigo_medico,
    CONCAT(first_name, ' ', last_name) AS nombre_completo,
    hospital_admission_date AS fecha_ingreso
    FROM
    smart_health.doctors
    WHERE
    EXTRACT(YEAR FROM hospital_admission_date) > 2020
    ORDER BY
    hospital_admission_date DESC;

 --codigo_medico |   nombre_completo   | fecha_ingreso
---------------+---------------------+---------------
 --DOC-2RU1E3    | Santiago Hernßndez  | 2025-12-31
 --DOC-CNI9UC    | Adriana Reyes       | 2025-12-30
 --DOC-KRA74R    | Julißn PÚrez        | 2025-12-27
 --DOC-2WBYI5    | Carolina Rinc¾n     | 2025-12-25
 --DOC-W2ZHB2    | Valentina Aguirre   | 2025-12-24
 --DOC-PLZ9KH    | Juliana PÚrez       | 2025-12-22
 --DOC-WJV12U    | Rodrigo Rojas       | 2025-12-21
 --DOC-P2N4DP    | MarÝa Montoya       | 2025-12-20
 --DOC-62U1IW    | Valentina Rojas     | 2025-12-20
 --DOC-UE1DU4    | Gabriela Soto       | 2025-12-18
 --DOC-J99R84    | Pedro JimÚnez       | 2025-12-18
 --DOC-OQ7Q44    | Carolina Castro     | 2025-12-15
 --DOC-9BZM9W    | Gabriela L¾pez      | 2025-12-11
 --DOC-DRULNU    | Luis MejÝa          | 2025-12-11
 --DOC-OVPBQA    | Manuel Lozano       | 2025-12-10
 --DOC-ECG8S2    | Juliana Lozano      | 2025-12-10
 --DOC-M65FUB    | Juan Cabrera        | 2025-12-07
 --DOC-E053V8    | Daniela MartÝnez    | 2025-12-03
 --DOC-FNRYD7    | Valentina Sußrez    | 2025-12-01
 --DOC-1BDT5X    | Luis Sußrez         | 2025-11-30
 --DOC-OUVLK6    | Miguel Salazar      | 2025-11-29
 --DOC-UIMAI0    | Vanessa Casta±o     | 2025-11-28
 --DOC-4T3Y1X    | M¾nica Gil          | 2025-11-25
 --DOC-CBTS7W    | Paola Mora          | 2025-11-24
 --DOC-VKGCOZ    | Luis Pardo          | 2025-11-23
 --DOC-VASIQ3    | Pedro Vargas        | 2025-11-23
 --DOC-QO90F9    | Hernßn Ortiz        | 2025-11-23

-- 3. Obtener todas las citas médicas con estado 'Scheduled' (Programada),
-- mostrando la fecha, hora de inicio y motivo de la consulta,
-- ordenadas por fecha y hora de manera ascendente.
SELECT
    appointment_date AS fecha,
    start_time AS hora_inicio,
    reason AS motivo
    FROM
    smart_health.appointments
    WHERE
    status = 'Scheduled'
    ORDER BY
    appointment_date ASC,
    start_time ASC;
  --fecha    | hora_inicio |                  motivo
------------+-------------+------------------------------------------
 --2020-01-01 | 07:00:00    | Control de presi¾n arterial.
 --2020-01-01 | 08:00:00    | AsesorÝa nutricional.
 --2020-01-01 | 09:15:00    | AsesorÝa nutricional.
 --2020-01-01 | 09:30:00    | Consulta por sÝntomas respiratorios.
 --2020-01-01 | 10:00:00    | Consulta por sÝntomas respiratorios.
 --2020-01-01 | 11:30:00    | Seguimiento postoperatorio.
 --2020-01-01 | 12:15:00    | AsesorÝa nutricional.
 --2020-01-01 | 12:30:00    | Control de presi¾n arterial.
 --2020-01-01 | 12:45:00    | Seguimiento postoperatorio.
 --2020-01-01 | 14:30:00    | Consulta de rutina.
 --2020-01-01 | 16:45:00    | Evaluaci¾n de resultados de laboratorio.
 --2020-01-01 | 16:45:00    | Consulta de rutina.
 --2020-01-01 | 17:45:00    | Atenci¾n por emergencia menor.
 --2020-01-01 | 17:45:00    | Control de presi¾n arterial.
 --2020-01-02 | 07:30:00    | Atenci¾n por emergencia menor.
 --2020-01-02 | 08:00:00    | AsesorÝa nutricional.
 --2020-01-02 | 08:45:00    | AsesorÝa nutricional.
 --2020-01-02 | 10:00:00    | Evaluaci¾n de resultados de laboratorio.
 --2020-01-02 | 10:30:00    | Chequeo mÚdico general.
 --2020-01-02 | 12:00:00    | Seguimiento postoperatorio.
 --2020-01-02 | 14:45:00    | Chequeo mÚdico general.
 --2020-01-02 | 16:15:00    | Consulta por sÝntomas respiratorios.
 --2020-01-03 | 08:30:00    | AsesorÝa nutricional.
 --2020-01-03 | 08:45:00    | Seguimiento postoperatorio.
 --2020-01-03 | 09:45:00    | Chequeo mÚdico general.
 --2020-01-03 | 10:30:00    | Evaluaci¾n de resultados de laboratorio.
 --2020-01-03 | 11:15:00    | Seguimiento postoperatorio.
-- Más  --


-- 4. Listar todos los medicamentos cuyo nombre comercial comience con la letra 'A',
-- mostrando el código ATC, nombre comercial y principio activo,
-- ordenados alfabéticamente por nombre comercial.
SELECT
    atc_code AS codigo_atc,
    commercial_name AS nombre_comercial,
    active_ingredient AS principio_activo
    FROM
    smart_health.medications
    WHERE
    commercial_name ILIKE 'A%'
    ORDER BY
    commercial_name ASC;
--codigo_atc |     nombre_comercial      |     principio_activo
------------+---------------------------+---------------------------
 --C07AA05    | ACEBUTALOL MK             | ACEBUTALOL
 --B01AA07    | ACENOCUMAROL MK           | ACENOCUMAROL
 --S01AX03    | ACETATO DE HIDROCORTISONA | HIDROCORTISONA
 --R05CB06    | ACETILCISTE═NA GEN╔RICO   | ACETILCISTE═NA
 --V03AE03    | ACETILCISTE═NA MK         | ACETILCISTE═NA
 --R05CB01    | ACETILCISTE═NA MK         | ACETILCISTE═NA
 --R05FA02    | ACETILCISTE═NA MK         | ACETILCISTE═NA
 --J05AF05    | ACICLOVIR GEN╔RICO        | ACICLOVIR
 --J05AB04    | ACICLOVIR MK              | ACICLOVIR
 --V07AB02    | ACIDO ASCORBICO MK        | ┴CIDO ASCËRBICO
 --A09AA02    | ACTIVOS CARBËN            | CARBËN ACTIVADO
 --V07AA02    | AGUA DESTILADA MK         | AGUA DESTILADA
 --P02CF03    | ALBENDAZOL MK             | ALBENDAZOL
 --B05XA02    | ALBUMINA HUMANA           | ALBUMINA
 --M05BA04    | ALENDRONATO MK            | ALENDRONATO SËDICO
 --G04CA02    | ALFUZOSINA MK             | ALFUZOSINA
 --M04AA01    | ALOPURINOL GEN╔RICO       | ALOPURINOL
 --N05BA12    | ALPRAZOLAM MK             | ALPRAZOLAM
 --N05BA08    | ALPRAZOLAM MK             | ALPRAZOLAM
 --N06AA09    | AMITRIPTILINA GEN╔RICO    | AMITRIPTILINA
 --C08CA01    | AMLODIPINO GEN╔RICO       | AMLODIPINO
 --J01CA04    | AMOXICILINA GENFAR        | AMOXICILINA
 --J01CA08    | AMOXICILINA/CLAVULANATO   | AMOXICILINA / CLAVULANATO
 --J01CA01    | AMPICILINA GEN╔RICO       | AMPICILINA
 --J01CA12    | AMPICILINA MK             | AMPICILINA
 --L02BB01    | ANASTROZOL MK             | ANASTROZOL
 --D05AA02    | ANTRALINA MK              | ANTRALINA
-- Más  --


-- 5. Consultar todos los diagnósticos que contengan la palabra 'diabetes' en su descripción,
-- mostrando el código CIE-10 y la descripción completa,
-- ordenados por código de diagnóstico.
SELECT
    icd_code AS "Código CIE-10",
    INITCAP(description) AS "Descripción"
    FROM
    smart_health.diagnoses
    WHERE
    description ILIKE '%diabetes%'
    ORDER BY
    icd_code;

 --Código CIE-10 |                                                                 Descripción                            
---------------+---------------------------------------------------------------------------------------------------------------------------------------------
 --E0800         | Diabetes Mellitus Debida A Afecci¾n Subyacente Con Hiperosmolaridad Sin Coma HiperglucÚmico Hiperosmolar No Cet¾sico (Chhnc)
 --E0801         | Diabetes Mellitus Debida A Afecci¾n Subyacente Con Hiperosmolaridad Con Coma
 --E0810         | Diabetes Mellitus Debida A Afecci¾n Subyacente Con Cetoacidosis Sin Coma
 --E0811         | Diabetes Mellitus Debida A Afecci¾n Subyacente Con Cetoacidosis Con Coma
 --E0821         | Diabetes Mellitus Debida A Afecci¾n Subyacente Con NefropatÝa DiabÚtica
 --E0822         | Diabetes Mellitus Debida A Afecci¾n Subyacente Con NefropatÝa DiabÚtica Cr¾nica
 --E0829         | Diabetes Mellitus Debida A Afecci¾n Subyacente Con Otra Complicaci¾n Renal DiabÚtica
 --E08311        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Especificada Con Edema Macular
 --E08319        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Especificada Sin Edema Macular
 --E08321        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Proliferativa Leve Con Edema Macular
 --E08329        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Proliferativa Leve Sin Edema Macular
 --E08331        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Proliferativa Moderada Con Edema Macular
 --E08339        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Proliferativa Moderada Sin Edema Macular
 --E08341        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Proliferativa Grave Con Edema Macular
 --E08349        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica No Proliferativa Grave Sin Edema Macular
 --E08351        | Diabetes Mellitus Debida A Afecci¾n Subyacente Con RetinopatÝa DiabÚtica Proliferativa Con Edema Macula-- Más  --


-- 6. Listar todas las salas de atención activas del hospital con capacidad mayor a 5 personas,
-- mostrando el nombre, tipo y ubicación de cada sala,
-- ordenadas por capacidad de mayor a menor.
SELECT
    room_name AS nombre_sala,
    room_type AS tipo_sala,
    location AS ubicacion,
    capacity AS capacidad
    FROM
    smart_health.rooms
    WHERE
    active = TRUE
    AND capacity > 5
    ORDER BY
    capacity DESC;

 --nombre_sala |      tipo_sala      |      ubicacion       | capacidad
-------------+---------------------+----------------------+-----------
 --Sala-0001   | Hospitalizaci¾n     | Torre Norte - 379    |        17
 --Sala-0214   | Hospitalizaci¾n     | Edificio B - 486     |        14
 --Sala-0175   | Hospitalizaci¾n     | Torre Sur - 167      |        13
 --Sala-0060   | Hospitalizaci¾n     | Piso 3 - 446         |        10
 --Sala-0038   | Emergencia          | Torre Norte - 114    |        10
 --Sala-0192   | Hospitalizaci¾n     | Piso 2 - 429         |         8
 --Sala-0017   | Farmacia            | Unidad Central - 180 |         8
 --Sala-0019   | Rehabilitaci¾n      | Torre Norte - 472    |         8
 --Sala-0055   | Hospitalizaci¾n     | Bloque C - 156       |         8
 --Sala-0059   | RadiologÝa          | Bloque C - 338       |         8
 --Sala-0086   | TraumatologÝa       | Piso 3 - 218         |         8
 --Sala-0095   | Consulta Externa    | Piso 2 - 101         |         8
 --Sala-0108   | Rehabilitaci¾n      | Torre Norte - 174    |         8
 --Sala-0117   | OdontologÝa         | Unidad Central - 448 |         8
 --Sala-0132   | Hospitalizaci¾n     | Torre Norte - 370    |         8
 --Sala-0137   | GinecologÝa         | Bloque C - 239       |         8
 --Sala-0195   | GinecologÝa         | Unidad Central - 121 |         8
 --Sala-0196   | OdontologÝa         | Piso 1 - 228         |         8
 --Sala-0209   | RadiologÝa          | Torre Sur - 346      |         8
 --Sala-0219   | Consulta Externa    | Edificio B - 230     |         8
 --Sala-0225   | Farmacia            | Piso 1 - 121         |         8
 --Sala-0230   | PsiquiatrÝa         | Unidad Central - 108 |         8
 --Sala-0052   | CardiologÝa         | Bloque C - 380       |         7
 --Sala-0100   | Emergencia          | Edificio A - 307     |         7
 --Sala-0101   | Laboratorio         | Unidad Central - 411 |         7
 --Sala-0104   | OncologÝa           | Edificio B - 293     |         7
 --Sala-0109   | Emergencia          | Torre Norte - 475    |         7
-- Más  --

-- 7. Obtener todos los pacientes que tienen tipo de sangre O+ o O-,
-- mostrando su nombre completo, tipo de sangre y fecha de nacimiento,
-- ordenados por tipo de sangre y luego por apellido.
SELECT
    CONCAT(p.first_name, ' ', 
           COALESCE(p.middle_name, ''), ' ', 
           p.first_surname, ' ', 
           COALESCE(p.second_surname, '')) AS nombre_completo,
    p.blood_type AS tipo_sangre,
    p.birth_date AS fecha_nacimiento
    FROM
    smart_health.patients p
    WHERE
    p.blood_type IN ('O+', 'O-')
    ORDER BY
    p.blood_type,
    p.first_surname;

        -- nombre_completo             | tipo_sangre | fecha_nacimiento
-----------------------------------------+-------------+------------------
 --Tatiana Armando Aguirre Serrano         | O-          | 1997-12-14
 --Sara Isabel Aguirre Andrade             | O-          | 1966-06-13
 --MarÝa  Aguirre RamÝrez                  | O-          | 2002-06-14
 --Diego Felipe Aguirre Cabrera            | O-          | 1990-03-03
 --Lorena  Aguirre PÚrez                   | O-          | 1971-05-02
 --Manuel  Aguirre Salinas                 | O-          | 1983-01-01
 --Valentina Ricardo Aguirre Ruiz          | O-          | 1982-10-14
 --Adriana  Aguirre Salinas                | O-          | 1984-02-11
 --Daniela  Aguirre G¾mez                  | O-          | 1987-06-14
 --M¾nica  Aguirre Medina                  | O-          | 1964-06-28
 --Valeria Del Pilar Aguirre Castillo      | O-          | 1987-05-15
 --Vanessa Isabel Aguirre Le¾n             | O-          | 1996-05-27
 --Valentina EstefanÝa Aguirre Molina      | O-          | 2000-12-16
 --Alejandro Mauricio Aguirre Salazar      | O-          | 1963-01-24
 --Rodrigo Del Pilar Aguirre RodrÝguez     | O-          | 2003-05-13
 --Carolina  Aguirre                       | O-          | 1965-08-26
 --Karen  Aguirre Cßrdenas                 | O-          | 1971-12-15
 --Gabriela Andrea Aguirre Salazar         | O-          | 2005-12-29
 --Angela Alejandra Aguirre Molina         | O-          | 1972-05-03
 --Paola  Aguirre Castillo                 | O-          | 1999-06-04
 --M¾nica  Aguirre MÚndez                  | O-          | 1962-03-30
 --Rafael Beatriz Aguirre PÚrez            | O-          | 1962-09-25
 --Angela  Aguirre                         | O-          | 1999-07-13
 --Rafael ┴ngel Aguirre Le¾n               | O-          | 2005-01-21
 --Adriana Paola Aguirre Salazar           | O-          | 1989-12-27
 --Valeria Beatriz Aguirre PÚrez           | O-          | 2003-02-16
 --Sebastißn Armando Aguirre Torres        | O-          | 1979-01-31
-- Más  --

-- 8. Consultar todas las direcciones activas ubicadas en un municipio específico,
-- mostrando la línea de dirección, código postal y código del municipio,
-- ordenadas por código postal.
SELECT
    address_line AS linea_direccion,
    postal_code AS codigo_postal,
    municipality_code AS codigo_municipio
    FROM
    smart_health.addresses
    WHERE
    active = TRUE
    AND municipality_code = '05001'  -- Ejemplo: código del municipio a consultar
    ORDER BY
    postal_code;

                             --   linea_direccion                                 | codigo_postal | codigo_municipio
--------------------------------------------------------------------------------+---------------+------------------
 --Cl 24 - Cl 1 - Urbano                                                          | 050033        | 05001
 --Municipio El Retorno - RÝo VaupÚs - Rural                                      | 051430        | 05001
 --Rural - V. Salado, Sabaneta Y M. Girardota - V. La Lomita, Granizal Y M. Bello | 052840        | 05001
 --Urbano - Limite Urbano - Limite Urbano                                         | 055860        | 05001
 --Rural - Mpio. San J. Del Guaviare - Mpio. Puerto Lleras                        | 056858        | 05001
 --Rural - Mpio. Piji±o Del Carmen                                                | 057447        | 05001
 --Rural - RÝo Pocito Y Chamberu - Municipio Pacora                               | 057830        | 05001
 --Urbano - Cl 5 S - Cl 10 Bis                                                    | 110311        | 05001
 --Municipio Espinal - VÝa Guamo-La Chamba - Rural                                | 132540        | 05001
 --Mpio. Quibd¾ Y El Carmen De Atrato - Mpio. CÚrtegui Y Bagad¾ - Rural           | 151007        | 05001
 --Urbano - Rio Tunjuelito                                                        | 152027        | 05001
 --Urbano - Limite Urbano                                                         | 171020        | 05001
 --Via Pto. Boyaca-San Alberto - Rural - Municipio Bolivar                        | 176020        | 05001
 --Rural - Mpio. Herveo Y Fresno                                                  | 177047        | 05001
 --Municipio Fosca - Municipio Guamal                                             | 191009        | 05001
 --Limite Urbano - Urbano                                                         | 193587        | 05001
 --Municipio Rionegro - M. San Alberto Y RÝo (Permanente) - Rural                 | 194028        | 05001
 --Cl 74 Y 73 - Urbano - Limite Urbano                                            | 250410        | 05001
 --Rural - Municipio Coper - RÝo Permanente                                       | 250827        | 05001
 --Municipio Barayß - M. Neiva Y San V. Del Cagußn                                | 251217        | 05001
 --Urbano - Limite Urbano                                                         | 252217        | 05001
 --Ca±o El Guan., Cumaral, Turpial Y Morro. - Municipio Puerto L¾pez              | 252240        | 05001
 --Rural - Mpio. Cumaribo Y San Jose Del Guavi.                                   | 272037        | 05001
 --Urbano - Limite Urbano - Limite Urbano                                         | 272058        | 05001
 --Limite Urbano - Urbano                                                         | 441027        | 05001
 --Urbano - Limite Urbano - Limite Urbano                                         | 502049        | 05001
 --Quebrada Trinidad - Rural - RÝo Sayßn Boky Y Mpio. El Carmen                   | 522087        | 05001
-- Más  --


-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################