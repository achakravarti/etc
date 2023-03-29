#! /bin/sh


upgrade_current()
{
	[ -f /root/upgrade.lock ] && return
		
	touch /root/upgrade.lock
	sysupgrade -s
	pkg_add -Uu || pkg_add -Dsnap -u
	sysmerge -d
	reboot
}


install_pkg()
{
	pkgs="git emacs--gtk3 firefox texlive_texmf-minimal spleen"
	pkgs="$pkgs openbsd-bacgkrounds most node clang-tools-extra fdm mu"
	pkg_add "$pkgs" || pkg_add -Dsnap "$pkgs"
}


create_user()
{
	_USER=user
	_USERNAME='John Doe'
	_TMPASS=tmpass
	_HOME="/home/$_USER"
	useradd -m -g =uid -G wheel -c "$_USERNAME" -p `encrypt -b a "$_TMPASS"` "$_USER"
	echo 'permit nopass :wheel' >> /etc/doas.conf
}


create_config()
{
	[ -d "$_HOME/tmp" ] && return

	su - "$_USER" -c "git clone https://github.com/achakravarti/etc.git tmp"
	mkdir -p "$_HOME/etc
	cp tmp/openbsd/current/* "$_HOME/etc"

	chmod 0644 "$_HOME/etc/Xresources"
	ln -s "$_HOME/etc/Xresources" "$_HOME/.Xresources"
	
	chmod 0644 "$_HOME/etc/cwmrc"
	ln -s "$_HOME/etc/cwmrc" "$_HOME/.cwmrc"
	
	chmod 0644 "$_HOME/etc/xsession"
	ln -s "$_HOME/etc/xsession" "$_HOME/.xsession"
	
	chmod 0644 "$_HOME/etc/mostrc"
	ln -s "$_HOME/etc/mostrc" "$_HOME/.mostrc"
	
	chmod 0644 "$_HOME/etc/profile"
	cp "$_HOME/.profile" "$_HOME/.profile~"
	rm -f "$_HOME/.profile"
	ln -s "$_HOME/etc/profile" "$_HOME/.profile"
	
	chmod 0644 "$_HOME/etc/tmux.conf"
	ln -s "$_HOME/etc/tmux.conf" "$_HOME/.tmux.conf"
	
	chown -R "$_USER:$_USER" "$_HOME/etc"
	reboot
}

# Setup cpan and PLS
# https://stackoverflow.com/questions/3462058/
create_cpan()
{
	su - "$_USER" -c "(echo yes; echo local::lib)|cpan"
	su - "$_USER" -c "cpan -i PLS"
}


ugrade_current
install_pkg
create_user
create_config
create_cpan

