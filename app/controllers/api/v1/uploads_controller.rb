class Api::V1::UploadsController < ApplicationController
  before_action :set_active_storage_host
  before_action :set_upload, only: [:show]
  before_action :file_not_found, only: [:show]

  def show
    redirect_to @upload.file.url, allow_other_host: true
  end

  def create
    @upload = Upload.new(upload_params)

    return errors_messages if !@upload.save
    
    render json: @upload.endpoint
  end

  private

  def upload_params
    params.permit(:file).merge(url_hash: SecureRandom.hex)
  end

  def set_upload
    @upload = Upload.find_by(endpoint: params[:endpoint])
  end

  def file_not_found
    return render json: {}, status: 404 if @upload.blank?
  end

  def errors_messages
    render json: @upload.errors.messages
  end

  def set_active_storage_host
    ActiveStorage::Current.url_options =
      { host: 'http://localhost:3005' }
  end
end
