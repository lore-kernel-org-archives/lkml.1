Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYDRMfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYDRMfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYDRMfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:35:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbYDRMfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:35:14 -0400
Date: Fri, 18 Apr 2008 14:35:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: simplify hex print
Message-ID: <20080418123502.GB17013@elte.hu>
References: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> simplify hex to ascii conversion with a lookup table.

thanks Thomas, applied.

	Ingo
