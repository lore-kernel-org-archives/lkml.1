Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbXKTQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbXKTQFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbXKTQF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:05:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49663 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbXKTQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:05:26 -0500
Date: Tue, 20 Nov 2007 08:02:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071120080243.22725fb3@laptopd505.fenrus.org>
In-Reply-To: <474302D0.9000509@rtr.ca>
References: <47425EA5.7000607@rtr.ca>
	<200711201517.16171.nickpiggin@yahoo.com.au>
	<20071119213727.16d5917b@laptopd505.fenrus.org>
	<200711201837.39664.nickpiggin@yahoo.com.au>
	<20071120064747.2a8036cd@laptopd505.fenrus.org>
	<4743018C.1000307@rtr.ca>
	<474302D0.9000509@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 10:52:48 -0500
Mark Lord <lkml@rtr.ca> wro
> 
> All of which reminds me of perhaps *the* most important reason to keep
> core functionality like "IRQ distribution" *inside* the kernel:
> 
>    It has to pass peer review on this mailing list.


that's a reason to keep it in the *source*, that's not the same as
keeping it in ring0 pinning down memory all the time etc ;)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
