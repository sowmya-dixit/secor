#!groovy

node('build-slave') {

   currentBuild.result = "SUCCESS"

   try {
      cleanWs()
      stage('Checkout'){         
         checkout scm
       }

      stage('Build'){
        env.NODE_ENV = "build"
        print "Environment will be : ${env.NODE_ENV}"
        sh('sudo mvn clean install -DskipTests=true')
         archive includes: "target/secor-0.24-SNAPSHOT-bin.tar.gz"
      }
      }
    catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }

}
