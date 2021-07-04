#!/bin/bash
#修改：2021.2.26
softver=1.4



# 运行路径
apppath=$(dirname "$0")
cd "$apppath"

# 服务移除
killall iproxy >/dev/null 2>&1
killall Python >/dev/null 2>&1
killall python >/dev/null 2>&1
rm -rf ~/.ssh/known_hosts >/dev/null 2>&1
echo "UserKnownHostsFile ~/.ssh/known_hosts" > ~/.ssh/config
mkdir ~/Library/Caches/factorydata >/dev/null 2>&1
workpatch=~/Library/Caches/factorydata/com.apple.factorydata

# xcode 环境检查
xcode-select --install >/dev/null 2>&1
if [ $? -ne 1 ]; then
echo " "
echo "  请安装 Xcode Command Line Tools(命令行工具) 并在安装完成后再按回车继续"
echo " "
echo " "
error=`osascript -e 'display dialog "                                ⚠️  运行环境缺失  ⚠️\n\n                   📵  抱歉，缺少工具运行所需运行环境\n\n 💡本工具运行需 Xcode Command Line Tools(命令行工具) ，请点击弹出的 Xcode Command Line Tools 安装向导在线安装，\n\n    查询硬盘联机信息需 Brew 环境组件，Brew 环境安装注意就是在安装时如之前已有安装 Brew 环境，则无需覆盖安装 Brew 环境，仅需自动检查其组件是否缺失，将自动安装！\n\n⚠️ 需注意的是 macOS 10.13 及以下版本，因系统较旧，环境安装比较复杂且耗时较长，如之前已安装了环境则按环境安装中文提示千万别去覆盖安装，仅需更新检查即可! \n\n 💡 付费用户如遇到环境安装调试问题可联系我远程解决。\n\n\n        🛑 使用本工具读取工厂码需将设备引导至越狱状态 🛑 \n\n\n\n ⚠️ 郑重声明:本工具仅供合法使用,一切纠纷由使用者自行承担!\n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "安装Brew环境","导出工厂文件","退出" } default button 2 with title "CDSQ iPhone 工厂码查询器 版本:v'${softver}'"'`
if [ "$error" = "button returned:安装brew环境" ] ;then
./运行环境安装
elif [ "$error" = "button returned:导出工厂文件" ] ;then
./工厂码文件提取
exit
else
exit
fi
fi

if [[ -f /usr/local/bin/brew ]]; then
 checkbrew="brewok" 
 else
 checkbrew="brewno" 
echo " "
echo "                未安装 brew 环境 "
echo " "
fi


# 授权检测

macsn1=`system_profiler SPHardwareDataType | grep "Serial Number (system)"`  >/dev/null 2>&1
macsn=`echo ${macsn1#*: }` >/dev/null 2>&1
softsn=cdsqfactorydata:$macsn
check=$(base64 -D <<< `cat ~/Library/.fdinfo 2>&1` 2>&1) 2>&1 >/dev/null 
zcm=`echo "ibase=16; $(echo "$softsn" | xxd -ps -u)" | bc | tr -d "\n"`


if [[ "$check" == "$zcm" ]]; then
jhstatus=jhok 
jh="···········❤️感谢捐助❤️·本工具仅供合法使用！··········"
else
jhstatus=jhno
jh="·⚠️无授权,请联系本人授权或自行根据半嫖WiFi码推算蓝牙码·\n······授权仅需捐助几十块💰，表示感谢下何尝不可🌹······\n·····提交您的Mac序列号:${macsn// /}获取授权器·····"
 fi  

# 欢迎
clear
echo " "
echo " "
echo "                  ____           __________  _____ ____  "
echo "                 / __ )__  __   / ____/ __ \/ ___// __ \ "
echo "                / __  / / / /  / /   / / / /\__ \/ / / / "
echo "               / /_/ / /_/ /  / /___/ /_/ /___/ / /_/ /  "
echo "              /_____/\__, /   \____/_____//____/\___\_\  "
echo "                    /____/                               "
echo " "
echo "             脚本编辑制作：威锋技术组 CDSQ;微博：CDSQ-L"
echo "                     iPhone 硬件工厂码查询"
echo "-------------------------------------------------------------------------"
echo -e "\033[31;49;5m            工厂码查询需设备处于越狱环境且已建立传输通道 \033[39;49;0m"
echo  " "
echo  "           本工具仅供作为维护辅助工具使用，严禁非法使用！"
echo  "               所引起的一切法律问题由使用者自行承担"
echo "-------------------------------------------------------------------------"
echo  " "
if [ "${jhstatus}" = "jhok" ]; then
Welcoming=`osascript -e 'display dialog "\n                    🎊 欢迎使用  iOS设备工厂码查询器 🎊\n\n   💡本查询器主要用于找回 iPhone/iPad 设备丢失的工厂出厂原始 序列号/Wi-Fi/蓝牙 地址码 信息（如 硬盘损坏更换），提取的工厂码信息自动发送至剪贴板可直接粘贴，可输出提取的工厂码的“底层”文件，可脱机解码其他途径提取的工厂数据文件。\n\n                                  📱  支 持 设 备  📱\n\n    🔘 iPhone 6-X；iPad iOS 版本为 13 及以上版本的越狱设备\n\n        🛑 使用本工具读取工厂码时需将设备引导至越狱状态 🛑 \n\n                                  👤  用 户 权 限  👤\n\n    ⚬ 免费用户：\n        可读取设备联机的当前硬盘数据，可提取工厂码的序列号及Wi-Fi地址码，蓝牙码需自行推算\n\n    ⚬ 授权用户：\n       在免费用户的基础上可解码蓝牙地址码；可脱机解码其他途径提取的工厂数据文件；可输出解码的工厂码“底层”文件；环境安装调试的远程协助；\n\n ⚠️ 郑重声明:本工具仅供合法使用,一切纠纷由使用者自行承担!\n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n                     💻 微博：CDSQ-D ；推特：@wecdsq" buttons { "本地数据解码","联机获取工厂码","退出" } default button 2 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "${jhstatus}" = "jhno" ]; then
Welcoming=`osascript -e 'display dialog "\n                    🎊 欢迎使用  iOS设备工厂码查询器 🎊\n\n   💡本查询器主要用于找回 iPhone/iPad 设备丢失的工厂出厂原始 序列号/Wi-Fi/蓝牙 地址码 信息（如 硬盘损坏更换），提取的工厂码信息自动发送至剪贴板可直接粘贴，可输出提取的工厂码的“底层”文件，可脱机解码其他途径提取的工厂数据文件。\n\n                                  📱  支 持 设 备  📱\n\n    🔘 iPhone 6-X；iPad iOS 版本为 13 及以上版本的越狱设备\n\n        🛑 使用本工具读取工厂码时需将设备引导至越狱状态 🛑 \n\n                                  👤  用 户 权 限  👤\n\n    ⚬ 免费用户：\n        可读取设备联机的当前硬盘数据，可提取工厂码的序列号及Wi-Fi地址码，蓝牙码需自行推算\n\n    ⚬ 授权用户：\n       在免费用户的基础上可解码蓝牙地址码；可脱机解码其他途径提取的工厂数据文件；可输出解码的工厂码“底层”文件；环境安装调试的远程协助；\n\n ⚠️ 郑重声明:本工具仅供合法使用,一切纠纷由使用者自行承担!\n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n                     💻 微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂文件","联机获取工厂码","退出" } default button 2 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
fi

# ---------------------------------------------------------

if [ "$Welcoming" = "button returned:退出" ] ;then
exit
fi

if [ "$Welcoming" = "button returned:导出工厂文件" ] ;then
./工厂码文件提取
fi

if [ "$Welcoming" = "button returned:联机获取工厂码" ] ;then

checkmode=Online
# dependerror：lockdownd 错误；noinput：未连接设备；noacc：未信任；unlock：未解锁；ok：组件正常

dev=$(./bin/ideviceinfo -k CPUArchitecture 2>&1)
if [ $? -eq 0  ] ;then
devstatus="设备现已正常联机"
elif [[ "$dev" =~ "flutter ERROR: Could not connect to lockdownd" ]]; then
devstatus="信息读取组件错误"
elif [[ "$dev" =~ "ERROR: No device found" ]]; then
devstatus="当前未连接到设备"
elif [[ "$dev" =~ "ERROR: Could not connect to lockdownd: Pairing dialog response pending" ]]; then
   devstatus="点击屏幕信任设备"
elif [[ "$dev" =~ "ERROR: Could not connect to lockdownd: User denied pairing" ]]; then
   devstatus="已拒绝了信任设备"
elif [[ "$dev" =~ "ERROR: Could not connect to lockdownd: Password protected" ]]; then
   devstatus="当前设备没有解锁"
else
   devstatus="当前连接状态未知"
fi


# 设备信息变量
if [ "$devstatus" = "设备现已正常联机" ]; then

dev=$(./bin/ideviceinfo -k DeviceClass 2>&1)
hdSN=$(./bin/ideviceinfo -k SerialNumber 2>&1)
ver=$(./bin/ideviceinfo -k ProductVersion 2>&1)
os=$(./bin/ideviceinfo -k ProductName 2>&1)
build=$(./bin/ideviceinfo -k BuildVersion 2>&1)
date=$(./bin/ideviceinfo -k TimeIntervalSince1970 2>&1)
date=`date -r ${date%.*} 2>&1`
hdimei=$(./bin/ideviceinfo -k InternationalMobileEquipmentIdentity 2>&1) 
if [ $? -eq 0 ]; then
   hdimeiStatus=ok
fi
hdmeid=$(./bin/ideviceinfo -k MobileEquipmentIdentifier 2>&1)
MN=$(./bin/ideviceinfo -k ModelNumber 2>&1)
PT=$(./bin/ideviceinfo -k ProductType 2>&1)
Reg=$(./bin/ideviceinfo -k RegionInfo 2>&1)
WMac=$(./bin/ideviceinfo -k WiFiAddress 2>&1 | tr 'a-z' 'A-Z')
BMac=$(./bin/ideviceinfo -k BluetoothAddress 2>&1 | tr 'a-z' 'A-Z')
Ethe=$(./bin/ideviceinfo -k EthernetAddress 2>&1 | tr 'a-z' 'A-Z')
DN=$(./bin/ideviceinfo -k DeviceName 2>&1)

cpu=$(./bin/ideviceinfo -k HardwarePlatform 2>&1 | tr 'a-z' 'A-Z')
if [[ "${cpu}" = "S5L8930" ]]; then
cpu2="A4"
elif [[ "${cpu}" = "S5L8940" ]]; then
cpu2="A5"
elif [[ "${cpu}" = "S5L8942" ]]; then
cpu2="A5 Rev A"
elif [[ "${cpu}" = "S5L8945" ]]; then
cpu2="A5X"
elif [[ "${cpu}" = "S5L8947" ]]; then
cpu2="A5 Rev B"
elif [[ "${cpu}" = "S5L8950" ]]; then
cpu2="A6"
elif [[ "${cpu}" = "S5L8955" ]]; then
cpu2="A6X"
elif [[ "${cpu}" = "S5L8960" ]]; then
cpu2="A7"
elif [[ "${cpu}" = "S5L8965" ]]; then
cpu2="A7 Variant"
elif [[ "${cpu}" = "T7000" ]]; then
cpu2="A8"
elif [[ "${cpu}" = "T7001" ]]; then
cpu2="A8X"
elif [[ "${cpu}" = "S8000" ]]; then
cpu2="A9 (三星)"
elif [[ "${cpu}" = "S8001" ]]; then
cpu2="A9X"
elif [[ "${cpu}" = "S8003" ]]; then
cpu2="A9 (台积电)"
elif [[ "${cpu}" = "T8010" ]]; then
cpu2="A10 融合"
elif [[ "${cpu}" = "T8011" ]]; then
cpu2="A10X 融合"
elif [[ "${cpu}" = "T8015" ]]; then
cpu2="A11 仿生"
elif [[ "${cpu}" = "T8020" ]]; then
cpu2="A12 仿生"
elif [[ "${cpu}" = "T8027" ]]; then
cpu2="A12X 仿生 / A12Z 仿生"
elif [[ "${cpu}" = "T8030" ]]; then
cpu2="A13 仿生"
elif [[ "${cpu}" = "T8101" ]]; then
cpu2="A14 仿生"
else 
echo "" 
fi

HM=$(./bin/ideviceinfo -k HardwareModel 2>&1)
if [[ "${HM}" = "N61AP" ]]; then
HM2="iPhone 6"
elif [[ "${HM}" = "N56AP" ]]; then
HM2="iPhone 6 Plus"
elif [[ "${HM}" = "M68AP" ]]; then
HM2="iPhone"
elif [[ "${HM}" = "N82AP" ]]; then
HM2="iPhone 3G"
elif [[ "${HM}" = "N88AP" ]]; then
HM2="iPhone 3GS"
elif [[ "${HM}" = "N90AP" ]]; then
HM2="iPhone 4"
elif [[ "${HM}" = "N90BAP" ]]; then
HM2="iPhone 4"
elif [[ "${HM}" = "N92AP" ]]; then
HM2="iPhone 4"
elif [[ "${HM}" = "N94AP" ]]; then
HM2="iPhone 4S"
elif [[ "${HM}" = "N41AP" ]]; then
HM2="iPhone 5"
elif [[ "${HM}" = "N42AP" ]]; then
HM2="iPhone 5"
elif [[ "${HM}" = "N48AP" ]]; then
HM2="iPhone 5c"
elif [[ "${HM}" = "N49AP" ]]; then
HM2="iPhone 5c"
elif [[ "${HM}" = "N51AP" ]]; then
HM2="iPhone 5s"
elif [[ "${HM}" = "N53AP" ]]; then
HM2="iPhone 5s"
elif [[ "${HM}" = "N71AP" ]]; then
HM2="iPhone 6s"
elif [[ "${HM}" = "N71mAP" ]]; then
HM2="iPhone 6s"
elif [[ "${HM}" = "N66AP" ]]; then
HM2="iPhone 6s Plus"
elif [[ "${HM}" = "N66mAP" ]]; then
HM2="iPhone 6s Plus"
elif [[ "${HM}" = "D10AP" ]]; then
HM2="iPhone 7"
elif [[ "${HM}" = "D101AP" ]]; then
HM2="iPhone 7"
elif [[ "${HM}" = "D11AP" ]]; then
HM2="iPhone 7 Plus"
elif [[ "${HM}" = "D111AP" ]]; then
HM2="iPhone 7 Plus"
elif [[ "${HM}" = "D20AP" ]]; then
HM2="iPhone 8"
elif [[ "${HM}" = "D20AAP" ]]; then
HM2="iPhone 8"
elif [[ "${HM}" = "D201AP" ]]; then
HM2="iPhone 8"
elif [[ "${HM}" = "D201AAP" ]]; then
HM2="iPhone 8"
elif [[ "${HM}" = "D21AP" ]]; then
HM2="iPhone 8 Plus"
elif [[ "${HM}" = "D21AAP" ]]; then
HM2="iPhone 8 Plus"
elif [[ "${HM}" = "D211AP" ]]; then
HM2="iPhone 8 Plus"
elif [[ "${HM}" = "D211AAP" ]]; then
HM2="iPhone 8 Plus"
elif [[ "${HM}" = "D22AP" ]]; then
HM2="iPhone X"
elif [[ "${HM}" = "D221AP" ]]; then
HM2="iPhone X"
elif [[ "${HM}" = "N841AP" ]]; then
HM2="iPhone XR"
elif [[ "${HM}" = "D321AP" ]]; then
HM2="iPhone XS"
elif [[ "${HM}" = "D331AP" ]]; then
HM2="iPhone XS Max"
elif [[ "${HM}" = "D331pAP" ]]; then
HM2="iPhone XS Max"
elif [[ "${HM}" = "N104AP" ]]; then
HM2="iPhone 11"
elif [[ "${HM}" = "D421AP" ]]; then
HM2="iPhone 11 Pro"
elif [[ "${HM}" = "D431AP" ]]; then
HM2="iPhone 11 Pro Max"
elif [[ "${HM}" = "D79AP" ]]; then
HM2="iPhone SE 2代"
elif [[ "${HM}" = "D52gAP" ]]; then
HM2="iPhone 12 mini"
elif [[ "${HM}" = "D53gAP" ]]; then
HM2="iPhone 12"
elif [[ "${HM}" = "D53pAP" ]]; then
HM2="iPhone 12 Pro"
elif [[ "${HM}" = "D54pAP" ]]; then
HM2="iPhone 12 Pro Max"

elif [[ "${HM}" = "K93AP" ]]; then
HM2="iPad 2"
elif [[ "${HM}" = "K94AP" ]]; then
HM2="iPad 2"
elif [[ "${HM}" = "K95AP" ]]; then
HM2="iPad 2"
elif [[ "${HM}" = "K93AAP" ]]; then
HM2="iPad 2"
elif [[ "${HM}" = "J1AP" ]]; then
HM2="iPad 3"
elif [[ "${HM}" = "J2AP" ]]; then
HM2="iPad 3"
elif [[ "${HM}" = "J2AAP" ]]; then
HM2="iPad 3"
elif [[ "${HM}" = "P101AP" ]]; then
HM2="iPad 4"
elif [[ "${HM}" = "P102AP" ]]; then
HM2="iPad 4"
elif [[ "${HM}" = "P103AP" ]]; then
HM2="iPad 4"
elif [[ "${HM}" = "J71sAP" ]]; then
HM2="iPad 5"
elif [[ "${HM}" = "J71tAP" ]]; then
HM2="iPad 5"
elif [[ "${HM}" = "J72sAP" ]]; then
HM2="iPad 5"
elif [[ "${HM}" = "J72tAP" ]]; then
HM2="iPad 5"
elif [[ "${HM}" = "J71bAP" ]]; then
HM2="iPad 6"
elif [[ "${HM}" = "J72bAP" ]]; then
HM2="iPad 6"
elif [[ "${HM}" = "J171AP" ]]; then
HM2="iPad 7"
elif [[ "${HM}" = "J172AP" ]]; then
HM2="iPad 7"
elif [[ "${HM}" = "J171aAP" ]]; then
HM2="iPad 8"
elif [[ "${HM}" = "J172aAP" ]]; then
HM2="iPad 8"
elif [[ "${HM}" = "J71AP" ]]; then
HM2="iPad Air"
elif [[ "${HM}" = "J72AP" ]]; then
HM2="iPad Air"
elif [[ "${HM}" = "J73AP" ]]; then
HM2="iPad Air"
elif [[ "${HM}" = "J81AP" ]]; then
HM2="iPad Air 2"
elif [[ "${HM}" = "J82AP" ]]; then
HM2="iPad Air 2"
elif [[ "${HM}" = "J217AP" ]]; then
HM2="iPad Air 3"
elif [[ "${HM}" = "J218AP" ]]; then
HM2="iPad Air 3"
elif [[ "${HM}" = "J307AP" ]]; then
HM2="iPad Air 4"
elif [[ "${HM}" = "J308AP" ]]; then
HM2="iPad Air 4"
elif [[ "${HM}" = "J98aAP" ]]; then
HM2="iPad Pro 12.9寸"
elif [[ "${HM}" = "J99aAP" ]]; then
HM2="iPad Pro 12.9寸"
elif [[ "${HM}" = "J127AP" ]]; then
HM2="iPad Pro 9.7寸"
elif [[ "${HM}" = "J128AP" ]]; then
HM2="iPad Pro 9.7寸"
elif [[ "${HM}" = "J120AP" ]]; then
HM2="iPad Pro 2 12.9寸"
elif [[ "${HM}" = "J121AP" ]]; then
HM2="iPad Pro 2 12.9寸"
elif [[ "${HM}" = "J207AP" ]]; then
HM2="iPad Pro 10.5寸"
elif [[ "${HM}" = "J208AP" ]]; then
HM2="iPad Pro 10.5寸"
elif [[ "${HM}" = "J317AP" ]]; then
HM2="iPad Pro 11寸"
elif [[ "${HM}" = "J317xAP" ]]; then
HM2="iPad Pro 11寸"
elif [[ "${HM}" = "J318AP" ]]; then
HM2="iPad Pro 11寸"
elif [[ "${HM}" = "J318xAP" ]]; then
HM2="iPad Pro 11寸"
elif [[ "${HM}" = "J320AP" ]]; then
HM2="iPad Pro 3 12.9寸"
elif [[ "${HM}" = "J320xAP" ]]; then
HM2="Pad Pro 3 12.9寸"
elif [[ "${HM}" = "J321AP" ]]; then
HM2="Pad Pro 3 12.9寸"
elif [[ "${HM}" = "J321xAP" ]]; then
HM2="Pad Pro 3 12.9寸"
elif [[ "${HM}" = "J417AP" ]]; then
HM2="iPad Pro 2 11寸"
elif [[ "${HM}" = "J418AP" ]]; then
HM2="iPad Pro 2 11寸"
elif [[ "${HM}" = "J420AP" ]]; then
HM2="iPad Pro 4 12.9寸"
elif [[ "${HM}" = "J421AP" ]]; then
HM2="iPad Pro 4 12.9寸"
elif [[ "${HM}" = "P105AP" ]]; then
HM2="iPad mini"
elif [[ "${HM}" = "P106AP" ]]; then
HM2="iPad mini"
elif [[ "${HM}" = "P107AP" ]]; then
HM2="iPad mini"
elif [[ "${HM}" = "J85AP" ]]; then
HM2="iPad mini 2"
elif [[ "${HM}" = "J86AP" ]]; then
HM2="iPad mini 2"
elif [[ "${HM}" = "J87AP" ]]; then
HM2="iPad mini 2"
elif [[ "${HM}" = "J85mAP" ]]; then
HM2="iPad mini 3"
elif [[ "${HM}" = "J86mAP" ]]; then
HM2="iPad mini 3"
elif [[ "${HM}" = "J87mAP" ]]; then
HM2="iPad mini 3"
elif [[ "${HM}" = "J96AP" ]]; then
HM2="iPad mini 4"
elif [[ "${HM}" = "J97AP" ]]; then
HM2="iPad mini 4"
elif [[ "${HM}" = "J210AP" ]]; then
HM2="iPad mini 5"
elif [[ "${HM}" = "J211AP" ]]; then
HM2="iPad mini 5"
elif [[ "${HM}" = "N45AP" ]]; then
HM2="iPod touch"
elif [[ "${HM}" = "N72AP" ]]; then
HM2="iPod touch 2"
elif [[ "${HM}" = "N18AP" ]]; then
HM2="iPod touch 3"
elif [[ "${HM}" = "N81AP" ]]; then
HM2="iPod touch 4"
elif [[ "${HM}" = "N78AP" ]]; then
HM2="iPod touch 5"
elif [[ "${HM}" = "N78aAP" ]]; then
HM2="iPod touch 5"
elif [[ "${HM}" = "N102AP" ]]; then
HM2="iPod touch 6"
elif [[ "${HM}" = "N112AP" ]]; then
HM2="iPod touch 7"
else 
HM2="未知型号" 
fi
# echo "设备序列号为: '${hdSN// /}'"
fi


#检查连接状态

./bin/iproxy 2222 44 >/dev/null 2>&1 & ./bin/sshpass -p alpine ssh -o 'StrictHostKeyChecking=no' root@localhost -p 2222 'mount -o rw,union,update /'
if [ ! $? -eq 0  ] ;then
clear
echo " "
echo " "
echo -e "\033[31;49;1m                             设备未连接或未越狱 \033[39;49;0m"
echo " "
echo -e "\033[31;49;5m              请仔细检查设备硬件和越狱引导状态，确认正常后再次提取 \033[39;49;0m"
echo " "
echo " "
echo "                  ____           __________  _____ ____  "
echo "                 / __ )__  __   / ____/ __ \/ ___// __ \ "
echo "                / __  / / / /  / /   / / / /\__ \/ / / / "
echo "               / /_/ / /_/ /  / /___/ /_/ /___/ / /_/ /  "
echo "              /_____/\__, /   \____/_____//____/\___\_\  "
echo "                    /____/                               "
echo " "
echo "-------------------------------------------------------------------------"
echo "             脚本编辑制作：威锋技术组 CDSQ;微博：CDSQ-L"
echo " "
# error=`osascript -e 'display dialog "                                ⚠️  联 机 错 误 提 醒  ⚠️\n\n                 📵  您查询工厂码的设备未正常联机或越狱\n\n 💡如已连接 Mac，请重新拔插一次数据线并保持设备亮屏状态\n\n\n\n        🛑 使用本工具读取工厂码需将设备引导至越狱状态 🛑 \n\n\n\n ⚠️ 郑重声明:本工具仅供合法使用,一切纠纷由使用者自行承担!\n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n                     💻 微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
jbstatus=nojb   
else
jbstatus=jbok   
fi

./bin/sshpass -p "alpine" ssh -o StrictHostKeyChecking=no root@localhost -p 2222 test -d /System/Library/Caches/com.apple.factorydata >/dev/null 2>&1
if [ $? -eq 0  ] ;then
datafilestatus="ok"
./bin/sshpass -p alpine scp -rP 2222 -o StrictHostKeyChecking=no root@127.0.0.1:/System/Library/Caches/com.apple.factorydata/ ~/Library/Caches/factorydata/
else
datastatusfile="no"
fi   

fi


###############


if [[ "$Welcoming" = "button returned:本地数据解码" ]] ;then


checkmode=local


hdfiles=`osascript -e "set dir to POSIX path of (choose folder with prompt \"请选择需要解码的包含数据文件的工厂数据文件夹\")"`
if [ ! $? -eq 0  ] ;then
 alert=`osascript -e 'display alert "⚠️ 您已取消本地工厂数据文件的解码" buttons { "关闭" } default button 1 as critical giving up after 3'`   
exit  
else
mkdir "${workpatch}" 


find "${hdfiles}" -name "*" -exec cp -rf '{}' "${workpatch}" \;

datafilestatus="ok"

fi


fi

# ------------------------------------------------------------------------------------------------------------------------------

snfile=$(find "${workpatch}"  -name 'NvMR*' | sed 's#.*/##') >/dev/null 2>&1
bbpvfile=$(find "${workpatch}"  -name 'bbpv*' | sed 's#.*/##') >/dev/null 2>&1
bbpcfile=$(find "${workpatch}"  -name 'bbpc*' | sed 's#.*/##') >/dev/null 2>&1
# ------------------------------------------------------------------------------------------------------------------------------

if [[ -n "$bbpcfile" ]]; then
# 距离感应码
read=$( strings "${workpatch}"/"${bbpcfile}" | grep  -A 2 "pfcl" | sed -n '1d;n;p' > "${workpatch}"/pfclinfo ) >/dev/null 2>&1
pfcl=$( cat "${workpatch}"/pfclinfo | sed -n '1d;n;p' ) >/dev/null 2>&1

# 环境光码
read=$(strings "${workpatch}"/"${bbpcfile}" | grep  -A 2 "IfCl" | sed -n '1d;n;p' > "${workpatch}"/ifclinfo) 2>&1>/dev/null
ifcl=$(cat "${workpatch}"/ifclinfo | sed -n '1d;n;p') 2>&1>/dev/null

# 盖板码：
MtSN1=$(strings "${workpatch}"/"${bbpcfile}" | grep  -A 2 "t604" | sed -n '1d;n;p') 2>&1>/dev/null
MtSN=${MtSN1//,/}
MtSN2="\n"
fi

# 指纹码：
if [[ -n "$snfile" ]]; then
NvMR=${snfile//NvMR-/}  
elif [[ -n "$bbpcfile" ]]; then
read=$(strings "${workpatch}"/"${bbpcfile}" | grep  -A 2 "NvMR" | sed -n '1d;n;p' > "${workpatch}"/Nvinfo) 2>&1>/dev/null
NvMR=$(cat "${workpatch}"/Nvinfo | sed -n '1d;n;p') 2>&1>/dev/null
fi

# ------------------------------------------------------------------------------------------------------------------------------

# 三码

if [[ -n "$bbpvfile" ]]; then
read=$(strings "${workpatch}"/$bbpvfile | grep -o "[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}" > "${workpatch}"/bbinfo) >/dev/null 2>&1
wifi1=$(sed -n '1p' "${workpatch}"/bbinfo) >/dev/null 2>&1
wifi=$(echo $wifi1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1
unset wifi1
bmac1=$(sed -n '2p' "${workpatch}"/bbinfo) >/dev/null 2>&1
bmac=$(echo $bmac1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1
bmacstatus=ok
unset bmac1
emac1=$(sed -n '3p' "${workpatch}"/bbinfo) >/dev/null 2>&1
emac=$(echo $emac1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1
emacstatus=ok
unset bmac1

elif [[ -n "$bbpcfile" ]]; then
read=$(strings "${workpatch}"/$bbpcfile | grep -o "[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}" > "${workpatch}"/bbinfo) >/dev/null 2>&1
cell1=$(sed -n '3p' "${workpatch}"/bbinfo) >/dev/null 2>&1
cell=$(echo $cell1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1
cellstatus=ok
unset cell1
wifi1=$(sed -n '2p' "${workpatch}"/bbinfo) >/dev/null 2>&1
wifi=$(echo $wifi1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1

unset wifi1
bmac1=$(sed -n '1p' "${workpatch}"/bbinfo) >/dev/null 2>&1
bmac=$(echo $bmac1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1
bmacstatus=ok
unset bmac1

elif [[ -n "$snfile" ]]; then
read=$(strings "${workpatch}"/$snfile | grep -o "[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}:[a-zA-Z0-9]\{2\}" > "${workpatch}"/bbinfo) >/dev/null 2>&1
cell1=$(sed -n '3p' "${workpatch}"/bbinfo) >/dev/null 2>&1
cell=$(echo $cell1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1
cellstatus=ok
unset cell1
wifi1=$(sed -n '2p' "${workpatch}"/bbinfo) >/dev/null 2>&1
wifi=$(echo $wifi1 | tr '[a-z]' '[A-Z]')  >/dev/null 2>&1

unset wifi1

bmac1=$(sed -n '1p' "${workpatch}"/bbinfo) >/dev/null 2>&1
bmac=$(echo $bmac1 | tr '[a-z]' '[A-Z]') 
bmacstatus=ok
unset bmac1
fi
# --------------------------------------------------------------------------------

if [ ! $wifi ]; then
wifistatus=no
else
wifistatus=ok  
fi

if [ "$wifistatus" = "no" ] && [ "$datafilestatus" = "ok" ]; then
datastatus=no
else
datastatus=ok
fi

# --------------------------------------------------------------------------------

# --------------------------------------------------------------------------------


# 序列号获取
if [[ -n "$snfile" ]]; then
read=$(strings "${workpatch}"/$snfile | grep -o "SrNm" -A1 > "${workpatch}"/SrNm) >/dev/null 2>&1
if [ $? -eq 0  ] ;then
   LSSN=`cat "${workpatch}"/SrNm | grep -v "SrNm" -A1`  2>&1
SN=${LSSN///}
unset LSSN
fi
elif [[ -n "$bbpcfile" ]]; then
read=$(strings "${workpatch}"/${bbpcfile} | grep -o "SrNm" -A1 > "${workpatch}"/SrNm) >/dev/null 2>&1
if [ $? -eq 0  ] ;then
   LSSN=`cat "${workpatch}"/SrNm | grep -v "SrNm" -A1` 2>&1
SN=${LSSN///}
unset LSSN
fi
fi

# --------------------------------------------------------------------------------
if [ ! $SN ]; then
   SN="未提取到本项信息"
   SN2="⚠️  未获取序列号信息,请读取IMEI后去公众号反查
            推荐在“找机汇”公众号平台查询"
   WARR="\n···⚠️未获取工厂串号,序列号信息,请读取IMEI后去公众号反查\n\n··············推荐在“找机汇”公众号平台查询··············\n\n"
   open ./bin/AD-SN.jpg >/dev/null 2>&1
else
SNStatus=ok
fi

# imei 串号提取
if [[ -n "$bbpcfile" ]]; then
read=$(strings "${workpatch}"/"${bbpcfile}" | grep -o "imei" -A1 > "${workpatch}"/imei1) >/dev/null 2>&1
if [ $? -eq 0  ] ;then
imei=`cat "${workpatch}"/imei1 | grep -v "imei" -A1`
else
   if [[ -n "$snfile" ]]; then
read=$(strings "${workpatch}"/"${snfile}" | grep -o "imei" -A1 > "${workpatch}"/imei1) >/dev/null 2>&1
if [ $? -eq 0  ] ;then
imei=`cat "${workpatch}"/imei1 | grep -v "imei" -A1`
fi
fi

if [ -n $imei ]; then
   imeiStatus=ok
   fi
if [ ! $imei ] | [ ! $SN ]; then
   WARR="\n··⚠️未联机获取工厂串号,序列号信息,请正常联机··\n"
   imei="无法获取本项信息"
   meid="未提取到本项信息或本身两网"
elif [ ! $imei ]; then
   imei="未提取到本项信息"
#   WARR="\n··⚠️未获取工厂串号,序列号信息,请读取IMEI后去公众号反查··\n"   
fi
fi
fi


# meid 串号提取
if [[ -n "$bbpcfile" ]]; then
read=$(strings "${workpatch}"/"${bbpcfile}" | grep -o "meid" -A1 > "${workpatch}"/meid1) >/dev/null 2>&1
if [ $? -eq 0  ] ;then
meid=`cat "${workpatch}"/meid1 | grep -v "meid" -A1` >/dev/null 2>&1
else
   if [[ -n "$snfile" ]]; then
read=$(strings "${workpatch}"/"${snfile}" | grep -o "meid" -A1 > "${workpatch}"/meid1) >/dev/null 2>&1
if [ $? -eq 0  ] ;then
meid=`cat "${workpatch}"/meid1 | grep -v "meid" -A1` >/dev/null 2>&1
fi
fi
fi

if [ -n $meid ]; then
   meidStatus=ok
   fi
if [ ! $meid ]; then
   meid="未提取到本项信息或本身两网"
else
meidStatus="nodata"   
fi
fi

if [ ! -n "$ifcl" ]; then
ifcl=未提取到环境光检测码
fi
if [ ! -n "$pfcl" ]; then
pfcl=未提取到距离感应编码
fi
if [ ! -n "$MtSN" ]; then
MtSN=未提取到盖板的序列号
MtSN2=""
fi
if [ ! -n "$NvMR" ]; then
NvMR=此为面容设备不含指纹
fi
if [ ! -n "$imei" ]; then
imei=未提取到工厂串号信息
fi

if [[ "$jhstatus" = "jhok" ]]; then
echo " "
echo " "
echo "···········❤️  感谢捐助 ❤️ ·本工具仅供合法使用！··········"
echo " "
echo " "
else
bmac=半嫖免费，查全授权
emac=半嫖免费，查全授权
pfcl=半嫖免费，查全授权
ifcl=半嫖免费，查全授权
MtSN=半嫖免费，查全授权
NvMR=半嫖免费，查全授权
echo " "
echo " "
echo "⚠️无授权,请联系本人授权或自行根据半嫖WiFi码推算蓝牙码"
echo " "
echo " "
open ./Donate.jpg >/dev/null 2>&1
open https://weibo.com/u/7550681764 >/dev/null 2>&1
fi

if [ "$dev" = "iPad" ] && [ -n $hdimei ]; then
hdimei=(Wi-Fi版设备不含蜂窝模块)
hdmeid=(Wi-Fi版设备不含蜂窝模块)
imei=(Wi-Fi版设备不含蜂窝模块)
meid=(Wi-Fi版设备不含蜂窝模块)
WARR=" "
fi

if [[ "${dev}" =~ "ERROR" ]]; then
dev=""
fi


if [[ "${wifistatus}" = "ok" ]]; then

echo "         您当前解码的${dev}设备工厂信息 "
echo " "
echo " "
echo "📱 蜂窝网络串号: ${imei// /}"
echo "📱 电信网络串号: ${meid// /}"
echo "📱 设备序列号为: ${SN///} "
echo " ${SN2} "
echo "📱 无线网卡地址: ${wifi// /} "
echo "📱 蓝牙模块地址: ${bmac// /}"
echo "📱 有线网卡地址: ${emac// /}"
echo " "
echo "📱 距离感应码为: ${pfcl// /} "
echo "📱 环境光检测码: ${ifcl// /} "
echo "📱 盖板序列号为: ${MtSN// /} "
echo " "
echo "📱 指纹序列号为: ${NvMR// /} "
echo " "
echo "           ❤️  CDSQ 感谢您的注册 ❤️  "
echo "可关注 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq "
echo " "
echo "     注册授权是支持开发者今后开发的更多更好的程序"
echo "祝使用破解白嫖的和破解的人修啥啥坏，好的不灵坏的灵，自己瞎🐔8⃣️  自摸 "
echo " "


echo "       您当前解码的${dev}设备工厂信息

 蜂窝网络串号: ${imei// /}
 电信网络串号: ${meid// /}
 设备序列号为: ${SN// /}

 ${SN2}

 无线网卡地址: ${wifi// /}
 蓝牙模块地址: ${bmac// /}
 有线网卡地址: ${emac// /}

 距离感应码为: ${pfcl// /}
 环境光检测码: ${ifcl// /} 
 盖板序列号为: ${MtSN// /}

 指纹序列号为: ${NvMR// /}

            ❤️   CDSQ 感谢您的注册 ❤️  
可关注 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq

     注册授权是支持开发者今后开发的更多更好的程序
祝使用破解白嫖的和破解的人修啥啥坏，好的不灵坏的灵，自己瞎🐔8⃣️  自摸 


 " | LC_CTYPE=UTF-8 pbcopy
echo " "
echo " "
# display=`osascript -e 'display dialog "\n\n                        ⚙️ 您当前解码的'${dev// /}'设备工厂信息\n\n                         IMEI 串号：'${imei// /}' \n                       MEID 串号：'${meid// /}'\n                      本机序列号：'${SN///}' \n        '${WARR// /}'\n                     Wi-Fi地址码：'${wifi// /}' \n                       蓝牙地址码：'${bmac// /}' \n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n                   💻 微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
else
echo " "
echo "           ⚙️  您当前${dev}设备的工厂信息 "
echo " "
echo " ⁉️ 抱歉，此设备内未找到工厂参数文件，不支持此查询 "
echo " "
echo " "
fi

rm -rf ~/Library/Caches/factorydata >/dev/null 2>&1


# 本地解码有数据
if [ "$checkmode" = "local" ] && [ "$datastatus" = "ok" ] ; then
afplay ./bin/OK.aif
display=`osascript -e 'display dialog "\n\n                              ⚙️ 您当前解码的工厂信息\n\n                      蜂窝网络串号：'${imei// /}' \n                      电信网络串号：'${meid// /}'\n                      设备的序列号：'${SN///}' \n        '${WARR// /}'\n                     无线网卡地址：'${wifi// /}' \n                     蓝牙模块地址：'${bmac// /}' \n                     有线网卡地址：'${emac// /}' \n\n                     距离感应码为：'${pfcl// /}' \n                     环境光检测码：'${ifcl// /}'\n                     盖板序列号为：'${MtSN2}''\ \ \ \ \ ${MtSN// /}'  \n\n                     指纹的序列号：'${NvMR// /}'\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本:v'${softver}'"'`

# 本地解码无数据
elif [ "$checkmode" = "local" ] && [ "$datastatus" = "no" ] ; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "\n\n                              ⚙️ 您当前解码的工厂信息\n\n\n                         ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  \n\n                 📵  抱歉，未发现您要查的设备的关键信息 ....\n\n 目前发现大部分的 mini4 & Air2 有工厂文件但不包含关键数据\n\n                                          🙀  🙀  🙀  \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本:v'${softver}'"'`


# 未联机
elif [ "$checkmode" = "Online" ] && [ "$devstatus" = "当前未连接到设备" ]; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您当前尚未连接设备  ⚠️\n\n\n                            📱  请连接您需要读取的设备！\n\n\n                            ⚙️ 您当前设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  你设备都没连接上查个🔨呀......😂🥺😱😪\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`

# 已联机
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "nojb" ] && [ "$devstatus" = "设备现已正常联机" ]; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                        📱  您当前'\ ${dev// /·}\ '设备的硬盘信息\n\n  📱   设备型号类别: '${HM2// /·}'（'${HM// /·}\ ''${PT// /}'）\n  📱   处理器的型号: '${cpu2// /·}' ( '${cpu// /}' )\n  📱   设备型号类别: '${MN// /}' '${Reg// /}'\n  📱   设备序列号为: '${hdSN// /}'\n  📱   无线网卡地址: '${WMac// /}'\n  📱   蓝牙模块地址: '${BMac// /}'\n  📱   有线网卡地址: '${Ethe// /}'\n  📱   蜂窝网络串号: '${hdimei// /}'\n  📱   电信网络串号: '${hdmeid// /}'\n  📱   系统版本号为: '${os// /}' '${ver// /}' Build '${build// /}'\n\n\n                        ⚙️ 您当前'\ ${dev// /}\ '设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                       设备虽已正常联机但未处于越狱环境\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "设备现已正常联机" ] && [ "$datastatus" = "ok" ] ; then
afplay ./bin/OK.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                        📱  您当前'\ ${dev// /·}\ '设备的硬盘信息\n\n  📱   设备型号类别: '${HM2// /·}'（'${HM// /·}\ ''${PT// /}'）\n  📱   处理器的型号: '${cpu2// /·}' ( '${cpu// /}' )\n  📱   设备型号类别: '${MN// /}' '${Reg// /}'\n  📱   设备序列号为: '${hdSN// /}'\n  📱   无线网卡地址: '${WMac// /}'\n  📱   蓝牙地址码为: '${BMac// /}'\n  📱   有线网卡地址: '${Ethe// /}'\n  📱   蜂窝网络串号: '${hdimei// /}'\n  📱   电信网络串号: '${hdmeid// /}'\n  📱   系统版本号为: '${os// /}' '${ver// /}' Build '${build// /}'\n\n\n                        ⚙️ 您当前'\ ${dev// /}\ '设备的工厂信息\n\n                     蜂窝网络串号：'${imei// /}' \n                     电信网络串号：'${meid// /}'\n                     设备原厂序号：'${SN///}' \n        '${WARR// /}'\n                     无线网卡地址：'${wifi// /}' \n                     蓝牙地址码为：'${bmac// /}' \n                     有线网卡地址：'${emac// /}' \n\n '${jh// /}' \n\n                     距离感应编码：'${pfcl// /}' \n                     环境光检测码：'${ifcl// /}' \n                     盖板序列号为：'${MtSN2}''\ \ \ \ \ ${MtSN// /}'\n\n                     指纹序列号为：'${NvMR// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","退出" } default button 2 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "设备现已正常联机" ] && [ "$datastatus" = "no" ] ; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                        📱  您当前'\ ${dev// /·}\ '设备的硬盘信息\n\n  📱   设备型号类别: '${HM2// /·}'（'${HM// /·}\ ''${PT// /}'）\n  📱   处理器的型号: '${cpu2// /·}' ( '${cpu// /}' )\n  📱   设备型号类别: '${MN// /}' '${Reg// /}'\n  📱   设备序列号为: '${hdSN// /}'\n  📱   无线网卡地址: '${WMac// /}'\n  📱   蓝牙地址码为: '${BMac// /}'\n  📱   有线网卡地址: '${Ethe// /}'\n  📱   蜂窝网络串号: '${hdimei// /}'\n  📱   电信网络串号: '${hdmeid// /}'\n  📱   系统版本号为: '${os// /}' '${ver// /}' Build '${build// /}'\n\n\n                        ⚙️ 您当前'\ ${dev// /}\ '设备的工厂信息\n\n\n                         ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  \n\n                 📵  抱歉，虽然设备包含工厂数据文件\n                        但未发现您要查的设备的关键信息 ....\n\n 目前发现大部分的 mini4 & Air2 有工厂文件但不包含关键数据\n\n                                          🙀  🙀  🙀  \n\n '${jh// /}' \n\n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","退出" } default button 2 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`

# 当前设备没有解锁
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "nojb" ] && [ "$devstatus" = "当前设备没有解锁" ]; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您当前的设备未解锁  ⚠️\n\n\n                            🔓  请解锁您需要读取的设备！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "当前设备没有解锁" ] && [ "$datastatus" = "ok" ] ; then
afplay ./bin/OK.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您当前的设备未解锁  ⚠️\n\n\n                            🔓  请解锁您需要读取的设备！\n\n\n                        ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n                     蜂窝网络串号：'${imei// /}' \n                     电信网络串号：'${meid// /}'\n                     设备原厂序号：'${SN///}' \n        '${WARR// /}'\n                     无线网卡地址：'${wifi// /}' \n                     蓝牙地址码为：'${bmac// /}' \n                     有线网卡地址：'${emac// /}' \n\n '${jh// /}' \n\n                     距离感应编码：'${pfcl// /}' \n                     环境光检测码：'${ifcl// /}' \n                     盖板序列号为：'${MtSN2}''\ \ \ \ \ ${MtSN// /}'\n\n                     指纹序列号为：'${NvMR// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "当前设备没有解锁" ] && [ "$datastatus" = "no" ] ; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您当前的设备未解锁  ⚠️\n\n\n                            🔓  请解锁您需要读取的设备！\n\n\n                        ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                         ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  ⁉️  \n\n                 📵  抱歉，虽然设备包含工厂数据文件\n                        但未发现您要查的设备的关键信息 ....\n\n 目前发现大部分的 mini4 & Air2 有工厂文件但不包含关键数据\n\n                                          🙀  🙀  🙀  \n\n '${jh// /}' \n\n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`

# 点击屏幕信任设备
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "nojb" ] && [ "$devstatus" = "点击屏幕信任设备" ]; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您当前的设备未信任  ⚠️\n\n\n                    🔓  请解锁设备并点击弹窗的“信任”按钮！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "点击屏幕信任设备" ] && [ "$datastatus" = "ok" ] ; then
afplay ./bin/OK.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您当前的设备未信任  ⚠️\n\n\n                    🔓  请解锁设备并点击弹窗的“信任”按钮！\n\n\n                        ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n                     蜂窝网络串号：'${imei// /}' \n                     电信网络串号：'${meid// /}'\n                     设备原厂序号：'${SN///}' \n        '${WARR// /}'\n                     无线网卡地址：'${wifi// /}' \n                     蓝牙地址码为：'${bmac// /}' \n                     有线网卡地址：'${emac// /}' \n\n '${jh// /}' \n\n                     距离感应编码：'${pfcl// /}' \n                     环境光检测码：'${ifcl// /}' \n                     盖板序列号为：'${MtSN2}''\ \ \ \ \ ${MtSN// /}'\n\n                     指纹序列号为：'${NvMR// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "点击屏幕信任设备" ] && [ "$datastatus" = "no" ] ; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您当前的设备未信任  ⚠️\n\n\n                    🔓  请解锁设备并点击弹窗的“信任”按钮！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`

# 已拒绝了信任设备
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "nojb" ] && [ "$devstatus" = "已拒绝了信任设备" ]; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您拒绝了信任我操作  ⚠️\n\n\n                    💔  您在设备上都不信任我还查个🐓儿呀！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "已拒绝了信任设备" ] && [ "$datastatus" = "ok" ] ; then
afplay ./bin/OK.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您拒绝了信任我操作  ⚠️\n\n\n                    💔  您在设备上都不信任我还查个🐓儿呀！\n\n\n                        ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n                     蜂窝网络串号：'${imei// /}' \n                     电信网络串号：'${meid// /}'\n                     设备原厂序号：'${SN///}' \n        '${WARR// /}'\n                     无线网卡地址：'${wifi// /}' \n                     蓝牙地址码为：'${bmac// /}' \n                     有线网卡地址：'${emac// /}' \n\n '${jh// /}' \n\n                     距离感应编码：'${pfcl// /}' \n                     环境光检测码：'${ifcl// /}' \n                     盖板序列号为：'${MtSN2}''\ \ \ \ \ ${MtSN// /}'\n\n                     指纹序列号为：'${NvMR// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "已拒绝了信任设备" ] && [ "$datastatus" = "no" ] ; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                              ⚠️  您拒绝了信任我操作  ⚠️\n\n\n                    💔  您在设备上都不信任我还查个🐓儿呀！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`

# 信息读取组件错误
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "nojb" ] && [ "$devstatus" = "信息读取组件错误" ]; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                             ⚠️  设备信息读取环境错误  ⚠️\n\n\n                   🚧  您信息环境有问题,需要修复组件环境！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "组件修复","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "信息读取组件错误" ] && [ "$datastatus" = "ok" ] ; then
afplay ./bin/OK.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                             ⚠️  设备信息读取环境错误  ⚠️\n\n\n                   🚧  您信息环境有问题,需要修复组件环境！\n\n\n                        ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n                     蜂窝网络串号：'${imei// /}' \n                     电信网络串号：'${meid// /}'\n                     设备原厂序号：'${SN///}' \n        '${WARR// /}'\n                     无线网卡地址：'${wifi// /}' \n                     蓝牙地址码为：'${bmac// /}' \n                     有线网卡地址：'${emac// /}' \n\n '${jh// /}' \n\n                     距离感应编码：'${pfcl// /}' \n                     环境光检测码：'${ifcl// /}' \n                     盖板序列号为：'${MtSN2}''\ \ \ \ \ ${MtSN// /}'\n\n                     指纹序列号为：'${NvMR// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","组件修复","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "信息读取组件错误" ] && [ "$datastatus" = "no" ] ; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                             ⚠️  设备信息读取环境错误  ⚠️\n\n\n                   🚧  您信息环境有问题,需要修复组件环境！\n\n\n                            ⚙️ 您当前'\ ${dev// /}\ '设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "组件修复","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`

# 当前连接状态未知
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "nojb" ] && [ "$devstatus" = "当前连接状态未知" ]; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                             ⚠️  设备联机出现未知状态  ⚠️\n\n\n                   🚧  您联机状态有问题,请再次联机来尝试！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "当前连接状态未知" ] && [ "$datastatus" = "ok" ] ; then
afplay ./bin/OK.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                             ⚠️  设备联机出现未知状态  ⚠️\n\n\n                   🚧  您联机状态有问题,请再次联机来尝试！\n\n\n                        ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n                     蜂窝网络串号：'${imei// /}' \n                     电信网络串号：'${meid// /}'\n                     设备原厂序号：'${SN///}' \n        '${WARR// /}'\n                     无线网卡地址：'${wifi// /}' \n                     蓝牙地址码为：'${bmac// /}' \n                     有线网卡地址：'${emac// /}' \n\n '${jh// /}' \n\n                     距离感应编码：'${pfcl// /}' \n                     环境光检测码：'${ifcl// /}' \n                     盖板序列号为：'${MtSN2}''\ \ \ \ \ ${MtSN// /}'\n\n                     指纹序列号为：'${NvMR// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "导出工厂码底层文件","退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
elif [ "$checkmode" = "Online" ] && [ "$jbstatus" = "jbok" ] && [ "$devstatus" = "当前连接状态未知" ] && [ "$datastatus" = "no" ] ; then
afplay ./bin/ERR.aif
display=`osascript -e 'display dialog "                   💻📲 设备联机状态：'${devstatus// /}'\n\n                              📱  您当前设备的硬盘信息\n\n\n                             ⚠️  设备联机出现未知状态  ⚠️\n\n\n                   🚧  您联机状态有问题,请再次联机来尝试！\n\n\n                            ⚙️ 您当前'${dev// /}'设备的工厂信息\n\n\n                          ‼️ 抱歉！您的使用方法不对 ‼️\n\n                  设备未处于越狱环境或无法建立通信连接\n\n  ⛑ 工厂码查询需设备处于越狱环境且通信传输通道正常连接 \n\n    请仔细检查设备硬件和越狱引导状态，确认正常后再次提取\n\n '${jh// /}' \n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n\n     💻 微信：cdsqtuzi ；微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`

fi

if [ "$display" = "button returned:组件修复" ];then
./组件修复
fi

if [ "$display" = "button returned:导出工厂码底层文件" ] && [ "$jhstatus" = "jhno" ] ;then
BL=`osascript -e 'display dialog "\n                    🎊 欢迎使用  iOS设备工厂码查询器 🎊\n\n   💡本查询器主要用于找回 iPhone/iPad 设备丢失的工厂出厂原始 序列号/Wi-Fi/蓝牙 地址码 信息（如 硬盘损坏更换），提取的工厂码信息自动发送至剪贴板可直接粘贴，可输出提取的工厂码的“底层”文件，可脱机解码其他途径提取的工厂数据文件。\n\n                                  📱  支 持 设 备  📱\n\n    🔘 iPhone 6-X；iPad iOS 版本为 13 及以上版本的越狱设备\n\n          🛑 非常抱歉,您没有付费授权使用本底层导出功能 🛑 \n\n '${jh// /}' \n\n                                  👤  用 户 权 限  👤\n\n    ⚬ 免费用户：\n        可读取设备联机的当前硬盘数据，可提取工厂码的序列号及Wi-Fi地址码，蓝牙码需自行推算\n\n    ⚬ 授权用户：\n       在免费用户的基础上可解码蓝牙地址码；可脱机解码其他途径提取的工厂数据文件；可输出解码的工厂码“底层”文件；环境安装调试的远程协助；\n\n ⚠️ 郑重声明:本工具仅供合法使用,一切纠纷由使用者自行承担!\n\n                 🛠 本工具由威锋技术组 CDSQ 编辑制作\n                     💻 微博：CDSQ-D ；推特：@wecdsq" buttons { "退出" } default button 1 with title "CDSQ iPhone 工厂码查询器 版本: v'${softver}'"'`
exit
fi

if [ "$display" = "button returned:导出工厂码底层文件" ] && [ "$jhstatus" = "jhok" ] ;then
   if [ "$SNStatus" = "ok" ] && [ "$wifistatus" = "ok" ]; then
outdaigs=`osascript -e 'set dir to POSIX path of (choose file name with prompt "请选择输出底层文件保存的文件夹" default name "'${SN}'-工厂三码底层.bin")' 2>/dev/null`
if [[ -z "$outdaigs" ]]; then
alert=`osascript -e 'display alert "❌💾 已取消底层数据文件保存" buttons { "关闭" } default button 1 as critical giving up after 3'`
else
echo "# CDSQ 编制，weibo：https://weibo.com/u/7550681764 微信号：cdsqtuzi

syscfg add SrNm  ${SN}
syscfg add WMac  0x${wifi:9:2}${wifi:6:2}${wifi:3:2}${wifi:0:2} 0x0000${wifi:15:2}${wifi:12:2} 0x00000000 0x00000000
syscfg add BMac  0x${bmac:9:2}${bmac:6:2}${bmac:3:2}${bmac:0:2} 0x0000${bmac:15:2}${bmac:12:2} 0x00000000 0x00000000
syscfg add EMac  0x${emac:9:2}${bmac:6:2}${emac:3:2}${emac:0:2} 0x0000${emac:15:2}${emac:12:2} 0x00000000 0x00000000" > $outdaigs
alert=`osascript -e 'display alert "💾 底层文件保存完成\n\n 含序列号，Wi-Fi和蓝牙地址码的底层文件已保存为:\n '${outdaigs}' " buttons { "关闭" } default button 1 as critical giving up after 10'`
open -R $outdaigs
fi

elif [ "$wifistatus" = "ok" ] && [ "$bmacstatus" = "ok" ] && [ "$SNStatus" = "no" ]; then
outdaigs=`osascript -e 'set dir to POSIX path of (choose file name with prompt "请选择输出底层文件保存的文件夹" default name "未命名-工厂不含序列号两码底层.bin")' 2>/dev/null`
if [[ -z "$outdaigs" ]]; then
alert=`osascript -e 'display alert "❌💾 已取消底层数据文件保存" buttons { "关闭" } default button 1 as critical giving up after 3'`
else
echo "# CDSQ 编制，weibo：https://weibo.com/u/7550681764 微信号：cdsqtuzi

syscfg add WMac  0x${wifi:9:2}${wifi:6:2}${wifi:3:2}${wifi:0:2} 0x0000${wifi:15:2}${wifi:12:2} 0x00000000 0x00000000
syscfg add BMac  0x${bmac:9:2}${bmac:6:2}${bmac:3:2}${bmac:0:2} 0x0000${bmac:15:2}${bmac:12:2} 0x00000000 0x00000000
syscfg add EMac  0x${emac:9:2}${bmac:6:2}${emac:3:2}${emac:0:2} 0x0000${emac:15:2}${emac:12:2} 0x00000000 0x00000000" > $outdaigs
alert=`osascript -e 'display alert "💾 底层文件保存完成\n\n 不含序列号，仅Wi-Fi和蓝牙地址码的底层文件已保存为:\n '${outdaigs}' " buttons { "关闭" } default button 1 as critical giving up after 10'`
open -R $outdaigs
fi
fi
exit
fi






