# 援力满满 - 二次元虚拟人物交易交易所

## 简介

https://www.yuanlimm.com/#/about

## 描述

本项目是二次元虚拟人物交易交易所的开源代码，供Rails爱好者学习，和玩家审查所用。

## 基础架构

Rails 5.2 + Mysql5.7 + Redis4.0

## 阿里云开放搜索

本站使用了阿里云开放搜索的服务，由于阿里云开放搜索没有Ruby的SDK，所以自己简单的实现了一下。

参考文档: https://help.aliyun.com/document_detail/29140.html?spm=a2c4g.11186623.6.601.T4fkKI

基础类，用于验证: https://github.com/bydmm/yuanlimm/blob/master/app/models/open_search.rb

推送数据:  https://github.com/bydmm/yuanlimm/blob/master/app/models/open_search_push.rb

搜索API:  https://github.com/bydmm/yuanlimm/blob/master/app/models/open_search_search.rb

## 极限验证

本站的验证码服务都使用的是极限验证提供的滑块验证码，由于极限验证没有Ruby SDK，所以仿造python版本的实现了一个

极限验证： http://www.geetest.com/

实现地址： https://github.com/bydmm/yuanlimm/blob/master/app/models/geetest_lib.rb

# 高速许愿工具

https://github.com/bydmm/yuanlimm-cli

本项目的一个特色是使用算力去竞争增发的股票和游戏代币。

高速许愿工具是用Go编写的计算工具。

# 高速验证服务代码

https://github.com/bydmm/yuanlimm-server

高速许愿工具需要高性能的验证和状态服务，所以使用Go完成了这一部分的API。
