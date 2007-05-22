Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbXEVI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbXEVI0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbXEVI0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:26:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbXEVI0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:26:06 -0400
Date: Tue, 22 May 2007 10:25:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt3
Message-ID: <20070522082550.GA8161@elte.hu>
References: <20070517194143.GA25394@elte.hu> <1179778266.15427.38.camel@imap.mvista.com> <1179779053.12708.45.camel@chaos> <1179779142.15427.44.camel@imap.mvista.com> <1179779765.12708.50.camel@chaos> <1179780072.15427.51.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179780072.15427.51.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> I copied the patch into the first email, I did look at it which is why 
> you got an email. Your introducing the patch , it's for you to explain 
> why it needs to be there.. considering that the comment says "hack" in 
> it, I have to wonder what the non-hack version is ..

you might not have realized it, but the problem i think was the attitude 
you showed in the very first sentence:

> Where did the arm ep93xx changes come from? It looks like patch below 
> came in with them in 2.6.21-rt6 ..

AFAICS Thomas just mirrored that snotty comment back to you, and yes, 
when you are on the receiving end it feels nasty, doesnt it? So please 
restart and rephrase that into a more polite form and you might get an 
answer (although i certainly do not talk for Thomas). Something like:

> Thomas, could you give me a bit more information about why the arm 
> ep93xx changes were done in 2.6.21-rt6? I do not seem to understand 
> the reason behind that change. I've attached the change below. Thanks!

You are asking Thomas a favor after all... Be a bit more polite when 
asking others, and a completely new world might open up for you :-)

	Ingo
