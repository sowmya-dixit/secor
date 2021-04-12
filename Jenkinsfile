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
                checkout scm
                commit_hash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                artifact_version = sh(script: "echo " + params.github_release_tag.split('/')[-1] + "_" + commit_hash + "_" + env.BUILD_NUMBER, returnStdout: true).trim()
                echo "artifact_version: "+ artifact_version
            }
        }

            stage('Build') {
                sh 'mvn clean install'
            }

            stage('Package') {
                sh "/opt/apache-maven-3.6.3/bin/mvn3.6 package -Pbuild-docker-image -Drelease-version=${build_tag}"
            }

            stage('Retagging'){
                sh """
                    docker tag secor:${build_tag} ${hub_org}/secor:${build_tag}
                    echo {\\"image_name\\" : \\"secor\\", \\"image_tag\\" : \\"${build_tag}\\", \\"node_name\\" : \\"${env.NODE_NAME}\\"} > metadata.json
                """
            }

            stage('Archive artifacts'){
                archiveArtifacts "metadata.json"
                currentBuild.description = "${build_tag}"
            }
        }

    catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }

}
