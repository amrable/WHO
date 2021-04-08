require "uuidtools"
require 'prawn/qrcode'
require 'unix_crypt'

class IdentitiesController < ApplicationController
  before_action :set_identity, only: %i[ show edit update destroy ]

  # GET /download_pdf/:uuid
  def download_pdf
    send_file "#{Rails.root}/app/assets/images/" + params['uuid'] + '.svg', type: "application/svg", x_sendfile: true
  end
  # GET /identities/s/:uuid
  def select
    @identity = Identity.find_by uuid: params['uuid']
    @path_to = @identity.uuid + ".svg"
  end

  # GET /identities or /identities.json
  def index
    @identities = Identity.all
  end

  # GET /identities/1 or /identities/1.json
  def show
  end

  # GET /identities/new
  def new
    @identity = Identity.new
  end

  # GET /identities/1/edit
  def edit
  end

  # POST /identities or /identities.json
  def create
    @identity = Identity.new(identity_params)
    @identity['uuid'] = UUIDTools::UUID.random_create
    @identity['token'] = UnixCrypt::SHA256.build(@identity['token'])
    respond_to do |format|
      if @identity.save
        qrcode_content = "http://3.128.155.87:3003/identities/s/" + @identity.uuid
        qrcode = RQRCode::QRCode.new(qrcode_content, level: :m, size: 5)
        code = qrcode.as_svg(
          offset: 0,
          color: '000',
          shape_rendering: 'crispEdges',
          module_size: 11,
          standalone: true
        )
        IO.binwrite('app/assets/images/' + @identity.uuid+ '.svg', code.to_s ) 
        url = "/identities/s/"+@identity['uuid']
        format.html { redirect_to url, notice: "Identity was successfully created." }
        format.json { render :show, status: :created, location: @identity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /identities/1 or /identities/1.json
  def update
    respond_to do |format|
      @identity = Identity.find(params[:id])
      if UnixCrypt.valid?(params[:identity][:token], @identity.token)
        params[:identity][:token] = @identity.token
        if @identity.update(identity_params)
          url = "/identities/s/"+@identity['uuid']
          format.html { redirect_to url, notice: "Identity was successfully updated." }
          format.json { render :show, status: :ok, location: @identity }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @identity.errors, status: :unprocessable_entity }
        end
      else
        url = "/identities/s/"+@identity['uuid']
        format.html { redirect_to url, notice: "Invalid token." }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identities/1 or /identities/1.json
  def destroy
    @identity = Identity.find(params[:id])
    @identity.destroy
    respond_to do |format|
      format.html { redirect_to identities_url, notice: "Identity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_identity
      @identity = Identity.find_by uuid: params['uuid']
    end

    # Only allow a list of trusted parameters through.
    def identity_params
      params.require(:identity).permit(:name, :age, :gender, :phone_number, :additional_info, :token)
    end
end
