Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYFJKeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYFJKeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYFJKdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:33:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYFJKdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:33:52 -0400
Date: Tue, 10 Jun 2008 12:33:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] fix build bug in "x86: add PCI extended config space
	access for AMD Barcelona" (try #3)
Message-ID: <20080610103337.GH19136@elte.hu>
References: <alpine.LFD.1.10.0806052239110.3235@apollo.tec.linutronix.de> <20080606104814.484CF806B@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606104814.484CF806B@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Much more less code now.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

applied to tip/x86/cpu - thanks Robert.

	Ingo
