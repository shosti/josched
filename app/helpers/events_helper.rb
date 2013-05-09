module EventsHelper
  def delete_event_button(event)
    if appointment? event
      path = user_appointment_path(current_user, event)
    elsif task? event
      path = user_task_path(current_user, event)
    else
      raise TypeError
    end

    button_to("Delete #{event.type.downcase}",
              path,
              method: 'delete',
              class: 'btn btn-large btn-danger')
  end

  def an_event(event)
    if appointment? event
      "an appointment"
    elsif task? event
      "a task"
    else
      raise TypeError
    end
  end

  def appointment?(event)
    event.type == 'Appointment'
  end

  def task?(event)
    event.type == 'Task'
  end
end
