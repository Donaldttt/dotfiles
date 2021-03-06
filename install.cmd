:: This script is for configurating vim on windows 10 machine

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set NVIM_CONFIG_PATH=%HOME%\appdata\local\nvim\init.vim
@set APP_PATH=%HOME%\.dotfiles

IF NOT EXIST "%APP_PATH%" (
	call git clone "https://github.com/Donaldttt/dotfiles" "%APP_PATH%"
) ELSE (
	@set ORIGINAL_DIR=%CD%
	echo updating dotfiles
	chdir /d "%APP_PATH%"
	call git pull
	chdir /d "%ORIGINAL_DIR%"
	call cd "%APP_PATH%"
)

:: Install vim-plug
curl -fLo %HOME%/vimfiles/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call mklink "%HOME%\.vimrc" "%APP_PATH%\.vimrc"
call mklink "%HOME%\.vimrc.bundles" "%APP_PATH%\.vimrc.bundles"

IF NOT EXIST "%APP_PATH%\.vim" (
	call mkdir "%APP_PATH%\.vim"
)

if  exist "%NVIM_CONFIG_PATH%" (
    move "%NVIM_CONFIG_PATH%" "%NVIM_CONFIG_PATH%.backup""
)

(
echo set runtimepath+=~/.vim,~/.vim/after
echo set packpath+=~/.vim
echo source ~/.vimrc
)> %NVIM_CONFIG_PATH%

call nvim -u "%APP_PATH%/.vimrc.bundles" +BundleInstall! +BundleClean +qall
