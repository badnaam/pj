class FriendshipsController < ApplicationController
  def create
    @user = User.find(4)
    @friend_username = params[:friend_username]
    @friendship = @user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Added #{@friend_username} as a friend"
    else
      flash[:notice] = "Unable to add friend."
    end
       redirect_to users_path
  end

  def show
  end

  def destroy
     @user = User.find(4)

      @friendship = @user.friendships.find(params[:id])
      @friend = @friendship.friend.username
      if @friendship.delete
        flash[:notice] = "Friendship with #{@friend} deleted"
      end
      redirect_to @user
  end

end
