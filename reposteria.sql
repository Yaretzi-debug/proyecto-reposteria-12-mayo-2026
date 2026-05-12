-- Script de creación: bdreposteria.sql
-- Descripción: Base de datos para sistema de repostería (13 entidades)

CREATE DATABASE IF NOT EXISTS bdreposteria;
USE bdreposteria;

-- 1. Tabla: USUARIO (Admin)
CREATE TABLE USUARIO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'vendedor', 'produccion') NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- 2. Tabla: PROVEEDOR (Inventario)
CREATE TABLE PROVEEDOR (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(120),
    direccion TEXT
);

-- 3. Tabla: CATEGORIA (Catálogo)
CREATE TABLE CATEGORIA (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    descripcion TEXT
);

-- 4. Tabla: CLIENTE (Ventas)
CREATE TABLE CLIENTE (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(120),
    direccion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notas TEXT
);

-- 5. Tabla: GASTO (Finanzas)
CREATE TABLE GASTO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    concepto VARCHAR(150) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(60),
    fecha DATE NOT NULL,
    comprobante VARCHAR(255)
);

-- 6. Tabla: PRODUCTO (Catálogo)
CREATE TABLE PRODUCTO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    precio_venta DECIMAL(10,2) NOT NULL,
    imagen_url VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES CATEGORIA(id) ON DELETE SET NULL
);

-- 7. Tabla: INGREDIENTE (Inventario)
CREATE TABLE INGREDIENTE (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proveedor_id INT,
    nombre VARCHAR(100) NOT NULL,
    stock_actual DECIMAL(10,3) DEFAULT 0,
    stock_minimo DECIMAL(10,3) DEFAULT 0,
    unidad_medida VARCHAR(20),
    costo_unitario DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(id) ON DELETE SET NULL
);

-- 8. Tabla: RECETA (Catálogo)
CREATE TABLE RECETA (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    nombre VARCHAR(120) NOT NULL,
    porciones SMALLINT,
    tiempo_prep_min SMALLINT,
    instrucciones TEXT,
    FOREIGN KEY (producto_id) REFERENCES PRODUCTO(id) ON DELETE CASCADE
);

-- 9. Tabla: RECETA_INGREDIENTE (Relación N:M)
CREATE TABLE RECETA_INGREDIENTE (
    receta_id INT,
    ingrediente_id INT,
    cantidad DECIMAL(10,3) NOT NULL,
    unidad_medida VARCHAR(20),
    PRIMARY KEY (receta_id, ingrediente_id),
    FOREIGN KEY (receta_id) REFERENCES RECETA(id) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_id) REFERENCES INGREDIENTE(id) ON DELETE CASCADE
);

-- 10. Tabla: MOVIMIENTO_INVENTARIO (Inventario)
CREATE TABLE MOVIMIENTO_INVENTARIO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ingrediente_id INT NOT NULL,
    usuario_id INT,
    tipo ENUM('entrada', 'salida', 'ajuste') NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    referencia VARCHAR(100),
    FOREIGN KEY (ingrediente_id) REFERENCES INGREDIENTE(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES USUARIO(id) ON DELETE SET NULL
);

-- 11. Tabla: PEDIDO (Ventas)
CREATE TABLE PEDIDO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    usuario_id INT,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATETIME,
    estado ENUM('nuevo', 'produccion', 'listo', 'entregado', 'cancelado') DEFAULT 'nuevo',
    total DECIMAL(10,2) DEFAULT 0,
    notas TEXT,
    FOREIGN KEY (cliente_id) REFERENCES CLIENTE(id),
    FOREIGN KEY (usuario_id) REFERENCES USUARIO(id) ON DELETE SET NULL
);

-- 12. Tabla: PEDIDO_DETALLE (Ventas)
CREATE TABLE PEDIDO_DETALLE (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad SMALLINT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    personalizacion TEXT,
    FOREIGN KEY (pedido_id) REFERENCES PEDIDO(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES PRODUCTO(id)
);

-- 13. Tabla: PAGO (Finanzas)
CREATE TABLE PAGO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('efectivo', 'transferencia', 'tarjeta') NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    referencia VARCHAR(100),
    FOREIGN KEY (pedido_id) REFERENCES PEDIDO(id) ON DELETE CASCADE
);
