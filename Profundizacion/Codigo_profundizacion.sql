use compensarips;
INSERT INTO pacientes (nombre, apellido, tipo_documento, documento_identidad, fecha_nacimiento, genero, telefono, direccion, correo) VALUES 
('Camila', 'Vargas', 'CC', '1092837465', '1998-05-14', 'Femenino', '3104567890', 'Calle 100 # 15-20', 'camila.vargas@email.com'),
('Mateo', 'Rojas', 'TI', '1005678912', '2008-11-22', 'Masculino', '3209876543', 'Carrera 45 # 120-10', 'mateo.rojas@email.com'),
('Valeria', 'Jiménez', 'CC', '1038592014', '1992-03-08', 'Femenino', '3156781234', 'Avenida Boyacá # 72-45', 'valeria.jimenez@email.com'),
('Santiago', 'Morales', 'CC', '1023948576', '1995-07-19', 'Masculino', '3112345678', 'Calle 53 # 20-30', 'santiago.morales@email.com'),
('Isabella', 'Herrera', 'TI', '1008765432', '2009-02-15', 'Femenino', '3223456789', 'Carrera 15 # 85-12', 'isabella.herrera@email.com'),
('Alejandro', 'Ortiz', 'CC', '1012345678', '1988-12-04', 'Masculino', '3134567890', 'Transversal 78 # 45-60', 'alejandro.ortiz@email.com'),
('Mariana', 'Castro', 'CC', '1045678901', '1996-09-30', 'Femenino', '3145678901', 'Calle 127 # 7-45', 'mariana.castro@email.com'),
('Daniel', 'Restrepo', 'TI', '1001234568', '2010-06-11', 'Masculino', '3216789012', 'Avenida 68 # 49-20', 'daniel.restrepo@email.com'),
('Sofía', 'Benítez', 'CC', '1056789012', '1991-01-25', 'Femenino', '3167890123', 'Carrera 30 # 10-50', 'sofia.benitez@email.com'),
('Lucas', 'Parra', 'CC', '1078901234', '1985-04-03', 'Masculino', '3178901234', 'Calle 80 # 114-10', 'lucas.parra@email.com');

INSERT INTO citas (id_paciente, id_medico, fecha_hora, estado, observaciones) VALUES 
(31, 3, '2026-09-20 09:00:00', 'Programada', 'Control por medicina general'),
(32, 12, '2026-09-18 10:30:00', 'Atendida', 'Valoración inicial exitosa'),
(33, 5, '2026-09-16 14:00:00', 'Cancelada', 'Cancelado por solicitud del paciente'),
(34, 19, '2026-09-14 11:00:00', 'No Asistió', 'El usuario no se presentó al consultorio'),
(35, 8, '2026-09-21 08:30:00', 'Programada', 'Primera vez neurología'),
(36, 2, '2026-09-19 15:30:00', 'Atendida', 'Se entregan resultados de laboratorio'),
(37, 15, '2026-09-22 10:00:00', 'Programada', 'Control periódico de especialidad'),
(38, 22, '2026-09-15 09:15:00', 'Atendida', 'Consulta prioritaria resuelta'),
(39, 10, '2026-09-23 16:00:00', 'Programada', 'Valoración especializada'),
(40, 7, '2026-09-13 11:45:00', 'Cancelada', 'Reprogramada por calamidad médica');

INSERT INTO citas (id_paciente, id_medico, fecha_hora, estado, observaciones) VALUES 
(3, 4, '2026-09-25 08:30:00', 'Programada', 'Control de rutina'),
(8, 14, '2026-09-25 10:00:00', 'Atendida', 'Atención realizada sin novedades'),
(12, 1, '2026-09-26 11:15:00', 'Cancelada', 'Paciente avisa que no puede asistir'),
(15, 20, '2026-09-26 14:00:00', 'No Asistió', 'Ausencia injustificada del usuario'),
(21, 6, '2026-09-27 09:00:00', 'Programada', 'Seguimiento por especialidad'),
(25, 11, '2026-09-27 15:30:00', 'Atendida', 'Se ajusta tratamiento médico'),
(2, 9, '2026-09-28 08:00:00', 'Programada', 'Valoración inicial'),
(14, 18, '2026-09-28 10:45:00', 'Cancelada', 'Cita cancelada por la institución'),
(29, 3, '2026-09-29 13:15:00', 'Atendida', 'Consulta general completada'),
(38, 12, '2026-09-29 16:20:00', 'No Asistió', 'No se reportó asistencia en ventana de tiempo');

INSERT INTO historia_clinica (id_paciente, id_medico, id_cita, motivo_consulta, diagnostico, observaciones) VALUES 
(31, 3, (SELECT id_cita FROM citas WHERE id_paciente = 31 AND id_medico = 3), 'Control general de rutina', 'Paciente asintomático', 'Se aconseja mantener buenos hábitos de vida.'),
(32, 12, (SELECT id_cita FROM citas WHERE id_paciente = 32 AND id_medico = 12), 'Dolor articular leve', 'Artralgia leve por sobrecarga física', 'Se receta analgésico de venta libre y reposo relativo.'),
(33, 5, (SELECT id_cita FROM citas WHERE id_paciente = 33 AND id_medico = 5), 'Revisión odontológica periódica', ' Gingivitis leve', 'Se programa limpieza dental y técnica de cepillado.'),
(34, 19, (SELECT id_cita FROM citas WHERE id_paciente = 34 AND id_medico = 19), 'Molestias visuales', 'Astigmatismo moderado', 'Se remite a optometría especializada para fórmula de lentes.'),
(35, 8, (SELECT id_cita FROM citas WHERE id_paciente = 35 AND id_medico = 8), 'Cefaleas frecuentes', 'Cefalea tensional', 'Se sugieren ejercicios de relajación y control de estrés.'),
(36, 2, (SELECT id_cita FROM citas WHERE id_paciente = 36 AND id_medico = 2), 'Control de presión arterial', 'Hipertensión arterial controlada', 'Continuar con el tratamiento farmacológico actual.'),
(37, 15, (SELECT id_cita FROM citas WHERE id_paciente = 37 AND id_medico = 15), 'Alergia cutánea estacional', 'Dermatitis de contacto', 'Se prescribe crema tópica antihistamínica.'),
(38, 22, (SELECT id_cita FROM citas WHERE id_paciente = 38 AND id_medico = 22), 'Dolor abdominal agudo', 'Gastritis leve', 'Se indica dieta blanda y protector gástrico.'),
(39, 10, (SELECT id_cita FROM citas WHERE id_paciente = 39 AND id_medico = 10), 'Control pediátrico de crecimiento', 'Desarrollo acorde a la edad', 'Vacunación al día, sin novedades.'),
(40, 7, (SELECT id_cita FROM citas WHERE id_paciente = 40 AND id_medico = 7), 'Fatiga general y mareos', 'Anemia leve', 'Se solicitan exámenes de laboratorio de control (hemograma).');

/*ACTUALIZACIÓN DE ALGUNOS DATOS DE PACIENTES*/
UPDATE pacientes
SET tipo_documento='CC',
	fecha_nacimiento='2008-01-22'
WHERE id_paciente=32;
UPDATE pacientes
SET correo='mateoco.lopez08@gmail.com'
WHERE id_paciente=2;
UPDATE pacientes
SET telefono=3017927292
WHERE id_paciente=30;

/*PROCESO PARA ELIMINAR PACIENTES*/
-- 1. Eliminar primero las órdenes médicas asociadas a las historias clínicas de esos pacientes
DELETE FROM ordenes_medicas 
WHERE id_historia IN (
    SELECT id_historia FROM historia_clinica WHERE id_paciente IN (1, 4, 15, 18));
-- 2. Eliminar las historias clínicas de los pacientes 1, 4, 15 y 18
DELETE FROM historia_clinica 
WHERE id_paciente IN (1, 4, 15, 18);
-- 3. Eliminar las citas asociadas a estos pacientes
DELETE FROM citas 
WHERE id_paciente IN (1, 4, 15, 18);
-- 4. Finalmente, eliminar a los pacientes de la tabla principal
DELETE FROM pacientes 
WHERE id_paciente IN (1, 4, 15, 18);

/*CREACIÓN DE 10 VISTAS CON BASE EN LAS CONSULTAS JOIN*/
-- vista 1
CREATE VIEW vw_citas_pacientes AS
SELECT c.id_cita, p.nombre AS paciente_nombre, p.apellido AS paciente_apellido, c.fecha_hora, c.estado
FROM citas c
JOIN pacientes p ON c.id_paciente = p.id_paciente;
-- vista 2
CREATE VIEW vw_detalle_citas AS
SELECT c.id_cita, 
       CONCAT(p.nombre, ' ', p.apellido) AS paciente, 
       CONCAT(m.nombre, ' ', m.apellido) AS medico, 
       c.fecha_hora, c.estado 
FROM citas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;
-- vista 3
CREATE VIEW vw_medicos_por_especialidad AS
SELECT e.nombre AS especialidad, COUNT(m.id_medico) AS total_medicos
FROM especialidades e
LEFT JOIN medicos m ON e.id_especialidad = m.id_especialidad
GROUP BY e.id_especialidad, e.nombre;
-- vista 4
CREATE VIEW vw_historial_pacientes AS
SELECT h.id_historia, 
       CONCAT(p.nombre, ' ', p.apellido) AS paciente, 
       h.motivo_consulta, 
       h.diagnostico 
FROM historia_clinica h
JOIN pacientes p ON h.id_paciente = p.id_paciente;
-- vista 5
CREATE VIEW vw_ordenes_medicamentos AS
SELECT om.id_orden, h.id_historia, med.nombre AS medicamento, om.cantidad, om.dosis, om.frecuencia 
FROM ordenes_medicas om
JOIN historia_clinica h ON om.id_historia = h.id_historia
JOIN medicamentos med ON om.id_medicamento = med.id_medicamento;
-- vista 6
CREATE VIEW vw_citas_atendidas AS
SELECT c.id_cita, p.nombre, p.apellido, c.fecha_hora, c.observaciones 
FROM citas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE c.estado = 'Atendida';
-- vista 7
CREATE VIEW vw_ranking_citas_pacientes AS
SELECT p.nombre, p.apellido, COUNT(c.id_cita) AS total_citas
FROM pacientes p
LEFT JOIN citas c ON p.id_paciente = c.id_paciente
GROUP BY p.id_paciente, p.nombre, p.apellido;
-- vista 8
CREATE VIEW vw_medicos_cardiologia AS
SELECT m.nombre, m.apellido, m.correo, e.nombre AS especialidad
FROM medicos m
JOIN especialidades e ON m.id_especialidad = e.id_especialidad
WHERE e.nombre = 'Cardiología';
-- vista 9
CREATE VIEW vw_medicamentos_mas_recetados AS
SELECT med.nombre, COUNT(om.id_orden) AS veces_recetado 
FROM medicamentos med
LEFT JOIN ordenes_medicas om ON med.id_medicamento = om.id_medicamento
GROUP BY med.id_medicamento, med.nombre;
-- vista 10
CREATE VIEW vw_reporte_completo_ordenes AS
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
