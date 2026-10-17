##
# Bad Words v4.0.2
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.5.5 or greater.
#
# My Website - http://mc.purehype.net:81/
# Have a bug?  http://mc.purehype.net:81/bugzilla/
##

##
# This script will kick and ban anyone in a specified room that mentions a
# certin word (wildcards accepted).
#
# I use this script to ban those whom spam other channels as well as websites n`
# such.  If you do the same, I suggest using mc.spamcheck as well.
##

##
# The history log has been moved to the very bottom of this script.
##

##
# COMMANDS (dcc)
##
# +badword [[#channel|&message|&global] <*bad*string*> [#warnings] [%expire<XdXhXm>] <kick/warning message>]
#   This will add a bad word string to the badwords list.
#   Defaults:
#     [#channel|&message|&global] = &global
#     [#warnings] = #0 (none)
#     [%expire<XdXhXm>] = %0d0h0m (never, perm)
#   EXAMPLES:
#     +badword #eggdrop *i*want*free*shell* Do not ask about free shells!
#       This will add *i*want*free*shell* to #eggdrop's badword list with the
#       warning and kick message to be "Do not ask for free shells!".
#     +badword *MC_8*sucks* MC Rocks
#       This will add *MC_8*sucks* to the global badword list with the
#       warning/kick message will be "MC Rocks".
#     +badword &global *MC_8*sucks* No he doesn't.
#       This will add *MC_8*sucks* to the global badword list with the
#       warning/kick message will be "No he doesn't.".
#     +badword &message * #3 Don't message me!
#       This will add * (anything) that is private messaged (msg/ action/
#       notice) to the bot to the badwords list.  The user will get 3 warnings
#       before being banned.  If you never specify the number of warnings (like
#       in above examples), it's 0 (none).
#     +badword &message * %1d3h14m Don't message me!
#       This will add * (anything) that is private messaged (msg/ action/
#       notice) to the bot to the badwords list.  There are no warnings, and it
#       expires in 1 day, 2 hours and 14 minutes, if expire time is not provided
#       (like in the above examples) then it never expires.
#     +badword
#       This will start the +badword prompt interface.  If the above examples
#       confuse you, just do this command instead to recieve a walk through 'add
#       badwords' interface.
#
# -badword [#channel|&message|&global] <*bad*string*>
#   This will remove a bad word string from the badwords list.
#   Defaults:
#     [#channel|&message|&global] = &global
#
# badwords [#channel|&message|&global|all]
#   This is used to view bad word strings already in the badwords list.
#   Defaults:
#     [#channel|&message|&global|all] = all
#
# +exemptword [[#channel|&message|&global] <*exempt*string*> [%expire<XdXhXm>]]
#   This will add an exempt word string to the exempwords list.
#   Defaults:
#     [#channel|&message|&global] = &global
#     [%expire<XdXhXm>] = %0d0h0m (never, perm)
#   EXAMPLES:
#     +exemptword &message "op *"
#       This will exempt all private messages (msg/ action/ notice) that start
#       with 'op '.  You might want to exempt all message commands such as
#       'ident', 'op', 'voice', 'help' and so on if you intend to '+badword
#       &message * Anti spam, don't message people you don't know.' (good for
#       anti spam).
#     +exemptword #abc123 "!vote *" %1d
#       This exempts all messages to #abc123 that starts with '!vote '.  This
#       entry will expire it's self in 1 day.
#     +exemptword
#       This will start the +exemptword prompt interface.  If the above examples
#       confuse you, just do this command instead to recieve a walk through 'add
#       exemptwords' interface.
#
# -exemptword [#channel|&message|&global] <*exempt*string*>
#   This will remove an exempt word string from the exemptwords list.
#   Defaults:
#     [#channel|&message|&global] = &global
#
# exemptwords [#channel|&message|&global|all]
#   This will view exempt word strings already in the exemptwords list.
#   Defaults:
#     [#channel|&message|&global|all] = all
#
# chanset <#channel> <+/->mc.bw.exemptvoice
#   Do you want to exempt users whom are voiced in #channel from the reactions
#   of this script?  You set this on a per channel basis, + represents 'yes' and
#   - represents 'no' to the above question.
#   EXAMPLES:
#     chanset #abc123 +mc.bw.exemptvoice
#       Will exempt voiced users in #abc123 from this script.
#     chanset #eggdrop -mc.bw.exemptvoice
#       Will not exempt voiced users in #eggdrop from this script.
#
# chanset <#channel> <+/->mc.bw.exemptop
#   This will do the same as the one above (the exempt voice one), but instead
#   of voice it's asking if you want to exempt ops.  Examples are relativly the
#   same as well.
#
# chattr <bot> +B [channel]
#   You can share your badwords entries with other bot's; the bots you want to
#   share your badwords and exemptwords entrys with must --
#     1) have the +B flag, must be added and linked and
#     2) must all have this script loaded.
#   If you don't submit a channel the B flag will be asigned globally, witch
#   means it will be a global share as opposed to only sharing specific badwords
#   for a specified channel.
#   NOTE:
#     o Please note that &message and &global badword and exempt word entrys are
#       sent through the shared pipe for global global shares.
#     o Entries never overwrite themselves.
#     o For better usefullness, there is no agressive and passive sharing
#       involved in this.  However, keep in mind, if one of the share bots are
#       not linked and you do a .-badword; the bot that's not linked will never
#       know you removed it.  It's the same way with core eggdrop sharing of
#       ban's (for referance).
#     o The flag 'B' is changable, incase 'B' conflicts with some other script.
#
#
# Usefull information:
#  - If your adding a *bad*string* (or *exempt*string*) that contains a space,
#    "quote it".
#    Example:
#      +badword #eggdrop "* pussy *" Go away.
#        If you think about it, if you set this to "*pussy*" it would wind up
#        banning people for even saying 'pussywillow' witch isn't really what
#        were worried about.
#  - If your adding a *bad*string* (or *exempt*string*) that contains a "
#    (quotation mark) then escape it.
#     Example:
#       +badword #eggdrop "* \"pussy *" Go away.
#         This will ban anyone that says "pussy as a word.  To escape something
#         (in TCL) means to put a '\' infront of it.
#  - The kick/warning message can have the following replacment veriables:
#      %channel == Channel it's for (&global/ &message/ #a_channel)
#      %method  == Method used (action/ msg/ notice/ pub).
#      %string  == The *ban*string* that was triggered by the user.
#      %add     == Who this was added by.
#      Example:
#        +badword &message * Anti spam, do not %method me!
#          So, if someone private messages the bot with something, and it's not
#          exempt (in exempt list); the user will get a kick message that states
#          "Anti spam, do not msg me!"
#  - *bad*string*'s (and *exempt*string*'s) don't bother with case sensativity.
#  - Avilable wildcards for the *bad*string*'s (and *exempt*string*'s) are:
#      *       = Matches any sequence of characters in string, including a null
#                string.
#      ?       = Matches any single character in string.
#      [chars] = Matches any character in the set given by chars. If a sequence
#                of the form x-y appears in chars, then any character between x
#                and y, inclusive, will match.  Whereas [a-mr-z] matches any
#                character between a and m, inclusive, or matches any character
#                between r and z, inclusive.
##

##
# Settings
##
#

# What flaged users should only be allowed to perform the dcc commands listed
# above in this script?  Flag format is "<global>|<channel>".
set mc_bw(access) "m|m"

# What flaged users are exempt from this script?  Set this to "" to disable.
# Flag format is "<global>|<channel>".
set mc_bw(exempt:flag) "b|"

# [0=no/1=yes] Do you want to process messages and notices directed to the bot
# as if they were channel text, to be evaluated by channel bad words list?
set mc_bw(procmsg) 0

# [0=no/1=yes] Do you want to strip mIRC color, bold, underline, reverse and
# normal control code characters from public text before evaluating?
#   Note: Some users get past the kick/ban by doing www.something.net (assuming
#         *www.* is a bad word).  On mIRC, and other clients that support these
#         mIRC control codes, it would show up as 'www.something.net' with that
#         block hidden to human eyes ... but not to scripts, therefor making
#         *www.* not trigger for its really to be *www.* for it to match.  This
#         setting will kill all them blocks before it evaluates it so they don't
#         get in the way.
set mc_bw(strip) 1

# How do you want to send warning messages?
#   0 = Private message to the offender.
#   1 = Private notice to the offender.
#   2 = Public message in the channel of the offender.
set mc_bw(warn_msgtype) 0

# [0=no/1=yes] Upon warning, do you want to kick the user?
set mc_bw(warn_kick) 0

# Upon warning, what modes to you want to change in the channel?  Set this to ""
# to disable.
# Replacment veriables:
#   %botnick == The bot's nick.
#   %nick    == The person's nick in violation.
# Example:
#   o If the channel is moderated, instead of kicking the person you can just -v
#     him (removing his voice to speak in the channel).
#   o set mc_bw(warn_mode) "-v+mv %nick %botnick"
set mc_bw(warn_mode) ""

# After exceeding warnings, how long, in minutes, do you want to ban the user?
#   -2 = Permanent ban (no expiration in bot records).
#   -1 = Will not ban (no ban, disable banning).
#    0 = Performs a server ban, but doesn't store the ban in the bot's ban list.
#  Any number greater than 0 will be the time in witch the ban will expire.  All
#  ban's will be channel ban's, if you want it to be a global ban -- put a "@"
#  infront of the time.
#    Example:  set mc_bw(bantime) @1440
#  Also, if you want the ban to be 'sticky' (read '.help stick' in the bot's dcc
#  console), append the value with a "!".
#    Example:  set mc_bw(bantime) 1440!
set mc_bw(bantime) 1440

# Upon issuing a ban for exceeding warnings, how do you want the ban masked?
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
#     You can also specify a type of 10 to 19 which correspond to masks 0 to 9.
#     But if the host.domain is a;
#       hostname = Instead of using a * wildcard to replace portions of the
#                  host.domain, it replaces the numbers in the host.domain with
#                  a '?' (question mark) wildcard.
#       ip       = It will mask as normal, with no '?' (question mark)
#                  replacments as does hostname.
set mc_bw(banmask) 11

# What flag should the script use to designate another bot as sharing with this
# script?  If your not sure as to what to set this to, then just leave it set to
# "B".  This setting is here just incase another script uses the "B" custom flag
# (as not not conflict, so it's changable).  Valid flags here can be A through Z
# (capital letters ONLY).
set mc_bw(share:flag) "B"

# [0=no/1=yes] If the bot finds someone in contempt of using a badword via
# private message (&message -- notice/ action/ privmsg to the bot) and the bot
# isn't opped to punish them, do you want the script to broadcast to the botnet
# to punish the user in violation?
# Note:
#   o Only bots that follow the criterias below can utalize this function
#       1) The other bot?s? have to be linked.
#       2) The other bot?s? have to use mc.badwords also.
#       3) The other bot?s? have to have the mc_bw(relay:rx) setting enabled.
#       4) The other bot?s? have to have the same matching 'relay:key' as does
#          this one.
#   o For security reasons, the bot will never broadcast for other bot's to
#     perform any mode changes other than the +b channel mode (ban).
set mc_bw(relay:tx) 1

# [0=no/1=yes] The setting above (relay:tx) broadcasts, this setting is for
# listening.  Do you want to listen for broadcasts from other bots?
# Note:
#   o This will only listen for those bots whom broadcast the matching key set
#     by 'relay:key' (below).
#   o For security reasons, the bot will never be asked to, nor perform any mode
#     changes other than the +b channel mode (ban).
set mc_bw(relay:rx) 1

# The 'relay:tx' and 'relay:rx' only communicate to eachother if both scripts
# have the same key.  This eliminates the problem of many bots on a botnet using
# the same script but only 2 should be in use for YOUR bots, the others are just
# ?a friends? bots or something.  If 'relay:tx' and 'relay:rx' are both set to
# 0, then don't worry about setting this... just skip over it for it's not even
# going to be used.
set mc_bw(relay:key) "BlaBlaBlaBla"

# [0=no/1=yes] Do you want to use regular expression matching rather than
# glob-style wildcarded matching?
# Note:
#   o Warning, regular expressions are advanced.  If you don't know how to use
#     regular expressions then do not turn this on.  If you want to learn
#     regular expressions then you can check out the following sites:
#       1) http://tcl.activestate.com/man/tcl8.3/TclCmd/re_syntax.htm#M2
#       2) http://dev.scriptics.com/doc/howto/regexp81.html
set mc_bw(use:regexp) 0

# Enter here the filename where dynamic badwords/exemptwords are stored.
set mc_bw(database) ".badwords.dat"


## MC SVS (Script Version Service) v2.1 ##
# Do you want the bot to connection to MC_8's SVS server to see if there's a
# newer version of this module available?  It will only tell you, it's up to you
# to get the newest version and compile it.
#   0 = No, do not enable SVS.
#   1 = Yes, but only inform me of non beta versions.
#   2 = Yes, inform me of all new versions (beta and stable).
set mc_bw(svs:mode) 2

# Upon finding a newer version, whom do you want to notify?  The notification is
# sent via 'note'.  Separate each user with a space.  For those whom know TCL;
# do not put this in list format, keep it in string format.
set mc_bw(svs:notify) "MC_8"



###
## Coding below, do not proceed -- you are done with the settings.
###

set mc_bw(script)      "Bad Words"
set mc_bw(version)     "v4.0.2"
set mc_bw(svs:script)  "badwerds"
set mc_bw(svs:version) "004000002000"
set mc_bw(svs:server)  "mc.purehype.net"
set mc_bw(svs:port)    "81"
set mc_bw(svs:get)     "/"
set mc_bw(svs:query)   "svs=$mc_bw(svs:script)&version=$mc_bw(svs:version)"

catch {unset temp}
if {![info exists numversion] || ($numversion < "1050500")} {
	set temp(tag) "$mc_bw(script) $mc_bw(version)"
	putlog "$temp(tag) by MC_8 will only work on eggdrop 1.5.5 or greater."
	putlog "$temp(tag)  will not work with eggdrop $version."
	putlog "$temp(tag)  not loaded."
	return 1
}

setudef flag mc.bw.exemptvoice; setudef flag mc.bw.exemptop

if {![info exists mc_bw(access)] || ($mc_bw(access) == "")} {
	set mc_bw(access) "m|m"
}
if {![info exists mc_bw(database)]} {set mc_bw(database) "./.badwords.dat"}
if {![info exists mc_bw(exempt:flag)]} {set mc_bw(exempt:flag) ""}
if {![info exists mc_bw(warn_msgtype)] ||
    ![regexp -- {^[012]$} $mc_bw(warn_msgtype)]} {set mc_bw(warn_msgtype) 0}
if {![info exists mc_bw(warn_kick)]} {set mc_bw(warn_kick) 0}
if {![info exists mc_bw(warn_mode)]} {set mc_bw(warn_mode) ""}
if {![info exists mc_bw(bantime)]} {set mc_bw(bantime) 1440}
if {![info exists mc_bw(procmsg)]} {set mc_bw(procmsg) 0}
if {![info exists mc_bw(strip)]} {set mc_bw(strip) 0}
if {![info exists mc_bw(banmask)]} {set mc_bw(banmask) 2}
if {![info exists mc_bw(share:flag)] ||
     [regexp -- {[^A-Z]} [string index $mc_bw(share:flag) 0]]} {
	set mc_bw(share:flag) B
}
set mc_bw(share:flag) [string index $mc_bw(share:flag) 0]
if {![info exists mc_bw(relay:tx)]} {set mc_bw(relay:tx) 1}
if {![info exists mc_bw(relay:rx)]} {set mc_bw(relay:rx) 1}
if {![info exists mc_bw(relay:key)] || ($mc_bw(relay:key) == "")} {
	set mc_bw(relay:key) "key"
}

if {![info exists mc_bw(svs:enabled)]} {set mc_bw(svs:enabled) 0}
if {![info exists mc_bw(svs:check)]} {set mc_bw(svs:check) 3}
if {![info exists mc_bw(svs:notify)]} {set mc_bw(svs:notify) $owner}
if {![info exists mc_bw(svs:stableonly)]} {set mc_bw(svs:stableonly) 0}

# Error system, v2.0
proc mc:bw:error {bindproc error {arg ""}} {
	global mc_bw version lastbind
	putlog "Error in script $mc_bw(script) $mc_bw(version)."
	putlog "       Last bind: $lastbind"
	putlog "       Procedure: $bindproc"
	putlog "            Args: $arg"
	putlog " Eggdrop version: $version"
	putlog "     TCL version: [info tclversion]"
	putlog "  TCL Patchlevel: [info patchlevel]"
	putlog "*** Please tell MC_8 about this BUG!  Visit        "
	putlog "*** http://mc.purehype.net:81/bugzilla/ to do so.  "
	putlog "*** Please include the next line in the bug report."
	error $error
}

proc mc:bw:errchk {command arg} {
 if {[catch {eval $command $arg} return]} {
  mc:bw:error $command $return $arg; return 0
 }; return $return
}
# ^

# +badword [[#channel|&message|&global] <*bad*string*> [#warnings] [%expire <XdXhXm>] <kick/warning message>]
bind dcc - +badwords *mc:bw:dcc:+badword
proc *mc:bw:dcc:+badword {hand idx arg} {
 return [mc:bw:errchk *mc:bw:dcc:+badword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:+badword_ {hand idx arg} {
 global mc_bw
 if {$arg == ""} {
  control $idx mc:bw:control:+badword
  putdcc $idx "$mc_bw(script), entering +badword prompt interface."
  putdcc $idx "  To exit early: *bye*"
  putdcc $idx "______________________________________________"
  set mc_bw($idx:switch) 2
  set mc_bw($idx:arg) ""
  putdcc $idx ""
  putdcc $idx "\[#channel|message|global\] What channel?"
  return 0
 }
 if {[regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
  putdcc $idx "$mc_bw(script): Syntax should be\; +badword \[\[#channel|&message|&global\] <*bad*string*> \[#warnings\] \[%expire <XdXhXm>\] <kick/warning message>\]"
  return 0
 }
 set temp [mc:bw:inter:examin $arg $idx $hand +]
 set chan [lindex $temp 0]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [lindex $temp 1]
 set has_access [lindex $temp 2]
 set access [lindex $temp 3]
 set message [lindex $temp 4]
 set warnings [lindex $temp 5]
 set expire [lindex $temp 6]
 while {[regexp -- \\*\\* $string]} {regsub -all -- \\*\\* $string * string}
 if {([string index $chan 0] != "&") && (![validchan $chan])} {
  putcmdlog "#$hand# Denied (invalid channel): +badwords $arg"
  putdcc $idx "$mc_bw(script): Invalid channel: $chan"
  putdcc $idx "Syntax: +badword \[\[#channel|&message|&global\] <*bad*string*> \[#warnings\] \[%expire <XdXhXm>\] <kick/warning message>\]"
  return 0
 }
 if {$message == ""} {
  putcmdlog "#$hand# Denied (no message specified): +badwords $arg"
  putdcc $idx "$mc_bw(script): No message specified."
  putdcc $idx "Syntax: +badword \[\[#channel|&message|&global\] <*bad*string*> \[#warnings\] \[%expire <XdXhXm>\] <kick/warning message>\]"
  return 0
 }
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): +badwords $arg"
  putdcc $idx "$mc_bw(script):  Access denied:  '$access' is required."
  return 0
 }
 if {![mc:bw:inter:list add $chan $string $message $hand $warnings $expire . . -bad]} {
  putcmdlog "#$hand# Denied (already exists): +badwords $arg"
  putdcc $idx "$mc_bw(script):  Access denied, entry already exists."
  return 0
 }
 putcmdlog "#$hand# +badwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "$mc_bw(script):  Added '$string' (warn/kick msg: $message) to $x badwords list."
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
    if {[string index $arg 0] == "#"} {
     if {![validchan $arg]} {
      putdcc $idx "Invalid channel: $arg"
      set mc_bw($idx:switch) 1
      mc:bw:control:+badword $idx . ; return 0
     }
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
 return [mc:bw:errchk *mc:bw:dcc:+exemptword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:+exemptword_ {hand idx arg} {
 global mc_bw
 if {$arg == ""} {
  control $idx mc:bw:control:+exemptword
  putdcc $idx "$mc_bw(script), entering +exemptword prompt interface."
  putdcc $idx "  To exit early: *bye*"
  putdcc $idx "_________________________________________________"
  set mc_bw($idx:arg) ""
  putdcc $idx ""
  putdcc $idx "\[#channel|message|global\] What channel?"
  set mc_bw($idx:switch) 2
  return 0
 }
 if {[regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
  putdcc $idx "$mc_bw(script): Syntax should be\; +exemptword \[#channel|&message|&global\] <*exempt*string*> \[%expire <XdXhXm>\]"
  return 0
 }
 set temp [mc:bw:inter:examin $arg $idx $hand +]
 set chan [lindex $temp 0]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [lindex $temp 1]
 set has_access [lindex $temp 2]
 set access [lindex $temp 3]
 set expire [lindex $temp 6]
 while {[regexp -- \\*\\* $string]} {regsub -all -- \\*\\* $string * string}
 if {([string index $chan 0] != "&") && (![validchan $chan])} {
  putcmdlog "#$hand# Denied (invalid channel): +exemptwords $arg"
  putdcc $idx "$mc_bw(script): Invalid channel: $chan"
  putdcc $idx "Syntax: +exemptword \[\[#channel|&message|&global\] <*bad*string*> \[%expire <XdXhXm>\]\]"
  return 0
 }
 if {$string == ""} {
  putcmdlog "#$hand# Denied (no *exempt*string* specified): +exemptwords $arg"
  putdcc $idx "$mc_bw(script): No *exempt*string* specified."
  putdcc $idx "Syntax: +exemptword \[\[#channel|&message|&global\] <*bad*string*> \[%expire <XdXhXm>\]\]"
  return 0
 }
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): +exemptwords $arg"
  putdcc $idx "$mc_bw(script):  Access denied:  '$access' is required."
  return 0
 }
 if {![mc:bw:inter:list add $chan $string . $hand 0 $expire . . -exempt]} {
  putcmdlog "#$hand# Denied (already exists): +exemptwords $arg"
  putdcc $idx "$mc_bw(script):  Access denied, entry already exists."
  return 0
 }
 putcmdlog "#$hand# +exemptwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "$mc_bw(script):  Added '$string' to $x exemptwords list."
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
    if {[string index $arg 0] == "#"} {
     if {![validchan $arg]} {
      putdcc $idx "Invalid channel: $arg"
      set mc_bw($idx:switch) 1
      mc:bw:control:+exemptword $idx . ; return 0
     }
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
 return [mc:bw:errchk *mc:bw:dcc:-badword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:-badword_ {hand idx arg} {
 global mc_bw
 set temp [mc:bw:inter:examin $arg $idx $hand -]
 set chan [lindex $temp 0]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [lindex $temp 1]
 set has_access [lindex $temp 2]
 set access [lindex $temp 3]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): -badwords $arg"
  putdcc $idx "$mc_bw(script):  Access denied:  '$access' is required."
  return 0
 }
 if {($string == "") || ([regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg])} {
  putdcc $idx "$mc_bw(script): Syntax, should be\; -badword \[<#>channel|&message|&global\] <*bad*string*>"
  return 0
 }
 if {![mc:bw:inter:list rem $chan $string . . . . . . -bad]} {
  putcmdlog "#$hand# Denied (no entry): -badwords $arg"
  putdcc $idx "$mc_bw(script):  No such entry: $chan '$string'"
  return 0
 }
 putcmdlog "#$hand# -badwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "$mc_bw(script):  Removed '$string' from $x badwords list."
 return 0
}

# -exemptword [<#>channel|&message|&global] <*exempt*string*>
bind dcc - -exemptwords *mc:bw:dcc:-exemptword
proc *mc:bw:dcc:-exemptword {hand idx arg} {
 return [mc:bw:errchk *mc:bw:dcc:-exemptword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:-exemptword_ {hand idx arg} {
 global mc_bw
 set temp [mc:bw:inter:examin $arg $idx $hand -]
 set chan [lindex $temp 0]
 if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
 set string [lindex $temp 1]
 set has_access [lindex $temp 2]
 set access [lindex $temp 3]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): -exemptwords $arg"
  putdcc $idx "$mc_bw(script):  Access denied:  '$access' is required."
  return 0
 }
 if {($string == "") || ([regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg])} {
  putdcc $idx "$mc_bw(script): Invalid Syntax, should be\; -exemptword \[<#>channel|&message|&global\] <*exempt*string*>"
  return 0
 }
 if {![mc:bw:inter:list rem $chan $string . . . . . . -exempt]} {
  putcmdlog "#$hand# Denied (no entry): -exemptwords $arg"
  putdcc $idx "$mc_bw(script):  No such entry: $chan '$string'"
  return 0
 }
 putcmdlog "#$hand# -exemptwords $arg"
 switch -- $chan {
  &global {set x "the global"}
  &message {set x "messages"}
  default {set x "$chan's"}
 }
 putdcc $idx "$mc_bw(script):  Removed '$string' from $x exemptwords list."
 return 0
}

# badwords [<#>channel|&message|&global|all]
bind dcc - badwords *mc:bw:dcc:badword
proc *mc:bw:dcc:badword {hand idx arg} {
 return [mc:bw:errchk *mc:bw:dcc:badword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:badword_ {hand idx arg} {
 global mc_bw
 if {[regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
  putdcc $idx "$mc_bw(script): Syntax, should be\; badwords \[<#>channel|&message|&global|all\]"
  return 0
 }
 set temp [mc:bw:inter:examin $arg $idx $hand 0]
 set chan [lindex $temp 0]
 if {$chan == "&default"} {set chan "all"}
 set has_access [lindex $temp 2]
 set access [lindex $temp 3]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): badwords $chan"
  putdcc $idx "$mc_bw(script):  Access denied:  '$access' is required."
  return 0
 }
 putcmdlog "#$hand# badwords $chan"
 putdcc $idx "$mc_bw(script) listing for '$chan':"
 foreach line [mc:bw:inter:list list $chan . . . . . . . -bad] {
  set ta [lindex $line 1] ;# Time added
  set ch [lindex $line 2] ;# Channel
  set st [lindex $line 3] ;# String
  set ms [lindex $line 4] ;# Message
  set ad [lindex $line 5] ;# Added by
  set wn [lindex $line 6] ;# Warnings
  set ex [lindex $line 7] ;# Expires
  set lu [lindex $line 8] ;# Last used
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
 return [mc:bw:errchk *mc:bw:dcc:exemptword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:exemptword_ {hand idx arg} {
 global mc_bw
 if {[regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
  putdcc $idx "$mc_bw(script): Syntax, should be\; exemptwords \[<#>channel|&message|&global|all\]"
  return 0
 }
 set temp [mc:bw:inter:examin $arg $idx $hand 0]
 set chan [lindex $temp 0]
 if {$chan == "&default"} {set chan "all"}
 set has_access [lindex $temp 2]
 set access [lindex $temp 3]
 if {!$has_access} {
  putcmdlog "#$hand# Denied (no access): exemptwords $chan"
  putdcc $idx "$mc_bw(script):  Access denied:  '$access' is required."
  return 0
 }
 putcmdlog "#$hand# exemptwords $chan"
 putdcc $idx "Exemptwords listing for '$chan':"
 foreach line [mc:bw:inter:list list $chan . . . . . . . -exempt] {
  set ta [lindex $line 1] ;# Time added
  set ch [lindex $line 2] ;# Channel
  set st [lindex $line 3] ;# String
  set ad [lindex $line 5] ;# Added by
  set ex [lindex $line 7] ;# Expires
  set lu [lindex $line 8] ;# Last used
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
 return [mc:bw:errchk mc:bw:pubm_ [list $nick $uhost $hand $chan $arg]]
}
proc mc:bw:pubm_ {nick uhost hand chan arg} {
	mc:bw:bw $nick $uhost $hand $chan $arg pub
}

bind ctcp - ACTION mc:bw:ctcp
proc mc:bw:ctcp {nick uhost hand chan key arg} {
 return [mc:bw:errchk mc:bw:ctcp_ [list $nick $uhost $hand $chan $key $arg]]
}
proc mc:bw:ctcp_ {nick uhost hand chan key arg} {
 global botnick mc_bw
 mc:bw:bw $nick $uhost $hand $chan $arg action
 if {($mc_bw(procmsg)) && ($chan == [string tolower $botnick])} {
  foreach channel [channels] {mc:bw:bw $nick $uhost $hand $channel $arg action}
 }
}

bind notc - * mc:bw:notc
proc mc:bw:notc {nick uhost hand arg {chan {}}} {
	return [mc:bw:errchk mc:bw:notc_ [list $nick $uhost $hand $arg $chan]]
}
proc mc:bw:notc_ {nick uhost hand arg {chan {}}} {
	global botnick mc_bw
	if {$chan == ""} {set chan [string tolower $botnick]}
	regexp -- {^@?(.*)$} $chan dummy chan
	mc:bw:bw $nick $uhost $hand $chan $arg notice
	if {($mc_bw(procmsg)) && ($chan == [string tolower $botnick])} {
		foreach channel [channels] {
			mc:bw:bw $nick $uhost $hand $channel $arg notice
		}
	}
}

bind msgm - * mc:bw:msgm
proc mc:bw:msgm {nick uhost hand arg} {
 return [mc:bw:errchk mc:bw:msgm_ [list $nick $uhost $hand $arg]]
}
proc mc:bw:msgm_ {nick uhost hand arg} {
 global mc_bw botnick
 mc:bw:bw $nick $uhost $hand $botnick $arg msg
 if {$mc_bw(procmsg)} {
  foreach channel [channels] {mc:bw:bw $nick $uhost $hand $channel $arg msg}
 }
}

proc mc:bw:bw {nick uhost hand chan arg type} {
	return [mc:bw:errchk mc:bw:bw_ [list $nick $uhost $hand $chan $arg $type]]
}
proc mc:bw:bw_ {nick uhost hand chan arg type} {
	global botnick mc_bw botnet-nick
	set chan [string tolower $chan]
	if {([validchan $chan] &&
	     (
		 	  ([isop $nick $chan] && [mc:bw:chanflag $chan mc.bw.exemptop]) ||
	      ([isvoice $nick $chan] && [mc:bw:chanflag $chan mc.bw.exemptvoice]) ||
	      (($mc_bw(exempt:flag) != "") &&
	       [matchattr $hand $mc_bw(exempt:flag) $chan])
		   )
		  ) ||
		  (![validchan $chan] &&
		   (($mc_bw(exempt:flag) != "") && [matchattr $hand $mc_bw(exempt:flag)])
	    )} {return 0}
	if {$mc_bw(strip)} {set arg [mc:bw:strip:all $arg]}
	if {[isbotnick $chan]} {set chan "&message"}
	if {([mc:bw:inter:list match &global . $arg . . . . . -exempt] != "") ||
	    ([mc:bw:inter:list match $chan . $arg . . . . . -exempt] != "")} {
		return 0
	}
	if {
		([set line [mc:bw:inter:list match &global . $arg . . . . . -bad]] == "") &&
	  ([set line [mc:bw:inter:list match $chan . $arg . . . . . -bad]] == "")} {
		return 0
	}
	set l_cs [lindex $line 1] ;# Time added
	set l_ch [lindex $line 2] ;# Channel
	set l_st [lindex $line 3] ;# String
	set l_ms [lindex $line 4] ;# Message
	set l_ad [lindex $line 5] ;# Added by
	set l_wn [lindex $line 6] ;# Warnings
	set l_ex [lindex $line 7] ;# Expires
	set l_lu [lindex $line 8] ;# Last used
	set host [lindex [split $uhost @] end]
	if {$chan == "&message"} {set temp "private $type"} else {set temp $chan}
	set message [mc:bw:replace $l_ms [list %method  $type \
	                                       %channel $temp \
	                                       %string  $l_st \
	                                       %add     $l_ad]]
	set action ""
	if {[mc:bw:warn $host $chan $l_st $l_wn]} {
		switch -- $mc_bw(warn_msgtype) {
			0 {
				lappend action "warned (via private message)"
				puthelp "PRIVMSG $nick :$message"
			}
			1 {
				lappend action "warned (via private notice)"
				puthelp "NOTICE $nick :$message"
			}
		}
		if {$chan == "&message"} {
			set channels [string tolower [channels]]
			set x "to me"
		} else {
			set channels [list $chan]
			set x "in $chan"
		}
		if {$mc_bw(warn_msgtype) == "2"} {
			lappend action "warned (via public @ [join $channels ", "])"
		}
		foreach channel $channels {
			if {$mc_bw(warn_msgtype) == "2"} {
				puthelp "PRIVMSG $channel :$message"
			}
			if {($mc_bw(warn_mode) != "") && [botisop $channel]} {
				set temp [mc:bw:replace $mc_bw(warn_mode) [list %botnick $botnick \
				                                                %nick    $nick]]
				putserv "MODE $channel $temp"
				lappend action "mode changed attempt ($channel $temp)"
			}
			if {$mc_bw(warn_kick)} {
				if {![isop $botnick $channel] && ($chan == "&message") &&
				    $mc_bw(relay:tx)} {
					set temp_1 [list $mc_bw(relay:key) KICK $channel $nick $message]
					set temp_2 [encrypt $mc_bw(relay:key)+${botnet-nick} $temp_1]
					putallbots "badwords [list k $temp_2]"
					lappend action "relay kick request (not op'd in $channel)"
				} elseif {[onchan $nick $channel] && [botisop $channel]} {
					putkick $channel $nick $message
					lappend action "kicked ($channel)"
				}
			}
		}
		set temp_1 "$nick was caught saying '$l_st' $x."
		putlog "$mc_bw(script): $temp_1  Action taken: [join $action ", "]"
	}	else {
		set banmask [mc:bw:inter:masktype $nick!$uhost $mc_bw(banmask)]
		set global [string match @* $mc_bw(bantime)]
		if {[string match *! $mc_bw(bantime)]} {
			set option sticky
		} else {
			set option none
		}
		set ban_time [string trim $mc_bw(bantime) @!]
		if {$ban_time == "-2"} {
			set ban_time ""
			set duration "Perm Ban"
		} elseif {$ban_time > "0"} {
			set duration [duration [expr $ban_time*60]]
		} else {
			set duration "Server Ban"
		}
		if {$global || ($chan == "&message")} {
			foreach channel [channels] {
				if {![botisop $channel] && ($chan == "&message") && $mc_bw(relay:tx)} {
					set temp ""
					if {$ban_time != "-1"} {
						set temp_1 [list $mc_bw(relay:key) BAN $channel	$banmask]
						set temp_2 [encrypt $mc_bw(relay:key)+${botnet-nick} $temp_1]
						putallbots "badwords [list k $temp_2]"
						set temp " and ban"
					}
					set temp_1 [list $mc_bw(relay:key) KICK $channel $nick $message]
					set temp_2 [encrypt $mc_bw(relay:key)+${botnet-nick} $temp_1]
					putallbots "badwords [list k $temp_2]"
					lappend action "relay kick$temp request (not op'd in $channel)"
				} else {
					set x 0
					if {([mc:bw:inter:findchanuser $banmask $channel] != "") &&
					    [botisop $channel]} {
						if {$ban_time != "-1"} {
							pushmode $channel +b $banmask
							incr x 1
						}
					}
					if {[onchan $nick $channel] && [botisop $channel]} {
						putkick $channel $nick $message
						incr x 2
					}
					switch -- $x {
						1 {lappend action "banned ($channel)"}
						2 {lappend action "kicked ($channel)"}
						3 {lappend action "kicked and banned ($channel)"}
					}
				}
			}
			if {$ban_time > "0"} {
				newban $banmask $l_ad $message $ban_time $option
				if {$option == "none"} {set temp ""} else {set temp " sticky"}
				set temp_1 "(Duration: $duration)"
				lappend action "added global$temp ban in bots banlist $temp_1"
			}
		} else {
			set x 0
			if {([mc:bw:inter:findchanuser $banmask $chan] != "") &&
			    [botisop $chan]} {
				if {$ban_time != "-1"} {
					pushmode $chan +b $banmask
					incr x 1
				}
			}
			if {[onchan $nick $chan] && [botisop $chan]} {
				putkick $chan $nick $message
				incr x 2
			}
			switch -- $x {
				1 {lappend action "banned ($chan)"}
				2 {lappend action "kicked ($chan)"}
				3 {lappend action "kicked and banned ($chan)"}
			}
			if {$ban_time > "0"} {
				newchanban $chan $banmask $l_ad $message $ban_time $option
				if {$option == "none"} {set temp ""} else {set temp " sticky"}
				set temp_1 "(Duration: $duration)"
				lappend action "added $chan$temp channel ban in bots banlist $temp_1"
			}
		}
		if {$chan == "&message"} {set x "to me"} else {set x "in $chan"}
		set temp_1 "Action taken: [join $action ", "]"
		putlog "$mc_bw(script): $nick was caught saying '$l_st' $x.  $temp_1"
	}
}

bind bot - badwords mc:bw:bot
proc mc:bw:bot {from command arg} {
	return [mc:bw:errchk mc:bw:bot_ [list $from $command $arg]]
}
proc mc:bw:bot_ {from command arg} {
	global mc_bw botnick
	set crypt [lindex $arg 0]
	if {$crypt == "k"} {
		set arg [decrypt "$mc_bw(relay:key)+$from" [lindex $arg 1]]
		if {[lindex $arg 0] != $mc_bw(relay:key)} {return 0}
		set arg [lrange $arg 1 end]
	} elseif {$crypt == "n"} {set arg [lrange $arg 1 end]} \
	else {return 0}
	set cmd [lindex $arg 0]   ;# command
	set a [lindex $arg 1]     ;# channel
	set b [lindex $arg 2]     ;# kick=nick, ban=banmask
	set c [lindex $arg 3]     ;# kick=message
	if {[regexp -- {^(KICK|BAN)$} $cmd] && (![validchan $a] || ![botisop $a])} {
		return 0
	}
	switch -- $cmd {
		KICK {
			putkick $a $b $c
			putloglev b * "$mc_bw(script): Relay from $from, kicking $b from $a."
		}
		BAN {
			pushmode $a +b $b
			putloglev b * "$mc_bw(script): Relay from $from, banning $b in $a."
		}
		share {
			# > x share cmd arg
			set cmd [lindex $arg 1]
			set ty [lindex $arg 2]
			set ch [lindex $arg 3]
			if {![validchan $ch]} {
				set access [matchattr $from b$mc_bw(share:flag)|]
			} elseif {[validchan $ch]} {
				set access [matchattr $from b$mc_bw(share:flag)|$mc_bw(share:flag) $ch]
			} else {set access 0}
			if {!$access && ($cmd != "U")} {return 0}
			set st [lindex $arg 4]
			set ms [lindex $arg 5]
			set hd [lindex $arg 6]
			set wn [lindex $arg 7]
			set ex [lindex $arg 8]
			set lu [lindex $arg 9]
			set q [lindex $arg 10]
			set vt [string trimleft $ty -]
			switch -- $cmd {
				add {
					if {![mc:bw:inter:list add $ch $st $ms $hd $wn $ex . NO $ty]} {
						mc:bw:inter:list update $ch $st $ms $hd $wn $ex $lu NO $ty
					}
					set temp(1) "Share from $from"
					putloglev b * "$mc_bw(script): $temp(1), added ${vt}word: $ch $st"
				}
				load {
					if {![mc:bw:inter:list add $ch $st $ms $hd $wn $ex . NO $ty]} {
						mc:bw:inter:list update $ch $st $ms $hd $wn $ex $lu NO $ty
					}
				}
				rem {
					mc:bw:inter:list rem $ch $st . . . . . NO $ty
					if {$ms != ""} {set ms "($ms)"}
					set temp(1) "Share from $from, removed"
					putloglev b * "$mc_bw(script): $temp(1) ${vt}word: $ch $st $ms"
				}
				U { mc:bw:inter:list save -quiet; mc:bw:inter:list load $from }
				update {
					if {![mc:bw:inter:list update $ch $st $ms $hd $wn $ex $lu NO $ty]} {
						mc:bw:inter:list add $ch $st $ms $hd $wn $ex . NO $ty
					}
					if {$q != "-quiet"} {
						set temp(1) "Share from $from, updated"
						putloglev b * "$mc_bw(script): $temp(1) ${vt}word: $ch $st"
					}
				}
				default {
					set temp(1) "Share from $from, unknown"
					putloglev b * "$mc_bw(script): $temp(1) request: $cmd"
				}
			}
		}
		default {
			putloglev b * "$mc_bw(script):  Relay from $from, unknown request: $cmd"
		}
	}
}

bind link - * mc:bw:link
proc mc:bw:link {bot via} {
 return [mc:bw:errchk mc:bw:link_ [list $bot $via]]
}
proc mc:bw:link_ {bot via} {mc:bw:inter:share U:$bot}

#   mc:bw:inter:share add [list $type $chan $string $text $hand $warnings $expire 0]
#   mc:bw:inter:share rem [list $type $chan $string $text]
#   mc:bw:inter:share update [list $type $chan $string $text $hand $warnings $expire $lu]
#   mc:bw:inter:share load:<bot> [list $type $ch $st $ms $ad $wn $ex $lu]
#   mc:bw:inter:share U:<bot>
# > x share cmd arg
proc mc:bw:inter:share {command {arg {}}} {
 global mc_bw
 set chan [lindex $arg 0]
 set cmd [string range $command 0 [expr [string first : $command]-1]]
 set bot [string range $command [expr [string first : $command]+1] end]
 if {$cmd == "U"} {
  if {$bot == "-all"} {putallbots [list badwords n share U]} elseif {[islinked $bot]} {
   putbot $bot [list badwords n share U]
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
   if {$access} {putbot $_bot "[list badwords n share load] $arg"}
  }; return
 }
 if {[string index $chan 0] != "#"} {set userlist [userlist b$mc_bw(share:flag)|]} elseif {[validchan $chan]} {
  set userlist [userlist b$mc_bw(share:flag)|$mc_bw(share:flag) $chan]
 } else {set userlist ""}
 foreach bot $userlist {
  if {![islinked $bot]} {continue}
  putbot $bot "[list badwords n share $command] $arg"
 }
}

# {-(bad|exempt) time_added channel string message added_by warnings expire lastused}
proc mc:bw:inter:list {cmd {chan {}} {string {}} {text {}} {hand {}} \
                       {warnings {}} {expire {}} {lu {}} {q {}} {type {}}} {
	return [mc:bw:errchk mc:bw:inter:list_ [list $cmd $chan $string $text $hand \
                                               $warnings $expire $lu $q $type]]
}
proc mc:bw:inter:list_ {cmd chan string text hand warnings expire lu q type} {
 global mc_bw {botnet-nick}
 set chan [string tolower $chan]
 if {![info exists mc_bw(list)]} {set mc_bw(list) ""}
 switch -- $cmd {
  add {
   if {[mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
   lappend mc_bw(list) [list $type [clock seconds] $chan $string [string range $text 0 299] $hand $warnings $expire 0]
   mc:bw:inter:list save -quiet
   mc:bw:inter:list expire . . . . . . . . $type
   if {$q != "NO"} {
    mc:bw:inter:share add [list $type $chan $string $text $hand $warnings $expire 0]
   };return 1
  }
  exists {
   foreach line $mc_bw(list) {
    set a [lindex $line 0]; set b [lindex $line 2]; set c [lindex $line 3]
    if {[string tolower "$a $b $c"] == [string tolower "$type $chan $string"]} {return 1}
   };return 0
  }
  expire {
   while {[regexp -- "\[0-9\]* \{mc:bw:inter:list expire . . . . . . . . $type\} timer\[0-9\]*" [utimers] timer]} {
    killutimer [lindex $timer 2]
   }
   set ex 0
   foreach line [lsort -dictionary -index 6 [mc:bw:inter:list list all . . . . . . . $type]] {
    set cs [lindex $line 1] ;# Time added
    set ch [lindex $line 2] ;# Channel
    set st [lindex $line 3] ;# String
    set ms [lindex $line 4] ;# Message
    set ad [lindex $line 5] ;# Added by
    set wn [lindex $line 6] ;# Warnings
    set ex [lindex $line 7] ;# Expires
    set lu [lindex $line 8] ;# Last used
    if {!$ex} {continue}
    if {[clock seconds] >= $ex} {
     mc:bw:inter:list rem $ch $st expired . . . . . $type
     switch -- $ch {
      &global {set x "the global"}
      &message {set x "messages"}
      default {set x "$chan's"}
     }
     putlog "$mc_bw(script):  Removed '$st' from $x [string trimleft ${type} -]words list. (expired)"
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
    if {$type != [lindex $line 0]} {continue}
    if {([string tolower $chan] == [string tolower [lindex $line 2]]) ||
        ([string tolower $chan] == "all")} {lappend return $line}
   };return "[lsort -dictionary -index 1 [lsort -dictionary -index 0 $return]]"
  }
	load {
		set mc_bw(list) ""
		if {![file exists $mc_bw(database)]} {close [open $mc_bw(database) w]}
		set io [open $mc_bw(database) r]
		set db_ver ""
		if {![eof $io]} { regexp -- {^#v[0-9]*:} [gets $io] db_ver }
		while {![eof $io]} {
			gets $io line
			if {([string trim $line " "] == "") ||
			    ([string index $line 0] == "#")} {continue}
			switch -- $db_ver {
				"#v1:"  { set temp(line) "-bad $line 0 0 0" }
				"#v2:"  { set temp(line) "-bad $line"       }
				"#v3:"  { set temp(line) $line              }
				default { set temp(line) "-bad $line 0 0 0" }
			}
			set ty [lindex $temp(line) 0] ;# Type
			set ta [lindex $temp(line) 1] ;# Time added
			set ch [lindex $temp(line) 2] ;# Channel
			set st [lindex $temp(line) 3] ;# String
			set ms [lindex $temp(line) 4] ;# Message
			set ad [lindex $temp(line) 5] ;# Added by
			set wn [lindex $temp(line) 6] ;# Warnings
			set ex [lindex $temp(line) 7] ;# Expires
			set lu [lindex $temp(line) 8] ;# Last used

			# Scan format, ensure correct before load.
			set temp(skip) 0
			    if {![regexp {^-(bad|exempt)$} $ty]} {set temp(skip) 1} \
			elseif {[regexp {^[^0-9]$} $ta]} {set temp(skip) 1} \
			elseif {$ch == ""} {set temp(skip) 1} \
			elseif {$st == ""} {set temp(skip) 1} \
			elseif {$ad == ""} {set temp(skip) 1} \
			elseif {[regexp {^[^0-9]$} $wn]} {set temp(skip) 1} \
			elseif {[regexp {^[^0-9]$} $ex]} {set temp(skip) 1} \
			elseif {[regexp {^[^0-9]$} $lu]} {set temp(skip) 1}
			if {$temp(skip)} {
				set temp(1) "Loading datafile, skipping '$temp(line)'"
				putloglev d * "$mc_bw(script):  $temp(1).  INVALID FORMAT"
				continue
			}
			# ^

			lappend mc_bw(list) $temp(line)
			mc:bw:inter:share load:$chan [list $ty $ch $st $ms $ad $wn $ex $lu]
		}
		close $io
		mc:bw:inter:list expire . . . . . . . . -exempt
		mc:bw:inter:list expire . . . . . . . . -bad
		return 1
	}
  match {
   foreach line [mc:bw:inter:list list $chan . . . . . . . $type] {
    set cs [lindex $line 1] ;# Time added
    set ch [lindex $line 2] ;# Channel
    set st [lindex $line 3] ;# String
    set ms [lindex $line 4] ;# Message
    set ad [lindex $line 5] ;# Added by
    set wn [lindex $line 6] ;# Warnings
    set ex [lindex $line 7] ;# Expires
    set lu [lindex $line 8] ;# Last used
    if {(($mc_bw(use:regexp)) &&
         ([regexp -- [string tolower $st] [string tolower $text]])) ||
        ((!$mc_bw(use:regexp)) &&
         ([string match [string tolower $st] [string tolower $text]]))} {
     mc:bw:inter:list update $chan $st $ms $ad $wn $ex [clock seconds] -quiet $type
     return $line
    }
   }; return ""
  }
  rem {
   if {![mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
   set list ""
   foreach line $mc_bw(list) {
    if {[string tolower "[list [lindex $line 0]] [lrange $line 2 3]"] != [string tolower [list $type $chan $string]]} {
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
    set ty [lindex $line 0] ;# Type
    set ta [lindex $line 1] ;# Time added
    set ch [lindex $line 2] ;# Channel
    set st [lindex $line 3] ;# String
    if {[string tolower "$ty $ch $st"] == [string tolower "$type $chan $string"]} {
     lappend list [list $ty $ta $chan $string $text $hand $warnings $expire $lu]
    } else {lappend list $line}
   }; set mc_bw(list) $list
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
 } elseif {[string index [set temp [lindex $arg 0]] 0] == "&"} {
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
  append access " $chan"
 }
 if {$ar == "-"} {
  set string [join [lrange $arg $x end]]
  set warnings ""
  set message ""
  set expire ""
 } else {
  set string [lindex $arg $x];incr x
  if {[string index [set temp [lindex $arg $x]] 0] == "#"} {
   set warnings [string range $temp 1 end];incr x
  } {set warnings 0}
  if {[string index [set temp [lindex $arg $x]] 0] == "%"} {
   set expire [mc:bw:inter:exp2cs [string range $temp 1 end]];incr x
  } {set expire 0}
  set message [lrange $arg $x end]
 }
 return [list $chan $string $has_access $access $message $warnings $expire]
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

# in: n!u@h #chan -- WC Accepted
#out: [nick [nick [...]]]
proc mc:bw:inter:findchanuser {hostmask channel} {
 if {![validchan $channel]} {return -code error "no such channel record"} ; set buffer ""
 set hostmask [string tolower $hostmask]
 foreach user [chanlist $channel] {
  if {[string match $hostmask [string tolower $user![getchanhost $user $channel]]]} {
   lappend buffer $user
  }
 }; return $buffer
}

# v1.1
proc mc:bw:replace {text subs} {
	if {![catch {string map -nocase $subs $text} output]} {return $output}
	for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
		set temp(re_syntax) {([\\\*\+\?\{\}\,\(\)\:\[\]\.\^\$\=\!\|])}
		regsub -all -- $temp(re_syntax) [lindex $subs $i] {\\\1} temp(temp)
		regsub -all -- $temp(temp) $text [lindex $subs [expr $i+1]] text
	}; return $text
}

# v1.1
proc mc:bw:strip:all {text} {
	regsub -all -- {\002} $text "" text ;#bold
	regsub -all -- {\003([0-9][0-9]?(,[0-9][0-9]?)?)?} $text "" text ;#color
	regsub -all -- {\017} $text "" text ;#normal
	regsub -all -- {\026} $text "" text ;#reverse
	regsub -all -- {\037} $text "" text ;#underline
	return $text
}

# v2.0
proc mc:bw:chanflag {channel flag} {
 if {[lsearch -exact [string tolower [channel info $channel]] +[string tolower $flag]] == "-1"} {return 0}
 return 1
}

# v1.3
proc mc:bw:inter:masktype {nuhost type} {
	set ident_max-length 9
	set host_max-length 63
	scan $nuhost {%[^!]!%s} nick uhost
	set temp(split_uhost) [split $uhost @]
	set temp(1) [expr [llength $temp(split_uhost)]-2]
	set ident [join [lrange $temp(split_uhost) 0 $temp(1)] @]
	set host [lindex $temp(split_uhost) end]
	set maskhost 1
	if {[regexp -- {^1[0-9]$} $type]} {
		set temp(w) {([0-9][0-9]?[0-9]?)}
		set temp(x) "^$temp(w)\\.$temp(w)\\.$temp(w)\\.$temp(w)\$"
		if {!(([regexp -- $temp(x) $host temp(1) a b c d]) &&
		     ($a > 0 && $a <= 255 && $b <= 255 && $c <= 255 && $d <= 255))} {
			regsub -all -- {[0-9]} $host ? host
			set maskhost 0
		}
		set type [string index $type 1]
	}
	if {[regexp -- {^[0-4]$} $type]} {set nick "*"}
	if {[regexp -- {^[2479]$} $type]} {set ident "*"}
	if {[regexp -- {^[1368]$} $type]} {regsub -- {^~?(.*)$} $ident *\\1 ident}
	if {[regexp -- {^[3489]$} $type]} {
		if {$maskhost} {set host [lindex [split [maskhost $host] @] end]}
	}
	if {[set cache(x) [string length $ident]] > ${ident_max-length}} {
		set ident "*[string range $ident [expr $cache(x)-${ident_max-length}] end]"
	}
	if {[set cache(x) [string length $host]] > ${host_max-length}} {
		set host "*[string range $host [expr $cache(x)-${host_max-length}] end]"
	}
	return [format "%s!%s@%s" $nick $ident $host]
}

bind evnt - save mc:bw:evnt
proc mc:bw:evnt {type} {return [mc:bw:errchk mc:bw:evnt_ [list $type]]}
proc mc:bw:evnt_ {type} {mc:bw:inter:list save}; mc:bw:inter:list load -all

## SVS v2.2
if {![info exists mc_bw(svs:mode)] ||
    ![regexp -- {^1|0$} $mc_bw(svs:mode)]} {set mc_bw(svs:mode) 2}
if {![info exists mc_bw(svs:notify)]} {
	if {![info exists owner]} {set owner ""}
	set mc_bw(svs:notify) $owner
}

bind time - "00 00 *" mc:bw:do_svs
proc mc:bw:do_svs {{args ""}} {
	global mc_bw
	if {!$mc_bw(svs:mode)} {return 0}
	if {[catch {
	        socket -async $mc_bw(svs:server) $mc_bw(svs:port)
	           } sid]} {
		putloglev d * "$mc_bw(script): SVS socket error: $sid"
		return 1
	}
	fconfigure $sid -blocking 0 -buffering line
	set tout [after 60000 "mc:bw:svs_talk $sid timeout"]
	fileevent $sid readable "mc:bw:svs_talk $sid $tout"
	puts $sid "GET $mc_bw(svs:get)?$mc_bw(svs:query) HTTP/1.0\
	         \nHost: $mc_bw(svs:server):$mc_bw(svs:port)\n"
	flush $sid
}

proc mc:bw:svs_talk {sid tout} {
	global mc_bw
	set array [list svs temp $sid]
	if {$tout == "timeout"} {
		set temp(1) "$mc_bw(svs:server):$mc_bw(svs:port)"
		putloglev d * \
			"$mc_bw(script): SVS Warning: Timed out connecting to $temp(1)."
		catch {unset mc_bw($array)}
		close $sid
		return 0
	}
	if {[eof $sid]} {
		catch {unset mc_bw($array)}
		close $sid
		return 1
	}
	gets $sid get
	after cancel $tout
	if {![info exist mc_bw($array)]} {
		if {$get == ""} {set mc_bw($array) 1}
		return -1
	}
	if {($get == "") || [catch {llength $get}]} {
		return -2
	}
	switch -- [lindex $get 0] {
		003 {
			set temp(reply) [lrange $get 1 end]
			set temp(reply:0) [lindex $temp(reply) 0]
			set temp(reply:1) [lindex $temp(reply) 1]
			set temp(reply:2) [lindex $temp(reply) 2]
			set temp(reply:3) [lindex $temp(reply) 3]
			set temp(reply:4) [lindex $temp(reply) 4]
			set temp(reply:5) [lindex $temp(reply) 5]
			if {$temp(reply:0) != $mc_bw(svs:script)} {
				set temp(1) "wanted $mc_bw(svs:script), got $temp(reply:0)"
				putloglev d * "$mc_bw(script): SVS Error: $temp(1)"
				unset mc_bw($array)
				close $sid
				return -3
			}
			if {$mc_bw(svs:mode) == "1"} {
				set temp(svs:version) [string range $mc_bw(svs:version) 0 8]999
			} else {
				set temp(svs:version) [string range $mc_bw(svs:version) 0 11]
			}
			if {$temp(reply:1) > $temp(svs:version)} {
				set temp(note) $temp(reply:5)
				regsub -all -- %0 $temp(note) $temp(reply:0) temp(note)
				regsub -all -- %1 $temp(note) $temp(reply:1) temp(note)
				regsub -all -- %2 $temp(note) $temp(reply:2) temp(note)
				regsub -all -- %3 $temp(note) $temp(reply:3) temp(note)
				regsub -all -- %4 $temp(note) $temp(reply:4) temp(note)
				regsub -all -- %version $temp(note) $mc_bw(version) temp(note)
				foreach temp(to) [split $mc_bw(svs:notify) ",; "] {
					if {$temp(to) == ""} {continue}
					regsub -- %nick $temp(note) $temp(to) temp(note2)
					set temp(lunotes) [notes $temp(to) -[notes $temp(to)]]]
					if {[string match *$temp(note2)* $temp(lunotes)]} {
						set temp(found_note) 0
						foreach temp(unote) $temp(lunotes) {
							if {$temp(note2) == [lindex $temp(unote) 2]} {
								set temp(found_note) 1
								break
							}
						}
						if {$temp(found_note)} {continue}
					}
					set temp(error) "sending note to $temp(to) -> "
					switch -- [sendnote SVS $temp(to) $temp(note2)] {
						0 {
							if {![validuser $temp(to)]} {
								append temp(error) "invalid user"
							} else {append temp(error) "unknown error"}
							putloglev d * \
								"$mc_bw(script): SVS sendnote error: $temp(error)"
						}
						3 {
							append temp(error) "notebox too full"
							putloglev d * \
								"$mc_bw(script): SVS sendnote error: $temp(error)"
						}
					}
				}
			}
			unset mc_bw($array)
			close $sid
			return 2
		}
	}
}
## ^

putlog "$mc_bw(script) $mc_bw(version) by MC_8 loaded."

##
# HISTORY  ( <Fixed by> - [Found by] - <Info> )
##
# v4.0.2 (06.27.02)
#  MC_8 - Schnups   - Fixed 'Tcl error [mc:bw:msgm]: invalid channel: &message'.
#                     Bugzilla bug: 107
#  MC_8 - Mustang97 - Moved the history to the bottom.  While it's still important to
#                     those whom want to see what changed as to base there reasoning
#                     for upgrading, it's now out of the way so the newbies don't go
#                     crazy trying to 'read the whole thing' (is what I tell people
#                     that don't understand something and it's already mentioned)
#                     when they really don't NEED to know history changes.
#  MC_8 - kk_       - Upgraded SVS.  v2.1 -> v2.2
#
# v4.0.1 (06.19.02)
#  MC_8 -         - Cleaned up the formatting and working of all comments before
#                   coding.
#  MC_8 -         - Rewrote 'mc:bw:bw_' proc, it was ugly and unformat'd.
#  MC_8 -         - Fixed conversion of string->list format for channel veriable
#                   within the mc:bw:bw_ proc.
#  MC_8 -         - Removed settings 'exempt:op' and 'exempt:voice', don't know
#                   why I have that there when I have channel specific
#                   'mc.bw.exemptop' and 'mc.bw.exemptvoice' flags.
#  MC_8 - Ovidiu/ - Fixed 'Tcl error [mc:bw:bot]: illegal channel: U'.
#         dork/     Bugzilla bug: 106
#         nonREAL
#
# v4.0 (06.18.02)
#  MC_8 - Jürgen    - Upgraded masktype proc, was giving error 'couldn't set
#                     variable "temp"'.  v1.2 -> v1.3
#  MC_8 -           - Upgraded SVS.  v2.0 -> v2.1
#  MC_8 - dork/     - Added scan system on datafile load to ensure it's trying
#         nonREAL/    to load a valid line of data.
#         Rami        Bugzilla bug: 105
#                     Bugzilla bug: 91
#                     Bugzilla bug: 89
#  MC_8 -           - Fixed 'can't read " #abc123": no such variable'.
#                     Bugzilla bug: 95
#  MC_8 - Alexander - Fixed '[mc:bw:bot]: can't read "key": no such variable'.
#                     Bugzilla bug: 94
#  MC_8 -           - Putting a 300 character restriction on badword reasons,
#                     botnet communications only support up to 300 -- the exta
#                     100 is for other informtion pertaning to that perticular
#                     badword entry.
#  MC_8 -           - Script was using [join [lindex ...]], don't know why...
#                     that's improper list usage and would cause bugs later on.
#  MC_8 -           - Changed how the bot communicates over the botnet, now
#                     encrypted.  Due to the totally different way this script
#                     shares info over the botnet, I'm going to up this to
#                     version 4.0, older version are not botnet compatable with
#                     this new communication method.
#  MC_8 -           - Bot wasn't communicating in proper list format over the
#                     botnet.
#                     Bugzilla bug: 88
#  MC_8 -           - Fixed a double listing error in 'findchanuser' proc.
#  MC_8 -           - Upgraded 'replace' proc.  v1.0 -> v1.1
#  MC_8 -           - Replaced 'chanflagison' with 'chanflag' proc.  -> v2.0
#  MC_8 -           - Upgraded 'masktype' proc, fixed some minor errors.
#                       o If ident@host == test@me@192.168.0.1, it would set
#                         ident to 'test' and host to 'me@192.168.0.1'.
#                       o Types *1,3,6,8 is support to remove the ident's first
#                         ~.  It was removing all continues (from left) ~'s.
#                       o A little more efficent, by cache'n some commands.
#                     v1.1 -> v1.2
#  MC_8 -           - Added the 'normal' character coad to 'strip:all' proc.
#                     old -> v1.1
#                     Bugzilla bug: 71
#  MC_8 - niklas    - Added information to 'Information' field.
#                     Bugzilla bug: 67
#  MC_8 - Lisa      - Fixed 'can't read "db_ver": no such variable'.
#  MC_8 -           - Added a better error output system, for debugging
#                     purposes.
#  MC_8 -           - Fixed onotice errors; '[mc:bw:notc]: illegal channel:
#                     @#channel'.
#                     Bugzilla bug: 61
#  MC_8 -           - Fixed error in masktype proc; if type is 10-19 and the
#                     host is an ip and it has a 255 in any of the 4 atoms- it
#                     would be treated as a host rather than an ip.
#  MC_8 - skuum     - Added ability to make a ban sticky via bantime setting.
#                     Bugzilla bug: 58
#  MC_8 -           - Added exempt:op, exempt:voice.  Also changed exempt to
#                     exempt:flag.
#                     Bugzilla bug: 56
#
# v3.1 (11.14.01)
#  MC_8 -        - Updated SVS.  v1.3 -> v2.0.
#  MC_8 -        - Added help argument to show proper syntax for all commands,
#                     .<command> -?
#  MC_8 -        - Fixed 'Invalid channel option: #channel', in .+badword or
#                     +exemptword prompt interface.
#  MC_8 - Dr.W95 - Added use:regexp.
#
# v3.0.1 (10.30.01)
#  MC_8 -              - Rewrote explination of ban masking types.
#  MC_8 -              - Rewrote the ban masking proc again, much smaller now.
#  MC_8 -              - Ban types 10-19 were not masking the host.domain
#                        correctly if it was an ip address.
#  MC_8 -              - Ban type 3, 4, 8 and 9 wasn't masking the host
#                        correctly.
#  MC_8 - Morpheus233  - Ban types 10-19 were giving tcl errors.  'TCL error
#                        [mc:bw:pubm]: syntax error in expression "[regexp --
#                        {^1[0-9]$} $type] &&', fixed.
#  MC_8 -              - Added share:flag configuration option.
#  MC_8 - Morpheus233/ - Fixed 'TCL error [mc:bw:pubm]: can't read "channel": no
#         Daniel         such veriable'.
#  MC_8 - Dr.W95       - Added warn_msgtype configuration option.
#  MC_8 -              - Made minor changes to the SVS client section -- to give
#                        proper error if an invalid user is specified to recieve
#                        a notification of a newer version.
#  MC_8 -              - Remove *inter:str proc, replaced with format's insted
#                        (more efficient).
#  MC_8 -              - Rewrote the ban masking proc, it's quicker.
#  MC_8 -              - Removed the findip proc.
#
# v3.0 (10.14.01)
#  MC_8 -       - Added prompt interfact for +(bad|exempt)word.
#  MC_8 -       - Bots were flooding "U" on load via botnet link.
#  MC_8 -       - Bot was getting flooded down with utimers.
#  MC_8 -       - Entrie expire time wasn't working.
#  MC_8 -       - Added dcc commands; exemptwords, +exemptword, -exemptword
#  MC_8 - ckitt - Fixed 'invalid command name ...' dealing with  '("1-2" arm
#                 line 1)' (part of the db auto conversion).
#  MC_8 -       - Added catches to not put a kick (nor ban) on the channel if
#                 the user (or banmask) isn't on the channel, saves bandwidth
#                 and also makes the listed 'Actions:' performed smaller.
#  MC_8 - ckitt - Relay kick message has a prepending ':' that shouldn't be
#                 there.
#  MC_8 - ckitt - Added ability to share badwords entries among the botnet.
#  MC_8 -       - Since expire, last used, and warnings are now used per entry,
#                 the database version has changed to v2.  I coded in an auto db
#                 converter to convert v1 to v2.
#  MC_8 -       - Added last used visual.
#  MC_8 -       - Added expire option.
#  MC_8 -       - After exceeding warnings the bot was starting warning's over
#                 again at 0, for the user -- fixed.
#  MC_8 -       - Fixed `TCL error [mc:bw:???]: illegal channel: <bots irc
#                 nick>`.  This error doesn't occure on undernet, was found on
#                 dalnet.
#  MC_8 -       - If bantime was set to -1, it wasn't kicking as well.  Fixed.
#  MC_8 -       - It is no longer manditory to quote the *bad*string* upon
#                 removal if it contains a space.
#  MC_8 -       - It now gives a better explination of what actions were taken
#                 upon catching a violator.
#  MC_8 - ckitt - Added botnet relay features.
#  MC_8 -       - Fixed special character handling for bad word strings.
#  MC_8 -       - Change kickop and kickvoice to exemptop and exemptvoice.
#  MC_8 - ckitt - Wasn't kicking after setting a ban for bad word match on
#                 private (notice/ msg/ action)'s.
#  MC_8 - ckitt - Further adjusted replacment veriable messages.
#  MC_8 - ckitt - On &global and &message's, the %channel replacment veriable
#                 was looking like "%channelglobal".  Fixed.
#  MC_8 - ckitt - The bot was kicking before banning -- I put kicks and bans on
#                 the same queue (putserv).
#  MC_8 - ckitt - Fixed 'TCL error [mc:bw:pubm]: invalid command name
#                 "mc:bwerd:inter:findip"'.
#  MC_8 - ckitt - Fixed documentation about chanset flags.
#  MC_8 -       - Dcc command wasn't recognizing option "all".
#  MC_8 -       - Changed the scripts name from Bad Werds to Bad Words.
#  MC_8 -       - To many changes to document -- I rewrote the entire script.
#
# v2.0 (06.27.01)
#  MC_8 - Sara    - Added a few examples within the command syntax layout.
#  MC_8 - ICU     - Fixed +/-badword dcc command requirment for the *bad*word*.
#  MC_8 - Rami    - Fixed `Tcl error [mc:msgm:weed]: wrong # args: should be
#                   "foreach varList list ?varList list ...? command"`.
#  MC_8 - KatzEye - Added ability to have perm bans, insted of timed bans.
#  MC_8 - KatzEye - Added ability to have the ban's global or channel specific.
#  MC_8 -         - Updated SVS to v1.2
#  MC_8 -         - Made the badword strings settable via dcc (on the fly)
#                   rather than editing them within the script.
#
# v1.11 (01.31.01)
#  (( Opps, forgot to log history changes for this version. ))
#
# v1.10.1 (02.01.01)
#  MC_8 -          - Added SVS.
#  MC_8 - Lawrence - Added warn_mode, to change user modes upon warning.
#
# v1.10 (08.14.00)
#  MC_8 - John Lange - Removed the ignore procedure.
#  MC_8 -            - Fixed, 'Tcl error [mc:weed]: invalid command name
#                      "findip"'.
#  MC_8 -            - Fixed, 'Tcl error [mc:weed:act]: illegal channel: police'
#                      This assuming your bot's nick is police.  Happens on
#                      ACTIONs to the bot.
#
# v1.9 (04.08.00)
#  MC_8 - eggheads - Removed this script's dependency on moretools.
#  MC_8 -          - Removed the requirment of having to "quote" searches
#                    contaning spaces.
#
# v1.8.2 (02-07-00)
#  MC_8 - Speedo- - Fixed, 'set mc_time to -1 to turn off banning'.
#  MC_8 - Speedo- - Fixed kicking procedure.
#
# v1.8.1 (01-14-00)
#  MC_8 - - *search* found the word, but a search* or search would not find the
#           badword, fixed.
#  MC_8 - - Fixed the "duration ..." thing (showed up in the post via dcc),
#           forgot the []'s
#
# v1.8 (01-03-00)
#  MC_8 - - Processes messages from user X and processes them as if they were
#           text said to the rooms, witch would pull from global then channel
#           bad werd list.
#           example:  say your rule for #warez4free is "*join #*" and
#                     #warez4warez is "*ratio*", and let's say user X in in
#                     #warez4free and in #warez4warez and /msg's the bot with "
#                     hey dude, join #blaboo " .. he will get booted from
#                     #warez4free but not from #warez4warez.
#           note: This function is optional.
#  MC_8 - - Added message to badwords set, for all messages, this is processed
#           before specific channel badwords are done.
#
# v1.7 (12-14-99)
#  MC_8 - - Fixed %match display, was showing (if you know tcl) lindex %match 0, only
#           taking the first if there was a space in the search.
#
# v1.6 (12-05-99)
#  MC_8 -       - Added %match veriable to warning message and kick message.
#  MC_8 - Malik - If you had NO global defined (regardless of wether or not it
#                 was empty) (in other words, you DELEATED global set) the whole
#                 script ceased to work, no error messages what so ever.
#
# v1.5 (11-22-99)
#  MC_8 - unknown - Treating channel notice's as regular channel text.
#
# v1.4 (10-18-99)
#  MC_8 - m8s - Now ban before kick (as opposed to vice versa).
#  MC_8 -     - I fixed the bantype error (it was in moretools), anyhow,
#               moretools 1.1.6 min. inst.
#
# v1.3 (10-11-99)
#  MC_8 - m8s - Found minor error in ban masking option, fixed.
#  MC_8 -     - Added more options to the ban masking option.
#
# v1.0 - v1.2 (??-??-99)
#  MC_8 - - Inital release
##
