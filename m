Return-Path: <linux-kernel-owner+w=401wt.eu-S934522AbYD1OAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522AbYD1OAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbYD1OAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:00:30 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43314 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765642AbYD1OAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:00:30 -0400
Date: Mon, 28 Apr 2008 16:59:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: x86: fix a couple of sparse warnings
Message-ID: <20080428135957.GK16379@cs181133002.pp.htv.fi>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com> <20080428123809.GD27997@elte.hu> <20080428133756.GJ16379@cs181133002.pp.htv.fi> <90edad820804280643p43509911gd7b497131c3f5004@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <90edad820804280643p43509911gd7b497131c3f5004@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 05:43:25PM +0400, Dmitri Vorobiev wrote:
> 2008/4/28 Adrian Bunk <bunk@kernel.org>:
> >
> > On Mon, Apr 28, 2008 at 02:38:09PM +0200, Ingo Molnar wrote:
> >  >
> >  > * Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> >  >
> >  > > Hi Ingo, Peter, Thomas,
> >  > >
> >  > > Here is a couple of patches that fix sparse warnings produced while
> >  > > compiling defconfig for i386:
> >  >
> >  > thanks Dmitri, applied.
> >
> >  /me wonders what was wrong with http://lkml.org/lkml/2008/4/23/131
> >     that contains a superset of the first patch
> >     (and got no response at all)
> 
> Adrian, I am sorry for duplicating your work. The clash wasn't intentional: I
> did not notice your earlier patch in the high traffic of this mailing list.

No problem, and I'm actually more interested why my patch got lost.

> Thanks,
> Dimitri

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

