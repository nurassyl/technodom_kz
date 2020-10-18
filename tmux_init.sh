# ./tmux_init.sh && source ~/.bashrc

sudo apt-get update
sudo apt-get install -y tmux

echo -e "if ! [ -n \"\$TMUX\" ]; then\n\texport TERM=xterm-256color\nfi" >> ~/.bashrc
cp .tmux.conf ~/.tmux.conf
