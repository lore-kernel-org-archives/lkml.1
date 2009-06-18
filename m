Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZFRJEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZFRJEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZFRJEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:04:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZFRJEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:04:21 -0400
Date: Thu, 18 Jun 2009 11:04:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
	counters on 32-bit powerpc
Message-ID: <20090618090414.GA21191@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <20090617142151.GB6846@elte.hu> <19001.31734.428534.890844@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19001.31734.428534.890844@cargo.ozlabs.ibm.com>
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

> Ingo Molnar writes:
> 
> > Note, i've created a new branch, tip:perfcounters/powerpc, so we can 
> > keep these things separate and Ben can pull them too. I see there 
> > was some review feedback - do you want to send a v2 version perhaps?
> 
> Kumar's comments seemed to me to be wanting changes to accommodate 
> code that doesn't exist yet, so I think those changes should be 
> done later when that code exists and we know exactly what is 
> needed.  So the current patches are fine as-is IMO.

ok - will queue them up.

	Ingo
