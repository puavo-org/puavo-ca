pipeline {
  agent { dockerfile true }
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
