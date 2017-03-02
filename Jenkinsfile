def getBucketScriptsFromGit() {
    git url: 'https://github.com/sjoeac/jenkins_pipeline_test.git';
    sh(script: "chmod +x *.pl", returnStdout: true);
}

def runSaltMasterHighState(bucketHosts) {
    String commandToRun = '\"sudo salt -L  \"' + bucketHosts + '\" cmd.run uptime\" '
    sh " ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/id_ecdsa  infra@10.1.246.251  /bin/bash -c '${commandToRun}' "
}

def main (serviceName){
    if ((params.Services == null) || (params.Bucket == null) || (params.Version == null)) {
        print "ERROR: Null Paramaters"; 
        sh 'exit 1'
    }
    print "DEBUG: parameter Services = " + params.Bucket
    print "DEBUG: parameter Services = " +  params.Version

    //Generate Bucket Data for this Tag
    sh(script: "./generateBucketData.pl ${env.Version}", returnStdout: true);
                  
    //Get Bucket List for This Tag
    def bucketHosts = sh(script: "./getBucketData.pl ${env.Version} ${env.Bucket} ${serviceName}", returnStdout: true)
    print "Container Hosts ${env.Bucket}  : "  + bucketHosts
                  
    // Run Salt Master Commands for High State
    runSaltMasterHighState(bucketHosts);
                  
    // Sleep for 10 mins.
    // Get Container Health
    def getContainterHealth = sh(script: "./getContainerHealth.pl ${serviceName}", returnStdout: true)
    print "Container Hosts: HEALTH "  + getContainterHealth
                 
}



node {
    stage('Git Update') {
        getBucketScriptsFromGit();
    }
}


parallel (
    "MP" : { 
        node { 
            stage('MP Build and Deploy') { // for display purposes
                def serviceName = 'MP'
                if ( (params.Services =~ /MP/)  || (params.Services =~ /ALL/)  )    {  
                    if ( (params.Bucket =~ /failures/)  )    {  
                 
                    }
                    else {
                        main(serviceName);
                        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"; fi '
                    }
                }   
            }
        }
    },

    "CP" : { 
        node  { 
            stage('CP Build and Deploy') { // for display purposes
                def serviceName = 'CP'
                if ( (params.Services =~ /CP/)  || (params.Services =~ /ALL/)  )    {  
                    if ( (params.Bucket =~ /failures/)  )    {  
    
                    }
                    else {
                        main(serviceName);
                        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"; fi '
                    }
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
