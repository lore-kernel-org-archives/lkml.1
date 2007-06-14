Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbXFNAoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbXFNAoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 20:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXFNAoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 20:44:09 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34443 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756511AbXFNAoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 20:44:08 -0400
Date: Thu, 14 Jun 2007 02:44:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614004419.GL3588@stusta.de>
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706131456230.14121@woody.linux-foundation.org> <orejkfla3l.fsf@oliva.athome.lsd.ic.unicamp.br> <200706131946.15714.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706131946.15714.dhazelton@enter.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 07:46:15PM -0400, Daniel Hazelton wrote:
> On Wednesday 13 June 2007 19:15:42 Alexandre Oliva wrote:
> > On Jun 13, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > On Wed, 13 Jun 2007, Alan Cox wrote:
> > >> > find offensive, so I don't choose to use it. It's offensive because
> > >> > Tivo never did anything wrong, and the FSF even acknowledged that. The
> > >> > fact
> > >>
> > >> Not all of us agree with this for the benefit of future legal
> > >> interpretation.
> > >
> > > Well, even the FSF lawyers did,
> >
> > Or rather they didn't think an attempt to enforce that in the US would
> > prevail (or so I'm told).  That's not saying what TiVo did was right,
> > and that's not saying that what TiVo did was permitted by the license.
> > Only courts of law can do that.
> 
> Wrong! Anyone with half a brain can make the distinction. What TiVO did is 
> entirely legal - they fully complied with the GPLv2. Note that what they 
> *DON'T* allow people to do is run whatever version of whatever software they 
> want on their hardware. They have that right - its the "Free Software 
> Foundation" and the GPL - regardless of version - is a *SOFTWARE* license. 
>...

The GPLv2 says:

"For an executable work, complete source code means all the source code 
for all modules it contains, plus any associated interface definition 
files, plus the scripts used to control compilation and installation of 
the executable."

The question is whether this includes private keys.
Different people have different opinions regarding this issue.

If "the complete source code" includes private keys, the GPLv2 requires 
them to give any costumer the private keys.

Fact is that Harald Welte did in several cases successfully convince 
vendors that private keys are part of the source code if they are 
required for running the compiled binary on some hardware.

AFAIK there haven't been any court rulings on this issue, and it could 
even be that courts in different countries will decide differently.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

