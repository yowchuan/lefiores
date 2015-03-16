class Admin::WelcomeController < Admin::BaseController
  load_and_authorize_resource :class => false

  def index
  end
end
