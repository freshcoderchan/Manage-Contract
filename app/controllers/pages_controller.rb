class PagesController < ApplicationController
  access all: { except: [:settings, :manage_jobseeker, :manage_recruiter] }, user: { except: [:settings, :manage_jobseeker, :manage_recruiter] }, superadmin: :all

  def index; end

  def alljobs
    if search_params.present?
      query = params[:q].presence || '*'
      @all_jobs = Job.search(query, Job.prepare_search(search_params))
      @filter_active = true
    else
      @all_jobs = Job.search('*', Job.prepare_search(search_params))
    end
    #binding.pry
  end

  def allcompanies
    if search_params.present?
      query = params[:q].presence || '*'
      @all_companies = Company.search(query, Company.prepare_search(search_params))
      @filter_active = true
    else
      @all_companies = Company.search('*', Company.prepare_search(search_params))
    end
  end

  def allresumes
    if search_params.present?
      query = params[:q].presence || '*'
      @all_resumes = Resume.search(query, Resume.prepare_search(search_params))
      @filter_active = true
    else
      @all_resumes = Resume.search('*', Resume.prepare_search(search_params))
    end
  end
# Add FAQs and Blogs
  def allfaqs
    @faqs = Faq.getActiveFaqs.order(created_at: :ASC).all()
    @role = user_signed_in? ? (current_user.interface.nil? ? 'admin' : 'user') : 'user'

    render :template => 'faqs/all', :locals => {:faqs => @faqs, :role => @role}
  end

  def allblogs
    @blogs = Blog.all()
    @role = user_signed_in? ? (current_user.interface.nil? ? 'admin' : 'user') : 'user'

    render :template => 'blogs/all', :locals => {:blogs => @blogs, :role => @role}
  end

  def find_resume; end

  def find_company; end

  def admin
    if !user_signed_in?
    else
      redirect_to root_path, notice: 'You already in the system'
    end
  end

  def settings
    @job_types = JobType.all
    @job_areas = JobArea.all
  end
# Show Jobseeker, Recruiter, Blog, FAQ for admin  
  def manage_jobseeker
    # @job_seekers = User.where(interface: 1).order(created_at: :DESC).all
    @job_seekers = User.job_seekers
    @type = 'JobSeeker'
  end

  def manage_recruiter
    # @recruiters = User.where(interface: 0).order(created_at: :DESC).all
    @recruiters = User.recruiters
    @type = 'Recruiter'
  end

# Add FAQ
  def add_faq
  end
  
  def alert
    @keywords = Keyword.set_by(current_user)
  end

  def subscribed_jobs
    @keywords = Keyword.set_by(current_user)
    if @keywords.blank?
      redirect_to(alert_path, alert: "Empty keywords! Go to Alert Job!") and return
    else
      @parameter = @keywords[0].title.downcase
      @results = Job.all.where("lower(title) LIKE :search", search: "%#{@parameter}%")
    end
  end

  def search_params
    params.permit(:q, :address, :sort_by, :page, experience: [], job_type: [], education: [], job_title: [], city: [], industry: [], reviews: [], title: [])
  end
end
