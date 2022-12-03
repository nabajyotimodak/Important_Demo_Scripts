pipeline {
agent none {
    stages {
    agent docker {
        stage('1st stage') {
        steps(print naba) {
                echo 'NABAJYOTI'
            }
        }
    }
    }
}
}
