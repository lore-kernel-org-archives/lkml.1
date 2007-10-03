Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXJCJYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXJCJYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbXJCJYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:24:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbXJCJYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:24:45 -0400
Date: Wed, 3 Oct 2007 11:23:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Benc <jbenc@suse.cz>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
	2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003092357.GA17841@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu> <20071003085022.GA6672@elte.hu> <20071003091257.GA15815@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003091257.GA15815@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> -CONFIG_MAC80211_DEBUGFS=y

it's CONFIG_MAC80211_DEBUGFS=y causing the crash.

	Ingo
