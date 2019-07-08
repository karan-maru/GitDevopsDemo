#!/usr/bin/env bash
curl -X POST -H 'Content-type: application/json' --data '{
  "app_name": "GitDevopsDemo",
  "branch": "master",
  "build_status": "Succeeded",
  "build_link": "https://appcenter.ms/users/karan_maru/apps/GitDevopsDemo/build/branches/master/builds/{build_id}",
  "build_reason": "push",
  "finish_time": "2018-06-14T23:59:05.2542221Z",
  "notification_settings_link": "https://appcenter.ms/users/{user-id}/apps/{app-name}/settings/notifications",
  "os": "Android"
}'
https://hooks.slack.com/services/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