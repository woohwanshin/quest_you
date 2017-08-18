class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    @new_title = Title.new
    @new_title.user_id = User.last.id
    @new_title.type_number = 15
    @new_title.save
    
    # 데일리 퀘스트 - 칭호 바꾸는 퀘스트 기본으로 제공
    @new_daily_quest = DailyQuest.new
    @new_daily_quest.user_id = current_user.id
    @new_daily_quest.content = Menu.where('category = ? AND type_num = ?','daily',1)[0].name
    @new_daily_quest.did = false
    @new_daily_quest.save
      
    # 데일리 퀘스트 - 랜덤으로 3개 제공
    @daily_content = Menu.where('category = ?', 'daily').offset(1).sample(3)
    @daily_content.each do |content|
      @new_daily_quest = DailyQuest.new
      @new_daily_quest.user_id = current_user.id
      @new_daily_quest.content = content.name
      # 데일리퀘스트의 내용을 랜덤으로 넣어주는 부분 아직 안 함!!!!!
      @new_daily_quest.did = false
      @new_daily_quest.save
    end
  
    # title_name (칭호) - 랜덤으로 5개 제공
    @random_title_names = Menu.where('category = ? AND type_num > ? AND (type_num < ? OR type_num > ?)', 'title', 0, 17, 30).sample(5)
    @random_title_names.each do |content|
      @new_title = Title.new
      @new_title.user_id = current_user.id
      @new_title.type_number = content.type_num
      @new_title.save
    end
    
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
