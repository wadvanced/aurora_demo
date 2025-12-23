defmodule AuroraDemoWeb.ContactInfo do
  use Aurora.Uix

  alias AuroraDemoWeb.UIMetadata.ContactInfo, as: ContactInfoMetadata

  @auix_resource_metadata ContactInfoMetadata.auix_resource(:address)

  auix_create_ui(link_prefix: "demo/contact_info/")
end
