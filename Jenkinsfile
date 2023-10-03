pipeline {
    agent any
    environment {
        REGION = "ap-southeast-1"
        PROJECT = "rnd"
        
        SLACK_COLOR_DANGER  = '#E01563'
        SLACK_COLOR_INFO    = '#6ECADC'
        SLACK_COLOR_WARNING = '#FFC300'
        SLACK_COLOR_GOOD    = '#3EB991'
        SLACK_WEBHOOK_URL   = 'https://hooks.slack.com/services/XXXXXXXXX'
        SLACK_CHANNEL       = 'xxxxxxxx'
        infra_repo = 'infra_repo'
        codebase_tag = 'codebase-repo'
        GITHUB_ACCESS_TOKEN   = credentials('gh_token')

    }

    parameters {
        choice(choices: ["uat", "lt", "prod"], description: "Select Environment", name: "ENVIRONMENT")
        choice(name: "terraform_changes", choices: ["no", "yes"], description: "Run Terraform?")
        choice(name: "helm_changes", choices: ["no", "yes"], description: "Kubernetes Changes")

        string(defaultValue: "release-tag", description:"Release Tag", name: "codebase_tag")
        string(defaultValue: "codebase_repo", description:"Codebase Release TAG", name: "codebase_repo")

        choice(name: "all_mw", choices: ["no", "yes"], description: "Do you want to deploy All Middleware?")
        choice(name: "mw1", choices: ["no", "yes"], description: "Do you want to deploy mw1?")
        choice(name: "mw2", choices: ["no", "yes"], description: "Do you want to deploy mw2?")
        choice(name: "mw3", choices: ["no", "yes"], description: "Do you want to deploy mw3?")


    }
    stages {
        stage ('WarmUP') {
            parallel {
                stage('Checkout Infra Code') {
                    steps {
                        script {
                            if (env.ENVIRONMENT == 'prod') {
                                IBRANCH = 'master'
                            }
                            if (env.ENVIRONMENT == 'uat') {
                                IBRANCH = 'develop'
                            }
                            if (env.ENVIRONMENT == 'lt') {
                                IBRANCH = 'loadtest'
                            }
                        }
                        git(url: "https://github.com/company/${env.infra_repo}", branch: "${IBRANCH}", credentialsId: 'github_credential')
                    }
                }
                stage('CodeBase Checkout'){
                    steps {
                        script {
                            if ( params.all_mw == "yes" || params.mw1 == "yes" || params.mw2 == "yes" || params.mw3 == "yes" ){
                            dir("${params.codebase_tag}") {
                                git(url: "https://github.com/company/${params.codebase_tag}", branch: "develop" , credentialsId: 'github_credential')
                                // sh script:"docker system prune -af", label:"docker prune"
                                sh script:"git checkout ${params.codebase_tag}", label:"git checkout to tag"
                                }
                            }
                        }
                    }
                }
            }
        }   
        stage('Terraform Plan') {
            when {
                expression {
                    params.terraform_changes == "yes"
                }
            }
            steps {
                dir('terraform/source') {
                    sh script:"terraform init",label:"tf init"
                    sh script:"terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}",label:"workspace select"
                    sh script:"terraform plan -out=myplan",label:"tf plan"
                }
            }
        }
        stage('Terraform Apply') {
            when {
                expression {
                    params.terraform_changes == "yes"
                }
            }
            steps {
                input 'Do you want to proceed?'
                dir('terraform/source') {
                    sh script:"terraform apply -input=false myplan",label:"tf apply"
                }
            }
        }

        stage('rnd MW Docker Build') {
            parallel {
                stage('Build mw1 Docker Image') {

                    when {
                        anyOf {
                            expression { params.all_mw == "yes" }
                            expression { params.mw1 == "yes" }
                        }
                    }

                    steps {
                        dir("${workspace}") {
                            sh script:"ansible-playbook ansible/image_build.yaml -e workspace=${workspace} -e CodeRepo=${params.codebase_tag} -e module=mw1 -e GITHUB_TOKEN=${env.GITHUB_ACCESS_TOKEN} -e env=${params.ENVIRONMENT}",label:"image build - mw1"
                        }
                    }
                }
                stage('Build mw2 Docker Image') {

                    when {
                        anyOf {
                            expression { params.all_mw == "yes" }
                            expression { params.mw2 == "yes" }
                        }
                    }                    
                    steps {
                        dir("${workspace}") {
                            sh script:"ansible-playbook ansible/image_build.yaml -e workspace=${workspace} -e CodeRepo=${params.codebase_tag} -e module=mw2 -e GITHUB_TOKEN=${env.GITHUB_ACCESS_TOKEN} -e env=${params.ENVIRONMENT}",label:"image build - mw2"
                        }
                    }
                }
                stage('Build mw3 Docker Image') {

                    when {
                        anyOf {
                            expression { params.all_mw == "yes" }
                            expression { params.mw3 == "yes" }
                        }
                    }                    
                    steps {
                        dir("${workspace}") {
                            sh script:"ansible-playbook ansible/image_build.yaml -e workspace=${workspace} -e CodeRepo=${params.codebase_tag} -e module=mw3 -e GITHUB_TOKEN=${env.GITHUB_ACCESS_TOKEN} -e env=${params.ENVIRONMENT}",label:"image build - mw3"
                        }
                    }
                }
            }   
        }

        stage('Helm Diff') {
            when {
                expression {
                    params.helm_changes == "yes"
                }
            }
            steps {
                dir("${params.codebase_tag}") {
                    sh script:"helmfile -e ${ENVIRONMENT} -f ${workspace}/helmfile/helmfile.yaml diff",label:"helmfile diff"
                }
            }
        }
        stage('Helm Upgrade') {
            when {
                expression {
                    params.helm_changes == "yes"
                }
            }
            steps {
                input 'Do you want to proceed?'
                dir("${params.codebase_tag}") {
                    script {
                        GIT_COMMIT_HASH = sh (
                        script: 'git log --format="%H" -n 1',
                        returnStdout: true
                        )
                    }
                    echo "${GIT_COMMIT_HASH}"
                    // sh "aws eks update-kubeconfig --region ap-southeast-1 --name ${params.ENVIRONMENT}-${env.PROJECT}-eks-cluster"
                    sh script:"helmfile -e ${ENVIRONMENT} -f ${workspace}/helmfile/helmfile.yaml apply",label:"helmfile apply"
                    // sh script:"kubectl annotate deployments --all kubernetes.io/change-cause=${GIT_COMMIT_HASH} -n ${PROJECT}",label:"change cause annotation"
                    // sh script:"kubectl rollout restart deployments -n ${PROJECT}",label:"rollout restart"
                }
            }
        }
        stage('Rolling Restart') {
            matrix {
                axes {
                    axis {
                        name 'MODULES'
                        values "all_mw", "mw1", "mw2", "mw3"
                    }
                }
                stages {
                    stage('Restart each modules deployment') {
                        when { expression { params["${MODULES}"] == "yes" && params.ENVIRONMENT == "uat" } }
                        steps {
                            dir("${workspace}") {
                                script {
                                    if ("${MODULES}" == "all_mw") {
                                        MODULES = ''
                                    }
                                }
                                sh script:"kubectl rollout restart deployments ${MODULES} -n ${PROJECT}",label:"rollout restart"
                            }
                        }
                    }
                }
            }
        }        
    }
}             