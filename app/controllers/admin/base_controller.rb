class Admin::BaseController < ApplicationController

  before_action :require_login
  #load_and_authorize_resource
  # => before_action :check_domain_and_env
  before_action :verify_staff_or_admin
  before_action :set_admin_meta_tags
  layout 'admin'

  # if current user don't have access, redirect them back to root page
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message + 'test'
  end

  

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end


  private

  def verify_staff_or_admin
    if current_user.role == :admin  
      # no prob, because you are admin.
      return
      redirect_to root_url, :alert => 'welcome ' + current_user.role.to_s + ' ' + current_user.email.to_s      
    else
      # cheking there is admin.
      @admin_user = User.where(:role => :admin).first
      if @admin_user.blank?
        # no admins yet.
        @user = User.where(:id => current_user.id.to_s).first
        #if @user.update(:role => :admin)
        #if @user.update_attribute(:role => :admin)
        @user.role = :admin
        if @user.save!
          # if there is no admin, you can get admin.
          redirect_to '/admin/', :notice => 'you are assigned as admin because there were no admins before. you are first admin!! ' and return
        else
          redirect_to root_url, :notice => 'not updated'
        end
      end
    end
    #uri = '/'
    #redirect_to uri and return
  end  

  def set_admin_meta_tags
    set_meta_tags :noindex => true
    set_meta_tags :nofollow => true
  end

  #slack comment
  
  # def slack_notification body
  #   if Rails.env.development? 
  #     # 20141224 Masakazu OHNO. now, I don't need it...
  #     return
  #   end

  #   message = ""
  #   if Rails.env.development? 
  #     message += "==== THIS IS TEST ENVIROMENT"
  #   else
  #     message += "===="
  #   end

  #   message += body + "\n"

  #   if current_user
  #     message += "by : " + current_user.username + "\n"
  #   end
  #   message += "====\n"

  #   slack_webhook_url_writers_log = 'https://hooks.slack.com/services/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'
  #   notifier = Slack::Notifier.new slack_webhook_url_writers_log , channel: '#gamerz_writers_log', username: 'gamerz_news'

  #   notifier.ping message

  # end
  



end
