module TasksHelper
  def task_length(task)
    pluralize(number_with_precision(task.length,
                                    strip_insignificant_zeros: true),
              task.time_units[0..-2])
  end
end
