# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
VCS_INFO_formats () {
	setopt localoptions noksharrays NO_shwordsplit
	local msg tmp
	local -i i
	local -A hook_com
	hook_com=(action "$1" action_orig "$1" branch "$2" branch_orig "$2" base "$3" base_orig "$3" staged "$4" staged_orig "$4" unstaged "$5" unstaged_orig "$5" revision "$6" revision_orig "$6" misc "$7" misc_orig "$7" vcs "${vcs}" vcs_orig "${vcs}") 
	hook_com[base-name]="${${hook_com[base]}:t}" 
	hook_com[base-name_orig]="${hook_com[base-name]}" 
	hook_com[subdir]="$(VCS_INFO_reposub ${hook_com[base]})" 
	hook_com[subdir_orig]="${hook_com[subdir]}" 
	: vcs_info-patch-9b9840f2-91e5-4471-af84-9e9a0dc68c1b
	for tmp in base base-name branch misc revision subdir
	do
		hook_com[$tmp]="${hook_com[$tmp]//\%/%%}" 
	done
	VCS_INFO_hook 'post-backend'
	if [[ -n ${hook_com[action]} ]]
	then
		zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" actionformats msgs
		(( ${#msgs} < 1 )) && msgs[1]=' (%s)-[%b|%a]%u%c-' 
	else
		zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" formats msgs
		(( ${#msgs} < 1 )) && msgs[1]=' (%s)-[%b]%u%c-' 
	fi
	if [[ -n ${hook_com[staged]} ]]
	then
		zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" stagedstr tmp
		[[ -z ${tmp} ]] && hook_com[staged]='S'  || hook_com[staged]=${tmp} 
	fi
	if [[ -n ${hook_com[unstaged]} ]]
	then
		zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" unstagedstr tmp
		[[ -z ${tmp} ]] && hook_com[unstaged]='U'  || hook_com[unstaged]=${tmp} 
	fi
	if [[ ${quiltmode} != 'standalone' ]] && VCS_INFO_hook "pre-addon-quilt"
	then
		local REPLY
		VCS_INFO_quilt addon
		hook_com[quilt]="${REPLY}" 
		unset REPLY
	elif [[ ${quiltmode} == 'standalone' ]]
	then
		hook_com[quilt]=${hook_com[misc]} 
	fi
	(( ${#msgs} > maxexports )) && msgs[$(( maxexports + 1 )),-1]=() 
	for i in {1..${#msgs}}
	do
		if VCS_INFO_hook "set-message" $(( $i - 1 )) "${msgs[$i]}"
		then
			zformat -f msg ${msgs[$i]} a:${hook_com[action]} b:${hook_com[branch]} c:${hook_com[staged]} i:${hook_com[revision]} m:${hook_com[misc]} r:${hook_com[base-name]} s:${hook_com[vcs]} u:${hook_com[unstaged]} Q:${hook_com[quilt]} R:${hook_com[base]} S:${hook_com[subdir]}
			msgs[$i]=${msg} 
		else
			msgs[$i]=${hook_com[message]} 
		fi
	done
	hook_com=() 
	backend_misc=() 
	return 0
}
_SUSEconfig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
__arguments () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
__git_prompt_git () {
	GIT_OPTIONAL_LOCKS=0 command git "$@"
}
__nvm () {
	declare previous_word
	previous_word="${COMP_WORDS[COMP_CWORD - 1]}" 
	case "${previous_word}" in
		(use | run | exec | ls | list | uninstall) __nvm_installed_nodes ;;
		(alias | unalias) __nvm_alias ;;
		(*) __nvm_commands ;;
	esac
	return 0
}
__nvm_alias () {
	__nvm_generate_completion "$(__nvm_aliases)"
}
__nvm_aliases () {
	declare aliases
	aliases="" 
	if [ -d "${NVM_DIR}/alias" ]
	then
		aliases="$(command cd "${NVM_DIR}/alias" && command find "${PWD}" -type f | command sed "s:${PWD}/::")" 
	fi
	echo "${aliases} node stable unstable iojs"
}
__nvm_commands () {
	declare current_word
	declare command
	current_word="${COMP_WORDS[COMP_CWORD]}" 
	COMMANDS='
    help install uninstall use run exec
    alias unalias reinstall-packages
    current list ls list-remote ls-remote
    install-latest-npm
    cache deactivate unload
    version version-remote which' 
	if [ ${#COMP_WORDS[@]} == 4 ]
	then
		command="${COMP_WORDS[COMP_CWORD - 2]}" 
		case "${command}" in
			(alias) __nvm_installed_nodes ;;
		esac
	else
		case "${current_word}" in
			(-*) __nvm_options ;;
			(*) __nvm_generate_completion "${COMMANDS}" ;;
		esac
	fi
}
__nvm_generate_completion () {
	declare current_word
	current_word="${COMP_WORDS[COMP_CWORD]}" 
	COMPREPLY=($(compgen -W "$1" -- "${current_word}")) 
	return 0
}
__nvm_installed_nodes () {
	__nvm_generate_completion "$(nvm_ls) $(__nvm_aliases)"
}
__nvm_options () {
	OPTIONS='' 
	__nvm_generate_completion "${OPTIONS}"
}
_a2ps () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_a2utils () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_aap () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_abcde () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_absolute_command_paths () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ack () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_acpi () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_acpitool () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_acroread () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_adb () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_add-zle-hook-widget () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_add-zsh-hook () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_alias () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_aliases () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_all_labels () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_all_matches () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_alsa-utils () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_alternative () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_analyseplugin () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ansible () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ant () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_antiword () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_apachectl () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_apm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_approximate () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_apt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_apt-file () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_apt-move () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_apt-show-versions () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_aptitude () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_arch_archives () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_arch_namespace () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_arg_compile () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_arguments () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_arp () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_arping () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_arrays () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_asciidoctor () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_asciinema () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_assign () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_at () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_attr () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_augeas () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_auto-apt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_autocd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_avahi () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_awk () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_aws () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_axi-cache () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_base64 () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_basename () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_basenc () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bash () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bash_complete () {
	local ret=1 
	local -a suf matches
	local -x COMP_POINT COMP_CWORD
	local -a COMP_WORDS COMPREPLY BASH_VERSINFO
	local -x COMP_LINE="$words" 
	local -A savejobstates savejobtexts
	(( COMP_POINT = 1 + ${#${(j. .)words[1,CURRENT-1]}} + $#QIPREFIX + $#IPREFIX + $#PREFIX ))
	(( COMP_CWORD = CURRENT - 1))
	COMP_WORDS=("${words[@]}") 
	BASH_VERSINFO=(2 05b 0 1 release) 
	savejobstates=(${(kv)jobstates}) 
	savejobtexts=(${(kv)jobtexts}) 
	[[ ${argv[${argv[(I)nospace]:-0}-1]} = -o ]] && suf=(-S '') 
	matches=(${(f)"$(compgen $@ -- ${words[CURRENT]})"}) 
	if [[ -n $matches ]]
	then
		if [[ ${argv[${argv[(I)filenames]:-0}-1]} = -o ]]
		then
			compset -P '*/' && matches=(${matches##*/}) 
			compset -S '/*' && matches=(${matches%%/*}) 
			compadd -f "${suf[@]}" -a matches && ret=0 
		else
			compadd "${suf[@]}" - "${(@)${(Q@)matches}:#*\ }" && ret=0 
			compadd -S ' ' - ${${(M)${(Q)matches}:#*\ }% } && ret=0 
		fi
	fi
	if (( ret ))
	then
		if [[ ${argv[${argv[(I)default]:-0}-1]} = -o ]]
		then
			_default "${suf[@]}" && ret=0 
		elif [[ ${argv[${argv[(I)dirnames]:-0}-1]} = -o ]]
		then
			_directories "${suf[@]}" && ret=0 
		fi
	fi
	return ret
}
_bash_completions () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bat () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_baudrates () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_baz () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_be_name () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_beadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_beep () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bibtex () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bind_addresses () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bindkey () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bison () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bittorrent () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bogofilter () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bpf_filters () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bpython () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_brace_parameter () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_brctl () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_brew () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_bsd_disks () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bsd_pkg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bsdconfig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bsdinstall () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_btrfs () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bts () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bug () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_builtin () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bzip2 () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_bzr () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cabal () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cache_invalid () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_caffeinate () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cal () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_calendar () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_call_function () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_call_program () {
	local -xi COLUMNS=999 
	local curcontext="${curcontext}" tmp err_fd=-1 clocale='_comp_locale;' 
	local -a prefix
	if [[ "$1" = -p ]]
	then
		shift
		if (( $#_comp_priv_prefix ))
		then
			curcontext="${curcontext%:*}/${${(@M)_comp_priv_prefix:#^*[^\\]=*}[1]}:" 
			zstyle -t ":completion:${curcontext}:${1}" gain-privileges && prefix=($_comp_priv_prefix) 
		fi
	elif [[ "$1" = -l ]]
	then
		shift
		clocale='' 
	fi
	if (( ${debug_fd:--1} > 2 )) || [[ ! -t 2 ]]
	then
		exec {err_fd}>&2
	else
		exec {err_fd}> /dev/null
	fi
	{
		if zstyle -s ":completion:${curcontext}:${1}" command tmp
		then
			if [[ "$tmp" = -* ]]
			then
				eval $clocale "$tmp[2,-1]" "$argv[2,-1]"
			else
				eval $clocale $prefix "$tmp"
			fi
		else
			eval $clocale $prefix "$argv[2,-1]"
		fi 2>&$err_fd
	} always {
		exec {err_fd}>&-
	}
}
_canonical_paths () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_capabilities () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ccal () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cdbs-edit-patch () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cdcd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cdr () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cdrdao () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cdrecord () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chattr () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chcon () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chflags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chkconfig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chmod () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_choom () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chown () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chroot () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chrt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_chsh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cksum () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_clay () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cmdambivalent () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cmdstring () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cmp () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_code () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_codex () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_column () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_combination () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_comm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_command () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_command_names () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_comp_locale () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_compadd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_compdef () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_complete () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_complete_debug () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_complete_help () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_complete_help_generic () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_complete_tag () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_completers () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_composer () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_compress () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_condition () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_configure () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_coreadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_correct () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_correct_filename () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_correct_word () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cowsay () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cp () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cpio () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cplay () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cpupower () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_crontab () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cryptsetup () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cscope () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_csplit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cssh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_csup () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ctags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ctags_tags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cu () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_curl () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cut () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cvs () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cvsup () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cygcheck () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cygpath () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cygrunsrv () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cygserver () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_cygstart () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dak () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_darcs () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_date () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_date_formats () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dates () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dbus () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dchroot () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dchroot-dsa () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dconf () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dcop () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dcut () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_deb_architectures () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_deb_codenames () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_deb_files () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_deb_packages () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debbugs_bugnumber () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debchange () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debcheckout () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debdiff () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debfoster () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_deborphan () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debsign () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debsnap () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_debuild () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_default () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_defaults () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_defer_async_git_register () {
	case "${PS1}:${PS2}:${PS3}:${PS4}:${RPROMPT}:${RPS1}:${RPS2}:${RPS3}:${RPS4}" in
		(*(\$\(git_prompt_info\)|\`git_prompt_info\`)*) _omz_register_handler _omz_git_prompt_info ;;
	esac
	case "${PS1}:${PS2}:${PS3}:${PS4}:${RPROMPT}:${RPS1}:${RPS2}:${RPS3}:${RPS4}" in
		(*(\$\(git_prompt_status\)|\`git_prompt_status\`)*) _omz_register_handler _omz_git_prompt_status ;;
	esac
	add-zsh-hook -d precmd _defer_async_git_register
	unset -f _defer_async_git_register
}
_delimiters () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_describe () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_description () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_devtodo () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_df () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dhclient () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dhcpinfo () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dict () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dict_words () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_diff () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_diff3 () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_diff_options () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_diffstat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dir_list () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_directories () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_directory_stack () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dirs () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_disable () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dispatch () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_django () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dkms () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dladm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dlocate () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dmesg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dmidecode () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dnf () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dns_types () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_doas () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_docker () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_domains () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dos2unix () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dpatch-edit-patch () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dpkg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dpkg-buildpackage () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dpkg-cross () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dpkg-repack () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dpkg_source () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dput () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_drill () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dropbox () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dscverify () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dsh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dtrace () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dtruss () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_du () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dumpadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dumper () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dupload () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dvi () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_dynamic_directory_name () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_e2label () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ecasound () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_echotc () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_echoti () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ed () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_elfdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_elinks () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_email_addresses () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_emulate () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_enable () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_enscript () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_entr () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_env () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_eog () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_equal () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_espeak () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_etags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ethtool () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_evince () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_exa () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_exec () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_expand () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_expand_alias () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_expand_word () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_extensions () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_external_pwds () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fakeroot () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fbsd_architectures () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fbsd_device_types () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fc () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_feh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fetch () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fetchmail () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ffmpeg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_figlet () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_file_descriptors () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_file_flags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_file_modes () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_file_systems () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_files () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_find () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_find_net_interfaces () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_findmnt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_finger () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fink () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_first () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_flac () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_flex () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_floppy () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_flowadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fmadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fmt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fold () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fortune () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_free () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_freebsd-update () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fs_usage () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fsh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fstat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_functions () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fuse_arguments () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fuse_values () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fuser () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fusermount () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_fw_update () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gcc () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gcore () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gdb () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_geany () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gem () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_generic () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_genisoimage () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_getclip () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_getconf () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_getent () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_getfacl () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_getmail () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_getopt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ghostscript () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_git () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_git-buildpackage () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_glab () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_global () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_global_tags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_globflags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_globqual_delims () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_globquals () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gnome-gv () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gnu_generic () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gnupod () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gnutls () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_go () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gpasswd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gpg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gphoto2 () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gprof () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gqview () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gradle () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_graphicsmagick () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_grep () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_grep-excuses () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_groff () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_groups () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_growisofs () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gsettings () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gstat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_guard () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_guilt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gv () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_gzip () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_hash () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_have_glob_qual () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_hdiutil () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_head () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_hexdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_history () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_history_complete_word () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_history_modifiers () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_host () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_hostname () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_hosts () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_htop () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_hwinfo () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_iconv () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_iconvconfig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_id () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ifconfig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_iftop () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ignored () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_imagemagick () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_in_vared () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_inetadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_init_d () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_initctl () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_install () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_invoke-rc.d () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ionice () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_iostat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ip () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ipadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ipfw () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ipsec () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ipset () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_iptables () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_irssi () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ispell () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_iwconfig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jail () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jails () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_java () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_java_class () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jexec () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jls () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jobs () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jobs_bg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jobs_builtin () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jobs_fg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_joe () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_join () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jot () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_jq () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_kdeconnect () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_kdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_kfmclient () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_kill () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_killall () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_kld () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_knock () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_kpartx () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ktrace () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ktrace_points () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_kubectl () {
	# undefined
	builtin autoload -XUz /Applications/OrbStack.app/Contents/MacOS/../Resources/completions/zsh
}
_kvno () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_last () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ld_debug () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ldap () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ldconfig () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ldd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_less () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lha () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_libvirt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lighttpd () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_limit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_limits () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_links () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lintian () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_list () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_list_files () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lldb () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ln () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_loadkeys () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_locale () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_localedef () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_locales () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_locate () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_logger () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_logical_volumes () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_login_classes () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_look () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_losetup () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lp () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ls () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lsattr () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lsblk () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lscfg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lsdev () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lslv () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lsns () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lsof () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lspv () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lsusb () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lsvg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ltrace () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lua () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_luarocks () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lynx () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lz4 () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_lzop () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mac_applications () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mac_files_for_application () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_madison () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mail () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mailboxes () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_main_complete () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_make () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_make-kpkg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_man () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mat2 () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_match () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_math () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_math_params () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_matlab () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_md5sum () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mdadm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mdatp () {
	# undefined
	builtin autoload -XUz /usr/local/share/zsh/site-functions
}
_mdfind () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mdls () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mdutil () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_members () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mencal () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_menu () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mere () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mergechanges () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_message () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mii-tool () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mime_types () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mixerctl () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mkdir () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mkfifo () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mknod () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mkshortcut () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mktemp () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mkzsh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_module () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_module-assistant () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_module_math_func () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_modutils () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mondo () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_monotone () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_moosic () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mosh () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_most_recent_file () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mount () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mozilla () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mpc () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mplayer () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mtools () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mtr () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_multi_parts () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mupdf () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mutt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mv () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_my_accounts () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_myrepos () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mysql_utils () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_mysqldiff () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nautilus () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nbsd_architectures () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ncftp () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nedit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_net_interfaces () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_netcat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_netscape () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_netstat () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_networkmanager () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_networksetup () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_newsgroups () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_next_label () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_next_tags () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nginx () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_ngrep () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nice () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nkf () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nl () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nmap () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_normal () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nothing () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_npm () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nsenter () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nslookup () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_numbers () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_numfmt () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_nvram () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_objdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_object_classes () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_object_files () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_obsd_architectures () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_od () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_okular () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_oldlist () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_omz () {
	local -a cmds subcmds
	cmds=('changelog:Print the changelog' 'help:Usage information' 'plugin:Manage plugins' 'pr:Manage Oh My Zsh Pull Requests' 'reload:Reload the current zsh session' 'shop:Open the Oh My Zsh shop' 'theme:Manage themes' 'update:Update Oh My Zsh' 'version:Show the version') 
	if (( CURRENT == 2 ))
	then
		_describe 'command' cmds
	elif (( CURRENT == 3 ))
	then
		case "$words[2]" in
			(changelog) local -a refs
				refs=("${(@f)$(builtin cd -q "$ZSH"; command git for-each-ref --format="%(refname:short):%(subject)" refs/heads refs/tags)}") 
				_describe 'command' refs ;;
			(plugin) subcmds=('disable:Disable plugin(s)' 'enable:Enable plugin(s)' 'info:Get plugin information' 'list:List plugins' 'load:Load plugin(s)') 
				_describe 'command' subcmds ;;
			(pr) subcmds=('clean:Delete all Pull Request branches' 'test:Test a Pull Request') 
				_describe 'command' subcmds ;;
			(theme) subcmds=('list:List themes' 'set:Set a theme in your .zshrc file' 'use:Load a theme') 
				_describe 'command' subcmds ;;
		esac
	elif (( CURRENT == 4 ))
	then
		case "${words[2]}::${words[3]}" in
			(plugin::(disable|enable|load)) local -aU valid_plugins
				if [[ "${words[3]}" = disable ]]
				then
					valid_plugins=($plugins) 
				else
					valid_plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)) 
					[[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins}) 
				fi
				_describe 'plugin' valid_plugins ;;
			(plugin::info) local -aU plugins
				plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)) 
				_describe 'plugin' plugins ;;
			(plugin::list) local -a opts
				opts=('--enabled:List enabled plugins only') 
				_describe -o 'options' opts ;;
			(theme::(set|use)) local -aU themes
				themes=("$ZSH"/themes/*.zsh-theme(-.N:t:r) "$ZSH_CUSTOM"/**/*.zsh-theme(-.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::)) 
				_describe 'theme' themes ;;
		esac
	elif (( CURRENT > 4 ))
	then
		case "${words[2]}::${words[3]}" in
			(plugin::(enable|disable|load)) local -aU valid_plugins
				if [[ "${words[3]}" = disable ]]
				then
					valid_plugins=($plugins) 
				else
					valid_plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)) 
					[[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins}) 
				fi
				local -a args
				args=(${words[4,$(( CURRENT - 1))]}) 
				valid_plugins=(${valid_plugins:|args}) 
				_describe 'plugin' valid_plugins ;;
		esac
	fi
	return 0
}
_omz::changelog () {
	local version=${1:-HEAD} format=${3:-"--text"} 
	if (
			builtin cd -q "$ZSH"
			! command git show-ref --verify refs/heads/$version && ! command git show-ref --verify refs/tags/$version && ! command git rev-parse --verify "${version}^{commit}"
		) &> /dev/null
	then
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} [version]

NOTE: <version> must be a valid branch, tag or commit.
EOF
		return 1
	fi
	ZSH="$ZSH" command zsh -f "$ZSH/tools/changelog.sh" "$version" "${2:-}" "$format"
}
_omz::confirm () {
	if [[ -n "$1" ]]
	then
		_omz::log prompt "$1" "${${functrace[1]#_}%:*}"
	fi
	read -r -k 1
	if [[ "$REPLY" != $'\n' ]]
	then
		echo
	fi
}
_omz::help () {
	cat >&2 <<EOF
Usage: omz <command> [options]

Available commands:

  help                Print this help message
  changelog           Print the changelog
  plugin <command>    Manage plugins
  pr     <command>    Manage Oh My Zsh Pull Requests
  reload              Reload the current zsh session
  shop                Open the Oh My Zsh shop
  theme  <command>    Manage themes
  update              Update Oh My Zsh
  version             Show the version

EOF
}
_omz::log () {
	setopt localoptions nopromptsubst
	local logtype=$1 
	local logname=${3:-${${functrace[1]#_}%:*}} 
	if [[ $logtype = debug && -z $_OMZ_DEBUG ]]
	then
		return
	fi
	case "$logtype" in
		(prompt) print -Pn "%S%F{blue}$logname%f%s: $2" ;;
		(debug) print -P "%F{white}$logname%f: $2" ;;
		(info) print -P "%F{green}$logname%f: $2" ;;
		(warn) print -P "%S%F{yellow}$logname%f%s: $2" ;;
		(error) print -P "%S%F{red}$logname%f%s: $2" ;;
	esac >&2
}
_omz::plugin () {
	(( $# > 0 && $+functions[$0::$1] )) || {
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  disable <plugin> Disable plugin(s)
  enable <plugin>  Enable plugin(s)
  info <plugin>    Get information of a plugin
  list [--enabled] List Oh My Zsh plugins
  load <plugin>    Load plugin(s)

EOF
		return 1
	}
	local command="$1" 
	shift
	$0::$command "$@"
}
_omz::plugin::disable () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]" >&2
		return 1
	fi
	local -a dis_plugins
	for plugin in "$@"
	do
		if [[ ${plugins[(Ie)$plugin]} -eq 0 ]]
		then
			_omz::log warn "plugin '$plugin' is not enabled."
			continue
		fi
		dis_plugins+=("$plugin") 
	done
	if [[ ${#dis_plugins} -eq 0 ]]
	then
		return 1
	fi
	local awk_subst_plugins="  gsub(/[ \t]+(${(j:|:)dis_plugins})[ \t]+/, \" \") # with spaces before or after
  gsub(/[ \t]+(${(j:|:)dis_plugins})$/, \"\")       # with spaces before and EOL
  gsub(/^(${(j:|:)dis_plugins})[ \t]+/, \"\")       # with BOL and spaces after

  gsub(/\((${(j:|:)dis_plugins})[ \t]+/, \"(\")     # with parenthesis before and spaces after
  gsub(/[ \t]+(${(j:|:)dis_plugins})\)/, \")\")     # with spaces before or parenthesis after
  gsub(/\((${(j:|:)dis_plugins})\)/, \"()\")        # with only parentheses

  gsub(/^(${(j:|:)dis_plugins})\)/, \")\")          # with BOL and closing parenthesis
  gsub(/\((${(j:|:)dis_plugins})$/, \"(\")          # with opening parenthesis and EOL
" 
	local awk_script="
# if plugins=() is in oneline form, substitute disabled plugins and go to next line
/^[ \t]*plugins=\([^#]+\).*\$/ {
  $awk_subst_plugins
  print \$0
  next
}

# if plugins=() is in multiline form, enable multi flag and disable plugins if they're there
/^[ \t]*plugins=\(/ {
  multi=1
  $awk_subst_plugins
  print \$0
  next
}

# if multi flag is enabled and we find a valid closing parenthesis, remove plugins and disable multi flag
multi == 1 && /^[^#]*\)/ {
  multi=0
  $awk_subst_plugins
  print \$0
  next
}

multi == 1 && length(\$0) > 0 {
  $awk_subst_plugins
  if (length(\$0) > 0) print \$0
  next
}

{ print \$0 }
" 
	local zdot="${ZDOTDIR:-$HOME}" 
	local zshrc="${${:-"${zdot}/.zshrc"}:A}" 
	awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" && command cp -f "$zshrc" "$zdot/.zshrc.bck" && command mv -f "$zdot/.zshrc.new" "$zshrc"
	[[ $? -eq 0 ]] || {
		local ret=$? 
		_omz::log error "error disabling plugins."
		return $ret
	}
	if ! command zsh -n "$zdot/.zshrc"
	then
		_omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
		command mv -f "$zdot/.zshrc.bck" "$zshrc"
		return 1
	fi
	_omz::log info "plugins disabled: ${(j:, :)dis_plugins}."
	[[ ! -o interactive ]] || _omz::reload
}
_omz::plugin::enable () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]" >&2
		return 1
	fi
	local -a add_plugins
	for plugin in "$@"
	do
		if [[ ${plugins[(Ie)$plugin]} -ne 0 ]]
		then
			_omz::log warn "plugin '$plugin' is already enabled."
			continue
		fi
		add_plugins+=("$plugin") 
	done
	if [[ ${#add_plugins} -eq 0 ]]
	then
		return 1
	fi
	local awk_script="
# if plugins=() is in oneline form, substitute ) with new plugins and go to the next line
/^[ \t]*plugins=\([^#]+\).*\$/ {
  sub(/\)/, \" $add_plugins&\")
  print \$0
  next
}

# if plugins=() is in multiline form, enable multi flag and indent by default with 2 spaces
/^[ \t]*plugins=\(/ {
  multi=1
  indent=\"  \"
  print \$0
  next
}

# if multi flag is enabled and we find a valid closing parenthesis,
# add new plugins with proper indent and disable multi flag
multi == 1 && /^[^#]*\)/ {
  multi=0
  split(\"$add_plugins\",p,\" \")
  for (i in p) {
    print indent p[i]
  }
  print \$0
  next
}

# if multi flag is enabled and we didnt find a closing parenthesis,
# get the indentation level to match when adding plugins
multi == 1 && /^[^#]*/ {
  indent=\"\"
  for (i = 1; i <= length(\$0); i++) {
    char=substr(\$0, i, 1)
    if (char == \" \" || char == \"\t\") {
      indent = indent char
    } else {
      break
    }
  }
}

{ print \$0 }
" 
	local zdot="${ZDOTDIR:-$HOME}" 
	local zshrc="${${:-"${zdot}/.zshrc"}:A}" 
	awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" && command cp -f "$zshrc" "$zdot/.zshrc.bck" && command mv -f "$zdot/.zshrc.new" "$zshrc"
	[[ $? -eq 0 ]] || {
		local ret=$? 
		_omz::log error "error enabling plugins."
		return $ret
	}
	if ! command zsh -n "$zdot/.zshrc"
	then
		_omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
		command mv -f "$zdot/.zshrc.bck" "$zshrc"
		return 1
	fi
	_omz::log info "plugins enabled: ${(j:, :)add_plugins}."
	[[ ! -o interactive ]] || _omz::reload
}
_omz::plugin::info () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin>" >&2
		return 1
	fi
	local readme
	for readme in "$ZSH_CUSTOM/plugins/$1/README.md" "$ZSH/plugins/$1/README.md"
	do
		if [[ -f "$readme" ]]
		then
			if [[ ! -t 1 ]]
			then
				cat "$readme"
				return $?
			fi
			case 1 in
				(${+commands[glow]}) glow -p "$readme" ;;
				(${+commands[bat]}) bat -l md --style plain "$readme" ;;
				(${+commands[less]}) less "$readme" ;;
				(*) cat "$readme" ;;
			esac
			return $?
		fi
	done
	if [[ -d "$ZSH_CUSTOM/plugins/$1" || -d "$ZSH/plugins/$1" ]]
	then
		_omz::log error "the '$1' plugin doesn't have a README file"
	else
		_omz::log error "'$1' plugin not found"
	fi
	return 1
}
_omz::plugin::list () {
	local -a custom_plugins builtin_plugins
	if [[ "$1" == "--enabled" ]]
	then
		local plugin
		for plugin in "${plugins[@]}"
		do
			if [[ -d "${ZSH_CUSTOM}/plugins/${plugin}" ]]
			then
				custom_plugins+=("${plugin}") 
			elif [[ -d "${ZSH}/plugins/${plugin}" ]]
			then
				builtin_plugins+=("${plugin}") 
			fi
		done
	else
		custom_plugins=("$ZSH_CUSTOM"/plugins/*(-/N:t)) 
		builtin_plugins=("$ZSH"/plugins/*(-/N:t)) 
	fi
	if [[ ! -t 1 ]]
	then
		print -l ${(q-)custom_plugins} ${(q-)builtin_plugins}
		return
	fi
	if (( ${#custom_plugins} ))
	then
		print -P "%U%BCustom plugins%b%u:"
		print -lac ${(q-)custom_plugins}
	fi
	if (( ${#builtin_plugins} ))
	then
		(( ${#custom_plugins} )) && echo
		print -P "%U%BBuilt-in plugins%b%u:"
		print -lac ${(q-)builtin_plugins}
	fi
}
_omz::plugin::load () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]" >&2
		return 1
	fi
	local plugin base has_completion=0 
	for plugin in "$@"
	do
		if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]
		then
			base="$ZSH_CUSTOM/plugins/$plugin" 
		elif [[ -d "$ZSH/plugins/$plugin" ]]
		then
			base="$ZSH/plugins/$plugin" 
		else
			_omz::log warn "plugin '$plugin' not found"
			continue
		fi
		if [[ ! -f "$base/_$plugin" && ! -f "$base/$plugin.plugin.zsh" ]]
		then
			_omz::log warn "'$plugin' is not a valid plugin"
			continue
		elif (( ! ${fpath[(Ie)$base]} ))
		then
			fpath=("$base" $fpath) 
		fi
		local -a comp_files
		comp_files=($base/_*(N)) 
		has_completion=$(( $#comp_files > 0 )) 
		if [[ -f "$base/$plugin.plugin.zsh" ]]
		then
			source "$base/$plugin.plugin.zsh"
		fi
	done
	if (( has_completion ))
	then
		compinit -D -d "$_comp_dumpfile"
	fi
}
_omz::pr () {
	(( $# > 0 && $+functions[$0::$1] )) || {
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  clean                       Delete all PR branches (ohmyzsh/pull-*)
  test <PR_number_or_URL>     Fetch PR #NUMBER and rebase against master

EOF
		return 1
	}
	local command="$1" 
	shift
	$0::$command "$@"
}
_omz::pr::clean () {
	(
		set -e
		builtin cd -q "$ZSH"
		local fmt branches
		fmt="%(color:bold blue)%(align:18,right)%(refname:short)%(end)%(color:reset) %(color:dim bold red)%(objectname:short)%(color:reset) %(color:yellow)%(contents:subject)" 
		branches="$(command git for-each-ref --sort=-committerdate --color --format="$fmt" "refs/heads/ohmyzsh/pull-*")" 
		if [[ -z "$branches" ]]
		then
			_omz::log info "there are no Pull Request branches to remove."
			return
		fi
		echo "$branches\n"
		_omz::confirm "do you want remove these Pull Request branches? [Y/n] "
		[[ "$REPLY" != [yY$'\n'] ]] && return
		_omz::log info "removing all Oh My Zsh Pull Request branches..."
		command git branch --list 'ohmyzsh/pull-*' | while read branch
		do
			command git branch -D "$branch"
		done
	)
}
_omz::pr::test () {
	if [[ "$1" = https://* ]]
	then
		1="${1:t}" 
	fi
	if ! [[ -n "$1" && "$1" =~ ^[[:digit:]]+$ ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <PR_NUMBER_or_URL>" >&2
		return 1
	fi
	local branch
	branch=$(builtin cd -q "$ZSH"; git symbolic-ref --short HEAD)  || {
		_omz::log error "error when getting the current git branch. Aborting..."
		return 1
	}
	(
		set -e
		builtin cd -q "$ZSH"
		command git remote -v | while read remote url _
		do
			case "$url" in
				(https://github.com/ohmyzsh/ohmyzsh(|.git)) found=1 
					break ;;
				(git@github.com:ohmyzsh/ohmyzsh(|.git)) found=1 
					break ;;
			esac
		done
		(( $found )) || {
			_omz::log error "could not find the ohmyzsh git remote. Aborting..."
			return 1
		}
		_omz::log info "checking if PR #$1 has the 'testers needed' label..."
		local pr_json label label_id="MDU6TGFiZWw4NzY1NTkwNA==" 
		pr_json=$(
      curl -fsSL \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/ohmyzsh/ohmyzsh/pulls/$1"
    ) 
		if [[ $? -gt 0 || -z "$pr_json" ]]
		then
			_omz::log error "error when trying to fetch PR #$1 from GitHub."
			return 1
		fi
		if (( $+commands[jq] ))
		then
			label="$(command jq ".labels.[] | select(.node_id == \"$label_id\")" <<< "$pr_json")" 
		else
			label="$(command grep "\"$label_id\"" <<< "$pr_json" 2>/dev/null)" 
		fi
		if [[ -z "$label" ]]
		then
			_omz::log warn "PR #$1 does not have the 'testers needed' label. This means that the PR"
			_omz::log warn "has not been reviewed by a maintainer and may contain malicious code."
			_omz::log prompt "Do you want to continue testing it? [yes/N] "
			builtin read -r
			if [[ "${REPLY:l}" != yes ]]
			then
				_omz::log error "PR test canceled. Please ask a maintainer to review and label the PR."
				return 1
			else
				_omz::log warn "Continuing to check out and test PR #$1. Be careful!"
			fi
		fi
		_omz::log info "fetching PR #$1 to ohmyzsh/pull-$1..."
		command git fetch -f "$remote" refs/pull/$1/head:ohmyzsh/pull-$1 || {
			_omz::log error "error when trying to fetch PR #$1."
			return 1
		}
		_omz::log info "rebasing PR #$1..."
		local ret gpgsign
		{
			gpgsign=$(command git config --local commit.gpgsign 2>/dev/null)  || ret=$? 
			[[ $ret -ne 129 ]] || gpgsign=$(command git config commit.gpgsign 2>/dev/null) 
			command git config commit.gpgsign false
			command git rebase master ohmyzsh/pull-$1 || {
				command git rebase --abort &> /dev/null
				_omz::log warn "could not rebase PR #$1 on top of master."
				_omz::log warn "you might not see the latest stable changes."
				_omz::log info "run \`zsh\` to test the changes."
				return 1
			}
		} always {
			case "$gpgsign" in
				("") command git config --unset commit.gpgsign ;;
				(*) command git config commit.gpgsign "$gpgsign" ;;
			esac
		}
		_omz::log info "fetch of PR #${1} successful."
	)
	[[ $? -eq 0 ]] || return 1
	_omz::log info "running \`zsh\` to test the changes. Run \`exit\` to go back."
	command zsh -l
	_omz::confirm "do you want to go back to the previous branch? [Y/n] "
	[[ "$REPLY" != [yY$'\n'] ]] && return
	(
		set -e
		builtin cd -q "$ZSH"
		command git checkout "$branch" -- || {
			_omz::log error "could not go back to the previous branch ('$branch')."
			return 1
		}
	)
}
_omz::reload () {
	command rm -f $_comp_dumpfile $ZSH_COMPDUMP
	local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}" 
	[[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
}
_omz::shop () {
	local shop_url="https://commitgoods.com/collections/oh-my-zsh" 
	_omz::log info "Opening Oh My Zsh shop in your browser..."
	_omz::log info "$shop_url"
	open_command "$shop_url"
}
_omz::theme () {
	(( $# > 0 && $+functions[$0::$1] )) || {
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  list            List all available Oh My Zsh themes
  set <theme>     Set a theme in your .zshrc file
  use <theme>     Load a theme

EOF
		return 1
	}
	local command="$1" 
	shift
	$0::$command "$@"
}
_omz::theme::list () {
	local -a custom_themes builtin_themes
	custom_themes=("$ZSH_CUSTOM"/**/*.zsh-theme(-.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::)) 
	builtin_themes=("$ZSH"/themes/*.zsh-theme(-.N:t:r)) 
	if [[ ! -t 1 ]]
	then
		print -l ${(q-)custom_themes} ${(q-)builtin_themes}
		return
	fi
	if [[ -n "$ZSH_THEME" ]]
	then
		print -Pn "%U%BCurrent theme%b%u: "
		[[ $ZSH_THEME = random ]] && echo "$RANDOM_THEME (via random)" || echo "$ZSH_THEME"
		echo
	fi
	if (( ${#custom_themes} ))
	then
		print -P "%U%BCustom themes%b%u:"
		print -lac ${(q-)custom_themes}
		echo
	fi
	print -P "%U%BBuilt-in themes%b%u:"
	print -lac ${(q-)builtin_themes}
}
_omz::theme::set () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <theme>" >&2
		return 1
	fi
	if [[ ! -f "$ZSH_CUSTOM/$1.zsh-theme" ]] && [[ ! -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]] && [[ ! -f "$ZSH/themes/$1.zsh-theme" ]]
	then
		_omz::log error "%B$1%b theme not found"
		return 1
	fi
	local awk_script='
!set && /^[ \t]*ZSH_THEME=[^#]+.*$/ {
  set=1
  sub(/^[ \t]*ZSH_THEME=[^#]+.*$/, "ZSH_THEME=\"'$1'\" # set by `omz`")
  print $0
  next
}

{ print $0 }

END {
  # If no ZSH_THEME= line was found, return an error
  if (!set) exit 1
}
' 
	local zdot="${ZDOTDIR:-$HOME}" 
	local zshrc="${${:-"${zdot}/.zshrc"}:A}" 
	awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" || {
		cat <<EOF
ZSH_THEME="$1" # set by \`omz\`

EOF
		cat "$zdot/.zshrc"
	} > "$zdot/.zshrc.new" && command cp -f "$zshrc" "$zdot/.zshrc.bck" && command mv -f "$zdot/.zshrc.new" "$zshrc"
	[[ $? -eq 0 ]] || {
		local ret=$? 
		_omz::log error "error setting theme."
		return $ret
	}
	if ! command zsh -n "$zdot/.zshrc"
	then
		_omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
		command mv -f "$zdot/.zshrc.bck" "$zshrc"
		return 1
	fi
	_omz::log info "'$1' theme set correctly."
	[[ ! -o interactive ]] || _omz::reload
}
_omz::theme::use () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <theme>" >&2
		return 1
	fi
	if [[ -f "$ZSH_CUSTOM/$1.zsh-theme" ]]
	then
		source "$ZSH_CUSTOM/$1.zsh-theme"
	elif [[ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]]
	then
		source "$ZSH_CUSTOM/themes/$1.zsh-theme"
	elif [[ -f "$ZSH/themes/$1.zsh-theme" ]]
	then
		source "$ZSH/themes/$1.zsh-theme"
	else
		_omz::log error "%B$1%b theme not found"
		return 1
	fi
	ZSH_THEME="$1" 
	[[ $1 = random ]] || unset RANDOM_THEME
}
_omz::update () {
	(( $+commands[git] )) || {
		_omz::log error "git is not installed. Aborting..."
		return 1
	}
	[[ "$1" != --unattended ]] || {
		_omz::log error "the \`\e[2m--unattended\e[0m\` flag is no longer supported, use the \`\e[2mupgrade.sh\e[0m\` script instead."
		_omz::log error "for more information see https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ#how-do-i-update-oh-my-zsh"
		return 1
	}
	local last_commit=$(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null) 
	[[ $? -eq 0 ]] || {
		_omz::log error "\`$ZSH\` is not a git directory. Aborting..."
		return 1
	}
	zstyle -s ':omz:update' verbose verbose_mode || verbose_mode=default 
	ZSH="$ZSH" command zsh -f "$ZSH/tools/upgrade.sh" -i -v $verbose_mode || return $?
	zmodload zsh/datetime
	echo "LAST_EPOCH=$(( EPOCHSECONDS / 60 / 60 / 24 ))" >| "${ZSH_CACHE_DIR}/.zsh-update"
	command rm -rf "$ZSH/log/update.lock"
	if [[ "$(builtin cd -q "$ZSH"; git rev-parse HEAD)" != "$last_commit" ]]
	then
		local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}" 
		[[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
	fi
}
_omz::version () {
	(
		builtin cd -q "$ZSH"
		local version
		version=$(command git describe --tags HEAD 2>/dev/null)  || version=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)  || version=$(command git name-rev --no-undefined --name-only --exclude="remotes/*" HEAD 2>/dev/null)  || version="<detached>" 
		local commit=$(command git rev-parse --short HEAD 2>/dev/null) 
		printf "%s (%s)\n" "$version" "$commit"
	)
}
_omz_async_callback () {
	emulate -L zsh
	local fd=$1 
	local err=$2 
	if [[ -z "$err" || "$err" == "hup" ]]
	then
		local handler="${(k)_OMZ_ASYNC_FDS[(r)$fd]}" 
		local old_output="${_OMZ_ASYNC_OUTPUT[$handler]}" 
		IFS= read -r -u $fd -d '' "_OMZ_ASYNC_OUTPUT[$handler]"
		if [[ "$old_output" != "${_OMZ_ASYNC_OUTPUT[$handler]}" ]]
		then
			zle .reset-prompt
			zle -R
		fi
		exec {fd}<&-
	fi
	zle -F "$fd"
	_OMZ_ASYNC_FDS[$handler]=-1 
	_OMZ_ASYNC_PIDS[$handler]=-1 
}
_omz_async_request () {
	setopt localoptions noksharrays unset
	local -i ret=$? 
	typeset -gA _OMZ_ASYNC_FDS _OMZ_ASYNC_PIDS _OMZ_ASYNC_OUTPUT
	local handler
	for handler in ${_omz_async_functions}
	do
		(( ${+functions[$handler]} )) || continue
		local fd=${_OMZ_ASYNC_FDS[$handler]:--1} 
		local pid=${_OMZ_ASYNC_PIDS[$handler]:--1} 
		if (( fd != -1 && pid != -1 )) && {
				true <&$fd
			} 2> /dev/null
		then
			exec {fd}<&-
			zle -F $fd
			if [[ -o MONITOR ]]
			then
				kill -TERM -$pid 2> /dev/null
			else
				kill -TERM $pid 2> /dev/null
			fi
		fi
		_OMZ_ASYNC_FDS[$handler]=-1 
		_OMZ_ASYNC_PIDS[$handler]=-1 
		exec {fd}< <(
      # Tell parent process our PID
      builtin echo ${sysparams[pid]}
      # Set exit code for the handler if used
      () { return $ret }
      # Run the async function handler
      $handler
    )
		_OMZ_ASYNC_FDS[$handler]=$fd 
		is-at-least 5.8 || command true
		read -u $fd "_OMZ_ASYNC_PIDS[$handler]"
		zle -F "$fd" _omz_async_callback
	done
}
_omz_diag_dump_check_core_commands () {
	builtin echo "Core command check:"
	local redefined name builtins externals reserved_words
	redefined=() 
	reserved_words=(do done esac then elif else fi for case if while function repeat time until select coproc nocorrect foreach end '!' '[[' '{' '}') 
	builtins=(alias autoload bg bindkey break builtin bye cd chdir command comparguments compcall compctl compdescribe compfiles compgroups compquote comptags comptry compvalues continue dirs disable disown echo echotc echoti emulate enable eval exec exit false fc fg functions getln getopts hash jobs kill let limit log logout noglob popd print printf pushd pushln pwd r read rehash return sched set setopt shift source suspend test times trap true ttyctl type ulimit umask unalias unfunction unhash unlimit unset unsetopt vared wait whence where which zcompile zle zmodload zparseopts zregexparse zstyle) 
	if is-at-least 5.1
	then
		reserved_word+=(declare export integer float local readonly typeset) 
	else
		builtins+=(declare export integer float local readonly typeset) 
	fi
	builtins_fatal=(builtin command local) 
	externals=(zsh) 
	for name in $reserved_words
	do
		if [[ $(builtin whence -w $name) != "$name: reserved" ]]
		then
			builtin echo "reserved word '$name' has been redefined"
			builtin which $name
			redefined+=$name 
		fi
	done
	for name in $builtins
	do
		if [[ $(builtin whence -w $name) != "$name: builtin" ]]
		then
			builtin echo "builtin '$name' has been redefined"
			builtin which $name
			redefined+=$name 
		fi
	done
	for name in $externals
	do
		if [[ $(builtin whence -w $name) != "$name: command" ]]
		then
			builtin echo "command '$name' has been redefined"
			builtin which $name
			redefined+=$name 
		fi
	done
	if [[ -n "$redefined" ]]
	then
		builtin echo "SOME CORE COMMANDS HAVE BEEN REDEFINED: $redefined"
	else
		builtin echo "All core commands are defined normally"
	fi
}
_omz_diag_dump_echo_file_w_header () {
	local file=$1 
	if [[ -f $file || -h $file ]]
	then
		builtin echo "========== $file =========="
		if [[ -h $file ]]
		then
			builtin echo "==========    ( => ${file:A} )   =========="
		fi
		command cat $file
		builtin echo "========== end $file =========="
		builtin echo
	elif [[ -d $file ]]
	then
		builtin echo "File '$file' is a directory"
	elif [[ ! -e $file ]]
	then
		builtin echo "File '$file' does not exist"
	else
		command ls -lad "$file"
	fi
}
_omz_diag_dump_one_big_text () {
	local program programs progfile md5
	builtin echo oh-my-zsh diagnostic dump
	builtin echo
	builtin echo $outfile
	builtin echo
	command date
	command uname -a
	builtin echo OSTYPE=$OSTYPE
	builtin echo ZSH_VERSION=$ZSH_VERSION
	builtin echo User: $USERNAME
	builtin echo umask: $(umask)
	builtin echo
	_omz_diag_dump_os_specific_version
	builtin echo
	programs=(sh zsh ksh bash sed cat grep ls find git posh) 
	local progfile="" extra_str="" sha_str="" 
	for program in $programs
	do
		extra_str="" sha_str="" 
		progfile=$(builtin which $program) 
		if [[ $? == 0 ]]
		then
			if [[ -e $progfile ]]
			then
				if builtin whence shasum &> /dev/null
				then
					sha_str=($(command shasum $progfile)) 
					sha_str=$sha_str[1] 
					extra_str+=" SHA $sha_str" 
				fi
				if [[ -h "$progfile" ]]
				then
					extra_str+=" ( -> ${progfile:A} )" 
				fi
			fi
			builtin printf '%-9s %-20s %s\n' "$program is" "$progfile" "$extra_str"
		else
			builtin echo "$program: not found"
		fi
	done
	builtin echo
	builtin echo Command Versions:
	builtin echo "zsh: $(zsh --version)"
	builtin echo "this zsh session: $ZSH_VERSION"
	builtin echo "bash: $(bash --version | command grep bash)"
	builtin echo "git: $(git --version)"
	builtin echo "grep: $(grep --version)"
	builtin echo
	_omz_diag_dump_check_core_commands || return 1
	builtin echo
	builtin echo Process state:
	builtin echo pwd: $PWD
	if builtin whence pstree &> /dev/null
	then
		builtin echo Process tree for this shell:
		pstree -p $$
	else
		ps -fT
	fi
	builtin set | command grep -a '^\(ZSH\|plugins\|TERM\|LC_\|LANG\|precmd\|chpwd\|preexec\|FPATH\|TTY\|DISPLAY\|PATH\)\|OMZ'
	builtin echo
	builtin echo Exported:
	builtin echo $(builtin export | command sed 's/=.*//')
	builtin echo
	builtin echo Locale:
	command locale
	builtin echo
	builtin echo Zsh configuration:
	builtin echo setopt: $(builtin setopt)
	builtin echo
	builtin echo zstyle:
	builtin zstyle
	builtin echo
	builtin echo 'compaudit output:'
	compaudit
	builtin echo
	builtin echo '$fpath directories:'
	command ls -lad $fpath
	builtin echo
	builtin echo oh-my-zsh installation:
	command ls -ld ~/.z*
	command ls -ld ~/.oh*
	builtin echo
	builtin echo oh-my-zsh git state:
	(
		builtin cd $ZSH && builtin echo "HEAD: $(git rev-parse HEAD)" && git remote -v && git status | command grep "[^[:space:]]"
	)
	if [[ $verbose -ge 1 ]]
	then
		(
			builtin cd $ZSH && git reflog --date=default | command grep pull
		)
	fi
	builtin echo
	if [[ -e $ZSH_CUSTOM ]]
	then
		local custom_dir=$ZSH_CUSTOM 
		if [[ -h $custom_dir ]]
		then
			custom_dir=$(builtin cd $custom_dir && pwd -P) 
		fi
		builtin echo "oh-my-zsh custom dir:"
		builtin echo "   $ZSH_CUSTOM ($custom_dir)"
		(
			builtin cd ${custom_dir:h} && command find ${custom_dir:t} -name .git -prune -o -print
		)
		builtin echo
	fi
	if [[ $verbose -ge 1 ]]
	then
		builtin echo "bindkey:"
		builtin bindkey
		builtin echo
		builtin echo "infocmp:"
		command infocmp -L
		builtin echo
	fi
	local zdotdir=${ZDOTDIR:-$HOME} 
	builtin echo "Zsh configuration files:"
	local cfgfile cfgfiles
	cfgfiles=(/etc/zshenv /etc/zprofile /etc/zshrc /etc/zlogin /etc/zlogout $zdotdir/.zshenv $zdotdir/.zprofile $zdotdir/.zshrc $zdotdir/.zlogin $zdotdir/.zlogout ~/.zsh.pre-oh-my-zsh /etc/bashrc /etc/profile ~/.bashrc ~/.profile ~/.bash_profile ~/.bash_logout) 
	command ls -lad $cfgfiles 2>&1
	builtin echo
	if [[ $verbose -ge 1 ]]
	then
		for cfgfile in $cfgfiles
		do
			_omz_diag_dump_echo_file_w_header $cfgfile
		done
	fi
	builtin echo
	builtin echo "Zsh compdump files:"
	local dumpfile dumpfiles
	command ls -lad $zdotdir/.zcompdump*
	dumpfiles=($zdotdir/.zcompdump*(N)) 
	if [[ $verbose -ge 2 ]]
	then
		for dumpfile in $dumpfiles
		do
			_omz_diag_dump_echo_file_w_header $dumpfile
		done
	fi
}
_omz_diag_dump_os_specific_version () {
	local osname osver version_file version_files
	case "$OSTYPE" in
		(darwin*) osname=$(command sw_vers -productName) 
			osver=$(command sw_vers -productVersion) 
			builtin echo "OS Version: $osname $osver build $(sw_vers -buildVersion)" ;;
		(cygwin) command systeminfo | command head -n 4 | command tail -n 2 ;;
	esac
	if builtin which lsb_release > /dev/null
	then
		builtin echo "OS Release: $(command lsb_release -s -d)"
	fi
	version_files=(/etc/*-release(N) /etc/*-version(N) /etc/*_version(N)) 
	for version_file in $version_files
	do
		builtin echo "$version_file:"
		command cat "$version_file"
		builtin echo
	done
}
_omz_git_prompt_info () {
	if ! __git_prompt_git rev-parse --git-dir &> /dev/null || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]
	then
		return 0
	fi
	local ref
	ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null)  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null)  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  || return 0
	local upstream
	if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} ))
	then
		upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null)  && upstream=" -> ${upstream}" 
	fi
	echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref//\%/%%}${upstream//\%/%%}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}
_omz_git_prompt_status () {
	[[ "$(__git_prompt_git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] && return
	local -A prefix_constant_map
	prefix_constant_map=('\?\? ' 'UNTRACKED' 'A  ' 'ADDED' 'M  ' 'MODIFIED' 'MM ' 'MODIFIED' ' M ' 'MODIFIED' 'AM ' 'MODIFIED' ' T ' 'MODIFIED' 'R  ' 'RENAMED' ' D ' 'DELETED' 'D  ' 'DELETED' 'UU ' 'UNMERGED' 'ahead' 'AHEAD' 'behind' 'BEHIND' 'diverged' 'DIVERGED' 'stashed' 'STASHED') 
	local -A constant_prompt_map
	constant_prompt_map=('UNTRACKED' "$ZSH_THEME_GIT_PROMPT_UNTRACKED" 'ADDED' "$ZSH_THEME_GIT_PROMPT_ADDED" 'MODIFIED' "$ZSH_THEME_GIT_PROMPT_MODIFIED" 'RENAMED' "$ZSH_THEME_GIT_PROMPT_RENAMED" 'DELETED' "$ZSH_THEME_GIT_PROMPT_DELETED" 'UNMERGED' "$ZSH_THEME_GIT_PROMPT_UNMERGED" 'AHEAD' "$ZSH_THEME_GIT_PROMPT_AHEAD" 'BEHIND' "$ZSH_THEME_GIT_PROMPT_BEHIND" 'DIVERGED' "$ZSH_THEME_GIT_PROMPT_DIVERGED" 'STASHED' "$ZSH_THEME_GIT_PROMPT_STASHED") 
	local status_constants
	status_constants=(UNTRACKED ADDED MODIFIED RENAMED DELETED STASHED UNMERGED AHEAD BEHIND DIVERGED) 
	local status_text
	status_text="$(__git_prompt_git status --porcelain -b 2> /dev/null)" 
	if [[ $? -eq 128 ]]
	then
		return 1
	fi
	local -A statuses_seen
	if __git_prompt_git rev-parse --verify refs/stash &> /dev/null
	then
		statuses_seen[STASHED]=1 
	fi
	local status_lines
	status_lines=("${(@f)${status_text}}") 
	if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]
	then
		local branch_statuses
		branch_statuses=("${(@s/,/)match}") 
		for branch_status in $branch_statuses
		do
			if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]
			then
				continue
			fi
			local last_parsed_status=$prefix_constant_map[$match[1]] 
			statuses_seen[$last_parsed_status]=$match[2] 
		done
	fi
	for status_prefix in "${(@k)prefix_constant_map}"
	do
		local status_constant="${prefix_constant_map[$status_prefix]}" 
		local status_regex=$'(^|\n)'"$status_prefix" 
		if [[ "$status_text" =~ $status_regex ]]
		then
			statuses_seen[$status_constant]=1 
		fi
	done
	local status_prompt
	for status_constant in $status_constants
	do
		if (( ${+statuses_seen[$status_constant]} ))
		then
			local next_display=$constant_prompt_map[$status_constant] 
			status_prompt="$next_display$status_prompt" 
		fi
	done
	echo $status_prompt
}
_omz_register_handler () {
	setopt localoptions noksharrays unset
	typeset -ga _omz_async_functions
	if [[ -z "$1" ]] || (( ! ${+functions[$1]} )) || (( ${_omz_async_functions[(Ie)$1]} ))
	then
		return
	fi
	_omz_async_functions+=("$1") 
	if (( ! ${precmd_functions[(Ie)_omz_async_request]} )) && (( ${+functions[_omz_async_request]}))
	then
		autoload -Uz add-zsh-hook
		add-zsh-hook precmd _omz_async_request
	fi
}
_omz_source () {
	local context filepath="$1" 
	case "$filepath" in
		(lib/*) context="lib:${filepath:t:r}"  ;;
		(plugins/*) context="plugins:${filepath:h:t}"  ;;
	esac
	local disable_aliases=0 
	zstyle -T ":omz:${context}" aliases || disable_aliases=1 
	local -A aliases_pre galiases_pre
	if (( disable_aliases ))
	then
		aliases_pre=("${(@kv)aliases}") 
		galiases_pre=("${(@kv)galiases}") 
	fi
	if [[ -f "$ZSH_CUSTOM/$filepath" ]]
	then
		source "$ZSH_CUSTOM/$filepath"
	elif [[ -f "$ZSH/$filepath" ]]
	then
		source "$ZSH/$filepath"
	fi
	if (( disable_aliases ))
	then
		if (( #aliases_pre ))
		then
			aliases=("${(@kv)aliases_pre}") 
		else
			(( #aliases )) && unalias "${(@k)aliases}"
		fi
		if (( #galiases_pre ))
		then
			galiases=("${(@kv)galiases_pre}") 
		else
			(( #galiases )) && unalias "${(@k)galiases}"
		fi
	fi
}
_open () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_openstack () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_opkg () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_options () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_options_set () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_options_unset () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_opustools () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_orb () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_orbctl () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_osascript () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_osc () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_other_accounts () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_otool () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
_p11-kit () {
	# undefined
	builtin autoload -XUz /opt/homebrew/share/zsh/site-functions
}
_p9k_all_params_eq () {
	local key
	for key in ${parameters[(I)${~1}]}
	do
		[[ ${(P)key} == $2 ]] || return
	done
}
_p9k_asdf_check_meta () {
	[[ -n $_p9k_asdf_meta_sig ]] || return
	[[ -z $^_p9k_asdf_meta_non_files(#qN) ]] || return
	local -a stat
	if (( $#_p9k_asdf_meta_files ))
	then
		zstat -A stat +mtime -- $_p9k_asdf_meta_files 2> /dev/null || return
	fi
	[[ $_p9k_asdf_meta_sig == $ASDF_CONFIG_FILE$'\0'$ASDF_DATA_DIR$'\0'${(pj:\0:)stat} ]] || return
}
_p9k_asdf_init_meta () {
	local last_sig=$_p9k_asdf_meta_sig 
	{
		local -a files
		local -i legacy_enabled
		_p9k_asdf_plugins=() 
		_p9k_asdf_file_info=() 
		local cfg=${ASDF_CONFIG_FILE:-~/.asdfrc} 
		files+=$cfg 
		if [[ -f $cfg && -r $cfg ]]
		then
			local lines=(${(@M)${(@)${(f)"$(<$cfg)"}%$'\r'}:#[[:space:]]#legacy_version_file[[:space:]]#=*}) 
			if [[ $#lines == 1 && ${${(s:=:)lines[1]}[2]} == [[:space:]]#yes[[:space:]]# ]]
			then
				legacy_enabled=1 
			fi
		fi
		local root=${ASDF_DATA_DIR:-~/.asdf} 
		files+=$root/plugins 
		if [[ -d $root/plugins ]]
		then
			local plugin
			for plugin in $root/plugins/[^[:space:]]##(/N)
			do
				files+=$root/installs/${plugin:t} 
				local -aU installed=($root/installs/${plugin:t}/[^[:space:]]##(/N:t) system) 
				_p9k_asdf_plugins[${plugin:t}]=${(j:|:)${(@b)installed}} 
				(( legacy_enabled )) || continue
				if [[ ! -e $plugin/bin ]]
				then
					files+=$plugin/bin 
				else
					local list_names=$plugin/bin/list-legacy-filenames 
					files+=$list_names 
					if [[ -x $list_names ]]
					then
						local parse=$plugin/bin/parse-legacy-file 
						local -i has_parse=0 
						files+=$parse 
						[[ -x $parse ]] && has_parse=1 
						local name
						for name in ${$($list_names 2>/dev/null)%$'\r'}
						do
							[[ $name == (*/*|.tool-versions) ]] && continue
							_p9k_asdf_file_info[$name]+="${plugin:t} $has_parse " 
						done
					fi
				fi
			done
		fi
		_p9k_asdf_meta_files=($^files(N)) 
		_p9k_asdf_meta_non_files=(${files:|_p9k_asdf_meta_files}) 
		local -a stat
		if (( $#_p9k_asdf_meta_files ))
		then
			zstat -A stat +mtime -- $_p9k_asdf_meta_files 2> /dev/null || return
		fi
		_p9k_asdf_meta_sig=$ASDF_CONFIG_FILE$'\0'$ASDF_DATA_DIR$'\0'${(pj:\0:)stat} 
		_p9k__asdf_dir2files=() 
		_p9k_asdf_file2versions=() 
	} always {
		if (( $? == 0 ))
		then
			_p9k__state_dump_scheduled=1 
			return
		fi
		[[ -n $last_sig ]] && _p9k__state_dump_scheduled=1 
		_p9k_asdf_meta_files=() 
		_p9k_asdf_meta_non_files=() 
		_p9k_asdf_meta_sig= 
		_p9k_asdf_plugins=() 
		_p9k_asdf_file_info=() 
		_p9k__asdf_dir2files=() 
		_p9k_asdf_file2versions=() 
	}
}
_p9k_asdf_parse_version_file () {
	local file=$1 
	local is_legacy=$2 
	local -a stat
	zstat -A stat +mtime $file 2> /dev/null || return
	if (( is_legacy ))
	then
		local plugin has_parse
		for plugin has_parse in $=_p9k_asdf_file_info[$file:t]
		do
			local cached=$_p9k_asdf_file2versions[$plugin:$file] 
			if [[ $cached == $stat[1]:* ]]
			then
				local v=${cached#*:} 
			else
				if (( has_parse ))
				then
					local v=($(${ASDF_DATA_DIR:-~/.asdf}/plugins/$plugin/bin/parse-legacy-file $file 2>/dev/null)) 
				else
					{
						local v=($(<$file)) 
					} 2> /dev/null
				fi
				v=(${v%$'\r'}) 
				v=${v[(r)$_p9k_asdf_plugins[$plugin]]:-$v[1]} 
				_p9k_asdf_file2versions[$plugin:$file]=$stat[1]:"$v" 
				_p9k__state_dump_scheduled=1 
			fi
			[[ -n $v ]] && : ${versions[$plugin]="$v"}
		done
	else
		local cached=$_p9k_asdf_file2versions[:$file] 
		if [[ $cached == $stat[1]:* ]]
		then
			local file_versions=(${(0)${cached#*:}}) 
		else
			local file_versions=() 
			{
				local lines=(${(@)${(@)${(f)"$(<$file)"}%$'\r'}/\#*}) 
			} 2> /dev/null
			local line
			for line in $lines
			do
				local words=($=line) 
				(( $#words > 1 )) || continue
				local installed=$_p9k_asdf_plugins[$words[1]] 
				[[ -n $installed ]] || continue
				file_versions+=($words[1] ${${words:1}[(r)$installed]:-$words[2]}) 
			done
			_p9k_asdf_file2versions[:$file]=$stat[1]:${(pj:\0:)file_versions} 
			_p9k__state_dump_scheduled=1 
		fi
		local plugin version
		for plugin version in $file_versions
		do
			: ${versions[$plugin]=$version}
		done
	fi
	return 0
}
_p9k_background () {
	[[ -n $1 ]] && _p9k__ret="%K{$1}"  || _p9k__ret="%k" 
}
_p9k_build_gap_post () {
	if [[ $1 == 1 ]]
	then
		local kind_l=first kind_u=FIRST 
	else
		local kind_l=newline kind_u=NEWLINE 
	fi
	_p9k_get_icon '' MULTILINE_${kind_u}_PROMPT_GAP_CHAR
	local char=${_p9k__ret:- } 
	_p9k_prompt_length $char
	if (( _p9k__ret != 1 || $#char != 1 ))
	then
		print -rP -- "%F{red}WARNING!%f %BMULTILINE_${kind_u}_PROMPT_GAP_CHAR%b is not one character long. Will use ' '." >&2
		print -rP -- "Either change the value of %BPOWERLEVEL9K_MULTILINE_${kind_u}_PROMPT_GAP_CHAR%b or remove it." >&2
		char=' ' 
	fi
	local style
	_p9k_color prompt_multiline_${kind_l}_prompt_gap BACKGROUND ""
	[[ -n $_p9k__ret ]] && _p9k_background $_p9k__ret
	style+=$_p9k__ret 
	_p9k_color prompt_multiline_${kind_l}_prompt_gap FOREGROUND ""
	[[ -n $_p9k__ret ]] && _p9k_foreground $_p9k__ret
	style+=$_p9k__ret 
	_p9k_escape_style $style
	style=$_p9k__ret 
	local exp=_POWERLEVEL9K_MULTILINE_${kind_u}_PROMPT_GAP_EXPANSION 
	(( $+parameters[$exp] )) && exp=${(P)exp}  || exp='${P9K_GAP}' 
	[[ $char == '.' ]] && local s=','  || local s='.' 
	_p9k__ret=$'${${_p9k__g+\n}:-'$style'${${${_p9k__m:#-*}:+' 
	_p9k__ret+='${${_p9k__'$1'g+${(pl.$((_p9k__m+1)).. .)}}:-' 
	if [[ $exp == '${P9K_GAP}' ]]
	then
		_p9k__ret+='${(pl'$s'$((_p9k__m+1))'$s$s$char$s')}' 
	else
		_p9k__ret+='${${P9K_GAP::=${(pl'$s'$((_p9k__m+1))'$s$s$char$s')}}+}' 
		_p9k__ret+='${:-"'$exp'"}' 
		style=1 
	fi
	_p9k__ret+='}' 
	if (( __p9k_ksh_arrays ))
	then
		_p9k__ret+=$'$_p9k__rprompt${_p9k_t[$((!_p9k__ind))]}}:-\n}' 
	else
		_p9k__ret+=$'$_p9k__rprompt${_p9k_t[$((1+!_p9k__ind))]}}:-\n}' 
	fi
	[[ -n $style ]] && _p9k__ret+='%b%k%f' 
	_p9k__ret+='}' 
}
_p9k_build_test_stats () {
	local code_amount="$2" 
	local tests_amount="$3" 
	local headline="$4" 
	(( code_amount > 0 )) || return
	local -F 2 ratio=$(( 100. * tests_amount / code_amount )) 
	(( ratio >= 75 )) && _p9k_prompt_segment "${1}_GOOD" "cyan" "$_p9k_color1" "$5" 0 '' "$headline: $ratio%%"
	(( ratio >= 50 && ratio < 75 )) && _p9k_prompt_segment "$1_AVG" "yellow" "$_p9k_color1" "$5" 0 '' "$headline: $ratio%%"
	(( ratio < 50 )) && _p9k_prompt_segment "$1_BAD" "red" "$_p9k_color1" "$5" 0 '' "$headline: $ratio%%"
}
_p9k_cache_ephemeral_get () {
	_p9k__cache_key="${(pj:\0:)*}" 
	local v=$_p9k__cache_ephemeral[$_p9k__cache_key] 
	[[ -n $v ]] && _p9k__cache_val=("${(@0)${v[1,-2]}}") 
}
_p9k_cache_ephemeral_set () {
	_p9k__cache_ephemeral[$_p9k__cache_key]="${(pj:\0:)*}0" 
	_p9k__cache_val=("$@") 
}
_p9k_cache_get () {
	_p9k__cache_key="${(pj:\0:)*}" 
	local v=$_p9k_cache[$_p9k__cache_key] 
	[[ -n $v ]] && _p9k__cache_val=("${(@0)${v[1,-2]}}") 
}
_p9k_cache_set () {
	_p9k_cache[$_p9k__cache_key]="${(pj:\0:)*}0" 
	_p9k__cache_val=("$@") 
	_p9k__state_dump_scheduled=1 
}
_p9k_cache_stat_get () {
	local -H stat
	local label=$1 f 
	shift
	_p9k__cache_stat_meta= 
	_p9k__cache_stat_fprint= 
	for f
	do
		if zstat -H stat -- $f 2> /dev/null
		then
			_p9k__cache_stat_meta+="${(q)f} $stat[inode] $stat[mtime] $stat[size] $stat[mode]; " 
		fi
	done
	if _p9k_cache_get $0 $label meta "$@"
	then
		if [[ $_p9k__cache_val[1] == $_p9k__cache_stat_meta ]]
		then
			_p9k__cache_stat_fprint=$_p9k__cache_val[2] 
			local -a key=($0 $label fprint "$@" "$_p9k__cache_stat_fprint") 
			_p9k__cache_fprint_key="${(pj:\0:)key}" 
			shift 2 _p9k__cache_val
			return 0
		else
			local -a key=($0 $label fprint "$@" "$_p9k__cache_val[2]") 
			_p9k__cache_ephemeral[${(pj:\0:)key}]="${(pj:\0:)_p9k__cache_val[3,-1]}0" 
		fi
	fi
	if (( $+commands[md5] ))
	then
		_p9k__cache_stat_fprint="$(md5 -- $* 2>&1)" 
	elif (( $+commands[md5sum] ))
	then
		_p9k__cache_stat_fprint="$(md5sum -b -- $* 2>&1)" 
	else
		return 1
	fi
	local meta_key=$_p9k__cache_key 
	if _p9k_cache_ephemeral_get $0 $label fprint "$@" "$_p9k__cache_stat_fprint"
	then
		_p9k__cache_fprint_key=$_p9k__cache_key 
		_p9k__cache_key=$meta_key 
		_p9k_cache_set "$_p9k__cache_stat_meta" "$_p9k__cache_stat_fprint" "$_p9k__cache_val[@]"
		shift 2 _p9k__cache_val
		return 0
	fi
	_p9k__cache_fprint_key=$_p9k__cache_key 
	_p9k__cache_key=$meta_key 
	return 1
}
_p9k_cache_stat_set () {
	_p9k_cache_set "$_p9k__cache_stat_meta" "$_p9k__cache_stat_fprint" "$@"
	_p9k__cache_key=$_p9k__cache_fprint_key 
	_p9k_cache_ephemeral_set "$@"
}
_p9k_cached_cmd () {
	local cmd=$commands[$3] 
	[[ -n $cmd ]] || return
	if ! _p9k_cache_stat_get $0" ${(q)*}" $2 $cmd
	then
		local out
		if (( $1 ))
		then
			out="$($cmd "${@:4}" 2>&1)" 
		else
			out="$($cmd "${@:4}" 2>/dev/null)" 
		fi
		_p9k_cache_stat_set $(( ! $? )) "$out"
	fi
	(( $_p9k__cache_val[1] )) || return
	_p9k__ret=$_p9k__cache_val[2] 
}
_p9k_can_configure () {
	[[ $1 == '-q' ]] && local -i q=1  || local -i q=0 
	$0_error () {
		(( q )) || print -rP "%1F[ERROR]%f %Bp10k configure%b: $1" >&2
	}
	typeset -g __p9k_cfg_path_o=${POWERLEVEL9K_CONFIG_FILE:=${ZDOTDIR:-~}/.p10k.zsh} 
	typeset -g __p9k_cfg_basename=${__p9k_cfg_path_o:t} 
	typeset -g __p9k_cfg_path=${__p9k_cfg_path_o:A} 
	typeset -g __p9k_cfg_path_u=${${${(q)__p9k_cfg_path_o}/#(#b)${(q)HOME}(|\/*)/'~'$match[1]}//\%/%%} 
	{
		[[ -o multibyte ]] || {
			$0_error "multibyte option is not set"
			return 1
		}
		[[ -e $__p9k_zd ]] || {
			$0_error "$__p9k_zd_u does not exist"
			return 1
		}
		[[ -d $__p9k_zd ]] || {
			$0_error "$__p9k_zd_u is not a directory"
			return 1
		}
		[[ ! -d $__p9k_cfg_path ]] || {
			$0_error "$__p9k_cfg_path_u is a directory"
			return 1
		}
		[[ ! -d $__p9k_zshrc ]] || {
			$0_error "$__p9k_zshrc_u is a directory"
			return 1
		}
		local dir=${__p9k_cfg_path:h} 
		while [[ ! -e $dir && $dir != ${dir:h} ]]
		do
			dir=${dir:h} 
		done
		if [[ ! -d $dir ]]
		then
			$0_error "cannot create $__p9k_cfg_path_u because ${dir//\%/%%} is not a directory"
			return 1
		fi
		if [[ ! -w $dir ]]
		then
			$0_error "cannot create $__p9k_cfg_path_u because ${dir//\%/%%} is readonly"
			return 1
		fi
		[[ ! -e $__p9k_cfg_path || -f $__p9k_cfg_path || -h $__p9k_cfg_path ]] || {
			$0_error "$__p9k_cfg_path_u is a special file"
			return 1
		}
		[[ ! -e $__p9k_zshrc || -f $__p9k_zshrc || -h $__p9k_zshrc ]] || {
			$0_error "$__p9k_zshrc_u a special file"
			return 1
		}
		[[ ! -e $__p9k_zshrc || -r $__p9k_zshrc ]] || {
			$0_error "$__p9k_zshrc_u is not readable"
			return 1
		}
		local style
		for style in lean lean-8colors classic rainbow pure
		do
			[[ -r $__p9k_root_dir/config/p10k-$style.zsh ]] || {
				$0_error "$__p9k_root_dir_u/config/p10k-$style.zsh is not readable"
				return 1
			}
		done
		(( LINES >= __p9k_wizard_lines && COLUMNS >= __p9k_wizard_columns )) || {
			$0_error "terminal size too small; must be at least $__p9k_wizard_columns columns by $__p9k_wizard_lines lines"
			return 1
		}
		[[ -t 0 && -t 1 ]] || {
			$0_error "no TTY"
			return 2
		}
		return 0
	} always {
		unfunction $0_error
	}
}
_p9k_check_visual_mode () {
	[[ ${KEYMAP:-} == vicmd ]] || return 0
	local region=${${REGION_ACTIVE:-0}/2/1} 
	[[ $region != $_p9k__region_active ]] || return 0
	_p9k__region_active=$region 
	__p9k_reset_state=2 
}
_p9k_clear_instant_prompt () {
	if (( $+__p9k_fd_0 ))
	then
		exec <&$__p9k_fd_0 {__p9k_fd_0}>&-
		unset __p9k_fd_0
	fi
	exec >&$__p9k_fd_1 2>&$__p9k_fd_2 {__p9k_fd_1}>&- {__p9k_fd_2}>&-
	unset __p9k_fd_1 __p9k_fd_2
	zshexit_functions=(${zshexit_functions:#_p9k_instant_prompt_cleanup}) 
	if (( _p9k__can_hide_cursor ))
	then
		echoti civis
		_p9k__cursor_hidden=1 
	fi
	if [[ -s $__p9k_instant_prompt_output ]]
	then
		{
			local content
			[[ $_POWERLEVEL9K_INSTANT_PROMPT == verbose ]] && content="$(<$__p9k_instant_prompt_output)" 
			local mark="${(e)${PROMPT_EOL_MARK-%B%S%#%s%b}}" 
			_p9k_prompt_length $mark
			local -i fill=$((COLUMNS > _p9k__ret ? COLUMNS - _p9k__ret : 0)) 
			local cr=$'\r' 
			local sp="${(%):-%b%k%f%s%u$mark${(pl.$fill.. .)}$cr%b%k%f%s%u%E}" 
			if (( _z4h_can_save_restore_screen == 1 && __p9k_instant_prompt_sourced >= 35 ))
			then
				-z4h-restore-screen
				unset _z4h_saved_screen
			fi
			print -rn -- $terminfo[rc]${(%):-%b%k%f%s%u}$terminfo[ed]
			local unexpected=${${${(S)content//$'\e[?'<->'c'}//$'\e['<->' q'}//$'\e'[^$'\a\e']#($'\a'|$'\e\\')} 
			if [[ -n $unexpected ]]
			then
				local omz1='[Oh My Zsh] Would you like to update? [Y/n]: ' 
				local omz2='Updating Oh My Zsh' 
				local omz3='https://shop.planetargon.com/collections/oh-my-zsh' 
				local omz4='There was an error updating. Try again later?' 
				if [[ $unexpected != ($omz1|)$omz2*($omz3|$omz4)[^$'\n']#($'\n'|) ]]
				then
					echo -E - ""
					echo -E - "${(%):-[%3FWARNING%f]: Console output during zsh initialization detected.}"
					echo -E - ""
					echo -E - "${(%):-When using Powerlevel10k with instant prompt, console output during zsh}"
					echo -E - "${(%):-initialization may indicate issues.}"
					echo -E - ""
					echo -E - "${(%):-You can:}"
					echo -E - ""
					echo -E - "${(%):-  - %BRecommended%b: Change %B$__p9k_zshrc_u%b so that it does not perform console I/O}"
					echo -E - "${(%):-    after the instant prompt preamble. See the link below for details.}"
					echo -E - ""
					echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
					echo -E - "${(%):-    * Zsh will start %Bquickly%b and prompt will update %Bsmoothly%b.}"
					echo -E - ""
					echo -E - "${(%):-  - Suppress this warning either by running %Bp10k configure%b or by manually}"
					echo -E - "${(%):-    defining the following parameter:}"
					echo -E - ""
					echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=quiet}"
					echo -E - ""
					echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
					echo -E - "${(%):-    * Zsh will start %Bquickly%b but prompt will %Bjump down%b after initialization.}"
					echo -E - ""
					echo -E - "${(%):-  - Disable instant prompt either by running %Bp10k configure%b or by manually}"
					echo -E - "${(%):-    defining the following parameter:}"
					echo -E - ""
					echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=off}"
					echo -E - ""
					echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
					echo -E - "${(%):-    * Zsh will start %Bslowly%b.}"
					echo -E - ""
					echo -E - "${(%):-  - Do nothing.}"
					echo -E - ""
					echo -E - "${(%):-    * You %Bwill%b see this error message every time you start zsh.}"
					echo -E - "${(%):-    * Zsh will start %Bquickly%b but prompt will %Bjump down%b after initialization.}"
					echo -E - ""
					echo -E - "${(%):-For details, see:}"
					if (( _p9k_term_has_href ))
					then
						echo - "${(%):-\e]8;;https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt\ahttps://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt\e]8;;\a}"
					else
						echo - "${(%):-https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt}"
					fi
					echo -E - ""
					echo - "${(%):-%3F-- console output produced during zsh initialization follows --%f}"
					echo -E - ""
				fi
			fi
			command cat -- $__p9k_instant_prompt_output
			echo -nE - $sp
			zf_rm -f -- $__p9k_instant_prompt_output
		} 2> /dev/null
	else
		zf_rm -f -- $__p9k_instant_prompt_output 2> /dev/null
		if (( _z4h_can_save_restore_screen == 1 && __p9k_instant_prompt_sourced >= 35 ))
		then
			-z4h-restore-screen
			unset _z4h_saved_screen
		fi
		print -rn -- $terminfo[rc]${(%):-%b%k%f%s%u}$terminfo[ed]
	fi
	prompt_opts=(percent subst sp cr) 
	if [[ $_POWERLEVEL9K_DISABLE_INSTANT_PROMPT == 0 && $__p9k_instant_prompt_active == 2 ]]
	then
		echo -E - "" >&2
		echo -E - "${(%):-[%1FERROR%f]: When using Powerlevel10k with instant prompt, %Bprompt_cr%b must be unset.}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-You can:}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-  - %BRecommended%b: call %Bp10k finalize%b at the end of %B$__p9k_zshrc_u%b.}" >&2
		echo -E - "${(%):-    You can do this by running the following command:}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-      %2Fecho%f %3F'(( ! \${+functions[p10k]\} )) || p10k finalize'%f >>! $__p9k_zshrc_u}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-    * You %Bwill not%b see this error message again.}" >&2
		echo -E - "${(%):-    * Zsh will start %Bquickly%b and %Bwithout%b prompt flickering.}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-  - Find where %Bprompt_cr%b option gets sets in your zsh configs and stop setting it.}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-    * You %Bwill not%b see this error message again.}" >&2
		echo -E - "${(%):-    * Zsh will start %Bquickly%b and %Bwithout%b prompt flickering.}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-  - Disable instant prompt either by running %Bp10k configure%b or by manually}" >&2
		echo -E - "${(%):-    defining the following parameter:}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=off}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-    * You %Bwill not%b see this error message again.}" >&2
		echo -E - "${(%):-    * Zsh will start %Bslowly%b.}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-  - Do nothing.}" >&2
		echo -E - "" >&2
		echo -E - "${(%):-    * You %Bwill%b see this error message every time you start zsh.}" >&2
		echo -E - "${(%):-    * Zsh will start %Bquckly%b but %Bwith%b prompt flickering.}" >&2
		echo -E - "" >&2
	fi
}
_p9k_color () {
	local key="_p9k_color ${(pj:\0:)*}" 
	_p9k__ret=$_p9k_cache[$key] 
	if [[ -n $_p9k__ret ]]
	then
		_p9k__ret[-1,-1]='' 
	else
		_p9k_param "$@"
		_p9k_translate_color $_p9k__ret
		_p9k_cache[$key]=${_p9k__ret}. 
	fi
}
_p9k_custom_prompt () {
	local segment_name=${1:u} 
	local command=_POWERLEVEL9K_CUSTOM_${segment_name} 
	command=${(P)command} 
	local parts=("${(@z)command}") 
	local cmd="${(Q)parts[1]}" 
	(( $+functions[$cmd] || $+commands[$cmd] )) || return
	local content="$(eval $command)" 
	[[ -n $content ]] || return
	_p9k_prompt_segment "prompt_custom_$1" $_p9k_color2 $_p9k_color1 "CUSTOM_${segment_name}_ICON" 0 '' "$content"
}
_p9k_declare () {
	local -i set=$+parameters[$2] 
	(( ARGC > 2 || set )) || return 0
	case $1 in
		(-b) if (( set ))
			then
				[[ ${(P)2} == true ]] && typeset -gi _$2=1 || typeset -gi _$2=0
			else
				typeset -gi _$2=$3
			fi ;;
		(-a) local -a v=("${(@P)2}") 
			if (( set ))
			then
				eval "typeset -ga _${(q)2}=(${(@qq)v})"
			else
				if [[ $3 != '--' ]]
				then
					echo "internal error in _p9k_declare " "${(qqq)@}" >&2
				fi
				eval "typeset -ga _${(q)2}=(${(@qq)*[4,-1]})"
			fi ;;
		(-i) (( set )) && typeset -gi _$2=$2 || typeset -gi _$2=$3 ;;
		(-F) (( set )) && typeset -gF _$2=$2 || typeset -gF _$2=$3 ;;
		(-s) (( set )) && typeset -g _$2=${(P)2} || typeset -g _$2=$3 ;;
		(-e) if (( set ))
			then
				local v=${(P)2} 
				typeset -g _$2=${(g::)v}
			else
				typeset -g _$2=${(g::)3}
			fi ;;
		(*) echo "internal error in _p9k_declare " "${(qqq)@}" >&2 ;;
	esac
}
_p9k_deinit () {
	(( $+functions[_p9k_preinit] )) && unfunction _p9k_preinit
	(( $+functions[gitstatus_stop_p9k_] )) && gitstatus_stop_p9k_ POWERLEVEL9K
	_p9k_worker_stop
	if (( _p9k__state_dump_fd ))
	then
		zle -F $_p9k__state_dump_fd
		exec {_p9k__state_dump_fd}>&-
	fi
	if (( _p9k__restore_prompt_fd ))
	then
		zle -F $_p9k__restore_prompt_fd
		exec {_p9k__restore_prompt_fd}>&-
	fi
	if (( _p9k__redraw_fd ))
	then
		zle -F $_p9k__redraw_fd
		exec {_p9k__redraw_fd}>&-
	fi
	(( $+_p9k__iterm2_precmd )) && functions[iterm2_precmd]=$_p9k__iterm2_precmd 
	(( $+_p9k__iterm2_decorate_prompt )) && functions[iterm2_decorate_prompt]=$_p9k__iterm2_decorate_prompt 
	unset -m '(_POWERLEVEL9K_|P9K_|_p9k_)*~(P9K_SSH|P9K_TOOLBOX_NAME|P9K_TTY|_P9K_TTY)'
	[[ -n $__p9k_locale ]] || unset __p9k_locale
}
_p9k_delete_instant_prompt () {
	local user=${(%):-%n} 
	local root_dir=${__p9k_dump_file:h} 
	zf_rm -f -- $root_dir/p10k-instant-prompt-$user.zsh{,.zwc} ${root_dir}/p10k-$user/prompt-*(N) 2> /dev/null
}
_p9k_deschedule_redraw () {
	(( _p9k__redraw_fd )) || return
	zle -F $_p9k__redraw_fd
	exec {_p9k__redraw_fd}>&-
	_p9k__redraw_fd=0 
}
_p9k_display_segment () {
	[[ $_p9k__display_v[$1] == $3 ]] && return
	_p9k__display_v[$1]=$3 
	[[ $3 == hide ]] && typeset -g $2= || unset $2
	__p9k_reset_state=2 
}
_p9k_do_dump () {
	eval "$__p9k_intro"
	zle -F $1
	exec {1}>&-
	(( _p9k__state_dump_fd )) || return
	if (( ! _p9k__instant_prompt_disabled ))
	then
		_p9k__instant_prompt_sig=$_p9k__cwd:$P9K_SSH:${(%):-%#} 
		_p9k_set_instant_prompt
		_p9k_dump_instant_prompt
		_p9k_dumped_instant_prompt_sigs[$_p9k__instant_prompt_sig]=1 
	fi
	_p9k_dump_state
	_p9k__state_dump_scheduled=0 
	_p9k__state_dump_fd=0 
}
_p9k_do_nothing () {
	true
}
_p9k_dump_instant_prompt () {
	local user=${(%):-%n} 
	local root_dir=${__p9k_dump_file:h} 
	local prompt_dir=${root_dir}/p10k-$user 
	local root_file=$root_dir/p10k-instant-prompt-$user.zsh 
	local prompt_file=$prompt_dir/prompt-${#_p9k__cwd} 
	[[ -d $prompt_dir ]] || mkdir -p $prompt_dir || return
	[[ -w $root_dir && -w $prompt_dir ]] || return
	if [[ ! -e $root_file ]]
	then
		local tmp=$root_file.tmp.$$ 
		local -i fd
		sysopen -a -m 600 -o creat,trunc -u fd -- $tmp || return
		{
			[[ $TERM == (screen*|tmux*) ]] && local screen='-n'  || local screen='-z' 
			local -a display_v=("${_p9k__display_v[@]}") 
			local -i i
			for ((i = 6; i <= $#display_v; i+=2)) do
				display_v[i]=show 
			done
			display_v[2]=hide 
			display_v[4]=hide 
			local gitstatus_dir=${${_POWERLEVEL9K_GITSTATUS_DIR:A}:-${__p9k_root_dir}/gitstatus} 
			local gitstatus_header
			if [[ -r $gitstatus_dir/install.info ]]
			then
				IFS= read -r gitstatus_header < $gitstatus_dir/install.info || return
			fi
			print -r -- '[[ -t 0 && -t 1 && -t 2 && -o interactive && -o zle && -o no_xtrace ]] &&
  ! (( ${+__p9k_instant_prompt_disabled} || ZSH_SUBSHELL || ${+ZSH_SCRIPT} || ${+ZSH_EXECUTION_STRING} )) || return 0' >&$fd
			print -r -- "() {
  $__p9k_intro_no_locale
  typeset -gi __p9k_instant_prompt_disabled=1
  [[ \$ZSH_VERSION == ${(q)ZSH_VERSION} && \$ZSH_PATCHLEVEL == ${(q)ZSH_PATCHLEVEL} &&
     $screen \${(M)TERM:#(screen*|tmux*)} &&
     \${#\${(M)VTE_VERSION:#(<1-4602>|4801)}} == ${#${(M)VTE_VERSION:#(<1-4602>|4801)}} &&
     \$POWERLEVEL9K_DISABLE_INSTANT_PROMPT != 'true' &&
     \$POWERLEVEL9K_INSTANT_PROMPT != 'off' ]] || return
  typeset -g __p9k_instant_prompt_param_sig=${(q+)_p9k__param_sig}
  local gitstatus_dir=${(q)gitstatus_dir}
  local gitstatus_header=${(q)gitstatus_header}
  local -i ZLE_RPROMPT_INDENT=${ZLE_RPROMPT_INDENT:-1}
  local PROMPT_EOL_MARK=${(q)PROMPT_EOL_MARK-%B%S%#%s%b}
  [[ -n \$SSH_CLIENT || -n \$SSH_TTY || -n \$SSH_CONNECTION ]] && local ssh=1 || local ssh=0
  local cr=\$'\r' lf=\$'\n' esc=\$'\e[' rs=$'\x1e' us=$'\x1f'
  local -i height=${_POWERLEVEL9K_INSTANT_PROMPT_COMMAND_LINES-1}
  local prompt_dir=${(q)prompt_dir}" >&$fd
			if (( ! ${+_POWERLEVEL9K_INSTANT_PROMPT_COMMAND_LINES} ))
			then
				print -r -- '
  (( _z4h_can_save_restore_screen == 1 )) && height=0' >&$fd
			fi
			print -r -- '
  local real_gitstatus_header
  if [[ -r $gitstatus_dir/install.info ]]; then
    IFS= read -r real_gitstatus_header <$gitstatus_dir/install.info || real_gitstatus_header=borked
  fi
  [[ $real_gitstatus_header == $gitstatus_header ]] || return
  zmodload zsh/langinfo zsh/terminfo zsh/system || return
  if [[ $langinfo[CODESET] != (utf|UTF)(-|)8 ]]; then
    local loc_cmd=$commands[locale]
    [[ -z $loc_cmd ]] && loc_cmd='${(q)commands[locale]}'
    if [[ -x $loc_cmd ]]; then
      local -a locs
      if locs=(${(@M)$(locale -a 2>/dev/null):#*.(utf|UTF)(-|)8}) && (( $#locs )); then
        local loc=${locs[(r)(#i)C.UTF(-|)8]:-${locs[(r)(#i)en_US.UTF(-|)8]:-$locs[1]}}
        [[ -n $LC_ALL ]] && local LC_ALL=$loc || local LC_CTYPE=$loc
      fi
    fi
  fi
  (( terminfo[colors] == '${terminfo[colors]:-0}' )) || return
  (( $+terminfo[cuu] && $+terminfo[cuf] && $+terminfo[ed] && $+terminfo[sc] && $+terminfo[rc] )) || return
  local pwd=${(%):-%/}
  [[ $pwd == /* ]] || return
  local prompt_file=$prompt_dir/prompt-${#pwd}
  local key=$pwd:$ssh:${(%):-%#}
  local content
  if [[ ! -e $prompt_file ]]; then
    typeset -gi __p9k_instant_prompt_sourced='$__p9k_instant_prompt_version'
    return 1
  fi
  { content="$(<$prompt_file)" } 2>/dev/null || return
  local tail=${content##*$rs$key$us}
  if (( ${#tail} == ${#content} )); then
    typeset -gi __p9k_instant_prompt_sourced='$__p9k_instant_prompt_version'
    return 1
  fi
  local _p9k__ipe
  local P9K_PROMPT=instant
  if [[ -z $P9K_TTY || $P9K_TTY == old && -n ${_P9K_TTY:#$TTY} ]]; then' >&$fd
			if (( _POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS < 0 ))
			then
				print -r -- '    typeset -gx P9K_TTY=new' >&$fd
			else
				print -r -- '
    typeset -gx P9K_TTY=old
    zmodload -F zsh/stat b:zstat || return
    zmodload zsh/datetime || return
    local -a stat
    if zstat -A stat +ctime -- $TTY 2>/dev/null &&
      (( EPOCHREALTIME - stat[1] < '$_POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS' )); then
      P9K_TTY=new
    fi' >&$fd
			fi
			print -r -- '  fi
  typeset -gx _P9K_TTY=$TTY
  local -i _p9k__empty_line_i=3 _p9k__ruler_i=3
  local -A _p9k_display_k=('${(j: :)${(@q)${(kv)_p9k_display_k}}}')
  local -a _p9k__display_v=('${(j: :)${(@q)display_v}}')
  function p10k() {
    '$__p9k_intro'
    [[ $1 == display ]] || return
    shift
    local -i k dump
    local opt prev new pair list name var
    while getopts ":ha" opt; do
      case $opt in
        a) dump=1;;
        h) return 0;;
        ?) return 1;;
      esac
    done
    if (( dump )); then
      reply=()
      shift $((OPTIND-1))
      (( ARGC )) || set -- "*"
      for opt; do
        for k in ${(u@)_p9k_display_k[(I)$opt]:/(#m)*/$_p9k_display_k[$MATCH]}; do
          reply+=($_p9k__display_v[k,k+1])
        done
      done
      return 0
    fi
    for opt in "${@:$OPTIND}"; do
      pair=(${(s:=:)opt})
      list=(${(s:,:)${pair[2]}})
      if [[ ${(b)pair[1]} == $pair[1] ]]; then
        local ks=($_p9k_display_k[$pair[1]])
      else
        local ks=(${(u@)_p9k_display_k[(I)$pair[1]]:/(#m)*/$_p9k_display_k[$MATCH]})
      fi
      for k in $ks; do
        if (( $#list == 1 )); then
          [[ $_p9k__display_v[k+1] == $list[1] ]] && continue
          new=$list[1]
        else
          new=${list[list[(I)$_p9k__display_v[k+1]]+1]:-$list[1]}
          [[ $_p9k__display_v[k+1] == $new ]] && continue
        fi
        _p9k__display_v[k+1]=$new
        name=$_p9k__display_v[k]
        if [[ $name == (empty_line|ruler) ]]; then
          var=_p9k__${name}_i
          [[ $new == hide ]] && typeset -gi $var=3 || unset $var
        elif [[ $name == (#b)(<->)(*) ]]; then
          var=_p9k__${match[1]}${${${${match[2]//\/}/#left/l}/#right/r}/#gap/g}
          [[ $new == hide ]] && typeset -g $var= || unset $var
        fi
      done
    done
  }' >&$fd
			if (( _POWERLEVEL9K_PROMPT_ADD_NEWLINE ))
			then
				print -r -- '  [[ $P9K_TTY == old ]] && { unset _p9k__empty_line_i; _p9k__display_v[2]=print }' >&$fd
			fi
			if (( _POWERLEVEL9K_SHOW_RULER ))
			then
				print -r -- '[[ $P9K_TTY == old ]] && { unset _p9k__ruler_i; _p9k__display_v[4]=print }' >&$fd
			fi
			if (( $+functions[p10k-on-init] ))
			then
				print -r -- '
  p10k-on-init() { '$functions[p10k-on-init]' }' >&$fd
			fi
			if (( $+functions[p10k-on-pre-prompt] ))
			then
				print -r -- '
  p10k-on-pre-prompt() { '$functions[p10k-on-pre-prompt]' }' >&$fd
			fi
			if (( $+functions[p10k-on-post-prompt] ))
			then
				print -r -- '
  p10k-on-post-prompt() { '$functions[p10k-on-post-prompt]' }' >&$fd
			fi
			if (( $+functions[p10k-on-post-widget] ))
			then
				print -r -- '
  p10k-on-post-widget() { '$functions[p10k-on-post-widget]' }' >&$fd
			fi
			if (( $+functions[p10k-on-init] ))
			then
				print -r -- '
  p10k-on-init' >&$fd
			fi
			local pat idx var
			for pat idx var in $_p9k_show_on_command
			do
				print -r -- "
  local $var=
  _p9k__display_v[$idx]=hide" >&$fd
			done
			if (( $+functions[p10k-on-pre-prompt] ))
			then
				print -r -- '
  p10k-on-pre-prompt' >&$fd
			fi
			if (( $+functions[p10k-on-init] ))
			then
				print -r -- '
  unfunction p10k-on-init' >&$fd
			fi
			if (( $+functions[p10k-on-pre-prompt] ))
			then
				print -r -- '
  unfunction p10k-on-pre-prompt' >&$fd
			fi
			if (( $+functions[p10k-on-post-prompt] ))
			then
				print -r -- '
  unfunction p10k-on-post-prompt' >&$fd
			fi
			if (( $+functions[p10k-on-post-widget] ))
			then
				print -r -- '
  unfunction p10k-on-post-widget' >&$fd
			fi
			print -r -- '
  () {
'$functions[_p9k_init_toolbox]'
  }
  trap "unset -m _p9k__\*; unfunction p10k" EXIT
  local -a _p9k_t=("${(@ps:$us:)${tail%%$rs*}}")
  if [[ $+VTE_VERSION == 1 || $TERM_PROGRAM == Hyper ]] && (( $+commands[stty] )); then
    if [[ $TERM_PROGRAM == Hyper ]]; then
      local bad_lines=40 bad_columns=100
    else
      local bad_lines=24 bad_columns=80
    fi
    if (( LINES == bad_lines && COLUMNS == bad_columns )); then
      zmodload -F zsh/stat b:zstat || return
      zmodload zsh/datetime || return
      local -a tty_ctime
      if ! zstat -A tty_ctime +ctime -- $TTY 2>/dev/null || (( tty_ctime[1] + 2 > EPOCHREALTIME )); then
        local -F deadline=$((EPOCHREALTIME+0.025))
        local tty_size
        while true; do
          if (( EPOCHREALTIME > deadline )) || ! tty_size="$(command stty size 2>/dev/null)" || [[ $tty_size != <->" "<-> ]]; then
            (( $+_p9k__ruler_i )) || local -i _p9k__ruler_i=1
            local _p9k__g= _p9k__'$#_p9k_line_segments_right'r= _p9k__'$#_p9k_line_segments_right'r_frame=
            break
          fi
          if [[ $tty_size != "$bad_lines $bad_columns" ]]; then
            local lines_columns=(${=tty_size})
            local LINES=$lines_columns[1]
            local COLUMNS=$lines_columns[2]
            break
          fi
        done
      fi
    fi
  fi' >&$fd
			(( __p9k_ksh_arrays )) && print -r -- '  setopt ksh_arrays' >&$fd
			(( __p9k_sh_glob )) && print -r -- '  setopt sh_glob' >&$fd
			print -r -- '  typeset -ga __p9k_used_instant_prompt=("${(@e)_p9k_t[-3,-1]}")' >&$fd
			(( __p9k_ksh_arrays )) && print -r -- '  unsetopt ksh_arrays' >&$fd
			(( __p9k_sh_glob )) && print -r -- '  unsetopt sh_glob' >&$fd
			print -r -- '
  local -i prompt_height=${#${__p9k_used_instant_prompt[1]//[^$lf]}}
  (( height += prompt_height ))
  local _p9k__ret
  function _p9k_prompt_length() {
    local -i COLUMNS=1024
    local -i x y=${#1} m
    if (( y )); then
      while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
        x=y
        (( y *= 2 ))
      done
      while (( y > x + 1 )); do
        (( m = x + (y - x) / 2 ))
        (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
      done
    fi
    typeset -g _p9k__ret=$x
  }
  local out=${(%):-%b%k%f%s%u}
  if [[ $P9K_TTY == old && ( $+VTE_VERSION == 0 && $TERM_PROGRAM != Hyper || $+_p9k__g == 0 ) ]]; then
    local mark=${(e)PROMPT_EOL_MARK}
    [[ $mark == "%B%S%#%s%b" ]] && _p9k__ret=1 || _p9k_prompt_length $mark
    local -i fill=$((COLUMNS > _p9k__ret ? COLUMNS - _p9k__ret : 0))
    out+="${(%):-$mark${(pl.$fill.. .)}$cr%b%k%f%s%u%E}"
  else
    out+="${(%):-$cr%E}"
  fi
  if (( _z4h_can_save_restore_screen != 1 )); then
    (( height )) && out+="${(pl.$height..$lf.)}$esc${height}A"
    out+="$terminfo[sc]"
  fi
  out+=${(%):-"$__p9k_used_instant_prompt[1]$__p9k_used_instant_prompt[2]"}
  if [[ -n $__p9k_used_instant_prompt[3] ]]; then
    _p9k_prompt_length "$__p9k_used_instant_prompt[2]"
    local -i left_len=_p9k__ret
    _p9k_prompt_length "$__p9k_used_instant_prompt[3]"
    if (( _p9k__ret )); then
      local -i gap=$((COLUMNS - left_len - _p9k__ret - ZLE_RPROMPT_INDENT))
      if (( gap >= 40 )); then
        out+="${(pl.$gap.. .)}${(%):-${__p9k_used_instant_prompt[3]}%b%k%f%s%u}$cr$esc${left_len}C"
      fi
    fi
  fi
  if (( _z4h_can_save_restore_screen == 1 )); then
    if (( height )); then
      out+="$cr${(pl:$((height-prompt_height))::\n:)}$esc${height}A$terminfo[sc]$out"
    else
      out+="$cr${(pl:$((height-prompt_height))::\n:)}$terminfo[sc]$out"
    fi
  fi
  if [[ -n "$TMPDIR" && ( ( -d "$TMPDIR" && -w "$TMPDIR" ) || ! ( -d /tmp && -w /tmp ) ) ]]; then
    local tmpdir=$TMPDIR
  else
    local tmpdir=/tmp
  fi
  typeset -g __p9k_instant_prompt_output=$tmpdir/p10k-instant-prompt-output-${(%):-%n}-$$
  { : > $__p9k_instant_prompt_output } || return
  print -rn -- "${out}${esc}?2004h" || return
  if (( $+commands[stty] )); then
    command stty -icanon 2>/dev/null
  fi
  local fd_null
  sysopen -ru fd_null /dev/null || return
  exec {__p9k_fd_0}<&0 {__p9k_fd_1}>&1 {__p9k_fd_2}>&2 0<&$fd_null 1>$__p9k_instant_prompt_output
  exec 2>&1 {fd_null}>&-
  typeset -gi __p9k_instant_prompt_active=1
  if (( _z4h_can_save_restore_screen == 1 )); then
    typeset -g _z4h_saved_screen
    -z4h-save-screen
  fi
  typeset -g __p9k_instant_prompt_dump_file=${XDG_CACHE_HOME:-~/.cache}/p10k-dump-${(%):-%n}.zsh
  if builtin source $__p9k_instant_prompt_dump_file 2>/dev/null && (( $+functions[_p9k_preinit] )); then
    _p9k_preinit
  fi
  function _p9k_instant_prompt_cleanup() {
    (( ZSH_SUBSHELL == 0 && ${+__p9k_instant_prompt_active} )) || return 0
    '$__p9k_intro_no_locale'
    unset __p9k_instant_prompt_active
    exec 0<&$__p9k_fd_0 1>&$__p9k_fd_1 2>&$__p9k_fd_2 {__p9k_fd_0}>&- {__p9k_fd_1}>&- {__p9k_fd_2}>&-
    unset __p9k_fd_0 __p9k_fd_1 __p9k_fd_2
    typeset -gi __p9k_instant_prompt_erased=1
    if (( _z4h_can_save_restore_screen == 1 && __p9k_instant_prompt_sourced >= 35 )); then
      -z4h-restore-screen
      unset _z4h_saved_screen
    fi
    print -rn -- $terminfo[rc]${(%):-%b%k%f%s%u}$terminfo[ed]
    if [[ -s $__p9k_instant_prompt_output ]]; then
      command cat $__p9k_instant_prompt_output 2>/dev/null
      if (( $1 )); then
        local _p9k__ret mark="${(e)${PROMPT_EOL_MARK-%B%S%#%s%b}}"
        _p9k_prompt_length $mark
        local -i fill=$((COLUMNS > _p9k__ret ? COLUMNS - _p9k__ret : 0))
        echo -nE - "${(%):-%b%k%f%s%u$mark${(pl.$fill.. .)}$cr%b%k%f%s%u%E}"
      fi
    fi
    zshexit_functions=(${zshexit_functions:#_p9k_instant_prompt_cleanup})
    zmodload -F zsh/files b:zf_rm || return
    local user=${(%):-%n}
    local root_dir=${__p9k_instant_prompt_dump_file:h}
    zf_rm -f -- $__p9k_instant_prompt_output $__p9k_instant_prompt_dump_file{,.zwc} $root_dir/p10k-instant-prompt-$user.zsh{,.zwc} $root_dir/p10k-$user/prompt-*(N) 2>/dev/null
  }
  function _p9k_instant_prompt_precmd_first() {
    '$__p9k_intro'
    function _p9k_instant_prompt_sched_last() {
      (( ${+__p9k_instant_prompt_active} )) || return 0
      _p9k_instant_prompt_cleanup 1
      setopt no_local_options prompt_cr prompt_sp
    }
    zmodload zsh/sched
    sched +0 _p9k_instant_prompt_sched_last
    precmd_functions=(${(@)precmd_functions:#_p9k_instant_prompt_precmd_first})
  }
  zshexit_functions=(_p9k_instant_prompt_cleanup $zshexit_functions)
  precmd_functions=(_p9k_instant_prompt_precmd_first $precmd_functions)
  DISABLE_UPDATE_PROMPT=true
} && unsetopt prompt_cr prompt_sp && typeset -gi __p9k_instant_prompt_sourced='$__p9k_instant_prompt_version' ||
  typeset -gi __p9k_instant_prompt_sourced=${__p9k_instant_prompt_sourced:-0}' >&$fd
		} always {
			exec {fd}>&-
		}
		{
			(( ! $? )) || return
			zf_rm -f -- $root_file.zwc || return
			zf_mv -f -- $tmp $root_file || return
			zcompile -R -- $tmp.zwc $root_file || return
			zf_mv -f -- $tmp.zwc $root_file.zwc || return
		} always {
			(( $? )) && zf_rm -f -- $tmp $tmp.zwc 2> /dev/null
		}
	fi
	local tmp=$prompt_file.tmp.$$ 
	zf_mv -f -- $prompt_file $tmp 2> /dev/null
	if [[ "$(<$tmp)" == *$'\x1e'$_p9k__instant_prompt_sig$'\x1f'* ]] 2> /dev/null
	then
		echo -n > $tmp || return
	fi
	local -i fd
	sysopen -a -m 600 -o creat -u fd -- $tmp || return
	{
		{
			print -rnu $fd -- $'\x1e'$_p9k__instant_prompt_sig$'\x1f'${(pj:\x1f:)_p9k_t}$'\x1f'$_p9k__instant_prompt || return
		} always {
			exec {fd}>&-
		}
		zf_mv -f -- $tmp $prompt_file || return
	} always {
		(( $? )) && zf_rm -f -- $tmp 2> /dev/null
	}
}
_p9k_dump_state () {
	local dir=${__p9k_dump_file:h} 
	[[ -d $dir ]] || mkdir -p -- $dir || return
	[[ -w $dir ]] || return
	local tmp=$__p9k_dump_file.tmp.$$ 
	local -i fd
	sysopen -a -m 600 -o creat,trunc -u fd -- $tmp || return
	{
		{
			typeset -g __p9k_cached_param_pat=$_p9k__param_pat 
			typeset -g __p9k_cached_param_sig=$_p9k__param_sig 
			typeset -pm __p9k_cached_param_pat __p9k_cached_param_sig >&$fd || return
			unset __p9k_cached_param_pat __p9k_cached_param_sig
			(( $+_p9k_preinit )) && {
				print -r -- $_p9k_preinit >&$fd || return
			}
			print -r -- '_p9k_restore_state_impl() {' >&$fd || return
			typeset -pm '_POWERLEVEL9K_*|_p9k_[^_]*|icons' >&$fd || return
			print -r -- '}' >&$fd || return
		} always {
			exec {fd}>&-
		}
		zf_rm -f -- $__p9k_dump_file.zwc || return
		zf_mv -f -- $tmp $__p9k_dump_file || return
		zcompile -R -- $tmp.zwc $__p9k_dump_file || return
		zf_mv -f -- $tmp.zwc $__p9k_dump_file.zwc || return
	} always {
		(( $? )) && zf_rm -f -- $tmp $tmp.zwc 2> /dev/null
	}
}
_p9k_escape () {
	[[ $1 == *["~!#\`\$^&*()\\\"'<>?{}[]"]* ]] && _p9k__ret="\${(Q)\${:-${(qqq)${(q)1}}}}"  || _p9k__ret=$1 
}
_p9k_escape_style () {
	[[ $1 == *'}'* ]] && _p9k__ret='${:-"'$1'"}'  || _p9k__ret=$1 
}
_p9k_fetch_cwd () {
	if [[ $PWD == /* && $PWD -ef . ]]
	then
		_p9k__cwd=$PWD 
	else
		_p9k__cwd=${${${:-.}:a}:-.} 
	fi
	_p9k__cwd_a=${${_p9k__cwd:A}:-.} 
	case $_p9k__cwd in
		(/ | .) _p9k__parent_dirs=() 
			_p9k__parent_mtimes=() 
			_p9k__parent_mtimes_i=() 
			_p9k__parent_mtimes_s= 
			return ;;
		(~ | ~/*) local parent=${${${:-~/..}:a}%/}/ 
			local parts=(${(s./.)_p9k__cwd#$parent})  ;;
		(*) local parent=/ 
			local parts=(${(s./.)_p9k__cwd})  ;;
	esac
	local MATCH
	_p9k__parent_dirs=(${(@)${:-{$#parts..1}}/(#m)*/$parent${(pj./.)parts[1,MATCH]}}) 
	if ! zstat -A _p9k__parent_mtimes +mtime -- $_p9k__parent_dirs 2> /dev/null
	then
		_p9k__parent_mtimes=(${(@)parts/*/-1}) 
	fi
	_p9k__parent_mtimes_i=(${(@)${:-{1..$#parts}}/(#m)*/$MATCH:$_p9k__parent_mtimes[MATCH]}) 
	_p9k__parent_mtimes_s="$_p9k__parent_mtimes_i" 
}
_p9k_fetch_nordvpn_status () {
	setopt err_return no_multi_byte
	local REPLY
	zsocket /run/nordvpn/nordvpnd.sock
	local -i fd=REPLY 
	{
		print -nu $fd 'PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n\0\0\0\4\1\0\0\0\0\0\0;\1\4\0\0\0\1\203\206E\213b\270\327\2762\322z\230\326j\246A\206\240\344\35\23\235\t_\213\35u\320b\r&=LMedz\212\232\312\310\264\307`+\262\332\340@\2te\206M\2035\5\261\37\0\0\5\0\1\0\0\0\1\0\0\0\0\0\0\0\25\1\4\0\0\0\3\203\206E\215b\270\327\2762\322z\230\334\221\246\324\177\302\301\300\277\0\0\5\0\1\0\0\0\3\0\0\0\0\0'
		local val
		local -i len n wire tag
		{
			IFS='' read -t 0.25 -r val
			val=$'\n' 
			while true
			do
				tag=$((#val)) 
				wire='tag & 7' 
				(( (tag >>= 3) && tag <= $#__p9k_nordvpn_tag )) || break
				if (( wire == 0 ))
				then
					sysread -s 1 -t 0.25 val
					n=$((#val)) 
					(( n < 128 )) || break
					if (( tag == 2 ))
					then
						case $n in
							(1) typeset -g P9K_NORDVPN_TECHNOLOGY=OPENVPN  ;;
							(2) typeset -g P9K_NORDVPN_TECHNOLOGY=NORDLYNX  ;;
							(3) typeset -g P9K_NORDVPN_TECHNOLOGY=SKYLARK  ;;
							(*) typeset -g P9K_NORDVPN_TECHNOLOGY=UNKNOWN  ;;
						esac
					elif (( tag == 3 ))
					then
						case $n in
							(1) typeset -g P9K_NORDVPN_PROTOCOL=UDP  ;;
							(2) typeset -g P9K_NORDVPN_PROTOCOL=TCP  ;;
							(*) typeset -g P9K_NORDVPN_PROTOCOL=UNKNOWN  ;;
						esac
					else
						break
					fi
				else
					(( wire == 2 )) || break
					(( tag != 2 && tag != 3 )) || break
					[[ -t $fd ]] || true
					sysread -s 1 -t 0.25 val
					len=$((#val)) 
					val= 
					while (( $#val < len ))
					do
						[[ -t $fd ]] || true
						sysread -s $(( len - $#val )) -t 0.25 'val[$#val+1]'
					done
					typeset -g $__p9k_nordvpn_tag[tag]=$val
				fi
				[[ -t $fd ]] || true
				sysread -s 1 -t 0.25 val
			done
		} <&$fd
	} always {
		exec {fd}>&-
	}
}
_p9k_foreground () {
	[[ -n $1 ]] && _p9k__ret="%F{$1}"  || _p9k__ret="%f" 
}
_p9k_fvm_new () {
	_p9k_upglob .fvm && return 1
	local sdk=$_p9k__parent_dirs[$?]/.fvm/flutter_sdk 
	if [[ -L $sdk ]]
	then
		if [[ ${sdk:A} == (#b)*/versions/([^/]##) ]]
		then
			_p9k_prompt_segment prompt_fvm blue $_p9k_color1 FLUTTER_ICON 0 '' ${match[1]//\%/%%}
			return 0
		fi
	fi
	return 1
}
_p9k_fvm_old () {
	_p9k_upglob fvm && return 1
	local fvm=$_p9k__parent_dirs[$?]/fvm 
	if [[ -L $fvm ]]
	then
		if [[ ${fvm:A} == (#b)*/versions/([^/]##)/bin/flutter ]]
		then
			_p9k_prompt_segment prompt_fvm blue $_p9k_color1 FLUTTER_ICON 0 '' ${match[1]//\%/%%}
			return 0
		fi
	fi
	return 1
}
_p9k_gcloud_prefetch () {
	unset P9K_GCLOUD_CONFIGURATION P9K_GCLOUD_ACCOUNT P9K_GCLOUD_PROJECT P9K_GCLOUD_PROJECT_ID P9K_GCLOUD_PROJECT_NAME
	(( $+commands[gcloud] )) || return
	_p9k_read_word ~/.config/gcloud/active_config || return
	P9K_GCLOUD_CONFIGURATION=$_p9k__ret 
	if ! _p9k_cache_stat_get $0 ~/.config/gcloud/configurations/config_$P9K_GCLOUD_CONFIGURATION
	then
		local pair account project_id
		pair="$(gcloud config configurations describe $P9K_GCLOUD_CONFIGURATION \
      --format=$'value[separator="\1"](properties.core.account,properties.core.project)')" 
		(( ! $? )) && IFS=$'\1' read account project_id <<< $pair
		_p9k_cache_stat_set "$account" "$project_id"
	fi
	if [[ -n $_p9k__cache_val[1] ]]
	then
		P9K_GCLOUD_ACCOUNT=$_p9k__cache_val[1] 
	fi
	if [[ -n $_p9k__cache_val[2] ]]
	then
		P9K_GCLOUD_PROJECT_ID=$_p9k__cache_val[2] 
		P9K_GCLOUD_PROJECT=$P9K_GCLOUD_PROJECT_ID 
	fi
	if [[ $P9K_GCLOUD_CONFIGURATION == $_p9k_gcloud_configuration && $P9K_GCLOUD_ACCOUNT == $_p9k_gcloud_account && $P9K_GCLOUD_PROJECT_ID == $_p9k_gcloud_project_id ]]
	then
		[[ -n $_p9k_gcloud_project_name ]] && P9K_GCLOUD_PROJECT_NAME=$_p9k_gcloud_project_name 
		if (( _POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS < 0 ||
          _p9k__gcloud_last_fetch_ts + _POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS > EPOCHREALTIME ))
		then
			return
		fi
	else
		_p9k_gcloud_configuration=$P9K_GCLOUD_CONFIGURATION 
		_p9k_gcloud_account=$P9K_GCLOUD_ACCOUNT 
		_p9k_gcloud_project_id=$P9K_GCLOUD_PROJECT_ID 
		_p9k_gcloud_project_name= 
		_p9k__state_dump_scheduled=1 
	fi
	[[ -n $P9K_GCLOUD_CONFIGURATION && -n $P9K_GCLOUD_ACCOUNT && -n $P9K_GCLOUD_PROJECT_ID ]] || return
	_p9k__gcloud_last_fetch_ts=EPOCHREALTIME 
	_p9k_worker_invoke gcloud "_p9k_prompt_gcloud_compute ${(q)commands[gcloud]} ${(q)P9K_GCLOUD_CONFIGURATION} ${(q)P9K_GCLOUD_ACCOUNT} ${(q)P9K_GCLOUD_PROJECT_ID}"
}
_p9k_get_icon () {
	local key="_p9k_get_icon ${(pj:\0:)*}" 
	_p9k__ret=$_p9k_cache[$key] 
	if [[ -n $_p9k__ret ]]
	then
		_p9k__ret[-1,-1]='' 
	else
		if [[ $2 == $'\1'* ]]
		then
			_p9k__ret=${2[2,-1]} 
		else
			_p9k_param "$1" "$2" ${icons[$2]-$'\1'$3}
			if [[ $_p9k__ret == $'\1'* ]]
			then
				_p9k__ret=${_p9k__ret[2,-1]} 
			else
				_p9k__ret=${(g::)_p9k__ret} 
				[[ $_p9k__ret != $'\b'? ]] || _p9k__ret="%{$_p9k__ret%}" 
			fi
		fi
		_p9k_cache[$key]=${_p9k__ret}. 
	fi
}
_p9k_glob () {
	local dir=$_p9k__parent_dirs[$1] 
	local cached=$_p9k__glob_cache[$dir/$2] 
	if [[ $cached == $_p9k__parent_mtimes[$1]:* ]]
	then
		return ${cached##*:}
	fi
	local -a stat
	zstat -A stat +mtime -- $dir 2> /dev/null || stat=(-1) 
	local files=($dir/$~2(N:t)) 
	_p9k__glob_cache[$dir/$2]="$stat[1]:$#files" 
	return $#files
}
_p9k_goenv_global_version () {
	_p9k_read_pyenv_like_version_file ${GOENV_ROOT:-$HOME/.goenv}/version go- || _p9k__ret=system 
}
_p9k_haskell_stack_version () {
	if ! _p9k_cache_stat_get $0 $1 ${STACK_ROOT:-~/.stack}/{pantry/pantry.sqlite3,stack.sqlite3}
	then
		local v
		v="$(STACK_YAML=$1 stack \
      --silent                 \
      --no-install-ghc         \
      --skip-ghc-check         \
      --no-terminal            \
      --color=never            \
      --lock-file=read-only    \
      query compiler actual)"  || v= 
		_p9k_cache_stat_set "$v"
	fi
	_p9k__ret=$_p9k__cache_val[1] 
}
_p9k_human_readable_bytes () {
	typeset -F n=$1 
	local suf
	for suf in $__p9k_byte_suffix
	do
		(( n < 1024 )) && break
		(( n /= 1024 ))
	done
	if (( n >= 100 ))
	then
		printf -v _p9k__ret '%.0f.' $n
	elif (( n >= 10 ))
	then
		printf -v _p9k__ret '%.1f' $n
	else
		printf -v _p9k__ret '%.2f' $n
	fi
	_p9k__ret=${${_p9k__ret%%0#}%.}$suf 
}
_p9k_init () {
	_p9k_init_vars
	_p9k_restore_state || _p9k_init_cacheable
	typeset -g P9K_OS_ICON=$_p9k_os_icon 
	local -a _p9k__async_segments_compute
	local -i i
	local elem
	_p9k__prompt_side=left 
	_p9k__segment_index=1 
	for i in {1..$#_p9k_line_segments_left}
	do
		for elem in ${${(@0)_p9k_line_segments_left[i]}%_joined}
		do
			local f_init=_p9k_prompt_${elem}_init 
			(( $+functions[$f_init] )) && $f_init
			(( ++_p9k__segment_index ))
		done
	done
	_p9k__prompt_side=right 
	_p9k__segment_index=1 
	for i in {1..$#_p9k_line_segments_right}
	do
		for elem in ${${(@0)_p9k_line_segments_right[i]}%_joined}
		do
			local f_init=_p9k_prompt_${elem}_init 
			(( $+functions[$f_init] )) && $f_init
			(( ++_p9k__segment_index ))
		done
	done
	if [[ -n $_POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE || -n $_POWERLEVEL9K_IP_INTERFACE || -n $_POWERLEVEL9K_VPN_IP_INTERFACE ]]
	then
		_p9k_prompt_net_iface_init
	fi
	if [[ -n $_p9k__async_segments_compute ]]
	then
		functions[_p9k_async_segments_compute]=${(pj:\n:)_p9k__async_segments_compute} 
		_p9k_worker_start
	fi
	local k v
	for k v in ${(kv)_p9k_display_k}
	do
		[[ $k == -* ]] && continue
		_p9k__display_v[v]=$k 
		_p9k__display_v[v+1]=show 
	done
	_p9k__display_v[2]=hide 
	_p9k__display_v[4]=hide 
	if (( $+functions[iterm2_decorate_prompt] ))
	then
		_p9k__iterm2_decorate_prompt=$functions[iterm2_decorate_prompt] 
		iterm2_decorate_prompt () {
			typeset -g ITERM2_PRECMD_PS1=$PROMPT 
			typeset -g ITERM2_SHOULD_DECORATE_PROMPT= 
		}
	fi
	if (( $+functions[iterm2_precmd] ))
	then
		_p9k__iterm2_precmd=$functions[iterm2_precmd] 
		functions[iterm2_precmd]='local _p9k_status=$?; zle && return; () { return $_p9k_status; }; '$_p9k__iterm2_precmd 
	fi
	if (( _POWERLEVEL9K_TERM_SHELL_INTEGRATION  &&
        ! $+_z4h_iterm_cmd                    &&
        ! $+functions[iterm2_decorate_prompt] &&
        ! $+functions[iterm2_precmd] ))
	then
		typeset -gi _p9k__iterm_cmd=0 
	fi
	if _p9k_segment_in_use todo
	then
		if [[ -n ${_p9k__todo_command::=${commands[todo.sh]}} ]]
		then
			local todo_global=/etc/todo/config 
		elif [[ -n ${_p9k__todo_command::=${commands[todo-txt]}} ]]
		then
			local todo_global=/etc/todo-txt/config 
		fi
		if [[ -n $_p9k__todo_command ]]
		then
			_p9k__todo_file="$(exec -a $_p9k__todo_command ${commands[bash]:-:} 3>&1 &>/dev/null -c "
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\$HOME/.todo/config
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\$HOME/todo.cfg
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\$HOME/.todo.cfg
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\${XDG_CONFIG_HOME:-\$HOME/.config}/todo/config
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=${(qqq)_p9k__todo_command:h}/todo.cfg
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\${TODOTXT_GLOBAL_CFG_FILE:-${(qqq)todo_global}}
        [ -r \"\$TODOTXT_CFG_FILE\" ] || exit
        source \"\$TODOTXT_CFG_FILE\"
        printf "%s" \"\$TODO_FILE\" >&3")" 
		fi
	fi
	if _p9k_segment_in_use dir && [[ $_POWERLEVEL9K_SHORTEN_STRATEGY == truncate_with_package_name && $+commands[jq] == 0 ]]
	then
		print -rP -- '%F{yellow}WARNING!%f %BPOWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name%b requires %F{green}jq%f.'
		print -rP -- 'Either install %F{green}jq%f or change the value of %BPOWERLEVEL9K_SHORTEN_STRATEGY%b.'
	fi
	_p9k_init_vcs
	if (( _p9k__instant_prompt_disabled ))
	then
		(( _POWERLEVEL9K_DISABLE_INSTANT_PROMPT )) && unset __p9k_instant_prompt_erased
		_p9k_delete_instant_prompt
		_p9k_dumped_instant_prompt_sigs=() 
	fi
	if (( $+__p9k_instant_prompt_sourced && __p9k_instant_prompt_sourced != __p9k_instant_prompt_version ))
	then
		_p9k_delete_instant_prompt
		_p9k_dumped_instant_prompt_sigs=() 
	fi
	if (( $+__p9k_instant_prompt_erased ))
	then
		unset __p9k_instant_prompt_erased
		if [[ -w $TTY ]]
		then
			local tty=$TTY 
		elif [[ -w /dev/tty ]]
		then
			local tty=/dev/tty 
		else
			local tty=/dev/null 
		fi
		{
			echo -E - "" >&2
			echo -E - "${(%):-[%1FERROR%f]: When using instant prompt, Powerlevel10k must be loaded before the first prompt.}" >&2
			echo -E - "" >&2
			echo -E - "${(%):-You can:}" >&2
			echo -E - "" >&2
			echo -E - "${(%):-  - %BRecommended%b: Change the way Powerlevel10k is loaded from %B$__p9k_zshrc_u%b.}" >&2
			if (( _p9k_term_has_href ))
			then
				echo - "${(%):-    See \e]8;;https://github.com/romkatv/powerlevel10k/blob/master/README.md#installation\ahttps://github.com/romkatv/powerlevel10k/blob/master/README.md#installation\e]8;;\a.}" >&2
			else
				echo - "${(%):-    See https://github.com/romkatv/powerlevel10k/blob/master/README.md#installation.}" >&2
			fi
			if (( $+zsh_defer_options ))
			then
				echo -E - "" >&2
				echo -E - "${(%):-    NOTE: Do not use %1Fzsh-defer%f to load %Upowerlevel10k.zsh-theme%u.}" >&2
			elif (( $+functions[zinit] ))
			then
				echo -E - "" >&2
				echo -E - "${(%):-    NOTE: If using %2Fzinit%f to load %3F'romkatv/powerlevel10k'%f, %Bdo not apply%b %1Fice wait%f.}" >&2
			elif (( $+functions[zplugin] ))
			then
				echo -E - "" >&2
				echo -E - "${(%):-    NOTE: If using %2Fzplugin%f to load %3F'romkatv/powerlevel10k'%f, %Bdo not apply%b %1Fice wait%f.}" >&2
			fi
			echo -E - "" >&2
			echo -E - "${(%):-    * You %Bwill not%b see this error message again.}" >&2
			echo -E - "${(%):-    * Zsh will start %Bquickly%b.}" >&2
			echo -E - "" >&2
			echo -E - "${(%):-  - Disable instant prompt either by running %Bp10k configure%b or by manually}" >&2
			echo -E - "${(%):-    defining the following parameter:}" >&2
			echo -E - "" >&2
			echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=off}" >&2
			echo -E - "" >&2
			echo -E - "${(%):-    * You %Bwill not%b see this error message again.}" >&2
			echo -E - "${(%):-    * Zsh will start %Bslowly%b.}" >&2
			echo -E - "" >&2
			echo -E - "${(%):-  - Do nothing.}" >&2
			echo -E - "" >&2
			echo -E - "${(%):-    * You %Bwill%b see this error message every time you start zsh.}" >&2
			echo -E - "${(%):-    * Zsh will start %Bslowly%b.}" >&2
			echo -E - "" >&2
		} 2>> $tty
	fi
}
_p9k_init_cacheable () {
	_p9k_init_icons
	_p9k_init_params
	_p9k_init_prompt
	_p9k_init_display
	if [[ $VTE_VERSION != (<1-4602>|4801) ]]
	then
		_p9k_term_has_href=1 
	fi
	local elem func
	local -i i=0 
	for i in {1..$#_p9k_line_segments_left}
	do
		for elem in ${${${(@0)_p9k_line_segments_left[i]}%_joined}//-/_}
		do
			local var=POWERLEVEL9K_${${(U)elem}//İ/I}_SHOW_ON_COMMAND 
			(( $+parameters[$var] )) || continue
			_p9k_show_on_command+=($'(|*[/\0])('${(j.|.)${(P)var}}')' $((1+_p9k_display_k[$i/left/$elem])) _p9k__${i}l$elem) 
		done
		for elem in ${${${(@0)_p9k_line_segments_right[i]}%_joined}//-/_}
		do
			local var=POWERLEVEL9K_${${(U)elem}//İ/I}_SHOW_ON_COMMAND 
			(( $+parameters[$var] )) || continue
			local cmds=(${(P)var}) 
			_p9k_show_on_command+=($'(|*[/\0])('${(j.|.)${(P)var}}')' $((1+$_p9k_display_k[$i/right/$elem])) _p9k__${i}r$elem) 
		done
	done
	if [[ $_POWERLEVEL9K_TRANSIENT_PROMPT != off ]]
	then
		local sep=$'\1' 
		_p9k_transient_prompt='%b%k%s%u%(?'$sep 
		_p9k_color prompt_prompt_char_OK_VIINS FOREGROUND 76
		_p9k_foreground $_p9k__ret
		_p9k_transient_prompt+=$_p9k__ret 
		_p9k_transient_prompt+='${${P9K_CONTENT::="❯"}+}' 
		_p9k_param prompt_prompt_char_OK_VIINS CONTENT_EXPANSION '${P9K_CONTENT}'
		_p9k_transient_prompt+='${:-"'$_p9k__ret'"}' 
		_p9k_transient_prompt+=$sep 
		_p9k_color prompt_prompt_char_ERROR_VIINS FOREGROUND 196
		_p9k_foreground $_p9k__ret
		_p9k_transient_prompt+=$_p9k__ret 
		_p9k_transient_prompt+='${${P9K_CONTENT::="❯"}+}' 
		_p9k_param prompt_prompt_char_ERROR_VIINS CONTENT_EXPANSION '${P9K_CONTENT}'
		_p9k_transient_prompt+='${:-"'$_p9k__ret'"}' 
		_p9k_transient_prompt+=')%b%k%f%s%u ' 
		if (( _POWERLEVEL9K_TERM_SHELL_INTEGRATION ))
		then
			_p9k_transient_prompt=$'%{\e]133;A\a%}'$_p9k_transient_prompt$'%{\e]133;B\a%}' 
			if (( $+_z4h_iterm_cmd && _z4h_can_save_restore_screen == 1 ))
			then
				_p9k_transient_prompt=$'%{\ePtmux;\e\e]133;A\a\e\\%}'$_p9k_transient_prompt$'%{\ePtmux;\e\e]133;B\a\e\\%}' 
			fi
		fi
	fi
	_p9k_uname="$(uname)" 
	[[ $_p9k_uname == Linux ]] && _p9k_uname_o="$(uname -o 2>/dev/null)" 
	_p9k_uname_m="$(uname -m)" 
	if [[ $_p9k_uname == Linux && $_p9k_uname_o == Android ]]
	then
		_p9k_set_os Android ANDROID_ICON
	else
		case $_p9k_uname in
			(SunOS) _p9k_set_os Solaris SUNOS_ICON ;;
			(Darwin) _p9k_set_os OSX APPLE_ICON ;;
			(CYGWIN* | MSYS* | MINGW*) _p9k_set_os Windows WINDOWS_ICON ;;
			(FreeBSD | OpenBSD | DragonFly) _p9k_set_os BSD FREEBSD_ICON ;;
			(Linux) _p9k_os='Linux' 
				local os_release_id
				if [[ -r /etc/os-release ]]
				then
					local lines=(${(f)"$(</etc/os-release)"}) 
					lines=(${(@M)lines:#ID=*}) 
					(( $#lines == 1 )) && os_release_id=${lines[1]#ID=} 
				elif [[ -e /etc/artix-release ]]
				then
					os_release_id=artix 
				fi
				case $os_release_id in
					(*arch*) _p9k_set_os Linux LINUX_ARCH_ICON ;;
					(*debian*) _p9k_set_os Linux LINUX_DEBIAN_ICON ;;
					(*raspbian*) _p9k_set_os Linux LINUX_RASPBIAN_ICON ;;
					(*ubuntu*) _p9k_set_os Linux LINUX_UBUNTU_ICON ;;
					(*elementary*) _p9k_set_os Linux LINUX_ELEMENTARY_ICON ;;
					(*fedora*) _p9k_set_os Linux LINUX_FEDORA_ICON ;;
					(*coreos*) _p9k_set_os Linux LINUX_COREOS_ICON ;;
					(*gentoo*) _p9k_set_os Linux LINUX_GENTOO_ICON ;;
					(*mageia*) _p9k_set_os Linux LINUX_MAGEIA_ICON ;;
					(*centos*) _p9k_set_os Linux LINUX_CENTOS_ICON ;;
					(*opensuse* | *tumbleweed*) _p9k_set_os Linux LINUX_OPENSUSE_ICON ;;
					(*sabayon*) _p9k_set_os Linux LINUX_SABAYON_ICON ;;
					(*slackware*) _p9k_set_os Linux LINUX_SLACKWARE_ICON ;;
					(*linuxmint*) _p9k_set_os Linux LINUX_MINT_ICON ;;
					(*alpine*) _p9k_set_os Linux LINUX_ALPINE_ICON ;;
					(*aosc*) _p9k_set_os Linux LINUX_AOSC_ICON ;;
					(*nixos*) _p9k_set_os Linux LINUX_NIXOS_ICON ;;
					(*devuan*) _p9k_set_os Linux LINUX_DEVUAN_ICON ;;
					(*manjaro*) _p9k_set_os Linux LINUX_MANJARO_ICON ;;
					(*void*) _p9k_set_os Linux LINUX_VOID_ICON ;;
					(*artix*) _p9k_set_os Linux LINUX_ARTIX_ICON ;;
					(*rhel*) _p9k_set_os Linux LINUX_RHEL_ICON ;;
					(amzn) _p9k_set_os Linux LINUX_AMZN_ICON ;;
					(*) _p9k_set_os Linux LINUX_ICON ;;
				esac ;;
		esac
	fi
	if [[ $_POWERLEVEL9K_COLOR_SCHEME == light ]]
	then
		_p9k_color1=7 
		_p9k_color2=0 
	else
		_p9k_color1=0 
		_p9k_color2=7 
	fi
	_p9k_battery_states=('LOW' 'red' 'CHARGING' 'yellow' 'CHARGED' 'green' 'DISCONNECTED' "$_p9k_color2") 
	local -a left_segments=(${(@0)${(pj:\0:)_p9k_line_segments_left}}) 
	_p9k_left_join=(1) 
	for ((i = 2; i <= $#left_segments; ++i)) do
		elem=$left_segments[i] 
		if [[ $elem == *_joined ]]
		then
			_p9k_left_join+=$_p9k_left_join[((i-1))] 
		else
			_p9k_left_join+=$i 
		fi
	done
	local -a right_segments=(${(@0)${(pj:\0:)_p9k_line_segments_right}}) 
	_p9k_right_join=(1) 
	for ((i = 2; i <= $#right_segments; ++i)) do
		elem=$right_segments[i] 
		if [[ $elem == *_joined ]]
		then
			_p9k_right_join+=$_p9k_right_join[((i-1))] 
		else
			_p9k_right_join+=$i 
		fi
	done
	case $_p9k_os in
		(OSX) (( $+commands[sysctl] )) && _p9k_num_cpus="$(sysctl -n hw.logicalcpu 2>/dev/null)"  ;;
		(BSD) (( $+commands[sysctl] )) && _p9k_num_cpus="$(sysctl -n hw.ncpu 2>/dev/null)"  ;;
		(*) (( $+commands[nproc]  )) && _p9k_num_cpus="$(nproc 2>/dev/null)"  ;;
	esac
	(( _p9k_num_cpus )) || _p9k_num_cpus=1 
	if _p9k_segment_in_use dir
	then
		if (( $+_POWERLEVEL9K_DIR_CLASSES ))
		then
			local -i i=3 
			for ((; i <= $#_POWERLEVEL9K_DIR_CLASSES; i+=3)) do
				_POWERLEVEL9K_DIR_CLASSES[i]=${(g::)_POWERLEVEL9K_DIR_CLASSES[i]} 
			done
		else
			typeset -ga _POWERLEVEL9K_DIR_CLASSES=() 
			_p9k_get_icon prompt_dir_ETC ETC_ICON
			_POWERLEVEL9K_DIR_CLASSES+=('/etc|/etc/*' ETC "$_p9k__ret") 
			_p9k_get_icon prompt_dir_HOME HOME_ICON
			_POWERLEVEL9K_DIR_CLASSES+=('~' HOME "$_p9k__ret") 
			_p9k_get_icon prompt_dir_HOME_SUBFOLDER HOME_SUB_ICON
			_POWERLEVEL9K_DIR_CLASSES+=('~/*' HOME_SUBFOLDER "$_p9k__ret") 
			_p9k_get_icon prompt_dir_DEFAULT FOLDER_ICON
			_POWERLEVEL9K_DIR_CLASSES+=('*' DEFAULT "$_p9k__ret") 
		fi
	fi
	if _p9k_segment_in_use status
	then
		typeset -g _p9k_exitcode2str=({0..255}) 
		local -i i=2 
		if (( !_POWERLEVEL9K_STATUS_HIDE_SIGNAME ))
		then
			for ((; i <= $#signals; ++i)) do
				local sig=$signals[i] 
				(( _POWERLEVEL9K_STATUS_VERBOSE_SIGNAME )) && sig="SIG${sig}($((i-1)))" 
				_p9k_exitcode2str[$((128+i))]=$sig 
			done
		fi
	fi
	if [[ $#_POWERLEVEL9K_VCS_BACKENDS == 1 && $_POWERLEVEL9K_VCS_BACKENDS[1] == git ]]
	then
		local elem line
		local -i i=0 line_idx=0 
		for line in $_p9k_line_segments_left
		do
			(( ++line_idx ))
			for elem in ${${(0)line}%_joined}
			do
				(( ++i ))
				if [[ $elem == vcs ]]
				then
					if (( _p9k_vcs_index ))
					then
						_p9k_vcs_index=-1 
					else
						_p9k_vcs_index=i 
						_p9k_vcs_line_index=line_idx 
						_p9k_vcs_side=left 
					fi
				fi
			done
		done
		i=0 
		line_idx=0 
		for line in $_p9k_line_segments_right
		do
			(( ++line_idx ))
			for elem in ${${(0)line}%_joined}
			do
				(( ++i ))
				if [[ $elem == vcs ]]
				then
					if (( _p9k_vcs_index ))
					then
						_p9k_vcs_index=-1 
					else
						_p9k_vcs_index=i 
						_p9k_vcs_line_index=line_idx 
						_p9k_vcs_side=right 
					fi
				fi
			done
		done
		if (( _p9k_vcs_index > 0 ))
		then
			local state
			for state in ${(k)__p9k_vcs_states}
			do
				_p9k_param prompt_vcs_$state CONTENT_EXPANSION x
				if [[ -z $_p9k__ret ]]
				then
					_p9k_vcs_index=-1 
					break
				fi
			done
		fi
		if (( _p9k_vcs_index == -1 ))
		then
			_p9k_vcs_index=0 
			_p9k_vcs_line_index=0 
			_p9k_vcs_side= 
		fi
	fi
}
_p9k_init_display () {
	_p9k_display_k=(empty_line 1 ruler 3) 
	local -i n=3 i 
	local name
	for i in {1..$#_p9k_line_segments_left}
	do
		local -i j=$((-$#_p9k_line_segments_left+i-1)) 
		_p9k_display_k+=($i $((n+=2)) $j $n $i/left_frame $((n+=2)) $j/left_frame $n $i/right_frame $((n+=2)) $j/right_frame $n $i/left $((n+=2)) $j/left $n $i/right $((n+=2)) $j/right $n $i/gap $((n+=2)) $j/gap $n) 
		for name in ${${(@0)_p9k_line_segments_left[i]}%_joined}
		do
			_p9k_display_k+=($i/left/$name $((n+=2)) $j/left/$name $n) 
		done
		for name in ${${(@0)_p9k_line_segments_right[i]}%_joined}
		do
			_p9k_display_k+=($i/right/$name $((n+=2)) $j/right/$name $n) 
		done
	done
}
_p9k_init_icons () {
	[[ -n ${POWERLEVEL9K_MODE-} || ${langinfo[CODESET]} == (utf|UTF)(-|)8 ]] || local POWERLEVEL9K_MODE=ascii 
	[[ $_p9k__icon_mode == $POWERLEVEL9K_MODE/$POWERLEVEL9K_LEGACY_ICON_SPACING/$POWERLEVEL9K_ICON_PADDING ]] && return
	typeset -g _p9k__icon_mode=$POWERLEVEL9K_MODE/$POWERLEVEL9K_LEGACY_ICON_SPACING/$POWERLEVEL9K_ICON_PADDING 
	if [[ $POWERLEVEL9K_LEGACY_ICON_SPACING == true ]]
	then
		local s= 
		local q=' ' 
	else
		local s=' ' 
		local q= 
	fi
	case $POWERLEVEL9K_MODE in
		('flat' | 'awesome-patched') icons=(RULER_CHAR '\u2500' LEFT_SEGMENT_SEPARATOR '\uE0B0' RIGHT_SEGMENT_SEPARATOR '\uE0B2' LEFT_SEGMENT_END_SEPARATOR ' ' LEFT_SUBSEGMENT_SEPARATOR '\uE0B1' RIGHT_SUBSEGMENT_SEPARATOR '\uE0B3' CARRIAGE_RETURN_ICON '\u21B5'$s ROOT_ICON '\uE801' SUDO_ICON '\uE0A2' RUBY_ICON '\uE847 ' AWS_ICON '\uE895'$s AWS_EB_ICON '\U1F331'$q BACKGROUND_JOBS_ICON '\uE82F ' TEST_ICON '\uE891'$s TODO_ICON '\u2611' BATTERY_ICON '\uE894'$s DISK_ICON '\uE1AE ' OK_ICON '\u2714' FAIL_ICON '\u2718' SYMFONY_ICON 'SF' NODE_ICON '\u2B22'$s NODEJS_ICON '\u2B22'$s MULTILINE_FIRST_PROMPT_PREFIX '\u256D\U2500' MULTILINE_NEWLINE_PROMPT_PREFIX '\u251C\U2500' MULTILINE_LAST_PROMPT_PREFIX '\u2570\U2500 ' APPLE_ICON '\uE26E'$s WINDOWS_ICON '\uE26F'$s FREEBSD_ICON '\U1F608'$q ANDROID_ICON '\uE270'$s LINUX_ICON '\uE271'$s LINUX_ARCH_ICON '\uE271'$s LINUX_DEBIAN_ICON '\uE271'$s LINUX_RASPBIAN_ICON '\uE271'$s LINUX_UBUNTU_ICON '\uE271'$s LINUX_CENTOS_ICON '\uE271'$s LINUX_COREOS_ICON '\uE271'$s LINUX_ELEMENTARY_ICON '\uE271'$s LINUX_MINT_ICON '\uE271'$s LINUX_FEDORA_ICON '\uE271'$s LINUX_GENTOO_ICON '\uE271'$s LINUX_MAGEIA_ICON '\uE271'$s LINUX_NIXOS_ICON '\uE271'$s LINUX_MANJARO_ICON '\uE271'$s LINUX_DEVUAN_ICON '\uE271'$s LINUX_ALPINE_ICON '\uE271'$s LINUX_AOSC_ICON '\uE271'$s LINUX_OPENSUSE_ICON '\uE271'$s LINUX_SABAYON_ICON '\uE271'$s LINUX_SLACKWARE_ICON '\uE271'$s LINUX_VOID_ICON '\uE271'$s LINUX_ARTIX_ICON '\uE271'$s LINUX_RHEL_ICON '\uE271'$s LINUX_AMZN_ICON '\uE271'$s SUNOS_ICON '\U1F31E'$q HOME_ICON '\uE12C'$s HOME_SUB_ICON '\uE18D'$s FOLDER_ICON '\uE818'$s NETWORK_ICON '\uE1AD'$s ETC_ICON '\uE82F'$s LOAD_ICON '\uE190 ' SWAP_ICON '\uE87D'$s RAM_ICON '\uE1E2 ' SERVER_ICON '\uE895'$s VCS_UNTRACKED_ICON '\uE16C'$s VCS_UNSTAGED_ICON '\uE17C'$s VCS_STAGED_ICON '\uE168'$s VCS_STASH_ICON '\uE133 ' VCS_INCOMING_CHANGES_ICON '\uE131 ' VCS_OUTGOING_CHANGES_ICON '\uE132 ' VCS_TAG_ICON '\uE817 ' VCS_BOOKMARK_ICON '\uE87B' VCS_COMMIT_ICON '\uE821 ' VCS_BRANCH_ICON '\uE220 ' VCS_REMOTE_BRANCH_ICON '\u2192' VCS_LOADING_ICON '' VCS_GIT_ICON '\uE20E ' VCS_GIT_GITHUB_ICON '\uE20E ' VCS_GIT_BITBUCKET_ICON '\uE20E ' VCS_GIT_GITLAB_ICON '\uE20E ' VCS_HG_ICON '\uE1C3 ' VCS_SVN_ICON 'svn'$q RUST_ICON 'R' PYTHON_ICON '\uE63C'$s SWIFT_ICON 'Swift' GO_ICON 'Go' GOLANG_ICON 'Go' PUBLIC_IP_ICON 'IP' LOCK_ICON '\UE138' NORDVPN_ICON '\UE138' EXECUTION_TIME_ICON '\UE89C'$s SSH_ICON 'ssh' VPN_ICON '\UE138' KUBERNETES_ICON '\U2388'$s DROPBOX_ICON '\UF16B'$s DATE_ICON '\uE184'$s TIME_ICON '\uE12E'$s JAVA_ICON '\U2615' LARAVEL_ICON '' RANGER_ICON '\u2B50' MIDNIGHT_COMMANDER_ICON 'mc' VIM_ICON 'vim' TERRAFORM_ICON 'tf' PROXY_ICON '\u2194' DOTNET_ICON '.NET' DOTNET_CORE_ICON '.NET' AZURE_ICON '\u2601' DIRENV_ICON '\u25BC' FLUTTER_ICON 'F' GCLOUD_ICON 'G' LUA_ICON 'lua' PERL_ICON 'perl' NNN_ICON 'nnn' XPLR_ICON 'xplr' TIMEWARRIOR_ICON 'tw' TASKWARRIOR_ICON 'task' NIX_SHELL_ICON 'nix' WIFI_ICON 'WiFi' ERLANG_ICON 'erl' ELIXIR_ICON 'elixir' POSTGRES_ICON 'postgres' PHP_ICON 'php' HASKELL_ICON 'hs' PACKAGE_ICON 'pkg' JULIA_ICON 'jl' SCALA_ICON 'scala' TOOLBOX_ICON '\u2B22')  ;;
		('awesome-fontconfig') icons=(RULER_CHAR '\u2500' LEFT_SEGMENT_SEPARATOR '\uE0B0' RIGHT_SEGMENT_SEPARATOR '\uE0B2' LEFT_SEGMENT_END_SEPARATOR ' ' LEFT_SUBSEGMENT_SEPARATOR '\uE0B1' RIGHT_SUBSEGMENT_SEPARATOR '\uE0B3' CARRIAGE_RETURN_ICON '\u21B5' ROOT_ICON '\uF201'$s SUDO_ICON '\uF09C'$s RUBY_ICON '\uF219 ' AWS_ICON '\uF270'$s AWS_EB_ICON '\U1F331'$q BACKGROUND_JOBS_ICON '\uF013 ' TEST_ICON '\uF291'$s TODO_ICON '\u2611' BATTERY_ICON '\U1F50B' DISK_ICON '\uF0A0 ' OK_ICON '\u2714' FAIL_ICON '\u2718' SYMFONY_ICON 'SF' NODE_ICON '\u2B22' NODEJS_ICON '\u2B22' MULTILINE_FIRST_PROMPT_PREFIX '\u256D\U2500' MULTILINE_NEWLINE_PROMPT_PREFIX '\u251C\U2500' MULTILINE_LAST_PROMPT_PREFIX '\u2570\U2500 ' APPLE_ICON '\uF179'$s WINDOWS_ICON '\uF17A'$s FREEBSD_ICON '\U1F608'$q ANDROID_ICON '\uE17B'$s LINUX_ICON '\uF17C'$s LINUX_ARCH_ICON '\uF17C'$s LINUX_DEBIAN_ICON '\uF17C'$s LINUX_RASPBIAN_ICON '\uF17C'$s LINUX_UBUNTU_ICON '\uF17C'$s LINUX_CENTOS_ICON '\uF17C'$s LINUX_COREOS_ICON '\uF17C'$s LINUX_ELEMENTARY_ICON '\uF17C'$s LINUX_MINT_ICON '\uF17C'$s LINUX_FEDORA_ICON '\uF17C'$s LINUX_GENTOO_ICON '\uF17C'$s LINUX_MAGEIA_ICON '\uF17C'$s LINUX_NIXOS_ICON '\uF17C'$s LINUX_MANJARO_ICON '\uF17C'$s LINUX_DEVUAN_ICON '\uF17C'$s LINUX_ALPINE_ICON '\uF17C'$s LINUX_AOSC_ICON '\uF17C'$s LINUX_OPENSUSE_ICON '\uF17C'$s LINUX_SABAYON_ICON '\uF17C'$s LINUX_SLACKWARE_ICON '\uF17C'$s LINUX_VOID_ICON '\uF17C'$s LINUX_ARTIX_ICON '\uF17C'$s LINUX_RHEL_ICON '\uF17C'$s LINUX_AMZN_ICON '\uF17C'$s SUNOS_ICON '\uF185 ' HOME_ICON '\uF015'$s HOME_SUB_ICON '\uF07C'$s FOLDER_ICON '\uF115'$s ETC_ICON '\uF013 ' NETWORK_ICON '\uF09E'$s LOAD_ICON '\uF080 ' SWAP_ICON '\uF0E4'$s RAM_ICON '\uF0E4'$s SERVER_ICON '\uF233'$s VCS_UNTRACKED_ICON '\uF059'$s VCS_UNSTAGED_ICON '\uF06A'$s VCS_STAGED_ICON '\uF055'$s VCS_STASH_ICON '\uF01C ' VCS_INCOMING_CHANGES_ICON '\uF01A ' VCS_OUTGOING_CHANGES_ICON '\uF01B ' VCS_TAG_ICON '\uF217 ' VCS_BOOKMARK_ICON '\uF27B ' VCS_COMMIT_ICON '\uF221 ' VCS_BRANCH_ICON '\uF126 ' VCS_REMOTE_BRANCH_ICON '\u2192' VCS_LOADING_ICON '' VCS_GIT_ICON '\uF1D3 ' VCS_GIT_GITHUB_ICON '\uF113 ' VCS_GIT_BITBUCKET_ICON '\uF171 ' VCS_GIT_GITLAB_ICON '\uF296 ' VCS_HG_ICON '\uF0C3 ' VCS_SVN_ICON 'svn'$q RUST_ICON '\uE6A8' PYTHON_ICON '\uE63C'$s SWIFT_ICON 'Swift' GO_ICON 'Go' GOLANG_ICON 'Go' PUBLIC_IP_ICON 'IP' LOCK_ICON '\UF023' NORDVPN_ICON '\UF023' EXECUTION_TIME_ICON '\uF253'$s SSH_ICON 'ssh' VPN_ICON '\uF023' KUBERNETES_ICON '\U2388' DROPBOX_ICON '\UF16B'$s DATE_ICON '\uF073 ' TIME_ICON '\uF017 ' JAVA_ICON '\U2615' LARAVEL_ICON '' RANGER_ICON '\u2B50' MIDNIGHT_COMMANDER_ICON 'mc' VIM_ICON 'vim' TERRAFORM_ICON 'tf' PROXY_ICON '\u2194' DOTNET_ICON '.NET' DOTNET_CORE_ICON '.NET' AZURE_ICON '\u2601' DIRENV_ICON '\u25BC' FLUTTER_ICON 'F' GCLOUD_ICON 'G' LUA_ICON 'lua' PERL_ICON 'perl' NNN_ICON 'nnn' XPLR_ICON 'xplr' TIMEWARRIOR_ICON 'tw' TASKWARRIOR_ICON 'task' NIX_SHELL_ICON 'nix' WIFI_ICON 'WiFi' ERLANG_ICON 'erl' ELIXIR_ICON 'elixir' POSTGRES_ICON 'postgres' PHP_ICON 'php' HASKELL_ICON 'hs' PACKAGE_ICON 'pkg' JULIA_ICON 'jl' SCALA_ICON 'scala' TOOLBOX_ICON '\u2B22')  ;;
		('awesome-mapped-fontconfig') if [ -z "$AWESOME_GLYPHS_LOADED" ]
			then
				echo "Powerlevel9k warning: Awesome-Font mappings have not been loaded.
          Source a font mapping in your shell config, per the Awesome-Font docs
          (https://github.com/gabrielelana/awesome-terminal-fonts),
          Or use a different Powerlevel9k font configuration."
			fi
			icons=(RULER_CHAR '\u2500' LEFT_SEGMENT_SEPARATOR '\uE0B0' RIGHT_SEGMENT_SEPARATOR '\uE0B2' LEFT_SEGMENT_END_SEPARATOR ' ' LEFT_SUBSEGMENT_SEPARATOR '\uE0B1' RIGHT_SUBSEGMENT_SEPARATOR '\uE0B3' CARRIAGE_RETURN_ICON '\u21B5' ROOT_ICON "${CODEPOINT_OF_OCTICONS_ZAP:+\\u$CODEPOINT_OF_OCTICONS_ZAP}" SUDO_ICON "${CODEPOINT_OF_AWESOME_UNLOCK:+\\u$CODEPOINT_OF_AWESOME_UNLOCK$s}" RUBY_ICON "${CODEPOINT_OF_OCTICONS_RUBY:+\\u$CODEPOINT_OF_OCTICONS_RUBY }" AWS_ICON "${CODEPOINT_OF_AWESOME_SERVER:+\\u$CODEPOINT_OF_AWESOME_SERVER$s}" AWS_EB_ICON '\U1F331'$q BACKGROUND_JOBS_ICON "${CODEPOINT_OF_AWESOME_COG:+\\u$CODEPOINT_OF_AWESOME_COG }" TEST_ICON "${CODEPOINT_OF_AWESOME_BUG:+\\u$CODEPOINT_OF_AWESOME_BUG$s}" TODO_ICON "${CODEPOINT_OF_AWESOME_CHECK_SQUARE_O:+\\u$CODEPOINT_OF_AWESOME_CHECK_SQUARE_O$s}" BATTERY_ICON "${CODEPOINT_OF_AWESOME_BATTERY_FULL:+\\U$CODEPOINT_OF_AWESOME_BATTERY_FULL$s}" DISK_ICON "${CODEPOINT_OF_AWESOME_HDD_O:+\\u$CODEPOINT_OF_AWESOME_HDD_O }" OK_ICON "${CODEPOINT_OF_AWESOME_CHECK:+\\u$CODEPOINT_OF_AWESOME_CHECK$s}" FAIL_ICON "${CODEPOINT_OF_AWESOME_TIMES:+\\u$CODEPOINT_OF_AWESOME_TIMES}" SYMFONY_ICON 'SF' NODE_ICON '\u2B22' NODEJS_ICON '\u2B22' MULTILINE_FIRST_PROMPT_PREFIX '\u256D\U2500' MULTILINE_NEWLINE_PROMPT_PREFIX '\u251C\U2500' MULTILINE_LAST_PROMPT_PREFIX '\u2570\U2500 ' APPLE_ICON "${CODEPOINT_OF_AWESOME_APPLE:+\\u$CODEPOINT_OF_AWESOME_APPLE$s}" FREEBSD_ICON '\U1F608'$q LINUX_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_ARCH_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_DEBIAN_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_RASPBIAN_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_UBUNTU_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_CENTOS_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_COREOS_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_ELEMENTARY_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_MINT_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_FEDORA_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_GENTOO_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_MAGEIA_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_NIXOS_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_MANJARO_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_DEVUAN_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_ALPINE_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_AOSC_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_OPENSUSE_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_SABAYON_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_SLACKWARE_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_VOID_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_ARTIX_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_RHEL_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" LINUX_AMZN_ICON "${CODEPOINT_OF_AWESOME_LINUX:+\\u$CODEPOINT_OF_AWESOME_LINUX$s}" SUNOS_ICON "${CODEPOINT_OF_AWESOME_SUN_O:+\\u$CODEPOINT_OF_AWESOME_SUN_O }" HOME_ICON "${CODEPOINT_OF_AWESOME_HOME:+\\u$CODEPOINT_OF_AWESOME_HOME$s}" HOME_SUB_ICON "${CODEPOINT_OF_AWESOME_FOLDER_OPEN:+\\u$CODEPOINT_OF_AWESOME_FOLDER_OPEN$s}" FOLDER_ICON "${CODEPOINT_OF_AWESOME_FOLDER_O:+\\u$CODEPOINT_OF_AWESOME_FOLDER_O$s}" ETC_ICON "${CODEPOINT_OF_AWESOME_COG:+\\u$CODEPOINT_OF_AWESOME_COG }" NETWORK_ICON "${CODEPOINT_OF_AWESOME_RSS:+\\u$CODEPOINT_OF_AWESOME_RSS$s}" LOAD_ICON "${CODEPOINT_OF_AWESOME_BAR_CHART:+\\u$CODEPOINT_OF_AWESOME_BAR_CHART }" SWAP_ICON "${CODEPOINT_OF_AWESOME_DASHBOARD:+\\u$CODEPOINT_OF_AWESOME_DASHBOARD$s}" RAM_ICON "${CODEPOINT_OF_AWESOME_DASHBOARD:+\\u$CODEPOINT_OF_AWESOME_DASHBOARD$s}" SERVER_ICON "${CODEPOINT_OF_AWESOME_SERVER:+\\u$CODEPOINT_OF_AWESOME_SERVER$s}" VCS_UNTRACKED_ICON "${CODEPOINT_OF_AWESOME_QUESTION_CIRCLE:+\\u$CODEPOINT_OF_AWESOME_QUESTION_CIRCLE$s}" VCS_UNSTAGED_ICON "${CODEPOINT_OF_AWESOME_EXCLAMATION_CIRCLE:+\\u$CODEPOINT_OF_AWESOME_EXCLAMATION_CIRCLE$s}" VCS_STAGED_ICON "${CODEPOINT_OF_AWESOME_PLUS_CIRCLE:+\\u$CODEPOINT_OF_AWESOME_PLUS_CIRCLE$s}" VCS_STASH_ICON "${CODEPOINT_OF_AWESOME_INBOX:+\\u$CODEPOINT_OF_AWESOME_INBOX }" VCS_INCOMING_CHANGES_ICON "${CODEPOINT_OF_AWESOME_ARROW_CIRCLE_DOWN:+\\u$CODEPOINT_OF_AWESOME_ARROW_CIRCLE_DOWN }" VCS_OUTGOING_CHANGES_ICON "${CODEPOINT_OF_AWESOME_ARROW_CIRCLE_UP:+\\u$CODEPOINT_OF_AWESOME_ARROW_CIRCLE_UP }" VCS_TAG_ICON "${CODEPOINT_OF_AWESOME_TAG:+\\u$CODEPOINT_OF_AWESOME_TAG }" VCS_BOOKMARK_ICON "${CODEPOINT_OF_OCTICONS_BOOKMARK:+\\u$CODEPOINT_OF_OCTICONS_BOOKMARK}" VCS_COMMIT_ICON "${CODEPOINT_OF_OCTICONS_GIT_COMMIT:+\\u$CODEPOINT_OF_OCTICONS_GIT_COMMIT }" VCS_BRANCH_ICON "${CODEPOINT_OF_OCTICONS_GIT_BRANCH:+\\u$CODEPOINT_OF_OCTICONS_GIT_BRANCH }" VCS_REMOTE_BRANCH_ICON "${CODEPOINT_OF_OCTICONS_REPO_PUSH:+\\u$CODEPOINT_OF_OCTICONS_REPO_PUSH$s}" VCS_LOADING_ICON '' VCS_GIT_ICON "${CODEPOINT_OF_AWESOME_GIT:+\\u$CODEPOINT_OF_AWESOME_GIT }" VCS_GIT_GITHUB_ICON "${CODEPOINT_OF_AWESOME_GITHUB_ALT:+\\u$CODEPOINT_OF_AWESOME_GITHUB_ALT }" VCS_GIT_BITBUCKET_ICON "${CODEPOINT_OF_AWESOME_BITBUCKET:+\\u$CODEPOINT_OF_AWESOME_BITBUCKET }" VCS_GIT_GITLAB_ICON "${CODEPOINT_OF_AWESOME_GITLAB:+\\u$CODEPOINT_OF_AWESOME_GITLAB }" VCS_HG_ICON "${CODEPOINT_OF_AWESOME_FLASK:+\\u$CODEPOINT_OF_AWESOME_FLASK }" VCS_SVN_ICON 'svn'$q RUST_ICON '\uE6A8' PYTHON_ICON '\U1F40D' SWIFT_ICON '\uE655'$s PUBLIC_IP_ICON "${CODEPOINT_OF_AWESOME_GLOBE:+\\u$CODEPOINT_OF_AWESOME_GLOBE$s}" LOCK_ICON "${CODEPOINT_OF_AWESOME_LOCK:+\\u$CODEPOINT_OF_AWESOME_LOCK}" NORDVPN_ICON "${CODEPOINT_OF_AWESOME_LOCK:+\\u$CODEPOINT_OF_AWESOME_LOCK}" EXECUTION_TIME_ICON "${CODEPOINT_OF_AWESOME_HOURGLASS_END:+\\u$CODEPOINT_OF_AWESOME_HOURGLASS_END$s}" SSH_ICON 'ssh' VPN_ICON "${CODEPOINT_OF_AWESOME_LOCK:+\\u$CODEPOINT_OF_AWESOME_LOCK}" KUBERNETES_ICON '\U2388' DROPBOX_ICON "${CODEPOINT_OF_AWESOME_DROPBOX:+\\u$CODEPOINT_OF_AWESOME_DROPBOX$s}" DATE_ICON '\uF073 ' TIME_ICON '\uF017 ' JAVA_ICON '\U2615' LARAVEL_ICON '' RANGER_ICON '\u2B50' MIDNIGHT_COMMANDER_ICON 'mc' VIM_ICON 'vim' TERRAFORM_ICON 'tf' PROXY_ICON '\u2194' DOTNET_ICON '.NET' DOTNET_CORE_ICON '.NET' AZURE_ICON '\u2601' DIRENV_ICON '\u25BC' FLUTTER_ICON 'F' GCLOUD_ICON 'G' LUA_ICON 'lua' PERL_ICON 'perl' NNN_ICON 'nnn' XPLR_ICON 'xplr' TIMEWARRIOR_ICON 'tw' TASKWARRIOR_ICON 'task' NIX_SHELL_ICON 'nix' WIFI_ICON 'WiFi' ERLANG_ICON 'erl' ELIXIR_ICON 'elixir' POSTGRES_ICON 'postgres' PHP_ICON 'php' HASKELL_ICON 'hs' PACKAGE_ICON 'pkg' JULIA_ICON 'jl' SCALA_ICON 'scala' TOOLBOX_ICON '\u2B22')  ;;
		('nerdfont-complete' | 'nerdfont-fontconfig') icons=(RULER_CHAR '\u2500' LEFT_SEGMENT_SEPARATOR '\uE0B0' RIGHT_SEGMENT_SEPARATOR '\uE0B2' LEFT_SEGMENT_END_SEPARATOR ' ' LEFT_SUBSEGMENT_SEPARATOR '\uE0B1' RIGHT_SUBSEGMENT_SEPARATOR '\uE0B3' CARRIAGE_RETURN_ICON '\u21B5' ROOT_ICON '\uE614'$q SUDO_ICON '\uF09C'$s RUBY_ICON '\uF219 ' AWS_ICON '\uF270'$s AWS_EB_ICON '\UF1BD'$q$q BACKGROUND_JOBS_ICON '\uF013 ' TEST_ICON '\uF188'$s TODO_ICON '\u2611' BATTERY_ICON '\UF240 ' DISK_ICON '\uF0A0'$s OK_ICON '\uF00C'$s FAIL_ICON '\uF00D' SYMFONY_ICON '\uE757' NODE_ICON '\uE617 ' NODEJS_ICON '\uE617 ' MULTILINE_FIRST_PROMPT_PREFIX '\u256D\U2500' MULTILINE_NEWLINE_PROMPT_PREFIX '\u251C\U2500' MULTILINE_LAST_PROMPT_PREFIX '\u2570\U2500 ' APPLE_ICON '\uF179' WINDOWS_ICON '\uF17A'$s FREEBSD_ICON '\UF30C ' ANDROID_ICON '\uF17B' LINUX_ARCH_ICON '\uF303' LINUX_CENTOS_ICON '\uF304'$s LINUX_COREOS_ICON '\uF305'$s LINUX_DEBIAN_ICON '\uF306' LINUX_RASPBIAN_ICON '\uF315' LINUX_ELEMENTARY_ICON '\uF309'$s LINUX_FEDORA_ICON '\uF30a'$s LINUX_GENTOO_ICON '\uF30d'$s LINUX_MAGEIA_ICON '\uF310' LINUX_MINT_ICON '\uF30e'$s LINUX_NIXOS_ICON '\uF313'$s LINUX_MANJARO_ICON '\uF312'$s LINUX_DEVUAN_ICON '\uF307'$s LINUX_ALPINE_ICON '\uF300'$s LINUX_AOSC_ICON '\uF301'$s LINUX_OPENSUSE_ICON '\uF314'$s LINUX_SABAYON_ICON '\uF317'$s LINUX_SLACKWARE_ICON '\uF319'$s LINUX_VOID_ICON '\uF17C' LINUX_ARTIX_ICON '\uF17C' LINUX_UBUNTU_ICON '\uF31b'$s LINUX_RHEL_ICON '\uF316'$s LINUX_AMZN_ICON '\uF270'$s LINUX_ICON '\uF17C' SUNOS_ICON '\uF185 ' HOME_ICON '\uF015'$s HOME_SUB_ICON '\uF07C'$s FOLDER_ICON '\uF115'$s ETC_ICON '\uF013'$s NETWORK_ICON '\uF50D'$s LOAD_ICON '\uF080 ' SWAP_ICON '\uF464'$s RAM_ICON '\uF0E4'$s SERVER_ICON '\uF0AE'$s VCS_UNTRACKED_ICON '\uF059'$s VCS_UNSTAGED_ICON '\uF06A'$s VCS_STAGED_ICON '\uF055'$s VCS_STASH_ICON '\uF01C ' VCS_INCOMING_CHANGES_ICON '\uF01A ' VCS_OUTGOING_CHANGES_ICON '\uF01B ' VCS_TAG_ICON '\uF02B ' VCS_BOOKMARK_ICON '\uF461 ' VCS_COMMIT_ICON '\uE729 ' VCS_BRANCH_ICON '\uF126 ' VCS_REMOTE_BRANCH_ICON '\uE728 ' VCS_LOADING_ICON '' VCS_GIT_ICON '\uF1D3 ' VCS_GIT_GITHUB_ICON '\uF113 ' VCS_GIT_BITBUCKET_ICON '\uE703 ' VCS_GIT_GITLAB_ICON '\uF296 ' VCS_HG_ICON '\uF0C3 ' VCS_SVN_ICON '\uE72D'$q RUST_ICON '\uE7A8'$q PYTHON_ICON '\UE73C ' SWIFT_ICON '\uE755' GO_ICON '\uE626' GOLANG_ICON '\uE626' PUBLIC_IP_ICON '\UF0AC'$s LOCK_ICON '\UF023' NORDVPN_ICON '\UF023' EXECUTION_TIME_ICON '\uF252'$s SSH_ICON '\uF489'$s VPN_ICON '\UF023' KUBERNETES_ICON '\U2388' DROPBOX_ICON '\UF16B'$s DATE_ICON '\uF073 ' TIME_ICON '\uF017 ' JAVA_ICON '\uE738' LARAVEL_ICON '\ue73f'$q RANGER_ICON '\uF00b ' MIDNIGHT_COMMANDER_ICON 'mc' VIM_ICON '\uE62B' TERRAFORM_ICON '\uF1BB ' PROXY_ICON '\u2194' DOTNET_ICON '\uE77F' DOTNET_CORE_ICON '\uE77F' AZURE_ICON '\uFD03' DIRENV_ICON '\u25BC' FLUTTER_ICON 'F' GCLOUD_ICON '\uF7B7' LUA_ICON '\uE620' PERL_ICON '\uE769' NNN_ICON 'nnn' XPLR_ICON 'xplr' TIMEWARRIOR_ICON '\uF49B' TASKWARRIOR_ICON '\uF4A0 ' NIX_SHELL_ICON '\uF313 ' WIFI_ICON '\uF1EB ' ERLANG_ICON '\uE7B1 ' ELIXIR_ICON '\uE62D' POSTGRES_ICON '\uE76E' PHP_ICON '\uE608' HASKELL_ICON '\uE61F' PACKAGE_ICON '\uF8D6' JULIA_ICON '\uE624' SCALA_ICON '\uE737' TOOLBOX_ICON '\uE20F'$s)  ;;
		(ascii) icons=(RULER_CHAR '-' LEFT_SEGMENT_SEPARATOR '' RIGHT_SEGMENT_SEPARATOR '' LEFT_SEGMENT_END_SEPARATOR ' ' LEFT_SUBSEGMENT_SEPARATOR '|' RIGHT_SUBSEGMENT_SEPARATOR '|' CARRIAGE_RETURN_ICON '' ROOT_ICON '#' SUDO_ICON '' RUBY_ICON 'rb' AWS_ICON 'aws' AWS_EB_ICON 'eb' BACKGROUND_JOBS_ICON '%%' TEST_ICON '' TODO_ICON 'todo' BATTERY_ICON 'battery' DISK_ICON 'disk' OK_ICON 'ok' FAIL_ICON 'err' SYMFONY_ICON 'symphony' NODE_ICON 'node' NODEJS_ICON 'node' MULTILINE_FIRST_PROMPT_PREFIX '' MULTILINE_NEWLINE_PROMPT_PREFIX '' MULTILINE_LAST_PROMPT_PREFIX '' APPLE_ICON 'mac' WINDOWS_ICON 'win' FREEBSD_ICON 'bsd' ANDROID_ICON 'android' LINUX_ICON 'linux' LINUX_ARCH_ICON 'arch' LINUX_DEBIAN_ICON 'debian' LINUX_RASPBIAN_ICON 'pi' LINUX_UBUNTU_ICON 'ubuntu' LINUX_CENTOS_ICON 'centos' LINUX_COREOS_ICON 'coreos' LINUX_ELEMENTARY_ICON 'elementary' LINUX_MINT_ICON 'mint' LINUX_FEDORA_ICON 'fedora' LINUX_GENTOO_ICON 'gentoo' LINUX_MAGEIA_ICON 'mageia' LINUX_NIXOS_ICON 'nixos' LINUX_MANJARO_ICON 'manjaro' LINUX_DEVUAN_ICON 'devuan' LINUX_ALPINE_ICON 'alpine' LINUX_AOSC_ICON 'aosc' LINUX_OPENSUSE_ICON 'suse' LINUX_SABAYON_ICON 'sabayon' LINUX_SLACKWARE_ICON 'slack' LINUX_VOID_ICON 'void' LINUX_ARTIX_ICON 'artix' LINUX_RHEL_ICON 'rhel' LINUX_AMZN_ICON 'amzn' SUNOS_ICON 'sunos' HOME_ICON '' HOME_SUB_ICON '' FOLDER_ICON '' ETC_ICON '' NETWORK_ICON 'ip' LOAD_ICON 'cpu' SWAP_ICON 'swap' RAM_ICON 'ram' SERVER_ICON '' VCS_UNTRACKED_ICON '?' VCS_UNSTAGED_ICON '!' VCS_STAGED_ICON '+' VCS_STASH_ICON '#' VCS_INCOMING_CHANGES_ICON '<' VCS_OUTGOING_CHANGES_ICON '>' VCS_TAG_ICON '' VCS_BOOKMARK_ICON '^' VCS_COMMIT_ICON '@' VCS_BRANCH_ICON '' VCS_REMOTE_BRANCH_ICON ':' VCS_LOADING_ICON '' VCS_GIT_ICON '' VCS_GIT_GITHUB_ICON '' VCS_GIT_BITBUCKET_ICON '' VCS_GIT_GITLAB_ICON '' VCS_HG_ICON '' VCS_SVN_ICON '' RUST_ICON 'rust' PYTHON_ICON 'py' SWIFT_ICON 'swift' GO_ICON 'go' GOLANG_ICON 'go' PUBLIC_IP_ICON 'ip' LOCK_ICON '!w' NORDVPN_ICON 'nordvpn' EXECUTION_TIME_ICON '' SSH_ICON 'ssh' VPN_ICON 'vpn' KUBERNETES_ICON 'kube' DROPBOX_ICON 'dropbox' DATE_ICON '' TIME_ICON '' JAVA_ICON 'java' LARAVEL_ICON '' RANGER_ICON 'ranger' MIDNIGHT_COMMANDER_ICON 'mc' VIM_ICON 'vim' TERRAFORM_ICON 'tf' PROXY_ICON 'proxy' DOTNET_ICON '.net' DOTNET_CORE_ICON '.net' AZURE_ICON 'az' DIRENV_ICON 'direnv' FLUTTER_ICON 'flutter' GCLOUD_ICON 'gcloud' LUA_ICON 'lua' PERL_ICON 'perl' NNN_ICON 'nnn' XPLR_ICON 'xplr' TIMEWARRIOR_ICON 'tw' TASKWARRIOR_ICON 'task' NIX_SHELL_ICON 'nix' WIFI_ICON 'wifi' ERLANG_ICON 'erlang' ELIXIR_ICON 'elixir' POSTGRES_ICON 'postgres' PHP_ICON 'php' HASKELL_ICON 'hs' PACKAGE_ICON 'pkg' JULIA_ICON 'jl' SCALA_ICON 'scala' TOOLBOX_ICON 'toolbox')  ;;
		(*) icons=(RULER_CHAR '\u2500' LEFT_SEGMENT_SEPARATOR '\uE0B0' RIGHT_SEGMENT_SEPARATOR '\uE0B2' LEFT_SEGMENT_END_SEPARATOR ' ' LEFT_SUBSEGMENT_SEPARATOR '\uE0B1' RIGHT_SUBSEGMENT_SEPARATOR '\uE0B3' CARRIAGE_RETURN_ICON '\u21B5' ROOT_ICON '\u26A1' SUDO_ICON '' RUBY_ICON 'Ruby' AWS_ICON 'AWS' AWS_EB_ICON '\U1F331'$q BACKGROUND_JOBS_ICON '\u2699' TEST_ICON '' TODO_ICON '\u2206' BATTERY_ICON '\U1F50B' DISK_ICON 'hdd' OK_ICON '\u2714' FAIL_ICON '\u2718' SYMFONY_ICON 'SF' NODE_ICON 'Node' NODEJS_ICON 'Node' MULTILINE_FIRST_PROMPT_PREFIX '\u256D\U2500' MULTILINE_NEWLINE_PROMPT_PREFIX '\u251C\U2500' MULTILINE_LAST_PROMPT_PREFIX '\u2570\U2500 ' APPLE_ICON 'OSX' WINDOWS_ICON 'WIN' FREEBSD_ICON 'BSD' ANDROID_ICON 'And' LINUX_ICON 'Lx' LINUX_ARCH_ICON 'Arc' LINUX_DEBIAN_ICON 'Deb' LINUX_RASPBIAN_ICON 'RPi' LINUX_UBUNTU_ICON 'Ubu' LINUX_CENTOS_ICON 'Cen' LINUX_COREOS_ICON 'Cor' LINUX_ELEMENTARY_ICON 'Elm' LINUX_MINT_ICON 'LMi' LINUX_FEDORA_ICON 'Fed' LINUX_GENTOO_ICON 'Gen' LINUX_MAGEIA_ICON 'Mag' LINUX_NIXOS_ICON 'Nix' LINUX_MANJARO_ICON 'Man' LINUX_DEVUAN_ICON 'Dev' LINUX_ALPINE_ICON 'Alp' LINUX_AOSC_ICON 'Aos' LINUX_OPENSUSE_ICON 'OSu' LINUX_SABAYON_ICON 'Sab' LINUX_SLACKWARE_ICON 'Sla' LINUX_VOID_ICON 'Vo' LINUX_ARTIX_ICON 'Art' LINUX_RHEL_ICON 'RH' LINUX_AMZN_ICON 'Amzn' SUNOS_ICON 'Sun' HOME_ICON '' HOME_SUB_ICON '' FOLDER_ICON '' ETC_ICON '\u2699' NETWORK_ICON 'IP' LOAD_ICON 'L' SWAP_ICON 'SWP' RAM_ICON 'RAM' SERVER_ICON '' VCS_UNTRACKED_ICON '?' VCS_UNSTAGED_ICON '\u25CF' VCS_STAGED_ICON '\u271A' VCS_STASH_ICON '\u235F' VCS_INCOMING_CHANGES_ICON '\u2193' VCS_OUTGOING_CHANGES_ICON '\u2191' VCS_TAG_ICON '' VCS_BOOKMARK_ICON '\u263F' VCS_COMMIT_ICON '' VCS_BRANCH_ICON '\uE0A0 ' VCS_REMOTE_BRANCH_ICON '\u2192' VCS_LOADING_ICON '' VCS_GIT_ICON '' VCS_GIT_GITHUB_ICON '' VCS_GIT_BITBUCKET_ICON '' VCS_GIT_GITLAB_ICON '' VCS_HG_ICON '' VCS_SVN_ICON '' RUST_ICON 'R' PYTHON_ICON 'Py' SWIFT_ICON 'Swift' GO_ICON 'Go' GOLANG_ICON 'Go' PUBLIC_IP_ICON 'IP' LOCK_ICON '\UE0A2' NORDVPN_ICON '\UE0A2' EXECUTION_TIME_ICON '' SSH_ICON 'ssh' VPN_ICON 'vpn' KUBERNETES_ICON '\U2388' DROPBOX_ICON 'Dropbox' DATE_ICON '' TIME_ICON '' JAVA_ICON '\U2615' LARAVEL_ICON '' RANGER_ICON '\u2B50' MIDNIGHT_COMMANDER_ICON 'mc' VIM_ICON 'vim' TERRAFORM_ICON 'tf' PROXY_ICON '\u2194' DOTNET_ICON '.NET' DOTNET_CORE_ICON '.NET' AZURE_ICON '\u2601' DIRENV_ICON '\u25BC' FLUTTER_ICON 'F' GCLOUD_ICON 'G' LUA_ICON 'lua' PERL_ICON 'perl' NNN_ICON 'nnn' XPLR_ICON 'xplr' TIMEWARRIOR_ICON 'tw' TASKWARRIOR_ICON 'task' NIX_SHELL_ICON 'nix' WIFI_ICON 'WiFi' ERLANG_ICON 'erl' ELIXIR_ICON 'elixir' POSTGRES_ICON 'postgres' PHP_ICON 'php' HASKELL_ICON 'hs' PACKAGE_ICON 'pkg' JULIA_ICON 'jl' SCALA_ICON 'scala' TOOLBOX_ICON '\u2B22')  ;;
	esac
	case $POWERLEVEL9K_MODE in
		('flat') icons[LEFT_SEGMENT_SEPARATOR]='' 
			icons[RIGHT_SEGMENT_SEPARATOR]='' 
			icons[LEFT_SUBSEGMENT_SEPARATOR]='|' 
			icons[RIGHT_SUBSEGMENT_SEPARATOR]='|'  ;;
		('compatible') icons[LEFT_SEGMENT_SEPARATOR]='\u2B80' 
			icons[RIGHT_SEGMENT_SEPARATOR]='\u2B82' 
			icons[VCS_BRANCH_ICON]='@'  ;;
	esac
	if [[ $POWERLEVEL9K_ICON_PADDING == none && $POWERLEVEL9K_MODE != ascii ]]
	then
		icons=("${(@kv)icons%% #}") 
		icons[LEFT_SEGMENT_END_SEPARATOR]+=' ' 
		icons[MULTILINE_LAST_PROMPT_PREFIX]+=' ' 
		icons[VCS_TAG_ICON]+=' ' 
		icons[VCS_BOOKMARK_ICON]+=' ' 
		icons[VCS_COMMIT_ICON]+=' ' 
		icons[VCS_BRANCH_ICON]+=' ' 
		icons[VCS_REMOTE_BRANCH_ICON]+=' ' 
	fi
}
_p9k_init_lines () {
	local -a left_segments=($_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS) 
	local -a right_segments=($_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS) 
	if (( _POWERLEVEL9K_PROMPT_ON_NEWLINE ))
	then
		left_segments+=(newline _p9k_internal_nothing) 
	fi
	local -i num_left_lines=$((1 + ${#${(@M)left_segments:#newline}})) 
	local -i num_right_lines=$((1 + ${#${(@M)right_segments:#newline}})) 
	if (( num_right_lines > num_left_lines ))
	then
		repeat $((num_right_lines - num_left_lines))
		do
			left_segments=(newline $left_segments) 
		done
		local -i num_lines=num_right_lines 
	else
		if (( _POWERLEVEL9K_RPROMPT_ON_NEWLINE ))
		then
			repeat $((num_left_lines - num_right_lines))
			do
				right_segments=(newline $right_segments) 
			done
		else
			repeat $((num_left_lines - num_right_lines))
			do
				right_segments+=newline 
			done
		fi
		local -i num_lines=num_left_lines 
	fi
	local -i i
	for i in {1..$num_lines}
	do
		local -i left_end=${left_segments[(i)newline]} 
		local -i right_end=${right_segments[(i)newline]} 
		_p9k_line_segments_left+="${(pj:\0:)left_segments[1,left_end-1]}" 
		_p9k_line_segments_right+="${(pj:\0:)right_segments[1,right_end-1]}" 
		(( left_end > $#left_segments )) && left_segments=()  || shift left_end left_segments
		(( right_end > $#right_segments )) && right_segments=()  || shift right_end right_segments
		_p9k_get_icon '' LEFT_SEGMENT_SEPARATOR
		_p9k_get_icon 'prompt_empty_line' LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL $_p9k__ret
		_p9k_escape $_p9k__ret
		_p9k_line_prefix_left+='${_p9k__'$i'l-${${:-${_p9k__bg::=NONE}${_p9k__i::=0}${_p9k__sss::=%f'$_p9k__ret'}}+}' 
		_p9k_line_suffix_left+='%b%k$_p9k__sss%b%k%f' 
		_p9k_escape ${(g::)_POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL}
		[[ -n $_p9k__ret ]] && _p9k_line_never_empty_right+=1  || _p9k_line_never_empty_right+=0 
		_p9k_line_prefix_right+='${_p9k__'$i'r-${${:-${_p9k__bg::=NONE}${_p9k__i::=0}${_p9k__sss::='$_p9k__ret'}}+}' 
		_p9k_line_suffix_right+='$_p9k__sss%b%k%f}' 
		if (( i == num_lines ))
		then
			_p9k_prompt_length ${(e)_p9k__ret}
			(( _p9k__ret )) || _p9k_line_never_empty_right[-1]=0 
		fi
	done
	_p9k_get_icon '' LEFT_SEGMENT_END_SEPARATOR
	if [[ -n $_p9k__ret ]]
	then
		_p9k__ret+=%b%k%f 
		_p9k__ret='${:-"'$_p9k__ret'"}' 
		if (( _POWERLEVEL9K_PROMPT_ON_NEWLINE ))
		then
			_p9k_line_suffix_left[-2]+=$_p9k__ret 
		else
			_p9k_line_suffix_left[-1]+=$_p9k__ret 
		fi
	fi
	for i in {1..$num_lines}
	do
		_p9k_line_suffix_left[i]+='}' 
	done
	if (( num_lines > 1 ))
	then
		for i in {1..$((num_lines-1))}
		do
			_p9k_build_gap_post $i
			_p9k_line_gap_post+=$_p9k__ret 
		done
		if [[ $+_POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX == 1 || $_POWERLEVEL9K_PROMPT_ON_NEWLINE == 1 ]]
		then
			_p9k_get_icon '' MULTILINE_FIRST_PROMPT_PREFIX
			if [[ -n $_p9k__ret ]]
			then
				[[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f 
				_p9k__ret='${_p9k__1l_frame-"'$_p9k__ret'"}' 
				_p9k_line_prefix_left[1]=$_p9k__ret$_p9k_line_prefix_left[1] 
			fi
		fi
		if [[ $+_POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX == 1 || $_POWERLEVEL9K_PROMPT_ON_NEWLINE == 1 ]]
		then
			_p9k_get_icon '' MULTILINE_LAST_PROMPT_PREFIX
			if [[ -n $_p9k__ret ]]
			then
				[[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f 
				_p9k__ret='${_p9k__'$num_lines'l_frame-"'$_p9k__ret'"}' 
				_p9k_line_prefix_left[-1]=$_p9k__ret$_p9k_line_prefix_left[-1] 
			fi
		fi
		_p9k_get_icon '' MULTILINE_FIRST_PROMPT_SUFFIX
		if [[ -n $_p9k__ret ]]
		then
			[[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f 
			_p9k_line_suffix_right[1]+='${_p9k__1r_frame-'${(qqq)_p9k__ret}'}' 
			_p9k_line_never_empty_right[1]=1 
		fi
		_p9k_get_icon '' MULTILINE_LAST_PROMPT_SUFFIX
		if [[ -n $_p9k__ret ]]
		then
			[[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f 
			_p9k_line_suffix_right[-1]+='${_p9k__'$num_lines'r_frame-'${(qqq)_p9k__ret}'}' 
			_p9k_prompt_length $_p9k__ret
			(( _p9k__ret )) && _p9k_line_never_empty_right[-1]=1 
		fi
		if (( num_lines > 2 ))
		then
			if [[ $+_POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX == 1 || $_POWERLEVEL9K_PROMPT_ON_NEWLINE == 1 ]]
			then
				_p9k_get_icon '' MULTILINE_NEWLINE_PROMPT_PREFIX
				if [[ -n $_p9k__ret ]]
				then
					[[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f 
					for i in {2..$((num_lines-1))}
					do
						_p9k_line_prefix_left[i]='${_p9k__'$i'l_frame-"'$_p9k__ret'"}'$_p9k_line_prefix_left[i] 
					done
				fi
			fi
			_p9k_get_icon '' MULTILINE_NEWLINE_PROMPT_SUFFIX
			if [[ -n $_p9k__ret ]]
			then
				[[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f 
				for i in {2..$((num_lines-1))}
				do
					_p9k_line_suffix_right[i]+='${_p9k__'$i'r_frame-'${(qqq)_p9k__ret}'}' 
				done
				_p9k_line_never_empty_right[2,-2]=${(@)_p9k_line_never_empty_right[2,-2]/0/1} 
			fi
		fi
	fi
}
_p9k_init_locale () {
	if (( ! $+__p9k_locale ))
	then
		typeset -g __p9k_locale= 
		(( $+commands[locale] )) || return
		local -a loc
		loc=(${(@M)$(locale -a 2>/dev/null):#*.(utf|UTF)(-|)8})  || return
		(( $#loc )) || return
		typeset -g __p9k_locale=${loc[(r)(#i)C.UTF(-|)8]:-${loc[(r)(#i)en_US.UTF(-|)8]:-$loc[1]}} 
	fi
	[[ -n $__p9k_locale ]]
}
_p9k_init_params () {
	_p9k_declare -F POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS 60
	_p9k_declare -s POWERLEVEL9K_INSTANT_PROMPT
	if [[ $_POWERLEVEL9K_INSTANT_PROMPT == off ]]
	then
		typeset -gi _POWERLEVEL9K_DISABLE_INSTANT_PROMPT=1 
	else
		_p9k_declare -b POWERLEVEL9K_DISABLE_INSTANT_PROMPT 0
		if (( _POWERLEVEL9K_DISABLE_INSTANT_PROMPT ))
		then
			_POWERLEVEL9K_INSTANT_PROMPT=off 
		elif [[ $_POWERLEVEL9K_INSTANT_PROMPT != quiet ]]
		then
			_POWERLEVEL9K_INSTANT_PROMPT=verbose 
		fi
	fi
	(( _POWERLEVEL9K_DISABLE_INSTANT_PROMPT )) && _p9k__instant_prompt_disabled=1 
	_p9k_declare -s POWERLEVEL9K_TRANSIENT_PROMPT off
	[[ $_POWERLEVEL9K_TRANSIENT_PROMPT == (off|always|same-dir) ]] || _POWERLEVEL9K_TRANSIENT_PROMPT=off 
	_p9k_declare -b POWERLEVEL9K_TERM_SHELL_INTEGRATION 0
	if [[ __p9k_force_term_shell_integration -eq 1 || $ITERM_SHELL_INTEGRATION_INSTALLED == Yes ]]
	then
		_POWERLEVEL9K_TERM_SHELL_INTEGRATION=1 
	fi
	_p9k_declare -s POWERLEVEL9K_WORKER_LOG_LEVEL
	_p9k_declare -i POWERLEVEL9K_COMMANDS_MAX_TOKEN_COUNT 64
	_p9k_declare -a POWERLEVEL9K_HOOK_WIDGETS --
	_p9k_declare -b POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL 0
	_p9k_declare -b POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED 0
	_p9k_declare -b POWERLEVEL9K_DISABLE_HOT_RELOAD 0
	_p9k_declare -F POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS 5
	_p9k_declare -i POWERLEVEL9K_INSTANT_PROMPT_COMMAND_LINES
	_p9k_declare -a POWERLEVEL9K_LEFT_PROMPT_ELEMENTS -- context dir vcs
	_p9k_declare -a POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS -- status root_indicator background_jobs history time
	_p9k_declare -b POWERLEVEL9K_DISABLE_RPROMPT 0
	_p9k_declare -b POWERLEVEL9K_PROMPT_ADD_NEWLINE 0
	_p9k_declare -b POWERLEVEL9K_PROMPT_ON_NEWLINE 0
	_p9k_declare -b POWERLEVEL9K_RPROMPT_ON_NEWLINE 0
	_p9k_declare -b POWERLEVEL9K_SHOW_RULER 0
	_p9k_declare -i POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT 1
	_p9k_declare -s POWERLEVEL9K_COLOR_SCHEME dark
	_p9k_declare -s POWERLEVEL9K_GITSTATUS_DIR ""
	_p9k_declare -s POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN
	_p9k_declare -b POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY 0
	_p9k_declare -i POWERLEVEL9K_VCS_SHORTEN_LENGTH
	_p9k_declare -i POWERLEVEL9K_VCS_SHORTEN_MIN_LENGTH
	_p9k_declare -s POWERLEVEL9K_VCS_SHORTEN_STRATEGY
	if [[ $langinfo[CODESET] == (utf|UTF)(-|)8 ]]
	then
		_p9k_declare -e POWERLEVEL9K_VCS_SHORTEN_DELIMITER '\u2026'
	else
		_p9k_declare -e POWERLEVEL9K_VCS_SHORTEN_DELIMITER '..'
	fi
	_p9k_declare -b POWERLEVEL9K_VCS_CONFLICTED_STATE 0
	_p9k_declare -b POWERLEVEL9K_HIDE_BRANCH_ICON 0
	_p9k_declare -b POWERLEVEL9K_VCS_HIDE_TAGS 0
	_p9k_declare -i POWERLEVEL9K_CHANGESET_HASH_LENGTH 8
	_p9k_declare -i POWERLEVEL9K_MAX_CACHE_SIZE 10000
	_p9k_declare -e POWERLEVEL9K_ANACONDA_LEFT_DELIMITER "("
	_p9k_declare -e POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER ")"
	_p9k_declare -b POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION 1
	_p9k_declare -b POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE 1
	_p9k_declare -b POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE_ALWAYS 0
	_p9k_declare -b POWERLEVEL9K_DISK_USAGE_ONLY_WARNING 0
	_p9k_declare -i POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL 90
	_p9k_declare -i POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL 95
	_p9k_declare -i POWERLEVEL9K_BATTERY_LOW_THRESHOLD 10
	_p9k_declare -i POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD 999
	_p9k_declare -b POWERLEVEL9K_BATTERY_VERBOSE 1
	_p9k_declare -a POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND --
	_p9k_declare -a POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND --
	case $parameters[POWERLEVEL9K_BATTERY_STAGES] in
		(scalar*) typeset -ga _POWERLEVEL9K_BATTERY_STAGES=("${(@s::)${(g::)POWERLEVEL9K_BATTERY_STAGES}}")  ;;
		(array*) typeset -ga _POWERLEVEL9K_BATTERY_STAGES=("${(@g::)POWERLEVEL9K_BATTERY_STAGES}")  ;;
		(*) typeset -ga _POWERLEVEL9K_BATTERY_STAGES=()  ;;
	esac
	local state
	for state in CHARGED CHARGING LOW DISCONNECTED
	do
		_p9k_declare -i POWERLEVEL9K_BATTERY_${state}_HIDE_ABOVE_THRESHOLD $_POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD
		local var=POWERLEVEL9K_BATTERY_${state}_STAGES 
		case $parameters[$var] in
			(scalar*) eval "typeset -ga _$var=(${(@qq)${(@s::)${(g::)${(P)var}}}})" ;;
			(array*) eval "typeset -ga _$var=(${(@qq)${(@g::)${(@P)var}}})" ;;
			(*) eval "typeset -ga _$var=(${(@qq)_POWERLEVEL9K_BATTERY_STAGES})" ;;
		esac
		local var=POWERLEVEL9K_BATTERY_${state}_LEVEL_BACKGROUND 
		case $parameters[$var] in
			(array*) eval "typeset -ga _$var=(${(@qq)${(@P)var}})" ;;
			(*) eval "typeset -ga _$var=(${(@qq)_POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND})" ;;
		esac
		local var=POWERLEVEL9K_BATTERY_${state}_LEVEL_FOREGROUND 
		case $parameters[$var] in
			(array*) eval "typeset -ga _$var=(${(@qq)${(@P)var}})" ;;
			(*) eval "typeset -ga _$var=(${(@qq)_POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND})" ;;
		esac
	done
	_p9k_declare -F POWERLEVEL9K_PUBLIC_IP_TIMEOUT 300
	_p9k_declare -a POWERLEVEL9K_PUBLIC_IP_METHODS -- dig curl wget
	_p9k_declare -e POWERLEVEL9K_PUBLIC_IP_NONE ""
	_p9k_declare -s POWERLEVEL9K_PUBLIC_IP_HOST "https://v4.ident.me/"
	_p9k_declare -s POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE ""
	_p9k_segment_in_use public_ip || _POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE= 
	_p9k_declare -b POWERLEVEL9K_ALWAYS_SHOW_CONTEXT 0
	_p9k_declare -b POWERLEVEL9K_ALWAYS_SHOW_USER 0
	_p9k_declare -e POWERLEVEL9K_CONTEXT_TEMPLATE "%n@%m"
	_p9k_declare -e POWERLEVEL9K_USER_TEMPLATE "%n"
	_p9k_declare -e POWERLEVEL9K_HOST_TEMPLATE "%m"
	_p9k_declare -F POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD 3
	_p9k_declare -i POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION 2
	_p9k_declare -s POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT "H:M:S"
	_p9k_declare -e POWERLEVEL9K_HOME_FOLDER_ABBREVIATION "~"
	_p9k_declare -b POWERLEVEL9K_DIR_PATH_ABSOLUTE 0
	_p9k_declare -s POWERLEVEL9K_DIR_SHOW_WRITABLE ''
	case $_POWERLEVEL9K_DIR_SHOW_WRITABLE in
		(true) _POWERLEVEL9K_DIR_SHOW_WRITABLE=1  ;;
		(v2) _POWERLEVEL9K_DIR_SHOW_WRITABLE=2  ;;
		(v3) _POWERLEVEL9K_DIR_SHOW_WRITABLE=3  ;;
		(*) _POWERLEVEL9K_DIR_SHOW_WRITABLE=0  ;;
	esac
	typeset -gi _POWERLEVEL9K_DIR_SHOW_WRITABLE
	_p9k_declare -b POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER 0
	_p9k_declare -b POWERLEVEL9K_DIR_HYPERLINK 0
	_p9k_declare -s POWERLEVEL9K_SHORTEN_STRATEGY ""
	local markers=(.bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform CVS Cargo.toml composer.json go.mod package.json) 
	_p9k_declare -s POWERLEVEL9K_SHORTEN_FOLDER_MARKER "(${(j:|:)markers})"
	_p9k_declare -s POWERLEVEL9K_DIR_MAX_LENGTH 0
	_p9k_declare -a POWERLEVEL9K_DIR_PACKAGE_FILES -- package.json composer.json
	_p9k_declare -i POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS 40
	_p9k_declare -F POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT 50
	_p9k_declare -a POWERLEVEL9K_DIR_CLASSES
	_p9k_declare -i POWERLEVEL9K_SHORTEN_DELIMITER_LENGTH
	_p9k_declare -e POWERLEVEL9K_SHORTEN_DELIMITER
	_p9k_declare -s POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER ''
	case $_POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER in
		(first | last) _POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER+=:0  ;;
		((first|last):(|-)<->)  ;;
		(*) _POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=  ;;
	esac
	[[ -z $_POWERLEVEL9K_SHORTEN_FOLDER_MARKER ]] && _POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER= 
	_p9k_declare -i POWERLEVEL9K_SHORTEN_DIR_LENGTH
	_p9k_declare -s POWERLEVEL9K_IP_INTERFACE ""
	: ${_POWERLEVEL9K_IP_INTERFACE:='.*'}
	_p9k_segment_in_use ip || _POWERLEVEL9K_IP_INTERFACE= 
	_p9k_declare -s POWERLEVEL9K_VPN_IP_INTERFACE "(gpd|wg|(.*tun)|tailscale)[0-9]*)|(zt.*)"
	: ${_POWERLEVEL9K_VPN_IP_INTERFACE:='.*'}
	_p9k_segment_in_use vpn_ip || _POWERLEVEL9K_VPN_IP_INTERFACE= 
	_p9k_declare -b POWERLEVEL9K_VPN_IP_SHOW_ALL 0
	_p9k_declare -i POWERLEVEL9K_LOAD_WHICH 5
	case $_POWERLEVEL9K_LOAD_WHICH in
		(1) _POWERLEVEL9K_LOAD_WHICH=1  ;;
		(15) _POWERLEVEL9K_LOAD_WHICH=3  ;;
		(*) _POWERLEVEL9K_LOAD_WHICH=2  ;;
	esac
	_p9k_declare -F POWERLEVEL9K_LOAD_WARNING_PCT 50
	_p9k_declare -F POWERLEVEL9K_LOAD_CRITICAL_PCT 70
	_p9k_declare -b POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY 0
	_p9k_declare -b POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY 0
	_p9k_declare -b POWERLEVEL9K_DOTNET_VERSION_PROJECT_ONLY 1
	_p9k_declare -b POWERLEVEL9K_GO_VERSION_PROJECT_ONLY 1
	_p9k_declare -b POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY 1
	_p9k_declare -b POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY 0
	_p9k_declare -b POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_NODENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_NODENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_RBENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_RBENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_SCALAENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_SCALAENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_PHPENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_PHPENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_LUAENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_LUAENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_JENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_JENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_PLENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_PLENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -b POWERLEVEL9K_PYENV_SHOW_SYSTEM 1
	_p9k_declare -a POWERLEVEL9K_PYENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -a POWERLEVEL9K_GOENV_SOURCES -- shell local global
	_p9k_declare -b POWERLEVEL9K_GOENV_SHOW_SYSTEM 1
	_p9k_declare -b POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW 0
	_p9k_declare -b POWERLEVEL9K_ASDF_SHOW_SYSTEM 1
	_p9k_declare -a POWERLEVEL9K_ASDF_SOURCES -- shell local global
	local var
	for var in ${parameters[(I)POWERLEVEL9K_ASDF_*_PROMPT_ALWAYS_SHOW]}
	do
		_p9k_declare -b $var $_POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW
	done
	for var in ${parameters[(I)POWERLEVEL9K_ASDF_*_SHOW_SYSTEM]}
	do
		_p9k_declare -b $var $_POWERLEVEL9K_ASDF_SHOW_SYSTEM
	done
	for var in ${parameters[(I)POWERLEVEL9K_ASDF_*_SOURCES]}
	do
		_p9k_declare -a $var -- $_POWERLEVEL9K_ASDF_SOURCES
	done
	_p9k_declare -b POWERLEVEL9K_HASKELL_STACK_PROMPT_ALWAYS_SHOW 1
	_p9k_declare -a POWERLEVEL9K_HASKELL_STACK_SOURCES -- shell local
	_p9k_declare -b POWERLEVEL9K_RVM_SHOW_GEMSET 0
	_p9k_declare -b POWERLEVEL9K_RVM_SHOW_PREFIX 0
	_p9k_declare -b POWERLEVEL9K_CHRUBY_SHOW_VERSION 1
	_p9k_declare -b POWERLEVEL9K_CHRUBY_SHOW_ENGINE 1
	_p9k_declare -b POWERLEVEL9K_STATUS_CROSS 0
	_p9k_declare -b POWERLEVEL9K_STATUS_OK 1
	_p9k_declare -b POWERLEVEL9K_STATUS_OK_PIPE 1
	_p9k_declare -b POWERLEVEL9K_STATUS_ERROR 1
	_p9k_declare -b POWERLEVEL9K_STATUS_ERROR_PIPE 1
	_p9k_declare -b POWERLEVEL9K_STATUS_ERROR_SIGNAL 1
	_p9k_declare -b POWERLEVEL9K_STATUS_SHOW_PIPESTATUS 1
	_p9k_declare -b POWERLEVEL9K_STATUS_HIDE_SIGNAME 0
	_p9k_declare -b POWERLEVEL9K_STATUS_VERBOSE_SIGNAME 1
	_p9k_declare -b POWERLEVEL9K_STATUS_EXTENDED_STATES 0
	_p9k_declare -b POWERLEVEL9K_STATUS_VERBOSE 1
	_p9k_declare -b POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE 0
	_p9k_declare -e POWERLEVEL9K_DATE_FORMAT "%D{%d.%m.%y}"
	_p9k_declare -s POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND 1
	_p9k_declare -b POWERLEVEL9K_SHOW_CHANGESET 0
	_p9k_declare -e POWERLEVEL9K_VCS_LOADING_TEXT loading
	_p9k_declare -a POWERLEVEL9K_VCS_GIT_HOOKS -- vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname
	_p9k_declare -a POWERLEVEL9K_VCS_HG_HOOKS -- vcs-detect-changes
	_p9k_declare -a POWERLEVEL9K_VCS_SVN_HOOKS -- vcs-detect-changes svn-detect-changes
	_p9k_declare -F POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS 0.01
	(( POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS >= 0 )) || (( POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS = 0 ))
	_p9k_declare -a POWERLEVEL9K_VCS_BACKENDS -- git
	(( $+commands[git] )) || _POWERLEVEL9K_VCS_BACKENDS=(${_POWERLEVEL9K_VCS_BACKENDS:#git}) 
	_p9k_declare -b POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING 0
	_p9k_declare -i POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY -1
	_p9k_declare -i POWERLEVEL9K_VCS_STAGED_MAX_NUM 1
	_p9k_declare -i POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM 1
	_p9k_declare -i POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM 1
	_p9k_declare -i POWERLEVEL9K_VCS_CONFLICTED_MAX_NUM 1
	_p9k_declare -i POWERLEVEL9K_VCS_COMMITS_AHEAD_MAX_NUM -1
	_p9k_declare -i POWERLEVEL9K_VCS_COMMITS_BEHIND_MAX_NUM -1
	_p9k_declare -b POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS 0
	_p9k_declare -b POWERLEVEL9K_DISABLE_GITSTATUS 0
	_p9k_declare -e POWERLEVEL9K_VI_INSERT_MODE_STRING "INSERT"
	_p9k_declare -e POWERLEVEL9K_VI_COMMAND_MODE_STRING "NORMAL"
	_p9k_declare -e POWERLEVEL9K_VI_VISUAL_MODE_STRING
	_p9k_declare -e POWERLEVEL9K_VI_OVERWRITE_MODE_STRING
	_p9k_declare -s POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV true
	_p9k_declare -b POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION 1
	_p9k_declare -e POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER "("
	_p9k_declare -e POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER ")"
	_p9k_declare -a POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES -- virtualenv venv .venv env
	_POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES="${(j.|.)_POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES}" 
	_p9k_declare -b POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION 1
	_p9k_declare -e POWERLEVEL9K_NODEENV_LEFT_DELIMITER "["
	_p9k_declare -e POWERLEVEL9K_NODEENV_RIGHT_DELIMITER "]"
	_p9k_declare -b POWERLEVEL9K_KUBECONTEXT_SHOW_DEFAULT_NAMESPACE 1
	_p9k_declare -a POWERLEVEL9K_KUBECONTEXT_SHORTEN --
	_p9k_declare -a POWERLEVEL9K_KUBECONTEXT_CLASSES --
	_p9k_declare -a POWERLEVEL9K_AWS_CLASSES --
	_p9k_declare -a POWERLEVEL9K_AZURE_CLASSES --
	_p9k_declare -a POWERLEVEL9K_TERRAFORM_CLASSES --
	_p9k_declare -b POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT 0
	_p9k_declare -a POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES -- 'service_account:*' SERVICE_ACCOUNT
	_p9k_declare -b POWERLEVEL9K_JAVA_VERSION_FULL 1
	_p9k_declare -b POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE 0
	_p9k_declare -e POWERLEVEL9K_TIME_FORMAT "%D{%H:%M:%S}"
	_p9k_declare -b POWERLEVEL9K_TIME_UPDATE_ON_COMMAND 0
	_p9k_declare -b POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME 0
	local -i i=1 
	while (( i <= $#_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS ))
	do
		local segment=${${(U)_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[i]}//İ/I} 
		local var=POWERLEVEL9K_${segment}_LEFT_DISABLED 
		(( $+parameters[$var] )) || var=POWERLEVEL9K_${segment}_DISABLED 
		if [[ ${(P)var} == true ]]
		then
			_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[i,i]=() 
		else
			(( ++i ))
		fi
	done
	local -i i=1 
	while (( i <= $#_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS ))
	do
		local segment=${${(U)_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[i]}//İ/I} 
		local var=POWERLEVEL9K_${segment}_RIGHT_DISABLED 
		(( $+parameters[$var] )) || var=POWERLEVEL9K_${segment}_DISABLED 
		if [[ ${(P)var} == true ]]
		then
			_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[i,i]=() 
		else
			(( ++i ))
		fi
	done
	local var
	for var in ${(@)${parameters[(I)POWERLEVEL9K_*]}/(#m)*/${(M)${parameters[_$MATCH]-$MATCH}:#$MATCH}}
	do
		case $parameters[$var] in
			((scalar|integer|float)*) typeset -g _$var=${(P)var} ;;
			(array*) eval 'typeset -ga '_$var'=("${'$var'[@]}")' ;;
		esac
	done
}
_p9k_init_prompt () {
	_p9k_t=($'\n' $'%{\n%}' '') 
	_p9k_prompt_overflow_bug && _p9k_t[2]=$'%{%G\n%}' 
	_p9k_init_lines
	_p9k_gap_pre='${${:-${_p9k__x::=0}${_p9k__y::=1024}${_p9k__p::=$_p9k__lprompt$_p9k__rprompt}' 
	repeat 10
	do
		_p9k_gap_pre+='${_p9k__m::=$(((_p9k__x+_p9k__y)/2))}' 
		_p9k_gap_pre+='${_p9k__xy::=${${(%):-$_p9k__p%$_p9k__m(l./$_p9k__m;$_p9k__y./$_p9k__x;$_p9k__m)}##*/}}' 
		_p9k_gap_pre+='${_p9k__x::=${_p9k__xy%;*}}' 
		_p9k_gap_pre+='${_p9k__y::=${_p9k__xy#*;}}' 
	done
	_p9k_gap_pre+='${_p9k__m::=$((_p9k__clm-_p9k__x-_p9k__ind-1))}' 
	_p9k_gap_pre+='}+}' 
	_p9k_prompt_prefix_left='${${_p9k__clm::=$COLUMNS}+}${${COLUMNS::=1024}+}' 
	_p9k_prompt_prefix_right='${_p9k__'$#_p9k_line_segments_left'-${${_p9k__clm::=$COLUMNS}+}${${COLUMNS::=1024}+}' 
	_p9k_prompt_suffix_left='${${COLUMNS::=$_p9k__clm}+}' 
	_p9k_prompt_suffix_right='${${COLUMNS::=$_p9k__clm}+}}' 
	if _p9k_segment_in_use vi_mode || _p9k_segment_in_use prompt_char
	then
		_p9k_prompt_prefix_left+='${${_p9k__keymap::=${KEYMAP:-$_p9k__keymap}}+}' 
	fi
	if {
			_p9k_segment_in_use vi_mode && (( $+_POWERLEVEL9K_VI_OVERWRITE_MODE_STRING ))
		} || {
			_p9k_segment_in_use prompt_char && (( _POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE ))
		}
	then
		_p9k_prompt_prefix_left+='${${_p9k__zle_state::=${ZLE_STATE:-$_p9k__zle_state}}+}' 
	fi
	_p9k_prompt_prefix_left+='%b%k%f' 
	if [[ -n $_p9k_line_segments_right[-1] && $_p9k_line_never_empty_right[-1] == 0 && $ZLE_RPROMPT_INDENT == 0 ]] && _p9k_all_params_eq '_POWERLEVEL9K_*WHITESPACE_BETWEEN_RIGHT_SEGMENTS' ' ' && _p9k_all_params_eq '_POWERLEVEL9K_*RIGHT_RIGHT_WHITESPACE' ' ' && _p9k_all_params_eq '_POWERLEVEL9K_*RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL' '' && ! is-at-least 5.7.2
	then
		_p9k_emulate_zero_rprompt_indent=1 
		_p9k_prompt_prefix_left+='${${:-${_p9k__real_zle_rprompt_indent:=$ZLE_RPROMPT_INDENT}${ZLE_RPROMPT_INDENT::=1}${_p9k__ind::=0}}+}' 
		_p9k_line_suffix_right[-1]='${_p9k__sss:+${_p9k__sss% }%E}}' 
	else
		_p9k_emulate_zero_rprompt_indent=0 
		_p9k_prompt_prefix_left+='${${_p9k__ind::=${${ZLE_RPROMPT_INDENT:-1}/#-*/0}}+}' 
	fi
	if (( _POWERLEVEL9K_TERM_SHELL_INTEGRATION ))
	then
		_p9k_prompt_prefix_left+=$'%{\e]133;A\a%}' 
		_p9k_prompt_suffix_left+=$'%{\e]133;B\a%}' 
		if (( $+_z4h_iterm_cmd && _z4h_can_save_restore_screen == 1 ))
		then
			_p9k_prompt_prefix_left+=$'%{\ePtmux;\e\e]133;A\a\e\\%}' 
			_p9k_prompt_suffix_left+=$'%{\ePtmux;\e\e]133;B\a\e\\%}' 
		fi
	fi
	if (( _POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT > 0 ))
	then
		_p9k_t+=${(pl.$_POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT..\n.)} 
	else
		_p9k_t+='' 
	fi
	_p9k_empty_line_idx=$#_p9k_t 
	if (( __p9k_ksh_arrays ))
	then
		_p9k_prompt_prefix_left+='${_p9k_t[${_p9k__empty_line_i:-'$#_p9k_t'}-1]}' 
	else
		_p9k_prompt_prefix_left+='${_p9k_t[${_p9k__empty_line_i:-'$#_p9k_t'}]}' 
	fi
	local -i num_lines=$#_p9k_line_segments_left 
	if (( $+terminfo[cuu1] ))
	then
		_p9k_escape $terminfo[cuu1]
		if (( __p9k_ksh_arrays ))
		then
			local scroll=$'${_p9k_t[${_p9k__ruler_i:-1}-1]:+\n'$_p9k__ret'}' 
		else
			local scroll=$'${_p9k_t[${_p9k__ruler_i:-1}]:+\n'$_p9k__ret'}' 
		fi
		if (( num_lines > 1 ))
		then
			local -i line_index= 
			for line_index in {1..$((num_lines-1))}
			do
				scroll='${_p9k__'$line_index-$'\n}'$scroll'${_p9k__'$line_index-$_p9k__ret'}' 
			done
		fi
		_p9k_prompt_prefix_left+='%{${_p9k__ipe-'$scroll'}%}' 
	fi
	_p9k_get_icon '' RULER_CHAR
	local ruler_char=$_p9k__ret 
	_p9k_prompt_length $ruler_char
	(( _p9k__ret == 1 && $#ruler_char == 1 )) || ruler_char=' ' 
	_p9k_color prompt_ruler BACKGROUND ""
	if [[ -z $_p9k__ret && $ruler_char == ' ' ]]
	then
		local ruler=$'\n' 
	else
		_p9k_background $_p9k__ret
		local ruler=%b$_p9k__ret 
		_p9k_color prompt_ruler FOREGROUND ""
		_p9k_foreground $_p9k__ret
		ruler+=$_p9k__ret 
		[[ $ruler_char == '.' ]] && local sep=','  || local sep='.' 
		ruler+='${(pl'$sep'${$((_p9k__clm-_p9k__ind))/#-*/0}'$sep$sep$ruler_char$sep')}%k%f' 
		if (( __p9k_ksh_arrays ))
		then
			ruler+='${_p9k_t[$((!_p9k__ind))]}' 
		else
			ruler+='${_p9k_t[$((1+!_p9k__ind))]}' 
		fi
	fi
	_p9k_t+=$ruler 
	_p9k_ruler_idx=$#_p9k_t 
	if (( __p9k_ksh_arrays ))
	then
		_p9k_prompt_prefix_left+='${(e)_p9k_t[${_p9k__ruler_i:-'$#_p9k_t'}-1]}' 
	else
		_p9k_prompt_prefix_left+='${(e)_p9k_t[${_p9k__ruler_i:-'$#_p9k_t'}]}' 
	fi
	(
		_p9k_segment_in_use time && (( _POWERLEVEL9K_TIME_UPDATE_ON_COMMAND ))
	)
	_p9k_reset_on_line_finish=$((!$?)) 
	_p9k_t+=$_p9k_gap_pre 
	_p9k_gap_pre='${(e)_p9k_t['$(($#_p9k_t - __p9k_ksh_arrays))']}' 
	_p9k_t+=$_p9k_prompt_prefix_left 
	_p9k_prompt_prefix_left='${(e)_p9k_t['$(($#_p9k_t - __p9k_ksh_arrays))']}' 
}
_p9k_init_ssh () {
	[[ -n $P9K_SSH ]] && return
	typeset -gix P9K_SSH=0 
	if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]
	then
		P9K_SSH=1 
		return 0
	fi
	(( $+commands[who] )) || return
	local ipv6='(([0-9a-fA-F]+:)|:){2,}[0-9a-fA-F]+' 
	local ipv4='([0-9]{1,3}\.){3}[0-9]+' 
	local hostname='([.][^. ]+){2}' 
	local w
	w="$(who -m 2>/dev/null)"  || w=${(@M)${(f)"$(who 2>/dev/null)"}:#*[[:space:]]${TTY#/dev/}[[:space:]]*} 
	[[ $w =~ "\(?($ipv4|$ipv6|$hostname)\)?\$" ]] && P9K_SSH=1 
}
_p9k_init_toolbox () {
	[[ -z $P9K_TOOLBOX_NAME ]] || return 0
	if [[ -f /run/.containerenv && -r /run/.containerenv ]]
	then
		local name=(${(Q)${${(@M)${(f)"$(</run/.containerenv)"}:#name=*}#name=}}) 
		[[ ${#name} -eq 1 && -n ${name[1]} ]] || return 0
		typeset -g P9K_TOOLBOX_NAME=${name[1]} 
	elif [[ -n $DISTROBOX_ENTER_PATH && -n $NAME ]]
	then
		local name=${(%):-%m} 
		if [[ $name == $NAME* ]]
		then
			typeset -g P9K_TOOLBOX_NAME=$name 
		fi
	fi
}
_p9k_init_vars () {
	typeset -gF _p9k__gcloud_last_fetch_ts
	typeset -g _p9k_gcloud_configuration
	typeset -g _p9k_gcloud_account
	typeset -g _p9k_gcloud_project_id
	typeset -g _p9k_gcloud_project_name
	typeset -gi _p9k_term_has_href
	typeset -gi _p9k_vcs_index
	typeset -gi _p9k_vcs_line_index
	typeset -g _p9k_vcs_side
	typeset -ga _p9k_taskwarrior_meta_files
	typeset -ga _p9k_taskwarrior_meta_non_files
	typeset -g _p9k_taskwarrior_meta_sig
	typeset -g _p9k_taskwarrior_data_dir
	typeset -g _p9k__taskwarrior_functional=1 
	typeset -ga _p9k_taskwarrior_data_files
	typeset -ga _p9k_taskwarrior_data_non_files
	typeset -g _p9k_taskwarrior_data_sig
	typeset -gA _p9k_taskwarrior_counters
	typeset -gF _p9k_taskwarrior_next_due
	typeset -ga _p9k_asdf_meta_files
	typeset -ga _p9k_asdf_meta_non_files
	typeset -g _p9k_asdf_meta_sig
	typeset -gA _p9k_asdf_plugins
	typeset -gA _p9k_asdf_file_info
	typeset -gA _p9k__asdf_dir2files
	typeset -gA _p9k_asdf_file2versions
	typeset -gA _p9k__read_word_cache
	typeset -gA _p9k__read_pyenv_like_version_file_cache
	typeset -ga _p9k__parent_dirs
	typeset -ga _p9k__parent_mtimes
	typeset -ga _p9k__parent_mtimes_i
	typeset -g _p9k__parent_mtimes_s
	typeset -g _p9k__cwd
	typeset -g _p9k__cwd_a
	typeset -gA _p9k__glob_cache
	typeset -gA _p9k__upsearch_cache
	typeset -g _p9k_timewarrior_dir
	typeset -gi _p9k_timewarrior_dir_mtime
	typeset -gi _p9k_timewarrior_file_mtime
	typeset -g _p9k_timewarrior_file_name
	typeset -gA _p9k__prompt_char_saved
	typeset -g _p9k__worker_pid
	typeset -g _p9k__worker_req_fd
	typeset -g _p9k__worker_resp_fd
	typeset -g _p9k__worker_shell_pid
	typeset -g _p9k__worker_file_prefix
	typeset -gA _p9k__worker_request_map
	typeset -ga _p9k__segment_cond_left
	typeset -ga _p9k__segment_cond_right
	typeset -ga _p9k__segment_val_left
	typeset -ga _p9k__segment_val_right
	typeset -ga _p9k_show_on_command
	typeset -g _p9k__last_buffer
	typeset -ga _p9k__last_commands
	typeset -gi _p9k__fully_initialized
	typeset -gi _p9k__must_restore_prompt
	typeset -gi _p9k__restore_prompt_fd
	typeset -gi _p9k__redraw_fd
	typeset -gi _p9k__can_hide_cursor=$(( $+terminfo[civis] && $+terminfo[cnorm] )) 
	typeset -gi _p9k__cursor_hidden
	typeset -gi _p9k__non_hermetic_expansion
	typeset -g _p9k__time
	typeset -g _p9k__date
	typeset -gA _p9k_dumped_instant_prompt_sigs
	typeset -g _p9k__instant_prompt_sig
	typeset -g _p9k__instant_prompt
	typeset -gi _p9k__state_dump_scheduled
	typeset -gi _p9k__state_dump_fd
	typeset -gi _p9k__prompt_idx
	typeset -gi _p9k_reset_on_line_finish
	typeset -gF _p9k__timer_start
	typeset -gi _p9k__status
	typeset -ga _p9k__pipestatus
	typeset -g _p9k__ret
	typeset -g _p9k__cache_key
	typeset -ga _p9k__cache_val
	typeset -g _p9k__cache_stat_meta
	typeset -g _p9k__cache_stat_fprint
	typeset -g _p9k__cache_fprint_key
	typeset -gA _p9k_cache
	typeset -gA _p9k__cache_ephemeral
	typeset -ga _p9k_t
	typeset -g _p9k__n
	typeset -gi _p9k__i
	typeset -g _p9k__bg
	typeset -ga _p9k_left_join
	typeset -ga _p9k_right_join
	typeset -g _p9k__public_ip
	typeset -g _p9k__todo_command
	typeset -g _p9k__todo_file
	typeset -g _p9k__git_dir
	typeset -gA _p9k_git_slow
	typeset -gA _p9k__gitstatus_last
	typeset -gF _p9k__gitstatus_start_time
	typeset -g _p9k__prompt
	typeset -g _p9k__rprompt
	typeset -g _p9k__lprompt
	typeset -g _p9k__prompt_side
	typeset -g _p9k__segment_name
	typeset -gi _p9k__segment_index
	typeset -gi _p9k__line_index
	typeset -g _p9k__refresh_reason
	typeset -gi _p9k__region_active
	typeset -ga _p9k_line_segments_left
	typeset -ga _p9k_line_segments_right
	typeset -ga _p9k_line_prefix_left
	typeset -ga _p9k_line_prefix_right
	typeset -ga _p9k_line_suffix_left
	typeset -ga _p9k_line_suffix_right
	typeset -ga _p9k_line_never_empty_right
	typeset -ga _p9k_line_gap_post
	typeset -g _p9k__xy
	typeset -g _p9k__clm
	typeset -g _p9k__p
	typeset -gi _p9k__x
	typeset -gi _p9k__y
	typeset -gi _p9k__m
	typeset -gi _p9k__d
	typeset -gi _p9k__h
	typeset -gi _p9k__ind
	typeset -g _p9k_gap_pre
	typeset -gi _p9k__ruler_i=3 
	typeset -gi _p9k_ruler_idx
	typeset -gi _p9k__empty_line_i=3 
	typeset -gi _p9k_empty_line_idx
	typeset -g _p9k_prompt_prefix_left
	typeset -g _p9k_prompt_prefix_right
	typeset -g _p9k_prompt_suffix_left
	typeset -g _p9k_prompt_suffix_right
	typeset -gi _p9k_emulate_zero_rprompt_indent
	typeset -gA _p9k_battery_states
	typeset -g _p9k_os
	typeset -g _p9k_os_icon
	typeset -g _p9k_color1
	typeset -g _p9k_color2
	typeset -g _p9k__s
	typeset -g _p9k__ss
	typeset -g _p9k__sss
	typeset -g _p9k__v
	typeset -g _p9k__c
	typeset -g _p9k__e
	typeset -g _p9k__w
	typeset -gi _p9k__dir_len
	typeset -gi _p9k_num_cpus
	typeset -g _p9k__keymap
	typeset -g _p9k__zle_state
	typeset -g _p9k_uname
	typeset -g _p9k_uname_o
	typeset -g _p9k_uname_m
	typeset -g _p9k_transient_prompt
	typeset -g _p9k__last_prompt_pwd
	typeset -gA _p9k_display_k
	typeset -ga _p9k__display_v
	typeset -gA _p9k__dotnet_stat_cache
	typeset -gA _p9k__dir_stat_cache
	typeset -gi _p9k__expanded
	typeset -gi _p9k__force_must_init
	typeset -g P9K_VISUAL_IDENTIFIER
	typeset -g P9K_CONTENT
	typeset -g P9K_GAP
	typeset -g P9K_PROMPT=regular 
}
_p9k_init_vcs () {
	if ! _p9k_segment_in_use vcs || (( ! $#_POWERLEVEL9K_VCS_BACKENDS ))
	then
		(( $+functions[gitstatus_stop_p9k_] )) && gitstatus_stop_p9k_ POWERLEVEL9K
		unset _p9k_preinit
		return
	fi
	_p9k_vcs_info_init
	if (( $+functions[_p9k_preinit] ))
	then
		if (( $+GITSTATUS_DAEMON_PID_POWERLEVEL9K ))
		then
			() {
				trap 'return 130' INT
				{
					gitstatus_start_p9k_ POWERLEVEL9K
				} always {
					trap ':' INT
				}
			}
		fi
		(( $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )) || _p9k__instant_prompt_disabled=1 
		return 0
	fi
	(( _POWERLEVEL9K_DISABLE_GITSTATUS )) && return
	(( $_POWERLEVEL9K_VCS_BACKENDS[(I)git] )) || return
	local gitstatus_dir=${_POWERLEVEL9K_GITSTATUS_DIR:-${__p9k_root_dir}/gitstatus} 
	typeset -g _p9k_preinit="function _p9k_preinit() {
    (( $+commands[git] )) || { unfunction _p9k_preinit; return 1 }
    [[ \$ZSH_VERSION == ${(q)ZSH_VERSION} ]]                      || return
    [[ -r ${(q)gitstatus_dir}/gitstatus.plugin.zsh ]]             || return
    builtin source ${(q)gitstatus_dir}/gitstatus.plugin.zsh _p9k_ || return
    GITSTATUS_AUTO_INSTALL=${(q)GITSTATUS_AUTO_INSTALL}               GITSTATUS_DAEMON=${(q)GITSTATUS_DAEMON}                         GITSTATUS_CACHE_DIR=${(q)GITSTATUS_CACHE_DIR}                   GITSTATUS_NUM_THREADS=${(q)GITSTATUS_NUM_THREADS}               GITSTATUS_LOG_LEVEL=${(q)GITSTATUS_LOG_LEVEL}                   GITSTATUS_ENABLE_LOGGING=${(q)GITSTATUS_ENABLE_LOGGING}           gitstatus_start_p9k_                                              -s $_POWERLEVEL9K_VCS_STAGED_MAX_NUM                            -u $_POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM                          -d $_POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM                         -c $_POWERLEVEL9K_VCS_CONFLICTED_MAX_NUM                        -m $_POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY                      ${${_POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS:#0}:+-e}           -a POWERLEVEL9K
  }" 
	builtin source $gitstatus_dir/gitstatus.plugin.zsh _p9k_ || return
	() {
		trap 'return 130' INT
		{
			gitstatus_start_p9k_ -s $_POWERLEVEL9K_VCS_STAGED_MAX_NUM -u $_POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM -d $_POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM -c $_POWERLEVEL9K_VCS_CONFLICTED_MAX_NUM -m $_POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY ${${_POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS:#0}:+-e} POWERLEVEL9K
		} always {
			trap ':' INT
		}
	}
	(( $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )) || _p9k__instant_prompt_disabled=1 
}
_p9k_iterm2_precmd () {
	builtin zle && return
	if (( _p9k__iterm_cmd )) && [[ -t 1 ]]
	then
		(( _p9k__iterm_cmd == 1 )) && builtin print -n '\e]133;C;\a'
		builtin printf '\e]133;D;%s\a' $1
	fi
	typeset -gi _p9k__iterm_cmd=1 
}
_p9k_iterm2_preexec () {
	[[ -t 1 ]] && builtin print -n '\e]133;C;\a'
	typeset -gi _p9k__iterm_cmd=2 
}
_p9k_jenv_global_version () {
	_p9k_read_word ${JENV_ROOT:-$HOME/.jenv}/version || _p9k__ret=system 
}
_p9k_left_prompt_segment () {
	if ! _p9k_cache_get "$0" "$1" "$2" "$3" "$4" "$_p9k__segment_index"
	then
		_p9k_color $1 BACKGROUND $2
		local bg_color=$_p9k__ret 
		_p9k_background $bg_color
		local bg=$_p9k__ret 
		_p9k_color $1 FOREGROUND $3
		local fg_color=$_p9k__ret 
		_p9k_foreground $fg_color
		local fg=$_p9k__ret 
		local style=%b$bg$fg 
		local style_=${style//\}/\\\}} 
		_p9k_get_icon $1 LEFT_SEGMENT_SEPARATOR
		local sep=$_p9k__ret 
		_p9k_escape $_p9k__ret
		local sep_=$_p9k__ret 
		_p9k_get_icon $1 LEFT_SUBSEGMENT_SEPARATOR
		_p9k_escape $_p9k__ret
		local subsep_=$_p9k__ret 
		local icon_
		if [[ -n $4 ]]
		then
			_p9k_get_icon $1 $4
			_p9k_escape $_p9k__ret
			icon_=$_p9k__ret 
		fi
		_p9k_get_icon $1 LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL
		local start_sep=$_p9k__ret 
		[[ -n $start_sep ]] && start_sep="%b%k%F{$bg_color}$start_sep" 
		_p9k_get_icon $1 LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL $sep
		_p9k_escape $_p9k__ret
		local end_sep_=$_p9k__ret 
		_p9k_get_icon $1 WHITESPACE_BETWEEN_LEFT_SEGMENTS ' '
		local space=$_p9k__ret 
		_p9k_get_icon $1 LEFT_LEFT_WHITESPACE $space
		local left_space=$_p9k__ret 
		[[ $left_space == *%* ]] && left_space+=$style 
		_p9k_get_icon $1 LEFT_RIGHT_WHITESPACE $space
		_p9k_escape $_p9k__ret
		local right_space_=$_p9k__ret 
		[[ $right_space_ == *%* ]] && right_space_+=$style_ 
		local s='<_p9k__s>' ss='<_p9k__ss>' 
		local -i non_hermetic=0 
		local t=$(($#_p9k_t - __p9k_ksh_arrays)) 
		_p9k_t+=$start_sep$style$left_space 
		_p9k_t+=$style 
		if [[ -n $fg_color && $fg_color == $bg_color ]]
		then
			if [[ $fg_color == $_p9k_color1 ]]
			then
				_p9k_foreground $_p9k_color2
			else
				_p9k_foreground $_p9k_color1
			fi
			_p9k_t+=%b$bg$_p9k__ret$ss$style$left_space 
		else
			_p9k_t+=%b$bg$ss$style$left_space 
		fi
		_p9k_t+=%b$bg$s$style$left_space 
		local join="_p9k__i>=$_p9k_left_join[$_p9k__segment_index]" 
		_p9k_param $1 SELF_JOINED false
		if [[ $_p9k__ret == false ]]
		then
			if (( _p9k__segment_index > $_p9k_left_join[$_p9k__segment_index] ))
			then
				join+="&&_p9k__i<$_p9k__segment_index" 
			else
				join= 
			fi
		fi
		local p= 
		p+="\${_p9k__n::=}" 
		p+="\${\${\${_p9k__bg:-0}:#NONE}:-\${_p9k__n::=$((t+1))}}" 
		if [[ -n $join ]]
		then
			p+="\${_p9k__n:=\${\${\$(($join)):#0}:+$((t+2))}}" 
		fi
		if (( __p9k_sh_glob ))
		then
			p+="\${_p9k__n:=\${\${(M)\${:-x$bg_color}:#x\$_p9k__bg}:+$((t+3))}}" 
			p+="\${_p9k__n:=\${\${(M)\${:-x$bg_color}:#x\$${_p9k__bg:-0}}:+$((t+3))}}" 
		else
			p+="\${_p9k__n:=\${\${(M)\${:-x$bg_color}:#x(\$_p9k__bg|\${_p9k__bg:-0})}:+$((t+3))}}" 
		fi
		p+="\${_p9k__n:=$((t+4))}" 
		_p9k_param $1 VISUAL_IDENTIFIER_EXPANSION '${P9K_VISUAL_IDENTIFIER}'
		[[ $_p9k__ret == (|*[^\\])'$('* ]] && non_hermetic=1 
		local icon_exp_=${_p9k__ret:+\"$_p9k__ret\"} 
		_p9k_param $1 CONTENT_EXPANSION '${P9K_CONTENT}'
		[[ $_p9k__ret == (|*[^\\])'$('* ]] && non_hermetic=1 
		local content_exp_=${_p9k__ret:+\"$_p9k__ret\"} 
		if [[ ( $icon_exp_ != '"${P9K_VISUAL_IDENTIFIER}"' && $icon_exp_ == *'$'* ) || ( $content_exp_ != '"${P9K_CONTENT}"' && $content_exp_ == *'$'* ) ]]
		then
			p+="\${P9K_VISUAL_IDENTIFIER::=$icon_}" 
		fi
		local -i has_icon=-1 
		if [[ $icon_exp_ != '"${P9K_VISUAL_IDENTIFIER}"' && $icon_exp_ == *'$'* ]]
		then
			p+='${_p9k__v::='$icon_exp_$style_'}' 
		else
			[[ $icon_exp_ == '"${P9K_VISUAL_IDENTIFIER}"' ]] && _p9k__ret=$icon_  || _p9k__ret=$icon_exp_ 
			if [[ -n $_p9k__ret ]]
			then
				p+="\${_p9k__v::=$_p9k__ret" 
				[[ $_p9k__ret == *%* ]] && p+=$style_ 
				p+="}" 
				has_icon=1 
			else
				has_icon=0 
			fi
		fi
		p+='${_p9k__c::='$content_exp_'}${_p9k__c::=${_p9k__c//'$'\r''}}' 
		p+='${_p9k__e::=${${_p9k__'${_p9k__line_index}l${${1#prompt_}%%[A-Z0-9_]#}'+00}:-' 
		if (( has_icon == -1 ))
		then
			p+='${${(%):-$_p9k__c%1(l.1.0)}[-1]}${${(%):-$_p9k__v%1(l.1.0)}[-1]}}' 
		else
			p+='${${(%):-$_p9k__c%1(l.1.0)}[-1]}'$has_icon'}' 
		fi
		p+='}}+}' 
		p+='${${_p9k__e:#00}:+${${_p9k_t[$_p9k__n]/'$ss'/$_p9k__ss}/'$s'/$_p9k__s}' 
		_p9k_param $1 ICON_BEFORE_CONTENT ''
		if [[ $_p9k__ret != false ]]
		then
			_p9k_param $1 PREFIX ''
			_p9k__ret=${(g::)_p9k__ret} 
			_p9k_escape $_p9k__ret
			p+=$_p9k__ret 
			[[ $_p9k__ret == *%* ]] && local -i need_style=1  || local -i need_style=0 
			if (( has_icon != 0 ))
			then
				_p9k_color $1 VISUAL_IDENTIFIER_COLOR $fg_color
				_p9k_foreground $_p9k__ret
				_p9k__ret=%b$bg$_p9k__ret 
				_p9k__ret=${_p9k__ret//\}/\\\}} 
				if [[ $_p9k__ret != $style_ ]]
				then
					p+=$_p9k__ret'${_p9k__v}'$style_ 
				else
					(( need_style )) && p+=$style_ 
					p+='${_p9k__v}' 
				fi
				_p9k_get_icon $1 LEFT_MIDDLE_WHITESPACE ' '
				if [[ -n $_p9k__ret ]]
				then
					_p9k_escape $_p9k__ret
					[[ _p9k__ret == *%* ]] && _p9k__ret+=$style_ 
					p+='${${(M)_p9k__e:#11}:+'$_p9k__ret'}' 
				fi
			elif (( need_style ))
			then
				p+=$style_ 
			fi
			p+='${_p9k__c}'$style_ 
		else
			_p9k_param $1 PREFIX ''
			_p9k__ret=${(g::)_p9k__ret} 
			_p9k_escape $_p9k__ret
			p+=$_p9k__ret 
			[[ $_p9k__ret == *%* ]] && p+=$style_ 
			p+='${_p9k__c}'$style_ 
			if (( has_icon != 0 ))
			then
				local -i need_style=0 
				_p9k_get_icon $1 LEFT_MIDDLE_WHITESPACE ' '
				if [[ -n $_p9k__ret ]]
				then
					_p9k_escape $_p9k__ret
					[[ $_p9k__ret == *%* ]] && need_style=1 
					p+='${${(M)_p9k__e:#11}:+'$_p9k__ret'}' 
				fi
				_p9k_color $1 VISUAL_IDENTIFIER_COLOR $fg_color
				_p9k_foreground $_p9k__ret
				_p9k__ret=%b$bg$_p9k__ret 
				_p9k__ret=${_p9k__ret//\}/\\\}} 
				[[ $_p9k__ret != $style_ || $need_style == 1 ]] && p+=$_p9k__ret 
				p+='$_p9k__v' 
			fi
		fi
		_p9k_param $1 SUFFIX ''
		_p9k__ret=${(g::)_p9k__ret} 
		_p9k_escape $_p9k__ret
		p+=$_p9k__ret 
		[[ $_p9k__ret == *%* && -n $right_space_ ]] && p+=$style_ 
		p+=$right_space_ 
		p+='${${:-' 
		p+="\${_p9k__s::=%F{$bg_color\}$sep_}\${_p9k__ss::=$subsep_}\${_p9k__sss::=%F{$bg_color\}$end_sep_}" 
		p+="\${_p9k__i::=$_p9k__segment_index}\${_p9k__bg::=$bg_color}" 
		p+='}+}' 
		p+='}' 
		_p9k_param $1 SHOW_ON_UPGLOB ''
		_p9k_cache_set "$p" $non_hermetic $_p9k__ret
	fi
	if [[ -n $_p9k__cache_val[3] ]]
	then
		_p9k__has_upglob=1 
		_p9k_upglob $_p9k__cache_val[3] && return
	fi
	_p9k__non_hermetic_expansion=$_p9k__cache_val[2] 
	(( $5 )) && _p9k__ret=\"$7\"  || _p9k_escape $7
	if [[ -z $6 ]]
	then
		_p9k__prompt+="\${\${:-\${P9K_CONTENT::=$_p9k__ret}$_p9k__cache_val[1]" 
	else
		_p9k__prompt+="\${\${:-\"$6\"}:+\${\${:-\${P9K_CONTENT::=$_p9k__ret}$_p9k__cache_val[1]}" 
	fi
}
_p9k_luaenv_global_version () {
	_p9k_read_word ${LUAENV_ROOT:-$HOME/.luaenv}/version || _p9k__ret=system 
}
_p9k_maybe_ignore_git_repo () {
	if [[ $VCS_STATUS_RESULT == ok-* && $VCS_STATUS_WORKDIR == $~_POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN ]]
	then
		VCS_STATUS_RESULT=norepo${VCS_STATUS_RESULT#ok} 
	fi
}
_p9k_must_init () {
	(( _POWERLEVEL9K_DISABLE_HOT_RELOAD && !_p9k__force_must_init )) && return 1
	_p9k__force_must_init=0 
	local IFS sig
	if [[ -n $_p9k__param_sig ]]
	then
		IFS=$'\2' sig="${(e)_p9k__param_pat}" 
		[[ $sig == $_p9k__param_sig ]] && return 1
		_p9k_deinit
	fi
	_p9k__param_pat=$'v134\1'${(q)ZSH_VERSION}$'\1'${(q)ZSH_PATCHLEVEL}$'\1' 
	_p9k__param_pat+=$__p9k_force_term_shell_integration$'\1' 
	_p9k__param_pat+=$'${#parameters[(I)POWERLEVEL9K_*]}\1${(%):-%n%#}\1$GITSTATUS_LOG_LEVEL\1' 
	_p9k__param_pat+=$'$GITSTATUS_ENABLE_LOGGING\1$GITSTATUS_DAEMON\1$GITSTATUS_NUM_THREADS\1' 
	_p9k__param_pat+=$'$GITSTATUS_CACHE_DIR\1$GITSTATUS_AUTO_INSTALL\1${ZLE_RPROMPT_INDENT:-1}\1' 
	_p9k__param_pat+=$'$__p9k_sh_glob\1$__p9k_ksh_arrays\1$ITERM_SHELL_INTEGRATION_INSTALLED\1' 
	_p9k__param_pat+=$'${PROMPT_EOL_MARK-%B%S%#%s%b}\1$+commands[locale]\1$langinfo[CODESET]\1' 
	_p9k__param_pat+=$'${(M)VTE_VERSION:#(<1-4602>|4801)}\1$DEFAULT_USER\1$P9K_SSH\1$+commands[uname]\1' 
	_p9k__param_pat+=$'$__p9k_root_dir\1$functions[p10k-on-init]\1$functions[p10k-on-pre-prompt]\1' 
	_p9k__param_pat+=$'$functions[p10k-on-post-widget]\1$functions[p10k-on-post-prompt]\1' 
	_p9k__param_pat+=$'$+commands[git]\1$terminfo[colors]\1${+_z4h_iterm_cmd}\1' 
	_p9k__param_pat+=$'$_z4h_can_save_restore_screen' 
	local MATCH
	IFS=$'\1' _p9k__param_pat+="${(@)${(@o)parameters[(I)POWERLEVEL9K_*]}:/(#m)*/\${${(q)MATCH}-$IFS\}}" 
	IFS=$'\2' _p9k__param_sig="${(e)_p9k__param_pat}" 
}
_p9k_nodeenv_version_transform () {
	local dir=${NODENV_ROOT:-$HOME/.nodenv}/versions 
	[[ -z $1 || $1 == system ]] && _p9k__ret=$1  && return
	[[ -d $dir/$1 ]] && _p9k__ret=$1  && return
	[[ -d $dir/${1/v} ]] && _p9k__ret=${1/v}  && return
	[[ -d $dir/${1#node-} ]] && _p9k__ret=${1#node-}  && return
	[[ -d $dir/${1#node-v} ]] && _p9k__ret=${1#node-v}  && return
	return 1
}
_p9k_nodenv_global_version () {
	_p9k_read_word ${NODENV_ROOT:-$HOME/.nodenv}/version || _p9k__ret=system 
}
_p9k_nvm_ls_current () {
	local node_path=${commands[node]:A} 
	[[ -n $node_path ]] || return
	local nvm_dir=${NVM_DIR:A} 
	if [[ -n $nvm_dir && $node_path == $nvm_dir/versions/io.js/* ]]
	then
		_p9k_cached_cmd 0 '' iojs --version || return
		_p9k__ret=iojs-v${_p9k__ret#v} 
	elif [[ -n $nvm_dir && $node_path == $nvm_dir/* ]]
	then
		_p9k_cached_cmd 0 '' node --version || return
		_p9k__ret=v${_p9k__ret#v} 
	else
		_p9k__ret=system 
	fi
}
_p9k_nvm_ls_default () {
	local v=default 
	local -a seen=($v) 
	while [[ -r $NVM_DIR/alias/$v ]]
	do
		local target= 
		IFS='' read -r target < $NVM_DIR/alias/$v
		target=${target%$'\r'} 
		[[ -z $target ]] && break
		(( $seen[(I)$target] )) && return
		seen+=$target 
		v=$target 
	done
	case $v in
		(default | N/A) return 1 ;;
		(system | v) _p9k__ret=system 
			return 0 ;;
		(iojs-[0-9]*) v=iojs-v${v#iojs-}  ;;
		([0-9]*) v=v$v  ;;
	esac
	if [[ $v == v*.*.* ]]
	then
		if [[ -x $NVM_DIR/versions/node/$v/bin/node || -x $NVM_DIR/$v/bin/node ]]
		then
			_p9k__ret=$v 
			return 0
		elif [[ -x $NVM_DIR/versions/io.js/$v/bin/node ]]
		then
			_p9k__ret=iojs-$v 
			return 0
		else
			return 1
		fi
	fi
	local -a dirs=() 
	case $v in
		(node | node- | stable) dirs=($NVM_DIR/versions/node $NVM_DIR) 
			v='(v[1-9]*|v0.*[02468].*)'  ;;
		(unstable) dirs=($NVM_DIR/versions/node $NVM_DIR) 
			v='v0.*[13579].*'  ;;
		(iojs*) dirs=($NVM_DIR/versions/io.js) 
			v=v${${${v#iojs}#-}#v}'*'  ;;
		(*) dirs=($NVM_DIR/versions/node $NVM_DIR $NVM_DIR/versions/io.js) 
			v=v${v#v}'*'  ;;
	esac
	local -a matches=(${^dirs}/${~v}(/N)) 
	(( $#matches )) || return
	local max path
	for path in ${(Oa)matches}
	do
		[[ ${path:t} == (#b)v(*).(*).(*) ]] || continue
		v=${(j::)${(@l:6::0:)match}} 
		[[ $v > $max ]] || continue
		max=$v 
		_p9k__ret=${path:t} 
		[[ ${path:h:t} != io.js ]] || _p9k__ret=iojs-$_p9k__ret 
	done
	[[ -n $max ]]
}
_p9k_on_expand () {
	(( _p9k__expanded && ! ${+__p9k_instant_prompt_active} )) && [[ "${langinfo[CODESET]}" == (utf|UTF)(-|)8 ]] && return
	eval "$__p9k_intro_no_locale"
	if [[ $langinfo[CODESET] != (utf|UTF)(-|)8 ]]
	then
		_p9k_restore_special_params
		if [[ $langinfo[CODESET] != (utf|UTF)(-|)8 ]] && _p9k_init_locale
		then
			if [[ -n $LC_ALL ]]
			then
				_p9k__real_lc_all=$LC_ALL 
				LC_ALL=$__p9k_locale 
			else
				_p9k__real_lc_ctype=$LC_CTYPE 
				LC_CTYPE=$__p9k_locale 
			fi
		fi
	fi
	(( _p9k__expanded && ! $+__p9k_instant_prompt_active )) && return
	eval "$__p9k_intro_locale"
	if (( ! _p9k__expanded ))
	then
		if _p9k_should_dump
		then
			sysopen -o cloexec -ru _p9k__state_dump_fd /dev/null
			zle -F $_p9k__state_dump_fd _p9k_do_dump
		fi
		if [[ -z $P9K_TTY || ( $P9K_TTY == old && -n ${_P9K_TTY:#$TTY} ) ]]
		then
			typeset -gx P9K_TTY=old 
			if (( _POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS < 0 ))
			then
				P9K_TTY=new 
			else
				local -a stat
				if zstat -A stat +ctime -- $TTY 2> /dev/null && (( EPOCHREALTIME - stat[1] < _POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS ))
				then
					P9K_TTY=new 
				fi
			fi
		fi
		typeset -gx _P9K_TTY=$TTY 
		__p9k_reset_state=1 
		if (( _POWERLEVEL9K_PROMPT_ADD_NEWLINE ))
		then
			if [[ $P9K_TTY == new ]]
			then
				_p9k__empty_line_i=3 
				_p9k__display_v[2]=hide 
			elif [[ -z $_p9k_transient_prompt && $+functions[p10k-on-post-prompt] == 0 ]]
			then
				_p9k__empty_line_i=3 
				_p9k__display_v[2]=print 
			else
				unset _p9k__empty_line_i
				_p9k__display_v[2]=show 
			fi
		fi
		if (( _POWERLEVEL9K_SHOW_RULER ))
		then
			if [[ $P9K_TTY == new ]]
			then
				_p9k__ruler_i=3 
				_p9k__display_v[4]=hide 
			elif [[ -z $_p9k_transient_prompt && $+functions[p10k-on-post-prompt] == 0 ]]
			then
				_p9k__ruler_i=3 
				_p9k__display_v[4]=print 
			else
				unset _p9k__ruler_i
				_p9k__display_v[4]=show 
			fi
		fi
		(( _p9k__fully_initialized )) || _p9k_wrap_widgets
	fi
	if (( $+__p9k_instant_prompt_active ))
	then
		_p9k_clear_instant_prompt
		unset __p9k_instant_prompt_active
	fi
	if (( ! _p9k__expanded ))
	then
		_p9k__expanded=1 
		(( _p9k__fully_initialized || ! $+functions[p10k-on-init] )) || p10k-on-init
		local pat idx var
		for pat idx var in $_p9k_show_on_command
		do
			_p9k_display_segment $idx $var hide
		done
		(( $+functions[p10k-on-pre-prompt] )) && p10k-on-pre-prompt
		if zle
		then
			local -a P9K_COMMANDS=($_p9k__last_commands) 
			local pat idx var
			for pat idx var in $_p9k_show_on_command
			do
				if (( $P9K_COMMANDS[(I)$pat] ))
				then
					_p9k_display_segment $idx $var show
				else
					_p9k_display_segment $idx $var hide
				fi
			done
			if (( $+functions[p10k-on-post-widget] ))
			then
				local -h WIDGET
				unset WIDGET
				p10k-on-post-widget
			fi
		else
			if [[ $_p9k__display_v[2] == print && -n $_p9k_t[_p9k_empty_line_idx] ]]
			then
				print -rnP -- '%b%k%f%E'$_p9k_t[_p9k_empty_line_idx]
			fi
			if [[ $_p9k__display_v[4] == print ]]
			then
				() {
					local ruler=$_p9k_t[_p9k_ruler_idx] 
					local -i _p9k__clm=COLUMNS _p9k__ind=${ZLE_RPROMPT_INDENT:-1} 
					(( __p9k_ksh_arrays )) && setopt ksh_arrays
					(( __p9k_sh_glob )) && setopt sh_glob
					setopt prompt_subst
					print -rnP -- '%b%k%f%E'$ruler
				}
			fi
		fi
		__p9k_reset_state=0 
		_p9k__fully_initialized=1 
	fi
}
_p9k_on_widget_deactivate-region () {
	_p9k_check_visual_mode
}
_p9k_on_widget_overwrite-mode () {
	_p9k_check_visual_mode
	__p9k_reset_state=2 
}
_p9k_on_widget_send-break () {
	_p9k_on_widget_zle-line-finish int
}
_p9k_on_widget_vi-replace () {
	_p9k_check_visual_mode
	__p9k_reset_state=2 
}
_p9k_on_widget_visual-line-mode () {
	_p9k_check_visual_mode
}
_p9k_on_widget_visual-mode () {
	_p9k_check_visual_mode
}
_p9k_on_widget_zle-keymap-select () {
	_p9k_check_visual_mode
	__p9k_reset_state=2 
}
_p9k_on_widget_zle-line-finish () {
	(( $+_p9k__line_finished )) && return
	local P9K_PROMPT=transient 
	_p9k__line_finished= 
	(( _p9k_reset_on_line_finish )) && __p9k_reset_state=2 
	(( $+functions[p10k-on-post-prompt] )) && p10k-on-post-prompt
	local -i optimized
	if [[ -n $_p9k_transient_prompt ]]
	then
		if [[ $_POWERLEVEL9K_TRANSIENT_PROMPT == always || $_p9k__cwd == $_p9k__last_prompt_pwd ]]
		then
			optimized=1 
			__p9k_reset_state=2 
		else
			_p9k__last_prompt_pwd=$_p9k__cwd 
		fi
	fi
	if [[ $1 == int ]]
	then
		_p9k__must_restore_prompt=1 
		if (( !_p9k__restore_prompt_fd ))
		then
			sysopen -o cloexec -ru _p9k__restore_prompt_fd /dev/null
			zle -F $_p9k__restore_prompt_fd _p9k_restore_prompt
		fi
	fi
	if (( __p9k_reset_state == 2 ))
	then
		if (( optimized ))
		then
			RPROMPT= PROMPT=$_p9k_transient_prompt _p9k_reset_prompt
		else
			_p9k_reset_prompt
		fi
	fi
	_p9k__line_finished='%{%}' 
}
_p9k_on_widget_zle-line-init () {
	(( _p9k__cursor_hidden )) || return 0
	_p9k__cursor_hidden=0 
	echoti cnorm
}
_p9k_param () {
	local key="_p9k_param ${(pj:\0:)*}" 
	_p9k__ret=$_p9k_cache[$key] 
	if [[ -n $_p9k__ret ]]
	then
		_p9k__ret[-1,-1]='' 
	else
		if [[ ${1//-/_} == (#b)prompt_([a-z0-9_]#)(*) ]]
		then
			local var=_POWERLEVEL9K_${${(U)match[1]}//İ/I}$match[2]_$2 
			if (( $+parameters[$var] ))
			then
				_p9k__ret=${(P)var} 
			else
				var=_POWERLEVEL9K_${${(U)match[1]%_}//İ/I}_$2 
				if (( $+parameters[$var] ))
				then
					_p9k__ret=${(P)var} 
				else
					var=_POWERLEVEL9K_$2 
					if (( $+parameters[$var] ))
					then
						_p9k__ret=${(P)var} 
					else
						_p9k__ret=$3 
					fi
				fi
			fi
		else
			local var=_POWERLEVEL9K_$2 
			if (( $+parameters[$var] ))
			then
				_p9k__ret=${(P)var} 
			else
				_p9k__ret=$3 
			fi
		fi
		_p9k_cache[$key]=${_p9k__ret}. 
	fi
}
_p9k_parse_aws_config () {
	local cfg=$1 
	typeset -ga reply=() 
	[[ -f $cfg && -r $cfg ]] || return
	local -a lines
	lines=(${(f)"$(<$cfg)"})  || return
	local line profile
	local -a match mbegin mend
	for line in $lines
	do
		if [[ $line == [[:space:]]#'[default]'[[:space:]]#(|'#'*) ]]
		then
			profile=default 
		elif [[ $line == (#b)'[profile'[[:space:]]##([^[:space:]]|[^[:space:]]*[^[:space:]])[[:space:]]#']'[[:space:]]#(|'#'*) ]]
		then
			profile=${(Q)match[1]} 
		elif [[ $line == (#b)[[:space:]]#region[[:space:]]#=[[:space:]]#([^[:space:]]|[^[:space:]]*[^[:space:]])[[:space:]]# ]]
		then
			if [[ -n $profile ]]
			then
				reply+=$#profile:$profile:$match[1] 
				profile= 
			fi
		fi
	done
}
_p9k_parse_buffer () {
	[[ ${2:-0} == <-> ]] || return 2
	local rcquotes
	[[ -o rcquotes ]] && rcquotes=rcquotes 
	eval "$__p9k_intro"
	setopt no_nomatch $rcquotes
	typeset -ga P9K_COMMANDS=() 
	local -r id='(<->|[[:alpha:]_][[:IDENT:]]#)' 
	local -r var="\$$id|\${$id}|\"\$$id\"|\"\${$id}\"" 
	local -i e ic c=${2:-'1 << 62'} 
	local skip n s r state token cmd prev
	local -a aln alp alf v
	if [[ -o interactive_comments ]]
	then
		ic=1 
		local tokens=(${(Z+C+)1}) 
	else
		local tokens=(${(z)1}) 
	fi
	{
		while (( $#tokens ))
		do
			(( e = $#state ))
			while (( $#tokens == alp[-1] ))
			do
				aln[-1]=() 
				alp[-1]=() 
				if (( $#tokens == alf[-1] ))
				then
					alf[-1]=() 
					(( e = 0 ))
				fi
			done
			while (( c-- > 0 )) || return
			do
				token=$tokens[1] 
				tokens[1]=() 
				if (( $+galiases[$token] ))
				then
					(( $aln[(eI)p$token] )) && break
					s=$galiases[$token] 
					n=p$token 
				elif (( e ))
				then
					break
				elif (( $+aliases[$token] ))
				then
					(( $aln[(eI)p$token] )) && break
					s=$aliases[$token] 
					n=p$token 
				elif [[ $token == ?*.?* ]] && (( $+saliases[${token##*.}] ))
				then
					r=${token##*.} 
					(( $aln[(eI)s$r] )) && break
					s=${saliases[$r]%% #} 
					n=s$r 
				else
					break
				fi
				aln+=$n 
				alp+=$#tokens 
				[[ $s == *' ' ]] && alf+=$#tokens 
				(( ic )) && tokens[1,0]=(${(Z+C+)s})  || tokens[1,0]=(${(z)s}) 
			done
			case $token in
				('<<'(|-)) state=h 
					continue ;;
				(*('`'|['<>=$']'(')*) if [[ $token == ('`'[^'`']##'`'|'"`'[^'`']##'`"'|'$('[^')']##')'|'"$('[^')']##')"'|['<>=']'('[^')']##')') ]]
					then
						s=${${token##('"'|)(['$<>']|)?}%%?('"'|)} 
						(( ic )) && tokens+=(';' ${(Z+C+)s})  || tokens+=(';' ${(z)s}) 
					fi ;;
			esac
			case $state in
				(*r) state[-1]= 
					continue ;;
				(a) if [[ $token == $skip ]]
					then
						if [[ $token == '{' ]]
						then
							P9K_COMMANDS+=$cmd 
							cmd= 
							state= 
						else
							skip='{' 
						fi
						continue
					else
						state=t 
					fi ;&
				(t | p*) if (( $+__p9k_pb_term[$token] ))
					then
						if [[ $token == '()' ]]
						then
							state= 
						else
							P9K_COMMANDS+=$cmd 
							if [[ $token == '}' ]]
							then
								state=a 
								skip=always 
							else
								skip=$__p9k_pb_term_skip[$token] 
								state=${skip:+s} 
							fi
						fi
						cmd= 
						continue
					elif [[ $state == t ]]
					then
						continue
					elif [[ $state == *x ]]
					then
						if (( $+__p9k_pb_redirect[$token] ))
						then
							prev= 
							state[-1]=r 
							continue
						else
							state[-1]= 
						fi
					fi ;;
				(s) if [[ $token == $~skip ]]
					then
						state= 
					fi
					continue ;;
				(h) while (( $#tokens ))
					do
						(( e = ${tokens[(i)${(Q)token}]} ))
						if [[ $tokens[e-1] == ';' && $tokens[e+1] == ';' ]]
						then
							tokens[1,e]=() 
							break
						else
							tokens[1,e]=() 
						fi
					done
					while (( $#alp && alp[-1] >= $#tokens ))
					do
						aln[-1]=() 
						alp[-1]=() 
					done
					state=t 
					continue ;;
			esac
			if (( $+__p9k_pb_redirect[${token#<0-255>}] ))
			then
				state+=r 
				continue
			fi
			if [[ $token == *'$'* ]]
			then
				if [[ $token == $~var ]]
				then
					n=${${token##[^[:IDENT:]]}%%[^[:IDENT:]]} 
					[[ $token == *'"' ]] && v=("${(P)n}")  || v=(${(P)n}) 
					tokens[1,0]=(${(@qq)v}) 
					continue
				fi
			fi
			case $state in
				('') if (( $+__p9k_pb_cmd_skip[$token] ))
					then
						skip=$__p9k_pb_cmd_skip[$token] 
						[[ $token == '}' ]] && state=a  || state=${skip:+s} 
						continue
					fi
					if [[ $token == *=* ]]
					then
						v=${(S)token/#(<->|([[:alpha:]_][[:IDENT:]]#(|'['*[^\\](\\\\)#']')))(|'+')=} 
						if (( $#v < $#token ))
						then
							if [[ $v == '(' ]]
							then
								state=s 
								skip='\)' 
							fi
							continue
						fi
					fi
					: ${token::=${(Q)${~token}}} ;;
				(p2) if [[ -n $prev ]]
					then
						prev= 
					else
						: ${token::=${(Q)${~token}}}
						if [[ $token == '{'$~id'}' ]]
						then
							state=p2x 
							prev=$token 
						else
							state=p 
						fi
						continue
					fi ;&
				(p) if [[ -n $prev ]]
					then
						token=$prev 
						prev= 
					else
						: ${token::=${(Q)${~token}}}
						case $token in
							('{'$~id'}') prev=$token 
								state=px 
								continue ;;
							([^-]*)  ;;
							(--) state=p1 
								continue ;;
							($~skip) state=p2 
								continue ;;
							(*) continue ;;
						esac
					fi ;;
				(p1) if [[ -n $prev ]]
					then
						token=$prev 
						prev= 
					else
						: ${token::=${(Q)${~token}}}
						if [[ $token == '{'$~id'}' ]]
						then
							state=p1x 
							prev=$token 
							continue
						fi
					fi ;;
			esac
			if (( $+__p9k_pb_precommand[$token] ))
			then
				prev= 
				state=p 
				skip=$__p9k_pb_precommand[$token] 
				cmd+=$token$'\0' 
			else
				state=t 
				[[ $token == ('(('*'))'|'`'*'`'|'$'*|['<>=']'('*')'|*$'\0'*) ]] || cmd+=$token$'\0' 
			fi
		done
	} always {
		[[ $state == (px|p1x) ]] && cmd+=$prev 
		P9K_COMMANDS+=$cmd 
		P9K_COMMANDS=(${(u)P9K_COMMANDS%$'\0'}) 
	}
}
_p9k_phpenv_global_version () {
	_p9k_read_word ${PHPENV_ROOT:-$HOME/.phpenv}/version || _p9k__ret=system 
}
_p9k_plenv_global_version () {
	_p9k_read_word ${PLENV_ROOT:-$HOME/.plenv}/version || _p9k__ret=system 
}
_p9k_precmd () {
	__p9k_new_status=$? 
	__p9k_new_pipestatus=($pipestatus) 
	trap ":" INT
	[[ -o ksh_arrays ]] && __p9k_ksh_arrays=1  || __p9k_ksh_arrays=0 
	[[ -o sh_glob ]] && __p9k_sh_glob=1  || __p9k_sh_glob=0 
	_p9k_restore_special_params
	_p9k_precmd_impl
	[[ ${+__p9k_instant_prompt_active} == 0 || -o no_prompt_cr ]] || __p9k_instant_prompt_active=2 
	setopt no_local_options no_prompt_bang prompt_percent prompt_subst prompt_cr prompt_sp
	typeset -g __p9k_trapint='_p9k_trapint; return 130' 
	trap "$__p9k_trapint" INT
	: ${(%):-%b%k%s%u}
}
_p9k_precmd_first () {
	eval "$__p9k_intro"
	if [[ -n $KITTY_SHELL_INTEGRATION && KITTY_SHELL_INTEGRATION[(wIe)no-prompt-mark] -eq 0 ]]
	then
		KITTY_SHELL_INTEGRATION+=' no-prompt-mark' 
		(( $+__p9k_force_term_shell_integration )) || typeset -gri __p9k_force_term_shell_integration=1 
	fi
	typeset -ga precmd_functions=(${precmd_functions:#_p9k_precmd_first}) 
}
_p9k_precmd_impl () {
	eval "$__p9k_intro"
	(( __p9k_enabled )) || return
	if ! zle || [[ -z $_p9k__param_sig ]]
	then
		if zle
		then
			__p9k_new_status=0 
			__p9k_new_pipestatus=(0) 
		else
			_p9k__must_restore_prompt=0 
		fi
		if _p9k_must_init
		then
			local -i instant_prompt_disabled
			if (( !__p9k_configured ))
			then
				__p9k_configured=1 
				if [[ -z "${parameters[(I)POWERLEVEL9K_*~POWERLEVEL9K_(MODE|CONFIG_FILE|GITSTATUS_DIR)]}" ]]
				then
					_p9k_can_configure -q
					local -i ret=$? 
					if (( ret == 2 && $+__p9k_instant_prompt_active ))
					then
						_p9k_clear_instant_prompt
						unset __p9k_instant_prompt_active
						_p9k_delete_instant_prompt
						zf_rm -f -- $__p9k_dump_file{,.zwc} 2> /dev/null
						() {
							local key
							while true
							do
								[[ -t 2 ]]
								read -t0 -k key || break
							done 2> /dev/null
						}
						_p9k_can_configure -q
						ret=$? 
					fi
					if (( ret == 0 ))
					then
						if (( $+commands[git] ))
						then
							(
								local -i pid
								{
									{
										/bin/sh "$__p9k_root_dir"/gitstatus/install < /dev/null &> /dev/null &
									} && pid=$! 
									(
										builtin source "$__p9k_root_dir"/internal/wizard.zsh
									)
								} always {
									if (( pid ))
									then
										kill -- $pid 2> /dev/null
										wait -- $pid 2> /dev/null
									fi
								}
							)
						else
							(
								builtin source "$__p9k_root_dir"/internal/wizard.zsh
							)
						fi
						if (( $? ))
						then
							instant_prompt_disabled=1 
						else
							builtin source "$__p9k_cfg_path"
							_p9k__force_must_init=1 
							_p9k_must_init
						fi
					fi
				fi
			fi
			typeset -gi _p9k__instant_prompt_disabled=instant_prompt_disabled 
			_p9k_init
		fi
		if (( _p9k__timer_start ))
		then
			typeset -gF P9K_COMMAND_DURATION_SECONDS=$((EPOCHREALTIME - _p9k__timer_start)) 
		else
			unset P9K_COMMAND_DURATION_SECONDS
		fi
		_p9k_save_status
		if [[ $_p9k__preexec_cmd == [[:space:]]#(clear([[:space:]]##-(|x)(|T[a-zA-Z0-9-_\'\"]#))#|reset)[[:space:]]# && $_p9k__status == 0 ]]
		then
			P9K_TTY=new 
		elif [[ $P9K_TTY == new && $_p9k__fully_initialized == 1 ]] && ! zle
		then
			P9K_TTY=old 
		fi
		_p9k__timer_start=0 
		_p9k__region_active=0 
		unset _p9k__line_finished _p9k__preexec_cmd
		_p9k__keymap=main 
		_p9k__zle_state=insert 
		(( ++_p9k__prompt_idx ))
		if (( $+_p9k__iterm_cmd ))
		then
			_p9k_iterm2_precmd $__p9k_new_status
		fi
	fi
	_p9k_fetch_cwd
	_p9k__refresh_reason=precmd 
	__p9k_reset_state=1 
	local -i fast_vcs
	if (( _p9k_vcs_index && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K ))
	then
		if [[ $_p9k__cwd != $~_POWERLEVEL9K_VCS_DISABLED_DIR_PATTERN ]]
		then
			local -F start_time=EPOCHREALTIME 
			unset _p9k__vcs
			unset _p9k__vcs_timeout
			local -i _p9k__vcs_called
			_p9k_vcs_gitstatus
			local -i fast_vcs=1 
		fi
	fi
	(( $+functions[_p9k_async_segments_compute] )) && _p9k_async_segments_compute
	_p9k__expanded=0 
	_p9k_set_prompt
	_p9k__refresh_reason='' 
	if [[ $precmd_functions[1] != _p9k_do_nothing && $precmd_functions[(I)_p9k_do_nothing] != 0 ]]
	then
		precmd_functions=(_p9k_do_nothing ${(@)precmd_functions:#_p9k_do_nothing}) 
	fi
	if [[ $precmd_functions[-1] != _p9k_precmd && $precmd_functions[(I)_p9k_precmd] != 0 ]]
	then
		precmd_functions=(${(@)precmd_functions:#_p9k_precmd} _p9k_precmd) 
	fi
	if [[ $preexec_functions[1] != _p9k_preexec1 && $preexec_functions[(I)_p9k_preexec1] != 0 ]]
	then
		preexec_functions=(_p9k_preexec1 ${(@)preexec_functions:#_p9k_preexec1}) 
	fi
	if [[ $preexec_functions[-1] != _p9k_preexec2 && $preexec_functions[(I)_p9k_preexec2] != 0 ]]
	then
		preexec_functions=(${(@)preexec_functions:#_p9k_preexec2} _p9k_preexec2) 
	fi
	if (( fast_vcs && _p9k_vcs_index && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K ))
	then
		if (( $+_p9k__vcs_timeout ))
		then
			(( _p9k__vcs_timeout = _POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS + start_time - EPOCHREALTIME ))
			(( _p9k__vcs_timeout >= 0 )) || (( _p9k__vcs_timeout = 0 ))
			gitstatus_process_results_p9k_ -t $_p9k__vcs_timeout POWERLEVEL9K
		fi
		if (( ! $+_p9k__vcs ))
		then
			local _p9k__prompt _p9k__prompt_side=$_p9k_vcs_side _p9k__segment_name=vcs 
			local -i _p9k__has_upglob _p9k__segment_index=_p9k_vcs_index _p9k__line_index=_p9k_vcs_line_index 
			_p9k_vcs_render
			typeset -g _p9k__vcs=$_p9k__prompt 
		fi
	fi
	_p9k_worker_receive
	__p9k_reset_state=0 
}
_p9k_preexec1 () {
	_p9k_restore_special_params
	unset __p9k_trapint
	trap - INT
}
_p9k_preexec2 () {
	typeset -g _p9k__preexec_cmd=$2 
	_p9k__timer_start=EPOCHREALTIME 
	P9K_TTY=old 
	(( ! $+_p9k__iterm_cmd )) || _p9k_iterm2_preexec
}
_p9k_preinit () {
	(( 1 )) || {
		unfunction _p9k_preinit
		return 1
	}
	[[ $ZSH_VERSION == 5.9 ]] || return
	[[ -r /opt/homebrew/Cellar/powerlevel10k/1.16.1/gitstatus/gitstatus.plugin.zsh ]] || return
	builtin source /opt/homebrew/Cellar/powerlevel10k/1.16.1/gitstatus/gitstatus.plugin.zsh _p9k_ || return
	GITSTATUS_AUTO_INSTALL='' GITSTATUS_DAEMON='' GITSTATUS_CACHE_DIR='' GITSTATUS_NUM_THREADS='' GITSTATUS_LOG_LEVEL='' GITSTATUS_ENABLE_LOGGING='' gitstatus_start_p9k_ -s 1 -u 1 -d 1 -c 1 -m -1 -a POWERLEVEL9K
}
_p9k_print_params () {
	typeset -p -- "$@"
}
_p9k_prompt_anaconda_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${CONDA_PREFIX:-$CONDA_ENV_PATH}'
}
_p9k_prompt_asdf_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[asdf]:-${${+functions[asdf]}:#0}}'
}
_p9k_prompt_aws_eb_env_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[eb]'
}
_p9k_prompt_aws_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${AWS_VAULT:-${AWSUME_PROFILE:-${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}}}'
}
_p9k_prompt_azure_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[az]'
}
_p9k_prompt_battery_async () {
	local prev="${(pj:\0:)_p9k__battery_args}" 
	_p9k_prompt_battery_set_args
	[[ "${(pj:\0:)_p9k__battery_args}" == $prev ]] && return 1
	_p9k_print_params _p9k__battery_args
	echo -E - 'reset=2'
}
_p9k_prompt_battery_compute () {
	_p9k_worker_async _p9k_prompt_battery_async _p9k_prompt_battery_sync
}
_p9k_prompt_battery_init () {
	typeset -ga _p9k__battery_args=() 
	if [[ $_p9k_os == OSX && $+commands[pmset] == 1 ]]
	then
		_p9k__async_segments_compute+='_p9k_worker_invoke battery _p9k_prompt_battery_compute' 
		return
	fi
	if [[ $_p9k_os != (Linux|Android) || -z /sys/class/power_supply/(CMB*|BAT*|battery)/(energy_full|charge_full|charge_counter)(#qN) ]]
	then
		typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
	fi
}
_p9k_prompt_battery_set_args () {
	_p9k__battery_args=() 
	local state remain
	local -i bat_percent
	case $_p9k_os in
		(OSX) (( $+commands[pmset] )) || return
			local raw_data=${${(Af)"$(pmset -g batt 2>/dev/null)"}[2]} 
			[[ $raw_data == *InternalBattery* ]] || return
			remain=${${(s: :)${${(s:; :)raw_data}[3]}}[1]} 
			[[ $remain == *no* ]] && remain="..." 
			[[ $raw_data =~ '([0-9]+)%' ]] && bat_percent=$match[1] 
			case "${${(s:; :)raw_data}[2]}" in
				('charging' | 'finishing charge' | 'AC attached') if (( bat_percent == 100 ))
					then
						state=CHARGED 
						remain='' 
					else
						state=CHARGING 
					fi ;;
				('discharging') (( bat_percent < _POWERLEVEL9K_BATTERY_LOW_THRESHOLD )) && state=LOW  || state=DISCONNECTED  ;;
				(*) state=CHARGED 
					remain=''  ;;
			esac ;;
		(Linux | Android) local -a bats=(/sys/class/power_supply/(CMB*|BAT*|battery)/(FN)) 
			(( $#bats )) || return
			local -i energy_now energy_full power_now
			local -i is_full=1 is_calculating is_charching 
			local dir
			for dir in $bats
			do
				local -i pow=0 full=0 
				if _p9k_read_file $dir/(energy_full|charge_full|charge_counter)(N)
				then
					(( energy_full += ${full::=_p9k__ret} ))
				fi
				if _p9k_read_file $dir/(power|current)_now(N) && (( $#_p9k__ret < 9 ))
				then
					(( power_now += ${pow::=$_p9k__ret} ))
				fi
				if _p9k_read_file $dir/capacity(N)
				then
					(( energy_now += _p9k__ret * full / 100. + 0.5 ))
				elif _p9k_read_file $dir/(energy|charge)_now(N)
				then
					(( energy_now += _p9k__ret ))
				fi
				_p9k_read_file $dir/status(N) && local bat_status=$_p9k__ret  || continue
				[[ $bat_status != Full ]] && is_full=0 
				[[ $bat_status == Charging ]] && is_charching=1 
				[[ $bat_status == (Charging|Discharging) && $pow == 0 ]] && is_calculating=1 
			done
			(( energy_full )) || return
			bat_percent=$(( 100. * energy_now / energy_full + 0.5 )) 
			(( bat_percent > 100 )) && bat_percent=100 
			if (( is_full || (bat_percent == 100 && is_charching) ))
			then
				state=CHARGED 
			else
				if (( is_charching ))
				then
					state=CHARGING 
				elif (( bat_percent < _POWERLEVEL9K_BATTERY_LOW_THRESHOLD ))
				then
					state=LOW 
				else
					state=DISCONNECTED 
				fi
				if (( power_now > 0 ))
				then
					(( is_charching )) && local -i e=$((energy_full - energy_now))  || local -i e=energy_now 
					local -i minutes=$(( 60 * e / power_now )) 
					(( minutes > 0 )) && remain=$((minutes/60)):${(l#2##0#)$((minutes%60))} 
				elif (( is_calculating ))
				then
					remain="..." 
				fi
			fi ;;
		(*) return 0 ;;
	esac
	(( bat_percent >= _POWERLEVEL9K_BATTERY_${state}_HIDE_ABOVE_THRESHOLD )) && return
	local msg="$bat_percent%%" 
	[[ $_POWERLEVEL9K_BATTERY_VERBOSE == 1 && -n $remain ]] && msg+=" ($remain)" 
	local icon=BATTERY_ICON 
	local var=_POWERLEVEL9K_BATTERY_${state}_STAGES 
	local -i idx="${#${(@P)var}}" 
	if (( idx ))
	then
		(( bat_percent < 100 )) && idx=$((bat_percent * idx / 100 + 1)) 
		icon=$'\1'"${${(@P)var}[idx]}" 
	fi
	local bg=$_p9k_color1 
	local var=_POWERLEVEL9K_BATTERY_${state}_LEVEL_BACKGROUND 
	local -i idx="${#${(@P)var}}" 
	if (( idx ))
	then
		(( bat_percent < 100 )) && idx=$((bat_percent * idx / 100 + 1)) 
		bg="${${(@P)var}[idx]}" 
	fi
	local fg=$_p9k_battery_states[$state] 
	local var=_POWERLEVEL9K_BATTERY_${state}_LEVEL_FOREGROUND 
	local -i idx="${#${(@P)var}}" 
	if (( idx ))
	then
		(( bat_percent < 100 )) && idx=$((bat_percent * idx / 100 + 1)) 
		fg="${${(@P)var}[idx]}" 
	fi
	_p9k__battery_args=(prompt_battery_$state "$bg" "$fg" $icon 0 '' $msg) 
}
_p9k_prompt_battery_sync () {
	eval $REPLY
	_p9k_worker_reply $REPLY
}
_p9k_prompt_chruby_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$RUBY_ENGINE'
}
_p9k_prompt_context_init () {
	if [[ $_POWERLEVEL9K_ALWAYS_SHOW_CONTEXT == 0 && -n $DEFAULT_USER && $P9K_SSH == 0 ]]
	then
		if [[ ${(%):-%n} == $DEFAULT_USER ]]
		then
			if (( ! _POWERLEVEL9K_ALWAYS_SHOW_USER ))
			then
				typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
			fi
		fi
	fi
}
_p9k_prompt_detect_virt_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[systemd-detect-virt]'
}
_p9k_prompt_direnv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${DIRENV_DIR:-${precmd_functions[-1]:#_p9k_precmd}}'
}
_p9k_prompt_disk_usage_async () {
	local pct=${${=${(f)"$(df -P $1 2>/dev/null)"}[2]}[5]%%%} 
	[[ $pct == <0-100> && $pct != $_p9k__disk_usage_pct ]] || return
	_p9k__disk_usage_pct=$pct 
	_p9k__disk_usage_normal= 
	_p9k__disk_usage_warning= 
	_p9k__disk_usage_critical= 
	if (( _p9k__disk_usage_pct >= _POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL ))
	then
		_p9k__disk_usage_critical=1 
	elif (( _p9k__disk_usage_pct >= _POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL ))
	then
		_p9k__disk_usage_warning=1 
	elif (( ! _POWERLEVEL9K_DISK_USAGE_ONLY_WARNING ))
	then
		_p9k__disk_usage_normal=1 
	fi
	_p9k_print_params _p9k__disk_usage_pct _p9k__disk_usage_normal _p9k__disk_usage_warning _p9k__disk_usage_critical
	echo -E - 'reset=1'
}
_p9k_prompt_disk_usage_compute () {
	(( $+commands[df] )) || return
	_p9k_worker_async "_p9k_prompt_disk_usage_async ${(q)1}" _p9k_prompt_disk_usage_sync
}
_p9k_prompt_disk_usage_init () {
	typeset -g _p9k__disk_usage_pct= 
	typeset -g _p9k__disk_usage_normal= 
	typeset -g _p9k__disk_usage_warning= 
	typeset -g _p9k__disk_usage_critical= 
	_p9k__async_segments_compute+='_p9k_worker_invoke disk_usage "_p9k_prompt_disk_usage_compute ${(q)_p9k__cwd_a}"' 
}
_p9k_prompt_disk_usage_sync () {
	eval $REPLY
	_p9k_worker_reply $REPLY
}
_p9k_prompt_docker_machine_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$DOCKER_MACHINE_NAME'
}
_p9k_prompt_dotnet_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[dotnet]'
}
_p9k_prompt_dropbox_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[dropbox-cli]'
}
_p9k_prompt_fvm_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[fvm]'
}
_p9k_prompt_gcloud_async () {
	local gcloud=$1 
	$gcloud projects describe $P9K_GCLOUD_PROJECT_ID --configuration=$P9K_GCLOUD_CONFIGURATION --account=$P9K_GCLOUD_ACCOUNT --format='value(name)'
}
_p9k_prompt_gcloud_compute () {
	local gcloud=$1 
	P9K_GCLOUD_CONFIGURATION=$2 
	P9K_GCLOUD_ACCOUNT=$3 
	P9K_GCLOUD_PROJECT_ID=$4 
	_p9k_worker_async "_p9k_prompt_gcloud_async ${(q)gcloud}" _p9k_prompt_gcloud_sync
}
_p9k_prompt_gcloud_init () {
	_p9k__async_segments_compute+=_p9k_gcloud_prefetch 
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[gcloud]'
}
_p9k_prompt_gcloud_sync () {
	_p9k_worker_reply "_p9k_prompt_gcloud_update ${(q)P9K_GCLOUD_CONFIGURATION} ${(q)P9K_GCLOUD_ACCOUNT} ${(q)P9K_GCLOUD_PROJECT_ID} ${(q)REPLY%$'\n'}"
}
_p9k_prompt_gcloud_update () {
	[[ $1 == $P9K_GCLOUD_CONFIGURATION && $2 == $P9K_GCLOUD_ACCOUNT && $3 == $P9K_GCLOUD_PROJECT_ID && $4 != $P9K_GCLOUD_PROJECT_NAME ]] || return
	[[ -n $4 ]] && P9K_GCLOUD_PROJECT_NAME=$4  || unset P9K_GCLOUD_PROJECT_NAME
	_p9k_gcloud_project_name=$P9K_GCLOUD_PROJECT_NAME 
	_p9k__state_dump_scheduled=1 
	reset=1 
}
_p9k_prompt_go_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[go]'
}
_p9k_prompt_goenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[goenv]:-${${+functions[goenv]}:#0}}'
}
_p9k_prompt_google_app_cred_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${GOOGLE_APPLICATION_CREDENTIALS:+$commands[jq]}'
}
_p9k_prompt_haskell_stack_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[stack]'
}
_p9k_prompt_java_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[java]'
}
_p9k_prompt_jenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[jenv]:-${${+functions[jenv]}:#0}}'
}
_p9k_prompt_kubecontext_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[kubectl]'
}
_p9k_prompt_laravel_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[php]'
}
_p9k_prompt_length () {
	local -i COLUMNS=1024 
	local -i x y=${#1} m 
	if (( y ))
	then
		while (( ${${(%):-$1%$y(l.1.0)}[-1]} ))
		do
			x=y 
			(( y *= 2 ))
		done
		while (( y > x + 1 ))
		do
			(( m = x + (y - x) / 2 ))
			(( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
		done
	fi
	typeset -g _p9k__ret=$x 
}
_p9k_prompt_load_async () {
	local load="$(sysctl -n vm.loadavg 2>/dev/null)"  || return
	load=${${(A)=load}[_POWERLEVEL9K_LOAD_WHICH+1]//,/.} 
	[[ $load == <->(|.<->) && $load != $_p9k__load_value ]] || return
	_p9k__load_value=$load 
	_p9k__load_normal= 
	_p9k__load_warning= 
	_p9k__load_critical= 
	local -F pct='100. * _p9k__load_value / _p9k_num_cpus' 
	if (( pct > _POWERLEVEL9K_LOAD_CRITICAL_PCT ))
	then
		_p9k__load_critical=1 
	elif (( pct > _POWERLEVEL9K_LOAD_WARNING_PCT ))
	then
		_p9k__load_warning=1 
	else
		_p9k__load_normal=1 
	fi
	_p9k_print_params _p9k__load_value _p9k__load_normal _p9k__load_warning _p9k__load_critical
	echo -E - 'reset=1'
}
_p9k_prompt_load_compute () {
	(( $+commands[sysctl] )) || return
	_p9k_worker_async _p9k_prompt_load_async _p9k_prompt_load_sync
}
_p9k_prompt_load_init () {
	if [[ $_p9k_os == (OSX|BSD) ]]
	then
		typeset -g _p9k__load_value= 
		typeset -g _p9k__load_normal= 
		typeset -g _p9k__load_warning= 
		typeset -g _p9k__load_critical= 
		_p9k__async_segments_compute+='_p9k_worker_invoke load _p9k_prompt_load_compute' 
	elif [[ ! -r /proc/loadavg ]]
	then
		typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
	fi
}
_p9k_prompt_load_sync () {
	eval $REPLY
	_p9k_worker_reply $REPLY
}
_p9k_prompt_luaenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[luaenv]:-${${+functions[luaenv]}:#0}}'
}
_p9k_prompt_midnight_commander_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$MC_TMPDIR'
}
_p9k_prompt_net_iface_async () {
	local iface ip line var
	typeset -a iface2ip ips ifaces
	if (( $+commands[ifconfig] ))
	then
		for line in ${(f)"$(command ifconfig 2>/dev/null)"}
		do
			if [[ $line == (#b)([^[:space:]]##):[[:space:]]##flags=([[:xdigit:]]##)'<'* ]]
			then
				[[ $match[2] == *[13579bdfBDF] ]] && iface=$match[1]  || iface= 
			elif [[ -n $iface && $line == (#b)[[:space:]]##inet[[:space:]]##([0-9.]##)* ]]
			then
				iface2ip+=($iface $match[1]) 
				iface= 
			fi
		done
	elif (( $+commands[ip] ))
	then
		for line in ${(f)"$(command ip -4 a show 2>/dev/null)"}
		do
			if [[ $line == (#b)<->:[[:space:]]##([^:]##):[[:space:]]##\<([^\>]#)\>* ]]
			then
				[[ ,$match[2], == *,UP,* ]] && iface=$match[1]  || iface= 
			elif [[ -n $iface && $line == (#b)[[:space:]]##inet[[:space:]]##([0-9.]##)* ]]
			then
				iface2ip+=($iface $match[1]) 
				iface= 
			fi
		done
	fi
	if _p9k_prompt_net_iface_match $_POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE
	then
		local public_ip_vpn=1 
		local public_ip_not_vpn= 
	else
		local public_ip_vpn= 
		local public_ip_not_vpn=1 
	fi
	if _p9k_prompt_net_iface_match $_POWERLEVEL9K_IP_INTERFACE
	then
		local ip_ip=$ips[1] ip_interface=$ifaces[1] ip_timestamp=$EPOCHREALTIME 
		local ip_tx_bytes ip_rx_bytes ip_tx_rate ip_rx_rate
		if [[ $_p9k_os == (Linux|Android) ]]
		then
			if [[ -r /sys/class/net/$ifaces[1]/statistics/tx_bytes && -r /sys/class/net/$ifaces[1]/statistics/rx_bytes ]]
			then
				_p9k_read_file /sys/class/net/$ifaces[1]/statistics/tx_bytes && [[ $_p9k__ret == <-> ]] && ip_tx_bytes=$_p9k__ret  && _p9k_read_file /sys/class/net/$ifaces[1]/statistics/rx_bytes && [[ $_p9k__ret == <-> ]] && ip_rx_bytes=$_p9k__ret  || {
					ip_tx_bytes= 
					ip_rx_bytes= 
				}
			fi
		elif [[ $_p9k_os == (BSD|OSX) && $+commands[netstat] == 1 ]]
		then
			local -a lines
			if lines=(${(f)"$(netstat -inbI $ifaces[1])"}) 
			then
				local header=($=lines[1]) 
				local -i rx_idx=$header[(Ie)Ibytes] 
				local -i tx_idx=$header[(Ie)Obytes] 
				if (( rx_idx && tx_idx ))
				then
					ip_tx_bytes=0 
					ip_rx_bytes=0 
					for line in ${lines:1}
					do
						(( ip_rx_bytes += ${line[(w)rx_idx]} ))
						(( ip_tx_bytes += ${line[(w)tx_idx]} ))
					done
				fi
			fi
		fi
		if [[ -n $ip_rx_bytes ]]
		then
			if [[ $ip_ip == $P9K_IP_IP && $ifaces[1] == $P9K_IP_INTERFACE ]]
			then
				local -F t='ip_timestamp - _p9__ip_timestamp' 
				if (( t <= 0 ))
				then
					ip_tx_rate=${P9K_IP_TX_RATE:-0 B/s} 
					ip_rx_rate=${P9K_IP_RX_RATE:-0 B/s} 
				else
					_p9k_human_readable_bytes $(((ip_tx_bytes - P9K_IP_TX_BYTES) / t))
					[[ $_p9k__ret == *B ]] && ip_tx_rate="$_p9k__ret[1,-2] B/s"  || ip_tx_rate="$_p9k__ret[1,-2] $_p9k__ret[-1]iB/s" 
					_p9k_human_readable_bytes $(((ip_rx_bytes - P9K_IP_RX_BYTES) / t))
					[[ $_p9k__ret == *B ]] && ip_rx_rate="$_p9k__ret[1,-2] B/s"  || ip_rx_rate="$_p9k__ret[1,-2] $_p9k__ret[-1]iB/s" 
				fi
			else
				ip_tx_rate='0 B/s' 
				ip_rx_rate='0 B/s' 
			fi
		fi
	else
		local ip_ip= ip_interface= ip_tx_bytes= ip_rx_bytes= ip_tx_rate= ip_rx_rate= ip_timestamp= 
	fi
	if _p9k_prompt_net_iface_match $_POWERLEVEL9K_VPN_IP_INTERFACE
	then
		if (( _POWERLEVEL9K_VPN_IP_SHOW_ALL ))
		then
			local vpn_ip_ips=($ips) 
		else
			local vpn_ip_ips=($ips[1]) 
		fi
	else
		local vpn_ip_ips=() 
	fi
	[[ $_p9k__public_ip_vpn == $public_ip_vpn && $_p9k__public_ip_not_vpn == $public_ip_not_vpn && $P9K_IP_IP == $ip_ip && $P9K_IP_INTERFACE == $ip_interface && $P9K_IP_TX_BYTES == $ip_tx_bytes && $P9K_IP_RX_BYTES == $ip_rx_bytes && $P9K_IP_TX_RATE == $ip_tx_rate && $P9K_IP_RX_RATE == $ip_rx_rate && "$_p9k__vpn_ip_ips" == "$vpn_ip_ips" ]] && return 1
	if [[ "$_p9k__vpn_ip_ips" == "$vpn_ip_ips" ]]
	then
		echo -n 0
	else
		echo -n 1
	fi
	_p9k__public_ip_vpn=$public_ip_vpn 
	_p9k__public_ip_not_vpn=$public_ip_not_vpn 
	P9K_IP_IP=$ip_ip 
	P9K_IP_INTERFACE=$ip_interface 
	if [[ -n $ip_tx_bytes && -n $P9K_IP_TX_BYTES ]]
	then
		P9K_IP_TX_BYTES_DELTA=$((ip_tx_bytes - P9K_IP_TX_BYTES)) 
	else
		P9K_IP_TX_BYTES_DELTA= 
	fi
	if [[ -n $ip_rx_bytes && -n $P9K_IP_RX_BYTES ]]
	then
		P9K_IP_RX_BYTES_DELTA=$((ip_rx_bytes - P9K_IP_RX_BYTES)) 
	else
		P9K_IP_RX_BYTES_DELTA= 
	fi
	P9K_IP_TX_BYTES=$ip_tx_bytes 
	P9K_IP_RX_BYTES=$ip_rx_bytes 
	P9K_IP_TX_RATE=$ip_tx_rate 
	P9K_IP_RX_RATE=$ip_rx_rate 
	_p9__ip_timestamp=$ip_timestamp 
	_p9k__vpn_ip_ips=($vpn_ip_ips) 
	_p9k_print_params _p9k__public_ip_vpn _p9k__public_ip_not_vpn P9K_IP_IP P9K_IP_INTERFACE P9K_IP_TX_BYTES P9K_IP_RX_BYTES P9K_IP_TX_BYTES_DELTA P9K_IP_RX_BYTES_DELTA P9K_IP_TX_RATE P9K_IP_RX_RATE _p9__ip_timestamp _p9k__vpn_ip_ips
	echo -E - 'reset=1'
}
_p9k_prompt_net_iface_compute () {
	_p9k_worker_async _p9k_prompt_net_iface_async _p9k_prompt_net_iface_sync
}
_p9k_prompt_net_iface_init () {
	typeset -g _p9k__public_ip_vpn= 
	typeset -g _p9k__public_ip_not_vpn= 
	typeset -g P9K_IP_IP= 
	typeset -g P9K_IP_INTERFACE= 
	typeset -g P9K_IP_TX_BYTES= 
	typeset -g P9K_IP_RX_BYTES= 
	typeset -g P9K_IP_TX_BYTES_DELTA= 
	typeset -g P9K_IP_RX_BYTES_DELTA= 
	typeset -g P9K_IP_TX_RATE= 
	typeset -g P9K_IP_RX_RATE= 
	typeset -g _p9__ip_timestamp= 
	typeset -g _p9k__vpn_ip_ips=() 
	[[ -z $_POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE ]] && _p9k__public_ip_not_vpn=1 
	_p9k__async_segments_compute+='_p9k_worker_invoke net_iface _p9k_prompt_net_iface_compute' 
}
_p9k_prompt_net_iface_match () {
	local iface_regex="^($1)\$" iface ip 
	ips=() 
	ifaces=() 
	for iface ip in "${(@)iface2ip}"
	do
		[[ $iface =~ $iface_regex ]] || continue
		ifaces+=$iface 
		ips+=$ip 
	done
	return $(($#ips == 0))
}
_p9k_prompt_net_iface_sync () {
	local -i vpn_ip_changed=$REPLY[1] 
	REPLY[1]="" 
	eval $REPLY
	(( vpn_ip_changed )) && REPLY+='; _p9k_vpn_ip_render' 
	_p9k_worker_reply $REPLY
}
_p9k_prompt_nix_shell_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${IN_NIX_SHELL:#0}'
}
_p9k_prompt_nnn_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${NNNLVL:#0}'
}
_p9k_prompt_node_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[node]'
}
_p9k_prompt_nodeenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$NODE_VIRTUAL_ENV'
}
_p9k_prompt_nodenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[nodenv]:-${${+functions[nodenv]}:#0}}'
}
_p9k_prompt_nordvpn_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[nordvpn]'
}
_p9k_prompt_nvm_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[nvm]:-${${+functions[nvm]}:#0}}'
}
_p9k_prompt_openfoam_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$WM_PROJECT_VERSION'
}
_p9k_prompt_overflow_bug () {
	[[ $ZSH_PATCHLEVEL =~ '^zsh-5\.4\.2-([0-9]+)-' ]] && return $(( match[1] < 159 ))
	[[ $ZSH_PATCHLEVEL =~ '^zsh-5\.7\.1-([0-9]+)-' ]] && return $(( match[1] >= 50 ))
	is-at-least 5.5 && ! is-at-least 5.7.2
}
_p9k_prompt_php_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[php]'
}
_p9k_prompt_phpenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[phpenv]:-${${+functions[phpenv]}:#0}}'
}
_p9k_prompt_plenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[plenv]:-${${+functions[plenv]}:#0}}'
}
_p9k_prompt_proxy_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$all_proxy$http_proxy$https_proxy$ftp_proxy$ALL_PROXY$HTTP_PROXY$HTTPS_PROXY$FTP_PROXY'
}
_p9k_prompt_public_ip_async () {
	local ip method
	local -F start=EPOCHREALTIME 
	local -F next='start + 5' 
	for method in $_POWERLEVEL9K_PUBLIC_IP_METHODS $_POWERLEVEL9K_PUBLIC_IP_METHODS
	do
		case $method in
			(dig) if (( $+commands[dig] ))
				then
					ip="$(dig +tries=1 +short -4 A myip.opendns.com @resolver1.opendns.com 2>/dev/null)" 
					[[ $ip == ';'* ]] && ip= 
					if [[ -z $ip ]]
					then
						ip="$(dig +tries=1 +short -6 AAAA myip.opendns.com @resolver1.opendns.com 2>/dev/null)" 
						[[ $ip == ';'* ]] && ip= 
					fi
				fi ;;
			(curl) if (( $+commands[curl] ))
				then
					ip="$(curl --max-time 5 -w '\n' "$_POWERLEVEL9K_PUBLIC_IP_HOST" 2>/dev/null)" 
				fi ;;
			(wget) if (( $+commands[wget] ))
				then
					ip="$(wget -T 5 -qO- "$_POWERLEVEL9K_PUBLIC_IP_HOST" 2>/dev/null)" 
				fi ;;
		esac
		[[ $ip =~ '^[0-9a-f.:]+$' ]] || ip='' 
		if [[ -n $ip ]]
		then
			next=$((start + _POWERLEVEL9K_PUBLIC_IP_TIMEOUT)) 
			break
		fi
	done
	_p9k__public_ip_next_time=$next 
	_p9k_print_params _p9k__public_ip_next_time
	[[ $_p9k__public_ip == $ip ]] && return
	_p9k__public_ip=$ip 
	_p9k_print_params _p9k__public_ip
	echo -E - 'reset=1'
}
_p9k_prompt_public_ip_compute () {
	(( EPOCHREALTIME >= _p9k__public_ip_next_time )) || return
	_p9k_worker_async _p9k_prompt_public_ip_async _p9k_prompt_public_ip_sync
}
_p9k_prompt_public_ip_init () {
	typeset -g _p9k__public_ip= 
	typeset -gF _p9k__public_ip_next_time=0 
	_p9k__async_segments_compute+='_p9k_worker_invoke public_ip _p9k_prompt_public_ip_compute' 
}
_p9k_prompt_public_ip_sync () {
	eval $REPLY
	_p9k_worker_reply $REPLY
}
_p9k_prompt_pyenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[pyenv]:-${${+functions[pyenv]}:#0}}'
}
_p9k_prompt_ram_async () {
	local -F free_bytes
	case $_p9k_os in
		(OSX) (( $+commands[vm_stat] )) || return
			local stat && stat="$(vm_stat 2>/dev/null)"  || return
			[[ $stat =~ 'Pages free:[[:space:]]+([0-9]+)' ]] || return
			(( free_bytes += match[1] ))
			[[ $stat =~ 'Pages inactive:[[:space:]]+([0-9]+)' ]] || return
			(( free_bytes += match[1] ))
			if (( ! $+_p9k__ram_pagesize ))
			then
				local p
				(( $+commands[pagesize] )) && p=$(pagesize 2>/dev/null)  && [[ $p == <1-> ]] || p=4096 
				typeset -gi _p9k__ram_pagesize=p 
				_p9k_print_params _p9k__ram_pagesize
			fi
			(( free_bytes *= _p9k__ram_pagesize )) ;;
		(BSD) local stat && stat="$(grep -F 'avail memory' /var/run/dmesg.boot 2>/dev/null)"  || return
			free_bytes=${${(A)=stat}[4]}  ;;
		(*) [[ -r /proc/meminfo ]] || return
			local stat && stat="$(</proc/meminfo)"  || return
			[[ $stat == (#b)*(MemAvailable:|MemFree:)[[:space:]]#(<->)* ]] || return
			free_bytes=$(( $match[2] * 1024 ))  ;;
	esac
	_p9k_human_readable_bytes $free_bytes
	[[ $_p9k__ret != $_p9k__ram_free ]] || return
	_p9k__ram_free=$_p9k__ret 
	_p9k_print_params _p9k__ram_free
	echo -E - 'reset=1'
}
_p9k_prompt_ram_compute () {
	_p9k_worker_async _p9k_prompt_ram_async _p9k_prompt_ram_sync
}
_p9k_prompt_ram_init () {
	if [[ ( $_p9k_os == OSX && $+commands[vm_stat] == 0 ) || ( $_p9k_os == BSD && ! -r /var/run/dmesg.boot ) || ( $_p9k_os != (OSX|BSD) && ! -r /proc/meminfo ) ]]
	then
		typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
		return
	fi
	typeset -g _p9k__ram_free= 
	_p9k__async_segments_compute+='_p9k_worker_invoke ram _p9k_prompt_ram_compute' 
}
_p9k_prompt_ram_sync () {
	eval $REPLY
	_p9k_worker_reply $REPLY
}
_p9k_prompt_ranger_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$RANGER_LEVEL'
}
_p9k_prompt_rbenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[rbenv]:-${${+functions[rbenv]}:#0}}'
}
_p9k_prompt_rust_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[rustc]'
}
_p9k_prompt_rvm_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[rvm-prompt]:-${${+functions[rvm-prompt]}:#0}}'
}
_p9k_prompt_scalaenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[scalaenv]:-${${+functions[scalaenv]}:#0}}'
}
_p9k_prompt_segment () {
	"_p9k_${_p9k__prompt_side}_prompt_segment" "$@"
}
_p9k_prompt_ssh_init () {
	if (( ! P9K_SSH ))
	then
		typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
	fi
}
_p9k_prompt_swap_async () {
	local -F used_bytes
	if [[ "$_p9k_os" == "OSX" ]]
	then
		(( $+commands[sysctl] )) || return
		[[ "$(sysctl vm.swapusage 2>/dev/null)" =~ "used = ([0-9,.]+)([A-Z]+)" ]] || return
		used_bytes=${match[1]//,/.} 
		case ${match[2]} in
			('K') (( used_bytes *= 1024 )) ;;
			('M') (( used_bytes *= 1048576 )) ;;
			('G') (( used_bytes *= 1073741824 )) ;;
			('T') (( used_bytes *= 1099511627776 )) ;;
			(*) return 0 ;;
		esac
	else
		local meminfo && meminfo="$(grep -F 'Swap' /proc/meminfo 2>/dev/null)"  || return
		[[ $meminfo =~ 'SwapTotal:[[:space:]]+([0-9]+)' ]] || return
		(( used_bytes+=match[1] ))
		[[ $meminfo =~ 'SwapFree:[[:space:]]+([0-9]+)' ]] || return
		(( used_bytes-=match[1] ))
		(( used_bytes *= 1024 ))
	fi
	(( used_bytes >= 0 || (used_bytes = 0) ))
	_p9k_human_readable_bytes $used_bytes
	[[ $_p9k__ret != $_p9k__swap_used ]] || return
	_p9k__swap_used=$_p9k__ret 
	_p9k_print_params _p9k__swap_used
	echo -E - 'reset=1'
}
_p9k_prompt_swap_compute () {
	_p9k_worker_async _p9k_prompt_swap_async _p9k_prompt_swap_sync
}
_p9k_prompt_swap_init () {
	if [[ ( $_p9k_os == OSX && $+commands[sysctl] == 0 ) || ( $_p9k_os != OSX && ! -r /proc/meminfo ) ]]
	then
		typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
		return
	fi
	typeset -g _p9k__swap_used= 
	_p9k__async_segments_compute+='_p9k_worker_invoke swap _p9k_prompt_swap_compute' 
}
_p9k_prompt_swap_sync () {
	eval $REPLY
	_p9k_worker_reply $REPLY
}
_p9k_prompt_swift_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[swift]'
}
_p9k_prompt_taskwarrior_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[task]:+$_p9k__taskwarrior_functional}'
}
_p9k_prompt_terraform_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[terraform]'
}
_p9k_prompt_terraform_version_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[terraform]'
}
_p9k_prompt_time_async () {
	sleep 1 || true
}
_p9k_prompt_time_compute () {
	_p9k_worker_async _p9k_prompt_time_async _p9k_prompt_time_sync
}
_p9k_prompt_time_init () {
	(( _POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME )) || return
	_p9k__async_segments_compute+='_p9k_worker_invoke time _p9k_prompt_time_compute' 
}
_p9k_prompt_time_sync () {
	_p9k_worker_reply '_p9k_worker_invoke _p9k_prompt_time_compute _p9k_prompt_time_compute; reset=1'
}
_p9k_prompt_timewarrior_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[timew]'
}
_p9k_prompt_todo_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$_p9k__todo_file'
}
_p9k_prompt_toolbox_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$P9K_TOOLBOX_NAME'
}
_p9k_prompt_user_init () {
	if [[ $_POWERLEVEL9K_ALWAYS_SHOW_USER == 0 && "${(%):-%n}" == $DEFAULT_USER ]]
	then
		typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
	fi
}
_p9k_prompt_vim_shell_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$VIMRUNTIME'
}
_p9k_prompt_virtualenv_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$VIRTUAL_ENV'
}
_p9k_prompt_wifi_async () {
	local airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport 
	local last_tx_rate ssid link_auth rssi noise bars on out line v state iface
	{
		if [[ -x $airport ]]
		then
			out="$($airport -I)"  || return 0
			for line in ${${${(f)out}##[[:space:]]#}%%[[:space:]]#}
			do
				v=${line#*: } 
				case $line[1,-$#v-3] in
					(agrCtlRSSI) rssi=$v  ;;
					(agrCtlNoise) noise=$v  ;;
					(state) state=$v  ;;
					(lastTxRate) last_tx_rate=$v  ;;
					(link\ auth) link_auth=$v  ;;
					(SSID) ssid=$v  ;;
				esac
			done
			[[ $state == running && $rssi == (0|-<->) && $noise == (0|-<->) ]] || return 0
		elif [[ -r /proc/net/wireless && -n $commands[iw] ]]
		then
			local -a lines
			lines=(${${(f)"$(</proc/net/wireless)"}:#*\|*})  || return 0
			(( $#lines == 1 )) || return 0
			local parts=(${=lines[1]}) 
			iface=${parts[1]%:} 
			state=${parts[2]} 
			rssi=${parts[4]%.*} 
			noise=${parts[5]%.*} 
			[[ -n $iface && $state == 0## && $rssi == (0|-<->) && $noise == (0|-<->) ]] || return 0
			lines=(${(f)"$(command iw dev $iface link)"})  || return 0
			local -a match mbegin mend
			for line in $lines
			do
				if [[ $line == (#b)[[:space:]]#SSID:[[:space:]]##(*) ]]
				then
					ssid=$match[1] 
				elif [[ $line == (#b)[[:space:]]#'tx bitrate:'[[:space:]]##([^[:space:]]##)' MBit/s'* ]]
				then
					last_tx_rate=$match[1] 
					[[ $last_tx_rate == <->.<-> ]] && last_tx_rate=${${last_tx_rate%%0#}%.} 
				fi
			done
			[[ -n $ssid && -n $last_tx_rate ]] || return 0
		else
			return 0
		fi
		local -i snr_margin='rssi - noise' 
		if (( snr_margin >= 40 ))
		then
			bars=4 
		elif (( snr_margin >= 25 ))
		then
			bars=3 
		elif (( snr_margin >= 15 ))
		then
			bars=2 
		elif (( snr_margin >= 10 ))
		then
			bars=1 
		else
			bars=0 
		fi
		on=1 
	} always {
		if (( ! on ))
		then
			rssi= 
			noise= 
			ssid= 
			last_tx_rate= 
			bars= 
			link_auth= 
		fi
		if [[ $_p9k__wifi_on != $on || $P9K_WIFI_LAST_TX_RATE != $last_tx_rate || $P9K_WIFI_SSID != $ssid || $P9K_WIFI_LINK_AUTH != $link_auth || $P9K_WIFI_RSSI != $rssi || $P9K_WIFI_NOISE != $noise || $P9K_WIFI_BARS != $bars ]]
		then
			_p9k__wifi_on=$on 
			P9K_WIFI_LAST_TX_RATE=$last_tx_rate 
			P9K_WIFI_SSID=$ssid 
			P9K_WIFI_LINK_AUTH=$link_auth 
			P9K_WIFI_RSSI=$rssi 
			P9K_WIFI_NOISE=$noise 
			P9K_WIFI_BARS=$bars 
			_p9k_print_params _p9k__wifi_on P9K_WIFI_LAST_TX_RATE P9K_WIFI_SSID P9K_WIFI_LINK_AUTH P9K_WIFI_RSSI P9K_WIFI_NOISE P9K_WIFI_BARS
			echo -E - 'reset=1'
		fi
	}
}
_p9k_prompt_wifi_compute () {
	_p9k_worker_async _p9k_prompt_wifi_async _p9k_prompt_wifi_sync
}
_p9k_prompt_wifi_init () {
	if [[ -x /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport || ( -r /proc/net/wireless && -n $commands[iw] ) ]]
	then
		typeset -g _p9k__wifi_on= 
		typeset -g P9K_WIFI_LAST_TX_RATE= 
		typeset -g P9K_WIFI_SSID= 
		typeset -g P9K_WIFI_LINK_AUTH= 
		typeset -g P9K_WIFI_RSSI= 
		typeset -g P9K_WIFI_NOISE= 
		typeset -g P9K_WIFI_BARS= 
		_p9k__async_segments_compute+='_p9k_worker_invoke wifi _p9k_prompt_wifi_compute' 
	else
		typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
	fi
}
_p9k_prompt_wifi_sync () {
	if [[ -n $REPLY ]]
	then
		eval $REPLY
		_p9k_worker_reply $REPLY
	fi
}
_p9k_prompt_xplr_init () {
	typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$XPLR_PID'
}
_p9k_pyenv_compute () {
	unset P9K_PYENV_PYTHON_VERSION _p9k__pyenv_version
	local v=${(j.:.)${(@)${(s.:.)PYENV_VERSION}#python-}} 
	if [[ -n $v ]]
	then
		(( ${_POWERLEVEL9K_PYENV_SOURCES[(I)shell]} )) || return
	else
		(( ${_POWERLEVEL9K_PYENV_SOURCES[(I)local|global]} )) || return
		_p9k__ret= 
		if [[ $PYENV_DIR != (|.) ]]
		then
			[[ $PYENV_DIR == /* ]] && local dir=$PYENV_DIR  || local dir="$_p9k__cwd_a/$PYENV_DIR" 
			dir=${dir:A} 
			if [[ $dir != $_p9k__cwd_a ]]
			then
				while true
				do
					if _p9k_read_pyenv_like_version_file $dir/.python-version python-
					then
						(( ${_POWERLEVEL9K_PYENV_SOURCES[(I)local]} )) || return
						break
					fi
					[[ $dir == (/|.) ]] && break
					dir=${dir:h} 
				done
			fi
		fi
		if [[ -z $_p9k__ret ]]
		then
			_p9k_upglob .python-version
			local -i idx=$? 
			if (( idx )) && _p9k_read_pyenv_like_version_file $_p9k__parent_dirs[idx]/.python-version python-
			then
				(( ${_POWERLEVEL9K_PYENV_SOURCES[(I)local]} )) || return
			else
				_p9k__ret= 
			fi
		fi
		if [[ -z $_p9k__ret ]]
		then
			(( _POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW )) || return
			(( ${_POWERLEVEL9K_PYENV_SOURCES[(I)global]} )) || return
			_p9k_pyenv_global_version
		fi
		v=$_p9k__ret 
	fi
	if (( !_POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW ))
	then
		_p9k_pyenv_global_version
		[[ $v == $_p9k__ret ]] && return 1
	fi
	if (( !_POWERLEVEL9K_PYENV_SHOW_SYSTEM ))
	then
		[[ $v == system ]] && return 1
	fi
	local versions=${PYENV_ROOT:-$HOME/.pyenv}/versions 
	versions=${versions:A} 
	local name version
	for name in ${(s.:.)v}
	do
		version=$versions/$name 
		version=${version:A} 
		if [[ $version(#qN/) == (#b)$versions/([^/]##)* ]]
		then
			typeset -g P9K_PYENV_PYTHON_VERSION=$match[1] 
			break
		fi
	done
	typeset -g _p9k__pyenv_version=$v 
}
_p9k_pyenv_global_version () {
	_p9k_read_pyenv_like_version_file ${PYENV_ROOT:-$HOME/.pyenv}/version python- || _p9k__ret=system 
}
_p9k_python_version () {
	case $commands[python] in
		("") return 1 ;;
		(${PYENV_ROOT:-~/.pyenv}/shims/python) local P9K_PYENV_PYTHON_VERSION _p9k__pyenv_version
			local -i _POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=1 _POWERLEVEL9K_PYENV_SHOW_SYSTEM=1 
			local _POWERLEVEL9K_PYENV_SOURCES=(shell local global) 
			if _p9k_pyenv_compute && [[ $P9K_PYENV_PYTHON_VERSION == ([[:digit:].]##)* ]]
			then
				_p9k__ret=$P9K_PYENV_PYTHON_VERSION 
				return 0
			fi ;&
		(*) _p9k_cached_cmd 1 '' python --version || return
			[[ $_p9k__ret == (#b)Python\ ([[:digit:].]##)* ]] && _p9k__ret=$match[1]  ;;
	esac
}
_p9k_rbenv_global_version () {
	_p9k_read_word ${RBENV_ROOT:-$HOME/.rbenv}/version || _p9k__ret=system 
}
_p9k_read_file () {
	_p9k__ret='' 
	[[ -n $1 ]] && IFS='' read -r _p9k__ret < $1
	[[ -n $_p9k__ret ]]
}
_p9k_read_pyenv_like_version_file () {
	local -a stat
	zstat -A stat +mtime -- $1 2> /dev/null || stat=(-1) 
	local cached=$_p9k__read_pyenv_like_version_file_cache[$1:$2] 
	if [[ $cached == $stat[1]:* ]]
	then
		_p9k__ret=${cached#*:} 
	else
		local fd content
		{
			{
				sysopen -r -u fd -- $1 && sysread -i $fd -s 1024 content
			} 2> /dev/null
		} always {
			[[ -n $fd ]] && exec {fd}>&-
		}
		local MATCH
		local versions=(${${${${(f)content}/(#m)*/${MATCH[(w)1]}}##\#*}#$2}) 
		_p9k__ret=${(j.:.)versions} 
		_p9k__read_pyenv_like_version_file_cache[$1:$2]=$stat[1]:$_p9k__ret 
	fi
	[[ -n $_p9k__ret ]]
}
_p9k_read_word () {
	local -a stat
	zstat -A stat +mtime -- $1 2> /dev/null || stat=(-1) 
	local cached=$_p9k__read_word_cache[$1] 
	if [[ $cached == $stat[1]:* ]]
	then
		_p9k__ret=${cached#*:} 
	else
		local rest
		_p9k__ret= 
		{
			read _p9k__ret rest < $1
		} 2> /dev/null
		_p9k__ret=${_p9k__ret%$'\r'} 
		_p9k__read_word_cache[$1]=$stat[1]:$_p9k__ret 
	fi
	[[ -n $_p9k__ret ]]
}
_p9k_redraw () {
	zle -F $1
	exec {1}>&-
	_p9k__redraw_fd=0 
	() {
		local -h WIDGET=zle-line-pre-redraw 
		_p9k_widget_hook ''
	}
}
_p9k_reset_prompt () {
	if (( __p9k_reset_state != 1 )) && zle && [[ -z $_p9k__line_finished ]]
	then
		__p9k_reset_state=0 
		setopt prompt_subst
		(( __p9k_ksh_arrays )) && setopt ksh_arrays
		(( __p9k_sh_glob )) && setopt sh_glob
		{
			(( _p9k__can_hide_cursor )) && echoti civis
			zle .reset-prompt
			(( ${+functions[z4h]} )) || zle -R
		} always {
			(( _p9k__can_hide_cursor )) && echoti cnorm
			_p9k__cursor_hidden=0 
		}
	fi
}
_p9k_restore_prompt () {
	eval "$__p9k_intro"
	zle -F $1
	exec {1}>&-
	_p9k__restore_prompt_fd=0 
	(( _p9k__must_restore_prompt )) || return 0
	_p9k__must_restore_prompt=0 
	unset _p9k__line_finished
	_p9k__refresh_reason=restore 
	_p9k_set_prompt
	_p9k__refresh_reason= 
	_p9k__expanded=0 
	_p9k_reset_prompt
}
