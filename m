Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYIXHbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYIXHbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYIXHbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:31:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYIXHbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:31:06 -0400
Date: Wed, 24 Sep 2008 09:30:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix build error introduced by commit
	4faac97d44ac27bdbb010a9c3597401a8f89341f
Message-ID: <20080924073052.GA3655@elte.hu>
References: <48D9A882.4080804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9A882.4080804@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marc Dionne <marc.c.dionne@gmail.com> wrote:

> process_32.c needs to include idle.h to get the prototype for  
> c1e_remove_cpu()

applied to tip/timers/urgent, thanks Marc!

	Ingo
