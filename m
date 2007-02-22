Return-Path: <linux-kernel-owner+w=401wt.eu-S1945940AbXBVBGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945940AbXBVBGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945934AbXBVBGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:06:03 -0500
Received: from mail.kroah.org ([69.55.234.183]:54091 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945932AbXBVBFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:05:50 -0500
Date: Wed, 21 Feb 2007 16:32:25 -0800
From: Greg KH <greg@kroah.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: gregkh@suse.de, LKML <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       jdike@addtoit.com, ak@suse.de, stable@kernel.org
Subject: Re: [stable] patch x86_64-fix-2.6.18-regression-ptrace_oldsetoptions-should-be-accepted.patch queued to -stable tree
Message-ID: <20070222003225.GC30480@kroah.com>
References: <20070220234253.7B612C15B05@imap.suse.de> <200702211343.43112.blaisorblade@yahoo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702211343.43112.blaisorblade@yahoo.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 01:43:42PM +0100, Blaisorblade wrote:
> On Wednesday 21 February 2007 00:41, gregkh@suse.de wrote:
> > This is a note to let you know that we have just queued up the patch titled
> >
> >      Subject: x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should
> > be accepted
> >
> > to the 2.6.18-stable tree.  Its filename is
> 
> Since you are still maintaining 2.6.18, I've just sent another patch for that, 
> i.e. the backport of commit 14679eb3c50897889ba62f9a37e3bcd8a205b5e7.
> Could you still merge it in this release, especially since this is the last 
> 2.6.18-stable you are doing?
> Also, this patch should also be merged in 2.6.20, but I saw no mail about 
> this, so I wanted to make sure it's heading there too.
> 
> > x86_64-fix-2.6.18-regression-ptrace_oldsetoptions-should-be-accepted.patch
> >
> > A git repo of this tree can be found at
> >    
> > http://www.kernel.org/git/?p=linux/kernel/git/gregkh/stable-queue.git;a=sum
> >mary
> 
> Hmm, this should be (note the missing gregkh in the path):
> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

Ah, good point, I'll go change my script that generates this, thanks for
pointing it out.

greg k-h
