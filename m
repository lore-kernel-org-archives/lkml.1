Return-Path: <linux-kernel-owner+w=401wt.eu-S1765728AbYBOGad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765728AbYBOGad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbYBOGaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:30:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36988 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbYBOGaU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:30:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gene Heskett <gene.heskett@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-reply-to: Your message of "Thu, 14 Feb 2008 13:32:02 EST."
             <200802141332.03315.gene.heskett@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080214232229.f7bdc6ac.sfr@canb.auug.org.au> <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
            <200802141332.03315.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 15 Feb 2008 01:29:14 -0500
Message-ID: <4367.1203056954@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 13:32:02 EST, Gene Heskett said:

> Nvidia vs 2.6.25-rc1 being a case in point, and they (nvidia) are appearing to 
> indicate its not a problem until some distro actually ships a kernel with the
> changes that broke it.  That could be months or even a year plus.

Actually following the NVidia forums indicates otherwise:

http://www.nvnews.net/vbulletin/showthread.php?t=107144

I expect Zander will be posting a patch rather soonish, for some value of
soonish.  And if you're running a -rc or -mm kernel, patching the 169.09
drivers should be well within your abilities....

