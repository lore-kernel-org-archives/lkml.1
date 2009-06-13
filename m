Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZFMWLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZFMWLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZFMWL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:11:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZFMWL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:11:27 -0400
Date: Sat, 13 Jun 2009 21:44:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paulus Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: perfcounters: lockdep warning
Message-ID: <20090613194447.GA2616@elte.hu>
References: <1244921989.12341.487.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1244921989.12341.487.camel@odie.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Holm Thøgersen <odie@cs.aau.dk> wrote:

> Just tried kicking the tires of performance counters and perf and 
> got the following warning that doesn't look like have been 
> reported already.

Hm, this looks safe at first sight so you can ignore this for now, 
we'll annotate it properly - thanks for reporting it. Did you see 
any lockups/problems?

	Ingo
