Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYIHNzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYIHNzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYIHNzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:55:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYIHNzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:55:31 -0400
Date: Mon, 8 Sep 2008 15:55:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tony.luck@intel.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 0/3] minor cleanups for swiotlb
Message-ID: <20080908135510.GF11993@elte.hu>
References: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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

> This patchset is minor cleanups for swiotlb. It doesn't confilict with
> the swiotlb fixes for the x86 tree (that I've just sent):
> 
> http://lkml.org/lkml/2008/9/8/30
> 
> This can be cleanly applied to tip/master and tip/x86/iommu.
> 
> Ingo, can you apply this to your tree?

applied to tip/x86/iommu, thanks!

Tony, since ia64 makes use of CONFIG_SWIOTLB, do you have any objections 
to carrying these patches in tip/x86/iommu?

	Ingo
