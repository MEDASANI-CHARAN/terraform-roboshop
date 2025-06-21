pipeline {
    agent {
        label 'agent-1'
    }
    options {
                // timeout(time: 100, unit: 'SECONDS')
                timeout(time: 5, unit: 'MINUTES')
                disableConcurrentBuilds()
                ansiColor('xterm')
            }
    parameters {
        choice(name: 'action', choices: ['Apply', 'Destroy'], description: 'Pick something')
    }
    stages {
        stage('Init') {
            steps {
                sh '''
                    cd 01-vpc ; cd ../02-sg
                    terraform init
                    ls -ltr
                '''
            }
        } 
        stage('Plan') {
            when {
                expression {
                    params.action == 'Apply'
                }
            }
            steps {
                sh '''
                   cd 01-vpc ; cd ../02-sg
                   terraform plan
                '''
            }
        }
        // stage('Deploy') {
        //     when {
        //         expression {
        //             params.action == 'Apply'
        //         }
        //     }
        //     input {
        //         message "Should we continue?"
        //         ok "Yes, we should."
        //         }
        //     steps {
        //         sh '''
        //            cd 01-vpc
        //            terraform apply -auto-approve
        //         '''
        //     }
        // } 
        // stage('Destroy') {
        //     when {
        //         expression {
        //             params.action == 'Destroy'
        //         }
        //     }
        //     steps {
        //         sh '''
        //            cd 01-vpc
        //            terraform destroy -auto-approve
        //         '''
        //     }
        // }
    }

    post { 
            always { 
                echo 'I will always say Hello again!'
                deleteDir()
            }
            success { 
                echo 'I will run when pipeline sucess'
            }
            failure { 
                echo 'I will run when pipeline failure'
            }
        } 
}
    