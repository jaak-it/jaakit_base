node {
    def app
    def dockerName = 'jaakit_base'
    def dockerMayorVersion = '0'
    def dockerMinorVersion = '0'
    def dockerLoginUser = 'admin'
    def dockerLoginPassword = '1Mono2019'
    def dockerFile = 'Dockerfile'
    def jenkinsURL = 'doomtreader.yellowbrain.io:8083'

    try {
        notifyBuild('STARTED')
        stage('Clone repository') {
          checkout scm
        }

        stage('Docker Login') {
          sh ("docker login -u ${dockerLoginUser} -p ${dockerLoginPassword} ${jenkinsURL}")
        }

        stage('Build image') {
          sh ("docker build -t ${dockerName}:${dockerMayorVersion}.${dockerMinorVersion}.${env.BUILD_NUMBER} -f ${dockerFile} .")
        }

        stage('Docker Login') {
          sh ("docker login -u ${dockerLoginUser} -p ${dockerLoginPassword} ${jenkinsURL}")
        }

        stage('Tag Image'){
          sh "docker tag ${dockerName}:${dockerMayorVersion}.${dockerMinorVersion}.${env.BUILD_NUMBER} ${jenkinsURL}/${dockerName}:${dockerMayorVersion}.${dockerMinorVersion}.${env.BUILD_NUMBER}"
        }

        stage('Push into Nexus'){
          sh  "docker push ${jenkinsURL}/${dockerName}:${dockerMayorVersion}.${dockerMinorVersion}.${env.BUILD_NUMBER}"
        }

        stage('Remove Unused docker image') {
            sh "docker image prune -a --filter ''until=48h'' -f"
        }


        } catch (e) {
          // If there was an exception thrown, the build failed
          currentBuild.result = "FAILED"
          throw e
        } finally {
          // Success or failure, always send notifications
          notifyBuild(currentBuild.result)
        }
}

def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (color: colorCode, message: summary)
}