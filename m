Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXFONDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXFONDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXFONCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:02:55 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60567 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753781AbXFONCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:02:54 -0400
Date: Fri, 15 Jun 2007 15:02:54 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Theodore Tso <tytso@mit.edu>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615130254.GB11830@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Daniel Hazelton <dhazelton@enter.net>,
	Bernd Paysan <bernd.paysan@gmx.de>, Theodore Tso <tytso@mit.edu>,
	Alexandre Oliva <aoliva@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
	Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
	david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de> <200706150633.51857.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706150633.51857.dhazelton@enter.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 06:33:51AM -0400, Daniel Hazelton wrote:
> Incorrect. Read section 9 of the GPLv2. It's pretty clear that the "any later 
> version" clause is optional. Whats more is that since the modern linux kernel 
> *IS* a "composite work" composed of Linus' original code with changes 
> contributed by other people - Linus retains copyright to the work as a whole. 

Huh - surely not to files added to the kernel that were written by
others from scratch!

> This means that he can license it in any manner he chooses, as long as it 
> doesn't affect the copyrights (or licensing) of the people that have 
> contributed changes. I don't have to go to the US copyright law for this - 
> Linus released Linux under the GPL, others made changes and sent them back 
> saying "You let me have access to your code under the GPL, I've made some 
> changes that make it better. You can have my changes under the GPL." QED: 
> Linus still holds copyright to Linux and can license it in any way he 
> chooses.

This is totally new to me - if this is true - I'd really like to be sure!
I always thought that it would be necessary to get signatures of each
and every contributor before you can change a license of a file. Why do
you think that the FSF demands written copyright-transfers with
signatures before you are allowed to submit a patch to any of their
largers projects? If they - as original copyright holder - could do
what you claim - they wouldn't need those signatures.

Having signed a copyright transfer for 'future' changes for gprof,
libiberty, readline, zlib, gcc, gdb, libstdc++, bfd, dejagnu, gas,
and binutils,
Carlo Wood <carlo@alinoe.com>
