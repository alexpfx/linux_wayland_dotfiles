#!/bin/bash

#!/bin/bash
input="$@"
while IFS= read -r line
do
	title=$(echo "$line" | cut -d ":" -f 1)
	pass=$(echo "$line" | cut -d ":" -f 2)
	echo $pass | pass insert -e $title
done < "$input"
