import os
from web3 import Web3
from dotenv import load_dotenv

load_dotenv()

provider = os.getenv("WEB3_PROVIDER")
web3 = Web3(Web3.HTTPProvider(provider))

abi = str(open("./src/abi.json", "r").read())
contractAddress = os.getenv("CONTRACT_ADDRESS")

contract = web3.eth.contract(address=contractAddress, abi=abi)