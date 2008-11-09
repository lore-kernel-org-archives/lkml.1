Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbYKIU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbYKIU32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYKIU3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:29:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbYKIU3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:29:05 -0500
Date: Sun, 9 Nov 2008 21:28:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, hpa@zytor.com
Subject: Re: Move iomap.h to arch/x86/include/asm
Message-ID: <20081109202855.GA26895@elte.hu>
References: <20081109101405.6981b835@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109101405.6981b835@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> 
> 
> The following changes since commit
> a622cf69b806bbb1887913c04e01d0c25b892876: Linus Torvalds (1):
>         Merge branch 'sched-fixes-for-linus' of
> git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-kerneloops.git
>   for-mingo
> 
> Arjan van de Ven (1):
>       x86: move iomap.h to the new include location
> 
>  {include/asm-x86 => arch/x86/include/asm}/iomap.h |    0
>  1 files changed, 0 insertions(+), 0 deletions(-)
>  rename {include/asm-x86 => arch/x86/include/asm}/iomap.h (100%)

pulled into tip/x86/urgent, thanks Arjan!

	Ingo
