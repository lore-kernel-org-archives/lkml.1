Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYDQJGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYDQJGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYDQJGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:06:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYDQJGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:06:39 -0400
Date: Thu, 17 Apr 2008 11:06:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417090626.GA14383@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org> <20080417083000.GA4935@elte.hu> <20080417014054.ea788f1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417014054.ea788f1f.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> By keeping all this code out of -mm you haven't solved any of the 
> merge/integration problems which we had in 2.6.24-rcX.  They're all 
> still there.  All you did was to push them out of the two-month 
> integrate-and-test period and put them into the 2.6.25 merge window 
> instead.

... hm, i think there's really no problem here at all: most of the merge 
problems you cited were due to clearly out-of-tree patches that sit in 
x86.git/testing for the convenience of our testers and contributors, 
that we have no intention to push upstream.

(Again, sorry about the terse shortlog which might have contributed to 
this misunderstanding, that's all i could do yesterday evening.)

	Ingo
