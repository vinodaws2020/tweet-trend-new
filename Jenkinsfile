pipeline {
    agent { label 'maven' }

    environment {
        PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
    }
    stages {
        stage("Build") {
            steps {
                echo "------- Build started --------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "------- Build completed -------"
            }
        }

        stage("Unit Test Report") {
            steps {
                echo "-------- Unit test report generation started ---------"
                sh 'mvn surefire-report:report'
                echo "-------- Unit test report generation completed ---------"
            }
        }

        stage("SonarQube Analysis") {
            environment {
                scannerHome = tool 'sonar-scanner' // Jenkins tool name for Sonar Scanner
            }
            steps {
                withSonarQubeEnv('sonarqube-server') { // Jenkins SonarQube server name
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
