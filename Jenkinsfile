node('build-slave') {
    try {
        String ANSI_GREEN = "\u001B[32m"
        String ANSI_NORMAL = "\u001B[0m"
        String ANSI_BOLD = "\u001B[1m"
        String ANSI_RED = "\u001B[31m"
        String ANSI_YELLOW = "\u001B[33m"

        ansiColor('xterm') {
            stage('Checkout') {
                cleanWs()
                if(params.tag == ""){
                    checkout scm
                    commit_hash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    branch_name = sh(script: 'git name-rev --name-only HEAD | rev | cut -d "/" -f1| rev', returnStdout: true).trim()
                    artifact_version = branch_name + "_" + commit_hash
                }
                else {
                    def scmVars = checkout scm
                    checkout scm: [$class: 'GitSCM', branches: [[name: "refs/tags/$params.tag"]],  userRemoteConfigs: [[url: scmVars.GIT_URL]]]
                    artifact_version = params.tag
                }
                echo "artifact_version: "+ artifact_version
            }
        }

            stage('Build') {
                sh 'mvn clean install'
            }


            stage('Archive artifacts'){
                sh """
                        mkdir secor_artifacts
                        cp target/secor-*.tar.gz secor_artifacts
                        zip -j secor_artifacts.zip:${artifact_version} secor_artifacts/*
                    """
                archiveArtifacts artifacts: "secor_artifacts.zip:${artifact_version}", fingerprint: true, onlyIfSuccessful: true
                sh """echo {\\"artifact_name\\" : \\"secor_artifacts.zip\\", \\"artifact_version\\" : \\"${artifact_version}\\", \\"node_name\\" : \\"${env.NODE_NAME}\\"} > metadata.json"""
                archiveArtifacts artifacts: 'metadata.json', onlyIfSuccessful: true
            }
        }

    catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }

}
