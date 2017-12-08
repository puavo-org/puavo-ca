pipeline {
  agent {
    docker {
      image 'debian:stretch'
      // XXX could you do most operations as normal user?
      args '-u root --mount type=bind,source=/etc/jenkins-docker-config,destination=/etc/jenkins-docker-config,readonly'
    }
  }

  stages {
    stage('Prepare') {
      steps {
        sh '''
          apt-get update
          apt-get -y dist-upgrade
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
        sh '''
          install -o root -g root -m 644 /etc/jenkins-docker-config/dput.cf \
            /etc/dput.cf
          install -o root -g root -m 644 \
            /etc/jenkins-docker-config/ssh_known_hosts \
            /etc/ssh-docker-config/ssh_known_hosts
        '''

        withCredentials([sshUserPrivateKey(credentialsId: 'puavo-deb-upload',
                                           keyFileVariable: 'ID_RSA',
                                           passphraseVariable: '',
                                           usernameVariable: '')]) {
          sh 'cp -p "$ID_RSA" ~/.ssh/id_rsa'
        }
        sh 'make upload-deb'
      }
    }
  }
}
