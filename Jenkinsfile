pipeline {
  agent any

  parameters {
    choice(name: 'aws_region',            choices: 'EU-WEST-1\nUS-EAST-1', description: 'The name of the AWS region')
    choice(name: 'ec2_instance_type',     choices: 'T2.MICRO\nM3.MEDIUM',  description: 'The EC2 instance type')
    string(name: 'ec2_key_name',          defaultValue: '',                description: 'The name of your EC2 key pair')
    string(name: 'meta_name',             defaultValue: '',                description: 'A name describing the deployment')
    string(name: 'meta_owner_name',       defaultValue: '',                description: 'Your name')
    string(name: 'meta_owner_email',      defaultValue: '',                description: 'Your email address')
    string(name: 'meta_owner_department', defaultValue: 'Development',     description: 'Your department')
  }

  environment {
    AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    AWS_REGION            = "${params.aws_region}"
  }

  stages {
    stage('Init') {
      steps {
        echo 'Initialize project.'
        sh 'make init'
      }
    }
    stage('Test') {
      environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-testing-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-testing-secret-access-key')
      }
      steps {
        echo 'Run infrastructure (integration) tests.'
        sh 'true'
      }
    }
    stage('Plan') {
      steps {
        echo 'Create terraform.tfvars.json.'

        script {
          def json = readJSON text: '{}'
          json.ec2_instance_type = params.ec2_instance_type.toString()
          json.ec2_key_name = params.ec2_key_name.toString()
          json.meta_namespace = "${env.JOB_NAME}-${params.meta_owner_email}".toString()
          json.meta_name = params.meta_name.toString()
          json.meta_owner_name = params.meta_owner_name.toString()
          json.meta_owner_email = params.meta_owner_email.toString()
          json.meta_owner_department = params.meta_owner_department.toString()
          writeJSON file: 'terraform.tfvars.json', json: json
        }

        stash includes: 'terraform.tfvars.json', name: 'terraform-vars'
        archiveArtifacts artifacts: 'terraform.tfvars.json'

        echo 'Plan infrastructure.'
        sh "make plan NAMESPACE='${env.JOB_NAME}-${params.meta_owner_email}'"

        stash includes: 'tfplan', name: 'terraform-plan'
        archiveArtifacts artifacts: 'tfplan'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploy infrastructure.'
        unstash name: 'terraform-plan'
        unstash name: 'terraform-vars'

        sh "make deploy NAMESPACE='${env.JOB_NAME}-${params.meta_owner_email}'"
      }
    }
    stage('Smoke-Test') {
      steps {
        echo 'Run infrastructure (smoke) tests.'
        sh 'make smoke-test'
      }
    }
    stage('Describe') {
      steps {
        echo 'Describe infrastructure.'
        sh "make describe NAMESPACE='${env.JOB_NAME}-${params.meta_owner_email}'"
        archiveArtifacts artifacts: 'outputs.json'
      }
    }
  }

  post {
    success {
      mail to: "${params.meta_owner_email}", subject: "Your infrastructure job '${env.JOB_NAME}' is ready :-)", body: "Check the console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"
    }
    failure {
      mail to: "${params.meta_owner_email}", subject: "Your infrastructure job '${env.JOB_NAME}' has failed :-('${env.JOB_NAME}'", body: "Check the console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"
    }
  }
}
