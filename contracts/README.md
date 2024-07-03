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
export PRIVATE_KEY=
```

```bash
npm run deploy <constructor-args>
```
#### Send transaction:
```bash
npm run send <contractAddress> <functionSignature> <args>
```
