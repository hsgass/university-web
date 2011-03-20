class PublicController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed
  before_filter      :set_current_section

  layout 'static'

  # Find the list of alumni, which can be all of them,
  # filtered by year or by year and term name.
  def alumni
    if params[:term]
      redirect_to("/alumni") && return if !params[:year]

      @term = Term.per_year(params[:year]).where(:name => params[:term]).first
      @alumni = @term.alumni
    else
      @alumni = User.alumni
      @alumni = @alumni.per_year(params[:year]) if params[:year]
    end
  end

  def changelog
    @announcements = Announcement.where(:public => true).order("created_at DESC")

    respond_to do |format|
      format.html do
        @announcements = @announcements.paginate(:page => params[:page], :per_page => 10)
      end
      format.rss { render :layout => false }
    end
  end

  def announcement
    @announcement = Announcement.find_by_slug(params[:slug])

    if @announcement.nil? || !@announcement.public?
      render(:text => "This announcement doesn't exist")
      return
    end
  end

  def set_current_section
    @current = params[:action]
  end
end
