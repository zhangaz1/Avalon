﻿#!/usr/bin/env perl
use Mojo::Webqq;

my ($host, $port, $post_api);
$host = "0.0.0.0"; #发送消息接口监听地址，没有特殊需要请不要修改
$port = 5000;      #发送消息接口监听端口，修改为自己希望监听的端口
$post_api = 'http://127.0.0.1:5050/post_api';  #接收到的消息上报接口，如果不需要接收消息上报，可以删除或注释此行

my $client = Mojo::Webqq->new();

$client->load("ShowQRcode");

$client->load("Openqq",data=>{
    listen => [
        {   host => $host,
            port => $port,
        },
		post_api => $post_api,
		post_event => 0,                             #可选，是否上报事件，为了向后兼容性，默认值为1
		# post_event_list => ['login','stop','state_change','input_qrcode'],
    ]
});

#利用controller允许指定的IP可以访问，更多关于controller的资料，可以参考 Mojolicious::Controller
sub{
    my ($param,$controller) = @_;
    if($controller->tx->remote_address eq "127.0.0.1"){
        return 1;
    }
    return 0;
};

$client->run();