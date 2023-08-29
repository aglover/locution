class WordsController < ApplicationController
  def index
    @words = Word.order(:id).page params[:page]
  end

  def show
    @word = Word.find(params[:id])
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(word: word_params[:word],
                     part_of_speech: word_params[:part_of_speech],
                     definitions_attributes: [
                       { definition: word_params[:definition] },
                     ])

    if @word.save
      redirect_to @word
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @word = Word.find(params[:id])
  end

  def update
    @word = Word.find(params[:id])

    if @word.update(word_params)
      redirect_to @word
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @word = Word.find(params[:id])
    @word.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def word_params
    params.require(:word).permit(
      :word,
      :part_of_speech,
      :definition,
    )
  end
end
