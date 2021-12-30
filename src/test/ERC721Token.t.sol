// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "std/Vm.sol";
import "ds-test/test.sol";
import "../ERC721Token.sol";

contract ERC721TokenTest is DSTest {
    Vm internal constant hevm = Vm(HEVM_ADDRESS);
    ERC721Token internal token;

    function setUp() public {
        token = new ERC721Token("Test Token", "TEST", "http://example.com/");
    }

    function testMintWithNoEth() public {
        hevm.expectRevert(abi.encodeWithSignature("NotEnoughETH()"));

        token.mint(1);
    }

    function testMintWithMaxSupply() public {
        // set totalSupply counter to max supply
        hevm.store(
            address(token),
            bytes32(uint256(3)),
            bytes32(token.TOTAL_SUPPLY())
        );

        uint256 tokenPrice = token.PRICE_PER_MINT();

        hevm.expectRevert(abi.encodeWithSignature("NoTokensLeft()"));
        token.mint{value: tokenPrice * 2}(2);
    }

    function testMint(uint16 amount) public {
        // skip fuzzing when the amount is bigger than the supply
        if (amount > token.TOTAL_SUPPLY()) return;

        uint256 tokenPrice = token.PRICE_PER_MINT();

        token.mint{value: tokenPrice * amount}(amount);

        assertEq(token.balanceOf(address(this)), amount);
    }

    function testWithdraw() public {
        uint256 initialBalance = address(this).balance;
        assertEq(address(token).balance, 0);

        hevm.deal(address(token), 1 ether);
        assertEq(address(token).balance, 1 ether);

        token.withdraw();

        assertEq(address(token).balance, 0);
        assertEq(address(this).balance, initialBalance + 1 ether);
    }

    // Required for `testWithdraw()`
    receive() external payable {}
}
