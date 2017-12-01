pipeline {
  agent {
    dockerfile true
    args '-u root'
  }

  stages {
    stage('Prepare') {
      steps {
        sh 'whoami'
        sh 'make install-build-deps'
      }
    }
    stage('Build') {
      steps {
        sh 'make deb'
      }
    }
  }
}
