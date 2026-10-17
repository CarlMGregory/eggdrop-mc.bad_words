##
# Bad Words v4.1
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.5.5 or greater.
#
#    R.I.P. Mom, To always be remembered; Nancy Marie Gregory.
#
# My Website - http://mc.purehype.net:81/
# Have a bug?  http://mc.purehype.net:81/bugzilla/
##

##
# Description
##
# This script will kick and ban anyone in a specified room that mentions a
# certain word (wildcards accepted).
#
# I use this script to ban those whom spam other channels as well as websites n`
# such.  If you do the same, I suggest using mc.spamcheck as well.
#
# Please note that this script can handle channels with extended ascii character, but
# only if your using TCL 8.2 or better.
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
#       confuse you, just do this command instead to receive a walk through 'add
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
#       confuse you, just do this command instead to receive a walk through 'add
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
#   of voice it's asking if you want to exempt ops.  Examples are relatively the
#   same as well.
#
# chattr <bot> +B [channel]
#   You can share your badwords entries with other bot's; the bots you want to
#   share your badwords and exemptwords entries with must --
#     1) have the +B flag, must be added and linked and
#     2) must all have this script loaded.
#   If you don't submit a channel the B flag will be assigned globally, witch
#   means it will be a global share as opposed to only sharing specific badwords
#   for a specified channel.
#   NOTE:
#     o Please note that &message and &global badword and exempt word entries are
#       sent through the shared pipe for global shares.
#     o Entries never overwrite themselves.
#     o For better usefulness, there is no aggressive and passive sharing
#       involved in this.  However, keep in mind, if one of the share bots are
#       not linked and you do a .-badword; the bot that's not linked will never
#       know you removed it.  It's the same way with core eggdrop sharing of
#       ban's (for reference).
#     o The flag 'B' is changeable, incase 'B' conflicts with some other script.
#
#
# Usefull information:
#  - If your adding a *bad*string* (or *exempt*string*) that contains a space,
#    "quote it".
#    Example:
#      +badword #eggdrop "* pussy *" Go away.
#        If you think about it, if you set this to "*pussy*" it would wind up
#        banning people for even saying 'pussy willow' witch isn't really what
#        were worried about.
#  - If your adding a *bad*string* (or *exempt*string*) that contains a "
#    (quotation mark) then escape it.
#     Example:
#       +badword #eggdrop "* \"pussy *" Go away.
#         This will ban anyone that says "pussy as a word.  To escape something
#         (in TCL) means to put a '\' in front of it.
#  - The kick/warning message can have the following replacement variables:
#      %channel == Channel it's for (&global/ &message/ #a_channel)
#      %method  == Method used (action/ msg/ notice/ pub).
#      %string  == The *ban*string* that was triggered by the user.
#      %add     == Who this was added by.
#      Example:
#        +badword &message * Anti spam, do not %method me!
#          So, if someone private messages the bot with something, and it's not
#          exempt (in exempt list); the user will get a kick message that states
#          "Anti spam, do not msg me!"
#  - *bad*string*'s (and *exempt*string*'s) don't bother with case sensitivity.
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

# What flagged users should only be allowed to perform the dcc commands listed
# above in this script?  Flag format is "<global>|<channel>".
set mc_bw(access) "m|m"

# What flagged users are exempt from this script?  Set this to "" to disable.
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
# Replacment variables:
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
#  in front of the time.
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
#                  replacements as does hostname.
set mc_bw(banmask) 11

# What flag should the script use to designate another bot as sharing with this
# script?  If your not sure as to what to set this to, then just leave it set to
# "B".  This setting is here just incase another script uses the "B" custom flag
# (as not conflict, so it's changeable).  Valid flags here can be A through Z
# (capital letters ONLY).
set mc_bw(share:flag) "B"

# [0=no/1=yes] If the bot finds someone in contempt of using a badword via
# private message (&message -- notice/ action/ privmsg to the bot) and the bot
# isn't opped to punish them, do you want the script to broadcast to the botnet
# to punish the user in violation?
# Note:
#   o Only bots that follow the criteria below can utilize this function
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

# The 'relay:tx' and 'relay:rx' only communicate to each other if both scripts
# have the same key.  This eliminates the problem of many bots on a botnet using
# the same script but only 2 should be in use for YOUR bots, the others are just
# ?a friends? bots or something.  If 'relay:tx' and 'relay:rx' are both set to
# 0, then don't worry about setting this... just skip over it for it's not even
# going to be used.
set mc_bw(relay:key) "BlaBlaBlaBla"

# [0=no/1=yes] Do you want to use regular expression matching rather than
# glob-style wild carded matching?
# Note:
#   o Warning, regular expressions are advanced.  If you don't know how to use
#     regular expressions then do not turn this on.  If you want to learn
#     regular expressions then you can check out the following sites:
#       1) http://tcl.activestate.com/man/tcl8.3/TclCmd/re_syntax.htm#M2
#       2) http://dev.scriptics.com/doc/howto/regexp81.html
set mc_bw(use:regexp) 0

# Enter here the filename where dynamic badwords/exemptwords are stored.
set mc_bw(database) ".badwords.dat"


## SVS Client (Script Version Service) v3.0.1 ##
# Once a day, the SVS Client will connect to MC_8's SVS Server to determine if there
# is a newer version of this script available.  This will only notify users of the ne
# version via a note.  It's up to the owner of the bot to download, adjust settings
# then install the script.

# If a newer version is found, whom do you want to notify?  The notification is sent
# via a note.  Seperate each user with a space, or set this to "" to disable SVS
# notification.  For those whom know TCL; do not put this in list format, keep it in
# string format.
set mc_bw(svs:notify) "MC_8"

# Would you like to restrict the concept of a new version to stable releases only?
#   0 = No, inform of both stable and beta release versions.
#   1 = Yes, inform of only stable release versions.
set mc_bw(svs:mode) 0


##

##
# Edit no further, tcl coding below.
##

#Script:mc_bw

set mc_bw(script)      "Bad Words"
set mc_bw(version)     "v4.1"
set mc_bw(svs:script)  "badwerds"
set mc_bw(svs:version) "004001000000"
set mc_bw(svs:server)  "mc.svs.purehype.net"
set mc_bw(svs:port)    "81"
set mc_bw(svs:get)     "/index.tcl"
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

# Error system, v3.0
proc mc:bw:error {command error arg} {
	global mc_bw version lastbind errorInfo
	putlog "Error in script $mc_bw(script) $mc_bw(version)."
	putlog "    Error System: v3.0"
	putlog "       Last Bind: [expr {[info exists lastbind] ? $lastbind : "-NULL-"}]"
	putlog "         Command: $command"
	putlog "       Arguments: $arg"
	putlog "       Error Msg: $error"
	putlog "    Egg. Version: [expr {[info exists version] ? $version : "-NULL-"}]"
	putlog "     TCL Version: [info tclversion]"
	putlog "  TCL Patchlevel: [info patchlevel]"
	putlog "*** Please submit this bug so MC_8 can fix it.  Visit"
	putlog "*** http://mc.purehype.net:81/bugzilla/ to properly report the bug."
	putlog "*** Please include ALL info. in the bug report, including the next(s)."
	error $errorInfo
}

proc mc:bw:errchk {command arg} {
	if {![catch {eval $command $arg} return]} {return $return}
	mc:bw:error $command $return $arg
	return 0
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
		set temp(syntax) {+badword [[#channel|&message|&global] <*bad*string*> }
		append temp(syntax) {[#warnings] [%expire<XdXhXm>] <kick/warning message>]}
		putdcc $idx "$mc_bw(script): Syntax should be\; $temp(syntax)"
		return 0
	}
	set temp() [mc:bw:inter:examin $arg $idx $hand +]
	set chan [lindex $temp() 0]
	if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
	set string [lindex $temp() 1]
	set has_access [lindex $temp() 2]
	set access [lindex $temp() 3]
	set message [lindex $temp() 4]
	set warnings [lindex $temp() 5]
	set expire [lindex $temp() 6]
	while {[regexp -- \\*\\* $string]} {regsub -all -- \\*\\* $string * string}
	if {([string index $chan 0] != "&") && (![validchan $chan])} {
		putcmdlog "#$hand# Denied (invalid channel): +badwords $arg"
		putdcc $idx "$mc_bw(script): Invalid channel: $chan"
		set temp(syntax) {+badword [[#channel|&message|&global] <*bad*string*> }
		append temp(syntax) {[#warnings] [%expire<XdXhXm>] <kick/warning message>]}
		putdcc $idx "Syntax: $temp(syntax)"
		return 0
	}
	if {$message == ""} {
		putcmdlog "#$hand# Denied (no message specified): +badwords $arg"
		putdcc $idx "$mc_bw(script): No message specified."
		set temp(syntax) {+badword [[#channel|&message|&global] <*bad*string*> }
		append temp(syntax) {[#warnings] [%expire<XdXhXm>] <kick/warning message>]}
		putdcc $idx "Syntax: $temp(syntax)"
		return 0
	}
	if {!$has_access} {
		putcmdlog "#$hand# Denied (no access): +badwords $arg"
		putdcc $idx "$mc_bw(script):  Access denied:  '$access' is required."
		return 0
	}
	if {![mc:bw:inter:list add $chan $string $message $hand $warnings $expire . . \
	      -bad]} {
		putcmdlog "#$hand# Denied (already exists): +badwords $arg"
		putdcc $idx "$mc_bw(script): Access denied, entry already exists."
		return 0
	}
	putcmdlog "#$hand# +badwords $arg"
	switch -- $chan {
		&global  {set x "the global"}
		&message {set x "messages"  }
		default  {set x "$chan's"   }
	}
	set temp(1) "Added '$string' (warn/kick msg: $message)"
	putdcc $idx "$mc_bw(script): $temp(1) to $x badwords list."
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
						mc:bw:control:+badword $idx .
						return 0
					}
				} elseif {($arg != "global") && ($arg != "message")} {
					putdcc $idx "Invalid channel option: $arg"
					set mc_bw($idx:switch) 1
					mc:bw:control:+badword $idx .
					return 0
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
					mc:bw:control:+badword $idx ----redo:mc:bw:control
					return 0
				}; lappend mc_bw($idx:arg) $arg
			}
			putdcc $idx ""
			set temp(1) "How many warnings do you want to give before a ban?"
			putdcc $idx "\[0-99+\] $temp(1)  (default= 0)"
		}
		4 {
			if {[regexp -- {[^0-9]} $arg]} {
				putdcc $idx "Invalid number of warnings: $arg"
				set mc_bw($idx:switch) 3
				mc:bw:control:+badword $idx ----redo:mc:bw:control
				return 0
			}
			lappend mc_bw($idx:arg) "#$arg"
			putdcc $idx ""
			set temp(1) "When do you want this entry to expire?"
			putdcc $idx "\[XdXhXm\] $temp(1)  (default= 0d0h0m (aka perm))"
			set temp(1) "X represents a positive number."
			putdcc $idx " ^^^^^^- $temp(1)  d is day, h is hour, m is minute"
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
				mc:bw:control:+badword $idx ----redo:mc:bw:control
				return 0
			}
			append mc_bw($idx:arg) " $arg"
			putdcc $idx ""
			putdcc $idx "Performing: .+badword $mc_bw($idx:arg)"
			set temp(1) [list *mc:bw:dcc:+badword [idx2hand $idx] $idx $mc_bw($idx:arg)]
			if {[catch {eval $temp(1)} error]} {putdcc $idx "Error: $error"}
			unset mc_bw($idx:arg)
			unset mc_bw($idx:switch)
			putdcc $idx ""
			putdcc $idx "Exiting prompt interface."
			return 1
		}
		default {
			putdcc $idx "Error($mc_bw($idx:switch))"
			return 1
		}
	}
	incr mc_bw($idx:switch)
	return 0
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
		set temp(syntax) {+exemptword [#channel|&message|&global] }
		append temp(syntax) {<*exempt*string*> [%expire <XdXhXm>]}
		putdcc $idx "$mc_bw(script): Syntax should be\; $temp(syntax)"
		return 0
	}
	set temp() [mc:bw:inter:examin $arg $idx $hand +]
	set chan [lindex $temp() 0]
	if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
	set string [lindex $temp() 1]
	set has_access [lindex $temp() 2]
	set access [lindex $temp() 3]
	set expire [lindex $temp() 6]
	while {[regexp -- \\*\\* $string]} {regsub -all -- \\*\\* $string * string}
	if {([string index $chan 0] != "&") && ![validchan $chan]} {
		putcmdlog "#$hand# Denied (invalid channel): +exemptwords $arg"
		putdcc $idx "$mc_bw(script): Invalid channel: $chan"
		set temp(syntax) {+exemptword [[#channel|&message|&global] }
		append temp(syntax) {<*bad*string*> [%expire<XdXhXm>]]}
		putdcc $idx "Syntax: $temp(syntax)"
		return 0
	}
	if {$string == ""} {
		putcmdlog "#$hand# Denied (no *exempt*string* specified): +exemptwords $arg"
		putdcc $idx "$mc_bw(script): No *exempt*string* specified."
		set temp(syntax) {+exemptword [[#channel|&message|&global] }
		append temp(syntax) {<*bad*string*> [%expire <XdXhXm>]]}
		putdcc $idx "Syntax: $temp(syntax)"
		return 0
	}
	if {!$has_access} {
		putcmdlog "#$hand# Denied (no access): +exemptwords $arg"
		putdcc $idx "$mc_bw(script): Access denied: '$access' is required."
		return 0
	}
	if {![mc:bw:inter:list add $chan $string . $hand 0 $expire . . -exempt]} {
		putcmdlog "#$hand# Denied (already exists): +exemptwords $arg"
		putdcc $idx "$mc_bw(script): Access denied, entry already exists."
		return 0
	}
	putcmdlog "#$hand# +exemptwords $arg"
	switch -- $chan {
		&global  {set x "the global"}
		&message {set x "messages"  }
		default  {set x "$chan's"   }
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
						mc:bw:control:+exemptword $idx .
						return 0
					}
				} elseif {($arg != "global") && ($arg != "message")} {
					putdcc $idx "Invalid channel option: $arg"
					set mc_bw($idx:switch) 1
					mc:bw:control:+exemptword $idx .
					return 0
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
				mc:bw:control:+exemptword $idx ----redo:mc:bw:control
				return 0
			}
			lappend mc_bw($idx:arg) $arg
			putdcc $idx ""
			set temp(1) "When do you want this entry to expire?"
			putdcc $idx "\[XdXhXm\] $temp(1)  (default= 0d0h0m (aka perm))"
			set temp(1) "X represents a positive number."
			putdcc $idx " ^^^^^^- $temp(1)  d is day, h is hour, m is minute"
		}
		4 {
			lappend mc_bw($idx:arg) "%[mc:bw:inter:exp2exp $arg]"
			putdcc $idx ""
			putdcc $idx "Performing: .+badword $mc_bw($idx:arg)"
			set temp(1) [list *mc:bw:dcc:+exemptword [idx2hand $idx] $idx $mc_bw($idx:arg)]
			if {[catch {eval $temp(1)} error]} {putdcc $idx "Error: $error"}
			unset mc_bw($idx:arg)
			unset mc_bw($idx:switch)
			putdcc $idx ""
			putdcc $idx "Exiting prompt interface."
			return 1
		}
		default {
			putdcc $idx "Error($mc_bw($idx:switch))"
			return 1
		}
	}
	incr mc_bw($idx:switch)
	return 0
}

# -badword [<#>channel|&message|&global] <*bad*string*>
bind dcc - -badwords *mc:bw:dcc:-badword
proc *mc:bw:dcc:-badword {hand idx arg} {
	return [mc:bw:errchk *mc:bw:dcc:-badword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:-badword_ {hand idx arg} {
	global mc_bw
	set temp() [mc:bw:inter:examin $arg $idx $hand -]
	set chan [lindex $temp() 0]
	if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
	set string [lindex $temp() 1]
	set has_access [lindex $temp() 2]
	set access [lindex $temp() 3]
	if {!$has_access} {
		putcmdlog "#$hand# Denied (no access): -badwords $arg"
		putdcc $idx "$mc_bw(script): Access denied: '$access' is required."
		return 0
	}
	if {($string == "") || [regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
		set temp(syntax) {-badword [channel|&message|&global] <*bad*string*>}
		putdcc $idx "$mc_bw(script): Syntax, should be\; $temp(syntax)"
		return 0
	}
	if {![mc:bw:inter:list rem $chan $string . . . . . . -bad]} {
		putcmdlog "#$hand# Denied (no entry): -badwords $arg"
		putdcc $idx "$mc_bw(script): No such entry: $chan '$string'"
		return 0
	}
	putcmdlog "#$hand# -badwords $arg"
	switch -- $chan {
		&global  {set x "the global"}
		&message {set x "messages"  }
		default  {set x "$chan's"   }
	}
	putdcc $idx "$mc_bw(script): Removed '$string' from $x badwords list."
	return 0
}

# -exemptword [channel|&message|&global] <*exempt*string*>
bind dcc - -exemptwords *mc:bw:dcc:-exemptword
proc *mc:bw:dcc:-exemptword {hand idx arg} {
	return [mc:bw:errchk *mc:bw:dcc:-exemptword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:-exemptword_ {hand idx arg} {
	global mc_bw
	set temp() [mc:bw:inter:examin $arg $idx $hand -]
	set chan [lindex $temp() 0]
	if {($chan == "&default") || ($chan == "all")} {set chan "&global"}
	set string [lindex $temp() 1]
	set has_access [lindex $temp() 2]
	set access [lindex $temp() 3]
	if {!$has_access} {
		putcmdlog "#$hand# Denied (no access): -exemptwords $arg"
		putdcc $idx "$mc_bw(script): Access denied: '$access' is required."
		return 0
	}
	if {($string == "") || [regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
		set temp(syntax) {-exemptword [channel|&message|&global] <*exempt*string*>}
		putdcc $idx "$mc_bw(script): Invalid Syntax, should be\; $temp(syntax)"
		return 0
	}
	if {![mc:bw:inter:list rem $chan $string . . . . . . -exempt]} {
		putcmdlog "#$hand# Denied (no entry): -exemptwords $arg"
		putdcc $idx "$mc_bw(script): No such entry: $chan '$string'"
		return 0
	}
	putcmdlog "#$hand# -exemptwords $arg"
	switch -- $chan {
		&global  {set x "the global"}
		&message {set x "messages"  }
		default  {set x "$chan's"   }
	}
	putdcc $idx "$mc_bw(script): Removed '$string' from $x exemptwords list."
	return 0
}

# badwords [channel|&message|&global|all]
bind dcc - badwords *mc:bw:dcc:badword
proc *mc:bw:dcc:badword {hand idx arg} {
	return [mc:bw:errchk *mc:bw:dcc:badword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:badword_ {hand idx arg} {
	global mc_bw
	if {[regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
		set temp(syntax) {badwords [channel|&message|&global|all]}
		putdcc $idx "$mc_bw(script): Syntax, should be\; $temp(syntax)"
		return 0
	}
	set temp() [mc:bw:inter:examin $arg $idx $hand 0]
	set chan [lindex $temp() 0]
	if {$chan == "&default"} {set chan "all"}
	set has_access [lindex $temp() 2]
	set access [lindex $temp() 3]
	if {!$has_access} {
		putcmdlog "#$hand# Denied (no access): badwords $chan"
		putdcc $idx "$mc_bw(script): Access denied: '$access' is required."
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
		if {$ex == "0"} {
			set ex perm
		} else {
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
	}; return 0
}

# exemptwords [channel|&message|&global|all]
bind dcc - exemptwords *mc:bw:dcc:exemptword
proc *mc:bw:dcc:exemptword {hand idx arg} {
	return [mc:bw:errchk *mc:bw:dcc:exemptword_ [list $hand $idx $arg]]
}
proc *mc:bw:dcc:exemptword_ {hand idx arg} {
	global mc_bw
	if {[regexp -- {^-?(-h(elp)?|-\?|-s(yntax)?)$} $arg]} {
		set temp(syntax) {exemptwords [channel|&message|&global|all]}
		putdcc $idx "$mc_bw(script): Syntax, should be\; $temp(syntax)"
		return 0
	}
	set temp() [mc:bw:inter:examin $arg $idx $hand 0]
	set chan [lindex $temp() 0]
	if {$chan == "&default"} {set chan "all"}
	set has_access [lindex $temp() 2]
	set access [lindex $temp() 3]
	if {!$has_access} {
		putcmdlog "#$hand# Denied (no access): exemptwords $chan"
		putdcc $idx "$mc_bw(script): Access denied: '$access' is required."
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
		if {$ex == "0"} {
			set ex perm
		} else {
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
	}; return 0
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
	if {$mc_bw(procmsg) && [isbotnick $chan]} {
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
	if {$mc_bw(strip)} {set arg [mc:bw:mirc_strip -all -- $arg]}
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
	if {$chan == "&message"} {set temp() "private $type"} else {set temp() $chan}
	set message [mc:bw:replace $l_ms [list %method  $type \
	                                       %channel $temp() \
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
				set temp() [mc:bw:replace $mc_bw(warn_mode) [list %botnick $botnick \
				                                                %nick    $nick]]
				putserv "MODE $channel $temp()"
				lappend action "mode changed attempt ($channel $temp())"
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
		set banmask [mc:bw:maskhostbytype $nick!$uhost $mc_bw(banmask)]
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
					set temp() ""
					if {$ban_time != "-1"} {
						set temp_1 [list $mc_bw(relay:key) BAN $channel	$banmask]
						set temp_2 [encrypt $mc_bw(relay:key)+${botnet-nick} $temp_1]
						putallbots "badwords [list k $temp_2]"
						set temp() " and ban"
					}
					set temp_1 [list $mc_bw(relay:key) KICK $channel $nick $message]
					set temp_2 [encrypt $mc_bw(relay:key)+${botnet-nick} $temp_1]
					putallbots "badwords [list k $temp_2]"
					lappend action "relay kick$temp() request (not op'd in $channel)"
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
				if {$option == "none"} {set temp() ""} else {set temp() " sticky"}
				set temp_1 "(Duration: $duration)"
				lappend action "added global$temp() ban in bots banlist $temp_1"
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
				if {$option == "none"} {set temp() ""} else {set temp() " sticky"}
				set temp_1 "(Duration: $duration)"
				lappend action "added $chan$temp() channel ban in bots banlist $temp_1"
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
		if {$bot == "-all"} {
			putallbots [list badwords n share U]
		} elseif {[islinked $bot]} {
			putbot $bot [list badwords n share U]
		}; return
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
	if {[string index $chan 0] != "#"} {set userlist [userlist b$mc_bw(share:flag)|]} \
	elseif {[validchan $chan]} {
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
	set temp(buffer) [list $cmd $chan $string $text $hand	$warnings $expire $lu $q]
	lappend temp(buffer) $type
	return [mc:bw:errchk mc:bw:inter:list_ $temp(buffer)]
}
proc mc:bw:inter:list_ {cmd chan string text hand warnings expire lu q type} {
	global mc_bw {botnet-nick}
	set chan [string tolower $chan]
	if {![info exists mc_bw(list)]} {set mc_bw(list) ""}
	if {[info tclversion] > 8.0} {
		foreach temp() [list cmd chan string text hand warnings expire lu q type] {
			set $temp() [encoding convertto [encoding system] [set $temp()]]
		}
	}
	switch -- $cmd {
		add {
			if {[mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
			lappend mc_bw(list) \
				[list $type [clock seconds] $chan $string [string range $text 0 299] $hand \
				$warnings $expire 0]
			mc:bw:inter:list save -quiet
			mc:bw:inter:list expire . . . . . . . . $type
			if {$q != "NO"} {
				mc:bw:inter:share add \
					[list $type $chan $string $text $hand $warnings $expire 0]
			}; return 1
		}
		exists {
			foreach line $mc_bw(list) {
				set a [lindex $line 0]
				set b [lindex $line 2]
				set c [lindex $line 3]
				if {[string tolower "$a $b $c"] == [string tolower "$type $chan $string"]} {
					return 1
				}
			}; return 0
		}
		expire {
			set temp(cmd) "mc:bw:inter:list expire . . . . . . . . $type"
			while {[regexp -- "\[0-9\]* \{$temp(cmd)\} timer\[0-9\]*" [utimers] timer]} {
				killutimer [lindex $timer 2]
			}
			set ex 0
			set temp(1) [mc:bw:inter:list list all . . . . . . . $type]
			foreach line [lsort -dictionary -index 6 $temp(1)] {
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
						&global  {set x "the global"}
						&message {set x "messages"  }
						default  {set x "$chan's"   }
					}
					set temp(1) "Removed '$st' from $x [string trimleft ${type} -]words list."
					putlog "$mc_bw(script): $temp(1) (expired)"
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
			}; return [lsort -dictionary -index 1 [lsort -dictionary -index 0 $return]]
		}
		load {
			set mc_bw(list) ""
			if {![file exists $mc_bw(database)]} {close [open $mc_bw(database) w]}
			set io [open $mc_bw(database) r]
			set db_ver ""
			for {set for_i 0} {![eof $io]} {incr for_i} {
				gets $io line
				if {!$for_i} {
					if {[regexp -- {^#v[0-9]*:} $line db_ver]} {continue}
				}
				if {([string trim $line " "] == "") ||
				    ([string index $line 0] == "#")} {continue}
				switch -- $db_ver {
					"#v2:"  { set temp(line) "-bad $line"              }
					"#v3:"  { set temp(line) $line                     }
					default { set temp(line) "-bad $line {} * 0 0 0 0" }
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
				if {![regexp {^-(bad|exempt)$} $ty] || [regexp {^[^0-9]$} $ta] ||
				    ($ch == "") || ($st == "") || ($ad == "") || [regexp {^[^0-9]$} $wn] ||
				    [regexp {^[^0-9]$} $ex] || [regexp {^[^0-9]$} $lu]} {
					set temp(1) "Loading datafile, skipping '$temp(line)'"
					putloglev d * "$mc_bw(script): $temp(1).  INVALID FORMAT"
					continue
				}
				# ^
				if {[info tclversion] > 8.0} {
					lappend mc_bw(list) [encoding convertto [encoding system] $temp(line)]
				} else {
					lappend mc_bw(list) $temp(line)
				}
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
					mc:bw:inter:list update $chan $st $ms $ad $wn $ex [clock seconds] -quiet \
						$type
					return $line
				}
			}; return ""
		}
		rem {
			if {![mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
			set list ""
			foreach line $mc_bw(list) {
				set temp(1) "[list [lindex $line 0]] [lrange $line 2 3]"
				set temp(2) [list $type $chan $string]
				if {[string tolower $temp(1)] != [string tolower $temp(2)]} {
					lappend list $line
				}
			}
			set mc_bw(list) $list
			mc:bw:inter:list save -quiet
			if {$q != "NO"} {mc:bw:inter:share rem [list $type $chan $string $text]}
			return 1
		}
		save {
			if {$chan != "-quiet"} {putloglev o * "Writing $mc_bw(script) file..."}
			set io [open $mc_bw(database) w]
			puts $io "#v3:$mc_bw(version):${botnet-nick}:[clock seconds]"
			foreach line [mc:bw:inter:list list all . . . . . . . -bad] {
				puts $io $line
			}
			foreach line [mc:bw:inter:list list all . . . . . . . -exempt] {
				puts $io $line
			}
			close $io
			return 1
		}
		update {
			if {![mc:bw:inter:list exists $chan $string . . . . . . $type]} {return 0}
			set list ""
			foreach line $mc_bw(list) {
				set ty [lindex $line 0] ;# Type
				set ta [lindex $line 1] ;# Time added
				set ch [lindex $line 2] ;# Channel
				set st [lindex $line 3] ;# String
				set temp(1) [string tolower "$type $chan $string"]
				if {[string tolower "$ty $ch $st"] == $temp(1)} {
					lappend list [list $ty $ta $chan $string $text $hand $warnings $expire $lu]
				} else {lappend list $line}
			}
			set mc_bw(list) $list
			mc:bw:inter:list save -quiet
			mc:bw:inter:list expire . . . . . . . . $type
			if {$q != "NO"} {
				mc:bw:inter:share update [list $type $chan $string $text $hand $warnings \
					$expire $lu $q]
			}; return 1
		}
	}
}

proc mc:bw:warn {host chan string warn} {
	global mc_bw
	set host [string tolower $host]
	set chan [string tolower $chan]
	set string [string tolower $string]
	if {![info exists mc_bw(warn!$host:$chan:$string)]} {
		set mc_bw(warn!$host:$chan:$string) 0
	}
	if {$warn <= $mc_bw(warn!$host:$chan:$string)} {return 0}
	incr mc_bw(warn!$host:$chan:$string);return 1
}

# in: unixtime
#out: x day(s) || hh:mm
proc mc:bw:inter:ut2d {time} {
	set diff [string trimleft [expr [clock seconds]-$time] -]
	if {[set d [expr $diff/60/60/24]] != "0"} {
		if {$d == "1"} {set s ""} else {set s s}
		append d day$s
	} else {
		set d [clock format $time -format %H:%M]
	}; return $d
}

#return: chan string has_access access_type message warnings expire
proc mc:bw:inter:examin {arg idx hand ar} {
	global mc_bw
	set x 0
	if {[string index [set temp() [lindex $arg 0]] 0] == "#"} {
		set chan [string tolower $temp()]
		set x 1
	} elseif {[string index [set temp() [lindex $arg 0]] 0] == "&"} {
		set temp() [string tolower $temp()]
		if {($temp() == "&message") || ($temp() == "&global")} {
			set chan $temp()
			set x 1
		}
	} elseif {[string tolower [lindex $arg 0]] == "all"} {
		set chan "all"
		set x 1
	}
	if {!$x} {
		if {[set chan [string tolower [lindex [console $idx] 0]]] == "*"} {
			set chan "&default"
		}
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
		set string [lindex $arg $x]
		incr x
		if {[string index [set temp() [lindex $arg $x]] 0] == "#"} {
		 set warnings [string range $temp() 1 end]
		 incr x
		} else {set warnings 0}
		if {[string index [set temp() [lindex $arg $x]] 0] == "%"} {
			set expire [mc:bw:inter:exp2cs [string range $temp() 1 end]]
			incr x
		} else {set expire 0}
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
	if {$add} {return [expr [clock seconds] + $add]} \
	else {return 0}
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
	if {![validchan $channel]} {
		error "no such channel record"
	}
	set buffer ""
	set hostmask [string tolower $hostmask]
	foreach user [chanlist $channel] {
		set uhost [getchanhost $user $channel]
		if {[string match $hostmask [string tolower $user!$uhost]]} {
			lappend buffer $user
		}
	}; return $buffer
}


## More Tools quick procs.
## -- http://mc.purehype.net:81/script_info.tcl?script=moretools

# badargs <args> <min_llength> <max_llength|end> <argNames>
#     version:
#       v1.0
proc mc:bw:badargs {{args ""}} {
	if {[llength $args] < 4} {
		error {
			wrong # args: should be "mc:bw:badargs args min_llength max_llength argNames"
		}
	}

	set index 0
	foreach varName [list args min max names] {
		set check_$varName [lindex $args $index]
		incr index
	}

	if {[regexp -- {([^0-9])} $check_min -> bad]} {
		error "bad number \"$bad\" in: $check_min"
	}
	if {[regexp -- {([^0-9])} $check_max -> bad] && ($check_max != "end")} {
		error "bad number \"$bad\" in: $check_max"
	}

	# Make sure $check_args is in list format, if not then make it so.
	# Were not going to use 2list here, don't want to evoke a 'too many nested calls
	# to Tcl_EvalObj' error since '2list' uses on this proc.
	if {[catch {llength $check_args} llength]} {
		set check_args [split $check_args]
		set llength $check_args
	}

	if {($llength < $check_min) || (($llength != "end") && ($llength > $check_max))} {
		if {[info level] == "1"} {return 1}
		error "wrong # args: should be \"[lindex [info level -1] 0] $check_names\""
	}; return 0
}

# mc:bw:unlist <argsList> [varName1] [varName2] ... [varNameN]
#     version:
#       v1.0
proc mc:bw:unlist {{args ""}} {
	mc:bw:badargs $args 1 end "argsList ?varName varName ...?"
	set argList [lindex $args 0]
	set argList [expr {([catch {llength $argList}])?[split $argList]:$argList}]
	set argNames [lrange $args 1 end]
	if {![llength $argNames]} {
		return [expr {(![catch {llength $argList}])?
			[join $argList]:$argList}]
	}
	for {set index 0} {$index < [llength $argNames]} {incr index 1} {
		set argName     [lindex $argNames $index]
		set argListItem [lindex $argList  $index]

		set argName_ [expr {([catch {llength $argName}])?[split $argName]:$argName}]
		set setTo   [lindex $argName_ 1]
		set argName [lindex $argName_ 0]

		if {$argName == ""} {continue}

		upvar 1 $argName var

		if {[expr $index+1] > [llength $argList]} {
			if {[llength $argName_] == "2"} {set var $setTo}
		} else {
			if {$argName == "args"} {
				set var [lrange $argList $index end]
				incr index [expr [llength $var]-1]
			} else {set var $argListItem}
		}
	}; return $index
}

# 2list <text>
#     version:
#       v1.0
proc mc:bw:2list {{args ""}} {
	mc:bw:badargs $args 1 1 "text"
	mc:bw:unlist $args text

	return [expr {([catch {llength $text}])?[split $text]:$text}]
}

# mc:bw:replace [switches] <text> <substitutions>
#     version:
#       v1.3
proc mc:bw:replace {{args ""}} {
	mc:bw:badargs $args 2 4 "?switches? text substitutions"
	set switches ""
	for {set i 0} {[string match -* [set arg [lindex $args $i]]]} {incr i} {
		if {![regexp -- {^-(nocase|-)$} $arg -> switch]} {
			error "bad switch \"$arg\": must be -nocase, or --"
		}
		if {$switch == "-"} {
			incr i
			break
		}; lappend switches $switch
	}
	set nocase [expr {([lsearch -exact $switches "nocase"] >= "0") ? 1 : 0}]
	set text [lindex $args $i]
	set substitutions [lindex $args [expr $i+1]]
	mc:bw:badargs [lrange $args $i end] 2 2 "?switches? text substitutions"

	# Check to see if $substitutions is in list format, if not make it so.
	set substitutions [mc:bw:2list $substitutions]

	if {[info tclversion] >= "8.1"} {
		return [expr {($nocase)?
			[string map -nocase $substitutions $text]:
			[string map $substitutions $text]}]
	}

	set re_syntax {([][\\\*\+\?\{\}\,\(\)\:\.\^\$\=\!\|])}
	foreach {a b} $substitutions {
		regsub -all -- $re_syntax $a {\\\1} a
		if {$nocase} {regsub -all -nocase -- $a $text $b text} \
		else {regsub -all -- $a $text $b text}
	}; return $text
}

# mirc_strip [switches] <text>
#     version:
#       v1.0
proc mc:bw:mirc_strip {{args ""}} {
	mc:bw:badargs $args 1 7 "?switches? text"
	set switches ""
	for {set i 0} {[string match -* [set arg [lindex $args $i]]]} {incr i} {
		if {![regexp -- {^-(all|bold|color|reverse|underline|-)$} $arg -> switch]} {
			set valid "-all -bold -color -reverse -underline {or --}"
			error "bad switch \"$arg\": must be [join $valid ", "]"
		}
		if {$switch == "-"} {
			incr i
			break
		}; lappend switches $switch
	}
	if {$switches == ""} {set switches all}
	set arg [lindex $args $i]
	mc:bw:badargs [lrange $args $i end] 1 1 "?switches? text"

	set all [expr {([lsearch -exact $switches all] >= 0) ? 1 : 0}]
	set list ""
	if {$all} {
		set list [list \002 "" \017 "" \026 "" \037 ""]
	} else {
		if {[lsearch -exact $switches bold] >= 0} {lappend list [list \002 ""]}
		if {[lsearch -exact $switches plain] >= 0} {lappend list [list \017 ""]}
		if {[lsearch -exact $switches reverse] >= 0} {lappend list [list \026 ""]}
		if {[lsearch -exact $switches underline] >= 0} {lappend list [list \037 ""]}
	}
	if {$all || ([lsearch -exact $switches color] >= 0)} {
		regsub -all -- "\003(\[0-9\]\[0-9\]?(,\[0-9\]\[0-9\]?)?)?" $arg "" arg
	}
	set arg [mc:bw:replace -- $arg [join $list]]

	return $arg
}

# chanflag <channel> <flag>
#     version:
#       v3.1
proc mc:bw:chanflag {{args ""}} {
	mc:bw:badargs $args 2 2 "channel flag"
	mc:bw:unlist $args channel flag

	if {![validchan $channel]} {error "no such channel record"}

	# Try the 'channel' commands' 'get' option first, it's faster since it is written
	# in C by the eggdrop development team.
	if {![catch {channel get $channel $flag} output]} {return $output}

	set temp(chaninfo) [string tolower [channel info $channel]]
	if {[lsearch -exact $temp(chaninfo) +[string tolower $flag]] >= "0"} {return 1}
	return 0
}

# maskhostbytype <nick!ident@host.domain> [type]
#     version:
#       v2.0
proc mc:bw:maskhostbytype {{args ""}} {
	mc:bw:badargs $args 1 2 "nick!ident@host.domain ?type?"
	mc:bw:unlist $args nuhost type


	set type [expr {($type == "")?5:$type}]
	if {![regexp -- {^1?[0-9]$} $type]} {
		set valid "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {or 19}"
		error "bad type \"$type\": must be [join $valid ", "]"
	}

	# Define the maximum length the ircd allows for an ident.  Standard is 9, however I
	# made it to a variable incase someone wants to change it up.
	set ident_max-length 9

	# Define the maximum length the ircd allows for a hostname/ ip.  Standard is 63,
	# however I made it to a variable incase someone wants to change it up.
	set host_max-length 63

	if {![regexp -- {^(.*?)!((.*)@(.*))$} $nuhost -> nick uhost ident host]} {
		error "invalid nick!ident@host.domain: $nuhost"
	}

	set maskhost 1
	if {[string length $type] == "2"} {
		# Type must be 10-19.
		if {[info tclversion] < "8.1"} {
			set re_syntax_1 {([12][0-9][0-9]|[1-9][0-9]|[1-9])}
			set re_syntax_2 {([12][0-9][0-9]|[1-9][0-9]|[0-9])}
		} else {
			set re_syntax_1 {([12]\d{2}|[1-9][0-9]|[1-9])}
			set re_syntax_2 {([12]\d{2}|[1-9][0-9]|[0-9])}
		}
		set re_syntax ^$re_syntax_1\\.$re_syntax_2\\.$re_syntax_2\\.$re_syntax_2\$

		if {![regexp -- $re_syntax $host]} {
			regsub -all -- {[0-9]} $host ? host
			set maskhost 0
		}; set type [string index $type 1]
	}

	# Previous version used regexp instead of these string matches.  String match in
	# this case is ~3 microseconds faster.
	if {[string match {[0-4]} $type]} {set nick *}
	if {[string match {[2479]} $type]} {set ident *}
	if {[string match {[1368]} $type]} {regsub -- {^~?(.*)$} $ident *\\1 ident}
	if {[string match {[3489]} $type] && $maskhost} {
		set host [lindex [split [maskhost $host] @] end]
	}

	if {[set length [string length $ident]] > ${ident_max-length}} {
		set ident *[string range $ident [expr $length-${ident_max-length}] end]
	}
	if {[set length [string length $host]] > ${host_max-length}} {
		set host *[string range $host [expr $length-${host_max-length}] end]
	}

	return $nick!$ident@$host
}

## End of More Tools quick procs.


bind evnt - save mc:bw:evnt
proc mc:bw:evnt {type} {return [mc:bw:errchk mc:bw:evnt_ [list $type]]}
proc mc:bw:evnt_ {type} {mc:bw:inter:list save}; mc:bw:inter:list load -all


## SVS v3.1
set mc_bw(svs:client_version) "v3.1"
if {![info exists mc_bw(svs:mode)] ||
    ![regexp -- {^(1|0)$} $mc_bw(svs:mode)]} {
	set mc_bw(svs:mode) 0
}
if {![info exists mc_bw(svs:notify)]} {
	if {![info exists owner]} {set owner ""}
	set mc_bw(svs:notify) $owner
}

bind time - "00 00 *" mc:bw:do_svs
proc mc:bw:do_svs {{args ""}} {
	global mc_bw
	mc:bw:do_svs_ $mc_bw(svs:server) $mc_bw(svs:port) $mc_bw(get)
}

proc mc:bw:do_svs_ {svs_server svs_port svs_get} {
	global mc_bw tcl_platform
	if {[catch {
	        socket -async $svs_server $svs_port
	           } sid]} {
		putloglev d * "$mc_bw(script): SVS socket error: $sid"
		return 1
	}

	# This block of code is to get a standard User-Agent line of information, as
	# proposed in http://www.mozilla.org/build/revised-user-agent-strings.html
	foreach array_name [list platform os osVersion machine] {
		set temp($array_name) [lindex [array get tcl_platform $array_name] 1]
	}
	switch -- $temp(platform) {
		windows {
			switch -- $temp(os) {
				Windows {set temp(2) Win$temp(osVersion)}
				"Windows 95" {
					if {$temp(osVersion) < "4.10"} {
						set temp(2) Win95
					} else {
						set temp(2) Win98
					}
				}
				"Windows 98" {set temp(2) Win98}
				"Windows NT" {
					if {$temp(osVersion) >= "5.0"} {
						set temp(2) "Windows NT $temp(osVersion)"
					} else {
						set temp(2) WinNT$temp(osVersion)
					}
				}
				default {
					set temp(2) "$temp(os) $temp(osVersion)"
				}
			}
		}
		unix {
			set temp(2) "unix $temp(machine)"
		}
		macintosh {
			set temp(2) $temp(machine)
		}
		default {
			set temp(2) "$temp(os) $temp(osVersion) $temp(machine)"
		}
	}
	set temp(user_agent) "Mozilla/5.001 ($temp(platform); U; $temp(2); en) "
	append temp(user_agent) "Gecko/25250101 $mc_bw(svs:script)/"
	append temp(user_agent) "$mc_bw(svs:version) SVS_Client/"
	append temp(user_agent) "$mc_bw(svs:client_version)"
	# ^

	fconfigure $sid -blocking 0 -buffering line
	set tout [after 60000 "mc:bw:svs_talk $sid timeout $svs_server $svs_port"]
	fileevent $sid readable "mc:bw:svs_talk $sid $tout"
	puts $sid "GET $svs_get?$mc_bw(svs:query) HTTP/1.0\
	         \nHost: $svs_server:$svs_port\
	         \nUser-Agent: $temp(user_agent)\n"
	flush $sid
}

proc mc:bw:svs_talk {sid tout {svs_server ""} {svs_port ""}} {
	global mc_bw
	set array [list svs temp $sid]
	if {$tout == "timeout"} {
		set temp(1) "$svs_server:$svs_port"
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
		200 {
			set temp(host) [lindex $get 1]
			set temp(port) [lindex $get 2]
			set temp(get) [lindex $get 3]
			set temp(cache) "$temp(host) at $temp(port)"
			putloglev d * "$mc_bw(script): SVS is being redirected to $temp(cache)."
			mc:bw:do_svs_ $temp(host) $temp(port) $temp(get)
			close $sid
			return 200
		}
		003 {
			set temp(reply) [lrange $get 1 end]
			for {set number 0} {$number <= 5} {incr number} {
				set temp(reply:$number) [lindex $temp(reply) $number]
			}
			if {$temp(reply:0) != $mc_bw(svs:script)} {
				set temp(1) "wanted $mc_bw(svs:script), got $temp(reply:0)"
				putloglev d * "$mc_bw(script): SVS Error: $temp(1)"
				unset mc_bw($array)
				close $sid
				return -3
			}
			if {$mc_bw(svs:mode)} {
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
					if {[string trim $temp(to)] == ""} {continue}
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
# v4.1 (10.09.02)
#  MC_8 -           - Upgraded SVS client.  v2.2 -> v3.1
#  MC_8 - KrE80r    - Fixed 'invalid command name "encoding"'. [Bug: 161]
#  MC_8 - heber     - Encoded ability to support for non ascii characters in channel
#                     names, such as `ã`.
#                     Bugzilla number: 152
#  MC_8 - heber     - Fixed 'invalid command name "badargs"'.
#                     Bugzilla number: 114
#                     Bugzilla number: 150
#  MC_8 - heber     - Fixed 'wrong # args: should be "*mc:bw:dcc:+badword hand idx
#                     arg"'.
#                     Bugzilla number: 146
#  MC_8 - heber     - Fixed 'invalid command name "2list"', added `2list` tcl
#                     command.  none -> v1.0
#                     Bugzilla number: 146
#  MC_8 - heber     - Fixed 'Error: invalid command name ...'.
#                     Bugzilla bug: 143
#  MC_8 - heber     - Fixed 'invalid command name "replace"'.
#                     Bugzilla bug: 125
#  MC_8 - heber     - Fixed 'missing close-brace: possible unbalanced brace in
#                     comment'.
#                     Bugzilla bug: 122
#  MC_8 -           - Added `unlist` tcl command.  none -> v1.0
#  MC_8 -           - Added `badargs` tcl command.  none -> v1.0
#  MC_8 -           - Upgraded `replace` tcl command.  v1.2 -> v1.3
#  MC_8 -           - Added new `mirc_strip`. none -> v1.0
#  MC_8 -           - Removed old `strip:all` tcl command. v1.1 -> none
#  MC_8 -           - Upgraded `chanflag` tcl command.  v3.0 -> v3.1
#  MC_8 -           - Upgraded `inter:masktype` tcl command, renamed to
#                     `maskhostbytype`.  v1.3 -> v2.0
#  MC_8 -           - Upgraded Error Catching System.  v2.1 -> v3.0
#  MC_8 - heber  \  - Fixed 'can't set "temp(syntax)": variable isn't array'.
#         xentor \    Bugzilla bug: 119
#         Javier
#  MC_8 - tim     \ - Fixed 'invalid command name ""'.
#         Francis \   Bugzilla number: 100
#         Victor  \
#         KrE80r
#
# v4.0.3 (07.09.02)
#  MC_8 - tim - Fixed problem auto conversion of datafile v1.0 to v3.0.
#               Bugzilla bug: 94
#  MC_8 -     - Upgraded replace proc.  v1.1 -> v1.2
#  MC_8 -     - Upgraded chanflag proc.  v2.0 -> v3.0
#  MC_8 - tim - Upgraded error system, a user reported an error of the error
#               system... witch means there was an legit error in the script but it
#               couldn't debug it because of another error.  Hopefully we can use
#               this new error catching system to track his bug down.  v2.0 -> v2.1
#               Bugzilla bug: 114
#
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
#  MC_8 -         - Rewrote 'mc:bw:bw_' proc, it was ugly and unformatted.
#  MC_8 -         - Fixed conversion of string->list format for channel variable
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
#                     botnet communications only support up to 300 -- the extra
#                     100 is for other information pertaining to that particular
#                     badword entry.
#  MC_8 -           - Script was using [join [lindex ...]], don't know why...
#                     that's improper list usage and would cause bugs later on.
#  MC_8 -           - Changed how the bot communicates over the botnet, now
#                     encrypted.  Due to the totally different way this script
#                     shares info over the botnet, I'm going to up this to
#                     version 4.0, older version are not botnet comparable with
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
#                       o A little more efficient, by cache'n some commands.
#                     v1.1 -> v1.2
#  MC_8 -           - Added the 'normal' character code to 'strip:all' proc.
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
#  MC_8 -              - Rewrote explanation of ban masking types.
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
#         Daniel         such variable'.
#  MC_8 - Dr.W95       - Added warn_msgtype configuration option.
#  MC_8 -              - Made minor changes to the SVS client section -- to give
#                        proper error if an invalid user is specified to receive
#                        a notification of a newer version.
#  MC_8 -              - Remove *inter:str proc, replaced with format's instead
#                        (more efficient).
#  MC_8 -              - Rewrote the ban masking proc, it's quicker.
#  MC_8 -              - Removed the findip proc.
#
# v3.0 (10.14.01)
#  MC_8 -       - Added prompt interface for +(bad|exempt)word.
#  MC_8 -       - Bots were flooding "U" on load via botnet link.
#  MC_8 -       - Bot was getting flooded down with utimers.
#  MC_8 -       - Entrie expire time wasn't working.
#  MC_8 -       - Added dcc commands; exemptwords, +exemptword, -exemptword
#  MC_8 - ckitt - Fixed 'invalid command name ...' dealing with  '("1-2" arm
#                 line 1)' (part of the db auto conversion).
#  MC_8 -       - Added catches to not put a kick (nor ban) on the channel if
#                 the user (or banmask) isn't on the channel, saves bandwidth
#                 and also makes the listed 'Actions:' performed smaller.
#  MC_8 - ckitt - Relay kick message has a pre pending ':' that shouldn't be
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
#                 nick>`.  This error doesn't occur on undernet, was found on
#                 dalnet.
#  MC_8 -       - If bantime was set to -1, it wasn't kicking as well.  Fixed.
#  MC_8 -       - It is no longer mandatory to quote the *bad*string* upon
#                 removal if it contains a space.
#  MC_8 -       - It now gives a better explanation of what actions were taken
#                 upon catching a violator.
#  MC_8 - ckitt - Added botnet relay features.
#  MC_8 -       - Fixed special character handling for bad word strings.
#  MC_8 -       - Change kickop and kickvoice to exemptop and exemptvoice.
#  MC_8 - ckitt - Wasn't kicking after setting a ban for bad word match on
#                 private (notice/ msg/ action)'s.
#  MC_8 - ckitt - Further adjusted replacement variable messages.
#  MC_8 - ckitt - On &global and &message's, the %channel replacement variable
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
#  MC_8 - ICU     - Fixed +/-badword dcc command requirement for the *bad*word*.
#  MC_8 - Rami    - Fixed `Tcl error [mc:msgm:weed]: wrong # args: should be
#                   "foreach varList list ?varList list ...? command"`.
#  MC_8 - KatzEye - Added ability to have perm bans, instead of timed bans.
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
#  MC_8 -          - Removed the requirement of having to "quote" searches
#                    containing spaces.
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
#                     #warez4warez is "*ratio*", and let's say user X in
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
#  MC_8 -       - Added %match variable to warning message and kick message.
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
