Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXLBQma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXLBQma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXLBQmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:42:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXLBQmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:42:22 -0500
Date: Sun, 2 Dec 2007 17:42:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: disable hpet legacy replacement for kdump
Message-ID: <20071202164204.GA4898@elte.hu>
References: <20071126193353.GA1676@elte.hu> <87sl2s4ran.fsf@duaron.myhome.or.jp> <8763zhrqwt.fsf_-_@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8763zhrqwt.fsf_-_@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> > This seems to introduced after 2.6.23, so if possible, I'd like to fix
> > before 2.6.24. What do you think the following?
> 
> The following patch fixes the kdump path. Please apply.

thanks, added.

	Ingo
