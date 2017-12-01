pipeline {
  agent {
    docker {
      image 'debian:stretch'
      args '-u root'
    }
  }

  stages {
    stage('Prepare') {
      steps {
        sh '''
          apt-get update
          apt-get dist-upgrade
          apt-get install -y devscripts dpkg-dev make
          make install-build-deps
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
