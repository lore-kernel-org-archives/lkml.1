Return-Path: <linux-kernel-owner+w=401wt.eu-S1765394AbZAQQlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765394AbZAQQlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763844AbZAQQlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:41:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763668AbZAQQlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:41:12 -0500
Date: Sat, 17 Jan 2009 17:41:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] x86: fix 22 make headers_check warnings
Message-ID: <20090117164108.GG10825@elte.hu>
References: <1232209856.3388.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232209856.3388.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> The following changes since commit 206e00df0967f6e91d792df7f1d4ff352eb42f8f:
>   Ingo Molnar (1):
>         Merge branch 'x86/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> 
> Jaswinder Singh Rajput (8):
>       x86: boot.h fix make headers_check
>       x86: e820.h fix make headers_check
>       x86: kvm.h fix make headers_check
>       x86: mce.h fix make headers_check
>       x86: mtrr.h fix make headers_check
>       x86: ptrace-abi.h fix make headers_check
>       x86: sigcontext.h fix make headers_check
>       x86: swab.h fix make headers_check
> 
>  arch/x86/include/asm/boot.h       |    2 ++
>  arch/x86/include/asm/e820.h       |   11 ++++++++---
>  arch/x86/include/asm/kvm.h        |    2 +-
>  arch/x86/include/asm/mce.h        |    5 +----
>  arch/x86/include/asm/mtrr.h       |    1 +
>  arch/x86/include/asm/ptrace-abi.h |    5 ++++-
>  arch/x86/include/asm/sigcontext.h |    2 +-
>  arch/x86/include/asm/swab.h       |   21 +++++++++++++++++++--
>  8 files changed, 37 insertions(+), 12 deletions(-)

Pulled into tip/core/header-fixes and started testing them, thanks 
Jaswinder!

	Ingo
