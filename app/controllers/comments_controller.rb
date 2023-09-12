class CommentsController < ApplicationController
  def edit
    @comment = Comment.find_by id: params[:id]
    if @current_user.id != @comment.user_id
      render root
    end
  end

  def update
    if @comment.update comment_params
      redirect_to article_path
    else
      render :edit
    end
  end

  def like
    @article = Article.find_by id: params[:article_id]
    @comment = Comment.find_by id: params[:comment_id]
    if @comment.liked_by.nil?
      @comment.liked_by = @current_user.to_s + ","
    elsif @comment.liked_by.include?(@current_user.id.to_s)
      @comment.liked_by = @article.liked_by.chomp(@current_user.id.to_s + ",")
    elsif !@comment.liked_by.include?(@current_user.id.to_s)
      @comment.liked_by += @current_user.id.to_s + ","
    end
    @comment.save!
    redirect_to article_path
  end

  def destroy
    @comment = Comment.find_by id: params[:id]
    @comment.destroy
    redirect_to article_comments_path
  end

  def create
    @article = Article.find_by id: params[:article_id]
    @comment = Comment.new comment_params
    @comment.user_id = current_user.id
    @comment.article_id = @article.id
    @comment.save!
    redirect_to "/articles/#{params[:article_id]}/comments"
  end

  def new
    @comment = Comment.new
  end

  private

  def comment_params
    params.require(:comment).permit(:liked_by, :content)
  end
end