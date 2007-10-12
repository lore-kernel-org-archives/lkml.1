Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbXJLM6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbXJLM6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXJLM6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:58:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34370 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbXJLM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:58:14 -0400
Message-ID: <470F6F5E.4080601@garzik.org>
Date: Fri, 12 Oct 2007 08:58:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
References: <aday7e9b0m3.fsf@cisco.com> <20071011.181719.78707713.davem@davemloft.net> <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Oh, and obviously, the NAPI changes may well have resulted in a merge that 
> had no actual *conflicts* in it, but whether the end result works or not 
> (and whether any IB drivers need updating due to the NAPI changes), I 
> cannot tell. I've pushed out my tree, so people who are competent or just 
> morbidly curious should start looking at it: it's got the following things 
> merged now:
> 
>  - x86 merge
>  - mmc
>  - v4l-dvb
>  - blackfin
>  - avr32
>  - block layer updates
>  - Jeff's dmi-const
>  - Purdie's blacklight and led trees
>  - ide
>  - mips
>  - net
>  - infiniband
> 
> and it all builds for me, but hey, I don't use half of it.


works here on intel x86-64, amd64, and 32-bit pentium4.

and without disk corruption, so I may now attend to the libata merge :)

	Jeff


