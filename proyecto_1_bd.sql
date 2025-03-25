select current_database()

create TABLE Roles_Usuarios ( 
    id SERIAL PRIMARY KEY, 
    nombre_rol VARCHAR(50) NOT NULL, 
    descripcion_rol TEXT, 
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(), 
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT NOW() 
); 
 
 
CREATE TABLE Usuario ( 
    id SERIAL PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE, 
    contraseña VARCHAR(255) NOT NULL, 
    id_Roles_Usuarios INTEGER NOT NULL, 
    estado BOOLEAN NOT NULL DEFAULT TRUE, 
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(), 
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT NOW(), 
    FOREIGN KEY (id_Roles_Usuarios) REFERENCES Roles_Usuarios(id) 
); 
 
 
 
CREATE TABLE Cliente ( 
    id SERIAL PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE, 
    direccion VARCHAR(255) NOT NULL, 
    telefono VARCHAR(15) NOT NULL, 
    fecha_registro TIMESTAMP NOT NULL DEFAULT NOW(), 
    estado BOOLEAN NOT NULL DEFAULT TRUE 
); 
 
 
CREATE TABLE Proveedor ( 
    id SERIAL PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    contacto VARCHAR(100) NOT NULL, 
    direccion VARCHAR(255) NOT NULL, 
    email VARCHAR(100) UNIQUE, 
    telefono VARCHAR(15), 
    fecha_registro TIMESTAMP NOT NULL DEFAULT NOW(), 
    estado BOOLEAN NOT NULL DEFAULT TRUE 
); 
 
 
 
CREATE TABLE Categoria_Producto ( 
    id SERIAL PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    descripcion TEXT NOT NULL, 
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(), 
    estado BOOLEAN NOT NULL DEFAULT TRUE 
); 
 
 
 
CREATE TABLE Producto ( 
    id SERIAL PRIMARY KEY, 
    codigo VARCHAR(50) UNIQUE, 
    nombre VARCHAR(100) NOT NULL, 
    descripcion TEXT NOT NULL, 
    precio DECIMAL(10,2) NOT NULL, 
    stock INTEGER NOT NULL CHECK (stock >= 0), 
    id_Proveedor INTEGER NOT NULL, 
    id_Categoria INTEGER NOT NULL, 
    fecha_registro TIMESTAMP NOT NULL DEFAULT NOW(), 
    estado BOOLEAN NOT NULL DEFAULT TRUE, 
    FOREIGN KEY (id_Proveedor) REFERENCES Proveedor(id), 
    FOREIGN KEY (id_Categoria) REFERENCES Categoria_Producto(id) 
); 
 
 
 
CREATE TABLE Material ( 
    id SERIAL PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    descripcion TEXT NOT NULL, 
    unidad_medida VARCHAR(20), 
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW() 
); 
 
 
 
 
CREATE TABLE Material_Producto ( 
    id_producto INTEGER NOT NULL, 
    id_material INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL CHECK (cantidad > 0), 
    PRIMARY KEY (id_producto, id_material), 
    FOREIGN KEY (id_producto) REFERENCES Producto(id), 
    FOREIGN KEY (id_material) REFERENCES Material(id) 
); 
 
 
 
CREATE TABLE Orden_Produccion ( 
    id SERIAL PRIMARY KEY, 
    id_producto INTEGER NOT NULL, 
    fecha_inicio TIMESTAMP NOT NULL DEFAULT NOW(), 
    fecha_fin TIMESTAMP, 
    cantidad INTEGER NOT NULL, 
    estado VARCHAR(50) NOT NULL, 
    comentarios TEXT, 
    FOREIGN KEY (id_producto) REFERENCES Producto(id) 
); 
 
 
 
CREATE TABLE Material_OrdenProduccion ( 
    id_orden_produccion INTEGER NOT NULL, 
    id_material INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL CHECK (cantidad > 0), 
    PRIMARY KEY (id_orden_produccion, id_material), 
    FOREIGN KEY (id_orden_produccion) REFERENCES Orden_Produccion(id), 
    FOREIGN KEY (id_material) REFERENCES Material(id) 
); 
 
 
 
 
CREATE TABLE Inventario ( 
    id SERIAL PRIMARY KEY, 
    id_producto INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL CHECK (cantidad >= 0), 
    ubicacion VARCHAR(100) NOT NULL, 
    ultima_actualizacion TIMESTAMP NOT NULL DEFAULT NOW(), 
    FOREIGN KEY (id_producto) REFERENCES Producto(id) 
); 
 
 
 
CREATE TABLE Pedido_Maestro ( 
    id SERIAL PRIMARY KEY, 
    id_cliente INTEGER NOT NULL, 
    fecha TIMESTAMP NOT NULL DEFAULT NOW(), 
    total DECIMAL(10,2) NOT NULL, 
    direccion_envio VARCHAR(255), 
    estado_pedido VARCHAR(50) NOT NULL DEFAULT 'Pendiente', 
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id) 
); 
 
 
 
CREATE TABLE Historial_Pedido ( 
    id SERIAL PRIMARY KEY, 
    id_pedido INTEGER NOT NULL, 
    fecha TIMESTAMP NOT NULL DEFAULT NOW(), 
    estado VARCHAR(50) NOT NULL, 
    comentarios TEXT, 
    FOREIGN KEY (id_pedido) REFERENCES Pedido_Maestro(id) 
); 
 
 
 
 
CREATE TABLE Pedido_Detalle ( 
    id SERIAL PRIMARY KEY, 
    id_pedido_maestro INTEGER NOT NULL, 
    id_producto INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL CHECK (cantidad > 0), 
    precio DECIMAL(10,2) NOT NULL, 
    descuento DECIMAL(10,2) DEFAULT 0, 
    FOREIGN KEY (id_pedido_maestro) REFERENCES Pedido_Maestro(id), 
    FOREIGN KEY (id_producto) REFERENCES Producto(id) 
); 
 
 
 
CREATE TABLE Factura_Maestro ( 
    id SERIAL PRIMARY KEY, 
    id_pedido INTEGER NOT NULL, 
    numero_factura VARCHAR(50) UNIQUE, 
    fecha DATE NOT NULL DEFAULT CURRENT_DATE, 
    total DECIMAL(10,2) NOT NULL, 
    impuesto DECIMAL(10,2) DEFAULT 0, 
    descuento DECIMAL(10,2) DEFAULT 0, 
    FOREIGN KEY (id_pedido) REFERENCES Pedido_Maestro(id) 
); 
 
 
 
CREATE TABLE Factura_Detalle ( 
    id SERIAL PRIMARY KEY, 
    id_factura_maestro INTEGER NOT NULL, 
    id_producto INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL CHECK (cantidad > 0), 
    precio_unitario DECIMAL(10,2) NOT NULL, 
    FOREIGN KEY (id_factura_maestro) REFERENCES Factura_Maestro(id), 
    FOREIGN KEY (id_producto) REFERENCES Producto(id) 
); 
 
 
 
 
CREATE TABLE Contabilidad ( 
    id SERIAL PRIMARY KEY, 
    fecha DATE NOT NULL DEFAULT CURRENT_DATE, 
    tipo VARCHAR(50) NOT NULL, 
    monto DECIMAL(10,2) NOT NULL, 
    descripcion TEXT NOT NULL, 
    referencia VARCHAR(100) 
); 
 
 
 
 
CREATE TABLE Bitacora ( 
    id SERIAL PRIMARY KEY, 
    id_usuario INTEGER NOT NULL, 
    accion TEXT NOT NULL, 
    fecha TIMESTAMP NOT NULL DEFAULT NOW(), 
    ip_usuario VARCHAR(45), 
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id) 
); 
 
 
 
 
CREATE TABLE Metodo_Pago ( 
    id SERIAL PRIMARY KEY, 
    nombre VARCHAR(50) NOT NULL, 
    descripcion TEXT NOT NULL, 
    estado BOOLEAN NOT NULL DEFAULT TRUE 
); 

------- inserts--------
--Datos/inserts

INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 1', 'Descripción del rol 1');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 2', 'Descripción del rol 2');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 3', 'Descripción del rol 3');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 4', 'Descripción del rol 4');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 5', 'Descripción del rol 5');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 6', 'Descripción del rol 6');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 7', 'Descripción del rol 7');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 8', 'Descripción del rol 8');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 9', 'Descripción del rol 9');
INSERT INTO Roles_Usuarios (nombre_rol, descripcion_rol) VALUES ('Rol 10', 'Descripción del rol 10');
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario1', 'usuario1@mail.com', 'pass1', 5);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario2', 'usuario2@mail.com', 'pass2', 5);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario3', 'usuario3@mail.com', 'pass3', 10);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario4', 'usuario4@mail.com', 'pass4', 7);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario5', 'usuario5@mail.com', 'pass5', 10);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario6', 'usuario6@mail.com', 'pass6', 9);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario7', 'usuario7@mail.com', 'pass7', 10);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario8', 'usuario8@mail.com', 'pass8', 5);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario9', 'usuario9@mail.com', 'pass9', 5);
INSERT INTO Usuario (nombre, email, contraseña, id_Roles_Usuarios) VALUES ('Usuario10', 'usuario10@mail.com', 'pass10', 5);
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente1', 'cliente1@mail.com', 'Dirección 1', '555000001');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente2', 'cliente2@mail.com', 'Dirección 2', '555000002');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente3', 'cliente3@mail.com', 'Dirección 3', '555000003');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente4', 'cliente4@mail.com', 'Dirección 4', '555000004');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente5', 'cliente5@mail.com', 'Dirección 5', '555000005');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente6', 'cliente6@mail.com', 'Dirección 6', '555000006');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente7', 'cliente7@mail.com', 'Dirección 7', '555000007');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente8', 'cliente8@mail.com', 'Dirección 8', '555000008');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente9', 'cliente9@mail.com', 'Dirección 9', '555000009');
INSERT INTO Cliente (nombre, email, direccion, telefono) VALUES ('Cliente10', 'cliente10@mail.com', 'Dirección 10', '555000010');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor1', 'Contacto1', 'Dirección Prov 1', 'prov1@mail.com', '556000001');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor2', 'Contacto2', 'Dirección Prov 2', 'prov2@mail.com', '556000002');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor3', 'Contacto3', 'Dirección Prov 3', 'prov3@mail.com', '556000003');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor4', 'Contacto4', 'Dirección Prov 4', 'prov4@mail.com', '556000004');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor5', 'Contacto5', 'Dirección Prov 5', 'prov5@mail.com', '556000005');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor6', 'Contacto6', 'Dirección Prov 6', 'prov6@mail.com', '556000006');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor7', 'Contacto7', 'Dirección Prov 7', 'prov7@mail.com', '556000007');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor8', 'Contacto8', 'Dirección Prov 8', 'prov8@mail.com', '556000008');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor9', 'Contacto9', 'Dirección Prov 9', 'prov9@mail.com', '556000009');
INSERT INTO Proveedor (nombre, contacto, direccion, email, telefono) VALUES ('Proveedor10', 'Contacto10', 'Dirección Prov 10', 'prov10@mail.com', '556000010');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría1', 'Descripción categoría 1');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría2', 'Descripción categoría 2');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría3', 'Descripción categoría 3');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría4', 'Descripción categoría 4');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría5', 'Descripción categoría 5');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría6', 'Descripción categoría 6');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría7', 'Descripción categoría 7');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría8', 'Descripción categoría 8');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría9', 'Descripción categoría 9');
INSERT INTO Categoria_Producto (nombre, descripcion) VALUES ('Categoría10', 'Descripción categoría 10');
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P001', 'Producto1', 'Descripción producto 1', 28.78, 37, 1, 1);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P002', 'Producto2', 'Descripción producto 2', 34.78, 4, 9, 8);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P003', 'Producto3', 'Descripción producto 3', 12.83, 31, 9, 6);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P004', 'Producto4', 'Descripción producto 4', 64.79, 11, 5, 9);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P005', 'Producto5', 'Descripción producto 5', 89.06, 39, 8, 7);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P006', 'Producto6', 'Descripción producto 6', 32.69, 40, 7, 10);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P007', 'Producto7', 'Descripción producto 7', 71.14, 30, 7, 2);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P008', 'Producto8', 'Descripción producto 8', 44.69, 42, 5, 4);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P009', 'Producto9', 'Descripción producto 9', 31.68, 3, 2, 2);
INSERT INTO Producto (codigo, nombre, descripcion, precio, stock, id_Proveedor, id_Categoria) VALUES ('P010', 'Producto10', 'Descripción producto 10', 13.96, 33, 9, 4);
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material1', 'Descripción material 1', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material2', 'Descripción material 2', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material3', 'Descripción material 3', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material4', 'Descripción material 4', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material5', 'Descripción material 5', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material6', 'Descripción material 6', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material7', 'Descripción material 7', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material8', 'Descripción material 8', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material9', 'Descripción material 9', 'unidad');
INSERT INTO Material (nombre, descripcion, unidad_medida) VALUES ('Material10', 'Descripción material 10', 'unidad');
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (9, 7, 9);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (3, 6, 13);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (7, 7, 7);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (6, 2, 3);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (6, 4, 18);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (10, 2, 6);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (6, 8, 4);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (6, 9, 9);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (10, 1, 17);
INSERT INTO Material_Producto (id_producto, id_material, cantidad) VALUES (6, 7, 15);
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (4, CURRENT_TIMESTAMP, 19, 'En proceso', 'Comentario 1');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (5, CURRENT_TIMESTAMP, 4, 'En proceso', 'Comentario 2');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (3, CURRENT_TIMESTAMP, 20, 'En proceso', 'Comentario 3');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (10, CURRENT_TIMESTAMP, 12, 'En proceso', 'Comentario 4');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (9, CURRENT_TIMESTAMP, 15, 'En proceso', 'Comentario 5');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (4, CURRENT_TIMESTAMP, 15, 'En proceso', 'Comentario 6');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (8, CURRENT_TIMESTAMP, 9, 'En proceso', 'Comentario 7');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (5, CURRENT_TIMESTAMP, 20, 'En proceso', 'Comentario 8');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (8, CURRENT_TIMESTAMP, 18, 'En proceso', 'Comentario 9');
INSERT INTO Orden_Produccion (id_producto, fecha_fin, cantidad, estado, comentarios) VALUES (3, CURRENT_TIMESTAMP, 4, 'En proceso', 'Comentario 10');
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (3, 6, 4);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (1, 3, 4);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (10, 2, 5);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (5, 5, 2);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (9, 5, 1);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (6, 8, 5);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (2, 2, 2);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (9, 4, 3);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (2, 10, 6);
INSERT INTO Material_OrdenProduccion (id_orden_produccion, id_material, cantidad) VALUES (8, 3, 3);
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (1, 1, 'Almacén 1');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (2, 80, 'Almacén 2');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (3, 80, 'Almacén 3');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (4, 1, 'Almacén 4');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (5, 48, 'Almacén 5');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (6, 48, 'Almacén 6');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (7, 19, 'Almacén 7');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (8, 76, 'Almacén 8');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (9, 36, 'Almacén 9');
INSERT INTO Inventario (id_producto, cantidad, ubicacion) VALUES (10, 5, 'Almacén 10');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (7, 273.65, 'Dirección envío 1');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (5, 988.19, 'Dirección envío 2');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (7, 816.88, 'Dirección envío 3');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (8, 674.86, 'Dirección envío 4');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (8, 994.19, 'Dirección envío 5');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (1, 796.24, 'Dirección envío 6');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (9, 506.61, 'Dirección envío 7');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (5, 350.55, 'Dirección envío 8');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (4, 572.68, 'Dirección envío 9');
INSERT INTO Pedido_Maestro (id_cliente, total, direccion_envio) VALUES (2, 471.5, 'Dirección envío 10');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (9, 'Procesado', 'Comentario 1');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (4, 'Procesado', 'Comentario 2');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (2, 'Procesado', 'Comentario 3');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (4, 'Procesado', 'Comentario 4');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (8, 'Procesado', 'Comentario 5');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (5, 'Procesado', 'Comentario 6');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (8, 'Procesado', 'Comentario 7');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (1, 'Procesado', 'Comentario 8');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (10, 'Procesado', 'Comentario 9');
INSERT INTO Historial_Pedido (id_pedido, estado, comentarios) VALUES (6, 'Procesado', 'Comentario 10');
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (6, 3, 3, 72.02, 9.46);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (10, 8, 1, 55.77, 4.94);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (8, 10, 2, 71.98, 9.52);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (2, 7, 5, 69.19, 9.02);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (2, 3, 4, 13.01, 8.29);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (3, 1, 2, 63.44, 1.52);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (6, 2, 4, 29.44, 5.96);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (10, 1, 1, 26.01, 1.92);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (8, 3, 3, 63.25, 1.25);
INSERT INTO Pedido_Detalle (id_pedido_maestro, id_producto, cantidad, precio, descuento) VALUES (7, 1, 4, 27.64, 7.17);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (1, 'FCT0001', 881.99, 5.51, 41.42);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (2, 'FCT0002', 218.86, 16.19, 16.53);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (3, 'FCT0003', 171.88, 15.42, 33.14);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (4, 'FCT0004', 301.39, 14.55, 23.0);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (5, 'FCT0005', 881.98, 8.42, 36.58);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (6, 'FCT0006', 584.39, 16.27, 41.93);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (7, 'FCT0007', 298.72, 15.56, 1.5);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (8, 'FCT0008', 370.77, 6.31, 43.23);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (9, 'FCT0009', 221.02, 17.51, 48.5);
INSERT INTO Factura_Maestro (id_pedido, numero_factura, total, impuesto, descuento) VALUES (10, 'FCT0010', 846.75, 7.19, 31.55);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (5, 10, 3, 55.51);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (1, 1, 5, 67.27);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (10, 7, 1, 44.8);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (2, 3, 2, 26.67);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (6, 1, 5, 93.25);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (9, 2, 5, 35.83);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (6, 4, 3, 80.96);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (4, 3, 4, 46.8);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (4, 8, 2, 75.37);
INSERT INTO Factura_Detalle (id_factura_maestro, id_producto, cantidad, precio_unitario) VALUES (4, 3, 4, 11.37);
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 685.12, 'Pago recibido 1', 'REF0001');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 842.51, 'Pago recibido 2', 'REF0002');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 946.0, 'Pago recibido 3', 'REF0003');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 733.53, 'Pago recibido 4', 'REF0004');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 638.87, 'Pago recibido 5', 'REF0005');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 307.53, 'Pago recibido 6', 'REF0006');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 171.26, 'Pago recibido 7', 'REF0007');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 457.42, 'Pago recibido 8', 'REF0008');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 472.03, 'Pago recibido 9', 'REF0009');
INSERT INTO Contabilidad (tipo, monto, descripcion, referencia) VALUES ('Ingreso', 892.28, 'Pago recibido 10', 'REF0010');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (2, 'Acción 1', '192.168.0.1');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (3, 'Acción 2', '192.168.0.2');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (2, 'Acción 3', '192.168.0.3');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (6, 'Acción 4', '192.168.0.4');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (3, 'Acción 5', '192.168.0.5');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (8, 'Acción 6', '192.168.0.6');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (3, 'Acción 7', '192.168.0.7');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (5, 'Acción 8', '192.168.0.8');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (7, 'Acción 9', '192.168.0.9');
INSERT INTO Bitacora (id_usuario, accion, ip_usuario) VALUES (10, 'Acción 10', '192.168.0.10');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método1', 'Descripción método 1');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método2', 'Descripción método 2');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método3', 'Descripción método 3');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método4', 'Descripción método 4');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método5', 'Descripción método 5');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método6', 'Descripción método 6');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método7', 'Descripción método 7');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método8', 'Descripción método 8');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método9', 'Descripción método 9');
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES ('Método10', 'Descripción método 10');