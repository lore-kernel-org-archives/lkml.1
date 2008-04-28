Return-Path: <linux-kernel-owner+w=401wt.eu-S935152AbYD1S46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbYD1S46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933717AbYD1S4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:56:43 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46842 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbYD1S4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:56:42 -0400
Date: Mon, 28 Apr 2008 21:56:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: x86: fix a couple of sparse warnings
Message-ID: <20080428185608.GZ2813@cs181133002.pp.htv.fi>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com> <20080428123809.GD27997@elte.hu> <20080428133756.GJ16379@cs181133002.pp.htv.fi> <90edad820804280643p43509911gd7b497131c3f5004@mail.gmail.com> <20080428135957.GK16379@cs181133002.pp.htv.fi> <20080428150156.GA7412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428150156.GA7412@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 05:01:56PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, Apr 28, 2008 at 05:43:25PM +0400, Dmitri Vorobiev wrote:
> > > 2008/4/28 Adrian Bunk <bunk@kernel.org>:
> > > >
> > > >  /me wonders what was wrong with http://lkml.org/lkml/2008/4/23/131
> > > >     that contains a superset of the first patch
> > > >     (and got no response at all)
> > > 
> > > Adrian, I am sorry for duplicating your work. The clash wasn't 
> > > intentional: I did not notice your earlier patch in the high traffic 
> > > of this mailing list.
> > 
> > No problem, and I'm actually more interested why my patch got lost.
> 
> It's simple: in this case i had two patches in my backlog, one from a 
> new person and one from a frequent contributor - doing the very same 
> change. I preferred the newbie's patch, to encourage Dmitri to keep 
> contributing to Linux and to help him learn from the experience of 
> working with various Linux maintainers.
>...

Every maintainer except you will teach the newbie where to find the 
current tree to avoid duplicating work...

But OK, instead of spending my time duplicating later patches I'll put 
possible cleanups and bugs for x86 on a list and check 1 or 2 months 
later whether they are still present.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

