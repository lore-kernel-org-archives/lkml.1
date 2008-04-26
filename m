Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbYDZTmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbYDZTmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762200AbYDZTml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:42:41 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41468 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762197AbYDZTmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:42:40 -0400
Date: Sat, 26 Apr 2008 22:42:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080426194215.GS2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <1209237655.14173.29.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1209237655.14173.29.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 12:20:55PM -0700, Harvey Harrison wrote:
> On Sat, 2008-04-26 at 14:00 +0300, Adrian Bunk wrote:
> > > [BUILDFIX PATCH] au0828: debug is a poor global identifier
> > 
> > Another issue for which I already sent a (slightly different) patch.
> > 
> > Why not check the mailing list before duplicating work? [1]
> 
> I do generally try to check the mailing list to avoid this...but LKML
> tends to be pretty busy.  I also try to check the latest -git devel
> tree for the affected area in case it's waiting to be pulled.  In this
> case it was so trivial I sent it directly to Linus.
> 
> In fact, I concentrate on looking at the sparse output because you
> do such a good job of catching unnecessary exports/globals.
>...

Sorry that my mail was unfriendly, but unfriendly flames are 
unfortunately sometimes the only choice for getting any response
on linux-kernel (and now I've gotten the responses my friendly
mail to Linus did not yield).

> Cheers,
> 
> Harvey

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

