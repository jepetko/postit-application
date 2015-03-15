module Sluggable

  extend ActiveSupport::Concern

  included do
    before_save :generate_slug
  end

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(get_slug_value)
    post = self.class.find_by slug: self.slug
    count = 2
    while post && post != self
      the_slug = append_postfix(the_slug, count)
      post = self.class.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug
  end

  def get_slug_value
    raise 'return self.title from this method if you are going to use title as slug'
  end

  def append_postfix(str, count)
    if str =~ /\-/
      pieces = str.split('-')
      if pieces.last.to_i != 0
        return pieces.slice(0...-1).join('-') + '-' + count.to_s
      end
    end
    str + '-' + count.to_s
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(%r{\s*[^0-9a-zA-Z]\s*}, '-')
    str.gsub!(%r{\-+$}, '-')
    str.gsub!(%r{(^\-|\-$)},'')
    str.downcase
    str
  end
end