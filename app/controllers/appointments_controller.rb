class AppointmentsController < EventsController
  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = current_user.appointments.build(params[:appointment])
    if @appointment.save
      flash[:success] = "Appointment scheduled"
      redirect_to [current_user, @appointment]
    else
      render 'new'
    end
  end

  def edit
    @appointment = current_user.appointments.find(params[:id])
  end

  def update
    @appointment = current_user.appointments.find(params[:id])
    if @appointment.update_attributes(params[:appointment])
      flash[:success] = "Appointment updated"
      redirect_to [current_user, @appointment]
    end
  end

  def destroy
    current_user.appointments.find(params[:id]).destroy
    flash[:success] = "Appointment deleted"
    redirect_to root_url
  end

end
