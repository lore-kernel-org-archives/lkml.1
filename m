Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYDGVZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYDGVZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYDGVY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:24:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbYDGVY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:24:58 -0400
Date: Mon, 7 Apr 2008 23:24:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
Message-ID: <20080407212434.GA27940@elte.hu>
References: <200804071459.35628.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804071459.35628.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10410
> Subject		: "x86: tsc prevent time going backwards" broke suspend
> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> Date		: 2008-04-07 02:08 (1 days old)

that's now reverted via 5b13d863573e746739ccfc24ac1a9473cfee8df1.

	Ingo
