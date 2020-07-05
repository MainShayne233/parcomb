-module(parcomb_bridge).

-export([parent_element_wrap/0]).

parent_element_wrap() ->
  parcomb:parent_element().
