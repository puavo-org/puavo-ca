node {
  stage 'Prepare'
  docker.image('debian:stretch').withRun('-u root') { c ->
    sh '''
      apt-get update
      apt-get install devscripts dpkg-dev make
    '''
  }

  stage 'Build'
  sh 'make deb'
}
