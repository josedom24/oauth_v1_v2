<html xmlns="http://www.w3.org/1999/xhtml">
    <title>OAuth</title>
  </head>
  <body>
  	<h1>OAuth 1</h1>
  	<p>Vamos a usar la API de twitter con autentificación oauth1</p>
    <a href="http://laxmarcaellugar.blogspot.com.es/2011/08/el-protocolo-de-autenticacion-oauth_08.html">Flujo oauth1</a>
  	<ul>
  		<li>Para comenzar, vamos a a acceder a la url de autentificación de twitter (AUTHENTICATE_URL)(https://api.twitter.com/oauth/authenticate?oauth_token=) y utilizamos el token de petición (request token)</li>
  		<li>Función get_request_token(): Para obtener el token de petición hacemos una petición POST a la url de solicitud de token de petición (REQUEST_TOKEN_URL)(https://api.twitter.com/oauth/request_token) de forma autentificada usando nuestras credenciales (CONSUMER_KEY,CONSUMER_SECRET)</li>
  		<pre>
          import requests
          from requests_oauthlib import OAuth1
          from urlparse import parse_qs

          REQUEST_TOKEN_URL = "https://api.twitter.com/oauth/request_token"
          AUTHENTICATE_URL = "https://api.twitter.com/oauth/authenticate?oauth_token="
          ACCESS_TOKEN_URL = "https://api.twitter.com/oauth/access_token"
 
          CONSUMER_KEY = "..."
          CONSUMER_SECRET = "..."

          TOKENS = {}

          def get_request_token():
            oauth = OAuth1(CONSUMER_KEY,
                           client_secret=CONSUMER_SECRET,
            )
            r = requests.post(url=REQUEST_TOKEN_URL, auth=oauth)
            credentials = parse_qs(r.content)
            TOKENS["request_token"] = credentials.get('oauth_token')[0]
            TOKENS["request_token_secret"] = credentials.get('oauth_token_secret')[0]
            
         def get_access_token(TOKENS):
          
          oauth = OAuth1(CONSUMER_KEY,
                           client_secret=CONSUMER_SECRET,
                           resource_owner_key=TOKENS["request_token"],
                           resource_owner_secret=TOKENS["request_token_secret"],
                           verifier=TOKENS["verifier"],)
          
          
          r = requests.post(url=ACCESS_TOKEN_URL, auth=oauth)
          credentials = parse_qs(r.content)
          TOKENS["access_token"] = credentials.get('oauth_token')[0]
          TOKENS["access_token_secret"] = credentials.get('oauth_token_secret')[0]        

        
        @get('/twitter')
        def twitter():
            get_request_token()
            authorize_url = AUTHENTICATE_URL + TOKENS["request_token"]
            response.set_cookie("request_token", TOKENS["request_token"],secret='some-secret-key')
            response.set_cookie("request_token_secret", TOKENS["request_token_secret"],secret='some-secret-key')
            return template('oauth1.tpl', authorize_url=authorize_url)
          		</pre>

  		<li>Una vez que nos hemos autentificado de forma adecuada la aplicación (en este caso twitter) nos devuelve a la Callback URL (http://oauth-iesgn.rhcloud.com/callback) donde cogemos un token de verificación que nos permitirá a continuación obtener los tokens de acceso (ACCESS_TOKEN,ACCESS_TOKEN_SECRET)</li>
      <pre>
       def get_access_token(TOKENS):
 
           oauth = OAuth1(CONSUMER_KEY,
                  client_secret=CONSUMER_SECRET,
                  resource_owner_key=TOKENS["request_token"],
                  resource_owner_secret=TOKENS["request_token_secret"],
                  verifier=TOKENS["verifier"],)
 
 
           r = requests.post(url=ACCESS_TOKEN_URL, auth=oauth)
           credentials = parse_qs(r.content)
           TOKENS["access_token"] = credentials.get('oauth_token')[0]
           TOKENS["access_token_secret"] = credentials.get('oauth_token_secret')[0]

       @get('/callback')     
       def get_verifier():
           TOKENS["request_token"]=request.get_cookie("request_token", secret='some-secret-key')
           TOKENS["request_token_secret"]=request.get_cookie("request_token_secret", secret='some-secret-key')
           TOKENS["verifier"] = request.query.oauth_verifier
           get_access_token(TOKENS)
           response.set_cookie("access_token", TOKENS["access_token"],secret='some-secret-key')
           response.set_cookie("access_token_secret", TOKENS["access_token_secret"],secret='some-secret-key')
           redirect('/twittear')
</pre>
    <li>Si tenemos guardado los tokens de acceso, significa que podemos utilizar nuestra aplicación y no hace falta autentificarnos></li>
      <pre>
      @get('/twittear')
      def twittear():
          if request.get_cookie("access_token", secret='some-secret-key'):
            TOKENS["access_token"]=request.get_cookie("access_token", secret='some-secret-key')
            TOKENS["access_token_secret"]=request.get_cookie("access_token_secret", secret='some-secret-key')
            return template('tweet')  
          else:
            redirect('/twitter')
      </pre>
    <li>Para escribir un tweet utilizamos la URL correspondiente, autentificarnos con nuestros tokens de acceso.</li>
    <pre>
      @post('/twittear')
      def tweet_submit():
        TOKENS["access_token"]=request.get_cookie("access_token", secret='some-secret-key')
        TOKENS["access_token_secret"]=request.get_cookie("access_token_secret", secret='some-secret-key')
        texto = request.forms.get("tweet")
        oauth = OAuth1(CONSUMER_KEY,
                         client_secret=CONSUMER_SECRET,
                         resource_owner_key=TOKENS["access_token"],
                         resource_owner_secret=TOKENS["access_token_secret"])
        url = 'https://api.twitter.com/1.1/statuses/update.json'
        r = requests.post(url=url,
                            data={"status":texto},
                            auth=oauth)
        if r.status_code == 200:
          return "<p>Tweet properly sent</p>"
        else:
          return "<p>Unable to send tweet</p>"
    </pre>
    <li>Para desconectar, lo único que hacemos es olvidar los tokens de acceso, borramos las cookies.</li>
    <pre>
      def twitter_logout():
        response.set_cookie("access_token", '',max_age=0)
        response.set_cookie("access_token_secret", '',max_age=0)
        redirect('/twitter')
    </pre>
  	</ul>
    <a href="{{authorize_url}}">Comenzar a twitterar</a>
  </body>
</html>
