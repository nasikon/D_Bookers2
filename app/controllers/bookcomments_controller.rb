class BookcommentsController < ApplicationController
  
  def create
    book = Book.find(params[:book_id])
    #本をパラメーターから探してくる。
    comment = current_user.bookcomments.new(bookcomment_params)
    #ログインユーザーのコメントをブックコメントのパラメータに作成。
    comment.book_id = book.id
    #コメントされた本は、その本。
    comment.save
    redirect_to request.referer
  end
  
  def destroy
    Bookcomment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    #findbyメソッド。コメントのidと本のidの２つから探す。
    redirect_to request.referer
  end
  
  private

  def bookcomment_params
    params.require(:bookcomment).permit(:comment)
  end
  
end
