Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYF3IyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYF3IyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYF3Ix5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:53:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbYF3Ix4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:53:56 -0400
Date: Mon, 30 Jun 2008 10:53:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       joerg.roedel@amd.com, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86 gart: remove unnecessary set_bit_string
Message-ID: <20080630085318.GA1701@elte.hu>
References: <20080630081117R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630081117R.fujita.tomonori@lab.ntt.co.jp>
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

> iommu_area_alloc internally calls set_bit_string and set bits 
> properly. This set_bit_string is unnecessary.

applied to tip/x86/gart - thanks!

	Ingo
