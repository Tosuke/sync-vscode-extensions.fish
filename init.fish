# support fundle
if contains 'fundle' (functions)
  ## fishfile
  if test -e ./fishfile
    cat ./fishfile | while read -l line
      fundle plugin "$line"
    end
  end
end