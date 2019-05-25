class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  def export
    @posts = Post.all
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
          template: "pdfs/export.html.erb",
          disposition: "attachment",
          layout: "pdf",
          orientation: "Landscape",
          encoding: "UTF-8"
      end
    end
  end
  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new post_params

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        @user.remove_attach! if params[:post][:remove_attach] == 1
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download_as_zip
    generate_zip do |zipname, zip_path|
      File.open(zip_path, 'rb') do |zf|
        self.response.headers['Content-Type'] = "application/zip"
        self.response.headers['Content-Disposition'] = "attachment; filename=#{zipname}"
        self.response.body = Enumerator.new do |out| # Enumerator is ruby 1.9
          while !zf.eof? do
            out << zf.read(4096)
          end
        end
      end
    end
  end

  def generate_zip post
    photos = post.attach
    temp_dir = Dir.mktempdir
    zip_path = File.join(temp_dir, 'export.zip')
    Zip::ZipFile::open(zip_path, true) do |zipfile|
      photos.each do |photo|
        zipfile.get_output_stream(photo.photo.identifier) do |io|
          io.write photo.photo.file.read
        end
      end
    end
    block.call 'export.zip', zip_path
  ensure
    FileUtils.rm_rf temp_dir if temp_dir
  end

  def generate_kit_banco_zip(kit_banco)
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(ENV['FOG_DIRECTORY'])

    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      file = kit_banco.social_contract_file.file
      file_obj = bucket.object(file.path)
      zos.put_next_entry("ContratoSocial.#{file.extension}")
      zos.print(file_obj.get.body.read)
    end

    compressed_filestream.rewind
    temp_zip = Tempfile.new(['kit_documento', '.zip'])
    temp_zip.binmode
    temp_zip.write(compressed_filestream.read)

    kit_banco.zipped_kit_file = File.open(temp_zip)
    kit_banco.save!
  ensure
    temp_zip.close
    temp_zip.unlink
  end

  # METHOD 2
  def generate_kit_banco_zip2(kit_banco)
    zip_path = Rails.root.join('tmp', 'uploads', SecureRandom.hex(10).to_s + '.zip')

    Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
      file = kit_banco.social_contract_file.file

      contract_file = Rails.root.join('tmp', 'uploads', SecureRandom.hex(10).to_s + ".#{file.extension}")
      File.open(contract_file, 'wb') do |f|
        f.write(file.read)
      end

      zipfile.add("contrato_social.#{file.extension}", contract_file)
    end

    kit_banco.zipped_kit_file = File.open(zip_path)
    kit_banco.save!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :title, :attach, :remove_attach)
    end
end
