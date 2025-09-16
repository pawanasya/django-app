pipeline {
    agent any

    environment {
        IMAGE_NAME = "django-app"
        DJANGO_CONTAINER = "django_app"
        MYSQL_CONTAINER = "mysql_db"
        NETWORK_NAME = "django-net"
        PATH = "/usr/local/bin:$PATH"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/pawanasya/django-app.git',
                    credentialsId: 'github-creds'
            }
        }

        stage('Load Env File') {
            steps {
                withCredentials([file(credentialsId: 'django-env-file', variable: 'ENV_FILE')]) {
                    sh 'cp $ENV_FILE $WORKSPACE/.env'
                }
            }
        }

        stage('Check Docker') {
            steps {
                sh 'docker --version'
                sh 'docker ps'
            }
        }

        stage('Create Docker Network') {
            steps {
                sh "docker network create ${NETWORK_NAME} || true"
            }
        }

        stage('Run MySQL Container') {
            steps {
                script {
                    sh """
                        docker rm -f ${MYSQL_CONTAINER} || true
                        docker run -d --name ${MYSQL_CONTAINER} \
                        --network ${NETWORK_NAME} \
                        -e MYSQL_ROOT_PASSWORD=root \
                        -e MYSQL_DATABASE=django_auth \
                        -e MYSQL_USER=django \
                        -e MYSQL_PASSWORD=djangopass \
                        mysql:8.0
                    """
                }
            }
        }

        stage('Build Django Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Run Tests in Container') {
            steps {
                script {
                    sh """
                        docker run --rm --network ${NETWORK_NAME} \
                        --env-file .env \
                        ${IMAGE_NAME}:latest python manage.py test
                    """
                }
            }
        }

        stage('Deploy Django Container') {
            steps {
                script {
                    sh "docker rm -f ${DJANGO_CONTAINER} || true"
                    sh """
                        docker run -d --name ${DJANGO_CONTAINER} \
                        --network ${NETWORK_NAME} \
                        --env-file .env \
                        -p 8001:8000 \
                        ${IMAGE_NAME}:latest \
                        sh -c '
                        until mysqladmin ping -h ${MYSQL_CONTAINER} -u django -pdjangopass --silent; do
                            echo "Waiting for MySQL to be ready..."
                            sleep 5
                        done
                        python manage.py migrate
                        python manage.py runserver 0.0.0.0:8000
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Django should be running on http://localhost:8001"
        }
    }
}
