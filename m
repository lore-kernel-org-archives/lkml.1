Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbYEARNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbYEARNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763477AbYEARMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:12:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42041 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762796AbYEARMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:12:47 -0400
Date: Thu, 1 May 2008 20:12:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: devzero@web.de, linux-kernel@vger.kernel.org
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080501171200.GH29330@cs181133002.pp.htv.fi>
References: <261643149@web.de> <4819EF53.6090808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4819EF53.6090808@intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 09:26:59AM -0700, Kok, Auke wrote:
> devzero@web.de wrote:
> >> I'll try to do this:
> >> - create some Wiki page
> >> - get a mailing list at vger
> >> - point newbies to this mailing list
> >> - tell people there which kernels to test
> >> - figure out and document stuff like how to bisect between -next kernels
> >> - help them to do whatever is required for a proper bug report
> > 
> > good idea :)
> > 
> > one more:
> > reported bugs sometimes get lost in lkml (or elsewhere) and may not get the attention they need.
> > 
> > maybe there are not enough people who put some steadiness into tracking bugs (i.e. put them in bugzilla and make sure they get tracked/resolved) ?
> 
> I would say that this should be one of the main goals - have a team of people who
> can consistently be assigned bugs for duplication and verification. Getting newly
> opened bugs reproduced can be half the solution (and a great way to learn the
> kernel on the side).
>...

That is already working in the kernel Bugzilla for years
(with Andrew currently doing most of the work).

You might be in the lucky and unusual position that you have the 
hardware for reproducing most bugs in the drivers you maintain,
but that's nothing that's generally true.

Bugs in e1000 have a good chance of being resolved, if you want a really
bad example think of e.g. a bug in some unmaintained ISA network driver

We already have 1350 open bugs in the kernel Bugzilla, and the real 
problem is not how to track them but to find someone who resolves them.

> Auke

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

