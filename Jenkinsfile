parallel (
    "MP" : { 
    if (params.Services =~ /[MP|ALL]/)  {  
           node { 
               stage('MP Build and Deploy') { // for display purposes
  	           sh "sleep 40s" 
               sh 'echo "MP deploy has passed"; exit 0'
               }
            } 
        }

    },

    "CP" : { 
        if (params.Services =~ /[MP|ALL]/)  {  
            node  { 
                stage('CP Build and Deploy') { // for display purposes
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
