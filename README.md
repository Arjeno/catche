# Catche [![Build Status](https://secure.travis-ci.org/Arjeno/catche.png?branch=master)](http://travis-ci.org/Arjeno/catche)

Catche is a caching library for Ruby on Rails. It automates resource and collection caching/expiration. It basically tags cached outputs and expires those tags based on configuration.

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

This will result in the following expirations:

```ruby
@project.update_attributes({ :title => 'Update!' }) # or @project.destroy

# => Expires /projects
# => Expires: /projects/1
```

```ruby
@project.create

# => Expires /projects
```

### Associative caching

Catche supports associative (nested) caching.

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

This will result in the following expirations:

```ruby
@task.update_attributes({ :title => 'Update!' }) # or @task.destroy

# => Expires /tasks
# => Expires: /projects/1/tasks
# => Expires: /projects/1/tasks/1
```

```ruby
@project.tasks.create

# => Expires /tasks
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

# => Expires /tasks
# => Expires: /projects/1/tasks
# => Expires: /projects/1/tasks/1
# => Expires: /users/1/tasks
# => Expires: /users/1/tasks/1
```

```ruby
@project.tasks.create

# => Expires /tasks
# => Expires: /projects/1/tasks
# => Expires: /users/1/tasks
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