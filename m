Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXCZJZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXCZJZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXCZJZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:25:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXCZJZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:25:18 -0400
Date: Mon, 26 Mar 2007 11:25:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] clockevents: remove bad designed sysfs support for now
Message-ID: <20070326092503.GA27109@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <1174900868.4182.21.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174900868.4182.21.camel@chaos>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The current sysfs support of clockevents does not obey the "only one 
> value per file" rule.
> 
> The real fix is not 2.6.21 material. Therefor remove the sysfs support 
> for now.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
