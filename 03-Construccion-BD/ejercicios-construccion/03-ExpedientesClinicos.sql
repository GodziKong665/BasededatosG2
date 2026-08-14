-- ============================================================
-- BASE DE DATOS: Control de Expedientes Clinicos
-- SGBD: SQL Server (SSMS) | T-SQL
-- Origen: 02-Modelado-BD/Diccionariodedatos/01-diccionariodatos-controlescolar.md
-- Relacion: Paciente 1:1 Expediente
-- ============================================================

-- Si la base ya existe, se elimina para recrearla desde cero
IF DB_ID(N'ExpedientesClinicos') IS NOT NULL
BEGIN
    ALTER DATABASE ExpedientesClinicos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ExpedientesClinicos;
END
GO

CREATE DATABASE ExpedientesClinicos;
GO

USE ExpedientesClinicos;
GO

-- ============================================================
-- TABLA: Paciente
-- Almacena los datos de identificacion personal e informacion
-- basica de los pacientes de la clinica.
-- ============================================================
CREATE TABLE dbo.Paciente (
    num_paciente      INT           IDENTITY(1,1) NOT NULL,  -- PK, AI
    nombre            VARCHAR(50)   NOT NULL,
    apellido_paterno  VARCHAR(50)   NOT NULL,
    apellido_materno  VARCHAR(50)   NULL,                    -- opcional
    fecha_nacimiento  DATE          NOT NULL,
    CONSTRAINT PK_Paciente PRIMARY KEY (num_paciente),
    CONSTRAINT CHK_Paciente_nombre CHECK (LTRIM(RTRIM(nombre)) <> ''),
    CONSTRAINT CHK_Paciente_fecha_nacimiento CHECK (fecha_nacimiento <= CAST(GETDATE() AS DATE))
);
GO

-- ============================================================
-- TABLA: Expediente
-- Almacena los expedientes clinicos y el historial medico
-- asignado a cada paciente. Relacion 1:1 con Paciente.
-- ============================================================
CREATE TABLE dbo.Expediente (
    num_expediente   INT          IDENTITY(1,1) NOT NULL,  -- PK, AI
    fecha_apertura   DATE         NOT NULL,
    tipo_sangre      VARCHAR(5)   NOT NULL,                -- ej. O+, A-
    num_paciente     INT          NOT NULL,                -- FK, UQ -> garantiza 1:1
    CONSTRAINT PK_Expediente PRIMARY KEY (num_expediente),
    -- RN-01 / RN-02: un paciente solo puede tener UN expediente
    CONSTRAINT UQ_Expediente_num_paciente UNIQUE (num_paciente),
    -- IR-01: no existe expediente sin paciente
    -- IR-02: no se puede eliminar un paciente con expediente (NO ACTION)
    CONSTRAINT FK_Expediente_Paciente FOREIGN KEY (num_paciente)
        REFERENCES dbo.Paciente (num_paciente)
        ON DELETE NO ACTION,
    CONSTRAINT CHK_Expediente_tipo_sangre
        CHECK (tipo_sangre IN ('O+','O-','A+','A-','B+','B-','AB+','AB-'))
);
GO

-- ============================================================
-- RN-03: La fecha de apertura del expediente NO puede ser
-- anterior a la fecha de nacimiento del paciente relacionado.
-- (Se implementa con TRIGGER porque involucra dos tablas;
--  un CHECK no puede consultar otra tabla en SQL Server.)
-- ============================================================
CREATE TRIGGER trg_Expediente_validar_fecha_apertura
ON dbo.Expediente
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Paciente p ON p.num_paciente = i.num_paciente
        WHERE i.fecha_apertura < p.fecha_nacimiento
    )
    BEGIN
        RAISERROR('RN-03: La fecha de apertura no puede ser anterior a la fecha de nacimiento del paciente.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

-- ============================================================
-- DATOS DE EJEMPLO (Seed)
-- ============================================================
INSERT INTO dbo.Paciente (nombre, apellido_paterno, apellido_materno, fecha_nacimiento)
VALUES
    ('Juan',   'Perez',  'Garcia', '1995-04-12'),
    ('Maria',  'Lopez',  NULL,     '2001-09-30'),
    ('Carlos', 'Ramirez','Flores', '1988-01-25');
GO

INSERT INTO dbo.Expediente (fecha_apertura, tipo_sangre, num_paciente)
VALUES
    ('2024-02-10', 'O+', 1),
    ('2024-03-22', 'A-', 2),
    ('2025-06-15', 'B+', 3);
GO

-- ============================================================
-- CONSULTAS DE VERIFICACION
-- ============================================================

-- Ver tablas completas
SELECT * FROM dbo.Paciente;
SELECT * FROM dbo.Expediente;

-- Consulta con JOIN (relacion 1:1)
SELECT
    p.num_paciente,
    p.nombre + ' ' + p.apellido_paterno AS paciente,
    e.num_expediente,
    e.fecha_apertura,
    e.tipo_sangre
FROM dbo.Paciente p
INNER JOIN dbo.Expediente e ON e.num_paciente = p.num_paciente
ORDER BY e.fecha_apertura;

-- Prueba IR-01: debe FALLAR (paciente inexistente)
-- INSERT INTO dbo.Expediente (fecha_apertura, tipo_sangre, num_paciente)
-- VALUES ('2024-05-01', 'O+', 999);

-- Prueba RN-01: debe FALLAR (duplicado de num_paciente en Expediente)
-- INSERT INTO dbo.Expediente (fecha_apertura, tipo_sangre, num_paciente)
-- VALUES ('2024-05-01', 'O+', 1);

-- Prueba RN-03: debe FALLAR (fecha de apertura anterior al nacimiento)
-- INSERT INTO dbo.Expediente (fecha_apertura, tipo_sangre, num_paciente)
-- VALUES ('1990-01-01', 'O+', 3);
