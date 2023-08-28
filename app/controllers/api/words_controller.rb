class Api::WordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Word.all.to_json(:include => :definitions)
  end

  def create
    @word = Word.new(word: word_params[:word],
                     part_of_speech: word_params[:part_of_speech],
                     definitions_attributes: [
                       { definition: word_params[:definition] },
                     ])

    if @word.save
      render json: @word, status: :ok
    else
      payload = { error: "error creating word", status: 400 }
      render :json => payload, :status => :bad_request
    end
  end

  def show
    render json: Word.where(id: params[:id]).load.includes(:definitions).first.to_json(:include => :definitions)
  end

  def word_params
    params.permit(:word, :part_of_speech, :definition)
  end
end
