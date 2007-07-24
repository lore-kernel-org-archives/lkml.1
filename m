Return-Path: <linux-kernel-owner+w=401wt.eu-S1762597AbXGXM2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597AbXGXM2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbXGXM2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:28:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbXGXM2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:28:02 -0400
Date: Tue, 24 Jul 2007 14:27:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.23-rc1-rt0
Message-ID: <20070724122758.GB21709@elte.hu>
References: <20070724120436.GA14466@elte.hu> <p73644aszxv.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73644aszxv.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> This patch is needed to build on x86-64 with only the tracing options, 
> but no preempt enabled.

thanks, applied.

	Ingo
