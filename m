Return-Path: <linux-kernel-owner+w=401wt.eu-S1946071AbXD3QJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946071AbXD3QJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946070AbXD3QJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:09:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:52520 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946066AbXD3QJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:09:40 -0400
Cc: mchehab@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 30 Apr 2007 18:09:38 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <4636058B.3070603@aitel.hist.no>
Message-ID: <20070430160938.51860@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>	
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>	
 <20070429205925.129920@gmx.net>	
 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>	
 <20070429230037.95120@gmx.net> <1177894713.3046.5.camel@pc06.localdom.local>
 <20070430110255.267000@gmx.net> <4635D139.4030609@aitel.hist.no>
 <20070430115000.194060@gmx.net> <4636058B.3070603@aitel.hist.no>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
	pseudo-authorities
To: Helge Hafting <helge.hafting@aitel.hist.no>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX185LW12CU05JZcIOQFQ3WqnbcI08cc+vYbHz7Rtfr
 +8TggZ2gIuyi76WP4y6qDCv2fRAF7u2woNeQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: p2VfKTAsMydhaVPbFWplM3xjaGRhZpp9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Mon, 30 Apr 2007 17:04:43 +0200
Von: Helge Hafting <helge.hafting@aitel.hist.no>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, mchehab@infradead.org
Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and	pseudo-authorities

> Uwe Bugla wrote:
> > -------- Original-Nachricht --------
> > Datum: Mon, 30 Apr 2007 13:21:29 +0200
> > Von: Helge Hafting <helge.hafting@aitel.hist.no>
> > An: Uwe Bugla <uwe.bugla@gmx.de>
> > CC: linux-kernel@vger.kernel.org
> > Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21
> and	pseudo-authorities
> >
> >   
> >> Uwe Bugla wrote:
> >>     
> >>> In this ten Emails you will yourself see the intellectual and
> technical
> >>>       
> >> proof in how far Mr. Chehab is acting with nothing else but:
> >>     
> >>> a. Lies
> >>> b. Unproven thesis
> >>> c. Stigmatizations
> >>>
> >>> and so on.
> >>>
> >>> THIS MAN HAS NO IDEA, BUT HE HAS THE POWER!
> >>>   
> >>>       
> >> Please note that there are ways to replace a bad maintainer. 
> >> We still try to keep it polite.
> >>
> >> But note that you can't have someone "fired", no matter how bad they
> >> do their job.  A bad maintainer is usually better than none - the bad
> >> maintainer might improve. Or at least get some simple stuff done.
> >>
> >> You therefore replace a bad maintainer by taking over the position. 
> >> Contact whoever is above the maintainer (Linus or some other
> >> higher-level maintainer). You explain the problem, and you must also
> >> show that you have the time and knowledge to do a better job. 
> >>     
> >
> > Hi Helge,
> > A. I do neither have enough skills to take up a maintainers role
> >   
> Then your only hope is to find someone else that is interested.
> > B. Linus and Andrew are high-leveled informed about the whole structural
> problem, but they close their eyes, they simply do not want to see the
> necessity of a replacement.
> > That is at least my impression. 
> >   
> The aren't doing any less than you do. They don't provide a better
> maintainer, but neither do you.   Linus and  Andrew don't have that
> much more resources than you have.  They have programming skills
> and lots of trust in the community.
> 
> >> You can, for example, maintain the same subsystem in parallel.  After a
> >> while,
> >> all interested parties sees that your tree works better and that
> >> communicating with you is easier.
> >> If you aren't prepared to do this - then you have to live with the
> current
> >> maintainer.  There is no staff ready to replace maintainers after
> >> complaints, a volunteer doing a better job is always necessary.
> >>     
> >
> > Neither nor: I do not livbe with persons like Chehab and others, no
> matter what the consequence is. To be truthful I would strategically prefare a
> vacuum at the price that the work isn't even done for months.
> > ONLY IF there is a personnel vacuum the necessity for others to
> volunteer will arise.
> >   
> A sufficiently bad maintainer will also do it.  If lots of submitters send
> their patches to andrew in order to get past a dysfunctional maintainer,
> then the subsystem effectively is unmaintained.
Hi,
False!
I in fact tried the mm-tree strategy, and it in fact worked - until Mauro Chehab started to soap in Andrew Morton's face with some utmost stigmatizing and stuipd rant to build up a "coalition of sit-out".
I know what I have to think about Mauro Carvalho Chehab, and I hate people like him.
And this stinking rotten "Apparatschnik" behaviour (I wouldn't even call this "conservative" as it isn't conservative at all, but simply stinking and rotten, if not to say reactionary) is driving me insane sometimes.....

> > So if you want a real change you gotta first kick the reactionary dumb
> bastards off from their seats without any return ticket - without that there
> won't be any changes at all!
> >   
> Well then - create a patch to the MAINTAINERS file that removes this 
> maintainer
> leaving the position open.  Perhaps you can get that accepted despite the
> existing maintainer - *if* you can get most other developers for that
> subsystem to add signed-off lines.  It will then be clear that the
> community agrees with you.

That sounds very naive, as many people do see the structural problems as they are, but do not build up solidarities leading to real structural changes.
Everyone tries to make the best out of it, and thus the whole thing resembles to a cancer growth scenery: metastase after metastase getting fatter and fatter, not smaller. With real structural problems never resolved, but always delegated or brushed under the carpet to make the own "Apparatschnik" life a lots of more easier.
> 
> However, if the bulk of them thinks the current maintainer is fine, then
> it stays that way.  Satisfying everybody is unfortunately not always 
> possible.
> You can always try submitting your own patches above this maintainer.
NO I CANNOT, if not to say: I tried so often, but in vain!
And some people see through the problems, but aren't ready to take up action.

The biggest problem is to build up majorities, it is almost impossible!

> > But the practice now is the typical "Sit out and do not react at all"
> behaviour as far as Chehab himself is concerned - Germans remember that
> reactionary gesture from the time when Hellmut Kohl was chancellor for 16
> horrible years.....
> >
> > So there will be no "soft" or "polite" solution at all, but only a harsh
> and rude one:
> > "Kick out the Jams!"
> Dropping lazy or incompetent maintainers do happen occationally.
> But don't let frustration lead to angry emails - all you get that way is 
> lost
> credibility, that will only make it harder to convince people.
I know that very much, but I ain't no machine or master in suppressing emotions.
And I have not lost hopes that there will be personal changes at linuxtv.org which are utmost necessary. That's why I keep on fighting....

Cheers
Uwe
> 
> Helge Hafting

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
