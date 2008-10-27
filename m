Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYJ0RL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYJ0RL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYJ0RLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:11:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYJ0RLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:11:49 -0400
Date: Mon, 27 Oct 2008 18:11:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] x86: corruption-check: fix some style issues
Message-ID: <20081027171139.GE19476@elte.hu>
References: <20081005120705.02492d44@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005120705.02492d44@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 5 Oct 2008 11:08:10 -0700
> Subject: [PATCH] x86: corruption-check: fix some style issues
> 
> Before moving the code to it's own file, fix some style issues
> in the corruption check code.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/kernel/setup.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)

i've picked up your fixes into tip/x86/corruption-check:

b43d196: x86: corruption-check: some post-move cleanups
304e629: x86: corruption check: run the corruption checks from a work queue
6784f7d: x86: corruption check: move the corruption checks into their own file
04d2aac: x86: corruption-check: fix some style issues

thanks Arjan!

	Ingo
