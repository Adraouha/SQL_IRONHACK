# Semana 15 - Actividad 5: Clientes HTTP, APIs REST, Postman & Thunder Client

---

## 🛠️ Entorno y Configuración en Visual Studio Code

Para trabajar con Java y probar APIs REST sin salir del editor se recomiendan las siguientes extensiones:

1. **Extension Pack for Java (Microsoft)**: Incluye soporte de lenguaje, depuración, ejecución y gestión de dependencias Maven.
2. **Thunder Client**: Cliente HTTP ligero y visual integrado en VSCode (alternativa nativa y ágil a Postman que no requiere registro obligatorio en la nube).
3. **Postman**: La herramienta estándar en la industria para diseño, prueba, documentación y automatización de peticiones HTTP/REST.

---

## 📚 LAB 1: Respuestas Teóricas y Fundamentos de Protocolo HTTP

### 1. ¿Cuáles son las diferencias entre PUT y PATCH?

| Característica | **PUT** | **PATCH** |
| :--- | :--- | :--- |
| **Propósito** | Reemplazo **completo** del recurso. | Modificación **parcial** del recurso. |
| **Idempotencia** | **Sí es idempotente**: Ejecutar la misma petición PUT 1 o 100 veces produce exactamente el mismo estado final en el servidor. | **No siempre garantizado como idempotente**: Depende de la lógica del servidor (ej: operaciones de incremento o apilado). |
| **Carga útil (Payload)**| Se deben enviar **todos los campos** del objeto. Si omites un campo que antes existía, el servidor lo sustituirá por `null` o por su valor por defecto. | Solo se envían los campos que se desean **modificar**. Los campos omitidos se conservan intactos. |

#### Ejemplo práctico:
Si un usuario tiene `{ "id": 1, "nombre": "Juan", "email": "juan@mail.com", "rol": "admin" }`:
- **Con PUT** para cambiar el email, debes enviar:
  ```json
  PUT /api/usuarios/1
  { "nombre": "Juan", "email": "juan_nuevo@mail.com", "rol": "admin" }
  ```
- **Con PATCH**, solo envías el cambio:
  ```json
  PATCH /api/usuarios/1
  { "email": "juan_nuevo@mail.com" }
  ```

---

### 2. ¿Cómo borras una entrada de la base de datos?

Existen dos niveles según el contexto:

1. **A nivel de Base de Datos (SQL)**:
   Se utiliza la sentencia `DELETE FROM` con una cláusula `WHERE` para especificar el registro concreto (filtrando preferentemente por su clave primaria `id` para evitar borrar toda la tabla):
   ```sql
   DELETE FROM libros WHERE id = 5;
   ```
2. **A nivel de API REST (Cliente HTTP - Postman / Thunder Client)**:
   Se realiza una petición con el verbo **`DELETE`** indicando el identificador del recurso en la ruta URL (URI):
   ```http
   DELETE https://api.midominio.com/libros/5
   ```
   El backend recibe esta petición HTTP y ejecuta internamente el `DELETE` en la base de datos, respondiendo habitualmente con un código de estado `200 OK` o `204 No Content`.

---

### 3. ¿Para qué sirve la cabecera de la petición (Headers / Head)?

Las cabeceras (`Headers`) son los **metadatos** que acompañan a la petición y a la respuesta HTTP. Permiten al cliente y al servidor negociar y comunicarse información contextual crucial sin alterar el cuerpo principal del mensaje:

- **Tipo de Contenido (`Content-Type`)**: Indica qué formato viaja en el cuerpo (ej: `application/json`, `text/html`, `multipart/form-data`).
- **Autenticación y Autorización (`Authorization`)**: Envía credenciales o tokens de seguridad para acceder a rutas protegidas (ej: `Bearer eyJhbGciOi...` o API Keys).
- **Formato Aceptado (`Accept`)**: Indica qué formatos es capaz de interpretar el cliente (ej: `Accept: application/json`).
- **Control de Caché (`Cache-Control`)**: Define si la respuesta debe guardarse localmente y por cuánto tiempo.
- **Identificación de Cliente (`User-Agent`)**: Especifica el navegador, sistema operativo o cliente (Postman, curl) que origina la llamada.
- **Gestión de Sesiones (`Cookie` / `Set-Cookie`)**: Envío y recepción de identificadores de sesión.

> **Nota sobre el método HTTP HEAD**: Existe un método HTTP llamado `HEAD` que solicita exactamente la misma respuesta que un `GET`, pero **sin devolver el cuerpo (body)**. Se utiliza para verificar si un recurso existe o medir su tamaño (`Content-Length`) sin gastar ancho de banda.

---

### 4. ¿Por dónde se envían los datos de un formulario HTML con el método GET? ¿Y con POST? ¿Cuál es más seguro?

#### Envíos con GET:
- Los datos del formulario se codifican en la propia **URL** en forma de parámetros de consulta (*Query Parameters*):
  ```
  https://misitio.com/buscar?categoria=libros&orden=precio_asc
  ```
- **Limitaciones**:
  - Los datos quedan registrados en el historial del navegador, en los marcadores, en los servidores proxy y en los archivos de log de los servidores web.
  - La longitud máxima está restringida (habitualmente alrededor de 2048 caracteres).
  - Solo admite texto plano ASCII.

#### Envíos con POST:
- Los datos viajan encapsulados en el **cuerpo del mensaje HTTP (Request Body)**:
  ```http
  POST /registro HTTP/1.1
  Host: misitio.com
  Content-Type: application/x-www-form-urlencoded

  usuario=carlos&clave=secreto123&email=carlos@mail.com
  ```
- No se muestran en la barra de direcciones ni se almacenan en el historial del navegador.
- Admite grandes volúmenes de datos y archivos binarios (imágenes, PDFs, etc.).

#### ¿Cuál es más seguro?
- **POST es mucho más seguro para datos sensibles** (contraseñas, números de tarjeta, información personal) porque nunca quedan expuestos en la URL, en la pantalla ante mirones (*shoulder surfing*), ni en los registros del servidor.
- **Aviso fundamental de seguridad**: Ninguno de los dos métodos es seguro por sí mismo si viaja por `HTTP` sin cifrar (ya que un atacante puede interceptar los paquetes en la red). La verdadera seguridad en tránsito se garantiza usando **`HTTPS` (TLS/SSL)**, donde tanto la URL como el cuerpo de la petición viajan encriptados de extremo a extremo.

---

## 🌐 LAB 2: Pruebas con APIs Públicas en Thunder Client / Postman

A continuación se detallan los endpoints listos para probar en Thunder Client, Postman o mediante comandos `curl`:

### 1. JSONPlaceholder (API REST Fake para pruebas CRUD)
- **GET - Listar publicaciones**:
  - `GET https://jsonplaceholder.typicode.com/posts`
- **GET - Obtener una publicación específica**:
  - `GET https://jsonplaceholder.typicode.com/posts/1`
- **POST - Crear una publicación**:
  - `POST https://jsonplaceholder.typicode.com/posts`
  - Body (JSON):
    ```json
    {
      "title": "Mi primer post desde Thunder Client",
      "body": "Aprendiendo clientes HTTP y bases de datos con Ironhack",
      "userId": 1
    }
    ```
- **PUT - Reemplazar la publicación**:
  - `PUT https://jsonplaceholder.typicode.com/posts/1`
  - Body (JSON):
    ```json
    {
      "id": 1,
      "title": "Título completamente nuevo",
      "body": "Cuerpo completamente actualizado",
      "userId": 1
    }
    ```
- **DELETE - Eliminar la publicación**:
  - `DELETE https://jsonplaceholder.typicode.com/posts/1`

### 2. Rick and Morty API (Información y personajes)
- **GET - Listar personajes**:
  - `GET https://rickandmortyapi.com/api/character`
- **GET - Filtrar por nombre y estado**:
  - `GET https://rickandmortyapi.com/api/character/?name=rick&status=alive`

### 3. PokéAPI (Pokémon y habilidades)
- **GET - Obtener datos de Pikachu**:
  - `GET https://pokeapi.co/api/v2/pokemon/pikachu`

### 4. ReqRes (Pruebas de usuarios y autenticación)
- **GET - Listado de usuarios paginado**:
  - `GET https://reqres.in/api/users?page=2`
- **POST - Crear nuevo usuario**:
  - `POST https://reqres.in/api/users`
  - Body (JSON):
    ```json
    {
      "name": "Hassan",
      "job": "Full Stack Developer"
    }
    ```

### 5. Coinbase API (Criptomonedas en tiempo real)
- **GET - Precio de Bitcoin en EUR**:
  - `GET https://api.coinbase.com/v2/prices/BTC-EUR/spot`
