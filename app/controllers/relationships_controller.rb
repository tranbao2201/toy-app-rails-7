class RelationshipsController < ApplicationController
    before_action :require_log_in!, :find_user
    def create
        if @user
            current_user.follow(@user)
            redirect_to @user
        else
            redirect_to root_url
        end
    end

    def destroy
        if @user
            current_user.unfollow(@user)
            redirect_to @user
        else
            redirect_to root_url
        end
    end

    private

    def find_user
        @user = User.find_by(id: params[:id])
    end
end
