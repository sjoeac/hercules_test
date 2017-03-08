//***********************************
// FUNCTIONS 
//***********************************
def runSaltMasterHighState(serviceName, bucketHosts) {
    String deploycommand = ' bb-sites.deploy_build ' + serviceName + ' ' +  params.Version;
    String commandToRun = '\"sudo salt -L  \"' + bucketHosts + '\"' + deploycommand + '\" '
    sh " ssh -o StrictHostKeyChecking=no   infra@10.1.246.251  /bin/bash -c '${commandToRun}' "
}


def main (serviceName){
    if (! fileExists("${WORKSPACE}/hercules/Jenkinsfile")) {
        sh "cd ${WORKSPACE};git clone git@github.com:sjoeac/jenkins_pipeline_test.git;";
        sh " cp hercules/*.pl ${WORKSPACE}@tmp/";
    }    
    else {
        sh(script: "cd ${WORKSPACE}/hercules; git reset --hard HEAD; git pull origin master;", returnStdout: true);
        sh " cp ${WORKSPACE}/hercules/*.pl ${WORKSPACE}@tmp/";
    }
    
    sh(script: " ${WORKSPACE}@tmp/generateBucketData.pl ${env.Version}", returnStdout: true);
    if ( (params.Bucket =~ /failures/)  )    {  
        def getFailedHosts = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers ", returnStdout: true)
        if (getFailedHosts =~/B0*/) {
            print "Container Hosts: FAILURES "  + getFailedHosts
            // Run Salt Master Commands for High State
            runSaltMasterHighState(serviceName,getFailedHosts);
        }              
        sleep 600;
        def getContainterHealth = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers", returnStdout: true)
        if (getContainterHealth =~/B0*/) {
            sh 'curl -X POST --data-urlencode \'payload={"channel": "#hercules", "username": "jenkins-hercules-bot", "text":  "' + params.Bucket + '[' + params.Version + ']'  + '[' + serviceName + '] Failures: '  +  getContainterHealth + '", "icon_emoji": ":ghost:"}\' https://hooks.slack.com/services/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 ; '    
            print "Failures:  "  + getContainterHealth
            sh 'exit 1';
        }              
        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"  ; fi '
        
    }
    else {
        //Get Bucket List for This Tag
        def bucketHosts = sh(script: "${WORKSPACE}@tmp/getBucketData.pl ${env.Version} ${env.Bucket} ${serviceName}", returnStdout: true)
        print "Container Hosts ${env.Bucket}  : "  + bucketHosts
        // Run Salt Master Commands for High State
        runSaltMasterHighState(serviceName,bucketHosts);
        sleep 600;
        def getContainterHealth = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers", returnStdout: true)
        if (getContainterHealth =~/B0*/) {
            sh 'curl -X POST --data-urlencode \'payload={"channel": "#hercules", "username": "jenkins-hercules-bot", "text":  "' + params.Bucket + '[' + params.Version + ']'  + '[' + serviceName + '] Failures: '  +  getContainterHealth + '", "icon_emoji": ":ghost:"}\' https://hooks.slack.com/services/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 ; '    
            print "Failures:  "  + getContainterHealth;
            sh 'exit 1';
        }              
        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"  ; fi '
    
    }

}


def parallelConverge(ArrayList<String> instanceNames) {
    def parallelNodes = [:]

    for (int i = 0; i < instanceNames.size(); i++) {
        def instanceName = instanceNames.get(i)
        parallelNodes[instanceName] = this.getNodeForInstance(instanceName)
    }

    parallel parallelNodes
}

def Closure getNodeForInstance(String serviceName) {
    return {
        node {
            if ( (params.Services =~ /^${serviceName}/)  || (params.Services =~ /ALL/)  )    {  
                stage(serviceName + ' deploy' ) { // for display purposes
                    main(serviceName)
                }   
            }
         }
    }
}



//***********************************
// WORKFLOW
//***********************************

def instanceNames = [ "hdfclimited", "dialerservice", "internal-cds", "exportservice", "cp", "gratter", "newgen", "bb-api", "roboArmService", "insurance-csdb", "notificationservice", "bb-sftp", "txnanalysis", "bankdataupload", "bankdb", "userreviewservice", "icici", "cds", "elasticsearch-prod", "centrelistingservice", "roboticArmService", "axis", "elasticsearch-elk", "csdb", "personalfinanceservice", "bankbridgeservice", "internal-cp", "campaign-tool", "export-service", "dataservice", "hdfc", "indusind", "internal-notificationservice", "mpinsurance", "internal-export-service", "mp"];

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

parallelConverge (instanceNames);

node {
    stage('Results') {
        sh 'echo "ALL TESTS PASS" exit 0'
    }
}

