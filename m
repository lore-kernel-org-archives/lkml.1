Return-Path: <linux-kernel-owner+w=401wt.eu-S1750991AbXCECHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991AbXCECHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXCECHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:07:01 -0500
Received: from raven.upol.cz ([158.194.120.4]:47646 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbXCECHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:07:00 -0500
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Discussing LKML community [OT from the Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3]
In-Reply-To: <f2b55d220702280901r421cc185mf669c3c7bf779531@mail.gmail.com>
References: <45DCD9E5.2010106@redhat.com> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <f2b55d220702271903o6bc418efu7d72a564a7ade365@mail.gmail.com> <20070228080226.GA9639@2ka.mipt.ru> <f2b55d220702280901r421cc185mf669c3c7bf779531@mail.gmail.com>
Date: Mon, 5 Mar 2007 03:16:50 +0100
Message-Id: <E1HO2ks-00082C-7y@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Michael K. Edwards" <medwards.linux@gmail.com>
> Newsgroups: gmane.linux.kernel
> Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
> Date: Wed, 28 Feb 2007 09:01:07 -0800

Michael,

[]
> In this instance, there didn't seem to be any harm in sending my
> thoughts to LKML as I wrote them, on the off chance that Ingo or
> Davide would get some value out of them in this design cycle (which
> any code I eventually get around to producing will miss).  So far,
> I've gotten some rather dismissive pushback from Ingo and Alan (who
> seem to have no interest outside x86 and less understanding than I
> would have thought of what real userspace code looks like), a "why
> preach to people who know more than you do" from Davide,

this may be sad, unless you've spent time and effort to make a Patch,
i.e. read source, understand why it's written so, why it's being used now
that way, and why it has to be updated on new cycle of kernel
development.

> a brief aside on the dominance of x86 from Oleg,

I didn't have a chance, and probably i will not have one, to communicate
with people like you to learn from your wisdom personally. That's why
i've replied to your, after you've mentioned transputers. And i've got
rather different opinion, than i expected. That shows my test-tube
being, little experience etc. As discussion was about CPUs, it was
technical, thus on-topic for LKML.

> and one off-list "keep up the good work".  Not a very rich harvest from
> (IMHO) pretty good seeds.

Offlist message was my share of view about things, that were offtopic,
and clarifying about lkml thing, and it wasn't on-topic for LKML.

I'm pretty sure, that there libraries of books, written on every single
bit of things Linux currently *implements* in asm/C.

(1) Thus, `return -ENOPATCH', man, regardless what you are saying in
lkml. That's why prominent people, you've joined me with (:, replied in
go-to-kernelnewbie style.

> In short, so far the "Linux kernel community" is upholding its
> reputation for insularity, arrogance, coding without prior design,
> lack of interest in userspace problems, and inability to learn from
> the mistakes of others.  (None of these characterizations depends on
> there being any real insight in anything I have written.)

You, as a person, who have right to be personally wrong, may think that
way. But do not forget, as i've wrote you offlist and in (1), this is
development community, sometimes development of development one, etc;
educated, enthusiastic, wise, Open Source, poor on time (and money :).

> Happy hacking,
> - Michael

And you too. LKML *can* (sometimes may) show how useful this hacking is.

> P. S.  I do think "threadlets" are brilliant, though, and reading
> Ingo's patches gave me a much better idea of what would be involved in
> prototyping Asynchronously Executed I/O Unit opcodes.

You are discussing on-topic thing in the P.S. And this is IMHO wrong
approach.

Also, note, that i've changed subject, stripped cc list, please note,
that i can be young and naive boy barking up the wrong tree.

Kind regards.
--
-o--=O`C  /. .\
 #oo'L O      o
<___=E M    ^-- (Wuuf)
