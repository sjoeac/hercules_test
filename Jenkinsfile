pipeline {
    agent any
    stages {
 
       stage('Deploy MP') {
            steps {
                sh 'echo "Hello World"'
                sh 'uptime'
                echo "Multiline shell steps works too"
                ls -lah
                sh 'echo "CP deploy has passed"; exit 0'
            }
        }

       stage('Build CP') {
            steps {
                sh 'echo "Hello World"'
                echo "Multiline shell steps works too"
                sh 'echo "CP deploy has failed"; exit 1'
            }
        }


    }
}
