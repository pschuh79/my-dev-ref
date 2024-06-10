#!/bin/bash

# The above is the shebang. The shebang specifies which interpreter will be used when executing the script.
# The shebang can be different depending on shell version or path where the binaries reside.
# There seems to be a bit of a debate as to the best general use shebang to use but it seems to be #!/bin/bash or #!/usr/bin/env bash
# This may be the same for zsh or sh or other shells

echo test-bed

# $$ is called a special parameter. These parameters may only be referenced. Assignment to them is verboten.
# See this link for other special parameters. https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters
# $$ Expands to the process ID (PID) of the shell. In a subshell, it expands to the process ID of the invoking shell, not the subshell.
echo $$

# spacing seems to be important when writing bash scripts. It can mean the difference between the script functioning, not functioning
# or functioning incorrectly.
# The $(...) syntax is called command substitution. It allows you to capture the output of a command and use it as part of another command.
timestamp=$(date +%Y-%m-%d-%H%M)

echo $timestamp

# cron jobs don't appear to be able to access envronment variables. If using environment variables, it seems that the env variables need to be explicitly
# called in the script. Check out this thread - https://stackoverflow.com/questions/2229825/where-can-i-set-environment-variables-that-crontab-will-use
# when setting up the cron command, I may need to use the absolute path of the interpreter

# associative arrays in shell
declare -A databases=(
  ["db1"]="client_db1"
  ["db2"]="client_db2"
  ["db3"]="client_db3"
)
