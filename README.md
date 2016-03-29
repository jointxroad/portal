Community Portal.
================

Source files that power [X-Road community portal](http://jointxroad.github.io/portal).
Uses [Middleman](https://github.com/middleman/middleman)-powered static page generator.

## How to run the site locally

Make sure you have Ruby 1.9.3+ and Bundler installed, then clone this repo and run `bundle install`.
Then run `bundle exec middleman server` to start the server at `http://localhost:4567`

## How to deploy to gh-pages

Middleman is configured with deploy module. Execute `bundle exec rake publish REMOTE_NAME=pages ALLOW_DIRTY=true BRANCH_NAME=master` to generate
/push site to gh-pages.


## Questions

If you have questions, answers can be found on our [community forum](http://jointxroad.slack.com/). Join Slack community from [joinxroadcommunity.herokuapp.com](joinxroadcommunity.herokuapp.com).

## Contributing

Yes please.
The guides are written in [Markdown](http://daringfireball.net/projects/markdown/).
Use pull-request/issues.
