# SalesKing Line Item Importer

A SalesKing app to import csv files to accomplish several goals. for example you might want to import tracked time from a third-party tracking tool or import orders from you eCommerce and so on.

You can choose from different import-scenarios:
* Create one draft document per row - you can choose the document type e.g. invoice, estimate, order within the App-UI
* Create one document and import all rows as line-items
* Add all rows as line-items to a existing draft-document - you can search and choose existing draft-documents within the App-UI

## Developer Info

The app is build with Rails 4 and Ruby 2+ and is working with MySQL or PostgreSQL.
It uses oAuth2 and has a canvas integration, so a user can use it without leaving 
his SalesKing-UI.

### Development Dependencies

Assets are managed via bower and the bower-rails gem. So you should have the 
following running:

* nodejs
* bower

Clone assets into /vendor/assets/bower_components

    rake bower:install

## Getting Started

1. Register a new app to get an app-id & secret in your SalesKing account. (salesking.eu/developer/apps)

    * Set a unique CANVAS SLUG so it can be reached inside salesking.eu/app/my-import
    * Set the Canvas URL to `http://MY-URL:Port/login` <- /login receives the auth POST when a user opens the app in sk/app/my-import

2. Checkout this repo, copy and edit `salesking_app.yml` & `database.yml`.

    bundle install
    bundle exec rake db:migrate
    bundle exec rails s

3. Go into SalesKing at `/app/your-canvas-slug`
    
4. SSL Restrictions in browsers will prevent iFrames to load (your local) http-site 
into the https-enabled SalesKing install. In Google Chrome look at the very 
right site of the url-input where an icon appears to allow such content.


## Run on Heroku

This app is deployed on Heroku and [you can do it too](http://devcenter.heroku.com/articles/rails31_heroku_cedar). The only problem to be
solved is the creation of the salesking_app.yml keeping the app
key & secret.
Instead of using [Heroku's env_vars](http://devcenter.heroku.com/articles/config-vars) you should use a separate
local git branch where you add the ignored `salesking_app.yml` file:

    # create a new branch
    git checkout production
    # [create salesking_app.yml, remove from .gitignore and commit]
    git merge master
    git push heroku production:master
    # change back to master branch for normal edits .. DO NOT merge production into master
    git checkout master

DON'T FORGET: never push production to your public branch, if you do you need to setup NEW app credentials

## Translating line-item-importer

- Edit the translations directly on the [salesking/line-item-importer](http://www.localeapp.com/projects/6762) project on Locale.
- **That's it!**
- The maintainer will then pull translations from the Locale project and push to Github.

If you need to pull/push locales:

  localeapp install --standalone <API Key>
  
And than edit the config file in .localeapp/config.rb


Happy translating!

## Test

Run specs with

    bundle exec rake spec

Test coverage report is created by simpleCov and available after running the
specs


Copyright (c) 2014 Georg Leciejewski, released under the MIT license
