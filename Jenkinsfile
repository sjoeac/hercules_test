node  {

  stage('MP Build and Deploy') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/sjoeac/jenkins_pipeline_test.git'
      sh 'echo "SSH to GOD and run commands for deploy"'
      sh 'uptime'
      sh 'echo "MP deploy has passed"; exit 0'
   }
   stage('CP Build and Deploy') { // for display purposes
      if (isUnix()) {
         sh 'echo "This is a unix os"; exit 0'
      } else {
         sh 'echo "This is not a unix os"; exit 1'
      }
   }
   stage('Results') {
//         junit testresults: '/tmp/test.xml'
         sh 'echo "ALL TESTS PASS" exit 0'
      

   }
}
