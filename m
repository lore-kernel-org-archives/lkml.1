Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYGFGNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYGFGNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 02:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYGFGNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 02:13:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYGFGNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 02:13:36 -0400
Date: Sun, 6 Jul 2008 08:13:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-ia64@vger.kernel.org, parisc-linux@parisc-linux.org,
       "David S. Miller" <davem@davemloft.net>, Peter Anvin <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: the printk problem
Message-ID: <20080706061311.GA23606@elte.hu>
References: <20080704104634.GA31634@digi.com> <20080704111540.ddffd241.akpm@linux-foundation.org> <alpine.LFD.1.10.0807041147450.2815@woody.linux-foundation.org> <alpine.LFD.1.10.0807041250220.2815@woody.linux-foundation.org> <1215212420.8970.8.camel@pasglop> <alpine.LFD.1.10.0807041622270.2815@woody.linux-foundation.org> <alpine.LFD.1.10.0807051523180.2847@woody.linux-foundation.org> <20080706052741.GA18928@elte.hu> <alpine.LFD.1.10.0807052232530.3016@woody.linux-foundation.org> <20080706055317.GA4212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706055317.GA4212@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> yeah, agreed, combined it's not an x86 topic anymore.
> 
> [ There's some lkml trouble so i've missed the earlier patch. I'm not 
>   sure the email problem is on my side, see how incomplete the 
>   discussion is on lkml.org as well:
> 
>      http://lkml.org/lkml/2008/6/25/170   ]
> 
> Anyway, i have have added this second patch of yours to 
> tip/core/printk and moved your first patch over to that topic (which 
> relies on it).

ah, i found the reason - it started out on linux-ia64 originally then 
moved over to lkml - so only half of the discussion was visible there. 
And linux-ia64 is one of the few vger lists i'm not subscribed to 
apparently. (there's no vger-please-give-me-all-emails list - making the 
following of Linux development even harder)

	Ingo
