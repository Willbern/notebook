# VirtualBox 克隆

用 VirtualBox 创建多个虚拟机， 用UI的clone功能，但是启动后发现多个虚拟机是同一个IP
，原因是直接克隆就是copy了一个相同的 .vdi 文件， UUID是相同的。
解决过程如下：

	 ~/VirtualBox VMs/ubuntu14.04/ VBoxManage clonehd ubuntu14.04.vdi omega-1.vdi
	0%...c10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
	Clone medium created in format 'VDI'. UUID: 08f60de7-ff52-4b0d-93b9-8ea5c4d11a42

 
 