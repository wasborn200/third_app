class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # process resize_to_limit: [400, 400]

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # アップロードファイルの保存先ディレクトリは上書き可能
  # 下記はデフォルトの保存先
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # アップロード可能な拡張子のリスト
  def extension_whitelist
    %w(jpg jpeg gif png mp3 mp4 wav)
  end

  # 画像のみリサイズ処理を行う
  version :thumb, if: :is_thumb?

  version :thumb do
    process resize_to_limit: [400, 400]
  end

  private
    def is_thumb? picture
      picture.content_type.include?("image/")
    end
end
