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
        withSonarQubeEnv('Sonar') {
        sh '${mavenhome}/bin/mvn sonar:sonar -Dsonar.host.url=http://35.188.100.185:8000/'
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
