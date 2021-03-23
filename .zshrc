# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

## テーマ
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# docker補完
zinit wait lucid is-snippet as"completion" for \
      OMZP::docker/_docker \
      OMZP::docker-compose/_docker-compose

## コマンド補完
zinit ice wait'0' lucid
zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1 

## シンタックスハイライト
zinit light zsh-users/zsh-syntax-highlighting

## 履歴補完
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=241"

## コマンド履歴検索
function peco-history-selection() {
  BUFFER=`history -n 1 | tail -r | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

## コマンド省略
zinit light momo-lab/zsh-abbrev-alias

## カレントディレクトリ以下のディレクトリ検索・移動
function find_cd() {
  local selected_dir=$(find . -type d | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N find_cd
bindkey '^X' find_cd

## gitリポジトリ検索・移動
function peco-src () {
  local selected_dir=$(ghq list -p | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-src
bindkey '^G' peco-src

## 履歴保存管理
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

# 他のzshと履歴を共有
setopt inc_append_history
setopt share_history

# 前と重複する行は記録しない
setopt HIST_IGNORE_DUPS

# 履歴中の重複行をファイル記録前に無くす
setopt HIST_IGNORE_ALL_DUPS

# 行頭がスペースのコマンドは記録しない
setopt HIST_IGNORE_SPACE

# 余分な空白は詰めて記録
setopt HIST_REDUCE_BLANKS

# histroyコマンドは記録しない
setopt HIST_NO_STORE

# パスを直接入力してもcdする
setopt AUTO_CD

# 環境変数を補完
setopt AUTO_PARAM_KEYS

## stop(Ctrl-s)/start(Ctrl-q)無効化
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

## エイリアス
alias ls="ls -G"
abbrev-alias l="ls"
abbrev-alias ll="ls -l"
abbrev-alias la="ls -la"
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"

abbrev-alias g="git"
abbrev-alias gst="git status"
abbrev-alias gad="git add ."
abbrev-alias gcm="git commit"
abbrev-alias gbr="git branch"
abbrev-alias gbra="git branch -a"
abbrev-alias gsw="git switch"
abbrev-alias gswc="git switch -c"
abbrev-alias gco="git checkout"
abbrev-alias gcob="git checkout -b"
abbrev-alias gl="git log"
abbrev-alias glo="git log --oneline"
abbrev-alias gf="git fetch"
abbrev-alias gpl="git pull"
abbrev-alias gps="git push"

abbrev-alias v="vim"

abbrev-alias d="docker"
abbrev-alias dc="docker compose"

## node
eval "$(nodenv init -)"

alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
