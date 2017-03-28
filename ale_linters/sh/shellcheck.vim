" Author: w0rp <devw0rp@gmail.com>,
"   taylorskalyo <https://github.com/taylorskalyo>
" Description: This file adds support for using the shellcheck linter with
"   shell scripts.

" This global variable can be set with a string of comma-seperated error
" codes to exclude from shellcheck. For example:
"
" let g:ale_linters_sh_shellcheck_exclusions = 'SC2002,SC2004'
let g:ale_linters_sh_shellcheck_exclusions =
\   get(g:, 'ale_linters_sh_shellcheck_exclusions', '')

" This global variable can be set with a string of shellcheck command line
" options. For example:
"
" let g:ale_sh_shellcheck_options = '--external-sources --exclude=SC2002'
let g:ale_sh_shellcheck_options =
\   get(g:, 'ale_sh_shellcheck_options', '')

if g:ale_linters_sh_shellcheck_exclusions !=# ''
    let s:exclude_option = '--exclude ' .
          \ g:ale_linters_sh_shellcheck_exclusions
else
    let s:exclude_option = ''
endif

if exists('b:is_bash') && b:is_bash
    let s:shell_option = '--shell=bash'
elseif exists('b:is_sh') && b:is_sh
    let s:shell_option = '--shell=sh'
elseif exists('b:is_kornshell') && b:is_kornshell
    let s:shell_option = '--shell=ksh'
else
    let s:shell_option = ''
endif

function! ale_linters#sh#shellcheck#GetCommand(buffer) abort
  return 'shellcheck' .
        \ ' ' . s:exclude_option .
        \ ' ' . s:shell_option .
        \ ' ' . g:ale_sh_shellcheck_options .
        \ ' --format=gcc' .
        \ ' -'
endfunction

call ale#linter#Define('sh', {
\   'name': 'shellcheck',
\   'executable': 'shellcheck',
\   'command_callback': 'ale_linters#sh#shellcheck#GetCommand',
\   'callback': 'ale#handlers#HandleGCCFormat',
\})
