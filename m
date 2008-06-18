Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYFRNBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYFRNBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYFRNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:01:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYFRNBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:01:13 -0400
Date: Wed, 18 Jun 2008 15:00:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: coding style fixes to
	arch/x86/kernel/cpu/mcheck/p4.c
Message-ID: <20080618130059.GB29202@elte.hu>
References: <20080614140619.3666c4f4@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614140619.3666c4f4@paolo-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Before:
> total: 16 errors, 34 warnings, 257 lines checked
> 
> After:
> total: 0 errors, 2 warnings, 257 lines checked

applied to tip/x86/cleanups, thanks Paolo.

	Ingo
