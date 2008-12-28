Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYL1L5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYL1L5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 06:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYL1L4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 06:56:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbYL1L4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 06:56:52 -0500
Date: Sun, 28 Dec 2008 12:56:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org, joerg.roedel@amd.com
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-ID: <20081228115621.GA11954@elte.hu>
References: <20081228093751.GC9022@elte.hu> <20081228190111H.fujita.tomonori@lab.ntt.co.jp> <20081228103419.GA7128@elte.hu> <20081228195952F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228195952F.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> You brought up a different topic, DMA bouncing implementations 
> unification. DMA bouncing implementations unification is a very nice 
> cleanup. But it's not related with Becky's patch to break IA64 build at 
> all.

All i'm saying is that obviously neither Jeremy's nor Becky's patches were 
created in a vacuum, and had it not been for the need and desire to extend 
swiotlb we'd not have seen Becky's 9/9 cleanup patch either.

	Ingo
