# frozen_string_literal: true

module Web
  class PostsController < ApplicationController
    before_action :authenticate_user!, except: %i[index show export]

    def index
      set_scope
      @posts = @posts.page params[:page]
    end

    def new
      @post = Post.new
    end

    def show
      @post = Post.includes(:creator, files_attachments: :blob).find(params[:id])
      authorize! @post
    end

    def create
      @post = current_user.posts.new(post_params)
      authorize! @post

      if current_user.admin?
        @post.state = :published
        @post.published_at = DateTime.current
      end
      @post.region_id = current_user.region_id if current_user.author?

      if @post.save
        redirect_to root_url, notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def export
      authorize!

      set_scope

      render xlsx: 'export'
    end

    def moderate
      authorize! instance
      UpdatePostStateWorker.perform_async(params[:id], :moderate)

      redirect_back fallback_location: root_url, notice: t('.post_moderated')
    end

    def publish
      authorize! instance
      UpdatePostStateWorker.perform_async(params[:id], :publish)

      redirect_back fallback_location: root_url, notice: t('.post_published')
    end

    def reject
      authorize! instance
      UpdatePostStateWorker.perform_async(params[:id], :reject)

      redirect_back fallback_location: root_url, notice: t('.post_rejected')
    end

    def destroy
      authorize! instance
      instance.delete

      redirect_back fallback_location: root_url, notice: t('.post_destroyed')
    end

    private

    def set_scope
      scope = PostPolicy.new(user: current_user).apply_scope(Post.all, type: :index)
      @q = scope.includes(:creator).ransack(params[:q])
      @posts = @q.result.order(id: :desc)
    end

    def instance
      @instance ||= Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :region_id, images: [], files: [])
    end
  end
end
