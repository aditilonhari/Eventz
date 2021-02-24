module EventsHelper

  def main_image(event)
    if event.main_image.attached?
      image_tag event.main_image.variant(resize_to_limit: [75,75])
    else
      image_tag "placeholder"
    end
  end

  def price(event)
    if event.free?
      "Free"
    else
      number_to_currency(event.price, precision: 0)
    end
  end

  def day_and_time(event)
    event.starts_at.strftime('%B %d at %I:%M %P')
  end
  
end
