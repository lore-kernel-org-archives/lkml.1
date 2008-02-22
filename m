Return-Path: <linux-kernel-owner+w=401wt.eu-S1765301AbYBVX1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765301AbYBVX1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYBVX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:27:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45518 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbYBVX1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:27:01 -0500
Date: Fri, 22 Feb 2008 15:18:08 -0800
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, arjan@infradead.org, gregkh@suse.de,
       stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: [stable] patch
	kbuild-allow-fstack-protector-to-take-effect.patch added to
	2.6.24-stable tree
Message-ID: <20080222231808.GA30669@kroah.com>
References: <200802190005.m1J05SKP017015@hera.kernel.org> <20080222230103.CC4EF14540D0@imap.suse.de> <20080222230604.GA20829@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222230604.GA20829@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 06:06:04PM -0500, Dave Jones wrote:
> On Fri, Feb 22, 2008 at 03:00:58PM -0800, gregkh@suse.de wrote:
>  > 
>  > This is a note to let you know that we have just queued up the patch titled
>  > 
>  >      Subject: kbuild: allow -fstack-protector to take effect
>  > 
>  > to the 2.6.24-stable tree.  Its filename is
>  > 
>  >      kbuild-allow-fstack-protector-to-take-effect.patch
>  > 
>  > A git repo of this tree can be found at 
>  >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> Is this wise given this thread..  http://lkml.org/lkml/2008/2/22/101    ?
> 
> At least until the problem is understood, not enabling this seems like
> a better option for -stable

I thought that thread was for the much larger patches, not just this
Makefile change.

Or am I wrong here?  If so, I'll gladly drop it.  Arjan?  Sam?

thanks,

greg k-h
