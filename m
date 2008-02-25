Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYBYOKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYBYOKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYBYOKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:10:00 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49928 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYBYOJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:09:59 -0500
Date: Mon, 25 Feb 2008 16:09:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225140901.GA8556@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225113235.GC32450@cs181133002.pp.htv.fi> <20080225115022.GA16376@elte.hu> <20080225122526.GE32450@cs181133002.pp.htv.fi> <20080225125707.GA27202@elte.hu> <20080225131202.GF32450@cs181133002.pp.htv.fi> <20080225134549.GA4481@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225134549.GA4481@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 02:45:49PM +0100, Ingo Molnar wrote:
>...
> > > I've seen architectures that were build-tested for the _first time_ 
> > > at around 2.6.24-rc8...
> > 
> > That can't be true.
> > 
> > Can you name what architectures you think of and why you think noone 
> > tried to compile them before?
> 
> sorry, s/build-tested/boot-tested.

That's quite a difference.

> there's been only 6 commits to arch/v850 between v2.6.23 and v2.6.24.
> None of them seems to suggest that anyone ever tested v850 in the last
> year or so.

Even longer, see
  http://lkml.org/lkml/2008/2/13/539

It's the only port we have that is completely unmaintained and broken 
for ages.

But the fact that the v850 port does not even compile is known for a 
long time, and nothing about this fact changed around 2.6.24-rc8.

> 	Ingo
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

