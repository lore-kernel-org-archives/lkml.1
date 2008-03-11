Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYCKMcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYCKMcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYCKMcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:32:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYCKMcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:32:05 -0400
Date: Tue, 11 Mar 2008 13:31:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86: coding style fixes to
	arch/x86/kernel/setup_32.c
Message-ID: <20080311123150.GB10343@elte.hu>
References: <20080307192459.52c0a330@paolo-desktop> <4d8e3fd30803110503n28692bcbt3f0ef3b94f4a3805@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30803110503n28692bcbt3f0ef3b94f4a3805@mail.gmail.com>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> On 3/7/08, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> > Compile tested, patch #2 depends on #1
> >
> > Paolo Ciarrocchi (2):
> > x86: coding style fixes to arch/x86/kernel/setup_32.c
> > x86: coding style fixes to arch/x86/kernel/setup_32.c
> >
> > arch/x86/kernel/setup_32.c | 9 ++++-----
> > 1 files changed, 4 insertions(+), 5 deletions(-)
> 
> hi Ingo, all,
> i think i didn't get any feedback, do you want me to submit again?

should all be in latest x86.git. Did i miss any of them? [i only picked 
up one because the other was already handled iirc]

	Ingo
