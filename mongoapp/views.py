from __future__ import unicode_literals

from django.template.response import TemplateResponse

from rest_framework_mongoengine.viewsets import ModelViewSet as MongoModelViewSet
from rest_framework import viewsets

from mongoapp.serializers import *
from mongoapp.models import Tool, Book, Author


def index_view(request):
    context = {}
    return TemplateResponse(request, 'index.html', context)


class ToolViewSet(viewsets.ModelViewSet):
    """
    Contains information about inputs/outputs of a single program
    that may be used in Universe workflows.
    """
    
    queryset = Tool.objects.all()
    lookup_field = 'id'
    serializer_class = ToolSerializer



class BookViewSet(viewsets.ModelViewSet):
   
    queryset = Book.objects.all()
    lookup_field = 'id'
    serializer_class = BookSerializer



class AuthorViewSet(MongoModelViewSet):
    lookup_field = 'id'
    serializer_class = AuthorSerializer

    def get_queryset(self):
        print("coming into the query")
        return Author.objects.all()
