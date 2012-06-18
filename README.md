# Catche [![Build Status](https://secure.travis-ci.org/Arjeno/catche.png?branch=master)](http://travis-ci.org/Arjeno/catche)

Catche is a caching library for easy and automated resource and collection caching. It basically tags cached outputs and expires them based on configuration.

## Installation

Add this to your Gemfile and run `bundle`.
```
gem "catche"
```

## Controller caching

Controller caching is based on `caches_action` using the method `catche`.

### Simple caching

```ruby
class ProjectsController < ApplicationController
  catche Project, :index, :show
end
```

### Associative caching

```ruby
class TasksController < ApplicationController
  catche Task, :index, :show, :through => :project
end
```

On resource change this will expire:

* Resource task
* Resource task within specific project

On resource or collection change this will expire:

* Collection tasks
* Collection tasks within specific project

## License

This project is released under the MIT license.