import datetime
from src.html import *
from src.operators import *
from flask import Flask, render_template, request

server = Flask(__name__)

# Home Page
@server.route("/")
def index():
    return render_template(
        template_name_or_list="index.html",
        title="My Wallet",
        header=HEADER,
        navbar=NAVBAR
    )

# Balance Page
@server.route("/balance", methods=["GET"])
def balance():
    address = request.args.get("address")
    tokenId = request.args.get("tokenId")
    nowTime = datetime.datetime.now()
    addressBalance = ""
    errorMessage = ""

    if not address: address = ""
    if not tokenId: tokenId = ""

    if address and tokenId:
        success, addressBalance = getBalance(address, tokenId)
        if not success:
            errorMessage = addressBalance
            addressBalance = ""

    return render_template(
        template_name_or_list="balance.html",
        title="My Wallet - Balance",
        header=HEADER,
        navbar=NAVBAR,
        addressBalance=addressBalance,
        address=address,
        tokenId=tokenId,
        nowTime=nowTime,
        errorMessage=errorMessage
    )

# Transfer Page
@server.route("/transfer")
def transfer():
    fromAddress = request.args.get("fromAddress")
    secretKey = request.args.get("secretKey")
    toAddress = request.args.get("toAddress")
    tokenId = request.args.get("tokenId")
    amount = request.args.get("amount")
    nowTime = datetime.datetime.now()
    transactionHash = ""
    errorMessage = ""

    if not fromAddress: fromAddress = ""
    if not secretKey: secretKey = ""
    if not toAddress: toAddress = ""
    if not tokenId: tokenId = ""
    if not amount: amount = ""

    if fromAddress and secretKey and toAddress and tokenId and amount:
        success, transactionHash = snedTransaction(fromAddress, secretKey, toAddress, tokenId, amount)
        if not success:
            errorMessage = transactionHash
            transactionHash = ""

    return render_template(
        template_name_or_list="transfer.html",
        title="My Wallet - Transfer",
        header=HEADER,
        navbar=NAVBAR,
        fromAddress=fromAddress,
        toAddress=toAddress,
        tokenId=tokenId,
        amount=amount,
        nowTime=nowTime,
        transactionHash=transactionHash,
        errorMessage=errorMessage
    )

# Error 404 Page
@server.errorhandler(404)
def error_404(error):
    return render_template(
        template_name_or_list="404.html",
        title="My Wallet - 404 Not Found",
        header=HEADER,
        navbar=NAVBAR
    )

if __name__ == "__main__":
    server.run(host="0.0.0.0", port=10000)