
//***********************************
// FUNCTIONS 
//***********************************
def runSaltMasterHighState(bucketHosts) {
    String commandToRun = '\"sudo salt -L  \"' + bucketHosts + '\" cmd.run uptime\" '
    sh " ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/id_ecdsa  infra@10.1.246.251  /bin/bash -c '${commandToRun}' "
}


def main (serviceName){
    //Git Update and Generate Bucket Data for this Tag
    //sh(script: "git reset --hard HEAD; git pull origin master;", returnStdout: true);
    sh(script: "./generateBucketData.pl ${env.Version}", returnStdout: true);
    if ( (params.Bucket =~ /failures/)  )    {  
        def getFailedHosts = sh(script: "./getContainerHealth.pl ${serviceName} servers ", returnStdout: true)
        if (getFailedHosts =~/B0*/) {
            print "Container Hosts: FAILURES "  + getFailedHosts
            // Run Salt Master Commands for High State
            runSaltMasterHighState(getFailedHosts);
        }              
        // Sleep for 10 mins.
        def getContainterHealth = sh(script: "./getContainerHealth.pl ${serviceName} debug", returnStdout: true)
        print "Container Hosts: HEALTH "  + getContainterHealth;
        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"; fi '
    }
    else {
        //Get Bucket List for This Tag
        def bucketHosts = sh(script: "./getBucketData.pl ${env.Version} ${env.Bucket} ${serviceName}", returnStdout: true)
        print "Container Hosts ${env.Bucket}  : "  + bucketHosts
        // Run Salt Master Commands for High State
        runSaltMasterHighState(bucketHosts);

        // Sleep for 10 mins.
        def getContainterHealth = sh(script: "./getContainerHealth.pl ${serviceName} debug", returnStdout: true)
        print "Container Hosts: HEALTH "  + getContainterHealth
        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"; fi '

    }
}

//***********************************
// WORKFLOW
//***********************************
node {
    stage('Git Update: ' + params.Bucket +'-' + params.Version) { // for display purposes
        git url: 'https://github.com/sjoeac/jenkins_pipeline_test.git';
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

