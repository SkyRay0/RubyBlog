class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show edit update destroy]
  def index
    if !params[:tag].nil? && params[:tag] == "AH"
      @articles = Article.where(category: "AH")
    elsif !params[:tag].nil? && params[:tag] == "HS"
      @articles = Article.where(category: "HS")
    elsif !params[:tag].nil? && params[:tag] == "AN"
      @articles = Article.where(category: "AN")
    elsif !params[:tag].nil? && params[:tag] == "FA" && !current_user.nil?
      @articles = Article.where :liked_by.include? current_user.id.to_s + ","
    else
      @articles = Article.all
    end

    if !params[:time].nil? && params[:time] == "D"
      @articles = @articles.where(:created_at => Time.now.prev_day...Time.now).order(created_at: :desc)
    elsif !params[:time].nil? && params[:time] == "W"
      @articles = @articles.where(:created_at => Time.now.prev_day(7)...Time.now).order(created_at: :desc)
    elsif !params[:time].nil? && params[:time] == "M"
      @articles = @articles.where(:created_at => Time.now.prev_month...Time.now).order(created_at: :desc)
    elsif !params[:time].nil? && params[:time] == "Y"
      @articles = @articles.where(:created_at => Time.now.prev_year...Time.now).order(created_at: :desc)
    else
      @articles = @articles.order(created_at: :desc)
    end

    if !params[:sort].nil? && params[:sort] == "LR"
      @articles = @articles.sort_by { |article|
        if article.liked_by.nil?
          0
        else
          article.liked_by.split(",").count
        end
      }.reverse
    elsif !params[:sort].nil? && params[:sort] == "C"
      @articles = @articles.sort_by { |article| Comment.where(article_id: article.id).count }
    elsif !params[:sort].nil? && params[:sort] == "CR"
      @articles = @articles.sort_by { |article| Comment.where(article_id: article.id).count }.reverse
    else
      @articles = @articles.sort_by { |article|
        if article.liked_by.nil?
          0
        else
          article.liked_by.split(",").count
        end
      }
    end

    @best_comments = Comment.where(:created_at => Time.now.prev_day(7)...Time.now).where.not(liked_by: nil).limit(3)
    @best_articles = Article.where(:created_at => Time.now.prev_day(7)...Time.now).sort_by {
      |article| Comment.where(article_id: article.id).count
    }.first 3

  end

  def show
    @article = Article.find_by id: params[:id]
    @article_creator = User.find_by id: @article.user_id
    @comments = Comment.where(article_id: @article.id)
    @comment = Comment.new
  end

  def edit
    @article = Article.find_by id: params[:id]
    if @current_user.id != @article.user_id
      render root
    end
  end

  def destroy
    @article = Article.find_by id: params[:id]
    @article.destroy
    redirect_to articles_path
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params
    @article.user_id = @current_user.id
    @article.save!
    redirect_to articles_path
  end

  def update
    if @article.update article_params
      redirect_to article_path
    else
      render :edit
    end
  end

  def like
    @article = Article.find_by id: params[:id]
    if @article.liked_by.nil?
      @article.liked_by = @current_user.to_s + ","
    elsif @article.liked_by.include?(@current_user.id.to_s)
      @article.liked_by = @article.liked_by.chomp(@current_user.id.to_s + ",")
    elsif !@article.liked_by.include?(@current_user.id.to_s)
      @article.liked_by += @current_user.id.to_s + ","
    end
    @article.save!
    redirect_to article_path
  end

  private

  def find_article
    @article = Article.find_by id: params[:id]
  end

  def article_params
    params.require(:article).permit(:content, :body, :category, :title)
  end

end