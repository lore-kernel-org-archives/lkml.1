Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYG1PxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYG1PxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYG1PxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:53:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33298 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbYG1PxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:53:09 -0400
Date: Mon, 28 Jul 2008 18:52:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080728155227.GF30612@cs181140183.pp.htv.fi>
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com> <9e4733910807280820v118b728fu1c0a8b8eb4c4fdaa@mail.gmail.com> <20080728153546.GD30612@cs181140183.pp.htv.fi> <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:45:29AM -0400, Jon Smirl wrote:
> On 7/28/08, Adrian Bunk <bunk@kernel.org> wrote:
> > On Mon, Jul 28, 2008 at 11:20:49AM -0400, Jon Smirl wrote:
> >  > Some stats using the new mailmap file:
> >  >
> >  > Patches, number of developers
> >  > 1, 1591
> >  > 2, 484
> >  > 3, 254
> >  > 4, 152
> >  > 5, 118
> >  > more, 1242
> >  >
> >  > Top twenty developers:
> >  >
> >  > Linus Torvalds (4350):
> >
> >
> > You count merges as patches.
> 
> I just used the output from git shortlog, is there a better way?

I use "cg-log --summary", but there's most likely also some easy way 
without cogito.

> >  > Andrew Morton (1789):
> >  > Adrian Bunk (1774):
> >  > Al Viro (1735):
> >  > Ingo Molnar (1393):
> >  > Ralf Baechle (1367):
> >  > Jeff Garzik (1291):
> >  > Takashi Iwai (1196):
> >  > Tejun Heo (1092):
> >  > Bartlomiej Zolnierkiewicz (1071):
> >  > David S. Miller (1069):
> >  > Patrick McHardy (1031):
> >  > Stephen Hemminger (1017):
> >  > Russell King (985):
> >  > Andi Kleen (973):
> >  > Thomas Gleixner (953):
> >  > Alan Cox (822):
> >  > Paul Mundt (813):
> >  > Dave Miller (787):
> >
> >
> > Dave Miller = David S. Miller
> >
> >  In this case your .mailmap made the result worse...
> 
> Easily fixed, I just missed one of his aliases.

There were two:
Dave Miller <davem@davemloft.net>
David Miller <davem@t1000.davemloft.net>

>...
> Jon Smirl

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

