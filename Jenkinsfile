node {
   def mvnHome
   mvnHome = '/usr'   

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
   // install required bundles
   sh 'bundle install'
   // build and run tests with coverage
   sh 'bundle exec rake build spec'
   // Archive the built artifacts
   archive (includes: 'pkg/*.gem')

   }
}


