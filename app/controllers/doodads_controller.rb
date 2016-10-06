class DoodadsController < ApplicationController
  before_action :set_doodad, only: [:show, :edit, :update, :destroy]

  # GET /doodads
  # GET /doodads.json
  def index
    @doodads = Doodad.all
  end

  # GET /doodads/1
  # GET /doodads/1.json
  def show
  end

  # GET /doodads/new
  def new
    @doodad = Doodad.new
  end

  # GET /doodads/1/edit
  def edit
  end

  # POST /doodads
  # POST /doodads.json
  def create
    @doodad = Doodad.new(doodad_params)

    respond_to do |format|
      if @doodad.save
        format.html { redirect_to @doodad, notice: 'Doodad was successfully created.' }
        format.json { render :show, status: :created, location: @doodad }
      else
        format.html { render :new }
        format.json { render json: @doodad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doodads/1
  # PATCH/PUT /doodads/1.json
  def update
    respond_to do |format|
      if @doodad.update(doodad_params)
        format.html { redirect_to @doodad, notice: 'Doodad was successfully updated.' }
        format.json { render :show, status: :ok, location: @doodad }
      else
        format.html { render :edit }
        format.json { render json: @doodad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doodads/1
  # DELETE /doodads/1.json
  def destroy
    @doodad.destroy
    respond_to do |format|
      format.html { redirect_to doodads_url, notice: 'Doodad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doodad
      @doodad = Doodad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doodad_params
      params.require(:doodad).permit(:name, :description)
    end
end
