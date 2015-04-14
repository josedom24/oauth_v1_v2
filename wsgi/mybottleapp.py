# -*- encoding: utf-8 -*-
from bottle import default_app, get, post, template, request, static_file, response
import requests
from requests_oauthlib import OAuth1
from urlparse import parse_qs

def get_request_token():
    oauth = OAuth1(CONSUMER_KEY,
                   client_secret=CONSUMER_SECRET,
    )
    r = requests.post(url=REQUEST_TOKEN_URL, auth=oauth)
 
REQUEST_TOKEN_URL = "https://api.twitter.com/oauth/request_token"
AUTHENTICATE_URL = "https://api.twitter.com/oauth/authenticate?oauth_token="
ACCESS_TOKEN_URL = "https://api.twitter.com/oauth/access_token"
 
CONSUMER_KEY = "MYQ9JgvCMJdjcqtX4dRnk1G4S"
CONSUMER_SECRET = "JeAiQ9IyFJdp3LWrBTl3EBbaqQgSuk0D1aP63JqGcq8lQxRa0c"

TOKENS = {}

@get('/')
def index():
    get_request_token()



# This must be added in order to do correct path lookups for the views
import os
from bottle import TEMPLATE_PATH
TEMPLATE_PATH.append(os.path.join(os.environ['OPENSHIFT_REPO_DIR'], 'wsgi/views/')) 

application=default_app()
