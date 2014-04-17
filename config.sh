MainProjectRoot="AnjukeBroker_New"
Schema="AnjukeBroker_New"

ProvisoningProfileForDailybuild="CF9D5379-0CDF-4AF6-8D5D-F1E2E06CA64C"
#ProvisoningProfileForDistribute="C684A69D-0F0D-4CEC-8274-C8707AA7ED38"
ProvisoningProfileForDistribute="C684A69D-0F0D-4CEC-8274-C8707AA7ED38"

SignIdentityForDailyBuild="iPhone Distribution: Ruiting Network Technology (Shanghai) Co., Ltd."
#SignIdentityForRelease="iPhone Distribution: RUITING NETWORK TECHNOLOGY(SHANGHAI)CO.,LTD."
SignIdentityForRelease="Phone Distribution: RUITING NETWORK TECHNOLOGY(SHANGHAI)CO.,LTD (52KTBFLJDB)"

ProjectFileName=`ls ./|grep 'xcworkspace'`
ProjectName=`echo ${ProjectFileName}|awk -F'[\.]' '{print $1}'`
Version=`grep 'CFBundleVersion' -A 1 ./${ProjectName}/${MainProjectRoot}-Info.plist|grep string|awk -F'[\>\<]' '{print $3}'`

#QudaoList="A00 A01 A02 A08 A17 A18"
QudaoList="A00 A02 A08 A17 A18 A19 A20 A21 A22"

AnjukebuildPath="/tmp/anjukeBroker_Newbuild"
if [ ! -d ${AnjukeBuidPath} ] ; then
    mkdir -p ${AnjukeBuildPath}
fi

AnjukeQudaoPath="/Users/anjuke/RUITING/i-anjuke/${Version}"
if [ ! -d ${AnjukeQudaoPath} ]; then
    mkdir -p ${AnjukeQudaoPath}
fi

RemotePackagePath='mobile@ios.dev.anjuke.com:/var/www/apps/AnjukeBroker_New_Enterprice/ipa/'

#denpendences
#dependences[0]='RTApiProxy:master'
#dependences[1]='RTCoreService:master'
#dependences[2]='RTNetwork:master'
#dependences[3]='UIComponents:master'