message EnumIdTypeMismatch do
  title "Type Error"

  block do
    text "The"
    bold "type of an enum"
    text "does not match its definition"
  end

  was_expecting_type expected, got

  snippet node, "The enum is here:"
end
