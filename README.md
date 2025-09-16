Project Setup with Docker (Django + MySQL)

This guide explains how to run the Django project with Docker and MySQL locally, along with all the fixes we applied during troubleshooting.

1. Clone the project & create .env

Create a .env file in the project root with database credentials:

# Database details
DB_NAME=django_auth
DB_USER=django
DB_PASSWORD=djangopass
DB_HOST=db
DB_PORT=3306

2. docker-compose.yml, Dockerfile configuration and mention all pip install modules in requirements.txt file

3. Build & Run

docker-compose build
docker-compose up -d

4. Run Migrations

docker exec -it django_app python manage.py migrate

5. Access App

Open in browser: http://localhost:8001

6. Bug Fixes & Issues Solved

    Here’s what we encountered & how we fixed it:

    ModuleNotFoundError: No module named 'decouple'
    → Installed via pip install python-decouple in Dockerfile.

    MySQL authentication error (cryptography required)
    → Forced MySQL user to use mysql_native_password instead of caching_sha2_password.

    Access denied for user issue
    → Created dedicated user inside MySQL with env variables.

    CREATE USER 'django'@'%' IDENTIFIED WITH mysql_native_password BY 'djangopass';
    GRANT ALL PRIVILEGES ON django_auth.* TO 'django'@'%';
    FLUSH PRIVILEGES;


    Django couldn’t connect to DB (Errno 111: Connection refused)
    → Added command: sh -c "sleep 15 && python manage.py migrate && python manage.py runserver 0.0.0.0:8000" in web section docker-compose.yml
    → Added healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-proot"]
      interval: 5s
      retries: 10


    Port conflicts (8000 already in use)
    → Exposed Django on 8001:8000.

    SSL self-signed cert error
    → Disabled SSL in settings.py using:

    "ssl": {"ca": None}

    -----------------------------------------------------------------------------------------------------------------------------

Staging Setup on AWS (EC2)

To deploy on AWS EC2 staging environment:

1. Install Docker & Docker Compose on EC2

sudo apt update -y
sudo apt install docker.io docker-compose -y
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

2. Copy project files to server
git clone <repo_url> /home/ubuntu/django-pro
cd django-pro

3. Configure .env for staging

DB_NAME=django_auth
DB_USER=django
DB_PASSWORD=stagingpass
DB_HOST=db
DB_PORT=3306
(Optionally use AWS RDS instead of containerized MySQL — update DB_HOST accordingly)

4. Run containers

docker-compose -f docker-compose.yml up -d --build

5. Allow Security Group Ports

Open 8001 (Django app)
Open 3306 (if using external RDS, restrict to app IP only)

6. Run migrations on server
docker exec -it django_app python manage.py migrate

7. Access App
http://<EC2-Public-IP>:8001

Now your project will work both locally & on AWS staging with Docker.

---------------------------------------------------------------------------------------------------------

Steps to setup Docker for django-app
1. install docker and docker desktop
2. check docker —version
3. create Dockerfile for docker configuration
4. create docker-compose.yml file for create container for django-app and mysql-db container with proper healthcheck to remove conflicts
5. check with docker compose up

Steps to setup on github for django-app repo:
1. generate GAT for jenkins credentails to access github repo
2. generate github webhook and add jenkins server url
3. In case of localhost generate public url using ngrok install
4. ngrok login and generate auth token first
5. ngrok http 8080 and generate public url for jenkins localhost port
6. now attach this url to github webhook

Steps to setup CI/CD using Jenkins:
1. install java jdk, install jenkins
2. generate admin password
3. login
4. install required plugins github, GitHub Integration plugin etc.
5. configure .env credentials and github credentials to jenkins manage credentials
6. create pipeline for django-app
7. configure webhook in pipeline
8. In django-app create jenkinsfile and mentions all stages to check 
9. check required file permissions to read .env of files and folder
10. now push the code and check on jenkins to create auto build generate after kill old build

