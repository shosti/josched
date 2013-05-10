class TasksController < EventsController
  def new
    @event = Task.new
  end

  def create
    @event = current_user.tasks.build(params[:task])
    if @event.save
      flash[:success] = "Task scheduled"
      redirect_to day_path(@event.date)
    else
      render 'new'
    end
  end

  def index
    @type = 'Task'
    super
  end

  def update
    @event = current_user.tasks.find(params[:id])
    if @event.update_attributes(params[:task])
      flash[:success] = "Task updated"
      redirect_to day_path(@event.date)
    end
  end
end
