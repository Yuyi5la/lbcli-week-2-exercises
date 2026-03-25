# Create a raw transaction with an amount of 20,000,000 satoshis to this address: 2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP 
# Use the UTXOs from the transaction below
#raw_tx="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"
raw_tx=$(bitcoin-cli -regtest createrawtransaction \
'[{"txid":"23c19f37d4e92e9a115aab86e4edc1b92a51add4e0ed0034bb166314dde50e16","vout":0},
  {"txid":"23c19f37d4e92e9a115aab86e4edc1b92a51add4e0ed0034bb166314dde50e16","vout":1}]' \
'{"2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP":0.2,
  "bcrt1qlpy0u5n8fydg5hfjgg77fv9zf5gxt3srrykua5":0.03669108}')
signed_tx=$(bitcoin-cli -regtest signrawtransactionwithwallet "$raw_tx" | jq -r '.hex')
bitcoin-cli -regtest sendrawtransaction "$signed_tx"