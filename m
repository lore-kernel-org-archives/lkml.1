Return-Path: <linux-kernel-owner+w=401wt.eu-S1762828AbXKTWEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828AbXKTWEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbXKTWD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:03:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbXKTWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:03:55 -0500
Date: Tue, 20 Nov 2007 23:03:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (2.6.24-rc3 -mm only) Smack Version 11c Simplified
	Mandatory Access Control Kernel
Message-ID: <20071120220326.GG24156@elte.hu>
References: <20071120132902.244057eb.akpm@linux-foundation.org> <22141.83890.qm@web36611.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22141.83890.qm@web36611.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Casey Schaufler <casey@schaufler-ca.com> wrote:

> > > I have verified this version against broken-out-2007-11-20-01-45 
> > > as well. Compiles, boots, and passes tests.
> > 
> > So is it time for me to wake up and start paying attention again?
> 
> Please? I've been very attentive, polling every few hours for updates 
> in -mm so that I can catch data structure changes early. If there are 
> any steps I can take to be helpful or to smooth the process (grease 
> the wheels?) let me know.

Andrew just asked whether he should merge your latest.

	Ingo
