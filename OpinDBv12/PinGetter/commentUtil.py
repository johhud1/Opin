from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse
import datetime
from PinGetter.models import Pin, User, Comment

def addComment():


def handleNewCommentRequest(request, pin_id):
    try:
        mPin = Pin.objects.get(id=pin_id)
        print(mPin)
        if request.method == 'POST':
            postDict = request.POST
            commentText = postDict.get('comment', "COULDN'T GET THE COMMENT FROM BODY")
            userText = postDict.get('user', "COULDN'T GET USER ERRORR")
            mUser = User.objects.get(username=userText)

            mComment = Comment(comment = commentText, pin_owner=mPin, author= mUser) 
            mComment.save()
    except ObjectDoesNotExist:
        return HttpResponse("couldn't find pin_id "+pin_id)
        