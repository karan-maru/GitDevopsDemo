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

# Update your ORG name and APP name
USR=karan_maru
APP=GitDevopsDemo
# This is to get the Build Details so we could pass it as part of the Email Body
build_url=https://appcenter.ms/users/$USR/apps/$APP/build/branches/$APPCENTER_BRANCH/builds/$APPCENTER_BUILD_ID
# Address to send email
TO_ADDRESS="karan.maru@plasticmobile.com"
# A sample Subject Titlegit rm -r --cached .
SUBJECT="AppCenter Build"
# Content of the Email on Build-Success.
SUCCESS_BODY="Success! Your build completed successfully!\n\n"
# Content of the Email on Build-Failure.
FAILURE_BODY="Sorry! Your AppCenter Build failed. Please review the logs and try again.\n\n"
#If Agent Job Build Status is successful, Send the email, if not send a failure email.
if [ "$AGENT_JOBSTATUS" == "Succeeded" ];
then
	echo "Build Success!"
	echo -e ${SUCCESS_BODY} ${build_url} | mail -s "${SUBJECT} - Success!" ${TO_ADDRESS}
	echo "success mail sent"
else
	echo "Build Failed!"
	echo -e ${FAILURE_BODY} ${build_url} | mail -s "${SUBJECT} - Failed!" ${TO_ADDRESS}
	echo "failure mail sent"
fi






# Send a slack notification specifying whether or
# not a build successfully completed.
#
# Contributed by: David Siegel
# https://github.com/quicktype/quicktype/

cd $APPCENTER_SOURCE_DIRECTORY

USR=karan_maru
APP=GitDevopsDemo

ICON=https://pbs.twimg.com/profile_images/881784177422725121/hXRP69QY_200x200.jpg

build_url=https://appcenter.ms/users/$ORG/apps/$APP/build/branches/$APPCENTER_BRANCH/builds/$APPCENTER_BUILD_ID
build_link="<$build_url|$APP $APPCENTER_BRANCH #$APPCENTER_BUILD_ID>"

version() {
    cat package.json | jq -r .version
}

slack_notify() {
    local message
    local "${@}"

    curl -X POST --data-urlencode \
        "payload={
            \"channel\": \"#devops_testing\",
            \"username\": \"App Center\",
            \"text\": \"$message\",
            \"icon_url\": \"$ICON\" \
        }" \
        $SLACK_WEBHOOK
}

slack_notify_build_passed() {
    slack_notify message="✓ $build_link built"
}

slack_notify_build_failed() {
    slack_notify message="💥 $build_link build failed"
}

slack_notify_deployed() {
    slack_notify message="✓ <$build_url|$APP v`version`> released to npm"
}

slack_notify_homebrew_bump() {
    slack_notify message="✓ <https://github.com/karan-maru/GitDevopsDemo/pull|$APP v`version`> bump PR sent to GitDevopsDemo"
}

if [ "$AGENT_JOBSTATUS" != "Succeeded" ]; then
    slack_notify_build_failed
    exit 0
fi