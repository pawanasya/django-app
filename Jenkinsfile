pipeline {
    agent any

    environment {
        IMAGE_NAME = "django-app"
        CONTAINER_NAME = "django_app"
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

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Run Tests in Container') {
            steps {
                script {
                    sh "docker run --rm --env-file .env ${IMAGE_NAME}:latest python manage.py test"
                }
            }
        }

        stage('Deploy Locally') {
            steps {
                script {
                    // पुराना container stop/remove
                    sh "docker rm -f ${CONTAINER_NAME} || true"

                    // नया container run
                    sh """
                        docker run -d --name ${CONTAINER_NAME} \
                        --env-file .env \
                        -p 8001:8000 ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        always {
            // Container cleanup ताकि Jenkins agent साफ रहे
            sh "docker rm -f ${CONTAINER_NAME} || true"
        }
    }
}


