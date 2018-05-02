pipeline {
  agent any

  parameters {
    choice(name: 'aws_region',            choices: 'EU-WEST-1\nUS-EAST-1', description: 'The name of the AWS region.')
    choice(name: 'ec2_instance_type',     choices: 'T2.MICRO\nM3.MEDIUM',  description: 'The type of the EC2 instance.')
    string(name: 'ec2_key_name',          defaultValue: '',                description: 'The name of your EC2 key pair.')
    string(name: 'meta_name',             defaultValue: '',                description: 'A name describing the deployment.')
    string(name: 'meta_owner_name',       defaultValue: '',                description: 'Your name.')
    string(name: 'meta_owner_email',      defaultValue: '',                description: 'Your email address.')
    string(name: 'meta_owner_department', defaultValue: 'Development',     description: 'Your department.')
  }

  stages {
    stage('Init') {
      steps {
        echo 'Initialize project.'
        sh 'make init'
        writeJSON file: 'terraform.tfvars.json', json: [
          "aws_profile":           "default",
          "aws_region":            "${params.aws_region}",
          "ec2_instance_type":     "${params.ec2_instance_type}",
          "ec2_key_name":          "${params.ec2_key_name}",
          "meta_name":             "${params.meta_name}",
          "meta_owner_name":       "${params.meta_owner_name}",
          "meta_owner_email":      "${params.meta_owner_email}",
          "meta_owner_department": "${params.meta_owner_department}"
        ]
      }
    }
    stage('Test') {
      steps {
        echo 'Run infrastructure (integration) tests.'
        sh 'make test'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploy infrastructure.'
        sh 'make deploy'
      }
    }
    stage('Smoke-Test') {
      steps {
        echo 'Run infrastructure (smoke) tests.'
        sh 'make smoke-test'
      }
    }
  }
}