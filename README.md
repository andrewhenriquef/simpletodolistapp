# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


To Create a sortable list ->

Install jquery and jquery ui rails
[jquery-rails](https://github.com/rails/jquery-rails) and [jquery-ui-rails](https://github.com/jquery-ui-rails/jquery-ui-rails) gems 

access this link
[Html5sortable](https://github.com/lukasoppermann/html5sortable) > dist
and copy all content from the file html.sortable.js

Create a new file called html.sortable.js in your app/assets/Javascript

In your application.js set the requires like this

```JavaScript
//= require jquery3
//= require bootstrap-sprockets
//= require rails-ujs
//= require jquery-ui
//= require html.sortable
//= require turbolinks
//= require_tree .
```

In your index.html.erb

```erb
<div class="col-md-4 sortable">
  <% @activities.each do |activity| %>
    <div class="card" data-id="<%= activity.id %>">
      <p class="card-text"><%= activity.title %></p>
      <%= link_to 'edit', edit_activity_path(activity)%>
      <%= link_to 'delete' %>
    </div>
  <%end%>
</div>

```
In your coffeeScript file

```coffeescript
ready = undefined
set_positions = undefined

set_positions = -> 
  $('.card').each (i) ->
    $(this).attr 'data-pos', i + 1
    return
  return

ready = ->
  set_positions()
  $('.sortable').sortable()
  $('.sortable').sortable().bind 'sortupdate'
  return

$(document).ready ready
```

Now sortable works, your app can change  the positions of items 
But not savind the positions, if you reload the page, they will back to the positions that they were