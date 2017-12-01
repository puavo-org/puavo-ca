pipeline {
  agent {
    docker {
      image 'debian:stretch'
    }
  }
  stages {
    stage('Prepare') {
      steps {
        sh '''
          sudo apt-get update
          sudo apt-get install devscripts dpkg-dev make
        '''
      }
    }

    stage('Build') {
      steps {
        sh 'make deb'
      }
    }
  }
}
