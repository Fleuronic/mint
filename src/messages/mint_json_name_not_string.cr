message MintJsonNameNotString do
  title "mint.json Error"

  block do
    text "The"
    bold "name"
    text "field of a"
    bold "mint.json"
    text "file is not a string."
  end

  snippet node, nil
end
