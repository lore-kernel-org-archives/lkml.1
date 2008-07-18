Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbYGRU1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbYGRU1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYGRU1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:27:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47633 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbYGRU1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:27:06 -0400
Date: Fri, 18 Jul 2008 22:26:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
Subject: Re: [PATCH] slub: dump more data on slab corruption
Message-ID: <20080718202646.GE24122@elte.hu>
References: <Pine.LNX.4.64.0807181729370.7723@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807181729370.7723@sbz-30.cs.Helsinki.FI>
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


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The limit to 128 bytes is too small when debugging slab corruption of the skb
> cache, for example. Increase the limit to PAGE_SIZE to make debugging
> corruptions sligthly easier.
> 
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
