const validators = [
    { id: 1, address: "0x...", status: "Active", weight: 50 },
    { id: 2, address: "0x...", status: "Active", weight: 50 }
];

function calculateDelegation(totalAmount) {
    return validators.map(v => ({
        address: v.address,
        amount: (totalAmount * v.weight) / 100
    }));
}

module.exports = { validators, calculateDelegation };
