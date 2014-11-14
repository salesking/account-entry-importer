class MappingsController < ApplicationController
  load_and_authorize_resource :attachment, only: [:new, :create]
  load_and_authorize_resource
  skip_load_resource only: [:create]

  before_filter :include_gon_translation

  def create
    @mapping = MappingManager.new(params, mapping_params, current_user).get_mapping

    @mapping.attachments << @attachment

    if @mapping.save
      redirect_to new_attachment_import_url(@attachment)
    else
      render :new
    end
  end

  def destroy
    if @mapping.destroy
      flash[:success] = I18n.t('imports.destroyed_successfully')
    else
      flash[:error]  = I18n.t('imports.destroy_failed')
    end
    redirect_to attachments_path
  end

  private
  def mapping_params
    params.require(:mapping).permit(:import_type, :account_id, :account_name, :account_budget, :account_default_price, :account_number, mapping_elements_attributes: [:id, :source, :target, :source, :conversion_type, :conversion_options, :import_id, :model_to_import])
  end

  def include_gon_translation
    gon[:account_id_placeholder] = t('mappings.form.account_id_placeholder')
  end
end
