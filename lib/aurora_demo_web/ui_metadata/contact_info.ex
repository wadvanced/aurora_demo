defmodule AuroraDemoWeb.UIMetadata.ContactInfo do
  use Aurora.Uix

  alias AuroraDemo.ContactInfo
  alias AuroraDemo.ContactInfo.Address

  auix_resource_metadata(:address, schema: Address, context: ContactInfo)

end
