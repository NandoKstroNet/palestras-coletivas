module ApplicationHelper
  def gravatar_image(email, alt, size = "80x80")
    url = Gravatar.url(email)
    image_tag url, :alt => alt, :class => "img-rounded", :size => size
  end
end
