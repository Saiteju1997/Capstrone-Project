node('Slave1'){
    stage("git clone"){
       checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITHUB', url: 'https://github.com/Saiteju1997/Capstrone-Project.git']]])
      }
    stage('SonarQube analysis') {
        def scannerHome = tool 'Sonar-3.2';
        def mavenhome = tool  name: 'Maven2' , type: 'maven';
        withSonarQubeEnv('Sonar') {
        sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.3.0.603:sonar'
    }
  }
}
node{
    stage("git clone"){
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITHUB', url: 'https://github.com/Saiteju1997/Capstrone-Project.git']]])
    }
    stage("deploying artifacts"){
        def server = Artifactory.server 'jfrog'
        def rtMaven = Artifactory.newMavenBuild()
        rtMaven.resolver server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
        rtMaven.deployer server: server, releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local'
        rtMaven.tool = 'Maven2'
        def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'clean install'
   }
 }
node('Docker-master'){
    stage("git clone"){
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITHUB', url: 'https://github.com/Saiteju1997/Capstrone-Project.git']]])
    }
    stage("copying Docker file and removig all the files"){
        sh 'cp -pr Dockerfile /inet/projects'
        sh 'rm -rf *'
    }
    stage("Building the Docker image"){
        sh 'docker build -t Steju480/qdrs.app.v1.$BUILD_ID /inet/projects/Dockerfile'
        sh 'docker tag Steju480/qdrs.app.v1.$BUILD_ID Steju480/qdrs.app.v1'
    }
    stage("Docker image push"){
        withCredentials([string(credentialsId: 'DockerHub-passwd', variable: 'DockerHub')]){
            sh 'docker login -u Steju480 -p $DockerHub'
            sh 'docker push Steju480/QDRS.app.V1.$BUILD_ID'
            sh 'docker push Steju480/QDRS.app.V1'
            sh 'docker rmi Steju480/QDRS.app.V1.$BUILD_ID'
            sh 'docker rmi Steju480/QDRS.app.V1' 
          }                        
      }  
 }                             
        
