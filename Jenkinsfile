def build_steps = { ->
    sh 'rm -R ./build || true'
    sh 'mkdir ./build'
    sh 'cp ./Dockerfile.example ./build/Dockerfile'
  }

def test_steps = { ->
    sh 'node --version'
    sh 'npm --version'
  }

def spec = [
  project: 'my-project-a',
  service: 'myservicename',
  build: build_steps,
  test: test_steps,
  builder: 'node:8-alpine',
  builder_args: '-v builder_cache:/var/cache',
  publish_path: 'build',
  environments: [
    dev: [
      docker_args: '-e ENV=DEV',
      app_args: '',
    ],
    qa: [
      docker_args: '-e ENV=QA',
      app_args: '',
    ],
    uat: [
      docker_args: '-e ENV=UAT',
      app_args: '',
    ],
    prod: [
      docker_args: '-e ENV=PROD',
      app_args: '',
    ],
  ],
]

def runPipelineSpec(spec) {
  nextVersion(spec)
  def builder = docker.image(spec.builder);
  def image = "${spec.project}-${spec.service}-${env.BUILD_ID}"

  stage('Test') {
    builder.inside(spec.builder_args) {
      spec.test()
    }
  }

  stage('Build') {
    builder.inside(spec.builder_args) {
      spec.build()
    }
  }

  stage('Publish') {
    dir(spec.publish_path) {
      echo "Publishing..."
      sh "echo docker build -t ${image} ."
    }
  }

  while(true) {
    stage("Deploy") {
      def deployTo = input(message: 'Target', parameters: [choice(choices: (spec.environments.keySet() as List), description: '', name: '')])
      node("deploy-$deployTo") {
        echo "Deploying to $deployTo"
        def network = "${spec.project}-${deployTo}"
        def name = "${network}-${spec.service}"
        def environ = spec.environments[deployTo];
        def docker_args = environ.docker_args;
        def app_args = environ.app_args;
        sh "echo docker run --network ${network} --name ${name} ${docker_args} ${image} ${app_args}"
      }
    }
  }
}

def nextVersion(spec) {
  def version_file = new File("/build_data/$spec.project")
    env.BUILD_ID = version_file.text.toInteger() + 1
    version_file.write(env.BUILD_ID.toString())
    version_file = null
    currentBuild.displayName = "#" + env.BUILD_ID
}

runPipelineSpec(spec);
