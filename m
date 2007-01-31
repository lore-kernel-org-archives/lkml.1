Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbXAaMs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbXAaMs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933198AbXAaMs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:48:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199AbXAaMs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:48:57 -0500
Date: Wed, 31 Jan 2007 13:47:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       tglx@linutronix.de
Subject: Re: [PATCH 01/23] clocksource: drop clocksource-add-verification-watchdog-helper-fix.patch
Message-ID: <20070131124712.GA22145@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033759.798289135@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033759.798289135@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4497]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Drop.

i'm summarily replying to your 4 'Drop' patches: what you didnt explain 
is /why/ you dropped these patches. I.e. why you think they are bad and 
how you think your solution is better. Without doing such analysis you 
shouldnt just be dropping patches of others like this.

	Ingo
