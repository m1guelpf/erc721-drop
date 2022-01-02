// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import "./LilOwnable.sol";
import "solmate/tokens/ERC721.sol";
import "solmate/utils/SafeTransferLib.sol";

error DoesNotExist();
error NoTokensLeft();
error NotEnoughETH();

contract ERC721Token is LilOwnable, ERC721 {
    uint256 public constant TOTAL_SUPPLY = 10_000;
    uint256 public constant PRICE_PER_MINT = 0.05 ether;

    uint256 public totalSupply;

    string public baseURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory _baseURI
    ) payable ERC721(name, symbol) {
        baseURI = _baseURI;
    }

    function mint(uint16 amount) external payable {
        if (totalSupply + amount >= TOTAL_SUPPLY) revert NoTokensLeft();
        if (msg.value < amount * PRICE_PER_MINT) revert NotEnoughETH();

        unchecked {
            for (uint16 index = 0; index < amount; index++) {
                _mint(msg.sender, totalSupply++);
            }
        }
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (ownerOf[id] == address(0)) revert DoesNotExist();

        return string(abi.encodePacked(baseURI, id));
    }

    function withdraw() external {
        if (msg.sender != _owner) revert NotOwner();

        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override(LilOwnable, ERC721)
        returns (bool)
    {
        return
            interfaceId == 0x7f5828d0 || // ERC165 Interface ID for ERC173
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC165
            interfaceId == 0x01ffc9a7; // ERC165 Interface ID for ERC721Metadata
    }
}
