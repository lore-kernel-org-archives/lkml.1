Return-Path: <linux-kernel-owner+w=401wt.eu-S934241AbZHEMdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241AbZHEMdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933704AbZHEMdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:33:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933701AbZHEMdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:33:37 -0400
Date: Wed, 5 Aug 2009 14:33:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Kyle McMartin <kyle@mcmartin.ca>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090805123313.GA23485@elte.hu>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <1249474256.7924.253.camel@twins> <20090805122120.GY12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805122120.GY12579@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Aug 05 2009, Peter Zijlstra wrote:
> > On Sun, 2009-08-02 at 15:44 -0400, Kyle McMartin wrote:
> > 
> > > Why not abuse the perf Makefile, which already has this kind of
> > > portability gunk in it?
> > 
> > Does this work for people?
> 
> Works for me, just tested it.

Thanks Jens - i've committed it and will push it Linus-wards.

	Ingo
