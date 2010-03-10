Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0CJNd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:33:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab0CJNdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:33:25 -0500
Date: Wed, 10 Mar 2010 14:32:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       jiang@cs.ncsu.edu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
Message-ID: <20100310133240.GA9606@elte.hu>
References: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
 <tip-01ab31371da90a795b774d87edf2c21bb3a64dda@git.kernel.org>
 <20100222105457.GA31148@elte.hu>
 <20100222110106.GA7206@elte.hu>
 <4B82BCB0.9060903@zytor.com>
 <20100222172153.GA28638@elte.hu>
 <817ecb6f1003061144r3defbe0eg74e23e0986f8e42d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f1003061144r3defbe0eg74e23e0986f8e42d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> Any suggestions on how should I proceed forward in troubleshooting this issue?

Can you reproduce it in KVM?

If yes then that might give you a more debuggable state than a crashed native 
system.

	Ingo
