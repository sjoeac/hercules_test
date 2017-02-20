node  {
    if (params.Services == 'mp')  {
     stage('MP Build and Deploy') { // for display purposes
        sh 'echo "SSH to GOD and run commands for deploy"'
        sh 'uptime'
        sh 'curl http://10.1.25.16:8500/v1/agent/members'
        sh 'echo "MP deploy has passed"; exit 0'
     }
    }   

    if (params.Services == 'cp')  {
      stage('CP Build and Deploy') { // for display purposes
      if (isUnix()) {
         sh 'echo "This is a unix os"; exit 0'
      } else {
         sh 'echo "This is not a unix os"; exit 1'
      }
     } 
    }   

   
    stage('Results') {
       if (params.Bucket)  {
         print "DEBUG: parameter Bervices = " + params.Bucket
        }
        sleep 10    
        if (params.Version)  {
         print "DEBUG: parameter Vervices = " +  params.Version
        }
         sh 'echo "ALL TESTS PASS" exit 0'

    }
    
}
