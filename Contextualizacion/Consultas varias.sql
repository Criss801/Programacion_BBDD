use compensarips;
-- Consulta #1
SELECT * FROM medicos;
-- Consulta #2
SELECT * FROM pacientes;
-- Consulta #3
SELECT * FROM medicamentos;
-- Consulta #4
SELECT * FROM especialidades;
-- Consulta #5
SELECT nombre, apellido, genero, correo 
FROM pacientes 
WHERE genero = 'Femenino';
-- Consulta #6
SELECT nombre, concentracion, precio_unitario 
FROM medicamentos 
ORDER BY precio_unitario DESC;
-- Consulta #7
SELECT nombre, apellido, correo 
FROM medicos 
ORDER BY apellido ASC;
-- Consulta #8
SELECT nombre, concentracion, stock 
FROM medicamentos 
WHERE stock < 500;
-- Consulta #9
SELECT AVG(precio_unitario) AS precio_promedio 
FROM medicamentos;
-- Consulta #10
SELECT genero, COUNT(*) AS total_pacientes 
FROM pacientes 
GROUP BY genero;
-- Consulta #11
SELECT c.id_cita, p.nombre AS paciente_nombre, p.apellido AS paciente_apellido, c.fecha_hora, c.estado
FROM citas c
JOIN pacientes p ON c.id_paciente = p.id_paciente;
-- Consulta #12
SELECT c.id_cita, 
       CONCAT(p.nombre, ' ', p.apellido) AS paciente, 
       CONCAT(m.nombre, ' ', m.apellido) AS medico, 
       c.fecha_hora, c.estado 
FROM citas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;
-- Consulta #13
SELECT e.nombre AS especialidad, COUNT(m.id_medico) AS total_medicos
FROM especialidades e
LEFT JOIN medicos m ON e.id_especialidad = m.id_especialidad
GROUP BY e.id_especialidad, e.nombre;
-- Consulta #14
SELECT h.id_historia, 
       CONCAT(p.nombre, ' ', p.apellido) AS paciente, 
       h.motivo_consulta, 
       h.diagnostico 
FROM historia_clinica h
JOIN pacientes p ON h.id_paciente = p.id_paciente;
-- Consulta #15
SELECT om.id_orden, h.id_historia, med.nombre AS medicamento, om.cantidad, om.dosis, om.frecuencia 
FROM ordenes_medicas om
JOIN historia_clinica h ON om.id_historia = h.id_historia
JOIN medicamentos med ON om.id_medicamento = med.id_medicamento;
-- Consulta #16
SELECT c.id_cita, p.nombre, p.apellido, c.fecha_hora, c.observaciones 
FROM citas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE c.estado = 'Atendida';
-- Consulta #17
SELECT p.nombre, p.apellido, COUNT(c.id_cita) AS total_citas
FROM pacientes p
LEFT JOIN citas c ON p.id_paciente = c.id_paciente
GROUP BY p.id_paciente, p.nombre, p.apellido
ORDER BY total_citas DESC;
-- Consulta #18
SELECT m.nombre, m.apellido, m.correo, e.nombre AS especialidad
FROM medicos m
JOIN especialidades e ON m.id_especialidad = e.id_especialidad
WHERE e.nombre = 'Cardiología';
-- Consulta #19
SELECT forma_farmaceutica, SUM(stock) AS stock_total
FROM medicamentos
GROUP BY forma_farmaceutica
HAVING SUM(stock) > 500;
-- Consulta #20
SELECT om.id_orden, p.nombre AS paciente, med.nombre AS medicamento, med.precio_unitario, om.cantidad
FROM ordenes_medicas om
JOIN historia_clinica h ON om.id_historia = h.id_historia
JOIN pacientes p ON h.id_paciente = p.id_paciente
JOIN medicamentos med ON om.id_medicamento = med.id_medicamento
WHERE med.precio_unitario > 1000
ORDER BY om.cantidad DESC;
-- Consulta #21
SELECT nombre, apellido, fecha_nacimiento, genero
FROM pacientes
WHERE fecha_nacimiento < '1990-01-01'
ORDER BY fecha_nacimiento ASC;
-- Consulta #22
SELECT estado, COUNT(*) AS cantidad_citas
FROM citas
GROUP BY estado;
-- Consulta #23
SELECT nombre, concentracion, precio_unitario 
FROM medicamentos 
WHERE precio_unitario > (SELECT AVG(precio_unitario) FROM medicamentos);
-- Consulta #24
SELECT h.id_historia, 
       CONCAT(p.nombre, ' ', p.apellido) AS paciente, 
       CONCAT(m.nombre, ' ', m.apellido) AS medico, 
       h.diagnostico 
FROM historia_clinica h
JOIN pacientes p ON h.id_paciente = p.id_paciente
JOIN medicos m ON h.id_medico = m.id_medico;
-- Consulta #25
SELECT med.nombre, COUNT(om.id_orden) AS veces_recetado 
FROM medicamentos med
LEFT JOIN ordenes_medicas om ON med.id_medicamento = om.id_medicamento
GROUP BY med.id_medicamento, med.nombre;
-- Consulta #26
SELECT nombre, apellido, documento_identidad, correo 
FROM pacientes 
WHERE tipo_documento = 'CC';
-- Consulta #27
SELECT e.nombre AS especialidad, COUNT(m.id_medico) AS cantidad_medicos 
FROM especialidades e
JOIN medicos m ON e.id_especialidad = m.id_especialidad
GROUP BY e.nombre;
-- Consulta #28
SELECT med.nombre AS medicamento, SUM(om.cantidad) AS total_unidades_ordenadas 
FROM ordenes_medicas om
JOIN medicamentos med ON om.id_medicamento = med.id_medicamento
GROUP BY med.id_medicamento, med.nombre;
-- Consulta #29
SELECT id_cita, id_paciente, id_medico, fecha_hora, estado 
FROM citas 
WHERE fecha_hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-05 23:59:59';
-- Consulta #30
SELECT om.id_orden, 
       CONCAT(p.nombre, ' ', p.apellido) AS paciente, 
       CONCAT(m.nombre, ' ', m.apellido) AS medico, 
       med.nombre AS medicamento, 
       om.dosis, 
       om.frecuencia 
FROM ordenes_medicas om
JOIN historia_clinica h ON om.id_historia = h.id_historia
JOIN pacientes p ON h.id_paciente = p.id_paciente
JOIN medicos m ON h.id_medico = m.id_medico
JOIN medicamentos med ON om.id_medicamento = med.id_medicamento;
