namespace :avm do

  desc "Export XMP data for all published images to XML."
  task :export_xml => :environment do
    @resources = ImageSet.where(:workflow_id => Workflow.published.id, :display_id => Display.visible.id)
    @resources.each do |resource|

      if resource.image
        resource.image.export_to_xmp(File.join(RAILS_ROOT, 'public', 'avm_docs', "#{resource.id}.xml"))
      end
    end
  end

end
