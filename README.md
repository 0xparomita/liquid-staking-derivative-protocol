# Liquid Staking Derivative Protocol

This repository implements a Liquid Staking solution that unlocks the liquidity of staked assets. When users deposit the base asset, the protocol issues a "Liquid Staking Token" (LST) that represents the user's share of the total staked pool plus accrued rewards.

## Core Mechanism
* **Staking:** Users deposit ETH; the contract mints `stETH` based on the current exchange rate.
* **Exchange Rate:** As staking rewards accumulate from validators, the value of `stETH` increases relative to ETH.
* **Withdrawal Queue:** To ensure security and handle validator exit delays, withdrawals are processed through a FIFO queue.



## Key Components
* **LST Token:** An ERC-20 token that serves as the receipt for staked funds.
* **Staking Pool:** The primary entry point for users; manages the internal accounting of principal and rewards.
* **Node Operator Registry:** Tracks authorized validators to whom the pooled assets are delegated.

## Usage
1. **Deposit:** Call `submit()` with the asset you wish to stake.
2. **Transfer/DeFi:** Use your `stAsset` in other protocols while still earning rewards.
3. **Redeem:** Request a withdrawal to burn your `stAsset` and claim your portion of the pool.
