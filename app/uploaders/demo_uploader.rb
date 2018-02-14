class DemoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    'uploads/demos'
  end

  def filename
    original_filename
  end

  def extension_white_list
    %w[dem]
  end
end
