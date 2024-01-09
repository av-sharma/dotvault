export ZSH=$HOME/dotvault

# List all of our zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

autoload -U add-zsh-hook

# Load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# Load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# Load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

unset config_files

