-- 1. CATEGORÍAS
CREATE TABLE categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    icono VARCHAR(50),
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. PRODUCTOS
CREATE TABLE productos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categoria_id UUID REFERENCES categorias(id) ON DELETE SET NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2) NOT NULL,
    unidad_medida VARCHAR(20) DEFAULT 'unidad',
    stock_disponible NUMERIC(10, 2) NOT NULL DEFAULT 0,
    imagen_url TEXT,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. CLIENTES
CREATE TABLE clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_completo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL UNIQUE,
    manzana_calle VARCHAR(100) NOT NULL,
    numero_casa VARCHAR(50) NOT NULL,
    referencia_direccion TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. MÉTODOS DE PAGO
CREATE TABLE metodos_pago (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    datos_instruccion TEXT,
    requiere_comprobante BOOLEAN DEFAULT TRUE,
    activo BOOLEAN DEFAULT TRUE
);

-- 5. PEDIDOS
CREATE TABLE pedidos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo_orden VARCHAR(10) UNIQUE NOT NULL,
    cliente_id UUID REFERENCES clientes(id) ON DELETE RESTRICT,
    metodo_pago_id UUID REFERENCES metodos_pago(id) ON DELETE RESTRICT,
    monto_subtotal NUMERIC(10, 2) NOT NULL,
    monto_delivery NUMERIC(10, 2) DEFAULT 0.00,
    monto_total NUMERIC(10, 2) NOT NULL,
    estado_pago VARCHAR(30) DEFAULT 'PENDIENTE_VERIFICACION',
    estado_pedido VARCHAR(30) DEFAULT 'POR_CONFIRMAR',
    referencia_pago VARCHAR(100),
    comprobante_url TEXT,
    cambio_efectivo_requerido NUMERIC(10, 2),
    notas_cliente TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. DETALLES DE PEDIDO
CREATE TABLE detalles_pedido (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pedido_id UUID REFERENCES pedidos(id) ON DELETE CASCADE,
    producto_id UUID REFERENCES productos(id) ON DELETE RESTRICT,
    precio_unitario NUMERIC(10, 2) NOT NULL,
    cantidad NUMERIC(10, 2) NOT NULL,
    subtotal NUMERIC(10, 2) NOT NULL
);

-- 7. DATOS INICIALES
INSERT INTO categorias (nombre, icono) VALUES 
('Víveres y Abarrotes', '🛒'),
('Charcutería y Lácteos', '🧀'),
('Bebidas y Refrescos', '🥤'),
('Snacks y Golosinas', '🍿'),
('Limpieza del Hogar', '🧹');

INSERT INTO metodos_pago (codigo, nombre, datos_instruccion, requiere_comprobante) VALUES 
('PAGO_MOVIL', 'Pago Móvil', 'Banco: Provincial | CI: 12345678 | Tlf: 04120000000', true),
('BINANCE_PAY', 'Binance Pay (USDT)', 'Pay ID: 123456789', true),
('EFECTIVO', 'Efectivo en Entrega', 'Indica en las notas con cuánto vas a pagar para llevar vuelto.', false);
