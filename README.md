# nodePush

nodePush is an open source push library for [WoltLab Community Framework](http://github.com/WoltLab/WCF). It provides an easy to use API for both, PHP and JavaScript and is based on node.js and socket.io.

## How to use

### On the server
```php
<?php
$pushHandler = \wcf\system\nodePush\NodePushHandler::getInstance();

if ($pushHandler->isRunning()) {
	$pushHandler->sendMessage('hello');
}
?>
```

### On the client
```javascript
be.bastelstu.wcf.nodePush.onMessage('hello', function() {
	alert('World!');
});
```

License
-------

For licensing information refer to the LICENSE file in this folder.