{
  # Implementation taken from `NixOS/nixpkgs`:
  # https://git.io/chromium-com-nix (MIT licensed)
  #
  # Serialize Nix types into GN types according to this document:
  # https://chromium.googlesource.com/chromium/src/+/master/tools/gn/docs/language.md

  mkGnFlags =
    let
      mkGnString = value: "\"${escape ["\"" "$" "\\"] value}\"";
      sanitize = value:
        if value == true then "true"
        else if value == false then "false"
        else if isList value then "[${concatMapStringsSep ", " sanitize value}]"
        else if isInt value then toString value
        else if isString value then mkGnString value
        else throw "Unsupported type for GN value «${value}».";
      toFlag = key: value: "${key}=${sanitize value}";
    in attrs: concatStringsSep " " (attrValues (mapAttrs toFlag attrs));
}
