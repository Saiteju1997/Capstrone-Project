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
    stage("using publish over ssh"){
        sshPublisher(publishers: [sshPublisherDesc(configName: 'Docker-master', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '//inet//projects', remoteDirectorySDF: false, removePrefix: 'target', sourceFiles: 'target/*.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])      
   }
 }  
node('Docker-master'){
    stage("git clone"){
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITHUB', url: 'https://github.com/Saiteju1997/Capstrone-Project.git']]])
    }
    stage("Building the Docker image"){
        sh 'cp -pr /inet/workspace/practice3/Dockerfile /inet/projects'
        sh 'docker build -t qdrs.app.v1.$BUILD_ID /inet/projects'
        sh 'docker tag qdrs.app.v1.$BUILD_ID steju480/qdrs.app.v1.$BUILD_ID'
        sh 'docker tag qdrs.app.v1.$BUILD_ID steju480/qdrs.app.v1'
    }
    stage("Docker image push"){
        withCredentials([string(credentialsId: 'DockerHub-passwd', variable: '')]) {
            sh 'docker login -u steju480 -p ${DockerHub-passwd}'
            sh 'docker push steju480/QDRS.app.V1.$BUILD_ID'
            sh 'docker push steju480/QDRS.app.V1'
            sh 'docker rmi steju480/QDRS.app.V1.$BUILD_ID'
            sh 'docker rmi steju480/QDRS.app.V1' 
            sh 'docker rmi qdrs.app.v1.$BUILD_ID'
          }                        
      }  
 }                             
        
