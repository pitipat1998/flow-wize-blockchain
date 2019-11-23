import "./IERC20.sol";
import "./IDGToken.sol";

contract DGToken is IERC20, IDGToken {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    address public minter;
    uint256 fee = 20000;

    modifier isOwner() {
        require(msg.sender == minter);
        _;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function myBalance() external view returns (uint256) {
        return _balances[msg.sender];
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
    
    function payFee() public returns (bool) {
        _transfer(msg.sender, minter, fee);
        return true;
    }

    function _returnFee(address recipient) internal returns (bool) {
        _transfer(minter, recipient, fee);
        return true;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount <= _balances[sender],"ERC20: transfer amount exceeds balance");

        _balances[sender] = _balances[sender]-amount;
        _balances[recipient] = _balances[recipient]+amount;
        emit Transfer(sender, recipient, amount);
    }
    
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        require(amount <= _allowances[sender][msg.sender],"ERC20: transfer amount exceeds allowance");
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender]-amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender]+addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        require(subtractedValue <= _allowances[msg.sender][spender],"ERC20: decreased allowance below zero");
        _approve(msg.sender, spender, _allowances[msg.sender][spender]-subtractedValue);
        return true;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply = _totalSupply+amount;
        _balances[account] = _balances[account]+amount;
        emit Transfer(address(0), account, amount);
    }

    constructor () public {
      minter = msg.sender;
      _mint(msg.sender, 1000000000000);
    }
}

