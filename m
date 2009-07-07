Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZGGXYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZGGXYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZGGXYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:24:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZGGXYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:24:39 -0400
Date: Wed, 8 Jul 2009 01:24:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] perf_counter: Add p6 PMU
Message-ID: <20090707232433.GA31234@elte.hu>
References: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
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


* Vince Weaver <vince@deater.net> wrote:

> OK, so I lied, I found time to throw together a p6 PMU 
> patch. I've tested it on a Pentium III and it seems to be 
> working.

Cool!! I've got some P3 box around somewhere so can try 
this in a few days.

The patch looks really clean and simple.

	Ingo
