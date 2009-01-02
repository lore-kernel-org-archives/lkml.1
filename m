Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbZABQrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbZABQrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZABQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:47:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705AbZABQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:47:14 -0500
Date: Fri, 2 Jan 2009 17:47:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: ldt.c fix style problems
Message-ID: <20090102164706.GB6759@elte.hu>
References: <1230721940.3738.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230721940.3738.5.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, fix style problems
> 
> Fixes style problems:
> WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> ERROR: space required before the open parenthesis '('
> 
> total: 1 errors, 1 warnings
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/ldt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied	to tip/x86/cleanups, thanks,

	Ingo
