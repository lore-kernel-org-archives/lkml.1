Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXLTJOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXLTJOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXLTJOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:14:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbXLTJOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:14:09 -0500
Date: Thu, 20 Dec 2007 10:13:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
Message-ID: <20071220091347.GB4478@elte.hu>
References: <20071219223534.129042140@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219223534.129042140@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's another round of the pagetable unification patches.  I've done 
> a few dozen rounds of randconfig builds on both 32- and 64-bit, so I 
> hope that will prevent compile problems in your test environment.
> 
> I've also boot-tested 64-bit and 32-bit PAE/non-PAE configs (both 
> paravirt and non-paravirt).

thanks, applied.

	Ingo
