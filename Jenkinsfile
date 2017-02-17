node  {
 def inputParams = inputParamsString(new File(pwd()))
    
    // Change `message` value to the message you want to display
    // Change `description` value to the description you want
    def selectedProperty = input( id: 'userInput', message: 'Choose properties file', parameters: [ [$class: 'ChoiceParameterDefinition', choices: inputParams, description: 'Properties', name: 'prop'] ])
    
    println "Property: $selectedProperty"
    
    // Change `job` value to your downstream job name
    // Change `name` value to the name you gave the string parameter in your downstream job
    build job: 'downstream-freestyle', parameters: [[$class: 'StringParameterValue', name: 'prop', value: selectedProperty]]



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
         junit testresults: '/tmp/test.xml'
         sh 'echo "ALL TESTS PASS" exit 0'
      

   }
}
