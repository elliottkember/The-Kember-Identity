public function runTests():void
{
    var isReversible:Boolean = false;
    var count:int = 0;
    while(!isReversible)
    {
        var test:String = random_gen(32);
        count++;
        if(count == 1000)
        {
            trace(test);
            count = 0;
        }
        
        var hash:String = encrypt(test);
        if(test == hash)
        {
            isReversible = true;
            trace("We found it! " + test + " is a reversible md5 hash. Profit!");
        } 
    }
}

private function random_gen(len:int):String
{
    var chars:String = "1234567890abcdef";
    var str:String = "";
    for(var i:int = 0; i < len; i++)
        str += chars.charAt(Math.floor(Math.random() * chars.length));
    
    return str;
}
