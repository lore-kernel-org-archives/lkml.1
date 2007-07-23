Return-Path: <linux-kernel-owner+w=401wt.eu-S935689AbXGWUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935689AbXGWUYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935467AbXGWUXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:23:07 -0400
Received: from thunk.org ([69.25.196.29]:52303 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935132AbXGWUXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:23:04 -0400
Date: Mon, 23 Jul 2007 16:22:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git tree for old kernels from before the current tree
Message-ID: <20070723202210.GC30165@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Paul Mundt <lethal@linux-sh.org>, Jon Smirl <jonsmirl@gmail.com>,
	Git Mailing List <git@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com> <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr> <20070722211314.GA13850@linux-sh.org> <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr> <46A3D5EA.2050600@zytor.com> <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org> <20070723185732.GB30165@thunk.org> <alpine.LFD.0.999.0707231242090.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707231242090.3607@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 12:44:57PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 23 Jul 2007, Theodore Tso wrote:
> > 
> > Um, *I* never had the bad taste to import Linux kernels into CVS.  :-)
> 
> Ahh. I just checked. 
> 
> RCS.
> 
> There are old linux archive of yours that has some RCS files in it (0.10 
> and 0.12 at least)

Ah, yes, I used to use RCS in order to generate the patches that I
sent to use.  The RCS directories were short-term, and never lasted
longer until the next kernel release.  I'm kind of surprised that I
actually had archives that had RCS files, since tsx-11 should have
just had the original tar.gz files from ftp.cs.helsinki.edu.  Maybe
for some reason the original files got nuked and I replaced it with
one of my saved files at one point.  I dunno....

       	  	      	     	     - Ted
