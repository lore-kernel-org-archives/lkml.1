Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbXLWNA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbXLWNA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 08:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXLWNAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 08:00:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXLWNAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 08:00:48 -0500
Date: Sun, 23 Dec 2007 14:00:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071223130029.GA6815@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712231335.58939.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712231335.58939.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Well it doesn't build on x86-64 for me:
> 
>   CHK     include/linux/compile.h
>   CC      arch/x86/ia32/../../../fs/compat_binfmt_elf.o
> Assembler messages:
> Fatal error: can't create arch/x86/ia32/../../../fs/.tmp_compat_binfmt_elf.o: No such file or directory
> make[2]: *** [arch/x86/ia32/../../../fs/compat_binfmt_elf.o] Error 2
> 
> I will post the .config if anyone is interested.

yes, please send the .config.

	Ingo
