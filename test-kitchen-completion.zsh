# petere wrote this, I just packaged it to use with antigen.
#
# The working parts are his, the broken parts are mine.
#
# Original source:
# https://gist.githubusercontent.com/petere/10307599/raw/8abbadd52bf5099628c75cee75801272f84d76a9/_kitchen


_kitchen() {
	local curcontext="$curcontext" state line
	typeset -A opt_args

	_arguments '1: :->cmds'\
	           '2: :->args'

	case $state in
		cmds)
			_arguments "1:Commands:(console converge create destroy diagnose driver help init list login setup test verify version)"
			;;
		args)
			case $line[1] in
				converge|create|destroy|diagnose|list|setup|test|verify)
					compadd "$@" all
					_kitchen_instances
					;;
				login)
					_kitchen_instances
					;;
			esac
			;;
	esac
}

_kitchen_instances() {
	if [[ $_kitchen_instances_cache_dir != $PWD ]]; then
		unset _kitchen_instances_cache
	fi
	if [[ ${+_kitchen_instances_cache} -eq 0 ]]; then
		_kitchen_instances_cache=(${(f)"$(bundle exec kitchen list -b 2>/dev/null || kitchen list -b 2>/dev/null)"})
		_kitchen_instances_cache_dir=$PWD
	fi
	compadd -a _kitchen_instances_cache
}

_kitchen "$@"

compdef _kitchen kitchen
