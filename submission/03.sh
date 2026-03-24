# Create a SegWit address.
# Add funds to the address.
# Return only the Address
ADDRESS=$(bitcoin-cli -regtest -rpcwallet="builderswallet" getnewaddress "" bech32)
bitcoin-cli -regtest generatetoaddress 101 "$ADDRESS" > /dev/null 2>&1
echo "$ADDRESS"