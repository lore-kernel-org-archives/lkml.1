Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYDUXCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYDUXCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbYDUXCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:02:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588AbYDUXCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:02:30 -0400
Date: Mon, 21 Apr 2008 16:00:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kernel@wantstofly.org,
       linux-arm-kernel@lists.arm.linux.org.uk, galak@kernel.crashing.org,
       David Miller <davem@davemloft.net>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, cooloney@kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] minor irq handler cleanups
In-Reply-To: <480C4DF1.2030204@garzik.org>
Message-ID: <alpine.LFD.1.10.0804211559230.2779@woody.linux-foundation.org>
References: <20080421013551.GA25960@havoc.gtf.org> <20080421074240.GA1938@flint.arm.linux.org.uk> <480C4DF1.2030204@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Apr 2008, Jeff Garzik wrote:
> 
> hrm, good point.  I re-reviewed specifically for this issue, just now, and it
> looks like there is another case of this as well, outside ARM.
> 
> If this hasn't been pulled, I'll redo the commit, otherwise I'll fix.

Gaah, I was going through my backlog, and the "please pull" was before 
this, so I didn't notice. I even *looked* at that part of the patch, and 
thought it looked odd, but the rest of it looked like obvious cleanups so 
I decided you knew what you were doing.

So please do send a fixup patch.

		Linus
