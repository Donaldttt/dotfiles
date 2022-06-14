REM This script is for configurating vim on windows 10 machine
REM

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set NVIM_CONFIG_PATH=%HOME%\appdata\local\nvim\init.vim
@set APP_PATH=%HOME%\vim-config
IF NOT EXIST "%APP_PATH%" (
	call git clone "https://github.com/Donaldttt/spf13-vim" "%APP_PATH%"
) ELSE (
	@set ORIGINAL_DIR=%CD%
	echo updating vim-config
	chdir /d "%APP_PATH%"
	call git pull
	chdir /d "%ORIGINAL_DIR%"
	call cd "%APP_PATH%"
)

call mklink "%HOME%\.vimrc" "%APP_PATH%\.vimrc"
call mklink "%HOME%\.vimrc.bundles" "%APP_PATH%\.vimrc.bundles"

IF NOT EXIST "%APP_PATH%\.vim" (
	call mkdir "%APP_PATH%\.vim"
)
IF NOT EXIST "%APP_PATH%\.vim\bundle" (
	call mkdir "%APP_PATH%\.vim\bundle"
)

IF NOT EXIST "%HOME%/.vim/bundle/vundle" (
	call git clone https://github.com/gmarik/vundle.git "%HOME%/.vim/bundle/vundle"
) ELSE (
	call cd "%HOME%/.vim/bundle/vundle"
	call git pull
	call cd %HOME%
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
