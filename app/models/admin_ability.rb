class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    @user_role = user.role.to_s.classify.underscore
    @user_id = user.id
    send user.role.to_s.classify.underscore
   
  end

  def admin
    #can :manage, :all
    #can [:read, :create, :destroy], Admin::Reservedword
    #can [:read, :create, :update, :destroy], Game

    #can :manage, Topic::Page
    #can :manage, News
    #can :manage, Game::Company
    can :manage, User
    #can :manage, News::Category
    #can :manage, Sitepage
    can :manage, Store
    
    #can :manage, Game::Platform
    #can :manage, Game::Genre

  end

  def staff
    can [:read, :create ], Admin::Reservedword
    can [:read, :create, :update, :destroy], Game
    can :manage, News::Category
    can :manage, Game::Company
    can :manage, Game::Platform
    can :manage, Game::Genre
    can [:read, :create, :update, :destroy], Game
  end

  def news_editor
    can [:read ], Admin::Reservedword
    can [:read,:update,:create], News, :user_id => @user_id
    cannot :status, News
    can :read, News::Category
    can [:read, :create], Game 
    can [:read, :create], Game::Company
    can [:update], Game ,:user_id => @user_id
    can [:update], Game::Company ,:user_id => @user_id
    can :read, Game::Genre
    can :read, Game::Platform
  end

  def news_manager
    can [:read ], Admin::Reservedword
    can :manage, News
    can :manage, Topic::Page
    can :manage, News::Category
    can [:read, :create, :update], Game
  end

  def spam_checker
    can [:read ], Admin::Reservedword
  end

end
