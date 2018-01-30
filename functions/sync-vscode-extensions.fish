function sync-vscode-extensions -d "Sync your vscode extensions as text"
  if not available code
    return 1
  end
  set -q XDG_CONFIG_HOME; or set -l XDG_CONFIG_HOME "$HOME/.config"
  set -l listpath "$XDG_CONFIG_HOME/Code/User/extensions"

  if not test -e $listpath
    spin 'code --list-extensions' | sort > $listpath
    return 0
  end

  set -l list (spin 'code --list-extensions' | sort)
  set -l adds ( \
    for e in $list; echo $e; end \
    | diff $listpath - \
    | string match -r '(?<=^<).*' \
    | string trim
  )
  set -l id_list
  for ext in $adds
    code --install-extension $ext &
    set id_list $id_list (last_job_id -l)
  end

  await $id_list

  spin 'code --list-extensions' | sort > $listpath
  return 0
end