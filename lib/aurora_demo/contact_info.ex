defmodule AuroraDemo.ContactInfo do
  use Aurora.Ctx

  alias AuroraDemo.ContactInfo.Address

  ctx_register_schema Address

end
