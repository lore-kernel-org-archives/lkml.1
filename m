Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYCUL2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYCUL2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYCUL2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:28:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbYCUL2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:28:37 -0400
Date: Fri, 21 Mar 2008 12:28:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] X86: Explicitly include required header files.
Message-ID: <20080321112820.GE20420@elte.hu>
References: <alpine.LFD.1.00.0803132143200.11821@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803132143200.11821@localhost.localdomain>
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


* Robert P. J. Day <rpjday@crashcourse.ca> wrote:

> After an experimental cleanup of <linux/percpu.h>, these files were 
> exposed as invoking kmalloc() without including <linux/slab.h>.

thanks, applied.

	Ingo
