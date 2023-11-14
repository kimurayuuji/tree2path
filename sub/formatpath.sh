pushd `dirname ${0}` > /tmp/null

filename=`cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head -n 1`

cat - > /tmp/$filename
columnCount=`awk -F '\t' '
{
  if(max < NF) {
    max = NF
  }
}
END {
  print max
}
' /tmp/$filename`

# write header
cat common_style
echo '
<style type="text/css">
.s-header { 
    border: 1px solid black;
    border-color: black;
    font-weight: bold;
    color: black;
    background:yellow;
} 
.s-num { 
    border: 1px solid black;
    border-color: black;
    text-align: right;
    color:black;
    background:white;
} 
.s-base { 
    border: 1px solid black; 
    border-color: black;
    border-bottom-style:none; 
    color:black;
    background:white;
} 
.s-same { 
    border: 1px solid black; 
    border-color: black;
    border-top-style:none; 
    border-bottom-style:none; 
    color:white;
    background:white;
} 
.s-blank { 
    border: 1px solid black; 
    border-color: black;
    border-top-style:none; 
    border-bottom-style:none; 
    border-left-style:none; 
    border-right-style:none; 
    background:lightgrey;
} 
.s-blank-above-existing { 
    border: 1px solid black;  
    border-color: black;
    border-bottom-style:none; 
    border-left-style:none; 
    border-right-style:none; 
    background:lightgrey;
} 
</style>
'

awk -F '\t' '
BEGIN {
  OFS=""
  comment_tag_reg = "{comment:.*}"
  after_colon_reg = ":.*"
  print "<table border=1>"  
  printf ("<tr><td class=\"s-header\" colspan=\"%d\">Insepection List</td><td class=\"s-header\">Comment</td></tr>", '$columnCount'+2)
}

match($0, comment_tag_reg, m) {
  comment = substr($0, RSTART, RLENGTH)
  comment_content_index = index(comment, ":")
  # {comment:apple-butter-charlie-duff-edward}
  #         ^comment_content_index            ^length(comment)
  #         |--------------------------------| length(comment)-1-comment_content_index
  comment = substr(comment, comment_content_index + 1, length(comment) - 1 - comment_content_index)

  sub(comment_tag_reg, "", $0)
  $('$columnCount'+2) = comment
}

{
  print "<tr>"
  print "<td class=\"s-num\">" NR "</td>"

  is_base = 0
  for (i = 1; i <= '$columnCount'; i++) {
    
    current = $i
    if (current == "" && prevRow[i] == "") {
      $i = "<td class=\"s-blank\"></td>"
    }
    else if (current == "" && prevRow[i] != "") {
      $i = "<td class=\"s-blank-above-existing\"></td>"
    }
    else if (!is_base && prevRow[i] == current) {
      $i = "<td class=\"s-same\">" current "</td>"
    }
    else  {
      $i = "<td class=\"s-base\">" current "</td>"
      is_base = 1
    }
    prevRow[i] = current
  }

  $('$columnCount'+1) = "<td class=\"s-blank\">" $('$columnCount'+1) "</td>"
  $('$columnCount'+2) = "<td class=\"s-base\">" $('$columnCount'+2) "</td>"

  print $0
  print "</tr>"
}

END {
  print "</table>"
}
' /tmp/$filename

popd > /tmp/null
