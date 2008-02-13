Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYBMKSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYBMKSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYBMKSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:18:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58431 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYBMKSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:18:11 -0500
Date: Wed, 13 Feb 2008 10:07:01 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213100700.GB21694@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
	arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212194100.GH27894@ZenIV.linux.org.uk> <20080212215152.1470fe7f@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212215152.1470fe7f@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:51:52PM +0000, Alan Cox wrote:
> > We could simply decide that API changes affecting more than one subsystem
> > Must Be Serialized(tm).  Explicitly.  As in "any such change is posted
> 
> Welcome to dreamland. The only way I can get serial changes done is to
> wait months and eventually simply persuade Andrew to ignore the
> "maintainers" who are basically not responding.

... because we didn't realise that the pre-requisits for those patches
had already gone in.  If that had been the case, I'd have applied the
ARM changes for the new tty ioctls immediately.

It was a communication problem, not a process problem.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
