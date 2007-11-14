Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbXKNTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbXKNTOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbXKNTOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:14:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52037 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbXKNTOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:14:03 -0500
Date: Wed, 14 Nov 2007 11:03:35 -0800
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
Message-ID: <20071114190335.GA10024@kroah.com>
References: <20071015204840.074767068@goop.org> <20071015215406.GA1588@kroah.com> <4713E2D6.90801@goop.org> <20071113232258.GA10338@kroah.com> <473B4132.5030402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B4132.5030402@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 10:40:50AM -0800, Jeremy Fitzhardinge wrote:
> Greg KH wrote:
> > These don't apply now due to the x86 merge.  Care to backport them and
> > send them to the stable@kernel.org address so we can apply them
> > properly?
> 
> I'm a bit confused.  The patches you mailed out are against arch/i386. 
> Won't they apply to the stable tree as-is?

Was this second series a new set, or a different one?  I was assuming
they were new patches, and that they too needed to be applied.

These patches were sent against the merged x86 tree, not the -stable
tree with i386.

> > Although, it's not like anyone actually uses the in-kernel Xen on
> > 2.6.23, so it's probably not really worth it.
> >   
> 
> To be fair, those fixes were in response to bug reports raised on the
> released 2.6.23 kernel.  But it isn't screamingly urgent.

Ok, that's fine, but can you send some patches that I can apply?  :)

thanks,

greg k-h
