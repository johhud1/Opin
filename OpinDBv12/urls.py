from django.conf.urls.defaults import patterns, include, url
from OpinDBv12 import PinGetter

# Uncomment the next two lines to enable the admin:

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    url(r'^PinGetter/$', 'PinGetter.views.home'),
    # url(r'^OpinDBv1/', include('OpinDBv1.foo.urls')),
    url(r'^createPin/(?P<username>\S{0,20})', 'PinGetter.views.handleNewPinRequest'),
    url(r'^createUser/(?P<username>\S{0,20})', 'PinGetter.userUtil.handleNewUserRequest'),
    url(r'^createComment/(?P<pin_id>\d+})', 'PinGetter.commentUtil.handleNewRequest'),
    url(r'^queryPins', 'PinGetter.queryUtil.gimmePins'),
    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)
