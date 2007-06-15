Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbXFOUwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbXFOUwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXFOUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:52:13 -0400
Received: from keil-draco.com ([216.193.185.50]:50351 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbXFOUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:52:12 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Carlo Wood <carlo@alinoe.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 16:51:57 -0400
User-Agent: KMail/1.9.6
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Theodore Tso <tytso@mit.edu>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <200706150633.51857.dhazelton@enter.net> <20070615130254.GB11830@alinoe.com>
In-Reply-To: <20070615130254.GB11830@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151651.58033.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 09:02:54 Carlo Wood wrote:
> On Fri, Jun 15, 2007 at 06:33:51AM -0400, Daniel Hazelton wrote:
> > Incorrect. Read section 9 of the GPLv2. It's pretty clear that the "any
> > later version" clause is optional. Whats more is that since the modern
> > linux kernel *IS* a "composite work" composed of Linus' original code
> > with changes contributed by other people - Linus retains copyright to the
> > work as a whole.
>
> Huh - surely not to files added to the kernel that were written by
> others from scratch!

Even those.

> > This means that he can license it in any manner he chooses, as long as it
> > doesn't affect the copyrights (or licensing) of the people that have
> > contributed changes. I don't have to go to the US copyright law for this
> > - Linus released Linux under the GPL, others made changes and sent them
> > back saying "You let me have access to your code under the GPL, I've made
> > some changes that make it better. You can have my changes under the GPL."
> > QED: Linus still holds copyright to Linux and can license it in any way
> > he chooses.
>
> This is totally new to me - if this is true - I'd really like to be sure!
> I always thought that it would be necessary to get signatures of each
> and every contributor before you can change a license of a file. Why do
> you think that the FSF demands written copyright-transfers with
> signatures before you are allowed to submit a patch to any of their
> largers projects? If they - as original copyright holder - could do
> what you claim - they wouldn't need those signatures.

They don't. They demand the signature so that some contributor can't change 
their mind at a later date or even be able to give a proprietary software 
vendor the ability to use the GPL'd code in a non-GPL project.

> Having signed a copyright transfer for 'future' changes for gprof,
> libiberty, readline, zlib, gcc, gdb, libstdc++, bfd, dejagnu, gas,
> and binutils,
> Carlo Wood <carlo@alinoe.com>

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
