#!/bin/bash

. bot.properties
input=".bot.cfg"
echo "Starting session: $(date "+[%y:%m:%d %T]")">$log 
echo "NICK $nick" > $input 
echo "USER $user" >> $input
echo "JOIN #$channel" >> $input

  #identify
     ;;
    *"This nickname is registered and protected."*) 
     echo "PRIVMSG NICKSERV :IDENTIFY $password" >> $input 



tail -f $input | telnet $server 6667 | while read res
do
  # log the session
  echo "$(date "+[%y:%m:%d %T]")$res" >> $log
  # do things when you see output
  case "$res" in
    # respond to ping requests from the server
    PING*)
      echo "$res" | sed "s/I/O/" >> $input 
    ;;
    # for pings on nick/user
    *"You have not"*)
      echo "JOIN #$channel" >> $input
    ;;
    # run when someone joins
    *JOIN*) who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
      if [ "$who" = "$nick" ]
      then
       continue 
      fi
      #resposnses to msgs----------------------------------------------------
    ;;
    *"PRIVMSG #$channel :hello Rebel_Joe"*)
     echo "PRIVMSG #$channel :HI Rebel!" >> $input 
    ;; 
    #responses end-----------------------------------------------------------
    # run when a message is seen
    *PRIVMSG*)
    # run when a message is seen
    *PRIVMSG*)
      echo "$res"
      who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
      from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) $
      # "#" would mean it's a channel
      if [ "$(echo "$from" | grep '#')" ]
      then
        test "$(echo "$res" | grep ":$nick:")" || continue
        will=$(echo "$res" | perl -pe "s/.*:$nick:(.*)/\1/")
      else
        will=$(echo "$res" | perl -pe "s/.*$nick :(.*)/\1/")
        from=$who
      fi
      will=$(echo "$will" | perl -pe "s/^ //")
      com=$(echo "$will" | cut -d " " -f1)
      if [ -z "$(ls modules/ | grep -i -- "$com")" ] || [ -z "$com" ]
      from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) $
      # "#" would mean it's a channel
      if [ "$(echo "$from" | grep '#')" ]
      then
        test "$(echo "$res" | grep ":$nick:")" || continue
        will=$(echo "$res" | perl -pe "s/.*:$nick:(.*)/\1/")
      else
        will=$(echo "$res" | perl -pe "s/.*$nick :(.*)/\1/")
        from=$who
      fi
      will=$(echo "$will" | perl -pe "s/^ //")
      com=$(echo "$will" | cut -d " " -f1)
      if [ -z "$(ls modules/ | grep -i -- "$com")" ] || [ -z "$com" ]
      then
        ./modules/help/help.sh $who $from >> $input
        continue
      fi
      ./modules/$com/$com.sh $who $from $(echo "$will" | cut -d " " -f2-$
    ;;
    *)
      echo "$res"
    ;;
  esac
done

