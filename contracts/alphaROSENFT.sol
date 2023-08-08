// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract alphaROSENFT is ERC1155 {

    string public name = "alpha ROSE NFT";

    string public symbol = "This NFT inherits Oasis Network's spirit of privacy and high performance to serve alphagram early users";

    //每个tokenID的最大mint数量
    mapping(uint256 => uint256) public token_ids_num;

    //记录每个nft被领取的个数
    mapping(uint256 => uint256) public  token_ids_mint_num;

    //定义合约的发起方
    address payable owner;

    constructor()  ERC1155("https://ipfs.io/ipfs/bafybeiflo7sjcf26j65fjkxdqleb24s6rfh6ftqpubjpltyr2nhemplpdu/alphaROSENFT.json") {
        token_ids_num[1357] = 4000;
        token_ids_mint_num[1357] = 1;
        owner = payable(msg.sender);
    }

    //管理员设置最大的mint个数
    function setTokendIdInfo(uint256 _token_id , uint256 _numbers) public {
        require(msg.sender == owner, "Temporarily without authority");
        if(token_ids_num[_token_id] == 0){
            token_ids_mint_num[_token_id] = 1;
        }
        token_ids_num[_token_id] =  _numbers;
    }


    //用户mint NFT
    function mint(uint256 _token_id) public returns (uint256) {

        // nft 是否被定义 个数 是否超出 判断个数是否超出
        require(token_ids_num[_token_id] > 0, "nft token id  is not insufficient");
        require(token_ids_num[_token_id] >= token_ids_mint_num[_token_id], "nft token id  is not insufficient");

        //判断是否已经mint
        uint256 balance = balanceOf(msg.sender,_token_id);
        require(balance == 0, "You already mint this nft");

        //计数
        uint256 amount = token_ids_mint_num[_token_id];
        _mint(msg.sender, _token_id, token_ids_mint_num[_token_id], "");
        token_ids_mint_num[_token_id]++;
        return  amount;
    }

    /**
     * 发起交易
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        //判断是否授权
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        //只有发起人有交易的权限
        require(
            from == owner,
            "ERC1155: You can't trade"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }


    /**
     * 批量发起交易
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        //只有发起人有交易的权限
        require(
            from == owner,
            "ERC1155: You can't trade"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }
}