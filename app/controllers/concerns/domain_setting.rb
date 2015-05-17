

module DomainSetting
  extend ActiveSupport::Concern


  included do
    #before_action :set_locale # for i18n
    before_action :set_site_domain    

    private
    #in the future we can create locale setting malay, tagalog, japanese, default is english
    # def set_locale
    #   #if Rails.env.com_production?
    #   #  return 'en'
    #   #elsif Rails.env.production?
    #   #  return 'ja'
    #   #elsif params[:locale].present? and params[:locale] == 'en'
    #   if params[:locale].present? and params[:locale] == 'en'
    #     I18n.locale = 'en'
    #     cookies[:locale] = 'en'
    #   elsif params[:locale].present? and params[:locale] == 'ja'
    #     I18n.locale = 'ja'
    #     cookies[:locale] = 'ja'
    #   elsif cookies[:locale].present? and cookies[:locale] == 'en'
    #     I18n.locale = 'en'
    #   elsif cookies[:locale].present? and cookies[:locale] == 'ja'
    #     I18n.locale = 'ja'
    #   else
    #     I18n.locale = extract_locale_from_domain
    #   end
    # end

    #we can setup different language on different domains
    # def extract_locale_from_domain
    #   begin
    #     if request.domain.match(/.com\Z/)
    #       return 'en'
    #     elsif request.domain.match(/.wiki\Z/)
    #       return 'ja'
    #     else
    #       return 'ja'
    #     end
    #   rescue
    #     return 'ja'
    #   end

    # end

    def set_site_domain
      begin
        @enable_games = false
        @enable_topics = false
        @enable_wiki = false
        @site_domain = 'lefiores.com'
        @facebook_url = 'https://www.facebook.com/www.gamerz.wiki'
        @twitter_url = 'https://twitter.com/gamerzwiki'
        @google_plus_url = 'https://plus.google.com/116093313158973278682/about'

        if Rails.env.production?          
          @site_domain = 'lefiores.com'                          
        
        else
          @site_domain = 'localhost:3000'          
        end
      rescue        
        @site_domain = 'lefiores.com'        
      end
    end
  end

  #we can setup stagin environment for admin and then create basic auth so that other users cannot access the domain
  # def basicauth
  #   _accepted_domains = []
  #   _accepted_domains.push('gamerz.wiki')
  #   _accepted_domains.push('localhost')
  #   _accepted_domains.push('localhost:3000')
  #   _accepted_domains.push('127.0.0.1')
  #   _accepted_domains.push('127.0.0.1:3000')
  #   _accepted_domains.push('gamerzwiki.com')
  #   _accepted_domains.push('www.gamerz.wiki')
  #   _accepted_domains.push('www.gamerzwiki.com')

  #   if _accepted_domains.include?(request.env['HTTP_HOST'])
  #     # we don't need basic auth if accepted domains
  #   else
  #     authenticate_or_request_with_http_basic do |user, pass|
     
  #       if user == 'rakd' && pass == 'rakdrakd'
  #          return true
  #       elsif user == 'gamerz_jatinder' && pass == '9Zu4322K2kn44k'
  #          return true 
        
  #       elsif user == 'gamerz_richard' && pass == 'B876647Z7Pi6'
  #            return true
  #       elsif user == 'gamerz_romeo' && pass == '44774fyKe794'
  #            return true 
  #       elsif user == 'gamerz_miklos' && pass == 'z63uj2s68736'
  #            return true 
  #       elsif user == 'gamerz_miklos' && pass == 'z63uj2s68736'
  #            return true 
  #       elsif user == 'gamerz_ahmed' && pass == 's6y9sKoRwJsEmK'
  #            return true 
  #       end
        
  #       # 通常認証経由のbasic auth通過は最後 (通常認証でのbasicauthは継続して効くが、rakdのbasicauthはあくまでもbasicauthだけ。それだけでは管理画面には行けない。)
  #       # because somebody rakd's basic auth password, somebody can login as rakd when using ID/PW. so it was moved here. 
  #       uu = login(user, pass)
  #       # 特殊ユーザの場合だけbasicauthを通過させる。
  #       # only accept basicauth in case of admin/staff/spam_checker/news_editor/news_manager
  #       if uu.present? and (uu.role == :admin  or uu.role == :staff or uu.role == :spam_checker or uu.role == :news_editor or uu.role == :news_manager)
  #         return true  if uu.present? 

  #       end
        
  #     end
  #   end
  # end


end
