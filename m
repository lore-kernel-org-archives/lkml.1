Return-Path: <linux-kernel-owner+w=401wt.eu-S934175AbZHEMVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbZHEMVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933634AbZHEMVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:21:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50175 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622AbZHEMVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:21:20 -0400
Date: Wed, 5 Aug 2009 14:21:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090805122120.GY12579@kernel.dk>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <1249474256.7924.253.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249474256.7924.253.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05 2009, Peter Zijlstra wrote:
> On Sun, 2009-08-02 at 15:44 -0400, Kyle McMartin wrote:
> 
> > Why not abuse the perf Makefile, which already has this kind of
> > portability gunk in it?
> 
> Does this work for people?

Works for me, just tested it.

-- 
Jens Axboe

