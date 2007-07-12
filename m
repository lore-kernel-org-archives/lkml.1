Return-Path: <linux-kernel-owner+w=401wt.eu-S1765352AbXGLQCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765352AbXGLQCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXGLQBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:01:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbXGLQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:01:47 -0400
Date: Thu, 12 Jul 2007 18:01:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Gerdau <mgd@technosis.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt1
Message-ID: <20070712160139.GB8252@elte.hu>
References: <20070712121355.GA10949@elte.hu> <200707121645.46206.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707121645.46206.mgd@technosis.de>
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


* Michael Gerdau <mgd@technosis.de> wrote:

> [sorry Ingo for the dublicated post]

[ sorry for the duplicated reply :) ]

> > to build a 2.6.22.1-rt1 tree, the following patches should be applied:
> >  
> >    http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
> >    http://redhat.com/~mingo/realtime-preempt/patch-2.6.22.1-rt1
> 
> I get a compile error on my x86_64 dualcore sytem.

could you check it builds fine with -rt2?

	Ingo
