echo "フォーマットしたいファイルをドラッグしてください" 
read target_file

output=${target_file%.*}.html

./sub/tree2path.sh -f ${target_file} | ./sub/formatpath.sh > ${output}

read -p "Press any key..."
