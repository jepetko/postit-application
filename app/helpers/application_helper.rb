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

  def link_to_voteable(voteable, vote, html_options = nil, &block)
    if voteable.instance_of?(Post)
      link = vote_post_path(voteable, vote: vote)
    elsif voteable.instance_of?(Comment)
      link = vote_post_comment_path(voteable.post, voteable, vote: vote)
    end
    link_to link, html_options, &block
  end
end
