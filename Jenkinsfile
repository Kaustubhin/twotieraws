pipeline {
    agent any
    stages
    {
        stage("Checkout code")
        {
            steps
            {
                checkout([$class: 'GitSCM', 
                branches: [[name: '*/master']],
                doGenerateSubmoduleConfigurations: false,
                extensions: [
                    [$class: 'SparseCheckoutPaths',  sparseCheckoutPaths:[[$class:'SparseCheckoutPath', path:'sparse/']]]
                ],
                submoduleCfg: [],
                userRemoteConfigs: [[credentialsId: 'none',url: 'http://github.com/Kaustubhin/twotieraws.git']]])

            }
        }
    }

    post{
        
        always
        {
            
                deleteDir()

        }
    }   
}

