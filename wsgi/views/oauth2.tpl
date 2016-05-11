<html xmlns="http://www.w3.org/1999/xhtml">
    <title>OAuth</title>
  </head>
  <body>
  	<h1>OAuth 2</h1>
    <a href="http://www.ladrupalera.com/drupal/desarrollo/javascript/como-usar-una-api-de-google-con-autenticacion-traves-de-oauth2">Cómo usar una API de Google con autenticación a través de OAuth2 </a>
  	<p>Vamos a usar la API de google con autentificación oauth2</p>
    <ol>  	
      <li>Tenemos que crear un proyecto en la consola de desarrollo de Google. De ese proyecto obtenemos client_id,client_secret y el redirect URI.</li>
      <pre>
      client_id='1002052005922-rr7bc2g3n2721gnb0a61242gog3mt84v.apps.googleusercontent.com'
      client_secret='EzJ0lyZxhD_tkIAG5Y5PKbxO'
      redirect_uri = 'https://oauth-iesgn.rhcloud.com/oauth2callback'
      </pre>
      <li>A continuación tenemos que crear una URL de autorización, a partir de la url base (token_url) y la credenciales anteriormente obtenidas. Además tendremos que indicar las APIS (servicios habilitados) que vamos a usar (scopes).
      Si ya tenemos el token y es válido, no hace falta hacer la operación anterior y saltaríamos a la url donde obtenemos la información.</li>
      <pre>
        scope = ['https://www.googleapis.com/auth/youtube','https://www.googleapis.com/auth/userinfo.profile']
        token_url = "https://accounts.google.com/o/oauth2/token"        
        
        @get('/youtube')
        def info_youtube():
          if token_valido():
            redirect("/perfil")
          else:
            response.set_cookie("token", '',max_age=0)
            oauth2 = OAuth2Session(client_id, redirect_uri=redirect_uri,scope=scope)
            authorization_url, state = oauth2.authorization_url('https://accounts.google.com/o/oauth2/auth')
            response.set_cookie("oauth_state", state)
            redirect(authorization_url)
      </pre>
      <li>Una vez que hemos autorizado a que la aplicación haga uso de los datos de google con un determinado usuario, google llama la callback URL, donde utilizando la información enviada en esta llamada podemos obtener nuestro token de acceso.</li>
      <pre>
      @get('/oauth2callback')
      def get_token():      

        oauth2 = OAuth2Session(client_id, state=request.cookies.oauth_state,redirect_uri=redirect_uri)
        token = oauth2.fetch_token(token_url, client_secret=client_secret,authorization_response=request.url)
        response.set_cookie("token", token,secret='some-secret-key')
        redirect("/perfil")
      </pre>
      <li>Finalmente puedo usar la API utilizando el token que hemos obtenido anteriormente.</li>
      <pre>
      @get('/perfil')
      def info():
        if token_valido():
          token=request.get_cookie("token", secret='some-secret-key')
          oauth2 = OAuth2Session(client_id, token=token)
          r = oauth2.get('https://www.googleapis.com/oauth2/v1/userinfo')
          doc=json.loads(r.content)
          return '<p>%s</p><img src="%s"/><br/><a href="/logout">Cerrar</a>' % (doc["name"],doc["picture"])
        else:
          redirect('/youtube')
      </pre>

          <a href="/youtube">Login a Google para ver el perfil de YouTube</a>
  </body>
</html>