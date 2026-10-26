# MensajesTwitter

**Display** is a "Twitter messages screen" built with Adobe AIR 3.4 / Flash ActionScript 3: a full-screen viewer that receives short text messages (tweets) over a TCP socket and shows them as floating fading text fields on a big screen — suitable for events/installations where a table/wall displays a live feed. The tweet-reading client component is external to this folder (see *Connecting the sender* below); this repository only contains the display side (`Display/Display.as` + `Display.fla` + compiled `Display.swf`).

> **This project is shared ONLY for educational purposes. Its use, direct or derived, for professional or economic purposes is not permitted.**

Note: for security reasons, some parts of the project may have been edited or removed (e.g. personal paths or local build artifacts replaced or excluded).

## Connecting the sender (protocol)

A sender app (for example, a Twitter reader) connects to the display over **TCP port 1234** (one connection at a time; on disconnect the server listens again). Protocol details, as implemented in `Display.as`:

1. **Handshake**: within 5 seconds of connecting, send `H` + payload `1234` + carriage return (`\r`). Anything else → the connection is closed. On success the display answers `Aceptada` + `\r`.
2. **Messages**: each command is 1 ASCII command letter + payload text, terminated by `\r` (carriage return):
   - `M<text>` — launch a message on screen (random position, fade-in via TweenNano/GreenSock)
   - `N<max>` — set the maximum number of simultaneous messages (oldest fades out when exceeded)
   - `D` — delete the oldest message
   - `C` — clear all messages
   - (any keyboard press on the display also clears everything)

**Suggestion**: [tweepy/tweepy](https://github.com/tweepy/tweepy) (Python, MIT) is a suggested, externally-maintained project that could be adapted as the sender: it reads tweets from X/Twitter API v2 (`StreamingClient.on_tweet()`, or v1.1 `API.home_timeline()`); a minimal adaptation would just open a socket to `Display` (port 1234), send the `H1234\r` handshake and forward every tweet as `M<tweet text>\r`.

**Requirements / How to run**

- Runtime: Adobe AIR 3.4+ (`Display-app.xml` descriptor; package the SWF with `adt -package`).
- Source editing: Adobe Flash Professional (open `Display/Display.fla`; doc-class `Display.as`) with GreenSock TweenNano (`greensock.swc`).
- Sender: any TCP client able to speak the protocol above (e.g. the suggested Tweepy-based Twitter reader).

DISCLAIMER: This software is provided "as is", without any warranty of any kind. The author accepts no liability for any errors or damages resulting from its use.

**AI training**: the use of the content of this repository (code, assets, documentation) to train or fine-tune machine learning models or AI systems is expressly **not permitted**. All of the repository is licensed under CC-BY-NC-4.0 (see the `LICENSE` file).

---

# MensajesTwitter

**Display** es una "pantalla de mensajes de Twitter" hecha con Adobe AIR 3.4 / Flash ActionScript 3: un visor a pantalla completa que recibe mensajes de texto cortos (tweets) por socket TCP y los muestra como campos de texto flotantes con fundido en una pantalla grande — apto para eventos/instalaciones donde se proyecte un feed en vivo. El componente lector de tweets (emisor) es externo a esta carpeta (ver *Conexión con el emisor*); este repositorio contiene solo el lado del display (`Display/Display.as` + `Display.fla` + el `Display.swf` compilado).

> **Este proyecto se comparte SOLO con valor educativo. No está permitido su uso (directo o derivado) para fines profesionales o económicos.**

Nota: por motivos de seguridad, es posible que algunas partes del proyecto se encuentren editadas o eliminadas (p. ej. rutas personales o artefactos locales han sido sustituidos o excluidos).

## Conexión con el emisor (protocolo)

Una app emisora (por ejemplo, un lector de tweets) se conecta al display por **TCP puerto 1234** (una conexión a la vez; al desconectar, el servidor vuelve a escuchar). El protocolo, tal como está implementado en `Display.as`:

1. **Handshake**: en los primeros 5 segundos tras conectar, enviar `H` + payload `1234` + retorno de carro (`\r`). Cualquier otra cosa → se cierra la conexión. En caso correcto el display responde `Aceptada` + `\r`.
2. **Mensajes**: cada orden es 1 letra ASCII de comando + texto, terminada en `\r` (retorno de carro):
   - `M<texto>` — lanzar un mensaje en pantalla (posición aleatoria, fundido de entrada con TweenNano/GreenSock)
   - `N<max>` — fijar el máximo de mensajes simultáneos (el más antiguo se funde fuera al excederse)
   - `D` — eliminar el mensaje más antiguo
   - `C` — limpiar todos
   - (cualquier tecla sobre el display también limpia todo)

**Sugerencia**: [tweepy/tweepy](https://github.com/tweepy/tweepy) (Python, MIT) es un proyecto externo sugerido que podría adaptarse como emisor: lee tweets de la API v2 de X/Twitter (`StreamingClient.on_tweet()`, o `API.home_timeline()` de la v1.1); una adaptación mínima solo tendría que abrir un socket hacia `Display` (puerto 1234), enviar el handshake `H1234\r` y reenviar cada tweet como `M<texto>\r`.

**Requisitos / Cómo ejecutar**

- Runtime: Adobe AIR 3.4+ (descriptor `Display-app.xml`; empaqueta el SWF con `adt -package`).
- Edición del código: Adobe Flash Professional (abre `Display/Display.fla`; doc-class `Display.as`) con TweenNano de GreenSock (`greensock.swc`).
- Emisor: cualquier cliente TCP que hable el protocolo anterior (p. ej. un lector de Twitter basado en Tweepy, el proyecto sugerido).

AVISO: Este software se ofrece "tal cual", sin ningún tipo de garantía. El autor no asume responsabilidad alguna por posibles errores o daños derivados de su uso.

**Entrenamiento de IA**: no se permite expresamente el uso del contenido de este repositorio (código, recursos, documentación) para entrenar o ajustar (*fine-tune*) modelos de aprendizaje automático o sistemas de IA. Todo el repositorio se publica con licencia CC-BY-NC-4.0 (ver el archivo `LICENSE`).
