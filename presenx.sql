-- Eliminar y crear base de datos
DROP DATABASE IF EXISTS presenx;
CREATE DATABASE presenx CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE presenx;

SET FOREIGN_KEY_CHECKS=0;

-- Tabla usuarios simplificada con rol ENUM
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('Administrador', 'Usuario') DEFAULT 'Usuario',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar usuario admin si no existe
INSERT INTO usuarios (nombre, email, password, rol)
SELECT 'admin', 'admin@gmail.com', '$2a$12$IYF9Ys//nXehAxGi.osCT..EONKvSfrMyH8tzUqBoLetyIBD4QPxi', 'Administrador'
WHERE NOT EXISTS (
    SELECT 1 FROM usuarios WHERE email = 'admin@gmail.com'
);

-- Tabla cargos
CREATE TABLE cargos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla empresas
CREATE TABLE empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    ubicacion VARCHAR(255),
    ruc VARCHAR(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla turnos con horario base
CREATE TABLE turnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    hora_entrada TIME NOT NULL,
    hora_salida TIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla empleados con id_turno
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    cedula VARCHAR(10) NOT NULL UNIQUE,
    genero ENUM('M','F','Otro'),
    fecha_nacimiento DATE,
    email VARCHAR(100),
    telefono VARCHAR(20),
    direccion TEXT,
    fecha_ingreso DATE,
    id_cargo INT NOT NULL,
    id_turno INT DEFAULT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    foto VARCHAR(255),
    FOREIGN KEY (id_cargo) REFERENCES cargos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_turno) REFERENCES turnos(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla horarios para excepciones o ajustes temporales de empleado
CREATE TABLE horarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    hora_entrada TIME NOT NULL,
    hora_salida TIME NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE DEFAULT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla asistencias
CREATE TABLE asistencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    entrada DATETIME NOT NULL,
    salida DATETIME,
    fecha DATE GENERATED ALWAYS AS (DATE(entrada)) STORED,
    estado ENUM('puntual','tarde','falta') DEFAULT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS=1;

DELIMITER $$

CREATE TRIGGER trg_asistencias_estado
BEFORE INSERT ON asistencias
FOR EACH ROW
BEGIN
    DECLARE hora_entrada_turno TIME;
    DECLARE hora_entrada_excepcion TIME;
    DECLARE fecha_actual DATE;

    SET fecha_actual = DATE(NEW.entrada);

    -- Buscar horario excepcional activo para el empleado en la fecha de la entrada
    SELECT h.hora_entrada INTO hora_entrada_excepcion
    FROM horarios h
    WHERE h.id_empleado = NEW.id_empleado
      AND fecha_actual BETWEEN h.fecha_inicio AND IFNULL(h.fecha_fin, fecha_actual)
    ORDER BY h.fecha_inicio DESC
    LIMIT 1;

    IF hora_entrada_excepcion IS NOT NULL THEN
        SET hora_entrada_turno = hora_entrada_excepcion;
    ELSE
        -- Obtener la hora de entrada del turno asignado al empleado
        SELECT t.hora_entrada INTO hora_entrada_turno
        FROM empleados e
        LEFT JOIN turnos t ON e.id_turno = t.id
        WHERE e.id = NEW.id_empleado;
    END IF;

    -- Comparar la hora de entrada real con la hora de entrada asignada
    IF NEW.entrada IS NOT NULL THEN
        IF TIME(NEW.entrada) <= hora_entrada_turno THEN
            SET NEW.estado = 'puntual';
        ELSE
            SET NEW.estado = 'tarde';
        END IF;
    ELSE
        SET NEW.estado = 'falta';
    END IF;

END$$

DELIMITER ;

-- Insertar empresa demo
INSERT INTO empresas (nombre, telefono, email, ubicacion, ruc) VALUES
('Empresa Demo S.A.', '0000000000', 'demo@empresa.com', 'Ciudad Ficticia, Calle Falsa 123', '0000000000001');

-- Insertar cargos
INSERT INTO cargos (nombre, descripcion) VALUES
('Gerente General', 'Dirección estratégica de la empresa'),
('Desarrollador Backend', 'Desarrollo de la lógica del servidor y bases de datos'),
('Desarrollador Frontend', 'Implementación de interfaces de usuario'),
('Diseñador UX/UI', 'Diseño de experiencia e interfaces de usuario'),
('Scrum Master', 'Gestión de procesos ágiles y equipos de desarrollo'),
('Product Owner', 'Definición y priorización de requisitos del producto'),
('QA Tester', 'Pruebas y control de calidad del software'),
('DevOps Engineer', 'Automatización de infraestructura y despliegue continuo'),
('Administrador de Sistemas', 'Mantenimiento de servidores y sistemas internos'),
('Administrador de Base de Datos', 'Gestión de bases de datos y rendimiento'),
('Ingeniero de Seguridad', 'Supervisión y aplicación de seguridad informática'),
('Analista de Requisitos', 'Levantamiento y análisis de requerimientos funcionales'),
('Jefe de Proyecto', 'Supervisión general de proyectos de software'),
('Soporte Técnico', 'Atención a usuarios y resolución de incidencias'),
('Especialista en Marketing Digital', 'Promoción de productos y análisis de mercado digital');

-- Insertar turnos con horarios base
INSERT INTO turnos (nombre, hora_entrada, hora_salida) VALUES
('Turno Mañana', '08:00:00', '17:00:00'),
('Turno Tarde', '14:00:00', '23:00:00'),
('Turno Noche', '22:00:00', '06:00:00'),
('Turno Flexible', '09:00:00', '18:00:00');

-- Insertar empleados con id_cargo y id_turno asignados
INSERT INTO empleados 
(nombre, apellido, cedula, genero, fecha_nacimiento, email, telefono, direccion, fecha_ingreso, id_cargo, id_turno, estado, foto) 
VALUES
('Juan', 'Pérez', '0102030405', 'M', '1985-03-20', 'juan.perez@mail.com', '0998765432', 'Av. Siempre Viva 123', '2020-01-15', 1, 1, 'activo', NULL),
('María', 'González', '1728394056', 'F', '1990-07-10', 'maria.gonzalez@mail.com', '0991234567', 'Calle Falsa 456', '2019-06-01', 2, 2, 'activo', NULL),
('Carlos', 'Ramírez', '0918273645', 'M', '1982-12-05', 'carlos.ramirez@mail.com', '0987654321', 'Av. Central 789', '2018-09-20', 3, 3, 'activo', NULL),
('Ana', 'López', '1716151413', 'F', '1995-05-15', 'ana.lopez@mail.com', '0976543210', 'Calle Luna 321', '2021-03-10', 1, 1, 'activo', NULL),
('Luis', 'Martínez', '0123456789', 'M', '1988-11-11', 'luis.martinez@mail.com', '0998877665', 'Av. Sol 654', '2017-08-05', 2, 2, 'activo', NULL),
('Sofía', 'Fernández', '0807060504', 'F', '1992-04-22', 'sofia.fernandez@mail.com', '0997766554', 'Calle Estrella 987', '2019-12-01', 3, 3, 'activo', NULL),
('Miguel', 'Gómez', '1415161718', 'M', '1980-02-29', 'miguel.gomez@mail.com', '0988998776', 'Av. Mar 111', '2016-04-18', 1, 1, 'activo', NULL),
('Laura', 'Díaz', '0109090807', 'F', '1993-09-30', 'laura.diaz@mail.com', '0977554433', 'Calle Río 222', '2021-07-20', 2, 2, 'activo', NULL),
('Pedro', 'Santos', '0506070809', 'M', '1987-06-15', 'pedro.santos@mail.com', '0999888777', 'Av. Cielo 333', '2018-11-11', 3, 3, 'activo', NULL),
('Elena', 'Vargas', '0112233445', 'F', '1991-01-05', 'elena.vargas@mail.com', '0988776655', 'Calle Nube 444', '2020-02-28', 1, 1, 'activo', NULL);

-- Insertar horarios para empleados (excepciones o ajustes especiales)
INSERT INTO horarios (id_empleado, hora_entrada, hora_salida, fecha_inicio, fecha_fin) VALUES
(2, '10:00:00', '19:00:00', '2025-06-01', '2025-06-30'), -- María cambio horario junio 2025
(3, '12:00:00', '21:00:00', '2025-06-15', NULL);           -- Carlos horario especial indefinido

-- Día actual
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE(), ' 07:58:00'), CONCAT(CURDATE(), ' 16:01:00'));

INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (2, CONCAT(CURDATE(), ' 07:59:00'), CONCAT(CURDATE(), ' 16:05:00'));

INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (3, CONCAT(CURDATE(), ' 16:58:00'), CONCAT(CURDATE(), ' 18:10:00'));

-- 1 día antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 1 DAY, ' 08:02:00'), CONCAT(CURDATE() - INTERVAL 1 DAY, ' 16:10:00'));

-- 2 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 2 DAY, ' 07:55:00'), CONCAT(CURDATE() - INTERVAL 2 DAY, ' 15:59:00'));

-- 3 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 3 DAY, ' 08:10:00'), CONCAT(CURDATE() - INTERVAL 3 DAY, ' 16:05:00'));

-- 4 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 4 DAY, ' 07:50:00'), CONCAT(CURDATE() - INTERVAL 4 DAY, ' 15:45:00'));

-- 5 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 5 DAY, ' 08:15:00'), CONCAT(CURDATE() - INTERVAL 5 DAY, ' 16:20:00'));

-- 6 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 6 DAY, ' 07:59:00'), CONCAT(CURDATE() - INTERVAL 6 DAY, ' 15:58:00'));

-- 7 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 7 DAY, ' 08:05:00'), CONCAT(CURDATE() - INTERVAL 7 DAY, ' 16:10:00'));

-- 8 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 8 DAY, ' 08:00:00'), CONCAT(CURDATE() - INTERVAL 8 DAY, ' 16:00:00'));

-- 9 días antes
INSERT INTO asistencias (id_empleado, entrada, salida)
VALUES (1, CONCAT(CURDATE() - INTERVAL 9 DAY, ' 08:03:00'), CONCAT(CURDATE() - INTERVAL 9 DAY, ' 16:08:00'));
