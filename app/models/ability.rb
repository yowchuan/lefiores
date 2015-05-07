class Ability
  include CanCan::Ability  
  
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    @user_id = user.id
    send user.role.to_s.classify.underscore
  end

  def admin
    can :manage, :all
    can :read, User
  end

  def florist
    can [:read,:update,:create], Store, :user_id => @user_id
  end
end
