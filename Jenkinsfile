//***********************************
// FUNCTIONS 
//***********************************
def runSaltMasterHighState(bucketHosts) {
    String commandToRun = '\"sudo salt -L  \"' + bucketHosts + '\" cmd.run uptime\" '
    sh " ssh -o StrictHostKeyChecking=no -i /home/infra/id_ecdsa  infra@10.1.246.251  /bin/bash -c '${commandToRun}' "
}


def main (serviceName){
   if (! fileExists("${WORKSPACE}/jenkins_pipeline_test/Jenkinsfile")) {
     sh "chmod 777 ${WORKSPACE}; cd ${WORKSPACE};git clone https://github.com/sjoeac/jenkins_pipeline_test.git;";
     sh " cp jenkins_pipeline_test/*.pl ${WORKSPACE}@tmp/";
   }    
   else {
      //Git Update and Generate Bucket Data for this Tag
      sh(script: "cd ${WORKSPACE}/jenkins_pipeline_test; git reset --hard HEAD; git pull origin master;", returnStdout: true);
      sh " cp ${WORKSPACE}/jenkins_pipeline_test/*.pl ${WORKSPACE}@tmp/";
    }
    
    sh(script: " ${WORKSPACE}@tmp/generateBucketData.pl ${env.Version}", returnStdout: true);
    if ( (params.Bucket =~ /failures/)  )    {  
        def getFailedHosts = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers ", returnStdout: true)
        if (getFailedHosts =~/B0*/) {
            print "Container Hosts: FAILURES "  + getFailedHosts
            // Run Salt Master Commands for High State
            runSaltMasterHighState(getFailedHosts);
        }              
        // Sleep for 10 mins.
        def getContainterHealth = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} debug", returnStdout: true)
        print "Container Hosts: HEALTH "  + getContainterHealth;
        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"; fi '
    }
    else {
        //Get Bucket List for This Tag
        def bucketHosts = sh(script: "${WORKSPACE}@tmp/getBucketData.pl ${env.Version} ${env.Bucket} ${serviceName}", returnStdout: true)
        print "Container Hosts ${env.Bucket}  : "  + bucketHosts
        // Run Salt Master Commands for High State
        runSaltMasterHighState(bucketHosts);

        // Sleep for 10 mins.
        def getContainterHealth = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} debug", returnStdout: true)
        print "Container Hosts: HEALTH "  + getContainterHealth
        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"; fi '
    }
}

//***********************************
// WORKFLOW
//***********************************
node {
    stage('Git Update: ' + params.Bucket +'-' + params.Version) { // for display purposes
        if ((params.Services == null) || (params.Bucket == null) || (params.Version == null)) {
            print "ERROR: Null Paramaters"; 
            sh 'exit 1'
        }
        print "DEBUG: parameter Services = " + params.Bucket
        print "DEBUG: parameter Services = " +  params.Version
    }
}

parallel (
    "MP" : { 
        node { 
            if ( (params.Services =~ /MP/)  || (params.Services =~ /ALL/)  )    {  
                def serviceName = 'MP'
                stage(serviceName + ' Deploy' ) { // for display purposes
                    main(serviceName)
                }   
            }
        }
    },

    "CP" : { 
        node  { 
            if ( (params.Services =~ /CP/)  || (params.Services =~ /ALL/)  )    {  
                def serviceName = 'CP'
                stage(serviceName + ' Deploy' ) { // for display purposes
                    main(serviceName)
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
