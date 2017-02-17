node {
   stage 'mp'
   		echo 'Running deployment jobs for MP'
                sh 'uptime'


   stage 'cds'
   		echo 'Running deployment jobs for cds'




    mail body: 'project build successful',
                        from: 'stephen.c@bankbazaar.com',
                        replyTo: 'stephen.c@bankbazaar.com',
                        subject: 'project build successful',
                        to: 'stephen.c@bankbazaar.com'




}
