Return-Path: <linux-kernel-owner+w=401wt.eu-S1422626AbXEDAHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422626AbXEDAHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423471AbXEDAHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:07:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:45656 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422626AbXEDAH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:07:29 -0400
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org, mkrufky@linuxtv.org
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 04 May 2007 02:07:27 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <d9def9db0705031506i53b8b263ld7f32a8cfd47b047@mail.gmail.com>
Message-ID: <20070504000727.19380@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<20070503153129.268110@gmx.net> <463A0462.5070106@gmail.com>
	<d9def9db0705030859y66b1ef8fv22fc844c77bcc3c6@mail.gmail.com>
	<463A0B36.5080204@gmail.com>
	<d9def9db0705031019l5083d1c1h607b0829ab526f1@mail.gmail.com>
	<1178215045.12651.124.camel@localhost> <463A31EE.20907@gmail.com>
	<d9def9db0705031400q375f2a29t1c9354d717a763d4@mail.gmail.com>
	<463A572E.1000903@gmail.com>
 <d9def9db0705031506i53b8b263ld7f32a8cfd47b047@mail.gmail.com>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
	points about ...)
To: "Markus Rechberger" <mrechberger@gmail.com>, abraham.manu@gmail.com
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+rDqA8tWircn178qF9QweN+BR8r1SCDb+AQNW4C8
 4IvEh/zyLGdRGq6FycjNFX3EpflDXaF14NbA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: B0sJcvhOX1V6JzDjE2Fy3wl/SDc4NAyO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Fri, 4 May 2007 00:06:51 +0200
Von: "Markus Rechberger" <mrechberger@gmail.com>
An: "Manu Abraham" <abraham.manu@gmail.com>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical	points about ...)

> On 5/3/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > Markus Rechberger wrote:
> > > On 5/3/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > >> Mauro Carvalho Chehab wrote:
> > >> > Enough. Let's stop arguing non technical issues.
> > >> >
> > >> > If either one of you have any technical argue against the Trent's
> > >> > patches, please point where the fix is wrong. Otherwise, if you
> wish,
> > >> > you may send an acked-by agreeing with the fix.
> > >> >
> > >>
> > >> Why don't you stop this childish behaviour ?
> > >>
> > >> After explaining to you the reasons in the previous mail:
> > >> being the author and maintainer of dst/dst_ca and maintainer of
> > >> dvb-bt8xx, i NACK this change
> > >>
> > >> (1) You aren't DVB maintainer
> > >
> > > I've seen that too often already, now we could point to a mail someone
> > > sent to Uwe regarding maintainership.
> >
> >
> > FYI, I have never written to Uwe regarding any sort of maintainership.
> > You seem to be quite up with an overdose of drugs
> >
> 
> I mean the mail from Helge Hafting (thread  [linux-dvb] Critical
> points about kernel 2.6.21 and pseudo-authorities) at the very first
> beginning.
> 
> > From 2005/09/13 - 2007/05/03 (till date) there have been 15 mails from
> > my side to Uwe, none of which has a topic whatsoever you say. Only the
> > first mail was a private mail and that is CC'd to Johannes as well.
> >
> > Firstly you seem to play politics by getting Uwe to flame me, then when
> > it backfired, you are trying to play tricks with the rest of the
> > community as well, by spreading nonsense statements.
> >
> 
> I sent several comments to Uwe to stop flaming, Trent was in the CC
> sometimes I never wrote that he should flame on anyone.
> I can simply forward you all mails I sent to Uwe there's not one bad mail.
> 
> My point is moreover to get that issue sorted out by either accepting
> his "proposal" or stating out why not to add it (and there must be a
> reason behind it, and no mail which is 2 years old, or explaining what
> the device is, again it got explained what's required from you)
> 
> seems like your response is based on that misunderstood sentence,
> sorry for not beeing clear enough.
> 
> Markus

Hi Markus, fine chap,
Please cool down...

I guess I understood Manu's response:

a. He just changed his priorities to pick up an old project that seemed to have died, but did not die at all - this project is called cx878 project, and it is the most radical approach that I ever have seen - trying to make all BT8xx drivers independent from bttv, which is not horrible, but only consequent, necessary, and good and fine.
Please see my previous mails on that issue.

Just read the ML to get the appropriate link and please get yourself in it to help developping it. I swear it is the right path, although I am still missing the avoidance of dvb-pll.c. A closer look into that module will quite easily tell you
that there aren't any BT8xx based PCI cards needing that module except the ones needing the lgdt330x frontend driver, which is maintained by Mike Krufky. So for all other cards treated by the dvb-bt8xx backend this module is nothing but heavily obsolete and nonsense, if not to say: RAM-Wasting.

b. In so far, Manu's statements do not base on any mail that is 2 years old, but he simply changed his mind, after it was necessarily me personally to build up "the golden bridge" for him, Mike and others as well.

c. I am deeply thankful for your diplomatic behaviour involving Trent, as this brought up Manu to react in the end instead of crawling back into his snail house.

d. But please let us establish peace among each other now, because without peace we will not be able to continue the whole thing...

Hi Trent,
I want to thank you for all your efforts - as they at least work for my deep satisfaction, but they may not work for other people as well for simply technical reasons (example: treating dst and dst_ca as one simple case does no good at all, does it?), but our primadonna Manuel Abraham simply follows another far more radical path - to get the whole thing independent from bttv, which is the RIGHT path.

Your invested energies weren't wasted at all, but they only approach "plan a" while "plan b" goes much more further than "plan a." It is as simple as that.

And, as I stated already, I am open for both plans - and if the more radical one gains more mercy I will not disagree, but simply follow it and trying my best to improve it.

Hi Mauro,

I would deeply appreciate you to pull my "proposal" for the Kconfig in the frontends section as at least the semantic problem gotta be resolved (SPO instead of SO - whoever wrote this). The question what card needs dvb-pll.c does not stay open so far - I just involved some fact about what card does really need it and what card simply never did.

However, also in "plan a" as in "plan b" the dvb-pll.c dependency issue stays open and I would deeply appreciate Mike Krufky to prepare a fix for us all.
It cannot be sufficient at all to be forced to compile a dvb-pll.c module for the whole group of bt8xx PCI cards if there is only one card that needs it being maintained by Mike, can it?

Again I state: The only bt8xx PCI based card that needs it is the one using the lgdt330x frontend driver - for all other cards of the BT8xx PCI kind that module is simply completely obsolete, if not to say: RAM-wasting nonsense.

And please stop to kill my deeply correct criticism with words like: "99 % of all cards need this module" or something like that, like you did in the past.
And please stop to kill my invested energies with sentences like "Again I say, please do not pull Uwe's patches at all, as he is only regarding things through his personal prisma."
Above from the fact that this is not really true it simply hurts and brings down all my invested energies for no acceptable reason.
In so far, you are NOT a neutral maintainer, like Markus stated, but you simply act playing unreasonable politics on me without knowing what you do.

Just be a little bit more open for the exception handling, even if you do not like to be. What I say is FACT, so please do not simply ignore the facts.

And after all I deeply respect that you are trying to be utmost restrictive as far as kernel oopses and regressions are concerned - I guess you're really doing fine as a team leader, although you are NOT neutral at least sometimes.

Hi Manuel,

I would deeply wish you to avoid the following words:
a. rant
b. childish behaviour
c. You aren't DVB maintainer
d. You seem to be quite up with an overdose of drugs

and other words like that.

Just to give you a very humble help:
Although Johannes stated that you were nothing but nerving when you were beginning this whole thing he himself tried to be always warm and encouraging to you.
So where is the reason in you personally that you cannot give back that positive behaviour please?

BTW:
I am really working hard on that cx878 project after the mercurial tree has been proven to work fine, and I hope that I can bring out some test report in order to make its development continue...

Yours sincerely

Uwe

> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
