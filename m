Return-Path: <linux-kernel-owner+w=401wt.eu-S1031643AbXEAJb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031643AbXEAJb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031644AbXEAJb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:31:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:36385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031645AbXEAJby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:31:54 -0400
Cc: linux-dvb@linuxtv.org, akpm@linux-foundation.org,
       helge.hafting@aitel.hist.no, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       abraham.manu@gmail.com
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 01 May 2007 11:31:52 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <d9def9db0705010200n4e09f4aega7e54bca06a029e3@mail.gmail.com>
Message-ID: <20070501093152.117520@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<4636E0E2.5020601@simon.arlott.org.uk>
 <d9def9db0705010200n4e09f4aega7e54bca06a029e3@mail.gmail.com>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
	points about ...)
To: "Markus Rechberger" <mrechberger@gmail.com>, simon@fire.lp0.eu
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX193t/tlh2p3H93q1GN1H6Xr4VPgkBdnyrSGi+G5ls
 4id5ajPe+vFDSA3PPDRwxGZ/hRk83ev1wguA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: PDsOft4YYW0tWGD9HmZpPL98amthc9sT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Tue, 1 May 2007 11:00:44 +0200
Von: "Markus Rechberger" <mrechberger@gmail.com>
An: "Simon Arlott" <simon@fire.lp0.eu>
CC: Manu Abraham <abraham.manu@gmail.com>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@linux01.gwdg.de>, helge.hafting@aitel.hist.no, akpm@linux-foundation.org, linux-dvb@linuxtv.org
Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical	points about ...)

> On 5/1/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> > On 30/04/07 22:17, Markus Rechberger wrote:
> > > Trent Piepho wrote another patch for it, it just completes Uwe's patch
> > > in the end.
> > > From my side I do not see any problem with that patch, if someone else
> > > has a problem with it please state out the reason.
> >
> > I have no problem with the patch since it has nothing to do with my DVB
> > card but you're only encouraging Uwe to be abusive since it seems to
> > help get him what he wants:
> >
> > On 01/05/07 00:05, Uwe Bugla wrote:
> > > Piepho, you are a devil, and your links do not work at all!
> > > Uwe
> >
> > On 01/05/07 00:40, Uwe Bugla wrote:
> > > Go to hell, Manuel Abraham, and do not return at all to absolutely no
> > thinkable condition at all, and never come back to this place once more
> > again
> > > Just goto hell, you goddamn deeply asocial miserable sonofabitch!!
> > >
> > > Uwe
> >
> > > On 4/30/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > >> it's enough, I told him that I'll look at it and try to get some
> other
> > >> people involved if it really breaks something it should get stated
> > >> out; and I'll refuse any further help if he starts to write any more
> > >> abusive mail.
> >
> > It's not working. Patches should still be applied on the basis of what
> > they do and how, not why they were made, of course.
> 
> this patch was written by Trent, and it seems like he already had that
> idea earlier too.
> 
> I really don't care if that patch goes in or not in the end, there's
> just no need to flame around for it.
> 
> The only reason I see is that it's not needed to link it statically
> against the bt878 module and there isn't even much work to do.
> Uwe's Makefile patch worked as expected, but it wasn't clean/complete
> enough that was a reason to not include it.
> Now with Trent's patch I don't see that as a valid argument against it
> anymore.
> And the email from Manu claiming that it generates alot work (which is
> btw. 2 years old) doesn't seem to be valid either.
> 
> Markus

Thank you, Markus - you are a real fine and straight chap.
You should be team leader of this community.
BTW:
Are my latest attempts sent to you already involved in the latest development state
(Read: Is dvb-pll.c deselectable now without breaking support for lgdt330)?
I simply stumbled over that lgdt330 binding in module dvb-bt8xx.c, line 641 or so.
Anything else I resolved at least from my personal side.

A thousands of thanks to you and Trent - well done!
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
