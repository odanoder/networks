#!/bin/bash
#Project cascadia
echo "Start ----------------------" >> $HOME/plogs/log_cascadia.txt
echo "Project: Cascadia" >> $HOME/plogs/log_cascadia.txt
echo "Date: $(TZ='Europe/Kiev' date +'%d.%m.%Y')" >> $HOME/plogs/log_cascadia.txt
echo "Time -start: $(TZ='Europe/Kiev' date +'%H:%M')/n" >> $HOME/plogs/log_cascadia.txt

echo "Withdraw Reward and Commission" >> $HOME/plogs/log_cascadia.txt
cascadiad tx distribution withdraw-rewards $(cascadiad keys show wallet --bech val -a) \
  --commission \
  --from wallet \
  --chain-id cascadia_11029-1 \
  --gas-prices 7aCC -y \
  | grep -E 'txhash:|code:' >> $HOME/plogs/log_cascadia.txt

sleep 30
 
echo "Cascadia key Balances" >> $HOME/plogs/log_cascadia.txt
cascadiad q bank balances $(cascadiad keys show wallet -a) \
| grep -E 'amount:'  >> $HOME/plogs/log_cascadia.txt
echo "amount=1:  10000000000000000aCC" >> $HOME/plogs/log_cascadia.txt

echo "Time -stop: $(TZ='Europe/Kiev' date +'%H:%M')" >> $HOME/plogs/log_cascadia.txt
echo -e "----------------------STOP\n\n" >> $HOME/plogs/log_cascadia.txt
