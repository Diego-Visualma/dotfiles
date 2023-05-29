function sd --wraps='cd (f -t d . | fzf)' --wraps='cd (fd -t d . | fzf)' --description 'alias sd=cd (fd -t d . | fzf)'
  cd (fd -t d . | fzf) $argv; 
end
