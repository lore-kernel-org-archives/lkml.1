Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbXK1LOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbXK1LOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbXK1LOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:14:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759876AbXK1LOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:14:17 -0500
Date: Wed, 28 Nov 2007 12:13:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] x86: eflags enum
Message-ID: <20071128111358.GF22039@elte.hu>
References: <20071128050745.357E826F8E7@magilla.localdomain> <20071128050912.7F31126F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128050912.7F31126F8E7@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> This removes the EF_* enum from <asm/ptrace.h>.  It is no longer used, 
> and duplicates the X86_EFLAGS_* constants from 
> <asm/processor-flags.h>.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

thanks, added. (queued to after the ptrace patches in x86.git)

	Ingo
