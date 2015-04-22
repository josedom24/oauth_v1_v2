# -*- encoding: utf-8 -*-
from bottle import default_app, get, post, template, request, static_file, response
import requests
from requests_oauthlib import OAuth1
from requests_oauthlib import OAuth2Session
from urlparse import parse_qs


REQUEST_TOKEN_URL = "https://api.twitter.com/oauth/request_token"
AUTHENTICATE_URL = "https://api.twitter.com/oauth/authenticate?oauth_token="
ACCESS_TOKEN_URL = "https://api.twitter.com/oauth/access_token"
 
CONSUMER_KEY = "MYQ9JgvCMJdjcqtX4dRnk1G4S"
CONSUMER_SECRET = "JeAiQ9IyFJdp3LWrBTl3EBbaqQgSuk0D1aP63JqGcq8lQxRa0c"

TOKENS = {}


###oauth2

client_id='709108337086-e8enc93g0s39o2elbjnfpt13c3ia343q.apps.googleusercontent.com'
client_secret = 'UsHozbjZlmUZGQwhIpatPlU2'
redirect_uri = 'https://oauth-iesgn.rhcloud.com/google'
scope = ['https://www.googleapis.com/auth/youtube']
oauth2 =OAuth2Session(1)

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

@get('/')
def index():
    get_request_token()
    authorize_url = AUTHENTICATE_URL + TOKENS["request_token"]
    return template('index.tpl', authorize_url=authorize_url)

@get('/callback')
@get('/twittear')
def get_verifier():
	TOKENS["verifier"] = request.query.oauth_verifier
	get_access_token(TOKENS)
	return template('tweet')

@post('/twittear')
def tweet_submit():
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

###oauth2

@get('/youtube')
def info_youtube():
  oauth2 = OAuth2Session(client_id, redirect_uri=redirect_uri,scope=scope)
  authorization_url, state = oauth2.authorization_url('https://accounts.google.com/o/oauth2/auth',
        access_type="offline", approval_prompt="force")
  return "<a href='%s'>Perfil de youtube</a>" % authorization_url

@get('/google')
def info_perfil():
  token = oauth2.fetch_token('https://accounts.google.com/o/oauth2/token',
        authorization_response=request.url,
        client_secret=client_secret)
  r = oauth.get('https://www.googleapis.com/oauth2/v1/userinfo')
  return '<p>%s</p>' % r.text


# This must be added in order to do correct path lookups for the views
import os
from bottle import TEMPLATE_PATH
TEMPLATE_PATH.append(os.path.join(os.environ['OPENSHIFT_REPO_DIR'], 'wsgi/views/')) 

application=default_app()
