pipeline {
  agent {
    docker {
      image 'debian:stretch'
    }
  }
  stages {
    stage('Prepare') {
      steps {
        docker.image('debian:stretch').withRun('-u root') { c ->
          sh '''
            apt-get update
            apt-get install devscripts dpkg-dev make
          '''
        }
      }
    }

    stage('Build') {
      steps {
        sh 'make deb'
      }
    }
  }
}
