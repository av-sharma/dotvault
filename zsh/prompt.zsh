autoload -U colors && colors

PROMPT='%F{#5692d7}%n@%m%k%f %B%F{cyan}%(4~|...|)%3~%F{white} %(?.%F{green}%(!.#.>).%F{red}%(!.#.>))%f %b%f%k'

if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ] }; then
   PROMPT='%F{green}(tmux) '$PROMPT
fi