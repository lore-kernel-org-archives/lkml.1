Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYF0Kyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYF0Kyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYF0Kym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:54:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbYF0Kyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:54:41 -0400
Date: Fri, 27 Jun 2008 12:53:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Michael Buesch <mb@bu3sch.de>, Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
Message-ID: <20080627105329.GA11218@elte.hu>
References: <1213739834.3803.137.camel@johannes.berg> <20080620155541.GC6656@elte.hu> <200806201801.09858.mb@bu3sch.de> <200806201818.34904.mb@bu3sch.de> <20080623084123.GA32688@elte.hu> <48647B94.5000006@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48647B94.5000006@pobox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jgarzik@pobox.com> wrote:

> applied

track record of 4 days of testing: the warning indeed went away and no 
other funnies in this area happened on that box. Thanks,

	Ingo
