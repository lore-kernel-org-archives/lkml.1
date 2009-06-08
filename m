Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZFHPaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZFHPaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZFHPaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:30:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZFHPaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:30:07 -0400
Date: Mon, 8 Jun 2009 17:29:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull][PATCH 0/5] dma-debug minor fixes and cleanups
Message-ID: <20090608152958.GC20905@elte.hu>
References: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 62a6f465f6572e1f28765c583c12753bb3e23715:
>   Ingo Molnar (1):
>         Merge branch 'dma-debug/2.6.31' of git://git.kernel.org/.../joro/linux-2.6-iommu into core/iommu
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/fixes
> 
> Joerg Roedel (5):
>       dma-debug: comment style fixes
>       dma-debug: code style fixes
>       dma-debug: use pr_* instead of printk(KERN_* ...)
>       dma-debug: disable/enable irqs only once in device_dma_allocations
>       dma-debug: simplify logic in driver_filter()
> 
>  lib/dma-debug.c |  112 +++++++++++++++++++++++++++---------------------------
>  1 files changed, 56 insertions(+), 56 deletions(-)
> 
> These changes fix various style issues and convert API functions 
> to newer versions. The last two patches optimize irq 
> enable/disable frequency and simplify driver filter code to make 
> it more readable. Please pull.

Pulled, thanks Joerg!

	Ingo
