// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract LiquidStakingToken is ERC20, Ownable {
    constructor() ERC20("Staked Asset", "stASSET") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}

contract LiquidStakingPool is Ownable, ReentrancyGuard {
    LiquidStakingToken public immutable stToken;
    
    uint256 public totalPooledAsset;
    uint256 public totalShares;

    event Submitted(address indexed sender, uint256 amount, uint256 shares);
    event RewardsDistributed(uint256 amount);

    constructor() Ownable(msg.sender) {
        stToken = new LiquidStakingToken();
    }

    /**
     * @dev User deposits native asset and receives liquid staking tokens.
     */
    function submit() external payable nonReentrant {
        require(msg.value > 0, "Cannot stake 0");

        uint256 sharesToMint = getSharesByPooledAsset(msg.value);
        if (totalShares == 0) {
            sharesToMint = msg.value;
        }

        totalPooledAsset += msg.value;
        totalShares += sharesToMint;

        stToken.mint(msg.sender, sharesToMint);
        emit Submitted(msg.sender, msg.value, sharesToMint);
    }

    /**
     * @dev Simulates reward accumulation from validators.
     */
    function distributeRewards(uint256 _rewardAmount) external onlyOwner {
        totalPooledAsset += _rewardAmount;
        emit RewardsDistributed(_rewardAmount);
    }

    function getSharesByPooledAsset(uint256 _amount) public view returns (uint256) {
        if (totalPooledAsset == 0) return _amount;
        return (_amount * totalShares) / totalPooledAsset;
    }

    function getPooledAssetByShares(uint256 _shares) public view returns (uint256) {
        if (totalShares == 0) return 0;
        return (_shares * totalPooledAsset) / totalShares;
    }

    receive() external payable {
        this.submit{value: msg.value}();
    }
}
