Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZABSZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZABSZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbZABSZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:25:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZABSZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:25:41 -0500
Date: Fri, 2 Jan 2009 19:25:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86: mpparse.c fix style problems
Message-ID: <20090102182523.GE10072@elte.hu>
References: <1230920005.8976.7.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230920005.8976.7.camel@jaswinder.satnam>
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

> 
> Impact: cleanup, fix style problems, more readable
> 
> Fixes style problems:
> WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
> WARNING: Use #include <linux/acpi.h> instead of <asm/acpi.h>
> WARNING: suspect code indent for conditional statements (8, 17)
> WARNING: space prohibited between function name and open parenthesis '('
> 
> total: 0 errors, 5 warnings
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/mpparse.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

applied	to tip/x86/cleanups, thanks,

	Ingo
