# Catche [![Build Status](https://secure.travis-ci.org/Arjeno/catche.png?branch=master)](http://travis-ci.org/Arjeno/catche)

Catche is a caching library for Ruby on Rails. It automates resource and collection caching/expiration. It basically tags cached outputs and expires those tags based on configuration.

## Installation

Add this to your Gemfile and run `bundle`.
```
gem "catche"
```

## Controller caching

Catche supports both action and page caching using the Rails methods `caches_action` and `caches_page`.

### Action caching

Catche's `catches_action` uses Rails' `caches_action` and therefore supports all options this method supports.

```ruby
class ProjectsController < ApplicationController
  catches_action Project, :index, :show
end
```

### Page caching

Catche's `catches_page` uses Rails' `caches_page` and therefore supports all options this method supports.

```ruby
class ProjectsController < ApplicationController
  catches_page Project, :index, :show
end
```

### Simple caching

```ruby
class ProjectsController < ApplicationController
  catches_action Project, :index, :show # or catches_page
end
```

This will result in the following expirations, depending on your routes configuration:

```ruby
@project.update_attributes({ :title => 'Update!' }) # or @project.destroy

# => Expires: /projects
# => Expires: /projects/1
```

```ruby
@project.create

# => Expires: /projects
```

### Associative caching

Catche supports associative caching.

```ruby
class Task < ActiveRecord::Base
  catche :through => :project
end
```

```ruby
class TasksController < ApplicationController
  catches_action Task, :index, :show # or catches_page
end
```

This will result in the following expirations:

```ruby
@task.update_attributes({ :title => 'Update!' }) # or @task.destroy

# => Expires: /tasks
# => Expires: /projects/1/tasks
# => Expires: /projects/1/tasks/1
```

```ruby
@project.tasks.create

# => Expires: /tasks
# => Expires: /projects/1/tasks
```

### Multiple associations

You can use as many associations as you would like. Associations are not nested.

```ruby
class Task < ActiveRecord::Base
  catche :through => [:user, :project]
end
```

This will result in the following expirations:

```ruby
@task.update_attributes({ :title => 'Update!' }) # or @task.destroy

# => Expires: /tasks
# => Expires: /projects/1/tasks
# => Expires: /projects/1/tasks/1
# => Expires: /users/1/tasks
# => Expires: /users/1/tasks/1
```

```ruby
@project.tasks.create

# => Expires: /tasks
# => Expires: /projects/1/tasks
# => Expires: /users/1/tasks
```

### Advanced configuration

```ruby
class TasksController < ApplicationController
  catche(
    Task,                         # Configured cached model
    :index, :show,                # Actions
    {
      :resource_name  => :task,   # Name of your resource, defaults to your model name
      :type           => :action, # Type of caching, :action or :page
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

## How does it work?

Catche intercepts a cached value and tags this value using the unique identifier for the given/loaded resource or collection. Once a resource expires it will expire the tagged cached values, such as the resource itself and the collection it belongs to.

```ruby
Catche::Tag::Collect.resource(@task) # { :set => ["tasks_1"], :expire => ["tasks_1"] }
Catche::Tag::Collect.collection_tags(@task, Task) # { :set => ["projects_1_tasks"], :expire => ["tasks", "projects_1_tasks"] }
```

The tags will point to different cached values, for example pointing to a cached key or a cached filepath.

## Manually expiring a cache

```ruby
@task.expire_resource!
@task.expire_collection!
@task.expire_resource_and_collection!
```

## Supported cache stores

Catche currently supports:

* MemoryStore
* Memcached
* Dalli

Want support for more? Just fork and open up a pull request.

## Roadmap

* View cache

## License

This project is released under the MIT license.