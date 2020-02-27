pipeline {
    agent none
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
                userRemoteConfigs: [[credentialsId: 'none',url: 'git@https://github.com/Kaustubhin/twotieraws.git']]])

            }
        }
    }   
}

