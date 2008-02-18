Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYBRJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYBRJu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYBRJuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:50:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43479 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYBRJuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:50:18 -0500
Date: Mon, 18 Feb 2008 10:49:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tilman Schmidt <tilman@imap.cc>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-ID: <20080218094939.GB31970@elte.hu>
References: <200802172304.00322.rjw@sisk.pl> <47B9473D.20508@gmail.com> <b6fcc0a0802180143u65120b97wa87d59eb17f37ed2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0802180143u65120b97wa87d59eb17f37ed2@mail.gmail.com>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Why on earth do we have CONFIG_SYSFS_DEPRECATED at all if the only 
> sane choice for someone who tests new kernels is to always turn it on?

seconded ...

it's insane how inconvenient certain storage systems are to use, and 
people get turned away with NOATBUG. ITISABUG every time user-space 
breaks or the user has to do _anything_ to get the box working as it 
should.

	Ingo
