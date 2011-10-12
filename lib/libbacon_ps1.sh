bacon_str() {
  # usage: bacon_str "=" "../dir" -> "=/../dir"
  local bacon="$1"
  local relpath_string="$2"
  if [ -n "$relpath_string" ] ; then
    bacon="$bacon/"
    if [ "x/" = "x${relpath_string:0:1}" ] ; then
      bacon=""
      fi
    fi
  local bacon_string="$bacon$relpath_string"
  echo "$bacon_string"
  return 0
  }

ps1path_clearcache() {
  export PS1PATH_CACHE=""
  }

ps1path_return() {
  export PS1PATH_CACHE="yes"
  export PS1PATH_CACHE_STR="$1"
  echo "$1"
  return 0
  }

ps1path() {
  # I tried memoization, but it doesn't seem to work...
  # doesn't hurt keeping it here though
  if [ -n "$PS1PATH_CACHE" ]; then
    echo "$PS1PATH_CACHE_STR"
    return 0
    fi
  
  # Suddenly, the ground disappears from under your feet!
  # 
  # (happens e.g. if someone deletes the dir you're in.)
  if ! [ -e "$PWD" ] || ! [ -e "$PWD/.." ] || ! [ -x "$PWD/.." ]; then
    ps1path_return "$1"
    return 0
    fi

  bd="$HOME/.bacons"
  if ! [ -e "$bd" ] || ! [ -d "$bd" ] || ! [ -x "$bd" ]; then
    ps1path_return "$1"
    return 0
    fi
  type relpath >/dev/null 2>&1
  if ! [ "$?" -eq 0 ]; then
    ps1path_return "$1"
    return 0
    fi
  type realpath >/dev/null 2>&1
  if ! [ "$?" -eq 0 ]; then
    ps1path_return "$1"
    return 0
    fi
  declare -a bacons
  bacons[0]="$1"
  declare -i i
  declare -i shortest
  local real_bacon
  local real_pwd
  local rel
  local bacon
  shortest=0
  while read bacon; do
    i="$i + 1"
    real_bacon=$(realpath "$bd/$bacon")
    real_pwd=$(realpath "$PWD")
    rel=$(relpath "$real_bacon" "$real_pwd")
    bacons[$i]=$(bacon_str "$bacon" "$rel")
    if [ "${#bacons[$i]}" -lt "${#bacons[$shortest]}" ]; then
      shortest="$i"
      fi
    done < <(ls -1A "$bd")
  ps1path_return "${bacons[$shortest]}"
  return 0
  }
