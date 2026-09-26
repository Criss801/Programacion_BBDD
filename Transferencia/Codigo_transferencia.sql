use compensarips;

/*CREACIÓN DE TABLA DE AUDITORÍAS*/
CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50) NOT NULL,
    tipo_operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    id_registro_afectado INT NOT NULL,
    info_anterior TEXT NULL, -- Almacena los datos previos (útil para UPDATE y DELETE)
    info_nueva TEXT NULL,     -- Almacena los nuevos datos (útil para INSERT y UPDATE)
    usuario VARCHAR(100) NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*CREACIÓN DE PROCEDIMIENTOS ALMACENADOS*/
/*PROCEDIMIENTO 1*/
DELIMITER //
CREATE PROCEDURE sp_insertar_paciente(
    IN p_documento_identidad VARCHAR(20),
    IN p_tipo_documento VARCHAR(10),
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_telefono VARCHAR(20),
    IN p_correo VARCHAR(100),
    IN p_direccion VARCHAR(100)
)
BEGIN
    -- Validar si el paciente ya existe en la base de datos
    IF EXISTS (SELECT 1 FROM pacientes WHERE documento_identidad = p_documento_identidad) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe un paciente registrado con este número de documento de identidad.';
    ELSE
        -- Si no existe, se procede con la inserción
        INSERT INTO pacientes (documento_identidad, tipo_documento, nombre, apellido, telefono, correo, direccion)
        VALUES (p_documento_identidad, p_tipo_documento, p_nombre, p_apellido, p_telefono, p_correo, p_direccion);
    END IF;
END //
DELIMITER ;

/*PROCEDIMIENTO 2*/
DELIMITER //
CREATE PROCEDURE sp_actualizar_paciente(
    IN p_id_paciente INT,
    IN p_telefono VARCHAR(20),
    IN p_correo VARCHAR(100),
    IN p_direccion VARCHAR(100)
)
BEGIN
    -- Validar si el paciente existe antes de intentar actualizar
    IF NOT EXISTS (SELECT 1 FROM pacientes WHERE id_paciente = p_id_paciente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El ID del paciente especificado no existe en la base de datos.';
    ELSE
        -- Si existe, se procede con la actualización
        UPDATE pacientes 
        SET telefono = p_telefono,
            correo = p_correo,
            direccion = p_direccion
        WHERE id_paciente = p_id_paciente;
    END IF;
END //
DELIMITER ;

/*PROCEDIMIENTO 3*/
DELIMITER //
CREATE PROCEDURE sp_eliminar_paciente(
    IN p_id_paciente INT
)
BEGIN
    -- 1. Validar si el paciente existe
    IF NOT EXISTS (SELECT 1 FROM pacientes WHERE id_paciente = p_id_paciente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El ID del paciente especificado no existe en la base de datos.';
    
    -- 2. Validar si tiene citas asociadas que impidan una eliminación directa
    ELSEIF EXISTS (SELECT 1 FROM citas WHERE id_paciente = p_id_paciente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se puede eliminar el paciente porque tiene citas o historial clínico asociado. Utilice el protocolo de baja por cascada si es necesario.';
    ELSE
        -- Si pasa las validaciones, se procede con la eliminación
        DELETE FROM pacientes 
        WHERE id_paciente = p_id_paciente;
    END IF;
END //
DELIMITER ;

/*PROCEDIMIENTO 4*/
DELIMITER //
CREATE PROCEDURE sp_consultar_paciente_por_id(
    IN p_id_paciente INT
)
BEGIN
    -- Validar si el paciente existe antes de consultar
    IF NOT EXISTS (SELECT 1 FROM pacientes WHERE id_paciente = p_id_paciente) THEN
        SELECT 'El paciente con el ID especificado no se encuentra registrado en el sistema.' AS mensaje_alerta;
    ELSE
        -- Si existe, se devuelve la información completa del paciente
        SELECT id_paciente, documento_identidad, tipo_documento, nombre, apellido, telefono, correo, direccion
        FROM pacientes
        WHERE id_paciente = p_id_paciente;
    END IF;
END //
DELIMITER ;

/*PROCEDIMIENTO 5*/
DELIMITER //
CREATE PROCEDURE sp_buscar_pacientes_por_nombre(
    IN p_termino_busqueda VARCHAR(50)
)
BEGIN
    -- Se utiliza CONCAT para aplicar los comodines % alrededor del término de búsqueda
    SELECT id_paciente, documento_identidad, tipo_documento, nombre, apellido, telefono, correo, direccion
    FROM pacientes
    WHERE nombre LIKE CONCAT('%', p_termino_busqueda, '%')
       OR apellido LIKE CONCAT('%', p_termino_busqueda, '%');
END //
DELIMITER ;

/*PROCEDIMIENTO 6*/
DELIMITER //
CREATE PROCEDURE sp_listar_pacientes()
BEGIN
    -- Muestra todos los pacientes ordenados alfabéticamente por apellido y nombre
    SELECT id_paciente, documento_identidad, tipo_documento, nombre, apellido, telefono, correo, direccion
    FROM pacientes
    ORDER BY apellido ASC, nombre ASC;
END //
DELIMITER ;

/*PROCEDIMIENTO 7*/
DELIMITER //
CREATE PROCEDURE sp_contar_registros_tabla(
    IN p_nombre_tabla VARCHAR(64)
)
BEGIN
    -- Construir la instrucción SQL de manera dinámica
    SET @sql = CONCAT('SELECT "', p_nombre_tabla, '" AS tabla, COUNT(*) AS total_registros FROM ', p_nombre_tabla);
    
    -- Preparar la sentencia
    PREPARE stmt FROM @sql;
    
    -- Ejecutar la sentencia
    EXECUTE stmt;
    
    -- Liberar la sentencia preparada
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

/*PROCEDIMIENTO 8*/
DELIMITER //
CREATE PROCEDURE sp_consultar_citas_por_rango_fechas(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    -- Filtra las citas cuya fecha se encuentre entre la fecha inicial y la fecha final
    SELECT c.id_cita, 
           CONCAT(p.nombre, ' ', p.apellido) AS paciente, 
           CONCAT(m.nombre, ' ', m.apellido) AS medico, 
           c.fecha_hora, 
           c.estado
    FROM citas c
    JOIN pacientes p ON c.id_paciente = p.id_paciente
    JOIN medicos m ON c.id_medico = m.id_medico
    WHERE DATE(c.fecha_hora) BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY c.fecha_hora ASC;
END //
DELIMITER ;

/*PROCEDIMIENTO 9*/
DELIMITER //
CREATE PROCEDURE sp_calcular_costo_medicamentos_por_paciente(
    IN p_id_paciente INT
)
BEGIN
    -- Calcula el valor total de los medicamentos recetados al paciente usando SUM
    SELECT p.id_paciente, 
           CONCAT(p.nombre, ' ', p.apellido) AS paciente,
           COALESCE(SUM(om.cantidad * med.precio_unitario), 0) AS costo_total_medicamentos
    FROM pacientes p
    LEFT JOIN historia_clinica h ON p.id_paciente = h.id_paciente
    LEFT JOIN ordenes_medicas om ON h.id_historia = om.id_historia
    LEFT JOIN medicamentos med ON om.id_medicamento = med.id_medicamento
    WHERE p.id_paciente = p_id_paciente
    GROUP BY p.id_paciente, p.nombre, p.apellido;
END //
DELIMITER ;

/*PROCEDIMIENTO 10*/
DELIMITER //
CREATE PROCEDURE sp_calcular_promedio_edad_pacientes()
BEGIN
    -- Calcula el promedio de edad de todos los pacientes activos en la EPS usando AVG y TIMESTAMPDIFF
    SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE())), 2) AS promedio_edad_pacientes
    FROM pacientes;
END //
DELIMITER ;

/*PROCEDIMIENTO 11*/
DELIMITER //
CREATE PROCEDURE sp_reporte_detallado_citas()
BEGIN
    -- Relaciona citas, pacientes, médicos y especialidades mostrando información totalmente descriptiva
    SELECT c.id_cita,
           CONCAT(p.nombre, ' ', p.apellido) AS nombre_paciente,
           p.documento_identidad AS documento_paciente,
           CONCAT(m.nombre, ' ', m.apellido) AS nombre_medico,
           e.nombre_especialidad AS especialidad_medica,
           c.fecha_hora AS fecha_y_hora_cita,
           c.estado AS estado_cita
    FROM citas c
    JOIN pacientes p ON c.id_paciente = p.id_paciente
    JOIN medicos m ON c.id_medico = m.id_medico
    JOIN especialidades e ON m.id_especialidad = e.id_especialidad
    ORDER BY c.fecha_hora DESC;
END //
DELIMITER ;

/*PROCEDIMIENTO 12*/
DELIMITER //
CREATE PROCEDURE sp_agendar_cita_con_validacion(
    IN p_id_paciente INT,
    IN p_id_medico INT,
    IN p_fecha_hora DATETIME
)
BEGIN
    DECLARE v_citas_existentes INT;

    -- 1. Validar si el paciente existe
    IF NOT EXISTS (SELECT 1 FROM pacientes WHERE id_paciente = p_id_paciente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El paciente especificado no se encuentra registrado.';
        
    -- 2. Validar si el médico existe
    ELSEIF NOT EXISTS (SELECT 1 FROM medicos WHERE id_medico = p_id_medico) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El médico especificado no se encuentra registrado.';
        
    ELSE
        -- 3. Contar si el médico ya tiene una cita en el mismo horario exacto utilizando COUNT
        SELECT COUNT(*) 
        INTO v_citas_existentes
        FROM citas 
        WHERE id_medico = p_id_medico 
          AND fecha_hora = p_fecha_hora;

        -- 4. Validar la condición de negocio con IF
        IF v_citas_existentes > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error de Negocio: El médico ya tiene una cita asignada en esta fecha y hora. Seleccione otro horario.';
        ELSE
            -- Si pasa todas las validaciones lógicas, se procede a insertar la cita
            INSERT INTO citas (id_paciente, id_medico, fecha_hora, estado)
            VALUES (p_id_paciente, p_id_medico, p_fecha_hora, 'Programada');
            
            -- Mensaje de éxito opcional o confirmación
            SELECT 'Cita agendada exitosamente.' AS mensaje;
        END IF;
    END IF;
END //
DELIMITER ;

/*CREACIÓN DE TRIGGERS*/
/*TRIGGER 1*/
DELIMITER //
CREATE TRIGGER trg_audit_pacientes_insert
AFTER INSERT ON pacientes
FOR EACH ROW
BEGIN
    -- Inserta el registro de auditoría capturando los datos nuevos y metadatos del sistema
    INSERT INTO auditoria (
        tabla_afectada, 
        tipo_operacion, 
        id_registro_afectado, 
        info_anterior, 
        info_nueva, 
        usuario, 
        fecha_hora
    )
    VALUES (
        'pacientes',
        'INSERT',
        NEW.id_paciente,
        NULL, -- No hay información anterior en una inserción
        CONCAT('Documento: ', NEW.documento_identidad, ' | Nombre: ', NEW.nombre, ' ', NEW.apellido, ' | Correo: ', NEW.correo),
        USER(),
        NOW()
    );
END //
DELIMITER ;

/*TRIGGER 2*/
DELIMITER //
CREATE TRIGGER trg_audit_pacientes_update
AFTER UPDATE ON pacientes
FOR EACH ROW
BEGIN
    -- Inserta el registro de auditoría registrando los valores anteriores y nuevos
    INSERT INTO auditoria (
        tabla_afectada, 
        tipo_operacion, 
        id_registro_afectado, 
        info_anterior, 
        info_nueva, 
        usuario, 
        fecha_hora
    )
    VALUES (
        'pacientes',
        'UPDATE',
        NEW.id_paciente,
        CONCAT('Teléfono Ant: ', OLD.telefono, ' | Correo Ant: ', OLD.correo, ' | Dir Ant: ', OLD.direccion),
        CONCAT('Teléfono Nuevo: ', NEW.telefono, ' | Correo Nuevo: ', NEW.correo, ' | Dir Nueva: ', NEW.direccion),
        USER(),
        NOW()
    );
END //
DELIMITER ;

/*TRIGGER 3*/
DELIMITER //
CREATE TRIGGER trg_audit_pacientes_delete
AFTER DELETE ON pacientes
FOR EACH ROW
BEGIN
    -- Inserta el registro de auditoría guardando la información clave del registro eliminado
    INSERT INTO auditoria (
        tabla_afectada, 
        tipo_operacion, 
        id_registro_afectado, 
        info_anterior, 
        info_nueva, 
        usuario, 
        fecha_hora
    )
    VALUES (
        'pacientes',
        'DELETE',
        OLD.id_paciente,
        CONCAT('Documento: ', OLD.documento_identidad, ' | Nombre: ', OLD.nombre, ' ', OLD.apellido, ' | Correo: ', OLD.correo),
        NULL, -- No hay información nueva porque el registro fue eliminado físicamente
        USER(),
        NOW()
    );
END //
DELIMITER ;

/*TRIGGER 4*/
DELIMITER //
CREATE TRIGGER trg_audit_citas_insert
AFTER INSERT ON citas
FOR EACH ROW
BEGIN
    -- Inserta el registro de auditoría capturando los detalles de la nueva cita transaccional
    INSERT INTO auditoria (
        tabla_afectada, 
        tipo_operacion, 
        id_registro_afectado, 
        info_anterior, 
        info_nueva, 
        usuario, 
        fecha_hora
    )
    VALUES (
        'citas',
        'INSERT',
        NEW.id_cita,
        NULL, -- No hay información anterior porque es una nueva asignación
        CONCAT('ID Paciente: ', NEW.id_paciente, ' | ID Médico: ', NEW.id_medico, ' | Fecha/Hora: ', NEW.fecha_hora, ' | Estado: ', NEW.estado),
        USER(),
        NOW()
    );
END //
DELIMITER ;

/*TRIGGER 5*/
DELIMITER //
CREATE TRIGGER trg_audit_citas_update
AFTER UPDATE ON citas
FOR EACH ROW
BEGIN
    -- Inserta el registro de auditoría comparando los valores anteriores y nuevos de la cita
    INSERT INTO auditoria (
        tabla_afectada, 
        tipo_operacion, 
        id_registro_afectado, 
        info_anterior, 
        info_nueva, 
        usuario, 
        fecha_hora
    )
    VALUES (
        'citas',
        'UPDATE',
        NEW.id_cita,
        CONCAT('Fecha Ant: ', OLD.fecha_hora, ' | Estado Ant: ', OLD.estado, ' | ID Médico Ant: ', OLD.id_medico),
        CONCAT('Fecha Nueva: ', NEW.fecha_hora, ' | Estado Nuevo: ', NEW.estado, ' | ID Médico Nuevo: ', NEW.id_medico),
        USER(),
        NOW()
    );
END //
DELIMITER ;

/*TRIGGER 6*/
DELIMITER //
CREATE TRIGGER trg_audit_citas_delete
AFTER DELETE ON citas
FOR EACH ROW
BEGIN
    -- Inserta el registro de auditoría conservando toda la información clave de la cita eliminada
    INSERT INTO auditoria (
        tabla_afectada, 
        tipo_operacion, 
        id_registro_afectado, 
        info_anterior, 
        info_nueva, 
        usuario, 
        fecha_hora
    )
    VALUES (
        'citas',
        'DELETE',
        OLD.id_cita,
        CONCAT('ID Paciente: ', OLD.id_paciente, ' | ID Médico: ', OLD.id_medico, ' | Fecha/Hora: ', OLD.fecha_hora, ' | Estado: ', OLD.estado),
        NULL, -- No hay información nueva porque el registro fue eliminado físicamente
        USER(),
        NOW()
    );
END //
DELIMITER ;

/*TRIGGER 7*/
DELIMITER //
CREATE TRIGGER trg_validar_medicamento_before_insert
BEFORE INSERT ON medicamentos
FOR EACH ROW
BEGIN
    -- 1. Validar que el precio unitario no sea menor o igual a cero
    IF NEW.precio_unitario <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de Negocio: El precio unitario del medicamento debe ser mayor a cero.';
    END IF;

    -- 2. Validar que el stock o cantidad disponible no sea negativo
    IF NEW.stock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de Negocio: El stock inicial no puede ser un valor negativo.';
    END IF;
    
    -- 3. Validar que el nombre del medicamento no esté vacío o en blanco
    IF TRIM(NEW.nombre) = '' OR NEW.nombre IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de Negocio: El nombre del medicamento es un dato obligatorio.';
    END IF;
END //
DELIMITER ;

/*TRIGGER 8*/
DELIMITER //
CREATE TRIGGER trg_validar_cita_before_update
BEFORE UPDATE ON citas
FOR EACH ROW
BEGIN
    -- 1. Validar que no se intente reprogramar una cita a una fecha u hora pasada
    IF NEW.fecha_hora < NOW() AND NEW.fecha_hora <> OLD.fecha_hora THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de Negocio: No se puede reprogramar una cita a una fecha y hora pasada.';
    END IF;

    -- 2. Validar que los estados permitidos cumplan con el flujo del negocio
    IF NEW.estado NOT IN ('Programada', 'Atendida', 'Cancelada', 'No Asistió') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de Negocio: El estado ingresado no es válido dentro del sistema de la EPS.';
    END IF;
END //
DELIMITER ;