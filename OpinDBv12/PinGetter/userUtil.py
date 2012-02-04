from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse, HttpResponseForbidden
import datetime
from PinGetter.models import Pin, User, Comment

#create new User
def addUser(username):
    mUser = User(username)
    mUser.save()

def handleNewUserRequest(request, username):
    print(username)
    try:
        User.objects.get(username = username)
        print("username already in use")
        return HttpResponseForbidden()
    except ObjectDoesNotExist:
        addUser(username)
    return HttpResponse("SUCCESS, user "+username+" added")