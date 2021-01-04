print "----------------------------------------------------"
print "                 JMeter Testing"
print "----------------------------------------------------"


node('master') {

				
	workspace = pwd()   // Set the main workspace in your Jenkins agent
	def appname = "app-loadtest-${env.BUILD_NUMBER+800}"

    try {
        stage ('pull code') {
            sh "oc new-app --search maven"
            //sh "ls"
            sh "rm -fR source"
            sh "rm -fR reports"
			sh "mkdir reports"
            sh "git clone https://github.com/FuzzyDays/openshift.git source"
            sh "ls source"
            //sh "cd source"
            //sh "ls"
        }
		stage ('manipulate code') {
			dir ("source"){
				//sh "git clone https://github.com/edwin/jmeter-loadtesting.git load"
				//sh "sed -i 's/COPY src \\/home\\/app\\/src/COPY source\\/src \\/home\\/app\\/src/' source/dockerfile"
				//sh "sed -i 's/COPY pom.xml \\/home\\/app/COPY source\\/pom.xml \\/home\\/app/' source/dockerfile"
				//sh "cat dockerfile"
			}
        }		
        stage ('deploy to ocp') {
			dir ("source"){
				sh "ls"
				sh "cat dockerfile"
				//sh "cat dockerfile | oc new-build --name ${appname} --dockerfile='-'"
				//sh "oc start-build bc/${appname} --follow"
				//sh "oc new-app ${appname} --name=${appname} --allow-missing-imagestream-tags"
				$ oc new-app --strategy=docker
				sleep(time:12,unit:"SECONDS")
			}
        }
        stage ('do load test') {
            dir ("source"){

				sleep(time:600,unit:"SECONDS")
				

            }
		}
		
        stage("get Pod name and Rsync Results") {
				dir ("reports"){
                 try {
					sh "oc get pods | grep Running | grep ${appname} | grep 1/1 | awk '{ print \$1 }' > pod "
            		pod = readFile('pod').trim()
                	echo pod   
					println pod
				
					// Get latest JMeter image from project to assign to job template
					//String imageURL = sh (
					//script:"""
					//oc get is/rhel-${appname} -n ${project} --output=jsonpath={.status.dockerImageRepository}
					//""",
					//returnStdout: true
					// Get reports directory from pod for HTML report dashboard
					sh """
					oc rsync ${pod}:/home/app/target/jmeter/reports/test01 ${workspace}/reports
					"""
				} catch(err){
					print "An exception occurred while parsing the JMeter reports: ${err}"
							}
            }
		}

    } catch (error) {
       throw error
    } finally {
        stage('housekeeping') {
            //sh "oc delete svc ${appname}"
		sh "oc delete pod ${pod} --grace-period=0 --force"		
            sh "oc delete bc ${appname}"
            sh "oc delete is ${appname}"
            //sh "oc delete dc ${appname}"
        }
    }
}
