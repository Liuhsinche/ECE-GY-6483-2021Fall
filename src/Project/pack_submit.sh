cp RTL/RTL.runs/impl_1/zcu104_wrapper.bit SkyNet.bit
cp RTL/RTL.srcs/sources_1/bd/zcu104/hw_handoff/zcu104.hwh SkyNet.hwh
cp -r ./HLS/Baseline/syn/report reports
zip -r Baseline.zip src reports SkyNet.bit SkyNet.hwh
rm SkyNet.bit
rm SkyNet.hwh
rm -r reports