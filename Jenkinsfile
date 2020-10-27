stageResultMap = [:]

pipeline {
    agent any
    parameters {
        choice(
            choices: ['greeting' , 'silence'],
            description: '',
            name: 'REQUESTED_ACTION')
    }
 
    stages {
        
        stage('A') {
            steps {
                println("This is stage: ${STAGE_NAME}")
            }
        }
        
        stage('Check if exist structure terraform') {
                            steps {
                                script {
                                    // Catch exceptions, set the stage result as unstable,
                                    // build result as failure, and the variable didB1Succeed to false
                                    try {
                                        sh "pwd"
                                        sh "pwd -P"
                                        sh "cp ../inventory /ansible-itea/inventory"
                                        
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
                                          

                                            sh " python3 invent.py"
                                            sh "cat inventory"  
                                    

                            }
                        }
    }                  
                        
}

