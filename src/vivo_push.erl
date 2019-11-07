-module(vivo_push).

%%API

-export([
        get_token/3,
        single_send/3,
        single_send/6,
        batch_send/5,
        batch_send/2,
        general_app_msg/6,
        general_notification/6
        ]).

-include_lib("eutil/include/eutil.hrl").

-define(SUCCESS, 0).
-define(NotifyType, 1).
-define(SkipType, 1).

general_notification(AppId, AppKey, AppSecret, RegId, Title, Content)->
  single_send(AppId, AppKey, AppSecret, RegId, Title, Content).

general_app_msg(AppId, AppKey, AppSecret, RegId, Title, Content)->
  single_send(AppId, AppKey, AppSecret, RegId, Title, Content).

get_conf_app_id() ->
  {ok, AppId} = application:get_env(vivo_push, app_id),
  AppId.

get_conf_app_key() ->
  {ok, AppKey} = application:get_env(vivo_push, app_key),
  AppKey.

get_conf_app_secret() ->
  {ok, AppSecret} = application:get_env(vivo_push, app_secret),
  AppSecret.

batch_send(Title, Desc) ->
  AppId = get_conf_app_id(),
  AppKey = get_conf_app_key(),
  AppSecret = get_conf_app_secret(),
  batch_send(AppId, AppKey, AppSecret, Title, Desc).

batch_send(AppId, AppKey, AppSecret, Title, Desc) ->
  case get_token(AppId, AppKey, AppSecret) of
    {ok, Token} ->
      MsgMap = #{<<"notifyType">> => ?NotifyType,
        <<"title">> => unicode:characters_to_binary(Title), <<"content">> => unicode:characters_to_binary(Desc),
        <<"skipType">> => ?SkipType, <<"requestId">> => erlang:system_time()},
      URL = <<"https://api-push.vivo.com.cn/message/all">>,
      send(Token, URL, MsgMap);
    Error ->
      Error
  end.

single_send(RegId, Title, Desc) ->
  AppId = get_conf_app_id(),
  AppKey = get_conf_app_key(),
  AppSecret = get_conf_app_secret(),
  single_send(AppId, AppKey, AppSecret, RegId, Title, Desc).

single_send(AppId, AppKey, AppSecret, RegId, Title, Desc) ->
  case get_token(AppId, AppKey, AppSecret) of
    {ok, Token} ->
      MsgMap = #{<<"regId">> => RegId,<<"notifyType">> => ?NotifyType,
        <<"title">> => unicode:characters_to_binary(Title), <<"content">> => unicode:characters_to_binary(Desc),
        <<"skipType">> => ?SkipType, <<"requestId">> => RegId},
      URL = <<"https://api-push.vivo.com.cn/message/send">>,
      send(Token, URL, MsgMap);
    Error ->
      Error
  end.

gen_headers(Token) ->
  [?JSON_HEAD, {<<"auth_token">>, Token}].

send(Token, URL, MsgMap) ->
  Headers = gen_headers(Token),
  send_for_headers(Headers, URL, MsgMap).

send_for_headers(Headers, URL, MsgMaps) ->
  case eutil:http_post(URL, Headers, MsgMaps, [{pool, vivo}]) of
  #{<<"result">> := ?SUCCESS} = Result ->
      {ok, Result};
    Other ->
      error_logger:error_msg("epush vivo error, URL: ~p, MsgMaps: ~p, Result: ~p", [URL, MsgMaps, Other]),
      {error, Other}
  end.

get_token(AppId, AppKey, AppSecret) ->
  Timestamp = erlang:system_time(second) * 1000,
  SignString = lists:concat([eutil:to_list(AppId), eutil:to_list(AppKey), Timestamp, eutil:to_list(AppSecret)]),
  Sign = string:to_lower(base64:encode_to_string(erlang:md5(SignString))),
  MsgMap = #{<<"appId">> => AppId, <<"appKey">> => AppKey, <<"sign">> => Sign, <<"timestamp">> => Timestamp},
  URL = <<"https://api-push.vivo.com.cn/message/auth">>,
  case eutil:http_post(URL, ?JSON_HEADS, MsgMap, [{pool, vivo}]) of
    #{<<"result">> := ?SUCCESS, <<"authToken">> := Token} ->
      {ok, Token};
    Other ->
      error_logger:error_msg("epush vivo get token error, URL: ~p, MsgMaps: ~p, Result: ~p", [URL, MsgMap, Other]),
      {error, Other}
  end.
