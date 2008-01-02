Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYABLJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYABLJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYABLJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:09:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbYABLJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:09:18 -0500
Date: Wed, 2 Jan 2008 12:08:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080102110859.GC14731@elte.hu>
References: <9DtBq-2jD-3@gated-at.bofh.it> <20071224012524.GA21843@gondor.apana.org.au> <20071230131018.GC16946@elte.hu> <200801022131.15482.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801022131.15482.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> (or -- why do we even make CONFIG_PREEMPT_BKL an option? [...]

thanks for the reminder - i just zapped it. Was a pleasure ;-)

	Ingo
