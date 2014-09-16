FILES = git/contrib/completion/git-prompt.sh git/contrib/completion/git-completion.bash

all: $(FILES)

install: $(FILES)
	cp git/contrib/completion/git-prompt.sh       $(HOME)/.git-prompt.bash
	cp git/contrib/completion/git-completion.bash $(HOME)/.git-completion.bash

git/contrib/completion/git-prompt.sh git/contrib/completion/git-completion.bash:
	git clone https://github.com/git/git.git
