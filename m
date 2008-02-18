Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYBRNto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYBRNto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYBRNtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:49:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYBRNte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:49:34 -0500
Date: Mon, 18 Feb 2008 14:49:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tilman Schmidt <tilman@imap.cc>, Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-ID: <20080218134908.GB28851@elte.hu>
References: <200802172304.00322.rjw@sisk.pl> <20080218094939.GB31970@elte.hu> <47B956EE.7020804@gmail.com> <200802181235.31503.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802181235.31503.rjw@sisk.pl>
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

> Well, my definition of a regression from 2.6.24 is that it happens 
> when someone takes a .config that worked with 2.6.24, configures the 
> kernel with that, leaving the defaults for the options he is _asked_ 
> _for_, and the resulting kernel doesn't work as expected.

yep, and that's how users determine whether "the new kernel works", so 
it's what we follow as well.

	Ingo
