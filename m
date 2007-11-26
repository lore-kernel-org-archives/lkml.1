Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbXKZXEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbXKZXEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbXKZXEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:04:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbXKZXEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:04:13 -0500
Date: Tue, 27 Nov 2007 00:03:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: disable hpet legacy replacement for kexec
Message-ID: <20071126230357.GB9623@elte.hu>
References: <20071126193353.GA1676@elte.hu> <87sl2s4ran.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sl2s4ran.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1078]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> This seems to introduced after 2.6.23, so if possible, I'd like to fix 
> before 2.6.24. What do you think the following?

looks good to me - i've queued it up.

	Ingo
