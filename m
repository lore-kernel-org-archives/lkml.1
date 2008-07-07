Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYGGHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYGGHoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYGGHog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:44:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYGGHof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:44:35 -0400
Date: Mon, 7 Jul 2008 09:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com, rjw@sisk.pl
Subject: Re: [PATCH 0/6] AMD IOMMU updates
Message-ID: <20080707074404.GA29275@elte.hu>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com> <20080704095213.GB22658@elte.hu> <20080707164023T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707164023T.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0060]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> BTW, "[PATCH 4/6] AMD IOMMU: honor iommu=off instead of amd_iommu=off"
> patch in auto-x86-next needs update the kernel parameter.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] AMD IOMMU: fix kernel parameter
> 
> amd_iommu=off was replaced with a common parameter, iommu=off.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

applied to tip/x86/amd-iommu, thanks.

	Ingo
