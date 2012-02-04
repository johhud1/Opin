import os, sys

#sys.path.append('/Users/jack/Downloads/Django-1.3.1/django')
sys.path.append('/Users/jack/Documents')
sys.path.append('/Users/jack/Documents/OpinDBv12')
os.environ['DJANGO_SETTINGS_MODULE'] = 'OpinDBv12.settings'
#os.environ.setdefault("DJANGO_SETTINGS_MODULE", "OpinDBv12.settings")

# This application object is used by the development server
# as well as any WSGI server configured to use this file.

import django.core.handlers.wsgi

application = django.core.handlers.wsgi.WSGIHandler()

