# 🧠 Actividad Sumativa 3 - Semana 8 - Modelamiento de Bases de Datos


👤 Autor del proyecto

Nombre completo: Daniel Francisco Caballero Salas

Sección: Programación Orientada a Objetos II

Carrera: Analista Programador Computacional

Sede: Campus Virtual


📘 Descripción general del sistema

Este proyecto implementa un modelo relacional para la gestión de clientes, automóviles y mantenciones en un taller mecánico.

El sistema considera las siguientes entidades principales:

- CLIENTE: almacena información personal y de contacto.

- MARCA y MODELO: definen la clasificación de los automóviles.

- AUTOMOVIL: registra los vehículos asociados a cada cliente.

- MANTENCION: controla las mantenciones realizadas en sucursales, con mecánicos asignados y estados definidos.

Consideraciones:

- Se utilizó de referencia las instrucciones indicadas y solicitadas en el enunciado.

- Las claves primarias y foráneas aseguran la integridad referencial.

- Se utilizan CHECK constraints para validar atributos como tipo_cl y estado.

- Los datos de prueba incluyen clientes con distintos RUT, automóviles variados y mantenciones en diferentes sucursales.


📂 Tablas principales (fuertes a débiles)

PAIS  (id_pais, nombre) → tabla raíz, no depende de nadie.

CIUDAD  (id_ciudad, nombre, region, id_pais) → depende de PAIS.

SUCURSAL  (cod_sucursal, nombre, direccion, telefono, id_ciudad) → depende de CIUDAD.

MARCA  (id_marca, descripcion) → independiente.

TIPO_AUTOMOVIL  (id_tipo, descripcion) → independiente.

MODELO  (id_modelo, marca_id, descripcion) → depende de MARCA.

CLIENTE  (rut, dv, pnombre, snombre, apat, amat, telefono, email, tipo_cl) → independiente.

MECANICO  (cod_mecanico, nombre, especialidad, sucursal_id) → depende de SUCURSAL.

SERVICIO  (cod_servicio, descripcion, valor) → independiente.

AUTOMOVIL  (patente, anio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut) → depende de CLIENTE, MODELO, MARCA y TIPO_AUTOMOVIL.

MANTENCION  (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado) → depende de AUTOMOVIL, SUCURSAL y MECANICO.

DETALLE_SERVICIO  (num_mantencion, cod_servicio, cantidad, subtotal) → depende de MANTENCION y SERVICIO.

ESTANDAR  (id_estandar, descripcion, condiciones) → tabla secundaria de servicios, puede depender de SERVICIO.

PREMIUM  (id_premium, descripcion, beneficios) → tabla secundaria de servicios, puede depender de SERVICIO.


⚙️ Instrucciones para clonar y ejecutar el proyecto
Clonar el repositorio desde GitHub:

Opcion 1:
 git clone https://github.com/DCaballero1164/Modelamiento_base_datos_S8.git

 Ejecutar Script PRY2204_SEMANA8.sql

Visualizar los resultados.

📌 Repositorio GitHub: https://github.com/DCaballero1164/Modelamiento_base_datos_S8.git 📅 Fecha de entrega: [01/03/2026]