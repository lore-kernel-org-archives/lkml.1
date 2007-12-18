Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXLRV5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXLRV5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXLRV5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:57:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57850 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbXLRV5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:57:30 -0500
Date: Tue, 18 Dec 2007 22:57:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] kvm IOPL_MASK cleanup
Message-ID: <20071218215709.GA16392@elte.hu>
References: <20071218214604.E07B326F8C2@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218214604.E07B326F8C2@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> IOPL_MASK went away and kvm/vmx.c doesn't compile.

thanks, applied.

	Ingo
