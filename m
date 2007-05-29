Return-Path: <linux-kernel-owner+w=401wt.eu-S1763245AbXE2TXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763245AbXE2TXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbXE2TXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:23:14 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758438AbXE2TXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:23:13 -0400
Date: Tue, 29 May 2007 12:22:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
In-Reply-To: <465C7AEB.7030304@rtr.ca>
Message-ID: <alpine.LFD.0.98.0705291221480.26602@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0705291428230.3340-100000@iolanthe.rowland.org>
 <465C7AEB.7030304@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Mark Lord wrote:
> 
> I didn't re-break the kernel to do the alt-sysrq thing,
> but I did reapply the b0rken commit plus your new patch (below).
> 
> So far, so good with that combination, thanks.

Ok, let's merge the fix them. Alan, can you send it up-stream with the 
proper commit message and sign-off?

		Linus
