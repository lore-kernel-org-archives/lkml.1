Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYC1JRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYC1JRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYC1JRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:17:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbYC1JRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:17:12 -0400
Date: Fri, 28 Mar 2008 10:16:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
Message-ID: <20080328091645.GI21413@elte.hu>
References: <20080327160700.GB828@suse.de> <47EC8793.2040508@rtr.ca> <47EC8AC3.7080002@rtr.ca> <200803272358.20081.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803272358.20081.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> On Thursday 27 March 2008, Mark Lord wrote:
> > Could somebody please fix the RTC mess in kconfig now ?
> 
> My version has been sitting in MM for a while now.
> I'll forward it to you off-list, in case you want
> to verify that it resolves that specific issue.

could you please provide an URL or the patch itself so that others who 
hit this issue and read this thread can apply the fix?

	Ingo
