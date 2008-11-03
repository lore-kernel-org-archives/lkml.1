Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYKCOFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYKCOFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYKCOFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:05:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYKCOFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:05:04 -0500
Date: Mon, 3 Nov 2008 15:04:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, srostedt@redhat.com
Subject: Re: next-20081103: error: asm/ftrace.h: No such file or directory
Message-ID: <20081103140442.GC14472@elte.hu>
References: <20081103183214.aac32543.sfr@canb.auug.org.au> <20081103135814.GB3432@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103135814.GB3432@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Alpha is busted:
> 
>   CC      init/main.o
> In file included from include/linux/interrupt.h:12,
>                  from include/linux/rtc.h:102,
>                  from include/linux/efi.h:19,
>                  from init/main.c:45:
> include/linux/hardirq.h:8:24: error: asm/ftrace.h: No such file or directory

should be solved in the latest ftrace tree.

	Ingo
