require 'fog'

# Connect to Rackspace
rackspace = Fog::Compute.new({:rackspace_username=>'haikulearning', :rackspace_api_key=>'59563fd89860ce53bfa3cf9eedde8fb7',	:provider=>'Rackspace', :rackspace_endpoint=>'https://ord.servers.api.rackspacecloud.com/v2',:version=>:v2})

# Create a new Daily Image from Red1
image = rackspace.create_image('18cae8a4-c97e-4160-a244-0d233e7d7880', 'Red1 Daily', options = {})
# If the image creation is started successfully...
if image.status == 202
  # Get the id of the new image
  new_image_id = /[a-z0-9\-]*$/.match(image.headers['Location']).to_s
  # Load the last_image_id
  last_image_id = File.open('/vhosts/apps/redmine/current/.last_daily_image', 'r') {|f| f.gets}
  # Save the id to the log
  File.open('/vhosts/apps/redmine/current/.last_daily_image', 'w') {|f| f.write(new_image_id)}
  # Delete the last image
  delete_response = rackspace.images.get(last_image_id).destroy 
  # Log the deletion status
  if delete_response == 204
    # Deletion Succeded 
  else
    # Deletion Failed
  end

# If the image creation fails...
else
   # Log the failure
  
  # Quit
  
end
