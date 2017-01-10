%%%-------------------------------------------------------------------
%%% @author jay
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jan 2017 9:34 AM
%%%-------------------------------------------------------------------
-module(chat_ebus_handler).
-author("jay").

%% API
-export([handle_msg/2]).

handle_msg(Msg, Context) ->
    io:format("handle_msg started!~n"),
    Context ! {message_publised, Msg}.
