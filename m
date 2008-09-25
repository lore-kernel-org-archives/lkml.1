Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYIYJFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYIYJFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYIYJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:05:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYIYJFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:05:33 -0400
Date: Thu, 25 Sep 2008 11:05:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: Re: [PATCH] x86 gart: remove unnecessary initialization
Message-ID: <20080925090525.GB16734@elte.hu>
References: <20080924224038N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924224038N.fujita.tomonori@lab.ntt.co.jp>
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

> This is against tip/x86/iommu
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] x86 gart: remove unnecessary initialization in struct dma_mapping_ops
> 
> There is no point to have such initialization in struct dma_mapping_ops.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

applied to tip/x86/iommu, thanks!

	Ingo
