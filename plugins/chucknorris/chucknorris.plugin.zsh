# chucknorris: Chuck Norris fortunes

# Automatically generate or update Chuck's compiled fortune data file
# $0 must be used outside a local function. This variable name is unlikly to collide.
CHUCKNORRIS_PLUGIN_DIR=${0:h}

() {
local DIR=$CHUCKNORRIS_PLUGIN_DIR/fortunes
# check if plugin directory is writeable
if [[ ! -w $DIR ]]; then
  # check for writable cache directory
  [[ -w $ZSH_CACHE_DIR ]] && [[ -d $ZSH_CACHE_DIR/chucknorris ]] || mkdir $ZSH_CACHE_DIR/chucknorris
  if [[ ! -d $ZSH_CACHE_DIR/chucknorris ]] || [[ ! -w $ZSH_CACHE_DIR/chucknorris ]]; then
    echo "[oh-my-zsh] cannot generate chucknorris.dat; neither chucknorris plugin directory nor cache directory writable" >&2
    return 1
  fi
  local OLD_DIR=$DIR
  DIR=$ZSH_CACHE_DIR/chucknorris
  # create link to fortune file if nessecarry
  [[ ! -e $DIR/chucknorris ]] && ln -sf $OLD_DIR/chucknorris $DIR/chucknorris 
fi
if [[ ! -f $DIR/chucknorris.dat ]] || [[ $DIR/chucknorris.dat -ot $DIR/chucknorris ]]; then
  # For some reason, Cygwin puts strfile in /usr/sbin, which is not on the path by default
  local strfile=strfile
  if ! which strfile &>/dev/null && [[ -f /usr/sbin/strfile ]]; then
    strfile=/usr/sbin/strfile
  fi
  if which $strfile &> /dev/null; then
    $strfile $DIR/chucknorris $DIR/chucknorris.dat >/dev/null
  else
    echo "[oh-my-zsh] chucknorris depends on strfile, which is not installed" >&2
    echo "[oh-my-zsh] strfile is often provided as part of the 'fortune' package" >&2
  fi
fi

# Aliases
alias chuck="fortune -a $DIR"
alias chuck_cow="chuck | cowthink"
}

unset CHUCKNORRIS_PLUGIN_DIR
