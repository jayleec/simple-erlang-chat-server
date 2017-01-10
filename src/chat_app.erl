%%%-------------------------------------------------------------------
%%% @author jay
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jan 2017 8:14 AM
%%%-------------------------------------------------------------------
-module(chat_app).
-author("jay").

-behaviour(application).

%% Application callbacks
-export([start/2,
    stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @end
%%--------------------------------------------------------------------
-spec(start(StartType :: normal | {takeover, node()} | {failover, node()},
    StartArgs :: term()) ->
    {ok, pid()} |
    {ok, pid(), State :: term()} |
    {error, Reason :: term()}).
start(_StartType, _StartArgs) ->
    ok = application:start(crypto),
    ok = application:start(asn1),
    ok = application:start(public_key),
    ok = application:start(ssl),
    ok = application:start(cowlib),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(ebus),
    ok = application:start(jiffy),

    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", cowboy_static, {file, "priv/index.html"}},
            {"/websocket", chat_cowboy_ws_handler, []},
            {"/assets/[...]", cowboy_static, {dir, "priv/assets"}}
        ]}
    ]),

    {ok, _} = cowboy:start_clear(http, 100, [{port, 6060}],
            #{env => #{dispatch => Dispatch}}
        ),

    case chat_sup:start_link() of
        {ok, Pid} ->
            io:format("start ok!"),
            {ok, Pid};
        Error ->
            Error
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @end
%%--------------------------------------------------------------------
-spec(stop(State :: term()) -> term()).
stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
