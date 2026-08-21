from django.urls import path
from .views import BillingInfoView

urlpatterns = [
    path('info/', BillingInfoView.as_view(), name='billing-info'),
]
