Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYGIIw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYGIIw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYGIIwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:52:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbYGIIws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:52:48 -0400
Date: Wed, 9 Jul 2008 10:52:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
Message-ID: <20080709085230.GA6267@elte.hu>
References: <20080709162913H.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709162913H.tomof@acm.org>
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

> Should be CONFIG_GART_IOMMU instead of CONFIG_IOMMU here?
> 
> Hmm, looks like it would be nice to have more cleanups of iommu.h and 
> gart.h.
> 
> This is against tip/master.

applied to tip/x86/core, thanks!

agreed about the cleanups. We are willing to test RFC patches :-)

	Ingo
