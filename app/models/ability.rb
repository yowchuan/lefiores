class Ability
  include CanCan::Ability  
  
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    send user.role.to_s.classify.underscore
  end

  def admin
    can :manage, :all
    can :read, User
  end

  def florist
    can :manage, Store
    can :read, User
  end
end
