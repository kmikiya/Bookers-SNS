class MessagesController < ApplicationController

    before_action :authenticate_user!, only: [:create]

 def show
  @user = User.find(params[:id])
  rooms = current_user.entries.pluck(:room_id)
  entries = Entry.find_by(user_id: @user.id, room_id: rooms)

  if entries.nil?
   @room = Room.new
   @room.save
   Entry.create(user_id: @user.id, room_id: @room.id)
   Entry.create(user_id: current_user.id, room_id: @room.id)
  else
   @room = entries.room
  end

  @messages = @room.messages
  @message = Message.new(room_id: @room.id)
 end

 def create
  @message = current_user.messages.new(message_params)
   if @message.save
   else
     render 'errors'
   end
 end



 private

 def message_params
  params.require(:message).permit(:message, :room_id)
 end

end