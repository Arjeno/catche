# Catche [![Build Status](https://secure.travis-ci.org/Arjeno/catche.png?branch=master)](http://travis-ci.org/Arjeno/catche)

Catche is a caching library for Ruby on Rails. It automates automated resource and collection caching/expiration. It basically tags cached outputs and expires those tags based on configuration.

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

For advanced usage such as advanced caching you need to configure this in the model.

```ruby
class Task < ActiveRecord::Base
  catche :through => :project
end
```

```ruby
class TasksController < ApplicationController
  catche Task, :index, :show
end
```

On resource `update` and `destroy` this will expire:

* Resource: `tasks_1`
* Collection: `tasks`
* Collection: `projects_1_tasks_1`

On resource `create` this will expire:

* Collection: `tasks`
* Collection: `projects_1_tasks_1`

You can use as many associations as you would like;

```ruby
class Task < ActiveRecord::Base
  catche :through => [:user, :project]
end
```

### Advanced configuration

```ruby
class TasksController < ApplicationController
  catche(
    Task,                       # Configured cached model
    :index, :show,              # Actions
    {
      :resource_name => :task,  # Name of your resource, defaults to your model name
    }
  )
end
```

```ruby
class Task < ActiveRecord::Base
  catche(
    :through        => [:user, :project], # Associations
    :tag_identifier => :id,               # Unique identifier for the resource
    :class          => Task,              # Class to use as tag scope
    :collection_tag => 'tasks',           # Name of the tag scope for this model,
  )
end
```

## License

This project is released under the MIT license.