Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYEAMA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYEAMA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYEAMAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:00:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:32863 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbYEAMAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:00:11 -0400
Date: Thu, 1 May 2008 14:59:23 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080501115923.GX29330@cs181133002.pp.htv.fi>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080501025234.GE27574@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 04:52:34AM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > I would really appreciate it if you could send the error message and 
> > the .config but not quick kconfig patches that are often wrong and 
> > that you try to push through the maintainers as you tried here.
> 
> hey, sorry about invading your turf of trivial patches ;) I dont see it 
> as a problem that the thought process and the initial patch is 
> incomplete and ad-hoc. My preference is to work with people out in the 
> open, even on trivial issues. Dmitry is a capable maintainer who 
> understands his code very well and he'll resist me if i'm full of it. 
> Just like i resisted you when you were full of it. That's what 
> maintainers do, their job is to know their code.
> 
> And, occasionally, as in this case, i might end up being faced with a 
> bug in the code i maintain ;)

You completely miss my point.

You wrongly (and loudly) blamed Dmitry for something you broke yourself.

And if I hadn't stopped you pointing to what actually was broken you 
might have annoyed Dmitry until he'd have merged your wrong patch.

I don't claim any knowledge about scheduler or x86 internals, but I 
claim that I might be the person with the second-best understanding
of our kconfig files.

And I'd really prefer being able to take some time searching for a 
correct solution over having to quickly defeat the mess you create
as I had here.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

