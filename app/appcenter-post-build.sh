#!/usr/bin/env bash
# Send a build notification over Email on Success/Failure of AppCenter Builds.
#
# Ensure you exclude the Sender Email Address from your Mail Spam Filters,
# or it will go to the Junk/Spam Folder.
# The 'from' email looks like this, vsts <vsts@Mac-n.local> where n could be {1,2,3...}
# Create Rules/Filters to route to Inbox based on Subject/Sender.
#
# Modify the ORG, APP, TO_ADDRESS, SUBJECT, SUCCESS_BODY, FAILURE_BODY as required.
#
# Add it as a Post-Build Script (appcenter-post-build.sh)
# Configure your AppCenter build(s) to ensure the Build Script is picked.
#
# Uses UNIX LF EOL format.
#

## Update your ORG name and APP name
#USR=karan_maru
#APP=GitDevopsDemo
## This is to get the Build Details so we could pass it as part of the Email Body
#build_url=https://appcenter.ms/users/$USR/apps/$APP/build/branches/$APPCENTER_BRANCH/builds/$APPCENTER_BUILD_ID
## Address to send email
#TO_ADDRESS="karan.maru@plasticmobile.com"
## A sample Subject Titlegit rm -r --cached .
#SUBJECT="AppCenter Build"
## Content of the Email on Build-Success.
#SUCCESS_BODY="Success! Your build completed successfully!\n\n"
## Content of the Email on Build-Failure.
#FAILURE_BODY="Sorry! Your AppCenter Build failed. Please review the logs and try again.\n\n"
##If Agent Job Build Status is successful, Send the email, if not send a failure email.
#if [ "$AGENT_JOBSTATUS" == "Succeeded" ];
#then
#	echo "Build Success!"
#	echo -e ${SUCCESS_BODY} ${build_url} | mail -s "${SUBJECT} - Success!" ${TO_ADDRESS}
#	echo "success mail sent"
#else
#	echo "Build Failed!"
#	echo -e ${FAILURE_BODY} ${build_url} | mail -s "${SUBJECT} - Failed!" ${TO_ADDRESS}
#	echo "failure mail sent"
#fi

# Post Build Script

set -e # Exit immediately if a command exits with a non-zero status (failure)

echo "***********"
echo "Post Build Script"
echo "***********"


# Run Android APPDebug & APPTest
$APPCENTER_SOURCE_DIRECTORY/gradlew assembleDebug
$APPCENTER_SOURCE_DIRECTORY/gradlew assembleAndroidTest
$APPCENTER_SOURCE_DIRECTORY/gradlew assembleRelease

# variables
appCenterLoginApiToken=$APPCENTER_ACCESS_TOKEN
locale="en_US"
appName="GitDevopsDemo"
deviceName="9c7fd2fc"
testSeriesName="launch-tests"
appDebugPath=$APPCENTER_SOURCE_DIRECTORY/app/build/outputs/apk/debug/app-debug.apk
appReleasePath=$APPCENTER_SOURCE_DIRECTORY/app/build/outputs/apk/release/app-release.apk
buildDir=$APPCENTER_SOURCE_DIRECTORY/app/build/outputs/apk/androidTest/debug

# Run UITest if branch is master
if [ "$APPCENTER_BRANCH" == "master" ];
then
    # app center command espresso test

echo "########## $appName espresso start ##########"
#    appcenter login
    appcenter test run espresso --app $appName --devices $deviceName --app-path $appDebugPath --test-series $testSeriesName --locale $locale --build-dir $buildDir --token $appCenterLoginApiToken;
    echo "########## $appName espresso finished ##########"
else

echo "Current branch is not 'master'"
fi



# Send a slack notification specifying whether or
# not a build successfully completed.

curl -X POST -H 'Content-type: application/json' --data '{"text":"The app has been built with AppCenter!"}' https://hooks.slack.com/services/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

