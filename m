Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYGZNiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYGZNiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYGZNh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:37:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49038 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYGZNh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:37:57 -0400
Date: Sat, 26 Jul 2008 15:37:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86: AMD microcode patch loading support
Message-ID: <20080726133737.GA4401@elte.hu>
References: <20080725161723.636932280@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725161723.636932280@amd.com>
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


* Peter Oruba <peter.oruba@amd.com> wrote:

> This patch set introduces microcode patch loading support for AMD 
> processors. It includes refactoring of existing code to allow code 
> sharing. Vendor specific code has been split off, leading to a 
> multi-module solution as compared to the current single-module 
> approach.

patch #4 does not apply anymore to latest -git:

 patching file arch/x86/kernel/microcode.c
 Hunk #2 FAILED at 143.
 Hunk #3 FAILED at 229.
 Hunk #4 FAILED at 248.
 3 out of 4 hunks FAILED -- rejects in file arch/x86/kernel/microcode.c

could you please resend?

Thanks,

	Ingo
