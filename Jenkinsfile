def spec = [
  project: 'My Project A',
  build_cmd: 'node --version',
  test_cmd: 'node --version',
]

def version_file = new File("/build_data/$spec.project")
env.BUILD_ID = version_file.text.toInteger() + 1
version_file.text = env.BUILD_ID.toString()
version_file.close()
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
