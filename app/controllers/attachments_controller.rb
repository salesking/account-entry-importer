class AttachmentsController < ApplicationController
  load_and_authorize_resource

  def new
    @attachment = Attachment.new(column_separator: ',', quote_character: '"', encoding: 'utf-8')
  end

  # TODO:
  # - check for headers if none use first data row
  # - hide headers/fields which are potentially empty
  # - find or construct a row with all data set, so we can show examples
  def create
    @attachment = Attachment.new(uploaded_data: params[:file], column_separator: params[:column_separator], quote_character: params[:quote_character], encoding: params[:encoding])
    @attachment.user = current_user
    @attachment.save!
    # TODO rescue parser errors -> rows empty
    render json: {success: true, id: @attachment.id, rows: @attachment.rows(4)}, status: :ok
  end

  def update
    if @attachment.update_attributes(attachment_params)
      respond_to do |format|
        format.html { redirect_to (@attachment.mapping.blank? ? new_attachment_mapping_url(@attachment) : new_attachment_import_url(@attachment))
          }
        format.js { render json: {rows: @attachment.rows(4)}, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: {rows: {}}, status: :ok }
      end
    end
  end

  def destroy
    @attachment.destroy
    redirect_to attachments_path
  end

  private

  def attachment_params
    params.require(:attachment).permit(:column_separator, :quote_character, :uploaded_data, :encoding, :mapping_id)
  end
end
