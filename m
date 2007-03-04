Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbXCDVOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbXCDVOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 16:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXCDVOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 16:14:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49131 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXCDVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 16:14:31 -0500
Date: Sun, 4 Mar 2007 13:14:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL][RETRY] KVM updates for Linux 2.6.21-rc2
In-Reply-To: <45EA8F9F.6010006@qumranet.com>
Message-ID: <Pine.LNX.4.64.0703041308100.3953@woody.linux-foundation.org>
References: <45EA8F9F.6010006@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Mar 2007, Avi Kivity wrote:
> 
> The changes fall into three broad categories:
> - initial kvm paravirtulization support
> - the first batch of the stable userspace interface changes
> - fixes, fixes, fixes

This is the absolute last time I say this.

WAY too late. You'd better get this in before -rc1 next time around. I 
want *FIXES*ONLY* by now, and next time I see crap like this I'm going to 
ignore it until you fix me a pull that contains fixes only, and I'm not 
even going to pull during the next merge window because I'm not interested 
in merging something that isn't maintained and doesn't get those "fixes 
only" trees.

So I pulled this now, but the fact is, I already ignored this once exactly 
because it wasn't appropriate to pull at this point. Yes, I soemtimes miss 
emails, but dammit, quite often it's also because I just judge the email 
to be *CRAP* and simply not worth bothering with.

750 new lines of code, with much of it apparently being new features, and 
stupid cleanups and cosmetics that don't actually fix anything simply 
isn't "post-rc2 material". I really *really* don't want to see this again!

I'm really fed up with having to pull big changes after the merge window, 
because it just doesn't seem to let up. I'm going to go postal on the next 
maintainer who doesn't understand what "merge window" and "fixes only" 
means.

		Linus
