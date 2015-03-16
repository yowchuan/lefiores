class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    puts user.role.to_s.classify.underscore
    send user.role.to_s.classify.underscore
  end

  def admin    
    can :manage, Users
  end

  def staff
    can [:update, :create], News
  end

  def user

  end

  def spam_checker

  end

  def news_editor
    can [:read, :update, :create], News
  end

  def news_manager
    can :manage, News
  end
end

