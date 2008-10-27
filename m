Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYJ0LoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYJ0LoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYJ0LoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:44:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYJ0LoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:44:12 -0400
Date: Mon, 27 Oct 2008 12:43:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Pavel Machek <pavel@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator
	driver
Message-ID: <20081027114348.GC5631@elte.hu>
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4901BF30.3090708@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Also, this is only on a UV system, I'm not introducing any overhead 
> for any other x86_64 systems.

true, but it sets a bad example that others might follow - and it's 
not hard to fix anyway.

	Ingo
