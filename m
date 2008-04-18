Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYDRMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYDRMl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYDRMlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:41:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYDRMlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:41:45 -0400
Date: Fri, 18 Apr 2008 14:41:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080418124100.GD17013@elte.hu>
References: <20080417083000.GA4935@elte.hu> <20080417014054.ea788f1f.akpm@linux-foundation.org> <20080417090626.GA14383@elte.hu> <20080417021813.04df7912.akpm@linux-foundation.org> <20080417093025.GA17389@elte.hu> <20080417023603.672d1032.akpm@linux-foundation.org> <84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com> <20080417033333.947dfcc9.akpm@linux-foundation.org> <20080417103800.GA27250@elte.hu> <20080417070129.2bb99e2c@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417070129.2bb99e2c@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > i think slab is clearly out, unless some catastrophic regression is 
> > found.
> 
> SLUB still has that several percent TPC-C regression.... Christoph has 
> a small reproducer testcase.

btw., several percent of TPC-C is bad... so i take back the 'SLAB is 
out' observation for now :-/

	Ingo
