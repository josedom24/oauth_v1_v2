<html xmlns="http://www.w3.org/1999/xhtml">
    <title>OAuth</title>
  </head>
  <body>
  	<h1>OAuth 2</h1>
    <a href="http://www.ladrupalera.com/drupal/desarrollo/javascript/como-usar-una-api-de-google-con-autenticacion-traves-de-oauth2">Cómo usar una API de Google con autenticación a través de OAuth2 </a>
  	<p>Vamos a usar la API de google con autentificación oauth2</p>
    <ol>  	
      <li>El usuario hará clic en el botón de login para identificarse en nuestra aplicación web con una cuenta de google.</li>
      <li>Nuestra aplicación web solicitara a la api de google, permiso para acceder a los datos del usuario.</li>
      <li>La api de google le pedirá al usuario permiso para que nuestra web acceda a sus datos.</li>
      <li>Cuandodo el usuario acepte, la api de google retornara a nuestra web un código con el que solicitar un token valido.</li>
      <li>Con este código, nuestra aplicación web solicitara un token valido para poder acceder a los datos del usuario.</li>
      <li>La api de google retornara un token valido con el que poder hacer consultas.</li>
      <li>Nuestra aplicación web solicitara los datos del usuario pasando el token devuelto antes.</li>
      <li>La api de google retornara los datos del usuario.</li>
      <li>Y con esto habrá acabado el proceso. En la imagen lateral se puede ver un gráfico del proceso para mejor comprensión.</li>
    </ol>
    <a href="/youtube">Login a Google para ver el perfil de YouTube</a>
  </body>
</html>