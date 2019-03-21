def spec = [
  project: 'My Project A',
  build: { ->
    sh 'node --version'
  },
  test: 'node --version',
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

def runPipeline(spec) {
  nextVersion()

  pipeline {
      agent {
          docker { image 'node:7-alpine' }
      }
      stages {
          stage('Build') {
              steps {
                  sh spec.build
              }
          }
          stage('Test') {
              steps {
                  sh spec.test
              }
          }
      }
  }

  while(true) {
      stage("Deploy?") {
          def deployTo = input(message: 'Target', parameters: [choice(choices: (spec.environments.keySet() as List), description: '', name: '')])
          node("deploy-$deployTo") {
              echo "$deployTo DEPLOYED"
          }
      }
  }

  def nextVersion() {
    def version_file = new File("/build_data/$spec.project")
    env.BUILD_ID = version_file.text.toInteger() + 1
    version_file.write(env.BUILD_ID.toString())
    version_file = null
    currentBuild.displayName = "#" + env.BUILD_ID
  }
}
runPipeline(spec);
