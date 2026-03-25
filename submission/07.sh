# Create a raw transaction with an amount of 20,000,000 satoshis to this address: 2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP 
# Use the UTXOs from the transaction below
#raw_tx="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"
#!/bin/bash
set -e

# Input UTXO transaction
RAW_TX="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"

# Decode to get TXID and output value
TXID=$(bitcoin-cli -regtest decoderawtransaction "$RAW_TX" | jq -r '.txid')
UTXO_VALUE=$(bitcoin-cli -regtest decoderawtransaction "$RAW_TX" | jq '.vout[0].value * 100000000 | floor')
VOUT_INDEX=0  # first output

echo "Using UTXO:"
echo "TXID: $TXID"
echo "Vout: $VOUT_INDEX"
echo "Value: $UTXO_VALUE satoshis"

# Amount to send
PAYMENT_AMOUNT=20000000  # satoshis

# Fee rate
FEE_RATE=10  # satoshis per vbyte

# Approximate tx size: base 10 + 1 input 68 + 2 outputs 31 each
TX_SIZE=$((10 + 68*1 + 31*2))
FEE_SATS=$((TX_SIZE * FEE_RATE))

# Change calculation
CHANGE_AMOUNT=$((UTXO_VALUE - PAYMENT_AMOUNT - FEE_SATS))

# Convert to BTC
PAYMENT_BTC=$(echo "scale=8; $PAYMENT_AMOUNT/100000000" | bc)
CHANGE_BTC=$(echo "scale=8; $CHANGE_AMOUNT/100000000" | bc)

# Addresses
PAYMENT_ADDRESS="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
CHANGE_ADDRESS="bcrt1qg09ftw43jvlhj4wlwwhkxccjzmda3kdm4y83ht"

# Create input JSON with RBF enabled (sequence < 0xffffffff)
TX_INPUTS='[{"txid":"'$TXID'","vout":'$VOUT_INDEX',"sequence":4294967293}]'

# Create outputs JSON
TX_OUTPUTS='{"'$PAYMENT_ADDRESS'":'$PAYMENT_BTC',"'$CHANGE_ADDRESS'":'$CHANGE_BTC'}'

# Create the raw transaction
RAW_RBF_TX=$(bitcoin-cli -regtest createrawtransaction "$TX_INPUTS" "$TX_OUTPUTS")

echo "Raw transaction hex:"
echo $RAW_RBF_TX