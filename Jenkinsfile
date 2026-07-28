def dockerImage

pipeline {

    agent any

    tools {
        maven "maven3.9.9"
    }

    environment {
        registry = "aroy0509/vprofileapp"
        registryCredential = "dockerhub"
    }

    stages {

        stage('BUILD') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo 'Archiving WAR file...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('UNIT TEST') {
            steps {
                sh 'mvn test'
            }
        }

        stage('INTEGRATION TEST') {
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }

        stage('CODE ANALYSIS WITH CHECKSTYLE') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Checkstyle report generated.'
                }
            }
        }

        stage('CODE ANALYSIS WITH SONARQUBE') {

            environment {
                scannerHome = tool 'mysonarscanner4'
            }

            steps {

                withSonarQubeEnv('sonar-pro') {

                    sh """
                    ${scannerHome}/bin/sonar-scanner \
                    -Dsonar.projectKey=vprofile \
                    -Dsonar.projectName=vprofile-repo \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src \
                    -Dsonar.java.binaries=target/classes \
                    -Dsonar.junit.reportsPath=target/surefire-reports \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml
                    """
                }

                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('BUILD APP IMAGE') {

            steps {

                script {

                    dockerImage = docker.build("${registry}:V${BUILD_NUMBER}")

                }

            }
        }

        stage('UPLOAD IMAGE TO DOCKER HUB') {

            steps {

                script {

                    docker.withRegistry('', registryCredential) {

                        dockerImage.push("V${BUILD_NUMBER}")
                        dockerImage.push("latest")

                    }

                }

            }
        }

        stage('REMOVE LOCAL DOCKER IMAGE') {

            steps {

                sh """
                docker rmi ${registry}:V${BUILD_NUMBER} || true
                docker rmi ${registry}:latest || true
                """

            }
        }

        stage('KUBERNETES DEPLOY') {

            agent {
                label 'KOPS'
            }

            steps {

                sh """
                helm upgrade --install vprofile-stack helm/vprofilecharts \
                --namespace prod \
                --create-namespace \
                --set appimage=${registry}:V${BUILD_NUMBER}
                """

            }
        }

    }

    post {

        always {
            cleanWs()
        }

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }

    }

}
