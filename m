Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYIFRvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYIFRvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYIFRv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:51:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYIFRv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:51:27 -0400
Date: Sat, 6 Sep 2008 19:51:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: add two __cpuinit annotations
Message-ID: <20080906175115.GU4856@elte.hu>
References: <48B80468.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B80468.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0136]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/cpu/common_64.c     |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

merged up to and applied to tip/x86/unify-cpu-detect. Thanks,

	Ingo
