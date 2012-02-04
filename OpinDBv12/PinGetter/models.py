from django.db import models

# Create your models here.

class Comment(models.Model):
    comment = models.CharField(max_length = 141)
    pin_owner = models.ForeignKey('Pin')
    author = models.ForeignKey('User')
    pub_date = models.DateTimeField('date of Comment', null = True)
    pub_date.auto_now_add = True
    def __unicode__(self):
        return self.comment

class User(models.Model):
    username = models.CharField(max_length = 20, primary_key=True)
    email = models.EmailField(max_length = 70)
    password = models.CharField(max_length = 20)
    following = models.ManyToManyField('User', related_name="followers")
    def __unicode__(self):
        return (self.username)

class Pin(models.Model):
    pub_date = models.DateTimeField('date of Comment', null = True)
    pub_date.auto_now_add = True
    lat = models.FloatField()
    long = models.FloatField()
    firstComment = models.CharField(max_length = 141)
    user = models.OneToOneField('User', unique = True, blank = True, null = True)
    active = models.BooleanField(default = True)
    
    def __unicode__(self):
        return (str(self.id)+' '+self.user.username+' date:'+str(self.pub_date))