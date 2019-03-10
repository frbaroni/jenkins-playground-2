def spec = [
  project: 'My Project A',
  build_cmd: 'node --version',
  test_cmd: 'node --version',
  builder: 'node:8-alpine',
  builder_args: '-v builder_cache:/var/cache',
  port: 8081,
  environments: [
    dev: '-e ENV=DEV',
    qa: '-e ENV=QA',
    uat: '-e ENV=UAT',
    prod: '-e ENV=PROD'
  ],
]

def version_file = new File("/build_data/$spec.project")
env.BUILD_ID = version_file.text.toInteger() + 1
version_file.write(env.BUILD_ID.toString())
version_file = null
currentBuild.displayName = "#" + env.BUILD_ID

pipeline {
    agent {
        docker { image 'node:7-alpine' }
    }
    stages {
        stage('Build') {
            steps {
                sh spec.build_cmd
            }
        }
        stage('Test') {
            steps {
                sh spec.test_cmd
            }
        }
    }
}

while(true) {
    def deployTo = ""
    stage("Deploy?") {
        deployTo = input(message: 'Target', parameters: [choice(choices: (spec.environments.keySet() as List), description: '', name: '')])
    }

    stage("Deployed to [$deployTo]") {
        node("deploy-$deployTo") {
            echo "$deployTo DEPLOYED"
        }
    }
}

