Return-Path: <linux-kernel-owner+w=401wt.eu-S932793AbXGQRNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbXGQRNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbXGQRNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:13:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60459 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbXGQRNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:13:40 -0400
Date: Tue, 17 Jul 2007 19:13:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus <lists4me@web.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070717171303.GA8323@elte.hu>
References: <20070706173319.GA2356@elte.hu> <200707161959.17750.lists4me@web.de> <20070717073709.GA12465@elte.hu> <200707171506.37886.lists4me@web.de> <20070717170628.GA6002@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717170628.GA6002@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i think it fails here due to some IO error:
> 
>  9173 1184675906.674610 write(2, "konqueror: Fatal IO error: 
>  clien"..., 41) = 41 <0.000007>

oh, and i missed the obvious request: could you start konqueror from a 
terminal and see what it prints when it goes down?

	Ingo
