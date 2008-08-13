Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYHMNg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYHMNg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYHMNgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:36:49 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35349 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYHMNgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:36:48 -0400
Date: Wed, 13 Aug 2008 16:34:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Pavel Machek <pavel@suse.cz>, Tim Tassonis <timtas@cubic.ch>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: reiser4 for 2.6.27-rc1
Message-ID: <20080813133457.GC26351@cs181140183.pp.htv.fi>
References: <4896F56D.7080503@cubic.ch> <20080813125807.GC6995@ucw.cz> <20080813131839.GB26351@cs181140183.pp.htv.fi> <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 09:24:58AM -0400, Michael Krufky wrote:
> On Wed, Aug 13, 2008 at 9:18 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Wed, Aug 13, 2008 at 02:58:08PM +0200, Pavel Machek wrote:
> >> On Mon 2008-08-04 14:26:21, Tim Tassonis wrote:
> >> > >Why is reiser4 still not in a vanilla kernel for
> >> > >testing. I have had
> >> > >to apply the reiser4 patches from -mm kernels to
> >> > >vanilla based
> >> > >patchset for over a year now. Reiser4 works fine, what
> >> > >will it take to
> >> > >get it included in vanilla? Here is a patch to add
> >> > >reiser4 to
> >> > >2.6.27-rc1:
> >> > >
> >> > >http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch
> >> > >
> >> > >-Ryan
> >> >
> >> > A good thing for a start would be to rename the whole
> >> > thing to something else, for obvious reasons.
> >>
> >> Whats wrong with reiser4 name?
> >>
> >>                                                       Pavel
> >>                       (or am I feeding a troll?)
> >
> > Not wanting a new filesystem named after a convicted murderer is not
> > a trollish suggestion.
> 
> Regardless of the murder conviction, I still believe that the guy
> should get credit for his work.

Other filesystems are usually not named after people, e.g. ext2 is not 
named cardfs2 and jffs2 is not named woodhousefs.

> Reiserfs is a name that we all know of, regardless of how current we
> are with the news (although you'd have to be PRETTY far behind if you
> don't know about the crime)
> 
> The current reiserfs filesystems aren't being renamed -- are they??
> 
> Does it really hurt to keep his name there?  I think it should just go as-is.

You can agree or disagree with Tim, but it's not a trollish suggestion.

> -Mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

