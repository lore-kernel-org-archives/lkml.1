Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbXFEIBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbXFEIBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXFEIBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:01:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37093 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXFEIBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:01:37 -0400
Date: Tue, 5 Jun 2007 10:01:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Yu <raise.sail@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070605080130.GA4301@elte.hu>
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu> <465E992C.4020601@gmail.com> <20070531095337.GA8104@elte.hu> <465FC7E7.7080804@gmail.com> <20070601192142.GA10039@elte.hu> <4664CB6D.8060507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4664CB6D.8060507@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Yu <raise.sail@gmail.com> wrote:

> Eh, I wrong again~ I even took an experiment in last week end, this 
> idea is really bad! ;(
> 
> I think the most inner of source of my wrong again and again is 
> misunderstanding virtual time. For more better understanding this, I 
> try to write one python script to simulate CFS behavior. However, It 
> can not implement the fairness as I want. I really confuse here.
> 
> Would you like help me point out what's wrong in it? Any suggestion is 
> welcome. Thanks in advanced.

sorry, my python-fu is really, really weak. All i can give you at the 
moment is the in-kernel implementation of CFS :-)

	Ingo
