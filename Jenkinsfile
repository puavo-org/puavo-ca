pipeline {
  agent {
    docker {
      image 'debian:stretch'
    }
  }
  stages {
    stage('Build') {
      steps {
        sh 'make deb'
      }
    }
  }
}
