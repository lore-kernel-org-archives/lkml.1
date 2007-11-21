Return-Path: <linux-kernel-owner+w=401wt.eu-S1765680AbXKUAvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765680AbXKUAvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbXKUAvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:51:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49282 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbXKUAvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:51:14 -0500
Message-ID: <47438025.5080407@zytor.com>
Date: Tue, 20 Nov 2007 16:47:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Lord <lkml@rtr.ca>, Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu> <47436C43.6010200@rtr.ca> <20071120232723.GB23667@elte.hu> <47436ECD.3050004@zytor.com> <20071120234725.GH23667@elte.hu> <474372BC.2000609@zytor.com> <20071121000742.GN23667@elte.hu> <474379C1.2040703@zytor.com> <20071121003629.GA20765@elte.hu>
In-Reply-To: <20071121003629.GA20765@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> i took that "Nope" as referring to my impression - but you in fact meant 
> that i am not wrong? :-) So nothing to see here. single-bzImage initrd 
> was and is possible, so we could in fact move chunks of system-related 
> userland (such as irqbalanced) into the kernel proper?
> 

Yes, it should be quite straightforward.

	-hpa
