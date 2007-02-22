Return-Path: <linux-kernel-owner+w=401wt.eu-S932948AbXBVBF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbXBVBF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945934AbXBVBFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:05:51 -0500
Received: from mail.kroah.org ([69.55.234.183]:54086 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbXBVBFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:05:49 -0500
Date: Wed, 21 Feb 2007 16:29:57 -0800
From: Greg KH <greg@kroah.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: gregkh@suse.de, LKML <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       jdike@addtoit.com, ak@suse.de, stable@kernel.org
Subject: Re: [stable] patch x86_64-fix-2.6.18-regression-ptrace_oldsetoptions-should-be-accepted.patch queued to -stable tree
Message-ID: <20070222002957.GB30480@kroah.com>
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

Ok, I'll add it, thanks.

> Also, this patch should also be merged in 2.6.20, but I saw no mail about 
> this, so I wanted to make sure it's heading there too.

If you sent it to me, it's still in my queue, I have a lot of
2.6.20-stable stuff to catch up on still...

thanks,

greg k-h
