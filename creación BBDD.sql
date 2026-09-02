use compensarips;
CREATE TABLE especialidades (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT);
CREATE TABLE grupos_administracion (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_grupo VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT);
CREATE TABLE permisos_usuarios (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo INT NOT NULL,
    modulo VARCHAR(50) NOT NULL,
    puede_crear BOOLEAN DEFAULT FALSE,
    puede_leer BOOLEAN DEFAULT FALSE,
    puede_actualizar BOOLEAN DEFAULT FALSE,
    puede_eliminar BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_grupo) REFERENCES grupos_administracion(id_grupo) ON DELETE CASCADE);
CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    documento_identidad VARCHAR(20) NOT NULL UNIQUE,
    tarjeta_profesional VARCHAR(30) NOT NULL UNIQUE,
    id_especialidad INT NOT NULL,
    correo VARCHAR(100),
    telefono VARCHAR(20),
    FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad));
CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    tipo_documento ENUM('CC', 'TI', 'CE', 'PA', 'RC') NOT NULL,
    documento_identidad VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    genero ENUM('Masculino', 'Femenino', 'Otro') NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(100),
    correo VARCHAR(100));
CREATE TABLE medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    concentracion VARCHAR(50) NOT NULL,
    forma_farmaceutica ENUM('Tableta', 'Cápsula', 'Jarabe', 'Inyección', 'Crema', 'Gotas') NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    precio_unitario INT NOT NULL);
CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('Programada', 'Atendida', 'Cancelada', 'No asistió') NOT NULL DEFAULT 'Programada',
    observaciones TEXT,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico));
CREATE TABLE historia_clinica (
    id_historia INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_cita INT UNIQUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo_consulta TEXT NOT NULL,
    diagnostico TEXT NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita));
CREATE TABLE ordenes_medicas (
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    id_historia INT NOT NULL,
    id_medicamento INT NOT NULL,
    cantidad INT NOT NULL,
    dosis VARCHAR(100) NOT NULL,
    frecuencia VARCHAR(100) NOT NULL,
    duracion VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_historia) REFERENCES historia_clinica(id_historia),
    FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id_medicamento));
