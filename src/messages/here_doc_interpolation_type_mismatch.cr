message HereDocInterpolationTypeMismatch do
  title "Type Error"

  block do
    text "An interpolation in here document is causing a mismatch."
  end

  type_with_text expected, "The expected type is:"
  type_with_text got, "Instead it got:"

  snippet node, "It is here:"
end
