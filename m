Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZI3TkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZI3TkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbZI3TkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:40:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZI3TkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:40:00 -0400
Date: Wed, 30 Sep 2009 21:39:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, johnstul@us.ibm.com,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, arjan@infradead.org,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched_clock: Fix atomicity/continuity bug
	by using cmpxchg64()
Message-ID: <20090930193924.GA17840@elte.hu>
References: <20090930170754.0886ff2e@infradead.org> <tip-1cb9955464ad248c79c48e9c8be6669020fe178c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-1cb9955464ad248c79c48e9c8be6669020fe178c@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1029]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Arjan van de Ven <arjan@infradead.org> wrote:

> Commit-ID:  1cb9955464ad248c79c48e9c8be6669020fe178c
> Gitweb:     http://git.kernel.org/tip/1cb9955464ad248c79c48e9c8be6669020fe178c
> Author:     Arjan van de Ven <arjan@infradead.org>

Note: i just fixed this to be Eric.

	Ingo
