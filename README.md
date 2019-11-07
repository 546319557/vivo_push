# vivo_push

## 只做下面两个接口
## --------------
## 2.单播
## 2.1单推接口（https://api-push.vivo.com.cn/message/send)
## 接口说明
## 接入方携带消息内容以及用户regId（或alias）进行通知消息推送。针对每个用户发送不同的通知。
## 使用场景：如物流、订单状态、游戏预约状态、行程状态、聊天（如微信、评论）等。-push.vivo.com.cn/message/send)
## 详情 /src/vivo_push_example.erl
## --------------
## 3.3全量发送接口（https://api-push.vivo.com.cn/message/send)
## 接口说明
## 向所有设备推送某条消息。
## 使用场景：活动、系统升级提醒等。
## 详情 /src/vivo_push_example.erl

