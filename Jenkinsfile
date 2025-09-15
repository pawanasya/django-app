pipeline {
    agent any

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
                    sh 'cp $ENV_FILE .env'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh './venv/bin/python manage.py test'
            }
        }
    }
}
