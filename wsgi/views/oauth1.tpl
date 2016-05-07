<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>OAuth</title>
  </head>
  <body>
  	<h1>OAuth 1</h1>
  	<p>Vamos a usar la API de twitter con autentificación oauth1</p>
  	<ul>
  		<li>Para comenzar, vamos a a acceder a la url de autentificación de twitter (AUTHENTICATE_URL)(https://api.twitter.com/oauth/authenticate?oauth_token=) y utilizamos el token de petición (request token)</li>
  		<li>Función get_request_token(): Para obtener el token de petición hacemos una petición POST a la url de solicitud de token de petición (REQUEST_TOKEN_URL)(https://api.twitter.com/oauth/request_token) de forma autentificada usando nuestras credenciales (CONSUMER_KEY,CONSUMER_SECRET)</li>
  		<code>
  				
  		</code>

  		<li>Una vez que nos hemos autentificado de forma adecuda la aplicación (en este caso twitter) nos devuelve a la Callback URL (http://oauth-iesgn.rhcloud.com/callback)
  	</ul>
    <a href="{{authorize_url}}">Comenzar a twitterar</a>
  </body>
</html>
