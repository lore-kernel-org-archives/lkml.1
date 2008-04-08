Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYDHNlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYDHNlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYDHNlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:41:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYDHNlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:41:35 -0400
Date: Tue, 8 Apr 2008 15:41:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
	decompressor
Message-ID: <20080408134112.GA4277@elte.hu>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com> <20080408122007.GA11832@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408122007.GA11832@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Hi Ingo,
> 
> I see you have applied the following patch to x86#for-akpm. It was 
> really ment for testing only. I think you ment to use this one 
> instead?

yep, i wanted to see how it holds up in testing - it's OK so far. I've 
got your other, fuller one queued up meanwhile - it's not pushed out 
yet.

	Ingo
