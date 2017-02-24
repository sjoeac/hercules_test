
node  {
                git url: 'https://github.com/sjoeac/jenkins_pipeline_test.git'
                sh 'chmod +x getContainerHealth.pl'
    
}

parallel (
    "MP" : { 
        if ( (params.Services =~ /MP/)  || (params.Services =~ /ALL/)  )    {  
             node { 
               stage('MP Build and Deploy') { // for display purposes
               if ((params.Services == null) || (params.Bucket == null) || (params.Version == null)) {
                    sh 'echo "ERROR: Null Paramaters"; exit 1'
               }
                print "DEBUG: parameter Bervices = " + params.Bucket
                print "DEBUG: parameter Vervices = " +  params.Version
                
                 // sh "sleep 40s" 
               // String commandToRun = '\"sudo salt -C "B053APP*" cmd.run "uptime"\" '
               // sh " ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/id_ecdsa  infra@10.1.246.251  /bin/bash -c '${commandToRun}' "
                sh 'echo "Get Container Health for Service: MP"'
                sh './getContainerHealth.pl mp'
                sh 'echo "MP deploy has passed"; exit 0'
               }
            } 
        }

    },

    "CP" : { 
        if ( (params.Services =~ /CP/)  || (params.Services =~ /ALL/)  )    {  
            node  { 
               stage('CP Build and Deploy') { // for display purposes
                  sh 'echo "Get Container Health for Service: CP"'
        	      sh 'echo "CP deploy has passed"; exit 0'
                }
            } 
         }
    }
)

node {
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

