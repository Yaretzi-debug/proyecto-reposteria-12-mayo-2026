actua como un administrador de base de datos: proyecto reposteria, que entidades se necesitan para su gestion
## Entidades para un Sistema de Gestión de Repostería

Aquí te presento las entidades principales organizadas por módulo:

---
<img width="810" height="627" alt="image" src="https://github.com/user-attachments/assets/e6fa71ce-227a-4914-802e-f1cfb2f76348" />


### 🧾 Núcleo del Negocio

**1. Producto**
Pasteles, galletas, cupcakes, etc.
- id, nombre, descripción, precio_venta, categoria_id, imagen, activo

**2. Categoría**
Clasificación de productos (tortas, postres fríos, panes, etc.)
- id, nombre, descripción

**3. Receta**
Vincula un producto con sus ingredientes y pasos
- id, producto_id, nombre, porciones, tiempo_preparacion, instrucciones

**4. Receta_Ingrediente** *(tabla pivote)*
- receta_id, ingrediente_id, cantidad, unidad_medida

---

### 🥚 Inventario

**5. Ingrediente**
Harina, azúcar, huevos, mantequilla, etc.
- id, nombre, stock_actual, stock_minimo, unidad_medida, costo_unitario, proveedor_id

**6. Proveedor**
- id, nombre, contacto, telefono, email, dirección

**7. Movimiento_Inventario**
Entradas y salidas de ingredientes
- id, ingrediente_id, tipo (entrada/salida), cantidad, fecha, referencia, usuario_id

---

### 👥 Clientes y Ventas

**8. Cliente**
- id, nombre, telefono, email, dirección, fecha_registro, notas

**9. Pedido**
- id, cliente_id, fecha_pedido, fecha_entrega, estado, total, notas, usuario_id

**10. Pedido_Detalle**
- id, pedido_id, producto_id, cantidad, precio_unitario, personalizacion

---

### 💰 Finanzas

**11. Gasto**
Gastos operativos (luz, renta, empaques, etc.)
- id, concepto, monto, categoria_gasto, fecha, comprobante

**12. Pago**
Registro de pagos de pedidos
- id, pedido_id, monto, metodo_pago, fecha, referencia

---

### 👩‍💼 Administración

**13. Usuario**
Personal del negocio
- id, nombre, email, contraseña_hash, rol (admin/vendedor/produccion), activo

**14. Rol / Permiso** *(si se necesita granularidad)*

---

### 🔗 Diagrama de relaciones clave

```
Proveedor ──< Ingrediente >──< Receta_Ingrediente >── Receta ──── Producto
                                                                      │
Cliente ──< Pedido >──< Pedido_Detalle >──────────────────────────────┘
              │
           Pago
```

---

las entidades con sus atributos y tipo en forma de tabla para cada una de las entidades
<img width="828" height="553" alt="image" src="https://github.com/user-attachments/assets/768c13df-f553-4f58-8614-cecc63c5fe0a" />
<img width="836" height="540" alt="image" src="https://github.com/user-attachments/assets/93d54e1d-ce70-432b-931c-0f7f47d062d3" />
<img width="824" height="626" alt="image" src="https://github.com/user-attachments/assets/4af505b2-a2fd-43bd-a6a5-1cb176d11a5e" />
<img width="742" height="611" alt="image" src="https://github.com/user-attachments/assets/96aa80cc-8ff6-4d2d-9ff8-117a49f5d614" />
<img width="747" height="341" alt="image" src="https://github.com/user-attachments/assets/3b4931e2-f048-4a5a-8820-0de23c061382" />
<img width="741" height="543" alt="image" src="https://github.com/user-attachments/assets/1cfec709-1c6f-445c-8d02-758cb78ecb95" />
<img width="739" height="539" alt="image" src="https://github.com/user-attachments/assets/bc6f268e-9c37-479b-ba00-484ea268d03c" />
Ahí están las 13 entidades con todos sus atributos, tipos de dato y descripción, agrupadas por módulo con código de color:

- **Catálogo** — Categoría, Producto, Receta, Receta_Ingrediente
- **Inventario** — Proveedor, Ingrediente, Movimiento_Inventario
- **Ventas** — Cliente, Pedido, Pedido_Detalle
- **Finanzas** — Pago, Gasto
- **Administración** — Usuario









