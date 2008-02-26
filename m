Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbYBZJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbYBZJbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYBZJbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:31:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbYBZJbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:31:01 -0500
Date: Tue, 26 Feb 2008 10:30:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB
Message-ID: <20080226093046.GK9857@elte.hu>
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <47C3053D.5060504@zytor.com> <1203968796.24935.1239027765@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203968796.24935.1239027765@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> > Either way, the code should be shared between 32 and 64 bits. There 
> > is nothing bitsize-specific about it!
> 
> Of course. That's also why I already added the old-Dell case ;). But 
> one problem at a time, please!

i've applied your patch to x86.git#testing. Feel free to send a 
code-unification patch too :-)

	Ingo
