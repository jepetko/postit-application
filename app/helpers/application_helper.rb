module ApplicationHelper

  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end

  def fix_date(dat)
    return 'unknown' if dat.nil?
    dat.strftime('%d.%m.%Y')
  end

  def active_for(obj, tab)
    if obj == :posts && tab.nil?
      'active'
    elsif obj == :comments && tab == 'comments'
      'active'
    end
  end
end
