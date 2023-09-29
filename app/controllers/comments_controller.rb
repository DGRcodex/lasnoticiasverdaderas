class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    redirect_to root_path
  end

  # GET /comments/1 or /comments/1.json
  def show
    redirect_to root_path
  end

  # GET /comments/new
  def new
    if user_signed_in?
      @noticia = params[:noticia]
      @comment = Comment.new
    else
      redirect_to root_path, alert: "Debes iniciar sesión para dejar un comentario."
    end
  end

  # GET /comments/1/edit
  def edit
    if user_signed_in?
      comment_id = params[:id]
      @comment = Comment.find(comment_id)
      if current_user.id == @comment.user_id

      else 
        redirect_to comment_path(comment_id), alert: "No puedes modificar un comentario del que no seas el autor."
      end
    else
      redirect_to comment_path(comment_id), alert: "Debes iniciar sesión para modificar tu comentario."
    end
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to news_url(@comment.news_id), notice: "Comentario creado correctamente." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    if user_signed_in?
      comment_id = params[:id]
      @comment = Comment.find(comment_id)
      if current_user.id == @news.user_id
        respond_to do |format|
          if @comment.update(comment_params)
            format.html { redirect_to news_url(@comment.news_id), notice: "Comentario actualizado correctamente." }
            format.json { render :show, status: :ok, location: @comment }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        end
      else 
        redirect_to comment_path(comment_id), alert: "No puedes actualizar un comentario del que no seas el autor."
      end
    else
      redirect_to comment_path(comment_id), alert: "Debes iniciar sesión para actualizar tu comentario."
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    if user_signed_in?
      comment_id = params[:id]
      @comment = Comment.find(comment_id)
      if current_user.id == @comment.user_id || current_user.role == User.roles.key(2).to_s
        @comment.destroy
        respond_to do |format|
          format.html { redirect_to news_url(@comment.news_id), notice: "El comentario ha sido eliminado correctamente" }
          format.json { head :no_content }
        end
      else 
        redirect_to comment_path(comment_id), alert: "No puedes eliminar un comentario del que no seas el autor."
      end
    else
      redirect_to comment_path(comment_id), alert: "Debes iniciar sesión para eliminar tu comentario."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :news_id).merge(user_id: current_user.id)
    end
end
