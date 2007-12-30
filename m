Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXL3PLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXL3PLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXL3PLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:11:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33284 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbXL3PLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:11:42 -0500
Date: Sun, 30 Dec 2007 16:07:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH corrected again] x86: unify
	arch/x86/boot/compressed/Makefile(s)
Message-ID: <20071230150747.GV16946@elte.hu>
References: <20071230132608.GA13857@uranus.ravnborg.org> <20071230133648.GA13945@uranus.ravnborg.org> <20071230134251.GA13990@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230134251.GA13990@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Last patch contained some additional changes to lib/*.
> Lets see if I can do this correct in third attempt...
> Time for coffee to minimize further stupidity.

thanks, applied to x86.git.

	Ingo
