# Invite new users to slack

Allows you to invite new users. 

E.g signup a bunch of users from a csv file:
```ruby
require './slack_signup'
require 'csv'

s = SlackSignup.new("your slack oauth token","https://<your-team-name>.slack.com")

users = CSV.parse(File.open('users.csv',))

users.each do |user|
  s.invite(user)
end
```

For security reasons a properly scoped oAuth token should be requested.
However, Slack offer a development token which works for testing:
https://api.slack.com/docs/oauth-test-tokens
  