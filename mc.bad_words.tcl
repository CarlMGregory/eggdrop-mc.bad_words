##
#  BadWerds v1.11 by (Carl M. Gregory) MC_8 <gregory@worldinter.net>
#                                          !e`mail me bug reports!
##

##
# This script will kick and ban anyone in a specified room that mentions a certin word
# wildcards accepted!
#
# This script will only ban them if there is not a valid user with the flags you set
# below!
##

##
# HISTORY
# v1.10.1 (02.01.01)
#  MC_8 - Added SVS
#  MC_8 - Lawrence - Added warn_mode, to change user modes upon
#                    warning.
#
# v1.10 (08.14.00)
#  MC_8 - John Lange - Removed the ignore procedure.
#  MC_8 - Tcl error [mc:weed]: invalid command name "findip"
#  MC_8 - `Tcl error [mc:weed:act]: illegal channel: police' This assuming your bot's 
#         nick is police.  Happens on ACTIONs to the bot.
#
# v1.9 (04.08.00)
#  MC_8 - eggheads - Removed this script's dependency on moretools.
#  MC_8 - Removed the requirment of having to "quote" searches contaning spaces.
#
# v1.8.2 (02-07-00)
#  MC_8 - Speedo- - Fixed `set mc_time to -1 to turn off banning'
#  MC_8 - Speedo- - Fixed kicking procedure.
#
# v1.8.1 (01-14-00)
#  MC_8 - *search* found the word, but a search* or search would not find the badwerd, 
#         fixed.
#  MC_8 - Fixed the "duration ..." thing (showed up in the post via dcc), forgot the []'s
#
# v1.8 (01-03-00)
#  MC_8 - Processes messages from user X and processes them as if they were text said to the rooms,
#         witch would pull from global then channel bad werd list.
#         example:  say your rule for #warez4free is "*join #*" and #warez4warez is "*ratio*",
#                   and let's say user X in in #warez4free and in #warez4warez and /msg's the
#                   bot with " hey dude, join #blaboo " .. he will get booted from #warez4free
#                   but not from #warez4warez.
#         note: This function is optional, can be turned off if I confused the hell outa ya :P~  .
#  MC_8 - Added message to badwerds set, for all messages, this is processed before specific channel
#         badwerds are done.
#
# v1.7 (12-14-99)
#  MC_8 - Fixed %match display, was showing (if you know tcl) lindex %match 0, only taking
#         the first if there was a space in the search.
#
# v1.6 (12-05-99)
#  MC_8 - added %match veriable to warning message and kick message.
#  MC_8 - Malik - if you had NO global defined (regardless of wether or not it was empty) (in
#                 other words, you DELEATED global set) the whole script ceased to work, no
#                 error messages what so ever.   (-( Woo Hoo, Fixed! )-)
#
# v1.5 (11-22-99)
#  MC_8 - unknown - treating channel notice's as regular channel text.
#
# v1.4 (10-18-99)
#  MC_8 - m8s - now ban before kick (as opposed
#   to vice versa)
#  MC_8 - I fixed the bantype error (it was in moretools), anyhow, moretools 1.1.6 min. inst.
# 
# v1.3 (10-11-99)
#  MC_8 - m8s - found minor error in ban masking option, fixed.
#  MC_8 - added more options to the ban masking option.
#
# v1.0 - v1.2 (??-??-99)
#  MC_8 - Inital release - unknown (I didn't keep track I guess)
##

# Set this to the BAD words you don't want said by. 
# Wildcards NEEDED, if your bad word contain spaces... "quote it"!
# You can add as many channels as you would like (ie: set badwerds(#channel) { .. })
# If you want a bad word for ALL channels
# your bot is on, add it like this: 
# set badwerds(global) {
#  *badword*
#  "*anoter badword*"
# }
# look at the one I set below to get an idea :)
set badwerds(global) {
 *I love #chatzone*
}

set badwerds(message) {
}

set badwerds(#warez4free) {
 *irc://*
 *.htm*
 *www.*
 *h??p:/*
 *.to/*
 *.at/*
 *join #*
 *join ch*
 *com*#*
 *h ? ? p :*
 *channel*#*
 * /server*
}

set badwerds(#mp34free) {
 *irc://*
 *.htm*
 *www.*
 *h??p:/*
 *.to/*
 *.at/*
 *join #*
 *join ch*
 *com*#*
 *h ? ? p :*
 *channel*#*
 * /server*
}

set badwerds(#warez4warez) {
 *irc://*
 *.htm*
 *www.*
 *h??p:/*
 *.to/*
 *.at/*
 *join #*
 *join ch*
 *com*#*
 *h ? ? p :*
 *channel*#*
 * /server*
}

set badwerds(#wareznorth) {
 *irc://*
 *.htm*
 *www.*
 *h??p:/*
 *.to/*
 *.at/*
 *join #*
 *join ch*
 *com*#*
 *h ? ? p :*
 *channel*#*
 * /server*
 !list
 !search *
 @find *
 !find *
 @locator *
}

set badwerds(#chatzone) {
 *fuck*
 *sex*
 *ass*
 *pussy*
 *slut*
 *trick*
 *bitch*
 *nigger*
 *nigga*
 *fuk*
 *shit*
 *azz*
 *dick*
 *cunt*
 *hail hitler*
}

# This is the ban time (in MIN.s)
#  set this to 0 to not add a ban in bot's banlist, just put a ban on the server (|hellman|)
#  set to anything greater than 0 for actuall bot's ban time.
#  set to -1 to turn off banning (MC_8)
set mc_time 1440

# How many warnings do you want to give the person?  0 = no warnings (du hu :P~)
set bwerd(warn) 1

# What do you want to say on the warning message? (( %match == *the badwerd* ))
set bwerd(warn_msg) "This is a warning, watch what you say.) (%match"

# [0=no/1=yes] upon warning, do you want to kick em too?
set bwerd(warn_kick) 0

# What modes to you want to change on the user upon warning?
# If the channel is moderated, insted of kicking the person you can just -v him.
# Set this to "" to disable.
set bwerd(warn_mode) ""

# Set this to the flag the person is required to have
# i.e.: let's say someone is supposed to be a voicer, but someone forgot to voice him?? 
#       you don't want to kick that person just cuz of that!
# set it to "-" for any user in database, or specify the certing flag required... "mno" is 
# master,owner,op .. this goes with the new flag system
# set to "" to turn this feature off.
set mc_flags "ov|ov"

# Set this to the kick message you want to show.
set mc_warning "You should really watch what you say.) (%match"

# [0=no/1=yes] do you want it to kick op's of the room?
set bwerd(kickops) 0

# [0=no/1=yes] do you want it to kick voiced ppl in the room?
set bwerd(kickvoice) 0

# [0=no/1=yes] Do you want to process MSGs as they were channel text, to be evaluated
#              by channel bad werds list.
set bwerd(procmsg) 0

# [0=no/1=yes] do you want to strip color/bold/uline/rev. characters from test?
#  example: some ppl get past the kick/ban by .. puting this www.something.net
#           on mirc, that shows up as www.something.net, normal, but to the bot it's 
#           NOT *www.*, it's *www.*
set bwerd(strip) 1

# How do you want it to mask a ban?  Default == 2
#      0 - *!user@host.domain
#      1 - *!*user@host.domain
#      2 - *!*@host.domain
#      3 - *!*user@*.domain
#      4 - *!*@*.domain
#      5 - nick!user@host.domain
#      6 - nick!*user@host.domain
#      7 - nick!*@host.domain
#      8 - nick!*user@*.domain
#      9 - nick!*@*.domain
#     You can also specify a type of 10 to 19 which correspond to masks 0 to 9, but
#     instead of using a * wildcard to replace portions of the host.domain, it uses ?
#     wildcards to replace the numbers in the address.
set bad_mask 11

## MC SVS (Script Version Server) v1.1 ##
# Do you want the bot to connection to MC_8's SVS to see if there are newer versions
# of this script avilable?  It will only tell you -- It's up to you to get the newest
# version (I decided not to auto update the code, there may be new features in the
# newest script that may require your attention).
# 0=no/1=yes
set mc_bw(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_bw(svs:check) 0  ;#This is at Midnight
#  set mc_bw(svs:check) 5  ;#This is at 5am
#  set mc_bw(svs:check) 13  ;#This is at 1pm
#  set mc_bw(svs:check) 23  ;#This is at 11pm
set mc_bw(svs:check) 3

# Upon finding a newer version, who do you want to notify via note?
# Seperate each user with a " " (space).
set mc_bw(svs:notify) "MC_8"



## Coding below.

set badwerds(version) v1.11
set mc_bw(svs:script) "badwerds 001011000000"
set mc_bw(svs:server) "mc.purehype.net 8085"

proc mc:weed {nick uhost hand chan args} {
 global botnick badwerds mc_time mc_flags mc_warning bwerd bad_mask
 if {![isop $botnick $chan]} {return 0}
 if {[info exists badwerds(message)]} {set chanz "message"} {set chanz ""}
 if {[info exists badwerds(global)]} {set chanz "$chanz global"}
 if {[info exists badwerds([string tolower $chan])]} {set chanz "$chanz [string tolower $chan]"}
 if {[lindex $chanz 0] == ""} {return 0}
 if {!$bwerd(kickops)} {if {[isop $nick $chan]} {return 0}}
 if {!$bwerd(kickvoice)} {if {[isvoice $nick $chan]} {return 0}}
 set args [lindex $args 0]
 if {$bwerd(strip)} {set args [mc:bwerds:strip:all $args]}
 if {([info exists mc_flags]) && ($mc_flags != "")} {
  if {[lindex [split $mc_flags |] 1] == ""} {if {[matchattr $hand $mc_flags]} {return 0}} {
   if {[matchattr $hand $mc_flags $chan]} {return 0}
  }
 }
 foreach chant $chanz {
  foreach bad1 [split $badwerds($chant) \n] {
   if {[set bad1 [string trim $bad1 "\" "]] == ""} {continue}
   if {[string match [string tolower $bad1] [string tolower $args]]} {
    if {[mc:bwerd:warn $nick $uhost $bad1]} {
     if {$bwerd(warn_mode) != ""} {pushmode $chan $bwerd(warn_mode) $nick}
     if {$bwerd(warn_kick)} {
      putserv "KICK $chan $nick :[mc:bwerds:replace $bwerd(warn_msg) "{%match} {$bad1}"]"
     } ; putlog "$nick was warned for saying $bad1 in $chan" ; break
    }
    set ban [mc:bwerds:masktype $nick!$uhost $bad_mask]
    if {$mc_time != "-1"} {
     putlog "Auto banned $nick ($ban) for saing $bad1 in $chan ([duration [expr $mc_time*60]])"
     putserv "MODE $chan +b $ban"
     putserv "KICK $chan $nick :[mc:bwerds:replace $mc_warning "{%match} {$bad1}"]"
     if {$mc_time > 0} {
      newchanban $chan $ban Auto-Set [mc:bwerds:replace $mc_warning "{%match} {$bad1}"] $mc_time
     } ; break
    } {putserv "KICK $chan $nick :[mc:bwerds:replace $mc_warning "{%match} {$bad1}"]"}
   }
  }
 }
}

proc mc:weed:act {nick uhost hand chan key args} {
 global botnick bwerd
 if {($chan == $botnick) && $bwerd(procmsg)} {
  foreach chan [channels] {mc:weed $nick $uhost $hand $chan $args}
 } {mc:weed $nick $uhost $hand $chan $args}
}

proc mc:msgm:weed {nick uhost hand args} {
 global bwerd ; if {$bwerd(procmsg)} {
  foreach chan [channels] {mc:weed:msgm $nick $uhost $hand $chan $args}
 }
}

proc mc:weed:msgm {nick uhost hand chan args} {
 global botnick badwerds mc_time mc_flags mc_warning bwerd bad_mask
 if {[info exists badwerds(global)]} {set chanz "global"} {set chanz ""}
 if {[info exists badwerds([string tolower $chan])]} {set chanz "$chanz [string tolower $chan]"}
 if {[lindex $chanz 0] == ""} {return 0}
 if {!$bwerd(kickops)} {if {[isop $nick $chan]} {return 0}}
 if {!$bwerd(kickvoice)} {if {[isvoice $nick $chan]} {return 0}}
 if {$bwerd(strip)} {set args [mc:bwerds:strip:all $args]}
 if {([info exists mc_flags]) && ($mc_flags != "")} {
  if {[lindex [split $mc_flags |] 1] == ""} {if {[matchattr $hand $mc_flags]} {return 0}} {
   if {[matchattr $hand $mc_flags $chan]} {return 0}
  }
 }
 foreach chant $chanz {
  foreach bad1 [split $badwerds($chant) \n] {
   if {[set bad1 [string trim $bad1 "\" "]] == ""} {continue}
   if {[string match [string tolower $bad1] [string tolower $args]]} {
    if {[mc:bwerd:warn $nick $uhost $bad1]} {
     if {$bwerd(warn_mode) != ""} {pushmode $chan $bwerd(warn_mode) $nick}
     if {$bwerd(warn_kick)} {
      putserv "KICK $chan $nick :[mc:bwerds:replace $bwerd(warn_msg) "{%match} {$bad1}"]"
     } ; putlog "$nick was warned for saying $bad1 via PrivMSG" ; break
    }
    set ban [mc:bwerds:masktype $nick!$uhost $bad_mask]
    putlog "Auto banned $nick ($ban) for saing $bad1 via PrivMSG ([duration [expr $mc_time*60]])"
    putserv "MODE $chan +b $ban"
    putserv "KICK $chan $nick :[mc:bwerds:replace $mc_warning "{%match} {$bad1}"]"
    if {$mc_time > 0} {
     newchanban $chan $ban Auto-Set [mc:bwerds:replace $mc_warning "{%match} {$bad1}"] $mc_time
    } ; break
   }
  }
 }
}

proc mc:weed:raw:notc {from key args} {
 if {[string index [lindex $args 0] 0] == "#"} {
  set nick [string range $from 0 [expr [string first "!" $from]-1]]
  set uhost [string range $from [expr [string first "!" $from]+1] e]
  set chan [lindex [lindex $args 0] 0]
  set hand [nick2hand $nick $chan]
  set args "\{[string trimright [string range $args [expr [string first ":" $args]+1] e] \}]\}"
  mc:weed $nick $uhost $hand $chan $args
 } ; return 0
}

proc mc:bwerd:warn {nick uhost bad} {
 global bwerd
 if {[info exists bwerd($uhost)]} {incr bwerd($uhost) 1} {set bwerd($uhost) 1}
 if {[expr $bwerd(warn)+1] <= $bwerd($uhost)} {unset bwerd($uhost) ; return 0}
 puthelp "PRIVMSG $nick :[mc:bwerds:replace $bwerd(warn_msg) "{%match} {$bad}"]"
# -=> \[Warning $bwerd($uhost) of $bwerd(warn)\]
 return 1
}

foreach chan [array names badwerds] {
 if {([string index $chan 0] == "#") && ([string tolower $chan] != $chan)} {
  set badwerds([string tolower $chan]) $badwerds($chan)
  unset badwerds($chan)
 }
}

proc mc:bwerds:strip:color {ar} {
 set argument ""
 if {![string match ** $ar]} {return $ar} ; set i -1 ; set length [string length $ar]
 while {$i < $length} {
  if {[string index $ar $i] == ""} {
   set wind 1 ; set pos [expr $i+1]
   while {$wind < 3} {
    if {[string index $ar $pos] <= 9 && [string index $ar $pos] >= 0} {
     incr wind 1 ; incr pos 1} {set wind 3
    }
   }
   if {[string index $ar $pos] == "," && [string index $ar [expr $pos + 1]] <= 9 &&
       [string index $ar [expr $pos + 1]] >= 0} {
    set wind 1 ; incr pos 1
    while {$wind < 3} {
     if {[string index $ar $pos] <= 9 && [string index $ar $pos] >= 0} {
      incr wind 1 ; incr pos 1} {set wind 3
     }
    }
   }
   if {$i == 0} { 
    set ar [string range $ar $pos end] 
    set length [string length $ar] 
   } { 
    set ar "[string range $ar 0 [expr $i - 1]][string range $ar $pos end]" 
    set length [string length $ar] 
   }
   set argument "$argument[string index $ar $i]"
  } {incr i 1}
 }
 set argument $ar
 return $argument
}

proc mc:bwerds:strip:bold {ar} {
 set argument ""
 if {[string match ** $ar]} {
  set i 0
  while {$i <= [string length $ar]} { 
   if {![string match  [string index $ar $i]]} { 
    set argument "$argument[string index $ar $i]"
   } ; incr i 1
  }
 } {set argument $ar}
 return $argument
}

proc mc:bwerds:strip:uline {ar} {
 set argument ""
 if {[string match ** $ar]} {
  set i 0
  while {$i <= [string length $ar]} { 
   if {![string match  [string index $ar $i]]} { 
    set argument "$argument[string index $ar $i]"
   } ; incr i 1
  }
 } {set argument $ar}
 return $argument
}

proc mc:bwerds:strip:reverse {ar} {
 set argument ""
 if {[string match ** $ar]} {
  set i 0
  while {$i <= [string length $ar]} { 
   if {![string match  [string index $ar $i]]} { 
    set argument "$argument[string index $ar $i]"
   } ; incr i 1
  }
 } {set argument $ar}
 return $argument
}

proc mc:bwerds:strip:all {ar} {
 return [mc:bwerds:strip:reverse [mc:bwerds:strip:uline [mc:bwerds:strip:bold [mc:bwerds:strip:color $ar]]]]
}

proc mc:bwerds:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 } ; return $string
}

proc mc:bwerds:masktype {uhost type} {
 if {![string match "*!*@*.*" $uhost]} {
  set nick [lindex [split $uhost "!"] 0] ; set uhost "$nick![getchanhost $nick]"
  if {$uhost == "$nick!"} {set type "return_nothing"}
 }
 switch -exact $type {
  0 {set ban "*[string range $uhost [string first ! $uhost] e]"}
  1 {set ban "*!*[string trimleft [string range $uhost [expr [string first ! $uhost]+1] e] "~"]"}
  2 {set ban "*!*[string range $uhost [string first @ $uhost] e]"}
  3 {
   set ident [string range $uhost [expr [string first ! $uhost]+1] [expr [string last @ $uhost]-1]]
   set ban "*!*[string trimleft $ident "~"][string range [maskhost $uhost] [string first @ [maskhost $uhost]] e]"
  }
  4 {set ban "*!*[string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"}
  5 {set ban $uhost}
  6 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
   set ban "$nick!*[string trimleft $ident "~"][string range $uhost [string last "@" $uhost] e]"
  }
  7 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ban "$nick!*[string range $uhost [string last "@" $uhost] e]"
  }
  8 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
   set ban "$nick!*[string trimleft $ident "~"][string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"
  }
  9 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ban "$nick!*[string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"
  }
  10 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:bwerds:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
    set ban "*!$ident$host"
   } {set ban [mc:bwerds:masktype $uhost 0]}
  }
  11 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:bwerds:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
    set ban "*!*[string trimleft $ident "~"]$host"
   } {set ban [mc:bwerds:masktype $uhost 1]}
  }
  12 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:bwerds:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ban "*!*$host"
   } {set ban [mc:bwerds:masktype $uhost 2]}
  }
  13 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:bwerds:masktype $uhost 11]} {set ban [mc:bwerds:masktype $uhost 3]}
  }
  14 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:bwerds:masktype $uhost 12]} {set ban [mc:bwerds:masktype $uhost 4]}
  }
  15 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:bwerds:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest [string range $uhost 0 [expr [string last "@" $uhost]-1]]
    set ban $rest$host
   } {set ban [mc:bwerds:masktype $uhost 5]}
  }
  16 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:bwerds:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest "[string range $uhost 0 [expr [string first "!" $uhost]-1]]!*[string trimleft [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]] "~"]"
    set ban $rest$host
   } {set ban [mc:bwerds:masktype $uhost 6]}
  }
  17 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:bwerds:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest "[string range $uhost 0 [expr [string first "!" $uhost]-1]]!*"
    set ban $rest$host 
   } {set ban [mc:bwerds:masktype $uhost 7]}
  }
  18 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:bwerds:masktype $uhost 16]} {set ban [mc:bwerds:masktype $uhost 8]}
  }
  19 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:bwerd:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:bwerds:masktype $uhost 17]} {set ban [mc:bwerds:masktype $uhost 9]}
  }
  return_nothing {set ban ""}
  default {set ban "*!*[string range $uhost [string first "@" $uhost] e]"}
 }
 set _nick [lindex [split $ban !] 0]
 set _ident [string range $ban [expr [string first ! $ban]+1] [expr [string last @ $ban]-1]]
 set _host [string range $ban [expr [string last @ $ban]+1] e]
 if {$_ident != [set temp [string range $_ident [expr [string length $_ident]-9] e]]} {
  set _ident *[string trimleft $temp *]
 }
 if {$_host != [set temp [string range $_host [expr [string length $_host]-63] e]]} {
  set _host *[string trimleft $temp *]
 } ; return $_nick!$_ident@$_host
}
proc mc:bwerd:inter:findip {args} {
 catch {unset mc_found_ip}
 if {![string match *.*.*.* $args]} {return 0}
 foreach arg $args {
  if {[string match *.*.*.* $arg]} {
   set mc_testa [split $arg "."] ; set i 0
   while {[llength $mc_testa] != $i} {
    set mc_test [lrange $mc_testa $i end]
    if {[string length [lindex $mc_test 1]]<4 && [string length [lindex $mc_test 2]]<4} {
     if {[lindex $mc_test 1] < 256 && [lindex $mc_test 2] < 256 && [lindex $mc_test 1] >= 0 && [lindex $mc_test 2] >= 0} {
      set first "abcdefghi"
      if {[string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 1]] <= 9 && [string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 1]] >= 0} {
       set first [string range [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 1] end]
       if {[string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 2]] <= 9 && [string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 2]] >= 0} {
        set first [string range [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 2] end]
        if {[string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 3]] <= 9 && [string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 3]] >= 0} {
         set first [string range [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 3] end]
        }
       }
      }
      set second [lindex $mc_test 1] ; set third [lindex $mc_test 2] ; set fourth "abcdefghi"
      if {[string index [lindex $mc_test 3] 0] <= 9 && [string index [lindex $mc_test 3] 0] >= 0} {
       set fourth [string index [lindex $mc_test 3] 0]
       if {[string index [lindex $mc_test 3] 1] <= 9 && [string index [lindex $mc_test 3] 1] >= 0} {
        set fourth $fourth[string index [lindex $mc_test 3] 1]
        if {[string index [lindex $mc_test 3] 2] <= 9 && [string index [lindex $mc_test 3] 2] >= 0} {
         set fourth $fourth[string index [lindex $mc_test 3] 2]
        }
       }
      }
      if {($first < 256) && ($second < 256) && ($third < 256) &&
          ($fourth < 256) && ($first > 0) && ($second > 0) &&
          ($third > 0) && ($fourth > 0) && ([string index $first 0] > 0) &&
          ([string index $second 0] > 0) && ([string index $third 0] > 0) &&
          ([string index $fourth 0] > 0)} {
       if {[info exists mc_found_ip]} {
        set mc_found_ip "$mc_found_ip $first.$second.$third.$fourth"
       } {set mc_found_ip $first.$second.$third.$fourth}
      }
     }
    } ; incr i +1
   }
  }
 } ; if {[info exists mc_found_ip]} {return $mc_found_ip} {return 0}
}

bind pubm - * mc:weed
bind ctcp - ACTION mc:weed:act
bind raw - NOTICE mc:weed:raw:notc
bind msgm - * mc:msgm:weed

if {$mc_bw(svs:enabled)} {
 if {($mc_bw(svs:check) > "23") || ($mc_bw(svs:check) < "0")} {set mc_bw(svs:check) 00}
 if {[string length $mc_bw(svs:check)] == "1"} {set mc_bw(svs:check) 0$mc_bw(svs:check)}
 bind time - "00 $mc_bw(svs:check) * * *" mc:bw:svs:time
 proc mc:bw:svs:time {min hour day month year} {
  global mc_bw
  catch {control [connect [lindex $mc_bw(svs:server) 0] [lindex $mc_bw(svs:server) 1]] mc:bw:svs:interface}
 }
}
proc mc:bw:svs:interface {idx args} {
 global mc_bw;set args [join $args]
 switch -- [lindex $args 0] {
  "" {return 1}
  000 {putdcc $idx q}
  002 {putdcc $idx [lindex $mc_bw(svs:script) 0]}
  003 {
   set args [lrange $args 1 e]
   if {[lindex $args 0] != [lindex $mc_bw(svs:script) 0]} {return 0}
   if {[lindex $args 1] > [lindex $mc_bw(svs:script) 1]} {
    set note [mc:bw:svs:replace [lindex $args 7] "%0 {[lindex $args 0]} %1 {[lindex $args 1]} %2 {[lindex $args 2]}"]
    set note [mc:bw:svs:replace $note "%3 {[lindex $args 3]} %4 {[lindex $args 4]} %5 {[lindex $args 5]}"]
    set note [mc:bw:svs:replace $note "%6 {[lindex $args 6]} %8 {[lindex $args 8]} %version {$mc_bw(version)}"]
    set note [mc:bw:svs:replace $note "%9 {[lindex $args 9]} %10 {[lindex $args 10]} %11 {[lindex $args 11]}"]
    set note [mc:bw:svs:replace $note "%12 {[lindex $args 12]} %13 {[lindex $args 13]} %14 {[lindex $args 14]}"]
    set note [mc:bw:svs:replace $note "%15 {[lindex $args 15]} %16 {[lindex $args 16]} %17 {[lindex $args 17]}"]
    set note [mc:bw:svs:replace $note "%18 {[lindex $args 18]} %19 {[lindex $args 19]} %20 {[lindex $args 20]}"]
    foreach notify [join [split $mc_bw(svs:notify) ",;"]] {
     switch -- [sendnote SVS $notify [mc:bw:svs:replace $note "%nick {$notify}"]] {
      0 {putlog "MC SVS for [lindex $mc_bw(svs:script) 0] had some errors updating $notify on current version of script; unknown reason!"}
      3 {putlog "MC SVS for [lindex $mc_bw(svs:script) 0] had some errors updating $notify on current version of script; notebox too full!"}
     }
    }
   } ; putdcc $idx q
  }
 } ; return 0
}
proc mc:bw:svs:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 } ; return $string
}

putlog "BadWerds $badwerds(version) by MC_8 loaded."
