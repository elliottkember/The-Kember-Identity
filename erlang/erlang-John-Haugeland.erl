
-module(kember_identity).

-author("John Haugeland <stonecypher@gmail.com>").
-webpage("http://scutil.com/").
-author_blog("http://fullof.bs/").
-twitter("ScUtil").
-twitter("JohnHaugeland").
-license( {mit_license, "http://scutil.com/license.html"} ).

-publicsvn("svn://crunchyd.com/scutil/").
-bugtracker("http://crunchyd.com/forum/project.php?projectid=7").
-publicforum("http://crunchyd.com/forum/scutil-discussion/").
-currentsource("http://crunchyd.com/release/scutil.zip").

-svn_id("$Id: kember_identity.erl 370 2009-05-06 22:30:03Z john $").
-svn_head("$HeadURL: svn://crunchyd.com/scutil/erl/src/misc/kember_identity.erl $").
-svn_revision("$Revision: 370 $").

-description("Search mechanism for the Kember Identity; see http://www.elliottkember.com/kember_identity.html").

-testerl_export( no_testsuite ).

-library_requirements([]).





-export([
    test_kember_identity/1,
    search_indefinately/0,
    start/0,
    gen_rand_input/0
]).





% Each KI process will take roughly 1/N of your CPU, where N is your core count.
% Want to max out a quad core?  Start four times.





test_kember_identity(Term) ->

    case crypto:md5(Term) == Term of
        true  -> { found_identity, Term };
        false -> false
    end.





search_n(0) ->

    false;





search_n(N) ->

    case test_kember_identity(gen_rand_input()) of

        false ->
            search_n(N-1);

        { found_identity, I } ->
            { found_identity, I }

    end.





gen_rand_input() ->

    [ random:uniform(256) - 1 || _Character <- lists:seq(1,16) ].





search_indefinately() ->

    receive

        terminate ->
            ok

    after 0 ->

        case search_n(1000) of

            false ->
                search_indefinately();

            { found_identity, I } ->
                { found_identity, I }

        end

    end.





start() ->

    crypto:start(),

    {A,B,C} = now(),
    random:seed(A,B,C),

    { ok, spawn(?MODULE, search_indefinately, []) }.

