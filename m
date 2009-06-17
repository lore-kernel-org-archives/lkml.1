Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbZFQOWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbZFQOWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZFQOVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:21:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZFQOVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:21:55 -0400
Date: Wed, 17 Jun 2009 16:21:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
	counters on 32-bit powerpc
Message-ID: <20090617142151.GB6846@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> This depends on the generic atomic64_t patches, which are now in 
> Linus' tree.  Ingo, if you're putting these in, please pull Linus' 
> tree in first.

Note, i've created a new branch, tip:perfcounters/powerpc, so we can 
keep these things separate and Ben can pull them too. I see there 
was some review feedback - do you want to send a v2 version perhaps?

	Ingo
