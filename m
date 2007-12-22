Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbXLVNTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbXLVNTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbXLVNTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:19:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXLVNTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:19:44 -0500
Date: Sat, 22 Dec 2007 14:16:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, clameter@sgi.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Message-ID: <20071222131601.GB32558@elte.hu>
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This adds a read-only /proc/slabinfo file that is ABI compatible with 
> SLAB for SLUB.
> 
> Cc: Ingo Molnar <mingo@elte.hu>

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
