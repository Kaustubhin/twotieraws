pipeline {
    agent none
    stages
    {
        stage("Checkout code")
        {
            agent
            {
                lable ("master")
            }
            steups
            {
                checkout([$class: 'GitSCM', 
                branches: [[name: '*/master']],
                doGenerateSubmoduleConfigurations: false,
                extensions: [
                    [$class: 'SparseCheckoutPaths',  sparseCheckoutPaths:[[$class:'SparseCheckoutPath', path:'sparse/']]]
                ],
                submoduleCfg: [],
                userRemoteConfigs: [[credentialsId: 'someID',url: 'git@https://github.com/Kaustubhin/twotieraws.git']]])

            }
                
        }

    }
}

