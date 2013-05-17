class AppointmentsController < EventsController
  def new
    @event = Appointment.new
  end

  def create
    @event = current_user.appointments.build(params[:appointment])
    if @event.save
      flash[:success] = 'Appointment scheduled'
      redirect_to day_path(@event.date)
    else
      render 'new'
    end
  end

  def index
    @type = 'Appointment'
    super
  end

  def update
    @event = current_user.appointments.find(params[:id])
    if @event.update_attributes(params[:appointment])
      flash[:success] = 'Appointment updated'
      redirect_to [current_user, @event]
    end
  end
end
