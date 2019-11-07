-module(vivo_push_example).
-compile(export_all).

-define(AppId, "go6VssZlTDDypm+hxYdaxycXtqM7M9NsTPbCjzyIyh0=").
-define(AppKey, "go6VssZlTDDypm+hxYdaxycXtqM7M9NsTPbCjzyIyh0=").
-define(AppSecret, "go6VssZlTDDypm+hxYdaxycXtqM7M9NsTPbCjzyIyh0=").
-define(REGID, "go6VssZlTDDypm+hxYdaxycXtqM7M9NsTPbCjzyIyh0=").
-define(TITLE, "Title标题").
-define(DESC, "DESC内容").

single_send_test()->
  vivo_push:single_send(?AppId, ?AppKey, ?AppSecret, ?REGID, ?TITLE, ?DESC).

batch_send_test()->
  vivo_push:batch_send(?AppId, ?AppKey, ?AppSecret, ?TITLE, ?DESC).
