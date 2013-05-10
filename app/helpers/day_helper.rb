module DayHelper
  def bottom_nav
    (link_to 'Previous day', day_path(@date - 1.day)) + ' | ' +
      (link_to 'Next day', day_path(@date + 1.day))
  end
end
