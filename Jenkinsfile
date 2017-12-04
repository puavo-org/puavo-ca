pipeline {
  agent {
    docker {
      image 'debian:stretch'
      // XXX could you do most operations as normal user?
      args '-u root'
    }
  }

  stages {
    stage('Prepare') {
      steps {
        sh '''
          apt-get update
          apt-get install -y strace
          strace apt-get dist-upgrade
          apt-get install -y devscripts dpkg-dev make
          make -f Makefile.debian install-build-deps
        '''
      }
    }

    stage('Build') {
      steps {
        sh 'make -f Makefile.debian deb'
      }
    }

    stage('Test') {
      steps {
        sh 'make test'
      }
    }

    stage('Upload') {
      steps {
        sh 'make -f Makefile.debian upload-deb'
      }
    }
  }
}
