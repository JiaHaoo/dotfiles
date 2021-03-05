# Automatically start ssh-agent if it's not running
SSH_ENV="$HOME/.ssh/environment"
 
function start_agent {
        echo "Initialising new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        echo succeeded
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add;
        /usr/bin/ssh-add ~/.ssh/id_pure_root;
}
 
if [ -f "${SSH_ENV}" ]
then
        . "${SSH_ENV}" > /dev/null
        #ps ${SSH_AGENT_PID} doesn't work under cywgin
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
                start_agent;
        }
else
        start_agent;
fi

function parse_git_dirty {
      [[ $(git status 2> /dev/null | tail -n1 | awk '{print $NF}') != "clean" ]] && echo "*"
}
function parse_git_branch {
      git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

# prompt
PS1="\[\e[32;49m\]\t \[\e[39;49m\]\u \[\e[33;49m\]\w\[\e[30;0m\] \n$ "
PS1='\[\e[33;49m\]\t ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \[\e[33;49m\]$(parse_git_branch)\n\[\033[00m\]$ '

export CLICOLOR=1


# alias
alias cd_aws="cd ~/workspace/keys/aws"
alias ll="ls -lh"
alias l="ls"
alias monster="ssh -Y dev-hjia"
alias monster2="ssh -Y dev-hjia2"


# path
export PATH=$PATH:~/workspace/tools
export PATH=$PATH:~/Library/Python/2.7/bin

# tools
lookfor () {
   local suffix=$1
   local keyword=$2
   local num_context=$3
   local cmd=$(printf "find . -name '*%s' -type f |xargs grep -n --color '%s'" "$suffix" "$keyword")
   if [ -n "$num_context" ]; then
       cmd=$(printf "${cmd} -C %s" $num_context)
   fi

   echo ">> $cmd"
   eval $cmd
}

work () {
   cd ~/workspace/purity
}


pretty () {
   cd `git rev-parse --show-toplevel`
   git diff -U0 --no-color HEAD^ | clang-format-diff.py -i -p1
   cd - > /dev/null
}

source ~/.git-completion.bash

ssh-add -K ~/.ssh/id_rsa


alias dawn="ssh -p 1111 pascal@localhost"
alias blackberry="ssh -p 1111 pascal@localhost"


## cmake
# add_library_path: required before running executables directly,
# if need to link to lib/ under project directory
function add_library_path {
	    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(git rev-parse --show-toplevel)/lib;
    }
# gg_build: build and install
function gg_build {
	    cd $(git rev-parse --show-toplevel);
	        cmake -H. -Bbuild &&
			        cmake --build build -- -j3 &&
				        cmake --build build --target install;
		    cd -;
	    }
    # gg_test: add library path and run unittest cmd, doesn't change environment variable LD_LIBRARY_PATH
    function gg_test {
	        LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(git rev-parse --show-toplevel)/lib $(git rev-parse --show-toplevel)/bin/unittest;
	}
# gg_app: run main()
function gg_app {
	    $(git rev-parse --show-toplevel)/bin/app
    }

# run the following cmd (in another shell, don't uncomment it) if it's a new machine
# cd; mkdir -p .bash && cd .bash && ln -s ../workspace/dotfiles/new_project.sh new_project.sh
source ~/.bash/new_project.sh
