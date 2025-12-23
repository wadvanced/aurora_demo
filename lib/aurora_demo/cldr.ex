defmodule AuroraDemo.Cldr do
  use Cldr,
  default_locale: "en",
  locales: ["en", "es"],
  add_fallback_locales: false,
  gettext: AuroraDemo.Gettext,
  data_dir: "./priv/cldr",
  opt_app: :aurora_demo,
  precompile_number_formats: ["¤¤#,##0.##", "¤¤#.##0,##"],
  providers: [Cldr.Number, Cldr.Territory],
  generate_docs: true,
  force_locale_download: Mix.env() == :prod
end
