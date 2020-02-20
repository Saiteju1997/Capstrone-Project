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
    stage("sonar scanner execution"){
        def scannerHome = tool 'Sonar-3.2';
        withSonarQubeEnv('Sonar') {
          sh """${scannerHome}/bin/sonar-scanner -D sonar.login=admin -D sonar.password=admin"""
        }
    }    
    stage("deploying artifacts"){
        def server = Artifactory.server 'jfrog'
        def rtMaven = Artifactory.newMavenBuild()
        rtMaven.resolver server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
        rtMaven.deployer server: server, releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local'
        rtMaven.tool = 'Maven2'
        def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'clean install'
    }
    stage("copying required files"){
        sh "scp -o StrictHostKeyChecking=no target/*.war root@docker-master:/inet/projects"
        sh "scp -o StrictHostKeyChecking=no Dockerfile root@docker-master:/inet/projects"
        sh "scp -o StrictHostKeyChecking=no kubernetes-deployment.yml root@k8smaster:/inet/projects"
   }
 }  
node('Docker-master'){
    stage("Building the Docker image"){ 
        sh 'docker build -t qdrs.app.v1.$BUILD_ID /inet/projects'
        sh 'docker tag qdrs.app.v1.$BUILD_ID steju480/qdrs.app.v1.$BUILD_ID'
        sh 'docker tag qdrs.app.v1.$BUILD_ID steju480/qdrs.app.v1'
    }
    stage("Docker image push"){
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'password', usernameVariable: 'user')]) {
            sh "docker login -u ${user} -p ${password}"
            sh 'docker login -u steju480 -p Steju@1997'
            sh 'docker push steju480/qdrs.app.v1.$BUILD_ID'
            sh 'docker push steju480/qdrs.app.v1'
            sh 'docker rmi steju480/qdrs.app.v1.$BUILD_ID'
            sh 'docker rmi steju480/qdrs.app.v1' 
            sh 'docker rmi qdrs.app.v1.$BUILD_ID'
          }                        
      }  
 }                             
 node('kubernetes'){
     stage("deploying the app"){     
        sh "kubectl delete -f /inet/projects/kubernetes-deployment.yml"
        sh "kubectl create -f /inet/projects/kubernetes-deployment.yml"
  }
}      
