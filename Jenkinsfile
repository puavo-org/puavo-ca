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
          apt-get update
          apt-get install devscripts dpkg-dev make
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
