.PHONY:
.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys
print("\x1b[1m%-20s\x1b[0m%s" % ("usage:", "make [COMMAND]"))
print("\x1b[1m%-20s %s\x1b[0m" % ("COMMAND", "Description"))
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("\x1b[92m%-20s \x1b[0m%s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

debug_log: ## Debug log
	@journalctl -f -o cat GNOME_SHELL_EXTENSION_UUID=onedrive@diegomerida.com

test_nested: ## Test extension in nested Gnome Shell
	@dbus-run-session -- gnome-shell --nested --wayland

locale_build: ## Build locale
	@msgfmt locale/it/LC_MESSAGES/One\ Drive.po -o locale/it/LC_MESSAGES/One\ Drive.mo &&\
	msgfmt locale/es/LC_MESSAGES/One\ Drive.po -o locale/es/LC_MESSAGES/One\ Drive.mo &&\
	msgfmt locale/ca/LC_MESSAGES/One\ Drive.po -o locale/ca/LC_MESSAGES/One\ Drive.mo

locale_update: ## Update locale
	@xgettext --no-location -o  locale/One\ Drive.pot *.js &&\
	msgmerge --no-location --previous --silent --lang=It locale/it/LC_MESSAGES/One\ Drive.po locale/One\ Drive.pot --output locale/it/LC_MESSAGES/One\ Drive.po &&\
	msgmerge --no-location --previous --silent --lang=es locale/es/LC_MESSAGES/One\ Drive.po locale/One\ Drive.pot --output locale/es/LC_MESSAGES/One\ Drive.po &&\
	msgmerge --no-location --previous --silent --lang=ca_ES locale/ca/LC_MESSAGES/One\ Drive.po locale/One\ Drive.pot --output locale/ca/LC_MESSAGES/One\ Drive.po


install: ## Install extansion
	@rm -rf ~/.local/share/gnome-shell/extensions/onedrive\@diegomerida.com &&\
	cp -R . ~/.local/share/gnome-shell/extensions/onedrive\@diegomerida.com

build: ## Build without login 
	@gnome-extensions pack --extra-source=imgs  --extra-source=locale --force
build_with_login: ## Build with login
	@gnome-extensions pack --extra-source=imgs --extra-source=login.js --extra-source=locale --force

# lg - Extension lg manager, run ALT+F2
