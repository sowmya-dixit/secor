node('build-slave') {
    try {
        ansiColor('xterm') {
            stage('Checkout') {
                cleanWs()
                checkout scm
            }
            
            stage('Build Assets'){
               sh "mvn clean install"
           }
            
            stage('Archive artifacts'){
                commit_hash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                branch_name = sh(script: 'git name-rev --name-only HEAD | rev | cut -d "/" -f1| rev', returnStdout: true).trim()
                artifact_version = branch_name + "_" + commit_hash
                sh """
                        mkdir secor_artifacts
                        cp target/secor-0.24-SNAPSHOT-bin.tar.gz secor_artifacts
                        zip -r secor_artifacts.zip:${artifact_version} secor_artifacts
                        rm -rf secor_artifacts
                    """
                archiveArtifacts artifacts: "secor_artifacts.zip:${artifact_version}", fingerprint: true, onlyIfSuccessful: true
                sh """echo {\\"artifact_name\\" : \\"secor_artifacts.zip\\", \\"artifact_version\\" : \\"${artifact_version}\\", \\"node_name\\" : \\"${env.NODE_NAME}\\"} > metadata.json"""
                archiveArtifacts artifacts: 'metadata.json', onlyIfSuccessful: true
                sh "rm secor_artifacts.zip:${artifact_version}"
            }
        }
    }

    catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }

}
