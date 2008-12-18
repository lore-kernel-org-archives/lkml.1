Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752040AbYLRMg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbYLRMg6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYLRMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:36:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYLRMgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:36:45 -0500
Date: Thu, 18 Dec 2008 13:36:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: time_64.c timer_interrupt should be static
Message-ID: <20081218123638.GF25715@elte.hu>
References: <1229536041.23068.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229536041.23068.1.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Impact: cleanup, reduce kernel size a bit
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/kernel/time_64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/x86/cleanups, thanks Jaswinder!

	Ingo
