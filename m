Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbZGCSp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbZGCSp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZGCSpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:45:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53649 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbZGCSpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:45:16 -0400
Date: Fri, 3 Jul 2009 20:45:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
       arnd@arndb.de, dhowells@redhat.com, fweisbec@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: Optimize CMPXCHG8B
	sequences to not use the LOCK prefix
Message-ID: <20090703184507.GA6094@elte.hu>
References: <20090703111033.6e9627de@infradead.org> <tip-07aa81b2169a2cb5e62ad239fd8055ef484e4f79@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-07aa81b2169a2cb5e62ad239fd8055ef484e4f79@git.kernel.org>
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


* tip-bot for Ingo Molnar <mingo@elte.hu> wrote:

> x86: atomic64: Optimize CMPXCHG8B sequences to not use the LOCK prefix

ok, that's wrong so i dropped it.

	Ingo
