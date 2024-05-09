#! /bin/bash

if [ $# -ne 3 ]
then
	echo "usage : ./OSS-project1.sh teams.csv player.csv matches.csv"
	exit 1
fi
echo "*********OSS1 - Project1*********"
echo "*     Student ID : 12201723     *"
echo "*     Name : Moon Dong Hyun     *"
echo "*********************************"

while true
do
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club,Appearances, Goals, Assists in players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in mateches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
	echo "7. Exit"
	read -p "Enter your CHOICE(1~7) : " choice
	case "$choice" in 
		1 )
			read -p "Do you want to get the Heung-Min Son's data? (y/n) : " yes 
			if [ "$yes" = "y" ]
			then
				cat $2 | awk -F, '$1=="Heung-Min Son"{printf("Team:%s,Apperance:%d,Goal:%d,Assist:%d\n",$4, $6, $7, $8)}' 
			else
				continue;
			fi
			;;
		2 )
			read -p "What do you want to get the team data of league_position[1~20]: " t
			cat $1 | awk -F, -v a=$t '$6==a{printf("%s %s %f\n",$6,$1,$2/($2+$3+$4))}'
			;;
		3 ) 
			read -p "Do you want to know Top-3 attendance data? (y/n) : " y
			if [ "$y" = "y" ]
			then
			echo "***Top-3 Attendance Match***"
			cat $3 | sort -t, -nr -k 2 | head -n 3 | awk -F, '{printf("\n\n%s vs %s (%s)\n%d %s\n\n",$3,$4,$1,$2,$7)}' 
			echo " "
			else
				continue	
			fi
			;;
		4 )
			read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " y
			if [ "$y" = "y" ]
			then	
				OIFS="$IFS"
				IFS=:
				val=0
				for var in $(cat $1 | sort -t, -n -k 6 | awk -F, '{print $1":"}');
				do
				 	if [ $val -eq 0 ]
					then
						val=$((val + 1))
						continue
					fi
				
					
					echo "$val $var"| tr -d "\n"
					cat $2 | grep -w "~${var}" | LC_ALL=C sort -t, -nr -k 7 | head -n 1 | awk -F, '{printf("\n%s %s\n\n",$1,$7)}' 
				       	val=$(( val + 1 ))	
				done
				IFS="$OIFS"
			else
				continue
			fi
			;;
		5 )
			read -p "Do you want to modify the format of date? (y/n) :" y
			if [ "$y" = "y" ]
			then
				cat $3 | cut -d, -f1 | sed '1d' | sed -E -e 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/' | sed -E -e 's/([0-9]{2}) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}):([0-9]{2})([ap]m)/\3\/\1\/\2 \4:\5\6/'
			else
				continue
			fi	
			;;
		6 )
			OIFS="$IFS"
			PS3="Enter your team number : "
			IFS=":"
			select var in  $( cat $1 | sed '1d'  | awk -F, '{print$1":"}'| tr -d "\n" )
			
			do
				val=$(cat $3 | awk -F, -v c=$var '$3==c&&$5>$6{print $5-$6, $0}' | sort -t, -nr -k 1 | head -n 1 |awk '{print$1}')
			        cat $3 | awk -F, '{print $5-$6, $0}' | sort -nr -k 1| awk -v b=$val '$1==b{print}' | cut -d' ' -f2- | sort -n -k 3 | sort -n -k 2 | awk -F, -v a=$var  '$3==a{printf("\n%s\n%s %d vs %d %s\n\n",$1,$3,$5,$6,$4)}'
				break;
			done	
			IFS="$OIFS"
			;;
		7 )
			break;;
	esac
done



