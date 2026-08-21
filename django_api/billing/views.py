from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

class BillingInfoView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        return Response({
            "message": "Welcome to the Billing API!",
            "user": str(user),
            "status": "active",
            "balance": "$120.00"
        })
