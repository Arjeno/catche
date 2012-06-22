class CachesPage::TasksController < TasksController

  catches_page Task, :index, :show

end
