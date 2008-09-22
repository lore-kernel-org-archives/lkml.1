Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYIVRwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYIVRwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYIVRw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:52:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYIVRwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:52:25 -0400
Date: Mon, 22 Sep 2008 19:52:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off
	instead of amd_iommu=off"
Message-ID: <20080922175212.GE10535@elte.hu>
References: <20080922142713.GA24392@amd.com> <20080922235421A.fujita.tomonori@lab.ntt.co.jp> <20080922163109.GD24392@amd.com> <20080923020639U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923020639U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0547]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Sure, Ingo's suggestion looks consistent, but these parameters 
> interact other parameters. If we are serious about improving the IOMMU 
> parameters, we need to spend more time to think about the final 
> picture of all the IOMMU parameters that we need.

yeah, definitely.

	Ingo
