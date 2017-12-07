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

    stage('Test') {
      steps {
        sh 'make test'
      }
    }

    stage('Upload') {
      steps {
        withCredentials([file(credentialsId: 'dput.cf',
                              variable: 'DPUT_CONFIG_FILE')]) {
          sh 'install -o root -g root -m 644 "$DPUT_CONFIG_FILE" /etc/dput.cf'
        }
        withCredentials([sshUserPrivateKey(credentialsId: 'puavo-deb-upload',
                                           keyFileVariable: '',
                                           passphraseVariable: '',
                                           usernameVariable: '')]) {
          sh 'make upload-deb'
        }
      }
    }
  }
}
