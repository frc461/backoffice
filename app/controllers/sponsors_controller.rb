class SponsorsController < ApplicationController
  before_action :authorize, except: [:show]
    def index
        @sponsors = Sponsor.find(:all).sort_by{|s| [s.o]}
    end

    def show
        @sponsor = Sponsor.find(params[:dn])
    end

    def post
        @sponsor = Sponsor.find(params[:dn])
        @transaction = Transaction.new
        @transaction.account = Account.find(params[:account_id])
        if @transaction.account
            @transaction.poster_dn = current_user.dn.to_s
            @transaction.amount = Monetize.parse(params[:amount])
            @transaction.icon = params[:icon]
            @transaction.description = params[:description]
            @transaction.sponsor_dn = params[:dn]
            if @transaction.save
                @transaction.account.balance_cents += @transaction.amount_cents
                @transaction.account.save
                redirect_to sponsor_path(dn: @sponsor.dn.to_s), notice: 'Posted transaction.'
            else
                redirect_to sponsor_path(dn: @sponsor.dn.to_s), error: 'Failed to post transaction.'
            end
        else
            redirect_to sponsor_path(dn: @sponsor.dn.to_s), error: 'Invalid account for transaction.'
        end
    end

    private
    def authorize
        redirect_to root_path, error: "You can't do that." unless current_role?('bookkeeper') || current_role?('administrator')
    end
end
