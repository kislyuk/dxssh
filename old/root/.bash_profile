source /etc/profile.d/dnanexus.environment
source environment

if [[ -z $TMUX ]]; then
    #byobu new-session -d 'dx-motd';
    byobu
fi
