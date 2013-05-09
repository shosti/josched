class TasksController < EventsController
  def new
    @event = Task.new
  end

  def create
    @event = current_user.tasks.build(params[:task])
    if @event.save
      flash[:success] = "Task scheduled"
      redirect_to [current_user, @event]
    else
      render 'new'
    end
  end

  def update
    @event = current_user.tasks.find(params[:id])
    if @event.update_attributes(params[:task])
      flash[:success] = "Task updated"
      redirect_to [current_user, @event]
    end
  end
end
