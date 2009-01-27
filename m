Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZA0OrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZA0OrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 09:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZA0Oqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 09:46:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbZA0Oqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:46:52 -0500
Date: Tue, 27 Jan 2009 15:46:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH -tip] IA64: fix the compile error on IA64_DIG_VTD
Message-ID: <20090127144637.GA14728@elte.hu>
References: <20090127233530U.fujita.tomonori@lab.ntt.co.jp> <20090127144602.GA12183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127144602.GA12183@elte.hu>
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

> > ---
> >  arch/ia64/kernel/dma-mapping.c |    3 +++
> >  arch/ia64/kernel/pci-swiotlb.c |    3 ---
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Applied to tip/core/iommu, thanks!

Tony, is this fix fine with you too?

	Ingo
