select current_database();

--tabla 1 usuario
CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    rol VARCHAR(20) CHECK (rol IN ('admin', 'vendedor', 'almacenista')) NOT NULL
);
-- Tabla Bitacora
CREATE TABLE Bitacora (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    accion TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE
);

-- Tabla Proveedor
CREATE TABLE Proveedor (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL
);

-- Tabla Producto
CREATE TABLE Producto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    proveedor_id INT NOT NULL,
    FOREIGN KEY (proveedor_id) REFERENCES Proveedor(id) ON DELETE CASCADE
);

-- Índice en la tabla Producto para mejorar búsqueda por nombre
CREATE INDEX idx_producto_nombre ON Producto(nombre);

-- Tabla Inventario
CREATE TABLE Inventario (
    id SERIAL PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    ubicacion VARCHAR(255) NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES Producto(id) ON DELETE CASCADE
);

-- Tabla Cliente
CREATE TABLE Cliente (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(15) NOT NULL
);