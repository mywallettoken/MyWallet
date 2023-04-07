from .contract import contract, contractAddress, web3

def getBalance(address: str, tokenId: int):
    address = str(address)

    if not web3.is_address(address): return False, f"Address '{address}' is not valid."

    try: tokenId = int(tokenId)
    except: return False, f"Tokne id must be an integer."

    return True, contract.functions.balanceOf(address, tokenId).call()

def snedTransaction(fromAddress: str, secretKet: str, toAddress: str, tokenId: int, amount: int):
    fromAddress = str(fromAddress)
    secretKet = str(secretKet)
    toAddress = str(toAddress)

    if not web3.is_address(fromAddress): return False, f"Sender address '{fromAddress}' is not valid."
    if not web3.is_address(toAddress): return False, f"Receiver address '{toAddress}' is not valid."

    try: tokenId = int(tokenId)
    except: return False, f"Tokne id must be an integer."

    try: amount = int(amount)
    except: return False, f"Amount must be an integer."

    transaction = {
        "from": fromAddress,
        "to": contractAddress,
        "value": web3.to_hex(0),
        "gas": 530000,
        "gasPrice": web3.to_wei(100, "gwei"),
        "nonce": web3.eth.get_transaction_count(fromAddress),
        "data": contract.encodeABI('safeTransferFrom', args=(fromAddress, toAddress, tokenId, amount)),
    }

    print(web3.eth.get_transaction_count(fromAddress))

    try:
        signed_tx = web3.eth.account.sign_transaction(transaction, secretKet)
        transactionHash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)

        return True, web3.to_hex(transactionHash)
    except: return False, "Some error occured, please try again later."