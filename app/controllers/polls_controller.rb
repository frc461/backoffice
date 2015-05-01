class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy, :vote, :cancel, :close]

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(poll_params)

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def vote
      if @poll.can_vote(current_user) && Vote.create(poll_id: @poll.id, user_dn: current_user.dn.to_s, value: params[:opt])
          flash[:notice] = "Thanks for voting!"
      else
          flash[:error] = "Something went wrong!"
      end
      redirect_to @poll
  end

  def cancel
    @poll.votes.where(user_dn: current_user.dn.to_s).each do |v|
        v.delete
    end
    redirect_to @poll
  end

  def close
      @poll.closed = true
      @poll.save
      redirect_to @poll, notice: 'Closed poll.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:title, :content, :options, :permissions)
    end
end
