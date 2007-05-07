Return-Path: <linux-kernel-owner+w=401wt.eu-S967019AbXEGVvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967019AbXEGVvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967014AbXEGVvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:51:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:58987 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966704AbXEGVvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:51:36 -0400
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 07 May 2007 23:51:33 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <1178571269.18383.296.camel@localhost>
Message-ID: <20070507215133.276290@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>
	<4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>
	<4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net>
	<463A0462.5070106@gmail.com>
	<d9def9db0705030859y66b1ef8fv22fc844c77bcc3c6@mail.gmail.com>
	<463A0B36.5080204@gmail.com>
	<d9def9db0705031019l5083d1c1h607b0829ab526f1@mail.gmail.com>
	<1178215045.12651.124.camel@localhost>  <463A31EE.20907@gmail.com>
	<1178388401.12541.115.camel@localhost>  <463CD106.3000706@gmail.com>
 <1178571269.18383.296.camel@localhost>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
	points about ...)
To: Mauro Carvalho Chehab <mchehab@infradead.org>, abraham.manu@gmail.com
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19fB1cMSAZfX2zoDCoLnI+IaUjPBn4/BwKnqH2E1a
 Bt86k3wnqmdiARGsxN8NRo7nhblyExCPvAwA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: CPJdEqpLbXB+TmH8TTQ2hqoiLyUmZQiT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Mon, 07 May 2007 17:54:29 -0300
Von: Mauro Carvalho Chehab <mchehab@infradead.org>
An: Manu Abraham <abraham.manu@gmail.com>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical	points about ...)

> Hi Manu,
> 
> > From my side, quite some time has been put forward to write that mail.
> > Inspite of that if you feel that you do have to go your own way, then
> > it is completely upto you. I would say: do as you feel in such a case.
> 
> The point is that those issues are pending for a long time, and they
> should be solved, especially the module removal issue (*)
> 
> If you are so afraid about applying those changes, maybe the better is
> to apply those patches at v4l-dvb tree and at -mm, asking people to
> test.
> 
> We may hold their commit on kernel mainstream until the next kernel
> release, if nobody complains about, or otherwise revert the changes, if
> they proofed to cause troubles at dst and/or dvb-bt8xx.
> 
> Also, you (or others) may write another approach keeping the fixes with
> an strategy more adequate for dst.
> 
> Do you agree with this way?
> 
> -- 
> Cheers,
> Mauro
> 
> (*) Currently, dst can be removed only with "rmmod -f", due to a wrong
> usage count. With Trent's patches, this were fixed.

Mauro,
First of all, Manu is not a machine shitting out solutions on other one's pressure.
And he is doing right so far, as far as what happened.

Second: You should do some self-reflection on the damage you did on the human layer.
You appear like not even having any intention or idea on how to do that, you just behave technocratic and cold, you are just doing "I-AM-THE-BOSS, AND-NOTHING-GOES-WITHOUT-ME"-politics, that's all. 

Even if you do not have at least partially any idea about it all, you just try to rule "godlike", you know. Not everybody agrees with that ruling style, just a hint for you that you do not ever want to see, because you prefer to be blind in order to rule, to move on to the daily dayplan, as if nothing happened. But there happened many things. But you just prefer to be blind.

Currently me and Manu are working on a long lasting project very harmonizing, which I never believed to be possible at all, but we do work together :-).

And as long as the the ruler behaviour and the ruling structure of linuxtv.org keeps on behaving like this (including all the nasty people like mrechberger for instance), then let me tell you that I care a shit about what is being pulled into the kernel and what is not, man!

Now if you cannot take that I feel sorry, but he whole system around here gotta be changed as far as maintainership is concerned.

You cannot go on like this, Mr. Chehab, and even if you keep on ignoring this message you will be producing nothing but damage in the end.

Noone was born to act and behave like a nodding nigger in front of you - and if you do not want to take that, well, then you're strictly obsolete, man!

Without any politeness

Uwe
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
