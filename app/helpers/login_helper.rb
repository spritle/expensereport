module LoginHelper  
  def display_date(input_date)
    return input_date.strftime("%d %B %Y")
  end
end
