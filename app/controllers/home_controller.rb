class HomeController < ApplicationController
  def login
    
  end
  
  
  def main
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @menus = Menu.all
      
      @titles = Title.where('user_id = ?',current_user)
      
      #current_time = Time.now + 60 * 60 * 9
      current_day = DateTime.now.beginning_of_day
    
      @custom_quests = CustomQuest.where('user_id = ? AND due_time >= ?', current_user, current_day)
    
      hat_array = (Menu.where('category = ? AND type_num = ?', 'hat', current_user.hat)) 
      dress_array = (Menu.where('category = ? AND type_num = ?', 'dress', current_user.dress)) 
      title_array = (Menu.where('category = ? AND type_num = ?', 'title', current_user.title_name))
      pet_array = (Menu.where('category = ? AND type_num = ?', 'pet_character', current_user.pet))
      
      if current_user.hat == current_user.dress
        hat_coin = (hat_array[0].coin_percent)*0.01*2
        dress_coin = (dress_array[0].coin_percent)*0.01*2
        title_coin = (title_array[0].coin_percent)*0.01
        pet_coin = (pet_array[0].coin_percent)*0.01
        
        hat_exp = (hat_array[0].exp_percent)*0.01*2
        dress_exp = (dress_array[0].exp_percent)*0.01*2
        title_exp = (title_array[0].exp_percent)*0.01
        pet_exp = (pet_array[0].exp_percent)*0.01
      else
        hat_coin = (hat_array[0].coin_percent)*0.01
        dress_coin = (dress_array[0].coin_percent)*0.01
        title_coin = (title_array[0].coin_percent)*0.01
        pet_coin = (pet_array[0].coin_percent)*0.01
        
        hat_exp = (hat_array[0].exp_percent)*0.01
        dress_exp = (dress_array[0].exp_percent)*0.01
        title_exp = (title_array[0].exp_percent)*0.01
        pet_exp = (pet_array[0].exp_percent)*0.01
      end
      
      
      current_user.extra_coin = 1 + hat_coin + dress_coin + title_coin + pet_coin
      current_user.extra_exp = 1 + hat_exp + dress_exp + title_exp + pet_exp
      current_user.save
      
      
      
      @daily_quests = DailyQuest.where('user_id = ? AND created_at > ?', current_user, current_day)
      if @daily_quests.empty?
        # 오늘 만들어진 데일리퀘스트가 없을 때 새로 만들어 디비에 넣고 띄워준다.
        @daily_content = Menu.where('category = ?', 'daily').offset(1).sample(3)
        @daily_content.each do |content|
          @new_daily_quest = DailyQuest.new
          @new_daily_quest.user_id = current_user.id
          @new_daily_quest.content = content.name
          # 데일리퀘스트의 내용을 랜덤으로 넣어주는 부분 아직 안 함!!!!!
          @new_daily_quest.did = false
          @new_daily_quest.save
        end
      end
      
      @party_partners = PartyPartner.where(:party_partners => { :user_id => current_user })
      
    end
  end
  
  def new_quest
    
    current_day = Date.today + params[:date].to_i + 1
    @new_custom_quest = CustomQuest.new
    @new_custom_quest.user_id = current_user.id
    @new_custom_quest.due_time = current_day
    @new_custom_quest.content = params[:Quest]
    @new_custom_quest.did = false
    @new_custom_quest.save
    
    redirect_to '/main'
    
  end
  
  def complete_custom_quest
    #@complete_custom_quest = CustomQuest.where(:custom_quests => { :id => params[:custom_id] })
    #@complete_custom_quest[0].did = true
    #@complete_custom_quest[0].save
    hat_array = (Menu.where('category = ? AND type_num = ?', 'hat', current_user.hat)) 
    dress_array = (Menu.where('category = ? AND type_num = ?', 'dress', current_user.dress)) 
    title_array = (Menu.where('category = ? AND type_num = ?', 'title', current_user.title_name))
    pet_array = (Menu.where('category = ? AND type_num = ?', 'pet_character', current_user.pet))
    
    if current_user.hat == current_user.dress
      hat_coin = (hat_array[0].coin_percent)*0.01*2
      dress_coin = (dress_array[0].coin_percent)*0.01*2
      title_coin = (title_array[0].coin_percent)*0.01
      pet_coin = (pet_array[0].coin_percent)*0.01
      
      hat_exp = (hat_array[0].exp_percent)*0.01*2
      dress_exp = (dress_array[0].exp_percent)*0.01*2
      title_exp = (title_array[0].exp_percent)*0.01
      pet_exp = (pet_array[0].exp_percent)*0.01
    else
      hat_coin = (hat_array[0].coin_percent)*0.01
      dress_coin = (dress_array[0].coin_percent)*0.01
      title_coin = (title_array[0].coin_percent)*0.01
      pet_coin = (pet_array[0].coin_percent)*0.01
      
      hat_exp = (hat_array[0].exp_percent)*0.01
      dress_exp = (dress_array[0].exp_percent)*0.01
      title_exp = (title_array[0].exp_percent)*0.01
      pet_exp = (pet_array[0].exp_percent)*0.01
    end
    
    
    current_user.extra_coin = 1 + hat_coin + dress_coin + title_coin + pet_coin
    current_user.extra_exp = 1 + hat_exp + dress_exp + title_exp + pet_exp
    
    
    @complete_custom_quest = CustomQuest.find(params[:custom_id])
    @complete_custom_quest.did = true
    @complete_custom_quest.save
    
    #current_user.current_exp += (10 + current_user.level*2)
    current_user.current_exp += ((rand(5..10) + current_user.level/3)*current_user.extra_exp)*3
    
    while(true)
      if current_user.current_exp >= current_user.need_exp
        current_user.level +=1
        current_user.current_exp = current_user.current_exp - current_user.need_exp
        current_user.need_exp = current_user.level * 2 + 18
      else
        break;
      end
    end
    
    current_user.coin += rand(5..7)*10*current_user.extra_coin*3
    current_user.save
    
    redirect_to '/main'
    
  end
  
  def complete_daily_quest
    @complete_daily_quest = DailyQuest.find(params[:daily_id])
    @complete_daily_quest.did = true
    @complete_daily_quest.save
    
    hat_array = (Menu.where('category = ? AND type_num = ?', 'hat', current_user.hat)) 
    dress_array = (Menu.where('category = ? AND type_num = ?', 'dress', current_user.dress)) 
    title_array = (Menu.where('category = ? AND type_num = ?', 'title', current_user.title_name))
    pet_array = (Menu.where('category = ? AND type_num = ?', 'pet_character', current_user.pet))
    
    if current_user.hat == current_user.dress
      hat_coin = (hat_array[0].coin_percent)*0.01*2
      dress_coin = (dress_array[0].coin_percent)*0.01*2
      title_coin = (title_array[0].coin_percent)*0.01
      pet_coin = (pet_array[0].coin_percent)*0.01
      
      hat_exp = (hat_array[0].exp_percent)*0.01*2
      dress_exp = (dress_array[0].exp_percent)*0.01*2
      title_exp = (title_array[0].exp_percent)*0.01
      pet_exp = (pet_array[0].exp_percent)*0.01
    else
      hat_coin = (hat_array[0].coin_percent)*0.01
      dress_coin = (dress_array[0].coin_percent)*0.01
      title_coin = (title_array[0].coin_percent)*0.01
      pet_coin = (pet_array[0].coin_percent)*0.01
      
      hat_exp = (hat_array[0].exp_percent)*0.01
      dress_exp = (dress_array[0].exp_percent)*0.01
      title_exp = (title_array[0].exp_percent)*0.01
      pet_exp = (pet_array[0].exp_percent)*0.01
    end
    
    
    current_user.extra_coin = 1 + hat_coin + dress_coin + title_coin + pet_coin
    current_user.extra_exp = 1 + hat_exp + dress_exp + title_exp + pet_exp
    
    current_user.current_exp += ((rand(10..15) + current_user.level/3)*current_user.extra_exp)
    
    while(true)
      if current_user.current_exp >= current_user.need_exp
        current_user.level +=1
        current_user.current_exp = current_user.current_exp - current_user.need_exp
        current_user.need_exp = current_user.level * 2 + 18
      else
        break;
      end
    end
    
    current_user.coin += rand(5..7)*10*current_user.extra_coin
    current_user.save

    
    redirect_to '/main'
    
  end
  
  def complete_party_quest
    @complete_party_quest = PartyPartner.find(params[:party_id])
    @complete_party_quest.did = true
    @complete_party_quest.save
    
    current_user.current_exp += (30 + current_user.level*4)
    
    while(true)
      if current_user.current_exp >= current_user.need_exp
        current_user.level +=1
        current_user.current_exp = current_user.current_exp - current_user.need_exp
        current_user.need_exp = current_user.level * 2 + 18
      else
        break;
      end
    end
    
    current_user.coin += rand(5..7)*10
    current_user.save
    
    redirect_to '/main'
  end
  

  
  def map
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @tickets = Ticket.where(:tickets =>{ :user_id => current_user })
      if @tickets.empty?
        @last_ticket = 0
      else
        @last_ticket = @tickets[@tickets.length - 1].type_number
      end
    end
    
  end
  
  def move_island
    
    current_user.island = params[:move_island]
    current_user.save
    
    sleep 5.1
    
    redirect_to '/main'
  end
  
  def bag_item
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @hats = Hat.where(:hats =>{ :user_id => current_user })
      @bags = Bag.where(:bags =>{ :user_id => current_user })
      @tickets = Ticket.where(:tickets =>{ :user_id => current_user })
      @dresses = Dress.where(:Dresses =>{ :user_id => current_user })
      @menus = Menu.all
    end
    
  end
  
  def wearing_item
    
    current_user.hat = params[:hat]
    current_user.dress = params[:clothes]
    current_user.bag = params[:bag]
    current_user.save
    
    redirect_to '/bag_item'
    
  end
  

  def pet
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @menus = Menu.all
      @animals = Animal.all
    end
  end
  
  #칭호 변경
  def change_title
    current_user.title_name = params[:title]
    current_user.save
    
    redirect_to '/main'
  end
  
  def selecting_pet
    current_user.pet = params[:pet]
    current_user.save
    
    redirect_to '/pet'
    
  end
  
  def releasing_pet
    current_user.pet = 0
    current_user.save
        
    Animal.destroy(params[:pet])
    

    
    redirect_to '/pet'
  end
  
  
  
  def shop
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      if current_user.island != 0
        @hats = Menu.where('category = ? AND type_num=?', 'hat', current_user.island)
        @dresses = Menu.where('category = ? AND type_num=?', 'dress', current_user.island)
        @bags = Menu.where('category = ? AND type_num=?', 'bag', ( current_user.island+1)/2)
        @papers = Menu.where('category = ? AND type_num=?', 'paper', current_user.island)
      end
      @tickets = Menu.where('category = ? AND type_num=?', 'ticket', current_user.island+1)
      
      @can_buy_hat = 0
      @can_buy_clothes = 0
      @can_buy_bag = 0
      @can_buy_ticket = 0
      
      @is_user_have_this_hat = Hat.where('user_id = ? AND type_number >= ?', current_user, current_user.island)
      if @is_user_have_this_hat.empty?
        @can_buy_hat = 1
      end
      
      @is_user_have_this_clothes = Dress.where('user_id = ? AND type_number >= ?', current_user, current_user.island)
      if @is_user_have_this_clothes.empty?
        @can_buy_clothes = 1
      end
      
      @is_user_have_this_bag = Bag.where('user_id = ? AND type_number >= ?', current_user, current_user.island)
      if @is_user_have_this_bag.empty?
        @can_buy_bag = 1
      end
      
      @is_user_have_this_ticket = Ticket.where('user_id = ? AND type_number >= ?', current_user, (current_user.island+1))
      if @is_user_have_this_ticket.empty?
        @can_buy_ticket = 1
      end
      
      
      @island_data = Menu.where('category = ? AND type_num=?', 'island', current_user.island)
      
      @pet_count = Animal.where(:animals =>{ :user_id => current_user }).length
      if(current_user.bag == 0)
        @user_max_pet = 3
      else
        @user_max_pet = Menu.where('category = ? AND type_num=?', 'bag', current_user.bag)[0].other_percent  
      end
      
      
    end
    
  end
  
  def buy_pet
    @new_pet = Animal.new
    @new_pet.user_id = current_user.id
    @new_pet.species = params[:shop_pet]
    @new_pet.name = params[:pet_name]
    @new_pet.character = rand(1..10)
    @new_pet.save
    
    current_user.coin = current_user.coin - params[:shop_pet_price].to_i
    current_user.save
    
    redirect_to '/pet'
    
  end
  
  def buy_hat
    @new_hat = Hat.new
    @new_hat.user_id = current_user.id
    @new_hat.type_number = params[:shop_hat]
    @new_hat.save
    
    current_user.coin = current_user.coin - params[:shop_hat_price].to_i
    current_user.save
    
    redirect_to '/bag_item'
    
  end
  
  def buy_clothes
    
    @new_clothes = Dress.new
    @new_clothes.user_id = current_user.id
    @new_clothes.type_number = params[:shop_clothes]
    @new_clothes.save
    
    current_user.coin = current_user.coin - params[:shop_clothes_price].to_i
    current_user.save
    redirect_to '/bag_item'
    
  end
  
  def buy_bag
    @new_bag = Bag.new
    @new_bag.user_id = current_user.id
    @new_bag.type_number = params[:shop_bag]
    @new_bag.save
    
    current_user.coin = current_user.coin - params[:shop_bag_price].to_i
    current_user.save
    redirect_to '/bag_item'
    
  end
  
  def buy_ticket
    @new_ticket = Ticket.new
    @new_ticket.user_id = current_user.id
    @new_ticket.type_number = params[:shop_ticket]
    @new_ticket.save
    
    current_user.coin = current_user.coin - params[:shop_ticket_price].to_i
    current_user.save
    redirect_to '/bag_item'
  end
  
  def setting
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
    end
    
  end
end
