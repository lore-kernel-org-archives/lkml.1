Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbXFNBBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbXFNBBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbXFNBBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:01:36 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50884 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbXFNBBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:01:35 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 21:01:28 -0400
User-Agent: KMail/1.9.6
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706131946.15714.dhazelton@enter.net> <20070614004419.GL3588@stusta.de>
In-Reply-To: <20070614004419.GL3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132101.28330.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 20:44:19 Adrian Bunk wrote:
> On Wed, Jun 13, 2007 at 07:46:15PM -0400, Daniel Hazelton wrote:
> > On Wednesday 13 June 2007 19:15:42 Alexandre Oliva wrote:
> > > On Jun 13, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > > On Wed, 13 Jun 2007, Alan Cox wrote:
> > > >> > find offensive, so I don't choose to use it. It's offensive
> > > >> > because Tivo never did anything wrong, and the FSF even
> > > >> > acknowledged that. The fact
> > > >>
> > > >> Not all of us agree with this for the benefit of future legal
> > > >> interpretation.
> > > >
> > > > Well, even the FSF lawyers did,
> > >
> > > Or rather they didn't think an attempt to enforce that in the US would
> > > prevail (or so I'm told).  That's not saying what TiVo did was right,
> > > and that's not saying that what TiVo did was permitted by the license.
> > > Only courts of law can do that.
> >
> > Wrong! Anyone with half a brain can make the distinction. What TiVO did
> > is entirely legal - they fully complied with the GPLv2. Note that what
> > they *DON'T* allow people to do is run whatever version of whatever
> > software they want on their hardware. They have that right - its the
> > "Free Software Foundation" and the GPL - regardless of version - is a
> > *SOFTWARE* license. ...
>
> The GPLv2 says:
>
> "For an executable work, complete source code means all the source code
> for all modules it contains, plus any associated interface definition
> files, plus the scripts used to control compilation and installation of
> the executable."
>
> The question is whether this includes private keys.
> Different people have different opinions regarding this issue.
>
> If "the complete source code" includes private keys, the GPLv2 requires
> them to give any costumer the private keys.
>
> Fact is that Harald Welte did in several cases successfully convince
> vendors that private keys are part of the source code if they are
> required for running the compiled binary on some hardware.

If the hardware was designed for the end-user to change the software running 
on it - including running software that it was never meant to run (ie: a 
complete webserver on cell phone) - then yes, the signing keys are a part of 
the source, as the software running on the device is designed to be updated 
by the user using the provided system.

If, on the other hand, the only "software updates" the user is expected to 
perform are the installation of newer versions of the existing code 
for "Security" or "Bug Fix" reasons then the signing keys aren't part of the 
source.

I haven't looked into what Harald Welte did, but I'd be surprised if someone 
tried following suit in America and had as much success.

>
> AFAIK there haven't been any court rulings on this issue, and it could
> even be that courts in different countries will decide differently.

Agreed.

DRH

>
> cu
> Adrian



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
