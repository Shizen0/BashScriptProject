#! /bin/bash

select operation in SortFiles sendEMail getEmail
do
	case $operation in 
		SortFiles)
			
			extensionname=$(zenity --entry --text "Enter your extension that you want to sort:" --title "Write Extension To Sort" --entry-text="");
			extensionnames=( $extensionname  )
			for (( i=0;i<${#extensionnames[@]};i++ ))
			do	
				if [ -d ${extensionnames[i]}  ]
				then
					echo "Directory named ${extensionnames[i]}  is already exists"
				else 
					mkdir ${extensionnames[i]} 
				fi
				
				for files in *.${extensionnames[i]}
				do
					if [ -f $files ]
					then
						mv $files ${extensionnames[i]}
						echo "$files is sorted and is moved to directory named ${extensionnames[i]}"
						if [ ${extensionnames[i]} == "txt" ]
						then
							cd ${extensionnames[i]}
							for files1 in *.${extensionnames[i]}
							do
								read -r firstline < $files1
								echo $firstline
								if [ -f $files1 ]
								then
								
									if [ -d $firstline ]
									then
										echo "Directory named $firstline  is already exists"
									else 
										mkdir $firstline 
									fi
									mv $files1 $firstline
									echo "$files1 is sorted and is moved to directory named $firstline"
								else 
									echo "There is no file to sort"	
								fi
								

							done
							cd ..
						fi
					else 
						echo "There is no file to sort"
					fi	
				done
			done	
		;;
	esac
	
	case $operation in 
		sendEMail)
			extensionname=$(zenity --entry --text "Enter your extension that you want to send:" --title "Write Extension To Send" --entry-text="");
			sendUser=$(zenity --entry --text "Enter the mail " --title "Write mail" --entry-text="");
			extensionnames=( $extensionname  )
			for (( i=0;i<${#extensionnames[@]};i++ ))
			do	
				if [ -d ${extensionnames[i]}  ]
				then
					
					cd ${extensionnames[i]}
					zip -r ${extensionnames[i]}.zip ./*
					mv ${extensionnames[i]}.zip ../
					cd ..
					swaks --to $sendUser -s smtp.gmail.com:587 -tls -au odevhesabi01@gmail.com -ap Ebois123 --header "Subject:Files that is wanted" --body "Files: " --attach ${extensionnames[i]}.zip 
					echo ${extensionnames[i]}.zip 
					rm ${extensionnames[i]}.zip
					
				else 
					echo "Directory named ${extensionnames[i]} doesn't exist"
				fi
			done
		;;
	esac
	
	case $operation in 
		getEmail)
			echo "$operation selected "
		;;
		
	esac
	
	#case $operation in 
	#	*)
	#		echo "Error"
	#	;;	
	#esac
done

