<html xmlns="http://www.w3.org/1999/xhtml">
  >
    <title>OAuth</title>
  </head>
  <body>
  	<h1>OAuth 1</h1>
  	<p>Vamos a usar la API de twitter con autentificación oauth1</p>
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
                           client_secret=CONSUMER_SECRET)
            r = requests.post(url=REQUEST_TOKEN_URL, auth=oauth)
            credentials = parse_qs(r.content)
            TOKENS["request_token"] = credentials.get('oauth_token')[0]
            TOKENS["request_token_secret"] = credentials.get('oauth_token_secret')[0]
    
 
            @get('/')
            def index():
               return template('index.tpl')           

            @get('/twitter')
            def twitter():
                get_request_token()
                authorize_url = AUTHENTICATE_URL + TOKENS["request_token"]
                return template('oauth1.tpl', authorize_url=authorize_url)
  		</pre>

  		<li>Una vez que nos hemos autentificado de forma adecuda la aplicación (en este caso twitter) nos devuelve a la Callback URL (http://oauth-iesgn.rhcloud.com/callback) 
  	</ul>
    <a href="{{authorize_url}}">Comenzar a twitterar</a>
  </body>
</html>
