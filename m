Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZA2Nk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZA2Nk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZA2Nkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:40:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52813 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbZA2Nkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:40:39 -0500
Date: Thu, 29 Jan 2009 14:40:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH -tip 1/3] IA64: fix swiotlb alloc_coherent for non
	DMA_64BIT_MASK devices
Message-ID: <20090129134022.GG24391@elte.hu>
References: <1233147198-30299-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233147198-30299-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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


Applied them to tip:core/iommu:

 d7ab5c4: intel-iommu: make dma mapping functions static
 dfb805e: IA64: fix VT-d dma_mapping_error
 97d9800: IA64: fix swiotlb alloc_coherent for non DMA_64BIT_MASK devices

thanks!

	Ingo
