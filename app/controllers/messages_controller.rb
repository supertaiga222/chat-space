class MessagesController < ApplicationController
  before_action :set_group
  
  def index
    #・新しいメッセージを送る
    #・メッセージの一覧の表示・・・インスタンス変数（グループに所属している、所属しているユーザーの発言）
    @message = Message.new
    @messages = @group.messages.includes(:user)
  end

  def create
    @message = @group.messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.json 
      end
    else
      @messages = @group.messages.includes(:user)
      flash.now[:alert] = 'メッセージを入力してください'
      render :index
    end
    respond_to do |format|
      format.html { redirect_to group_messages_path, notice: "メッセージを送信しました" } 
      format.json
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end