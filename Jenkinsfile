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

        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
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

