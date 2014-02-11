#!/bin/bash
for i in $(seq 30)
do
  #rails runner Tasks::SaveTask.execute\("7.0"\,"-73.0"\)
  #rails runner Tasks::SaveTask.execute\("39.0"\,"141.0"\)
  #rails runner Tasks::SaveTask.execute\("-82.0"\,"-133.0"\)
  #rails runner Tasks::SaveTask.execute\("31.0"\,"-100.0"\)
  #rails runner Tasks::SaveTask.execute\("43.7"\,"39.9"\)
  #rails runner Tasks::SaveTask.execute\("69.4"\,"88.4"\)
  #rails runner Tasks::SaveTask.execute\("-34.0"\,"151.3"\)
  rails runner Tasks::SaveTask.execute\("51.6"\,"0.27"\)
  #rails runner Tasks::SaveTask.execute\("-1.5"\,"36.9"\)
done
