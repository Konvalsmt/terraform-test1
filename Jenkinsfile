stageResultMap = [:]
stageResultMap1 = [:]
pipeline {
    agent any

 
    stages {
        
        stage('A') {
            steps {
                script {
                  try {
                        sh "mkdir -p ~/Public"
                       }
                         catch (Exception e) {
                                        stageResultMap1.didB1Succeed = false                                        
                                    }
                }      
            }
        }
        
        stage('Check if exist structure terraform') {
                            steps {
                                script {
                                    // Catch exceptions, set the stage result as unstable,
                                    // build result as failure, and the variable didB1Succeed to false
                                    try {
                                        sh "cp ~/Public/inventory ./ansible/inventory"
                                        
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
                                   sh "ansible-playbook -b -i ./ansible/inventory -e AGE=100 --private-key $PATH_TO_KEY ./ansible/docker.yml"
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
                                 script {    
                                    sh "terraform init "
                                    sh "terraform apply -auto-approve "
                                    sh "terraform output > terr-out "
                                    sh " python3 invent.py"
                                    sh "cat inventory"  
                                    sh  "cp inventory ./ansible/inventory"
                                    sh  "cp inventory ~/Public/inventory" 
                                    sh  "cp index.html ~/Public/index.html"
                                    sh  "cp Dockerfile  ~/Public/Dockerfile"
                                    sh "eval \$(python3 -c 'import os; f=open(\"envparam1\",\"r+\"); p=f.readline();f.close() ;  print(p)') "
                                    sh  "cp terraform.tfstate  ~/Public/terraform.tfstate"
                                    def ls="cat envparam1".execute().text
                                   //#def list=ls.readLine()
                                    //echo "${ls}"
                                    sh  " printenv "
                                 }    

                            }
                        }
        
              stage('Run Docker with ansible') {
                            steps {
                                script {
                                    // Catch exceptions, set the stage result as unstable,
                                    // build result as failure, and the variable didB1Succeed to false
                                  
                                   sh "ansible-playbook -b -i ./ansible/inventory -e AGE=40 --private-key $PATH_TO_KEY ./ansible/docker.yml"
                                   
                                }
                            }
                        } 
        
        
    }                  
                        
}

