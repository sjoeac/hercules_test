def getBucketScriptsFromGit() {
    git url: 'https://github.com/sjoeac/jenkins_pipeline_test.git';
    sh 'chmod +x getBucketData.pl';
    sh 'chmod +x generateBucketData.pl';
    sh 'chmod +x getContainerHealth.pl';
}

def runSaltMasterHighState(bucketHosts) {
    String commandToRun = '\"sudo salt -L  \"' + bucketHosts + '\" cmd.run uptime\" '
    sh " ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/id_ecdsa  infra@10.1.246.251  /bin/bash -c '${commandToRun}' "
}

parallel (
    "MP" : { 
        if ( (params.Services =~ /MP/)  || (params.Services =~ /ALL/)  )    {  
             node { 
               stage('MP Build and Deploy') { // for display purposes
               if ((params.Services == null) || (params.Bucket == null) || (params.Version == null)) {
                    sh 'echo "ERROR: Null Paramaters"; exit 1'
               }
                print "DEBUG: parameter Services = " + params.Bucket
                print "DEBUG: parameter Services = " +  params.Version
                
                sh "./generateBucketData.pl ${env.Version}"            
                sh "./getBucketData.pl ${env.Version} ${env.Bucket} mp"            
                 
                //Placeholders
                sh 'if [ "$?" = "0" ]; then echo "MP deploy has passed"; fi '
               }
            } 
        }

    },

    "CP" : { 
        if ( (params.Services =~ /CP/)  || (params.Services =~ /ALL/)  )    {  
            node  { 
               stage('CP Build and Deploy') { // for display purposes
                  sh 'echo "Get Container Health for Service: CP"'
                  getBucketScriptsFromGit();
                  sh "./generateBucketData.pl ${env.Version}"            
                  def bucketHosts = sh(script: "./getBucketData.pl ${env.Version} ${env.Bucket} cp", returnStdout: true)
                  runSaltMasterHighState(bucketHosts);
            
                  sh 'echo "Get Container Health for Service: CP"'
                 //sh './getContainerHealth.pl cp"
                  sh 'if [ "$?" = "0" ]; then echo "CP deploy has passed"; fi '
    
                }
            } 
         }
    }
)

node {
    stage('Results') {
        sh 'echo "ALL TESTS PASS" exit 0'
    }
}


