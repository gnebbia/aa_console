# Aa_console
```
================================================
                 _____ _____
                |  _  |  _  |
                |     |     |
                |__|__|__|__|
   _____ _____ _____ _____ _____ __    _____
  |     |     |   | |   __|     |  |  |   __|
  |   --|  |  | | | |__   |  |  |  |__|   __|
  |_____|_____|_|___|_____|_____|_____|_____|

================================================

aa-console > 
```
## What is aa_console?
Aa_console is a CLI tool that helps with AppArmor management; It simplifies the basic AppArmor operations and adds some custom commands (e.g. `log_search`) </br>

## Requirements
In order to use `aa_console` you need:
* **AppArmor** installed and enabled (please refer to the [official wiki](https://gitlab.com/apparmor/apparmor/wikis/home) for installation)
* **Ruby** installed on your system
* **auditd** installed and enabled on your system (the `log_search` command relies on this daemon)

## Usage
The main file is the one called `./aa_console.rb` and it **must be run as sudo**. Once the program is running you have just to type `help` to get a command list with description </br>
```
================================================
[ COMMAND ]                [ RESULT ]
================================================
> list [type]                
     all                  - show all profiles
     enforce              - show enforce
     complain             - show complain

> search [string]         - search for a
                            profile matching
                            string

> generate [name] <flag>  - generate prof
                            with given name
     -m                   - launch generate
                            in manual mode

> log_search <flag>       - search for DENIED
                            processes in logs
     -d                   - search on the
                            day's log
     -n                   - search on the
                            previous N days log

> change_prof <m> [prof]  - change 'prof' in mode
                            specified with 'm'
     -e                   - change in Enforce
     -c                   - change in Complain


> help                    - print help
                            (used after a cmd
                            shows cmd usage)

> exit                    - exit
```
