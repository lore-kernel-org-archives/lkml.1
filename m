Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYCCPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYCCPCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYCCPCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:02:37 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40452 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYCCPCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:02:36 -0500
Date: Mon, 3 Mar 2008 17:01:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303150101.GB26072@cs181133002.pp.htv.fi>
References: <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303120211.GG4457@cs181133002.pp.htv.fi> <20080303121015.GA12660@elte.hu> <20080303122953.GH4457@cs181133002.pp.htv.fi> <20080303125027.GA21577@elte.hu> <20080303145413.GA26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080303145413.GA26072@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 04:54:13PM +0200, Adrian Bunk wrote:
> On Mon, Mar 03, 2008 at 01:50:27PM +0100, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > I can only repeat that I did state several times on linux-kernel that 
> > > it never worked.
> > > 
> > > If you consider it my fault that noone reads my emails then you are 
> > > right that it's my fault...
> > 
> > well, i'm trying to assume the best, so please explain the following 
> > sequence of events to me:
> > 
> > 1) as you said you knew about this bug - which bug causes more inlining
> >    overhead than hundreds of your uninlining patches combined. The bug
> >    was introduced ~2 years ago in -mm - before the feature hit mainline
> >    in v2.6.16.
> 
> I don't remember having ever said this.
> 
> Your choices are:
> [ ] prove your accusation that I said I
>     "knew about this bug before the feature hit mainline"
> [ ] apologize
> [ ] be the firest person ever in my killfile
>...

s/firest/first/

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

