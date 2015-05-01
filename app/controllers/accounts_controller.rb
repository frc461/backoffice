class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :post]
  before_action :authorize, except: [:show]

  # GET /accounts
  # GET /accounts.json
  def index
      @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
        redirect_to root_path, error: "You can't do that." unless current_role?('bookkeeper') || current_role?('administrator') || current_user.dn.to_s == @account.user_dn
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def post
      @transaction = Transaction.new
      @transaction.account = @account
      @transaction.poster_dn = current_user.dn.to_s
      @transaction.amount = Monetize.parse(params[:amount])
      @transaction.icon = params[:icon]
      @transaction.description = params[:description]
      if @transaction.save
          @account.balance_cents += @transaction.amount_cents
          @account.save
          redirect_to @account, notice: 'Posted transaction.'
      else
          redirect_to @account, error: 'Failed to post transaction.'
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def authorize
        redirect_to root_path, error: "You can't do that." unless current_role?('bookkeeper') || current_role?('administrator')
    end
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :description, :user_dn, :code)
    end
end
