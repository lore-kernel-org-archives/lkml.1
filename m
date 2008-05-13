Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYEMJ5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYEMJ5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYEMJ5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:57:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40132 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbYEMJ5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:57:43 -0400
Date: Tue, 13 May 2008 11:57:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] x86: complete move ACPI from mpparse.c
Message-ID: <20080513095733.GC24037@elte.hu>
References: <20080512152434.27570.7396.stgit@thinkpad> <20080512152441.27570.68694.stgit@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512152441.27570.68694.stgit@thinkpad>
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


* Alexey Starikovskiy <astarikovskiy@suse.de> wrote:

> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c

> -#ifdef CONFIG_ACPI
[ ...]
> -#endif /* CONFIG_ACPI */

applied, thanks Alexey. Nice cleanup.

	Ingo
