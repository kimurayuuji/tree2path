declare -A argDic

for arg in "$@"; do
  case $arg in
    -*) option=${arg} ;;
    *) argDic["$option"]="$arg" ;;
  esac
done

for key in "${!argDic[@]}"; do
  echo $key: ${argDic[$key]}
done


