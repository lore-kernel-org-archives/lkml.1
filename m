Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYDKHsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYDKHsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYDKHsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:48:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52534 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbYDKHsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:48:16 -0400
Date: Fri, 11 Apr 2008 09:48:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       linux-arch <linux-arch@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] kernel: Move arches to use common unaligned access
Message-ID: <20080411074802.GC6410@elte.hu>
References: <1207885132.22001.85.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207885132.22001.85.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> diff --git a/include/asm-x86/unaligned.h b/include/asm-x86/unaligned.h
> index 913598d..7ba2e1a 100644
> --- a/include/asm-x86/unaligned.h
> +++ b/include/asm-x86/unaligned.h

nice work - the x86 bits and the general concept:

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
