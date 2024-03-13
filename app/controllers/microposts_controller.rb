class MicropostsController < ApplicationController
    before_action :require_log_in!, only: [:create]

    def index
    end

    def create
        @micropost = current_user.microposts.build(micropost_params)
        @micropost.image.attach(params[:micropost][:image])
        if @micropost.save
            flash[:success] = "Create micropost success!!!"
            redirect_to root_url
        else
            @feed_items = current_user.feed.paginate(page: params[:page])
            render "static_pages/home", status: :unprocessable_entity
        end
    end

    def destroy
        micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url unless micropost

        micropost.destroy
        flash[:success] = "Micropost delete"
    end

    private

    def micropost_params
        params.require(:micropost).permit(:content, :image)
    end
end
