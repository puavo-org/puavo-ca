pipeline {
  agent {
    docker {
      image 'debian:stretch'
      // XXX could you do most operations as normal user?
      args '-u root --mount source=var_cache_apt_stretch,target=/var/cache/apt'
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
