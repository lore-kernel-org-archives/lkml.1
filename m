Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYCCMbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYCCMbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYCCMb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:31:29 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39675 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYCCMb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:31:28 -0500
Date: Mon, 3 Mar 2008 14:29:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303122953.GH4457@cs181133002.pp.htv.fi>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303120211.GG4457@cs181133002.pp.htv.fi> <20080303121015.GA12660@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080303121015.GA12660@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 01:10:15PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > > http://lkml.org/lkml/2007/4/9/363
> > > 
> > > this second one is this very thread that i replied to.
> > >...
> > 
> > That's a lie.
> 
> oops, i was simply wrong - it looked very much like this current thread 
> ...
> 
> (It would be a lie had i been writing that intentinally. Thanks for 
> giving me the benefit of the doubt.)

Thanks for assuming only the best intentions from me.

I can only repeat that I did state several times on linux-kernel that it 
never worked.

If you consider it my fault that noone reads my emails then you are 
right that it's my fault...

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

