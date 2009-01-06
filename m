Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZAFNIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZAFNIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZAFNHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:07:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZAFNHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:07:51 -0500
Date: Tue, 6 Jan 2009 14:07:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] calgary: add map_page and unmap_page
Message-ID: <20090106130733.GD20407@elte.hu>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090106083201.GD6841@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106083201.GD6841@il.ibm.com>
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


* Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Mon, Jan 05, 2009 at 11:47:24PM +0900, FUJITA Tomonori wrote:
> > This is a preparation of struct dma_mapping_ops unification. We use
> > map_page and unmap_page instead of map_single and unmap_single.
> > 
> > We will remove map_single and unmap_single hooks in the last patch in
> > this patchset.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> Calgary bits look fine.
> 
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

thanks, added your ack to the changelog.

	Ingo
