Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXFNRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXFNRxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXFNRxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:53:08 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:39242 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbXFNRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:53:07 -0400
Date: Thu, 14 Jun 2007 13:53:05 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614175305.GI10008@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm> <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com> <20070610160531.GA12179@kroah.com> <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com> <20070612184110.GB7980@kroah.com> <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org> <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br> <20070613211432.GH10008@csclub.uwaterloo.ca> <orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 07:38:14PM -0300, Alexandre Oliva wrote:
> So let's go back to the preamble, that provides motivations and some
> guidance as to the interpretation of the legal text (i.e., the spirit
> of the license):
> 
>   [...] the GNU General Public License is intended to guarantee your
>   freedom to share and change free software--to make sure the software
>   is free for all its users. [...]
> 
>   [...] Our General Public Licenses are designed to make sure that you have
>   the freedom to distribute copies of free software (and charge for
>   this service if you wish), that you receive source code or can get
>   it if you want it, that you can change the software or use pieces of
>   it in new free programs; and that you know you can do these things.
> 
>   To protect your rights, we need to make restrictions that forbid
>   anyone to deny you these rights or to ask you to surrender the
>   rights.  These restrictions translate to certain responsibilities
>   for you if you distribute copies of the software, or if you modify
>   it.
> 
>   [...] if you distribute copies of such a program, whether gratis or
>   for a fee, you must give the recipients all the rights that you have
> 
> 
> Can anyone show me how any of the provisions of GPLv3 fails to meet
> this spirit?

Well much as I don't like what Tivo did with only allowing signed
kernels to run, I don't see anything in the above that says they can't
do that.  They let you have the code and make changes to it, they just
don't let you put that changed stuff on the device they build.  The
software is free, even though the hardware is locked down.  The GPL v3
really seems to change the spirit to try and cover usage and hardware
behaviour, while the spirit of the GPL v2 seemed to me at least to
simply be to allow people to copy and change and use the code, and pass
that on to people.  It didn't have anything to do with what they did
with it on hardware.  Nothing prevents you from taking tivos kernel
changes and building your own hardware to run that code on, and as such
the spirit of the GPL v2 seems fulfilled.  It covers freedom of the
source code and resulting binaries, not of the platform you run it on.
The GPL v3 has a much broader coverage of what it wants to control,
which to me means the spirit is different.

I don't have a tivo, I use mythtv on my own PC.  Tivo doesn't force you
to buy their hardware after all.

--
Len Sorensen
