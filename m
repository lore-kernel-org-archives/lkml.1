Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYL1JGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYL1JGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYL1JF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:05:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59865 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbYL1JF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:05:57 -0500
Date: Sun, 28 Dec 2008 10:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Becky Bruce <beckyb@kernel.crashing.org>
Subject: Re: [PATCH 0/3] swiotlb cleanups
Message-ID: <20081228090537.GA9022@elte.hu>
References: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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

> This is minor swiotlb cleanups. It depends on the swiotlb highmem
> patchset:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git swiotlb

thanks, applied them to tip/core/iommu - after Becky's patchset as ported 
by Jeremy.

	Ingo
