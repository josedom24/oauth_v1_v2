<html xmlns="http://www.w3.org/1999/xhtml">
    <title>OAuth</title>
  </head>
  <body>
  	<h1>OAuth 2</h1>
    <a href="http://www.ladrupalera.com/drupal/desarrollo/javascript/como-usar-una-api-de-google-con-autenticacion-traves-de-oauth2">Cómo usar una API de Google con autenticación a través de OAuth2 </a>
  	<p>Vamos a usar la API de google con autentificación oauth2</p>
    <ol>  	
      <li>Tenemos que crar un proyecto en la consola de desarrollo de Google. De ese proyecto obtenermos client_id,client_secret y el redirect URI.</li>
      <pre>
      client_id='1002052005922-rr7bc2g3n2721gnb0a61242gog3mt84v.apps.googleusercontent.com'
      client_secret='EzJ0lyZxhD_tkIAG5Y5PKbxO'
      redirect_uri = 'https://oauth-iesgn.rhcloud.com/oauth2callback'
      </pre>
      <li>A continuación tenemos que crear una URL de autorización, a partir de la url base (token_url) y la credenciales anteriormente obtenidas. Además tendremos que indicar las APIS (servicios habilitados) que vamos a usar (scopes).</li>
    <a href="/youtube">Login a Google para ver el perfil de YouTube</a>
  </body>
</html>