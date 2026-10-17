##
# Bad Words v3.0.1 by (Carl M. Gregory) MC_8 <gregory@worldinter.net>
#  This script will only work with eggdrop 1.5 and up only.
#
# If you have any questions/comments/idea's, please email me!
# ( Include the script name and version in the title, if you do email me. )
#
# My SVS Website - http://mc.purehype.net:81/
##

##
# This script will kick and ban anyone in a specified room that mentions a
# certin word wildcards accepted!
##

##
# HISTORY
##
# v3.0.1 (10.30.01)
#  MC_8 - Rewrote explination of ban masking types.
#  MC_8 - Rewrote the ban masking proc again, much smaller now.
#  MC_8 - Ban types 10-19 were not masking the host.domain correctly if it
#         was an ip address.
#  MC_8 - Ban type 3, 4, 8 and 9 wasn't masking the host correctly.
#  MC_8 - Morpheus233 - Ban types 10-19 were giving tcl errors.  'TCL error
#                       [mc:bw:pubm]: syntax error in expression "[regexp --
#                       {^1[0-9]$} $type] &&', fixed.
#  MC_8 - Added share:flag configuration option.
#  MC_8 - Morpheus233, Daniel - Fixed 'TCL error [mc:bw:pubm]: can't read 
#                               "channel": no such variable'.
#  MC_8 - Dr.W95 - Added warn_msgtype configuration option.
#  MC_8 - Made minor changes to the SVS client section -- to give proper
#         error if an invalid user is specified to recieve a notification
#         of a newer version.
#  MC_8 - Remove *inter:str proc, replaced with format's insted (more 
#         efficient).
#  MC_8 - Rewrote the ban masking proc, it's quicker.
#  MC_8 - Removed the findip proc.
#
# v3.0 (10.14.01)
#  MC_8 - Added prompt interfact for +(bad|exempt)word.
#  MC_8 - Bots were flooding "U" on load via botnet link.
#  MC_8 - Bot was getting flooded down with utimers.
#  MC_8 - Entrie expire time wasn't working.
#  MC_8 - Added dcc commands; exemptwords, +exemptword, -exemptword
#  MC_8 - ckitt - Fixed 'invalid command name ...' dealing with  '("1-2" 
#                 arm line 1)' (part of the db auto conversion).
#  MC_8 - Added catches to not put a kick (nor ban) on the channel if the
#         user (or banmask) isn't on the channel, saves bandwidth and also
#         makes the listed 'Actions:' performed smaller.
#  MC_8 - ckitt - Relay kick message has a prepending ':' that shouldn't be
#                 there.
#  MC_8 - ckitt - Added ability to share badwords entries among the botnet.
#  MC_8 - Since expire, last used, and warnings are now used per entry, the
#         database version has changed to v2.  I coded in an auto db 
#         converter to convert v1 to v2.
#  MC_8 - Added last used visual.
#  MC_8 - Added expire option.
#  MC_8 - After exceeding warnings the bot was starting warning's over 
#         again at 0, for the user -- fixed.
#  MC_8 - Fixed `TCL error [mc:bw:???]: illegal channel: <bots irc nick>`.
#         This error doesn't occure on undernet, was found on dalnet.
#  MC_8 - If bantime was set to -1, it wasn't kicking as well.  Fixed.
#  MC_8 - It is no longer manditory to quote the *bad*string* upon removal
#         if it contains a space.
#  MC_8 - It now gives a better explination of what actions were taken
#         upon catching a violator.
#  MC_8 - ckitt - Added botnet relay features.
#  MC_8 - Fixed special character handling for bad word strings.
#  MC_8 - Change kickop and kickvoice to exemptop and exemptvoice.
#  MC_8 - ckitt - Wasn't kicking after setting a ban for bad word match
#                 on private (notice/ msg/ action)'s.
#  MC_8 - ckitt - Further adjusted replacment veriable messages.
#  MC_8 - ckitt - On &global and &message's, the %channel replacment
#                 veriable was looking like "%channelglobal".  Fixed.
#  MC_8 - ckitt - The bot was kicking before banning -- I put kicks and
#                 bans on the same que (putserv).
#  MC_8 - ckitt - Fixed 'TCL error [mc:bw:pubm]: invalid command name
#                 "mc:bwerd:inter:findip"'
#  MC_8 - ckitt - Fixed documentation about chanset flags.
#  MC_8 - Dcc command wasn't recognizing option "all".
#  MC_8 - Changed the scripts name from Bad Werds to Bad Words.
#  MC_8 - To many changes to document -- I rewrote the entire script.
#
# v2.0 (06.27.01)
#  MC_8 - Sara - Added a few examples within the command syntax layout.
#  MC_8 - ICU - Fixed +/-badword dcc command requirment for the *bad*word*.
#  MC_8 - Rami - Fixed `Tcl error [mc:msgm:weed]: wrong # args: should be
#                "foreach varList list ?varList list ...? command"`
#  MC_8 - KatzEye - Added ability to have perm bans, insted of timed bans.
#  MC_8 - KatzEye - Added ability to have the ban's global or channel 
#                   specific.
#  MC_8 - Updated SVS to v1.2
#  MC_8 - Made the badword strings settable via dcc (on the fly) rather
#         than editing them within the script.
#
# v1.11 (01.31.01)
#  (( Opps, forgot to log history changes for this version. ))
#
# v1.10.1 (02.01.01)
#  MC_8 - Added SVS
#  MC_8 - Lawrence - Added warn_mode, to change user modes upon
#                    warning.
#
# v1.10 (08.14.00)
#  MC_8 - John Lange - Removed the ignore procedure.
#  MC_8 - Tcl error [mc:weed]: invalid command name "findip"
#  MC_8 - `Tcl error [mc:weed:act]: illegal channel: police' This assuming
#         your bot's nick is police.  Happens on ACTIONs to the bot.
#
# v1.9 (04.08.00)
#  MC_8 - eggheads - Removed this script's dependency on moretools.
#  MC_8 - Removed the requirment of having to "quote" searches contaning 
#         spaces.
#
# v1.8.2 (02-07-00)
#  MC_8 - Speedo- - Fixed `set mc_time to -1 to turn off banning'
#  MC_8 - Speedo- - Fixed kicking procedure.
#
# v1.8.1 (01-14-00)
#  MC_8 - *search* found the word, but a search* or search would not find 
#         the badword, fixed.
#  MC_8 - Fixed the "duration ..." thing (showed up in the post via dcc), 
#         forgot the []'s
#
# v1.8 (01-03-00)
#  MC_8 - Processes messages from user X and processes them as if they were
#         text said to the rooms, witch would pull from global then channel
#         bad werd list.
#         example:  say your rule for #warez4free is "*join #*" and 
#                   #warez4warez is "*ratio*", and let's say user X in in
#                   #warez4free and in #warez4warez and /msg's the bot with
#                   " hey dude, join #blaboo " .. he will get booted from
#                   #warez4free but not from #warez4warez.
#         note: This function is optional, can be turned off if I confused
#               the hell outa ya :P~  .
#  MC_8 - Added message to badwords set, for all messages, this is 
#         processed before specific channel badwords are done.
#
# v1.7 (12-14-99)
#  MC_8 - Fixed %match display, was showing (if you know tcl) lindex 
#         %match 0, only taking the first if there was a space in the 
#         search.
#
# v1.6 (12-05-99)
#  MC_8 - added %match veriable to warning message and kick message.
#  MC_8 - Malik - if you had NO global defined (regardless of wether or not
#                 it was empty) (in other words, you DELEATED global set) 
#                 the whole script ceased to work, no error messages what 
#                 so ever.   (-( Woo Hoo, Fixed! )-)
#
# v1.5 (11-22-99)
#  MC_8 - unknown - treating channel notice's as regular channel text.
#
# v1.4 (10-18-99)
#  MC_8 - m8s - now ban before kick (as opposed
#   to vice versa)
#  MC_8 - I fixed the bantype error (it was in moretools), anyhow,
#         moretools 1.1.6 min. inst.
# 
# v1.3 (10-11-99)
#  MC_8 - m8s - found minor error in ban masking option, fixed.
#  MC_8 - added more options to the ban masking option.
#
# v1.0 - v1.2 (??-??-99)
#  MC_8 - Inital release - unknown (I didn't keep track I guess)
##

##
# COMMANDS (dcc)
##
# +badword [[#channel|&message|&global] <*bad*string*> [#warnings] [%expire <XdXhXm>] <kick/warning message>]
#  This will add a bad word string, such as "*every*goto*http://*".
#  EXAMPLES: .+badword #eggdrop *i*want*free*shell* Do not ask about free shells, against rules.
#              This will add *i*want*free*shell* to #eggdrop's badword 
#              list, the warning and kick message will be "Do not ask for 
#              free shells, against rules". Whatever you set below in the 
#              settings.
#            .+badword *MC_8*sucks* MC Rocks
#              This will add *MC_8*sucks* to the global badword list, the
#              warning/kick message will be "MC Rocks".
#            .+badword &global *MC_8*sucks* No he doesn't.
#              This will add *MC_8*sucks* to the global badword list as 
#              well, the warning/kick message will be "No he doesn't.".
#            .+badword &message * #3 Don't message me!
#              This will give 3 warnings before issuing a ban. If you don't
#              specify number of warnings, it will default to 0 (none).
#            .+badword &message * %1d3h14m Don't message me!
#              This will expire the badword restriction after 1 day, 2 
#              hours and 14 min's.
#            .+badword
#              This will start the +badword prompt interface.
#
# -badword [<#>channel|&message|&global] <*bad*string*>
#  This will remove a bad word string.
#
# badwords [<#>channel|&message|&global|all]
#  This will view bad word strings.
#
# +exemptword [[#channel|&message|&global] <*exempt*string*> [%expire <XdXhXm>]]
#  This will add an exempt word string, such as "*every*goto*http://*".
#  EXAMPLES: .+exemptword &message "op *"
#              This will exempt all private messages (msg/ action/ notice)
#              that start with op.  You might want to exempt all message 
#              commands such as ident, op, voice, help and so on.
#            .+exemptword #abc123 "!vote *" %1d
#              This exempts all messages to #abc123 that starts with !vote,
#              it will expire in  day.
#            .+exemptword
#              This will start the +exemptword prompt interface.
#
# -exemptword [<#>channel|&message|&global] <*exempt*string*>
#  This will remove an exempt word string.
#
# exemptwords [<#>channel|&message|&global|all]
#  This will view exempt word strings.
#
# chanset <#channel> <+/->mc.bw.exemptvoice
#  Do you want the script to exempt users whom are voiced in #channel,
#   that is, if there in violation of saying a bad word?
#  You can set each channel different, set to -exemptvoice for no, and
#   +exemptvoice for yes.
#
# chanset <#channel> <+/->mc.bw.exemptop
#  Do you want the script to exempt users whom are opped in #channel,
#   that is, if there in violation of saying a bad word?
#  You can set each channel different, set to -exemptop for no, and
#   +exemptop for yes.
#
# chattr <bot> +B [channel]
#  You can share your badwords entries with other bot's, the bots you
#  want to share with must have the +B flag, must be added and linked,
#  and must all have this script loaded.  You can share specific channel
#  if you like, just submit the channel in the above syntax.  Having
#  no channel will make it a global share -- everything is shared with
#  that bot.
#   NOTE: Please note that %message and %global are sent threw the shared
#         pipe as globals, to be shared only with those whom are setup for
#         global badwords sharing.  Entries never overwrite themselves.
#   NOTE: For better usefullness, there is no agressive and passive sharing
#         involved in this.  However, keep in mind, if one of the shre bots
#         are not linked and you do a .-badword; the bot that's not linked
#         will never know you removed it.  It's the same way with ban.
#   NOTE: The flag 'B' is changable, incase 'B' conflicts with some other
#         script. 
#  
#
# Usefull information:
#  - If your adding a *bad*string* (or *exempt*string*) that contains a 
#    space, "quote it".
#  - If your adding a *bad*string* (or *exempt*string*) that contains a
#    " (quotation mark) it's self, escape it.
#    ie *bad*\"word\"*   (to \ it is to escape it)
#  - The kick/warning message can have the following replacment veriables:
#    %channel == Channel it's for (&global/ &message/ #a_channel)
#    %method  == Method used (action/ msg/ notice/ pub).
#    %string  == The *ban*string* that was triggered by the user.
#    %add     == Who this was added by.
#      Example:  %add said not to say %string in %channel!
#  - *bad*string*'s (and *exempt*string*'s) don't bother with case 
#    sensativity.
#  - Avilable wildcards for the *bad*string*'s (and *exempt*string*'s) are:
#     *       = Matches any sequence of characters in string, including a 
#               null string. 
#     ?       = Matches any single character in string. 
#     [chars] = Matches any character in the set given by chars. If a 
#               sequence of the form x-y appears in chars, then any 
#               character between x and y, inclusive, will match.  Whereas
#               [a-mr-z] matches any character between a and m, inclusive, 
#               or matches any character between r and z, inclusive.
##

##
# Settings
##
#

# What flaged users should only be allowed to perform the dcc commands?
# Flag format:  <global>|<channel>
set mc_bw(access) "m|m"

# The script will hold bad words information in a database file, what do
# you want to call this database file?
set mc_bw(database) ".badwords.dat"

# What flaged users are exempt from this script?
# Set this setting to "" to exempt no one from this script.
# Flag format:  <global>|<channel>
set mc_bw(exempt) "b|"

# How do you want to send warning messages?
#    0 = Private message to the offender.
#    1 = Private notice to the offender.
#    2 = Public message in the channel of the offender.
set mc_bw(warn_msgtype) 0

# [0=no/1=yes] Upon warning, do you want to kick the user?
set mc_bw(warn_kick) 0

# Upon warning, what modes to you want to change on the user?
# Example:  If the channel is moderated, insted of kicking the person
#           you can just -v him (removing his voice to speak in the 
#           channel).
# To disable this feature, set this to "".
# Replacment veriables:
#  %botnick == The bot's nick.
#  %nick    == The person's nick in violation.
#
# Example:
#  set mc_bw(warn_mode) "-v+mv %nick %botnick"
set mc_bw(warn_mode) ""

# This is the ban time (in MIN.s)
#  -2 = PERM ban (no expiration in bot records)
#  -1 = Will not ban.
#   0 = Performs a server ban, but doesn't store the ban in the bot's ban 
#       list.
#  Any number greater than 0 will be the time in witch the ban will expire.
#  All ban's will be channel ban's, if you want it to be a global ban -- 
#  put a "@" infront of the time.  Ie. set mc_bw(bantime) @1440
set mc_bw(bantime) 1440

# [0=no/1=yes] Do you want to process messages and notices directed
#  to the bot as if they were channel text, to be evaluated by channel
#  bad werds list?
set mc_bw(procmsg) 0

# [0=no/1=yes] Do you want to strip color/bold/underline/reverse characters
#  from the public text before evaluating?
#  example: Some users get past the kick/ban by puting doing 
#           www.something.net on mIRC.  That shows up as www.something.net
#           to the human eye on an mIRC client, but to the bot it's NOT 
#           *www.*, it's *www.*.
set mc_bw(strip) 1

# Upon issuing a ban, how do you want it to mask the ban?
#  Default == 5
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
#     You can also specify a type of 10 to 19 which correspond to masks 0 
#     to 9.  But if the host.domain is a;
#       hostname = Instead of using a * wildcard to replace portions of the
#                  host.domain, it replaces the numbers in the host.domain 
#                  with a '?' (question mark) wildcard
#       ip       = It will mask as normal, with no '?' (question mark)
#                  replacments as does hostname.
set mc_bw(banmask) 11

# What flag should the script use to designate another bot as sharing
# with this script?  This has nothing to do with the 2 relay settings
# below.  If you don't know what this is, don't mess with it.  This setting
# is here just incase another script uses the 'B' flag (as not not conflict).
# Valid flags here can be A threw Z (capital letters ONLY!).
set mc_bw(share:flag) "B"

# [0=no/1=yes] Upon the bot recieving a badword match sent via private 
# (notices/ actions/ msgs), if the bot is not op'd in certin channels... do
# you want the script to have anoter bot op handle the warn/bans of the 
# user?
# Note:  The other bots have to be linked, they have to use mc.badwords 
#        also, and they have to have the mc_bw(relay:rx) option enabled.
# Note:  For security reasons, the bot will never transmit any mode changes
#        upon other than +b (ban).
set mc_bw(relay:tx) 1

# [0=no/1=yes] As with the setting above, do you want to recieve others' 
# relay messages and process them?  If you set it to 0, it will just ignore
# the other bot's when they ask the botnet to ban the user for saying a 
# badword.
# Note:  For security reasons, the bot will never perform any mode changes 
#        upon recieving a transmit other than +b (ban).
set mc_bw(relay:rx) 1

# Set a key, this key can be whatever you want -- only scripts with the 
# same key can interact with one another (provided relay:rx and relay:tx, 
# above) are enabled.
set mc_bw(relay:key) "BlaBlaBlaBla"

## MC SVS (Script Version Service) v1.3 ##
# [0=no/1=yes] Do you want the script to auto connect to MC_8's SVS 
# (Script Version Service) to see if there is a newer version of this 
# script avilable?  It will only tell you if there is a newer version,
# it's up to you to get the newest version. I decided not to auto update
# the code, there may be new features in the newest script that may 
# require your attention.
set mc_bw(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_bw(svs:check) 0   ;#This is at Midnight
#  set mc_bw(svs:check) 5   ;#This is at 5am
#  set mc_bw(svs:check) 13  ;#This is at 1pm
#  set mc_bw(svs:check) 23  ;#This is at 11pm
set mc_bw(svs:check) 3

# Upon finding a newer version of this script, who do you want this script
# to send a note to telling them of this newer version?
# If more than 1 user is to be notified, seperate each user with a
# ' ' (space).
set mc_bw(svs:notify) "MC_8"

# Do you want to monitor only stable versions, disregarding beta versions?
#    0 = Tell me about all version, even beta versions.
#    1 = Just tell me about new stable versions.
set mc_bw(svs:stableonly) 0



###
## Coding below, do not proceed -- you are done with the settings.
###

set mc_bw(version) v3.0.1
set mc_bw(svs:script) "badwerds 003000001000"
set mc_bw(svs:server) "mc.purehype.net 8085"

if {$numversion < "1050000"} {
 putlog "Bad Words $mc_bw(version) by MC_8 is for eggdrop 1.5 and up only."
 putlog "Bad Words will not work with eggdrop $version."
 putlog "Bad Words not loaded."
 return 1
}

setudef flag mc.bw.exemptvoice; setudef flag mc.bw.exemptop

if {(![info exists mc_bw(access)]) || ($mc_bw(access) == "")} {set mc_bw(access) "m|m"}
if {![info exists mc_bw(database)]} {set mc_bw(database) "./.badwords.dat"}
if {![info exists mc_bw(exempt)]} {set mc_bw(exempt) ""}
if {(![info exists mc_bw(warn_msgtype)]) ||
    (![regexp -- {^[012]$} $mc_bw(warn_msgtype)])} {set mc_bw(warn_msgtype) 0}
if {![info exists mc_bw(warn_kick)]} {set mc_bw(warn_kick) 0}
if {![info exists mc_bw(warn_mode)]} {set mc_bw(warn_mode) ""}
if {![info exists mc_bw(bantime)]} {set mc_bw(bantime) 1440}
if {![info exists mc_bw(procmsg)]} {set mc_bw(procmsg) 0}
if {![info exists mc_bw(strip)]} {set mc_bw(strip) 0}
if {![info exists mc_bw(banmask)]} {set mc_bw(banmask) 2}
if {(![info exists mc_bw(share:flag)]) ||
    ([regexp -- {[^A-Z]} [string index $mc_bw(share:flag) 0]])} {set mc_bw(share:flag) B}
set mc_bw(share:flag) [string index $mc_bw(share:flag) 0]
if {![info exists mc_bw(relay:tx)]} {set mc_bw(relay:tx) 1}
if {![info exists mc_bw(relay:rx)]} {set mc_bw(relay:rx) 1}
if {(![info exists mc_bw(relay:key)]) || ($mc_bw(relay:key) == "")} {set mc_bw(relay:key) "key"}

if {![info exists mc_bw(svs:enabled)]} {set mc_bw(svs:enabled) 0}
if {![info exists mc_bw(svs:check)]} {set mc_bw(svs:check) 3}
if {![info exists mc_bw(svs:notify)]} {set mc_bw(svs:notify) $owner}
if {![info exists mc_bw(svs:stableonly)]} {set mc_bw(svs:stableonly) 0}

# +badword [[#channel|&message|&global] <*bad*string*> [#warnings] [%expire <XdXhXm>] <kick/warning message>]
bind dcc - +badwords *mc:bw:dcc:+badword
proc *mc:bw:dcc:+badword {hand idx arg} {
 global mc_bw
 if {$arg == ""} {
  control $idx mc:bw:control:+badword
  putdcc $idx "Bad Words, entering +badword prompt interface."
  putdcc $idx "  To exit early: *bye*"
  putdcc $idx "______________________________________________"
  set mc_bw($idx:switch) 2
  set mc_bw($idx:arg) ""
  putdcc $idx ""
  putdcc $idx "\[#channel|message|global\] What channel?"
  return 0
 }
 set temp [mc:bw:inter:examin $arg $idx $hand +]
 set chan [join [lindex $temp 0]]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [join [lindex $temp 1]]
 set has_access [join [lindex $temp 2]]
 set access [join [lindex $temp 3]]
 set message [join [lindex $temp 4]]
 set warnings [join [lindex $temp 5]]
 set expire [join [lindex $temp 6]]
 while {[regexp -- \\*\\* $string]} {regsub -all -- \\*\\* $string * string}
 if {([string index $chan 0] != "&") && (![validchan $chan])} {
  putcmdlog "#$hand# Denied (invalid channel): +badwords $arg"
  putdcc $idx "Badwords: Invalid channel: $chan"
  putdcc $idx "Syntax: +badword \[\[#channel|&message|&global\] <*bad*string*> \[#warnings\] \[%expire <XdXhXm>\] <kick/warning message>\]"
  return 0
 }
 if {$message == ""} {
  putcmdlog "#$hand# Denied (no message specified): +badwords $arg"
  putdcc $idx "Badwords: No message specified."
  putdcc $idx "Syntax: +badword \[\[#channel|&message|&global\] <*bad*string*> \[#warnings\] \[%expire <XdXhXm>\] <kick/warning message>\]"
  return 0
 }
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): +badwords $arg"
  putdcc $idx "Badwords:  Access denied:  '$access' is required."
  return 0
 }
 if {![mc:bw:inter:list add $chan $string $message $hand $warnings $expire . . -bad]} {
  putcmdlog "#$hand# Denied (already exists): +badwords $arg"
  putdcc $idx "Badwords:  Access denied, entry already exists."
  return 0
 }
 putcmdlog "#$hand# +badwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "Badwords:  Added '$string' (warn/kick msg: $message) to $x badwords list."
 return 0
}

proc mc:bw:control:+badword {idx arg} {
 global mc_bw
 if {$arg == "*bye*"} {
  putdcc $idx ""
  putdcc $idx "Exiting prompt interface."
  catch {unset mc_bw($idx:arg)}
  catch {unset mc_bw($idx:switch)}
  return 1
 }
 switch -- $mc_bw($idx:switch) {
  1 {
   set mc_bw($idx:arg) ""
   putdcc $idx ""
   putdcc $idx "\[#channel|message|global\] What channel?"
  }
  2 {
   if {$arg != "----redo:mc:bw:control"} {
    if {([string index $arg 0] == "#") && (![validchan $arg])} {
     putdcc $idx "Invalid channel: $arg"
     set mc_bw($idx:switch) 1
     mc:bw:control:+badword $idx . ; return 0
    } elseif {($arg != "global") && ($arg != "message")} {
     putdcc $idx "Invalid channel option: $arg"
     set mc_bw($idx:switch) 1
     mc:bw:control:+badword $idx . ; return 0
    }
    if {[string index $arg 0] != "#"} {set arg &$arg}
    lappend mc_bw($idx:arg) $arg
   }
   putdcc $idx ""
   putdcc $idx "Enter your *bad*string*:"
  }
  3 {
   if {$arg != "----redo:mc:bw:control"} {
    if {$arg == ""} {
     putdcc $idx "No *bad*string* entered."
     set mc_bw($idx:switch) 2
     mc:bw:control:+badword $idx ----redo:mc:bw:control ; return 0
    };lappend mc_bw($idx:arg) $arg
   }
   putdcc $idx ""
   putdcc $idx "\[0-99+\] How many warnings do you want to give before a ban?  (default= 0)"
  }
  4 {
   if {[regexp -- {[^0-9]} $arg]} {
    putdcc $idx "Invalid number of warnings: $arg"
    set mc_bw($idx:switch) 3
    mc:bw:control:+badword $idx ----redo:mc:bw:control ; return 0
   } ; lappend mc_bw($idx:arg) "#$arg"
   putdcc $idx ""
   putdcc $idx "\[XdXhXm\] When do you want this entry to expire?  (default= 0d0h0m (aka perm))"
   putdcc $idx " ^^^^^^- X represents a positive number.  d is day, h is hour, m is minute"
  }
  5 {
   if {$arg != "----redo:mc:bw:control"} {
    lappend mc_bw($idx:arg) "%[mc:bw:inter:exp2exp $arg]"
   }
   putdcc $idx ""
   putdcc $idx "What do you want the kick/warn message to say?"
  }
  6 {
   if {$arg == ""} {
    putdcc $idx "No kick/warn message specified."
    set mc_bw($idx:switch) 5
    mc:bw:control:+badword $idx ----redo:mc:bw:control ; return 0
   } ; append mc_bw($idx:arg) " $arg"
   putdcc $idx ""
   putdcc $idx "Performing: .+badword $mc_bw($idx:arg)"
   if {[catch {*mc:bw:dcc:+badword [idx2hand $idx] $idx $mc_bw($idx:arg)} error]} {
    putdcc $idx "Error: $error"
   }
   unset mc_bw($idx:arg)
   unset mc_bw($idx:switch)
   putdcc $idx ""
   putdcc $idx "Exiting prompt interface."
   return 1
  }
  default {putdcc $idx "Error($mc_bw($idx:switch))";return 1}
 };incr mc_bw($idx:switch);return 0
}

# +exemptword [#channel|&message|&global] <*exempt*string*> [%expire <XdXhXm>]
bind dcc - +exemptwords *mc:bw:dcc:+exemptword
proc *mc:bw:dcc:+exemptword {hand idx arg} {
 global mc_bw
 if {$arg == ""} {
  control $idx mc:bw:control:+exemptword
  putdcc $idx "Bad Words, entering +exemptword prompt interface."
  putdcc $idx "  To exit early: *bye*"
  putdcc $idx "_________________________________________________"
  set mc_bw($idx:arg) ""
  putdcc $idx ""
  putdcc $idx "\[#channel|message|global\] What channel?"
  set mc_bw($idx:switch) 2
  return 0
 }
 set temp [mc:bw:inter:examin $arg $idx $hand +]
 set chan [join [lindex $temp 0]]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [join [lindex $temp 1]]
 set has_access [join [lindex $temp 2]]
 set access [join [lindex $temp 3]]
 set expire [join [lindex $temp 6]]
 while {[regexp -- \\*\\* $string]} {regsub -all -- \\*\\* $string * string}
 if {([string index $chan 0] != "&") && (![validchan $chan])} {
  putcmdlog "#$hand# Denied (invalid channel): +exemptwords $arg"
  putdcc $idx "Badwords: Invalid channel: $chan"
  putdcc $idx "Syntax: +exemptword \[\[#channel|&message|&global\] <*bad*string*> \[%expire <XdXhXm>\]\]"
  return 0
 }
 if {$string == ""} {
  putcmdlog "#$hand# Denied (no *exempt*string* specified): +exemptwords $arg"
  putdcc $idx "Badwords: No *exempt*string* specified."
  putdcc $idx "Syntax: +exemptword \[\[#channel|&message|&global\] <*bad*string*> \[%expire <XdXhXm>\]\]"
  return 0
 }
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): +exemptwords $arg"
  putdcc $idx "Badwords:  Access denied:  '$access' is required."
  return 0
 }
 if {![mc:bw:inter:list add $chan $string . $hand . $expire . . -exempt]} {
  putcmdlog "#$hand# Denied (already exists): +exemptwords $arg"
  putdcc $idx "Badwords:  Access denied, entry already exists."
  return 0
 }
 putcmdlog "#$hand# +exemptwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "Badwords:  Added '$string' to $x exemptwords list."
 return 0
}

proc mc:bw:control:+exemptword {idx arg} {
 global mc_bw
 if {$arg == "*bye*"} {
  putdcc $idx ""
  putdcc $idx "Exiting prompt interface."
  catch {unset mc_bw($idx:arg)}
  catch {unset mc_bw($idx:switch)}
  return 1
 }
 switch -- $mc_bw($idx:switch) {
  1 {
   set mc_bw($idx:arg) ""
   putdcc $idx ""
   putdcc $idx "\[#channel|message|global\] What channel?"
  }
  2 {
   if {$arg != "----redo:mc:bw:control"} {
    if {([string index $arg 0] == "#") && (![validchan $arg])} {
     putdcc $idx "Invalid channel: $arg"
     set mc_bw($idx:switch) 1
     mc:bw:control:+exemptword $idx . ; return 0
    } elseif {($arg != "global") && ($arg != "message")} {
     putdcc $idx "Invalid channel option: $arg"
     set mc_bw($idx:switch) 1
     mc:bw:control:+exemptword $idx . ; return 0
    }
    if {[string index $arg 0] != "#"} {set arg &$arg}
    lappend mc_bw($idx:arg) $arg
   }
   putdcc $idx ""
   putdcc $idx "Enter your *exempt*string*:"
  }
  3 {
   if {$arg == ""} {
    putdcc $idx "No *exempt*string* entered."
    set mc_bw($idx:switch) 2
    mc:bw:control:+exemptword $idx ----redo:mc:bw:control ; return 0
   };lappend mc_bw($idx:arg) $arg
   putdcc $idx ""
   putdcc $idx "\[XdXhXm\] When do you want this entry to expire?  (default= 0d0h0m (aka perm))"
   putdcc $idx " ^^^^^^- X represents a positive number.  d is day, h is hour, m is minute"
  }
  4 {
   lappend mc_bw($idx:arg) "%[mc:bw:inter:exp2exp $arg]"
   putdcc $idx ""
   putdcc $idx "Performing: .+badword $mc_bw($idx:arg)"
   if {[catch {*mc:bw:dcc:+exemptword [idx2hand $idx] $idx $mc_bw($idx:arg)} error]} {
    putdcc $idx "Error: $error"
   }
   unset mc_bw($idx:arg)
   unset mc_bw($idx:switch)
   putdcc $idx ""
   putdcc $idx "Exiting prompt interface."
   return 1
  }
  default {putdcc $idx "Error($mc_bw($idx:switch))";return 1}
 };incr mc_bw($idx:switch);return 0
}

# -badword [<#>channel|&message|&global] <*bad*string*>
bind dcc - -badwords *mc:bw:dcc:-badword
proc *mc:bw:dcc:-badword {hand idx arg} {
 global mc_bw
 set temp [mc:bw:inter:examin $arg $idx $hand -]
 set chan [join [lindex $temp 0]]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [join [lindex $temp 1]]
 set has_access [join [lindex $temp 2]]
 set access [join [lindex $temp 3]]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): -badwords $arg"
  putdcc $idx "Badwords:  Access denied:  '$access' is required."
  return 0
 }
 if {![mc:bw:inter:list rem $chan $string . . . . . . -bad]} {
  putcmdlog "#$hand# Denied (no entry): -badwords $arg"
  putdcc $idx "Badwords:  No such entry: $chan '$string']"
  return 0
 }
 putcmdlog "#$hand# -badwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "Badwords:  Removed '$string' from $x badwords list."
 return 0
}

# -exemptword [<#>channel|&message|&global] <*exempt*string*>
bind dcc - -exemptwords *mc:bw:dcc:-exemptword
proc *mc:bw:dcc:-exemptword {hand idx arg} {
 global mc_bw
 set temp [mc:bw:inter:examin $arg $idx $hand -]
 set chan [join [lindex $temp 0]]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [join [lindex $temp 1]]
 set has_access [join [lindex $temp 2]]
 set access [join [lindex $temp 3]]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): -exemptwords $arg"
  putdcc $idx "Badwords:  Access denied:  '$access' is required."
  return 0
 }
 if {![mc:bw:inter:list rem $chan $string . . . . . . -exempt]} {
  putcmdlog "#$hand# Denied (no entry): -exemptwords $arg"
  putdcc $idx "Badwords:  No such entry: $chan '$string'"
  return 0
 }
 putcmdlog "#$hand# -exemptwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "Badwords:  Removed '$string' from $x exemptwords list."
 return 0
}

# badwords [<#>channel|&message|&global|all]
bind dcc - badwords *mc:bw:dcc:badword
proc *mc:bw:dcc:badword {hand idx arg} {
 global mc_bw
 set temp [mc:bw:inter:examin $arg $idx $hand 0]
 set chan [join [lindex $temp 0]]
 if {$chan == "&default"} {set chan "all"}
 set has_access [join [lindex $temp 2]]
 set access [join [lindex $temp 3]]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): badwords $chan"
  putdcc $idx "Badwords:  Access denied:  '$access' is required."
  return 0
 }
 putcmdlog "#$hand# badwords $chan"
 putdcc $idx "Badwords listing for '$chan':"
 foreach line [mc:bw:inter:list list $chan . . . . . . . -bad] {
  set ta [join [lindex $line 1]] ;# Time added
  set ch [join [lindex $line 2]] ;# Channel
  set st [join [lindex $line 3]] ;# String
  set ms [join [lindex $line 4]] ;# Message
  set ad [join [lindex $line 5]] ;# Added by
  set wn [join [lindex $line 6]] ;# Warnings
  set ex [join [lindex $line 7]] ;# Expires
  set lu [join [lindex $line 8]] ;# Last used
  if {[regexp -- day [set ta [mc:bw:inter:ut2d $ta]]]} {lappend ta ago}
  if {$ex == "0"} {set ex perm} else {
   if {[regexp -- day [set ex [mc:bw:inter:ut2d $ex]]]} {
    set ex "expires in $ex"
   } else {set ex "expires at $ex"}
  }
  if {!$lu} {set lu never} else {
   if {[regexp -- day [set lu [mc:bw:inter:ut2d $lu]]]} {lappend lu ago}
  }
  putdcc $idx [format "%9s %s" "$ch:" "$st ($ex)"    ]
  putdcc $idx [format "%9s %s" ""     "$ad: $ms"     ]
  putdcc $idx [format "%9s %s" ""     "Warnings: $wn"]
  putdcc $idx [format "%9s %s" ""     "Last used $lu"]
  putdcc $idx [format "%9s %s" ""     "Created $ta"  ]
 };return 0
}

# exemptwords [<#>channel|&message|&global|all]
bind dcc - exemptwords *mc:bw:dcc:exemptword
proc *mc:bw:dcc:exemptword {hand idx arg} {
 global mc_bw
 set temp [mc:bw:inter:examin $arg $idx $hand 0]
 set chan [join [lindex $temp 0]]
 if {$chan == "&default"} {set chan "all"}
 set has_access [join [lindex $temp 2]]
 set access [join [lindex $temp 3]]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): exemptwords $chan"
  putdcc $idx "Badwords:  Access denied:  '$access' is required."
  return 0
 }
 putcmdlog "#$hand# exemptwords $chan"
 putdcc $idx "Exemptwords listing for '$chan':"
 foreach line [mc:bw:inter:list list $chan . . . . . . . -exempt] {
  set ta [join [lindex $line 1]] ;# Time added
  set ch [join [lindex $line 2]] ;# Channel
  set st [join [lindex $line 3]] ;# String
  set ad [join [lindex $line 5]] ;# Added by
  set ex [join [lindex $line 7]] ;# Expires
  set lu [join [lindex $line 8]] ;# Last used
  if {[regexp -- day [set ta [mc:bw:inter:ut2d $ta]]]} {lappend ta ago}
  if {$ex == "0"} {set ex perm} else {
   if {[regexp -- day [set ex [mc:bw:inter:ut2d $ex]]]} {
    set ex "expires in $ex"
   } else {set ex "expires at $ex"}
  }
  if {!$lu} {set lu never} else {
   if {[regexp -- day [set lu [mc:bw:inter:ut2d $lu]]]} {lappend lu ago}
  }
  putdcc $idx [format "%9s %s" "$ch:" "$st ($ex)"     ]
  putdcc $idx [format "%9s %s" ""     "Added By : $ad"]
  putdcc $idx [format "%9s %s" ""     "Last used: $lu"]
  putdcc $idx [format "%9s %s" ""     "Created $ta"   ]
 };return 0
}

bind pubm - * mc:bw:pubm
proc mc:bw:pubm {nick uhost hand chan arg} {
 mc:bw:bw $nick $uhost $hand $chan $arg pub
}

bind ctcp - ACTION mc:bw:ctcp
proc mc:bw:ctcp {nick uhost hand chan key arg} {
 global botnick mc_bw
 mc:bw:bw $nick $uhost $hand $chan $arg action
 if {($mc_bw(procmsg)) && ($chan == [string tolower $botnick])} {
  foreach channel [channels] {
   mc:bw:bw $nick $uhost $hand $channel $arg action
  }
 }
}

bind notc - * mc:bw:notc
proc mc:bw:notc {nick uhost hand arg {chan {}}} {
 global botnick mc_bw
 if {$chan == ""} {set chan [string tolower $botnick]}
 set $chan [string trimleft $chan @]
 mc:bw:bw $nick $uhost $hand $chan $arg notice
 if {($mc_bw(procmsg)) && ($chan == [string tolower $botnick])} {
  foreach channel [channels] {
   mc:bw:bw $nick $uhost $hand $channel $arg notice
  }
 }
}

bind msgm - * mc:bw:msgm
proc mc:bw:msgm {nick uhost hand arg} {
 global mc_bw botnick
 mc:bw:bw $nick $uhost $hand $botnick $arg msg
 if {$mc_bw(procmsg)} {
  foreach channel [channels] {
   mc:bw:bw $nick $uhost $hand $channel $arg msg
  }
 }
}

proc mc:bw:bw {nick uhost hand chan arg type} {
 global botnick mc_bw
 set chan [string tolower $chan]
 if {([validchan $chan]) &&
     ((([isop $nick $chan]) && ([mc:bw:inter:chanflagison $chan mc.bw.exemptop])) ||
     (([isvoice $nick $chan]) && ([mc:bw:inter:chanflagison $chan mc.bw.exemptvoice])))} {
  return 0
 }
 if {$mc_bw(strip)} {set arg [mc:bw:inter:strip:all $arg]}
 if {$mc_bw(exempt) != ""} {
  if {$chan == [string tolower $botnick]} {
   if {[matchattr $hand $mc_bw(exempt)]} {return 0}
  } else {if {[matchattr $hand $mc_bw(exempt) $chan]} {return 0}}
 }
 if {$chan == [string tolower $botnick]} {set chan "&message"}
 if {([mc:bw:inter:list match &global . $arg . . . . . -exempt] != "") ||
     ([mc:bw:inter:list match $chan . $arg . . . . . -exempt] != "")} {return 0}
 if {([set line [mc:bw:inter:list match &global . $arg . . . . . -bad]] == "") &&
     ([set line [mc:bw:inter:list match $chan . $arg . . . . . -bad]] == "")} {return 0}
 set l_cs [join [lindex $line 1]] ;# Time added
 set l_ch [join [lindex $line 2]] ;# Channel
 set l_st [join [lindex $line 3]] ;# String
 set l_ms [join [lindex $line 4]] ;# Message
 set l_ad [join [lindex $line 5]] ;# Added by
 set l_wn [join [lindex $line 6]] ;# Warnings
 set l_ex [join [lindex $line 7]] ;# Expires
 set l_lu [join [lindex $line 8]] ;# Last used
 set host [string range $uhost [expr [string first @ $uhost]+1] end]
 if {$chan == "&message"} {set temp "private $type"} else {set temp $chan}
 set message [mc:bw:inter:replace $l_ms "%method [list $type] %channel [list $temp] %string [list $l_st] %add [list $l_ad]"]
 set action ""
 if {[mc:bw:warn $host $chan $l_st $l_wn]} {
  switch -- $mc_bw(warn_msgtype) {
   0 {lappend action "warned (via private message)";puthelp "PRIVMSG $nick :$message"}
   1 {lappend action "warned (via private notice)" ;puthelp "NOTICE $nick :$message" }
  }
  if {$chan == "&message"} {
   set channels [string tolower [channels]]
   set x "to me"
  } else {set channels $chan;set x "in $chan"}
  if {$mc_bw(warn_msgtype) == "2"} {lappend action "warned (via public @ [join $channels ", "])"}
  foreach channel $channels {
   if {$mc_bw(warn_msgtype) == "2"} {puthelp "PRIVMSG $channel :$message"}
   if {($mc_bw(warn_mode) != "") && ([isop $botnick $channel])} {
    set temp [mc:bw:inter:replace $mc_bw(warn_mode) "%botnick [list $botnick] %nick [list $nick]"]
    putserv "MODE $channel $temp";lappend action "mode changed ($channel $temp)"
   }
   if {$mc_bw(warn_kick)} {
    if {(![isop $botnick $channel]) && ($chan == "&message") && ($mc_bw(relay:tx))} {
     putallbots [list badwords $mc_bw(relay:key) KICK $channel $nick $message]
     lappend action "relay kick request (not op'd in $channel)"
    } elseif {([onchan $nick $channel]) && ([isop $botnick $channel])} {
     putserv "KICK $channel $nick :$message";lappend action "kicked ($channel)"
    }
   }
  };putlog "Badwords: $nick was caught saying '$l_st' $x.  Action taken: [join $action ", "]"
 } else {
  set banmask [mc:bw:inter:masktype $nick!$uhost $mc_bw(banmask)]
  set global [string match @* $mc_bw(bantime)]
  set ban_time [string trimleft $mc_bw(bantime) @]
  if {$ban_time == "-2"} {
   set ban_time ""
   set duration "Perm Ban"
  } elseif {$ban_time > "0"} {set duration [duration [expr $ban_time*60]]} else {
   set duration "Server Ban"
  }
  if {($global) || ($chan == "&message")} {
   foreach channel [channels] {
    if {(![isop $botnick $channel]) && ($chan == "&message") && ($mc_bw(relay:tx))} {
     set temp ""
     if {$ban_time != "-1"} {
      putallbots [list badwords $mc_bw(relay:key) BAN $channel $banmask]
      set temp " and ban"
     }
     putallbots [list badwords $mc_bw(relay:key) KICK $channel $nick $message]
     lappend action "relay kick$temp request (not op'd in $channel)"
    } else {
     set x 0
     if {([mc:bw:inter:findchanuser $banmask $channel] != "") && ([isop $botnick $channel])} {
      if {$ban_time != "-1"} {putserv "MODE $channel +b $banmask";incr x 1}
     }
     if {([onchan $nick $channel]) && ([isop $botnick $channel])} {
      putserv "KICK $channel $nick :$message";incr x 2
     }
     switch -- $x {
      1 {lappend action "banned ($channel)"}
      2 {lappend action "kicked ($channel)"}
      3 {lappend action "kicked and banned ($channel)"}
     }
    }
   }
   if {($ban_time > "0") || ($ban_time == "")} {
    newban $banmask $l_ad $message $ban_time
    lappend action "added global ban in bots banlist (Duration: $ban_time)"
   }
  } else {
   set x 0
   if {([mc:bw:inter:findchanuser $banmask $chan] != "") && ([isop $botnick $chan])} {
    if {$ban_time != "-1"} {putserv "MODE $chan +b $banmask";incr x 1}
   }
   if {([onchan $nick $chan]) && ([isop $botnick $chan])} {
    putserv "KICK $chan $nick :$message";incr x 2
   }
   switch -- $x {
    1 {lappend action "banned ($chan)"}
    2 {lappend action "kicked ($chan)"}
    3 {lappend action "kicked and banned ($chan)"}
   }
   if {($ban_time > "0") || ($ban_time == "")} {
    newchanban $chan $banmask $l_ad $message $ban_time
    lappend action "added $chan channel ban in bots banlist (Duration: $ban_time)"
   }
  }
  if {$chan == "&message"} {set x "to me"} else {set x "in $chan"}
  putlog "Badwords: $nick was caught saying '$l_st' $x.  Action taken: [join $action ", "]"
 }
}

bind bot - badwords mc:bw:bot
proc mc:bw:bot {from command arg} {
 global mc_bw botnick
 set a [join [lindex $arg 2]]     ;# channel
 set b [join [lindex $arg 3]]     ;#kick=nick, ban=banmask
 set c [join [lrange $arg 4 end]] ;#kick=message
 set k [join [lindex $arg 0]]     ;# key
 set cmd [join [lindex $arg 1]]   ;# command
 if {(([lindex $arg 0] != $mc_bw(relay:key)) || (![isop $botnick $a])) &&
     (($cmd == "KICK") || ($cmd == "BAN"))} {return 0}
 switch -- $cmd {
  KICK {
   putserv "KICK $a $b :$c"
   putloglev b * "Badwords:  Relay from $from, kicking $b in $a."
  }
  BAN {
   putserv "MODE $a +b $b"
   putloglev b * "Badwords:  Relay from $from, banning $b in $a."
  }
# > x share cmd arg
  share {
   set ty [join [lindex $arg 3]]
   set ch [join [lindex $arg 4]]
   if {[string index $ch 0] != "#"} {
    set access [matchattr $from b$mc_bw(share:flag)|]
   } elseif {[validchan $ch]} {
    set access [matchattr $from b$mc_bw(share:flag)|$mc_bw(share:flag) $ch]
   } else {set access 0}
   set cmd [join [lindex $arg 2]]
   if {(!$access) && ($cmd != "U")} {return 0}
   set st [join [lindex $arg 5]]
   set ms [join [lindex $arg 6]]
   set hd [join [lindex $arg 7]]
   set wn [join [lindex $arg 8]]
   set ex [join [lindex $arg 9]]
   set lu [join [lindex $arg 10]]
   set q [join [lindex $arg 11]]
   set vt [string trimleft $ty -]
   switch -- $cmd {
    add {
     if {![mc:bw:inter:list add $ch $st $ms $hd $wn $ex . NO $ty]} {
      mc:bw:inter:list update $ch $st $ms $hd $wn $ex $lu NO $ty
     }
     putloglev b * "Badwords:  Share from $from, added ${vt}word: $ch $st"
    }
    load {
     if {![mc:bw:inter:list add $ch $st $ms $hd $wn $ex . NO $ty]} {
      mc:bw:inter:list update $ch $st $ms $hd $wn $ex $lu NO $ty
     }
    }
    rem {
     mc:bw:inter:list rem $ch $st . . . . . NO $ty
     if {$ms != ""} {set ms "($ms)"}
     putloglev b * "Badwords:  Share from $from, removed ${vt}word: $ch $st $ms"
    }
    U { mc:bw:inter:list save -quiet; mc:bw:inter:list load $from }
    update {
     if {![mc:bw:inter:list update $ch $st $ms $hd $wn $ex $lu NO $ty]} {
      mc:bw:inter:list add $ch $st $ms $hd $wn $ex . NO $ty
     }
     if {$q != "-quiet"} {
      putloglev b * "Badwords:  Share from $from, updated ${vt}word: $ch $st"
     }
    }
    default {putloglev b * "Badwords:  Share from $from, unknown request: $cmd"}
   }
  }
  default {putloglev b * "Badwords:  Relay from $from, unknown request: $cmd"}
 }
}

bind link - * mc:bw:link;proc mc:bw:link {bot via} {mc:bw:inter:share U:$bot}

#   mc:bw:inter:share add [list $type $chan $string $text $hand $warnings $expire 0]
#   mc:bw:inter:share rem [list $type $chan $string $text]
#   mc:bw:inter:share update [list $type $chan $string $text $hand $warnings $expire $lu]
#   mc:bw:inter:share load:<bot> [list $type $ch $st $ms $ad $wn $ex $lu]
#   mc:bw:inter:share U:<bot>
# > x share cmd arg
proc mc:bw:inter:share {command {arg {}}} {
 global mc_bw
 set chan [join [lindex $arg 0]]
 set cmd [string range $command 0 [expr [string first : $command]-1]]
 set bot [string range $command [expr [string first : $command]+1] end]
 if {$cmd == "U"} {
  if {$bot == "-all"} {putallbots "badwords x share U $arg"} elseif {[islinked $bot]} {
   putbot $bot "badwords x share U $arg"
  };return
 }
 if {$cmd == "load"} {
  if {$bot == "-all"} {set bot [bots]}
  foreach _bot $bot {
   if {![islinked $_bot]} {continue}
   if {[string index $chan 0] != "#"} {
    set access [matchattr $_bot b$mc_bw(share:flag)|]
   } elseif {[validchan $chan]} {
    set access [matchattr $_bot b$mc_bw(share:flag)|$mc_bw(share:flag) $chan]
   } else {set access 0}
   if {$access} {putbot $_bot "badwords x share load $arg"}
  };return
 }
 if {[string index $chan 0] != "#"} {set userlist [userlist b$mc_bw(share:flag)|]} elseif {[validchan $chan]} {
  set userlist [userlist b$mc_bw(share:flag)|$mc_bw(share:flag) $chan]
 } else {set userlist ""}
 foreach bot $userlist {
  if {![islinked $bot]} {continue}
  putbot $bot "badwords x share [list $command] $arg"
 }
}

# {-bad|-exempt time_added channel string message added_by warnings expire lastused}
proc mc:bw:inter:list {cmd {chan {}} {string {}} {text {}} {hand {}} {warnings {}} {expire {}} {lu {}} {q {}} {type {}}} {
 global mc_bw {botnet-nick}
 set chan [string tolower $chan]
 if {![info exists mc_bw(list)]} {set mc_bw(list) ""}
 switch -- $cmd {
  add {
   if {[mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
   lappend mc_bw(list) [list $type [clock seconds] $chan $string $text $hand $warnings $expire 0]
   mc:bw:inter:list save -quiet
   mc:bw:inter:list expire . . . . . . . . $type
   if {$q != "NO"} {
    mc:bw:inter:share add [list $type $chan $string $text $hand $warnings $expire 0]
   };return 1
  }
  exists {
   foreach line $mc_bw(list) {
    set a [join [lindex $line 0]]; set b [join [lindex $line 2]]; set c [join [lindex $line 3]]
    if {[string tolower "$a $b $c"] == [string tolower "$type $chan $string"]} {return 1}
   };return 0
  }
  expire {
   while {[regexp -- "\[0-9\]* \{mc:bw:inter:list expire . . . . . . . . $type\} timer\[0-9\]*" [utimers] timer]} {
    killutimer [lindex $timer 2]
   }
   set ex 0
   foreach line [lsort -dictionary -index 6 [mc:bw:inter:list list all . . . . . . . $type]] {
    set cs [join [lindex $line 1]] ;# Time added
    set ch [join [lindex $line 2]] ;# Channel
    set st [join [lindex $line 3]] ;# String
    set ms [join [lindex $line 4]] ;# Message
    set ad [join [lindex $line 5]] ;# Added by
    set wn [join [lindex $line 6]] ;# Warnings
    set ex [join [lindex $line 7]] ;# Expires
    set lu [join [lindex $line 8]] ;# Last used
    if {!$ex} {continue}
    if {[clock seconds] >= $ex} {
     mc:bw:inter:list rem $ch $st expired . . . . . $type
     switch -- $ch {
      &global {set x "the global"}
      &message {set x "messages"}
      default {set x "$chan's"}
     }
     putlog "Badwords:  Removed '$st' from $x [string trimleft ${type} -]words list. (expired)"
     set ex 0
    } else {break}
   }
   if {$ex} {
    if {[set ex [expr $ex-[clock seconds]]] < "1"} {set ex 1}
    utimer $ex "mc:bw:inter:list expire . . . . . . . . $type"
   }
  }
  list {
   set return ""
   foreach line $mc_bw(list) {
    if {$type != [join [lindex $line 0]]} {continue}
    if {([string tolower $chan] == [string tolower [lindex $line 2]]) ||
        ([string tolower $chan] == "all")} {lappend return $line}
   };return "[lsort -dictionary -index 1 [lsort -dictionary -index 0 $return]]"
  }
  load {
   set mc_bw(list) ""
   if {![file exists $mc_bw(database)]} {close [open $mc_bw(database) w]}
   set io [open $mc_bw(database) r]
   if {![eof $io]} { regexp -- {^#v[0-9]*:} [gets $io] db_ver }
   while {![eof $io]} {
    gets $io line
    if {([join $line] == "") || ([string index $line 0] == "#")} {continue}
    switch -- $db_ver {
     default { lappend mc_bw(list) [set temp "-bad $line 0 0 0"] }
     "#v1:"  { lappend mc_bw(list) [set temp "-bad $line 0 0 0"] }
     "#v2:"  { lappend mc_bw(list) [set temp "-bad $line"]       }
     "#v3:"  { lappend mc_bw(list) [set temp $line]              }
    }
    set ty [join [lindex $temp 0]] ;# Type
    set ch [join [lindex $temp 2]] ;# Channel
    set st [join [lindex $temp 3]] ;# String
    set ms [join [lindex $temp 4]] ;# Message
    set ad [join [lindex $temp 5]] ;# Added by
    set wn [join [lindex $temp 6]] ;# Warnings
    set ex [join [lindex $temp 7]] ;# Expires
    set lu [join [lindex $temp 8]] ;# Last used
    mc:bw:inter:share load:$chan [list $ty $ch $st $ms $ad $wn $ex $lu]
   }
   close $io
   mc:bw:inter:list expire . . . . . . . . -exempt
   mc:bw:inter:list expire . . . . . . . . -bad
   return 1
  }
  match {
   foreach line [mc:bw:inter:list list $chan . . . . . . . $type] {
    set cs [join [lindex $line 1]] ;# Time added
    set ch [join [lindex $line 2]] ;# Channel
    set st [join [lindex $line 3]] ;# String
    set ms [join [lindex $line 4]] ;# Message
    set ad [join [lindex $line 5]] ;# Added by
    set wn [join [lindex $line 6]] ;# Warnings
    set ex [join [lindex $line 7]] ;# Expires
    set lu [join [lindex $line 8]] ;# Last used
    if {[string match [string tolower $st] [string tolower $text]]} {
     mc:bw:inter:list update $chan $st $ms $ad $wn $ex [clock seconds] -quiet $type
     return $line
    }
   };return ""
  }
  rem {
   if {![mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
   set list ""
   foreach line $mc_bw(list) {
    if {[string tolower "[join [lindex $line 0]] [join [lrange $line 2 3]]"] != [string tolower "$type $chan $string"]} {
     lappend list $line
    }
   }
   set mc_bw(list) $list
   mc:bw:inter:list save -quiet
   if {$q != "NO"} { mc:bw:inter:share rem [list $type $chan $string $text] }
   return 1
  }
  save {
   if {$chan != "-quiet"} {putloglev o * "Writing badwords file..."}
   if {![file exists $mc_bw(database)]} {close [open $mc_bw(database) w]}
   set io [open $mc_bw(database) w]
   puts $io "#v3:$mc_bw(version):${botnet-nick}:[clock seconds]"
   foreach line [mc:bw:inter:list list all . . . . . . . -bad] {puts $io $line}
   foreach line [mc:bw:inter:list list all . . . . . . . -exempt] {puts $io $line}
   close $io;return 1
  }
  update {
   if {![mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
   set list ""
   foreach line $mc_bw(list) {
    set ty [join [lindex $line 0]] ;# Type
    set ta [join [lindex $line 1]] ;# Time added
    set ch [join [lindex $line 2]] ;# Channel
    set st [join [lindex $line 3]] ;# String
    if {[string tolower "$ty $ch $st"] == [string tolower "$type $chan $string"]} {
     lappend list [list $ty $ta $chan $string $text $hand $warnings $expire $lu]
    } else {lappend list $line}
   };set mc_bw(list) $list
   mc:bw:inter:list save -quiet
   mc:bw:inter:list expire . . . . . . . . $type
   if {$q != "NO"} {
    mc:bw:inter:share update [list $type $chan $string $text $hand $warnings $expire $lu $q]
   };return 1
  }
 }
}

proc mc:bw:warn {host chan string warn} {
 global mc_bw
 set host [string tolower $host]
 set chan [string tolower $chan]
 set string [string tolower $string]
 if {![info exists mc_bw(warn!$host:$chan:$string)]} {set mc_bw(warn!$host:$chan:$string) 0}
 if {$warn <= $mc_bw(warn!$host:$chan:$string)} {return 0}
 incr mc_bw(warn!$host:$chan:$string);return 1
}

# in: unixtime
#out: x day(s) || hh:mm
proc mc:bw:inter:ut2d {time} {
 set diff [string trimleft [expr [clock seconds]-$time] -]
 if {[set d [expr $diff/60/60/24]] != "0"} {
  set s "";if {$d != "1"} {set s s};lappend d day$s
 } else {set d [clock format $time -format %H:%M]}
 return $d
}

#return: chan string has_access access_type message warnings expire
proc mc:bw:inter:examin {arg idx hand ar} {
 global mc_bw
 set x 0
 if {[string index [set temp [lindex $arg 0]] 0] == "#"} {
  set chan [string tolower $temp];set x 1
 } elseif {[string index [set temp [join [lindex $arg 0]]] 0] == "&"} {
  set temp [string tolower $temp]
  if {($temp == "&message") || ($temp == "&global")} {set chan $temp;set x 1}
 } elseif {[string tolower [lindex $arg 0]] == "all"} {set chan "all";set x 1}
 if {!$x} {
  if {[set chan [string tolower [lindex [console $idx] 0]]] == "*"} {set chan "&default"}
 }
 if {([string index $chan 0] == "&") || ($chan == "all")} {
  set has_access [set access [matchattr $hand [lindex [split $mc_bw(access) |] 0]]]
  set access "global $access"
 } else {
  set has_access [set access [matchattr $hand $mc_bw(access) $chan]]
  set access "$access $chan"
 }
 if {$ar == "-"} {
  set string [join [lrange $arg $x end]]
  set warnings ""
  set message ""
  set expire ""
 } else {
  set string [join [lindex $arg $x]];incr x
  if {[string index [set temp [join [lindex $arg $x]]] 0] == "#"} {
   set warnings [string range $temp 1 end];incr x
  } {set warnings 0}
  if {[string index [set temp [join [lindex $arg $x]]] 0] == "%"} {
   set expire [mc:bw:inter:exp2cs [string range $temp 1 end]];incr x
  } {set expire 0}
  set message [lrange $arg $x end]
 }
 return "[list $chan $string $has_access $access $message $warnings $expire]"
}

# Converts 1d4h17m to current unixtime + that, returns in unixtime format.
# If 0d0h0m =(returns)=> 0
proc mc:bw:inter:exp2cs {time} {
 if {[regexp -- {[^a-zA-Z]?[0-9]m} $time min]} {
  set min [string range $min 0 [expr [string length $min]-2]]
  if {$min == ""} {set min 0}
 } else {set min 0}
 if {[regexp -- {[^a-zA-Z]?[0-9]h} $time hour]} {
  set hour [string range $hour 0 [expr [string length $hour]-2]]
  if {$hour == ""} {set hour 0}
 } else {set hour 0}
 if {[regexp -- {[^a-zA-Z]?[0-9]d} $time day]} {
  set day [string range $day 0 [expr [string length $day]-2]]
  if {$day == ""} {set day 0}
 } else {set day 0}
 set add [expr ($min*60) + ($hour*60*60) + ($day*60*60*24)]
 if {!$add} {return 0} else {return [expr [clock seconds] + $add]}
}

# Converts 1d4h1d17m9r7k to 1d4h17m.
proc mc:bw:inter:exp2exp {time} {
 if {[regexp -- {[^a-zA-Z]?[0-9]m} $time min]} {
  set min [string range $min 0 [expr [string length $min]-2]]
  if {$min == ""} {set min 0}
 } else {set min 0}
 if {[regexp -- {[^a-zA-Z]?[0-9]h} $time hour]} {
  set hour [string range $hour 0 [expr [string length $hour]-2]]
  if {$hour == ""} {set hour 0}
 } else {set hour 0}
 if {[regexp -- {[^a-zA-Z]?[0-9]d} $time day]} {
  set day [string range $day 0 [expr [string length $day]-2]]
  if {$day == ""} {set day 0}
 } else {set day 0}
 return "${day}d${hour}h${min}m"
}

proc mc:bw:inter:strip:color {ar} {
 regsub -all -- {\003([0-9][0-9]?(,[0-9][0-9]?)?)?} $ar "" ar ; return $ar
}
proc mc:bw:inter:strip:bold {ar} {regsub -all -- "\002" $ar "" ar; return $ar}
proc mc:bw:inter:strip:uline {ar} {regsub -all -- "\037" $ar "" ar; return $ar}
proc mc:bw:inter:strip:reverse {ar} {regsub -all -- "\026" $ar "" ar; return $ar}
proc mc:bw:inter:strip:all {ar} {
 return [mc:bw:inter:strip:reverse [mc:bw:inter:strip:uline [mc:bw:inter:strip:bold [mc:bw:inter:strip:color $ar]]]]
}

# in: n!u@h #chan -- WC Accepted
#out: [nick [nick [...]]]
proc mc:bw:inter:findchanuser {hostmask channel} {
 if {![validchan $channel]} {return -code error "no such channel record"} ; set buffer ""
 set hostmask [string tolower $hostmask]
 foreach user [chanlist $channel] {
  if {[string match $hostmask [string tolower $user![getchanhost $user $channel]]]} {
   lappend buffer [list $user]
  }
 };return $buffer
}

proc mc:bw:inter:replace {string subs} {
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 };return $string
}

proc mc:bw:inter:chanflagison {chan flag} {
 foreach info [string tolower [channel info $chan]] {
  if {[string range $info 1 end] != [string tolower $flag]} {continue}
  if {[string index $info 0] == "-"} {
   return 0
  } elseif {[string index $info 0] == "+"} {return 1} else {return 0}
 };return 0
}

proc mc:bw:inter:masktype {uhost type} {
 set ident_max-length 9
 set host_max-length 63
 scan $uhost {%[^!]!%[^@]@%s} nick ident host
 set maskhost 1
 if {[regexp -- {^1[0-9]$} $type]} {
  if {!([regexp -- {^([0-9][0-9]?[0-9]?)\.([0-9][0-9]?[0-9]?)\.([0-9][0-9]?[0-9]?)\.([0-9][0-9]?[0-9]?)$} $host temp a b c d] && ($a > 0 && $a < 255 && $b < 255 && $c < 255 && $d < 255))} {
   regsub -all {[0-9]} $host "?" host
   set maskhost 0
  };set type [string index $type 1]
 }
 if {[regexp -- {^[0-4]$} $type]} {set nick "*"}
 if {[regexp -- {^[2479]$} $type]} {set ident "*"}
 if {[regexp -- {^[1368]$} $type]} {set ident "*[string trimleft $ident ~]"}
 if {[regexp -- {^[3489]$} $type]} {if {$maskhost} {scan [maskhost $host] {%[^@]@%s} temp host}}
 if {[string length $ident] > ${ident_max-length}} {
  set ident "*[string range $ident [expr [string length $ident]-${ident_max-length}] end]"
 }
 if {[string length $host] > ${host_max-length}} {
  set host "*[string range $host [expr [string length $host]-${host_max-length}] end]"
 }; return [format "%s!%s@%s" $nick $ident $host]
}

if {$mc_bw(svs:enabled)} {
 if {($mc_bw(svs:check) > "23") || ($mc_bw(svs:check) < "0")} {set mc_bw(svs:check) 00}
 if {[string length $mc_bw(svs:check)] == "1"} {set mc_bw(svs:check) 0$mc_bw(svs:check)}
 if {$mc_bw(svs:stableonly)} {
  set mc_bw(svs:script) [string range $mc_bw(svs:script) 0 [expr [string length $mc_bw(svs:script)]-4]]999
 }
 catch {unbind time - "00 $mc_bw(svs:oldcheck) * * *" mc:bw:svs:time}
 set mc_bw(svs:oldcheck) $mc_bw(svs:check)
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
   putdcc $idx q
   if {[lindex $args 1] > [lindex $mc_bw(svs:script) 1]} {
    set note [mc:bw:inter:replace [lindex $args 7] "%0 {[lindex $args 0]} %1 {[lindex $args 1]} %2 {[lindex $args 2]}"]
    set note [mc:bw:inter:replace $note "%3 {[lindex $args 3]} %4 {[lindex $args 4]} %5 {[lindex $args 5]}"]
    set note [mc:bw:inter:replace $note "%6 {[lindex $args 6]} %8 {[lindex $args 8]} %version {$mc_bw(version)}"]
    set note [mc:bw:inter:replace $note "%9 {[lindex $args 9]} %10 {[lindex $args 10]} %11 {[lindex $args 11]}"]
    set note [mc:bw:inter:replace $note "%12 {[lindex $args 12]} %13 {[lindex $args 13]} %14 {[lindex $args 14]}"]
    set note [mc:bw:inter:replace $note "%15 {[lindex $args 15]} %16 {[lindex $args 16]} %17 {[lindex $args 17]}"]
    set note [mc:bw:inter:replace $note "%18 {[lindex $args 18]} %19 {[lindex $args 19]} %20 {[lindex $args 20]}"]
    foreach notify [join [split $mc_bw(svs:notify) ",;"]] {
     set outnote [mc:bw:inter:replace $note "%nick {$notify}"]
     if {[string match "*$outnote*" "[notes $notify -[notes $notify]]"]} {
      set cont 0
      foreach unote [notes $notify -[notes $notify]] {
       if {$outnote == [lindex $unote 2]} {set cont 1;break}
      };if {$cont} {continue}
     }
     switch -- [sendnote SVS $notify $outnote] {
      0 {
       if {![validuser $notify]} {set x "invalid user"} else {set x "unknown reason"}
       putlog "MC SVS for [lindex $mc_bw(svs:script) 0] had some errors updating $notify on current version of script; $x"
      }
      3 {putlog "MC SVS for [lindex $mc_bw(svs:script) 0] had some errors updating $notify on current version of script; notebox too full!"}
     }
    }
   }
  }
 };return 0
}

bind evnt - save mc:bw:evnt ; proc mc:bw:evnt {type} {mc:bw:inter:list save}
mc:bw:inter:list load -all

putlog "Bad Words $mc_bw(version) by MC_8 loaded."
