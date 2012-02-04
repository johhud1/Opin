# Create your views here.
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse
import datetime
from PinGetter.models import Pin, User, Comment
from django.views.decorators.csrf import csrf_exempt

#add a pin to the user
def addPin(mUser, postDict):
    print("in addPin with user "+str(mUser))
    latitude = postDict.get('latitude', '0')
    longitude = postDict.get('longitude', '0')
    initComment = postDict.get('comment', "COULDN'T GET THE COMMENT FROM BODY")
    mPin = Pin(lat= latitude, long=longitude, user = mUser, firstComment = initComment)
    mPin.save()
    mComment = Comment(comment = initComment, pin_owner = mPin, author = mUser)
    mComment.save()
    mUser.save()

@csrf_exempt
def handleNewPinRequest(request, username):
    print(username)
    if request.method == 'POST':
        mUser = User.objects.get(username= username)
        postDict = request.POST
        try:
            mUser.pin.delete()
            print("pin exists, deleting and then creating new one")
            addPin(mUser, postDict)
        except ObjectDoesNotExist:
            print("no pin, creating one")
            addPin(mUser, postDict)
        return HttpResponse("success, created pin")
    elif request.method == 'GET':
        return HttpResponse("NO GET, TRY POST JERK")


def home(request):
	return HttpResponse("hello world again")
