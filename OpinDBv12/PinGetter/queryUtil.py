from django.core.exceptions import ObjectDoesNotExist
from django.core import serializers
from django.http import HttpResponse
import datetime
from PinGetter.models import Pin, User, Comment

def gimmePins(request):
    mhttpResponse = HttpResponse()
    pins = Pin.objects.all()
    json_serializer = serializers.get_serializer("json")()
    json_serializer.serialize(pins, ensure_ascii=False, stream = mhttpResponse)
    #comments = Comment.objects.all()
    #json_serializer.serialize(comments, ensure_ascii=False, stream=mhttpResponse)
    return mhttpResponse