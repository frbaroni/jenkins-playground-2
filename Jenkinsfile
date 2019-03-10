def spec = [
  build_cmd: 'node --version',
  test_cmd: 'node --version',
]

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
