from django.shortcuts import render

# Create your views here.
def login_view(request):
    return render(request, 'users/login.html')

def register_view(request):
    return render(request, 'users/register.html')

def forgot_password_view(request):
    return render(request, 'users/forgot_password.html')

def profile_view(request):
    return render(request, 'users/profile.html')

def change_password_view(request):
    return render(request, 'users/change_password.html')