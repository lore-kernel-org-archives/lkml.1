Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYJXLlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYJXLlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYJXLlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:41:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbYJXLlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:41:14 -0400
Date: Fri, 24 Oct 2008 13:40:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [GIT *] iommu fixes for 2.6.28
Message-ID: <20081024114046.GA15481@elte.hu>
References: <1224616464.16910.103.camel@macbook.infradead.org> <20081024110125.GA18869@elte.hu> <20081024110815.GA3933@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024110815.GA3933@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i've applied the fix below to tip/x86/urgent.

i have zapped it, to not conflict with the better partial-revert pointed 
out by Fujita.

	Ingo
