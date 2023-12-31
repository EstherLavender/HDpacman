// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import {IERC20} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';
import {IAxelarGasService} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import {AxelarExecutable} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';

contract PacmanRewardDistributor is AxelarExecutable {
    IAxelarGasService immutable gasService;

    constructor(
        address _gateway,
        address _gasReceiver
    ) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasReceiver);
    }

    event RewardDistributed(address indexed recipient, uint256 amount);

    function _executeWithToken(
        string calldata,
        string calldata,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 totalAmount
    ) internal override {
        address[] memory recipients = abi.decode(payload, (address[]));
        address tokenAddress = gateway.tokenAddresses(tokenSymbol);

        uint256 sentAmount = totalAmount / recipients.length;
        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20(tokenAddress).transfer(recipients[i], sentAmount);
            emit RewardDistributed(recipients[i], sentAmount);
        }
    }
}
//0xBeF57dA8a0FC7ffc52205D3aE4Cb0Ef47516a29a-Avalanche
//0x54C3cA45C6596094B631b185f20d1E2c7cF7C51B-polygon
