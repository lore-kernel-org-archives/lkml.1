Return-Path: <linux-kernel-owner+w=401wt.eu-S1761079AbXKAO7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761079AbXKAO7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXKAO7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:59:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41859 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXKAO7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:59:39 -0400
Date: Thu, 1 Nov 2007 15:59:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] kvm: fix !SMP build error
Message-ID: <20071101145916.GA4044@elte.hu>
References: <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org> <471F03F5.7090608@qumranet.com> <20071024123258.GA28653@elte.hu> <20071024123650.GA31562@elte.hu> <20071024181107.GA15250@elte.hu> <20071031203442.7e161692.rdunlap@xenotime.net> <20071101083139.GB8459@elte.hu> <4729D051.5040508@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4729D051.5040508@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0106]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> I thought you were handling it, as they aren't part of kvm proper.  
> But I can send them, sure.

i've got them in my queue already so i'll send them in the next 
scheduler batch, ok?

	Ingo
