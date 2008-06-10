Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYFJKZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYFJKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYFJKZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:25:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46378 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYFJKZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:25:14 -0400
Date: Tue, 10 Jun 2008 12:24:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -next] x86: fix longstanding setup.c printk format
	warning
Message-ID: <20080610102452.GD19136@elte.hu>
References: <Pine.LNX.4.64.0806051107200.702@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806051107200.702@shark.he.net>
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


* Randy.Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Note: for -next only, not mainline.
> 
> Fix setup.c printk format warning:
> 
> linux-next-20080605/arch/x86/kernel/setup.c: In function 'setup_per_cpu_areas':
> linux-next-20080605/arch/x86/kernel/setup.c:173: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ssize_t'

applied to tip/x86/numa - thanks Randy.

	Ingo
