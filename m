Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbXKNSlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbXKNSlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXKNSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:41:00 -0500
Received: from gw.goop.org ([64.81.55.164]:58353 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbXKNSk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:40:59 -0500
Message-ID: <473B4132.5030402@goop.org>
Date: Wed, 14 Nov 2007 10:40:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
References: <20071015204840.074767068@goop.org> <20071015215406.GA1588@kroah.com> <4713E2D6.90801@goop.org> <20071113232258.GA10338@kroah.com>
In-Reply-To: <20071113232258.GA10338@kroah.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> These don't apply now due to the x86 merge.  Care to backport them and
> send them to the stable@kernel.org address so we can apply them
> properly?

I'm a bit confused.  The patches you mailed out are against arch/i386. 
Won't they apply to the stable tree as-is?

> Although, it's not like anyone actually uses the in-kernel Xen on
> 2.6.23, so it's probably not really worth it.
>   

To be fair, those fixes were in response to bug reports raised on the
released 2.6.23 kernel.  But it isn't screamingly urgent.

    J
