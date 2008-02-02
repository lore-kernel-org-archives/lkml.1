Return-Path: <linux-kernel-owner+w=401wt.eu-S933765AbYBBTjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbYBBTjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbYBBTi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:38:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758516AbYBBTi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:38:58 -0500
Date: Sat, 2 Feb 2008 20:38:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080202193843.GB32039@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <200802020931.38689.david-b@pacbell.net> <20080202180002.GB26560@elte.hu> <200802021113.22130.david-b@pacbell.net> <20080202193202.GB31621@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202193202.GB31621@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> > It would have been easier to just use the public interface and 
> > hard-wire "rtc0".  But going directly to the hardware was dirtier, 
> > and more in the spirit of "hack that obviously shouldn't go upstream 
> > until it gets done properly".
> 
> Yes, it was "quick and dirty". And I do not think it is going upstream 
> in this form...?

which would be a pity - this thing _almost_ started doing suspend and 
resume cycles on my testsystems, all by itself :-)

	Ingo
