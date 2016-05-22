# Install vim with lua and ruby

###  为什么要编译安装vim

        vim 的强大之处就是她有很多强大的工具，而这些工具往往依赖一些语言的开发环境，比如command-T 依赖ruby（且不同版本的vim依赖的ruby版本也不同），neocomplete 依赖lua，但一般的二进制包是不包含这些的，我们需要根据需求定制安装。

 
## 1. 安装ruby 2.0.0

### 1.1 安装rvm， ruby 的包管理工具

#### 1.1.1 安装rvm所需要的套件

	$ sudo apt-get install build-essential curl
	
#### 1.1.2 下载并安装rvm

	$ curl -L https://get.rvm.io | sudo bash -s stable
	
#### 1.1.3 一些简单的rvm命令

	$ rvm -v
	$ rvm list
	$ rvm install 
	
### 1.2 使用rvm 安装 ruby2.0.0

	$ rvm install 2.0.0   

实际的安装目录为：/usr/loca/rvm/rubies 

### 1.3 设定预设的ruby版本
	
	$ rvm use 2.0.0 --default
	$ rvm use 2.0.0 --create

## 2. 安装lua5.1
 
	sudo apt-get install liblua5.1-dev luajit libluajit-5.1 python-dev 	ruby-dev libperl-dev libncurses5-dev libgnome2-dev libgnomeui-dev 	libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-	dev libxpm-dev libxt-dev
 
	sudo mkdir /usr/include/lua5.1/include
	sudo mv /usr/include/lua5.1/*.h /usr/include/lua5.1/include/
	sudo apt-get install liblua5.1-dev luajit libluajit-5.1
	sudo mkdir /usr/include/lua5.1/include
	sudo mv /usr/include/lua5.1/*.h /usr/include/lua5.1/include/
	
## 3. 安装vim

	git clone https://github.com/vim/vim
	cd vim/src
	make distclean
	./configure --with-features=huge \
            --enable-rubyinterp \
            --enable-largefile \
            --disable-netbeans \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --with-luajit \
	    --enable-gui=auto \
            --enable-fail-if-missing \
            --with-lua-prefix=/usr/include/lua5.1 \
            --enable-cscope 
	make 
	sudo make install
	
## 4. 遇到的问题

	vim: error while loading shared libraries: libruby-2.3.so.2.3: cannot open shared object file: No such file or directory

当前vim 链接的ruby版本是ruby2.3, 但commant-T 编译时的ruby版本是ruby2.0.0，所以报了找不到libryby-2.3.so.2.3 的错误。 

解决方法： 

1. 编译command-t的时候用ruby2.3 
2. rebuild vim with ruby2.0  



## 5.卸载vim 

### 5.1 apt-get 安装

	sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
	
### 5.2 编译安装

	make uninstall 
	sudo rm -rf /usr/local/share/vim
	sudo rm /usr/bin/vim
	
### 6. 编译command-t
	
	cd /root/.vim/bundle/command-t/ruby/command-t
	make clean
	ruby extconf.rb
	make
