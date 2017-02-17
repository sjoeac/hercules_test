node {
   def mvnHome
   mvnHome = '/usr'   

  stage('MP Build and Deploy') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/sjoeac/jenkins_pipeline_test.git'
      sh ' ls -l jenkins_pipeline_test/'
      sh 'echo "MP deploy has passed"; exit 0'
   }
   stage('CP Build and Deploy') { // for display purposes
      if (isUnix()) {
         sh "'${mvnHome}/bin/mvn -v' "
      } else {
         sh 'echo "This is not a unix os"; exit 1'
      }
   }
   stage('Results') {
      junit '**/target/surefire-reports/TEST-*.xml'
      archive 'target/*.jar'
   }
}


