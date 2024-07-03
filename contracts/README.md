### Run tests:
```bash
forge test
```

### Compare gas costs between OpenZeppelin and Solmate library
```bash
forge test --gas-report
```
#### Deployment:

Set the following environment variables

```bash
export RPC_URL=https://arbitrum-sepolia.blockpi.network/v1/rpc/public
export PRIVATE_KEY=add346348901c1c5e35f750628e322f99eee5b6d98d61d4213b0484ca9583b90
```

```bash
npm run deploy <constructor-args>
```
#### Send transaction:
```bash
npm run send <contractAddress> <functionSignature> <args>
```
