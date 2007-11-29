Return-Path: <linux-kernel-owner+w=401wt.eu-S1762547AbXK2KkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762547AbXK2KkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXK2KkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:40:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXK2KkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:40:02 -0500
Date: Thu, 29 Nov 2007 11:39:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 1/6] x86-64 ia32 ptrace pt_regs cleanup
Message-ID: <20071129103938.GE10577@elte.hu>
References: <20071129003849.428E026F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129003849.428E026F8E7@magilla.localdomain>
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
X-Mailing-List: linux-kernel@vger.kernel.org


thanks - i've queued up all 6 patches of yours. They applied fine to 
x86.git and passed a quick build & boot test as well.

	Ingo
