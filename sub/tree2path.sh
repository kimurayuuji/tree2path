pushd `dirname ${0}` > /tmp/null

file=`./parse_args.sh $@ | grep "\-f:" | awk '{print $2}'`
delimitor=`./parse_args.sh $@ | grep "\-d:" | awk '{print $2}'`
if ["${delimitor}" = ""]; then
  delimitor='\t'
fi

less $file | awk -F $delimitor '
BEGIN {
  OFS = FS
}
{
  # タブ文字の場合は以前の行のものに補完する
  for (i = 1; i<=NF; i++) {
    if ($i == "") {
      $i=buf[i]
    }
    else {
      buf[i]=$i
    }
  }
  print $0
}
' | tac | awk -F $delimitor '
BEGIN {
  OFS = FS
}
{
  # 末端のパスを取得したい
  # 親パスと同じものは出力しない
  # 親パス、子パスの行順を前提としているためtacで逆順から処理を行っている
  if(paths[$0 "\t"] == 0){
    print $0
  }
  $NF=""
  paths[$0] = 1
}
' | tac

popd > /tmp/null
