Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZEKMrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZEKMrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZEKMrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:47:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48279 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZEKMrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:47:23 -0400
Date: Mon, 11 May 2009 14:46:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, yanghy@cn.fujitsu.com,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dma-mapping: mark DMA_nBITS_MASK as deprecated fix
Message-ID: <20090511124646.GK13954@elte.hu>
References: <20090510085618D.fujita.tomonori@lab.ntt.co.jp> <1241939066-10178-1-git-send-email-jirislaby@gmail.com> <20090511113659U.fujita.tomonori@lab.ntt.co.jp> <4A07EE1C.2010705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A07EE1C.2010705@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 05/11/2009 04:36 AM, FUJITA Tomonori wrote:
> > But I think that you need to resend a version of this patch against
> > tip. We need this patch in linux-next to warn some new users of these
> > deprecated macros.
> 
> It depends on Ingo if he doesn't mind to pick it up :).

Yes, i picked it up - dma-mapping.h changes generally get reviewed 
by and go via the IOMMU folks and is maintained in tip:core/iommu.

	Ingo
