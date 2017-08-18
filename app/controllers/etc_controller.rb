class EtcController < ApplicationController
  def rank
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @level_ranks_medal = User.order('level DESC', 'current_exp DESC').limit(3)
      @level_ranks_other = User.order('level DESC', 'current_exp DESC').limit(20).offset(3)
      
      @pet_ranks_medal = Animal.select("user_id, count(*) as total").group("user_id").reverse_order.limit(3)
      @pet_ranks_other = Animal.select("user_id, count(*) as total").group("user_id").reverse_order.limit(20).offset(3)
      
      @custom_ranks_medal = CustomQuest.select("user_id, count(*) as total").group("user_id").order("total").reverse_order.limit(3)
      @custom_ranks_other = CustomQuest.select("user_id, count(*) as total").group("user_id").order("total").reverse_order.limit(20).offset(3)
      
      @coin_ranks_medal = User.order('coin DESC').limit(3)
      @coin_ranks_other = User.order('coin DESC').limit(20).offset(3)
    end
  end
  
  def friend
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      #if current_user.island != 0
        @hats = Menu.where('category = ? AND type_num=?', 'hat', 1)
        @dresses = Menu.where('category = ? AND type_num=?', 'dress', current_user.island)
        @bags = Menu.where('category = ? AND type_num=?', 'bag', (5+1)/2)
        @tickets = Menu.where('category = ? AND type_num=?', 'ticket', current_user.island+1)
        @papers = Menu.where('category = ? AND type_num=?', 'paper', current_user.island)
        
        #daily, title, pet_character
        
        @pet_characters = Menu.where('category = ?', 'pet_character')
        
      #else
        
      #end
 
      
      @already_active_friends = Friend.where('sender_id = ? AND accept=?', current_user, true)
      @already_passive_friends = Friend.where('receiver_id = ? AND accept=?', current_user, true)
      @waiting_active_friends = Friend.where('sender_id = ? AND accept=?', current_user, false)
      @waiting_passive_friends = Friend.where('receiver_id = ? AND accept=?', current_user, false)

      cannot_request = []
      cannot_request << current_user.id
      @not_request = Friend.where('sender_id = ? OR receiver_id=?', current_user, current_user)
      @not_request.each do |f|
        if f.sender_id == current_user.id
          cannot_request << f.receiver_id
        else
          cannot_request << f.sender_id
        end
      end

      @users = User.where.not(id: cannot_request)
    end
    
  end
  
  def friend_request
    # friend/request로 submit(POST) 시 "receiver_id"로 친구 신청 받는 사람의 id 보내준다고 가정.
    @new_friend = Friend.new
    @new_friend.sender_id = current_user.id
    @new_friend.receiver_id = params[:receiver_id]
    @new_friend.accept = false
    @new_friend.save
    
    redirect_to '/etc/friend'
  end
  
  def friend_accept
    if params[:accept].to_i == 1
      # friend/accpet로 submit(POST) 시 "friend_id"로 friend의 id 보내준다고 가정.
      @new_friend = Friend.find(params[:friend_id])
      @new_friend.accept = true
      @new_friend.save
    else
      Friend.destroy(params[:friend_id])
    end
    
    redirect_to '/etc/friend'
  end
  
end
