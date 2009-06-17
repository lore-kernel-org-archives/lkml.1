Return-Path: <linux-kernel-owner+w=401wt.eu-S1765534AbZFQMEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765534AbZFQMEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZFQMEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:04:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374AbZFQMEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:04:23 -0400
Date: Wed, 17 Jun 2009 14:04:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
	counters on 32-bit powerpc
Message-ID: <20090617120417.GA26454@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0587]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> This depends on the generic atomic64_t patches, which are now in 
> Linus' tree.  Ingo, if you're putting these in, please pull Linus' 
> tree in first.

yes, i already did that earlier today - so all should be fine with 
the lib/atomic64.c dependency.

	Ingo
