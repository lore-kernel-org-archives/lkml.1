Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYCULnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYCULnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYCULnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:43:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42098 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYCULnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:43:01 -0400
Date: Fri, 21 Mar 2008 12:42:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>
Subject: Re: pm_register() and pm_send_all()
Message-ID: <20080321114203.GJ20420@elte.hu>
References: <20080312150042.96668bcd.akpm@linux-foundation.org> <20080313092813.GA24027@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313092813.GA24027@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> --- a/arch/x86/kernel/apm_32.c
> +++ b/arch/x86/kernel/apm_32.c

thanks Pavel for taking care of this - the x86 bits look good. Those 
warnings have annoyed me for ages :-/

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
