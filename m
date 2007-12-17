Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbXLQNZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbXLQNZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXLQNZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:25:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbXLQNZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:25:22 -0500
Date: Mon, 17 Dec 2007 14:24:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i386: hard_{en,dis}able_TSC can be static
Message-ID: <20071217132456.GA1870@elte.hu>
References: <47610086.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47610086.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


thanks, applied your patch to x86.git - queued it up for v2.6.25.

	Ingo
