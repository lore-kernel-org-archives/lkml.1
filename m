Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbXGXAKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbXGXAKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXGXAK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:10:26 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38860 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXGXAKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:10:25 -0400
Date: Mon, 23 Jul 2007 20:10:23 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: Git tree for old kernels from before the current tree
In-reply-to: <20070723234628.GN21668@ftp.linux.org.uk>
X-X-Sender: nico@xanadu.home
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.0.999.0707231957450.6355@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
 <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
 <20070722211314.GA13850@linux-sh.org>
 <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr>
 <46A3D5EA.2050600@zytor.com>
 <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707231343350.6355@xanadu.home>
 <alpine.LFD.0.999.0707231057480.3607@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707231432560.6355@xanadu.home>
 <20070723234628.GN21668@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Al Viro wrote:

> On Mon, Jul 23, 2007 at 03:06:09PM -0400, Nicolas Pitre wrote:
> >  - v0.96 sources
> > 
> >  - v0.99.12 announcement
> > 
> >  - sources for v0.99.13{abcdefghij} (got k, don't know where the serie 
> >    ends) as well as announcements for all of them
> > 
> >  - all announcements for v0.99.14{a-z} except for pl14r
> > 
> >  - announcements for pl15c to pl15j, 1.0-pre1, and ALPHA-1.0.
> > 
> > Otherwise the archive appears fairly complete with almost 3 years of 
> > Linux development history captured in a 3MB pack file.
> 
> Umm...  IIRC, tar was unhappy with several tarballs on ftp.kernel.org.
> Do you have replacements (or instructions re combination of tar(1) options
> to make it eat them)?

I have sanitized .tgz files that I use to stuff a Git repo with.  I 
recall that some of them were reconstructed through patching an earlier 
or later kernel version because the original ones were corrupted. Some 
patches were retrieved from other archival sites, etc.  Then the result 
was 
cross checked with summary lists like this one: 

http://www.uwsg.iu.edu/hypermail/linux/kernel/0110.1/1684.html

This was a while ago so I don't remember the exact steps, but that 
wasn't always trivial.


Nicolas
