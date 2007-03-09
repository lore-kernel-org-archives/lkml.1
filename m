Return-Path: <linux-kernel-owner+w=401wt.eu-S1767626AbXCIXLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767626AbXCIXLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767629AbXCIXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:11:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767626AbXCIXLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:11:34 -0500
Date: Sat, 10 Mar 2007 00:10:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309231041.GA712@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309201257.GA5761@elte.hu> <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org> <20070309213607.GA16796@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309213607.GA16796@elte.hu>
User-Agent: Mutt/1.4.2.2i
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


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] If that is the case then my ABI worries would indeed be wrong 
> and i'd owe Zach a big fat apology [and more] for my flames ;-)

that apology i very much owe to Zach no matter what the outcome of the 
discussion. Zach, some of my mindless characterisations of the quality 
of VMI code (and of your intentions) were really out of bound and were 
unfair, and i'd like to apologize for that :-/

	Ingo
