# -*- encoding: utf-8 -*-
from bottle import default_app, get, post, template, request, static_file, response,redirect,run
import requests
from requests_oauthlib import OAuth1
from requests_oauthlib import OAuth2Session
from oauthlib.oauth2 import TokenExpiredError
from urlparse import parse_qs
import json
import os
from sys import argv

REQUEST_TOKEN_URL = "https://api.twitter.com/oauth/request_token"
AUTHENTICATE_URL = "https://api.twitter.com/oauth/authenticate?oauth_token="
ACCESS_TOKEN_URL = "https://api.twitter.com/oauth/access_token"


CONSUMER_KEY = "jWdjfLA3SbvWNPnE7G8LyoEAI"
CONSUMER_SECRET = "zOuclYiBmfKDztZaKtd77KL0hPf2DbvaQfbYDNNn83P6d3ldue"

TOKENS = {}

###oauth1



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
  return template('index.tpl')

@get('/twitter')
def twitter():
    get_request_token()
    authorize_url = AUTHENTICATE_URL + TOKENS["request_token"]
    response.set_cookie("request_token", TOKENS["request_token"],secret='some-secret-key')
    response.set_cookie("request_token_secret", TOKENS["request_token_secret"],secret='some-secret-key')
    return template('oauth1.tpl', authorize_url=authorize_url)

@get('/callback')

def get_verifier():
  TOKENS["request_token"]=request.get_cookie("request_token", secret='some-secret-key')
  TOKENS["request_token_secret"]=request.get_cookie("request_token_secret", secret='some-secret-key')
  TOKENS["verifier"] = request.query.oauth_verifier
  get_access_token(TOKENS)
  response.set_cookie("access_token", TOKENS["access_token"],secret='some-secret-key')
  response.set_cookie("access_token_secret", TOKENS["access_token_secret"],secret='some-secret-key')
  redirect('/twittear')


@get('/twittear')
def twittear():
    if request.get_cookie("access_token", secret='some-secret-key'):
      TOKENS["access_token"]=request.get_cookie("access_token", secret='some-secret-key')
      TOKENS["access_token_secret"]=request.get_cookie("access_token_secret", secret='some-secret-key')
      return template('tweet')  
    else:
      redirect('/twitter')


@post('/twittear')
def tweet_submit():
  texto = request.forms.get("tweet")
  TOKENS["access_token"]=request.get_cookie("access_token", secret='some-secret-key')
  TOKENS["access_token_secret"]=request.get_cookie("access_token_secret", secret='some-secret-key')
  print CONSUMER_KEY
  print CONSUMER_SECRET
  print TOKENS["access_token"]
  print TOKENS["access_token_secret"]
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
    return "<p>Unable to send tweet</p>"+r.content

@get('/twitter_logout')
def twitter_logout():
  response.set_cookie("access_token", '',max_age=0)
  response.set_cookie("access_token_secret", '',max_age=0)
  redirect('/twitter')



###oauth2

client_id='1002052005922-rr7bc2g3n2721gnb0a61242gog3mt84v.apps.googleusercontent.com'
client_secret='EzJ0lyZxhD_tkIAG5Y5PKbxO'
redirect_uri = 'https://oauth-iesgn.rhcloud.com/oauth2callback'
scope = ['https://www.googleapis.com/auth/youtube','https://www.googleapis.com/auth/userinfo.profile']
token_url = "https://accounts.google.com/o/oauth2/token"


@get('/google')
def get_token():
    return template('oauth2.tpl')


def token_valido():
  token=request.get_cookie("token", secret='some-secret-key')
  if token:
    token_ok = True
    try:
      oauth2 = OAuth2Session(client_id, token=token)
      r = oauth2.get('https://www.googleapis.com/oauth2/v1/userinfo')
    except TokenExpiredError as e:
      token_ok = False
  else:
    token_ok = False
  return token_ok

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

@get('/oauth2callback')
def get_token():

  oauth2 = OAuth2Session(client_id, state=request.cookies.oauth_state,redirect_uri=redirect_uri)
  token = oauth2.fetch_token(token_url, client_secret=client_secret,authorization_response=request.url)
  response.set_cookie("token", token,secret='some-secret-key')
  redirect("/perfil")
  
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

@get('/logout')
def salir():
  response.set_cookie("token", '',max_age=0)
  redirect('/youtube')

@get('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='static')



if __name__ == '__main__':
  run(host='0.0.0.0',port=argv[1])
