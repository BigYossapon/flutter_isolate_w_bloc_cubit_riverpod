function runHeavyTaskIWithtIsolateworkers(args) {
    let value = 0;
    //args[0] = 4000000000;
    for (var i = 0; i < args[0]; i++) {
        value += i;
    }
    //print('==============================');
    return value;
}


