//***********************************
// FUNCTIONS 
//***********************************
def runSaltSetBranch() {
    String setBranch    = '\" /usr/local/bin/infra-branch-set ' + params.InfraRepoVersion + '\"'
    String getBranch = '\" /usr/local/bin/infra-branch-get  \"'
    sh " ssh -o StrictHostKeyChecking=no   infra@10.1.246.251  /bin/bash -c '${setBranch}' "
    sh " ssh -o StrictHostKeyChecking=no   infra@10.1.246.251  /bin/bash -c '${getBranch}' "
}

def runSaltMasterHighState(serviceName, bucketHosts) {
    String deploycommand = ' bb-sites.deploy_build ' + serviceName + ' ' +  params.ArtifactVersion;
    String commandToRun1 = '\"sudo salt -L  \"' + bucketHosts + '\" saltutil.refresh_pillar \" '
    String commandToRun2 = '\"sudo salt -L  \"' + bucketHosts + '\" saltutil.sync_all \" '
    String commandToRun3 = '\"sudo salt -L  \"' + bucketHosts + '\" state.highstate -t 300 tomcat \" '
    String commandToRun4 = '\"sudo salt -L  \"' + bucketHosts + '\"' + deploycommand + '\" '
    sh " ssh -o StrictHostKeyChecking=no   infra@10.1.246.251  /bin/bash -c '${commandToRun1}' "
    sh " ssh -o StrictHostKeyChecking=no   infra@10.1.246.251  /bin/bash -c '${commandToRun2}' "
    sh " ssh -o StrictHostKeyChecking=no   infra@10.1.246.251  /bin/bash -c '${commandToRun3}' "
    sh " ssh -o StrictHostKeyChecking=no   infra@10.1.246.251  /bin/bash -c '${commandToRun4}' "
}


def sendSlackNotification (serviceName,message){
   sh 'curl -X POST --data-urlencode \'payload={"channel": "#hercules", "username": "jenkins-hercules-bot", "text":  "' + params.Bucket + '[' + params.Version + ']'  + '[' + serviceName + ']' + message + '", "icon_emoji": ":ghost:"}\' https://hooks.slack.com/services/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 ; '
}


def main (serviceName){
    git 'git@github.com:bankbazaar/hercules.git'
    sh " cp ${WORKSPACE}/*.pl ${WORKSPACE}@tmp/";
    sh(script: " ${WORKSPACE}@tmp/generateBucketData.pl ${env.Version}", returnStdout: true);
    if ( (params.Bucket =~ /failures/)  )    {  
        def getFailedHosts = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers ", returnStdout: true)
        if (getFailedHosts =~/B0*/) {
            print "Running deploy for Failed Container Hosts: "  + getFailedHosts
            runSaltMasterHighState(serviceName,getFailedHosts);
   
            def i = 1;
            while(i < 10) {
                print "Sleep "  + i + " min completed";
                sleep 60;
                def getContainterHealth = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers  ${env.Bucket} ${env.Version}", returnStdout: true)
                if (getContainterHealth =~/Cluster Healthy/) {
                return true // break
                }
            
                def getContainterExitState = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} exit  ${env.Bucket} ${env.Version}", returnStdout: true)
                if (getContainterExitState =~/B0*/) {
                sleep 300;
                getContainterExitState = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} exit ${env.Bucket} ${env.Version}", returnStdout: true)
                 if (getContainterExitState =~/B0*/) {
                    print "Failures: 404's  "  + getContainterExitState;
                    sh 'exit 1';
                    return true // break
                 }
                }
                i = i + 1;
            }

            def getContainterHealth = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers ${env.Bucket} ${env.Version}", returnStdout: true)
            if (getContainterHealth =~/B0*/) {
            sendSlackNotification(serviceName, 'Failures: '  +  getContainterHealth);      
            print "Failures:  "  + getContainterHealth
            sh 'exit 1';
            }              
            sendSlackNotification(serviceName, getContainterHealth);      
        }              
        sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"  ; fi '
    }
    else {
        def bucketHosts = sh(script: "${WORKSPACE}@tmp/getBucketData.pl ${env.Version} ${env.Bucket} ${serviceName}", returnStdout: true)

        if (bucketHosts =~/No minion available/) {
            sendSlackNotification(serviceName, bucketHosts);      
            sh 'if [ "$?" = "0" ]; then echo "${bucketHosts}"  ; fi '
            sh 'exit 0';
            return true // break
        }

        if (bucketHosts =~/ERROR/) {
            sendSlackNotification(serviceName, bucketHosts);      
            print "Container Hosts: FAILURES "  + bucketHosts
            sh 'exit 1';
        }

        //Run Salt Master Commands for High State
        print "Container Hosts: "  + bucketHosts
        runSaltMasterHighState(serviceName,bucketHosts);

        def i = 1;
        while(i < 10) { 
            print "Sleep "  + i + " min completed";
            sleep 60;
            def getContainterHealth = sh(script: "${workspace}@tmp/getContainerHealth.pl ${serviceName} servers ${env.Bucket} ${env.Version}", returnStdout: true)
            if (getContainterHealth =~/Cluster Healthy/) {
                return true // break
            }
            def getContainterExitState = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} exit ${env.Bucket} ${env.Version}", returnStdout: true)
            if (getContainterExitState =~/B0*/) {
                sleep 300;
                getContainterExitState = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} exit ${env.Bucket} ${env.Version}", returnStdout: true)
                if (getContainterExitState =~/B0*/) {
                    print "Failures: 404's  "  + getContainterExitState;
                    sh 'exit 1';
                    return true // break
                }
            }
            i = i + 1;
        }

        def getContainterHealth = sh(script: "${WORKSPACE}@tmp/getContainerHealth.pl ${serviceName} servers", returnStdout: true)
        if (getContainterHealth =~/B0*/) {
            sendSlackNotification(serviceName, 'Failures: '  +  getContainterHealth);      
            print "Failures:  "  + getContainterHealth
            sh 'exit 1';
        }              
        else {
            sendSlackNotification(serviceName, getContainterHealth);      
            sh 'if [ "$?" = "0" ]; then echo "${serviceName} deploy has passed"  ; fi '
        }              
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
            if ( params.Services.tokenize(',').contains(serviceName) || (params.Services == /ALL/) ) {
                stage(serviceName + ' deploy' ) { // for display purposes
                    sendSlackNotification(serviceName, ' deployment in progress...')
                    main(serviceName)
                    sendSlackNotification(serviceName, ' deployment has completed...');      
                }   
            }
         }
    }
}



//***********************************
// WORKFLOW
//***********************************
def instanceNames1 = [] as ArrayList;
def instanceNames2 = [] as ArrayList;

node {
    stage('Git Update: -' + params.InfraRepoVersion) { // for display purposes
        if ((params.Services == null) || (params.Bucket == null) || (params.ArtifactVersion == null) || (params.InfraRepoVersion == null)  ) {
            print "ERROR: Null Paramaters"; 
            sh 'exit 1'
        }
        if (!(params.InfraRepoVersion =~ /rc/)) {
            print "ERROR: InfraRepoVersion Paramater is Invalid"; 
            sh 'exit 1'
        }

        runSaltSetBranch()

        git 'git@github.com:bankbazaar/hercules.git'
        def matcher = readFile("${WORKSPACE}/list_services.txt");
        instanceNames1 = matcher.split("\n");
    }
}

for (i in instanceNames1) {
    instanceNames2.push(i);
}

parallelConverge (instanceNames2);

node {
    stage('Results') {
        sh 'echo "ALL TESTS PASS" exit 0'
    }
}

