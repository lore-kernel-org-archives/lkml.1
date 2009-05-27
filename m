Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbZE0XeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbZE0XeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZE0Xdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:33:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbZE0Xdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:33:54 -0400
Date: Thu, 28 May 2009 01:33:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 0/3] dma-debug fixes
Message-ID: <20090527233338.GD3830@elte.hu>
References: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090527124738.GH3927@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527124738.GH3927@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, May 27, 2009 at 09:43:00AM +0900, FUJITA Tomonori wrote:
> > None of them is critical (we get bogus warnings due to the bugs but
> > the bugs are in unpopular DMA mapping functions).
> > 
> > This patchset is against to tip/master.
> 
> Acked-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> They all look good to me.
> 
> Ingo, do you want to pick them up youself or should I include them 
> into my dma-debug pull-request to you for 2.6.31?

Sure, feel free to include them.

Thanks,

	Ingo
