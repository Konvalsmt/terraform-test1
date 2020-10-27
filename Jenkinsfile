stageResultMap = [:]
stageResultMap1 = [:]
pipeline {
    agent any

 
    stages {
        
        stage('A') {
            steps {
                  try {
                        sh "mkdir -p ~/Public"
                       }
                         catch (Exception e) {
                                        stageResultMap.didB1Succeed = false                                        
                                    }
            }
        }
        
        stage('Check if exist structure terraform') {
                            steps {
                                script {
                                    // Catch exceptions, set the stage result as unstable,
                                    // build result as failure, and the variable didB1Succeed to false
                                    try {
                                        sh "cp ~/Public/inentory /ansible-itea/inventory"
                                        
                                        stageResultMap.didB1Succeed = true
                                    }
                                    catch (Exception e) {
                                        // currentBuild.result = 'FAILURE'
                                        stageResultMap.didB1Succeed = false                                        
                                    }
                                }
                            }
                        }
        
                stage('Docker apply ansible') {
                            // Execute only if B1 succeeded
                            when {
                                expression {
                                    return stageResultMap.find{ it.key == "didB1Succeed" }?.value
                                }
                            }
                            steps {
                               // script {
                                // Mark the stage and build results as failure on error but continue pipeline execution
                                //catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                                    sh "echo Ansible"
                                //}
                            }
                        }
            
                         stage('Create strucrure terraform') {
                            // Execute only if B1 not succeeded
                            when {
                                expression {
                                    return !stageResultMap.find{ it.key == "didB1Succeed" }?.value
                                }
                            }
                            steps {
                                          
                                    sh "terraform init "
                                    sh "terraform apply -auto-approve "
                                   sh "terraform output > terr-out "
                                   sh "terraform destroy -auto-approve "
                                            sh " python3 invent.py"
                                            sh "cat inventory"  
                                     sh  "cp inventory ~/Public/inventory"
                                     
                                    

                            }
                        }
    }                  
                        
}

