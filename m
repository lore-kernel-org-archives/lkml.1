Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYHOODd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYHOODd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758909AbYHOODW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:03:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbYHOODV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:03:21 -0400
Date: Fri, 15 Aug 2008 16:03:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86 (v2)
Message-ID: <20080815140300.GC14103@elte.hu>
References: <489A1844.3090502@am.sony.com> <20080811191012.GA16553@elte.hu> <48A091B7.6050601@zytor.com> <48A1EA04.7090102@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A1EA04.7090102@am.sony.com>
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


* Tim Bird <tim.bird@am.sony.com> wrote:

> Allow x86 to support a built-in kernel command line.  The built-in 
> command line can override the one provided by the boot loader, for 
> those cases where the boot loader is broken or it is difficult to 
> change the command line in the the boot loader.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>

applied to tip/x86/commandline for v2.6.28 merging - thanks Tim!

	Ingo
