module ApplicationHelper

  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end

  def fix_date(dat)
    dat = dat.in_time_zone(current_user.time_zone) if logged_in? && !current_user.time_zone.blank?
    dat.strftime('%d.%m.%Y %l:%M%P %Z')
  end

  def active_for(obj, tab)
    if obj == :posts && tab.nil?
      'active'
    elsif obj == :comments && tab == 'comments'
      'active'
    end
  end

  def link_to_voteable(voteable, vote, html_options = nil, &block)
    return '' unless logged_in?
    if voteable.instance_of?(Post)
      link = vote ? upvote_post_path(voteable) : downvote_post_path(voteable)
    elsif voteable.instance_of?(Comment)
      link = vote ? upvote_post_comment_path(voteable.post, voteable) : downvote_post_comment_path(voteable.post, voteable)
    end
    link_to link, html_options, &block
  end
end
