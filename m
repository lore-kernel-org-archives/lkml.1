Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYBDT7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYBDT7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYBDT6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:58:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53022 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbYBDT6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:58:52 -0500
Date: Mon, 4 Feb 2008 20:58:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       hpa@zytor.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-ID: <20080204195831.GA21986@elte.hu>
References: <20080131201430.GA9375@cs181133002.pp.htv.fi> <20080131130529.b0e17815.akpm@linux-foundation.org> <20080202213628.GJ9375@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202213628.GJ9375@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> Sorry Andrew.
> 
> I misunderstood the patch flow.
> 
> And much more important, the tone of my email was not appropriate.
> 
> Due to unrelated reasons I was Thursday evening in a mood in which I 
> should not have left emails out of my postponed folder without 
> sleeping a night over them.
> 
> I hope you accept my apology.

i'd like to apologize to you too Adrian - i should have been (a lot) 
more patient as well - the merge window is not for the faint hearted i 
guess :-/

	Ingo
