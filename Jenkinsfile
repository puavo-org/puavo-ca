node {
  stage('Prepare') {
    def image = docker.image('debian:stretch')
    image.withRun('-u root') { c ->
      image.inside {
        sh '''
	  apt-get update
	  apt-get install devscripts dpkg-dev make
        '''
      }
    }
  }

  stage('Build') {
    sh 'make deb'
  }
}
