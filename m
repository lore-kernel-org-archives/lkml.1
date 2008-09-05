Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYIEIDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYIEIDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYIEIDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:03:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbYIEIDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:03:09 -0400
Date: Fri, 5 Sep 2008 10:02:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 1/3] x86: io-apic - use ARRAY_SIZE macro
Message-ID: <20080905080251.GA12409@elte.hu>
References: <20080904183748.950151853@gmail.com>> <48c02b69.0405560a.6570.7100@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c02b69.0405560a.6570.7100@mx.google.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Make the code width a bit shorter with ARRAY_SIZE macro.

applied to tip/irq/sparseirq (which is hosting the IO-APIC unification 
series) - thanks Cyrill.

	Ingo
