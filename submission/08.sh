# Create a raw transaction with a transaction fee of 20,000 satoshis 
# The transaction fee should be 20,000 satoshis, then the rest of the amount should be sent to the address: 2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP
# Use the UTXOs from the transaction below
# raw_tx="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"
raw_tx="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"
recipient="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
TXID=$(bitcoin-cli -regtest decoderawtransaction "$raw_tx" | jq -r '.txid')
total_sats=$(bitcoin-cli -regtest decoderawtransaction "$raw_tx" | jq '[.vout[].value*100000000|floor] | add')
fee=20000
send_sats=$((total_sats - fee))
send_btc=$(awk -v s="$send_sats" 'BEGIN { printf "%.8f", s/100000000 }')
inputs=$(jq -n --arg txid "$TXID" '[{"txid":$txid,"vout":0,"sequence":4294967293},{"txid":$txid,"vout":1,"sequence":4294967293}]')
outputs="{\"$recipient\":$send_btc}"
bitcoin-cli -regtest -named createrawtransaction inputs="$inputs" outputs="$outputs"
