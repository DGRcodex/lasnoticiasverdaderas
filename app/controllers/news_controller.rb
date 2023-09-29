class NewsController < ApplicationController
  before_action :set_news, only: %i[ show edit update destroy ]

  # GET /news or /news.json
  def index
    redirect_to root_path
  end

  # GET /news/1 or /news/1.json
  def show
    @news = News.find(params[:id])
    @comments = @news.comments
  end

  # GET /news/new
  def new
    if user_signed_in?
      @news = News.new
    else
      redirect_to root_path, alert: "Debes iniciar sesión para crear una noticia."
    end
  end

  # GET /news/1/edit
  def edit
    if user_signed_in?
      news_id = params[:id]
      @news = News.find(news_id)
      if current_user.id == @news.user_id

      else 
        redirect_to news_path(news_id), alert: "No puedes modificar una noticia de la que no seas el autor."
      end
    else
      redirect_to news_path(news_id), alert: "Debes iniciar sesión para modificar tu noticia."
    end
  end

  # POST /news or /news.json
  def create
    @news = News.new(news_params)
    respond_to do |format|
      if @news.save
        format.html { redirect_to news_url(@news), notice: "News was successfully created." }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1 or /news/1.json
  def update
    if user_signed_in?
      news_id = params[:id]
      @news = News.find(news_id)
      if current_user.id == @news.user_id
        respond_to do |format|
          if @news.update(news_params)
            format.html { redirect_to news_url(@news), notice: "News was successfully updated." }
            format.json { render :show, status: :ok, location: @news }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @news.errors, status: :unprocessable_entity }
          end
        end
      else 
        redirect_to news_path(news_id), alert: "No puedes actualizar una noticia de la que no seas el autor."
      end
    else
      redirect_to news_path(news_id), alert: "Debes iniciar sesión para actualizar tu noticia."
    end
  end

  # DELETE /news/1 or /news/1.json
  def destroy
    if user_signed_in?
      news_id = params[:id]
      if current_user.id == @news.user_id || current_user.role == User.roles.key(2).to_s
        @news.destroy
        respond_to do |format|
          format.html { redirect_to news_index_url, notice: "News was successfully destroyed." }
          format.json { head :no_content }
        end
      else 
        redirect_to news_path(news_id), alert: "No puedes eliminar una noticia de la que no seas el autor."
      end
    else
      redirect_to news_path(news_id), alert: "Debes iniciar sesión para eliminar tu noticia."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def news_params
      params.require(:news).permit(:title, :imagen, :description).merge(user_id: current_user.id)
    end
end
