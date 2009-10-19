Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZJSLnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZJSLnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZJSLnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:43:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60787 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZJSLnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:43:16 -0400
Date: Mon, 19 Oct 2009 13:43:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf stat: add branch performance counters to default
Message-ID: <20091019114313.GC12829@elte.hu>
References: <4ADC3975.8050109@klingt.org> <20091019112302.GB12829@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019112302.GB12829@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


btw., your patch was somewhat whitespace damaged (see 
Documentation/email-clients.txt).

I fixed it up manually - please double check latest -tip whether it's 
working all fine for you:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
