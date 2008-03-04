Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYCDNsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYCDNsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYCDNsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:48:42 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60592 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYCDNsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:48:41 -0500
Date: Tue, 4 Mar 2008 15:47:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080304134701.GA20278@cs181133002.pp.htv.fi>
References: <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303120211.GG4457@cs181133002.pp.htv.fi> <20080303121015.GA12660@elte.hu> <20080303122953.GH4457@cs181133002.pp.htv.fi> <20080303125027.GA21577@elte.hu> <20080303145413.GA26072@cs181133002.pp.htv.fi> <20080304131600.GG29777@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080304131600.GG29777@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 02:16:00PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@stusta.de> wrote:
> 
> > > well, i'm trying to assume the best, so please explain the following 
> > > sequence of events to me:
> > > 
> > > 1) as you said you knew about this bug - which bug causes more inlining
> > >    overhead than hundreds of your uninlining patches combined. The bug
> > >    was introduced ~2 years ago in -mm - before the feature hit mainline
> > >    in v2.6.16.
> > 
> > I don't remember having ever said this.
> > 
> > Your choices are:
> > [ ] prove your accusation that I said I
> >     "knew about this bug before the feature hit mainline"
> > [ ] apologize
> > [ ] be the firest person ever in my killfile
> 
> Adrian, you must be misunderstanding something. Where exactly in the 
> above sentences do i assert that you "knew about this bug before the 
> feature hit mainline"? I dont say that and cannot say that -

Please explain your statement "before the feature hit mainline in 
v2.6.16" in the above sentence of you in a reasonable way other than 
that it should say I knew about it before the feature hit mainline.

> and it's 
> rather irrelevant.

Perhaps for you.

For me it's not irrelevant what I'm publically being accused of.

And it's not the first time in the thread that you use things that are 
objectively not true in accusations against me.

> All i say is that you knew about this bug for a long 
> time.
>...

I found the bug.

I repeatedly told about this bug on linux-kernel.

I explained to you who claimed just yesterday "my experience was that 
it had effects." why it couldn't have possibly worked (no matter why 
your experience was differently).

And now you start big flames against me why I hadn't stated more boldly 
that this patch never worked.
Not against Arjan who seems to have sent a patch that never worked.
Not against Harvey who independently spotted the same bug.
Not against the people who didn't care when I said on linux-kernel that 
it didn't work (one of the threads even had CONFIG_FORCED_INLINING in 
the subject).

Thanks a lot, Mr. Molnar.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

