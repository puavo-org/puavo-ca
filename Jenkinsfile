pipeline {
  agent { dockerfile true }
  stages {
    stage('Prepare') {
      steps {
        sh 'sudo make install-build-deps'
      }
    }
    stage('Build') {
      steps {
        sh 'make deb'
      }
    }
  }
}
