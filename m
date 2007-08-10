Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbXHJVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbXHJVgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXHJVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:36:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55044 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbXHJVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:36:37 -0400
Date: Fri, 10 Aug 2007 23:36:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Willy Tarreau <w@1wt.eu>, Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070810213630.GA13910@elte.hu>
References: <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home> <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu> <Pine.LNX.4.64.0708102235320.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708102235320.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Well, I've sent him the stuff now...

received it - thanks alot, looking at it!

> It's not like I haven't given him anything, he already has the test 
> programs, he already knows the system configuration.

one more small thing: could you please send your exact .config (Mike 
asked for that too, and i too on two prior occasions). Sometimes 
unexpected little details in the .config make a difference, we are not 
asking you that because we are second-guessing you in any way, the 
reason is simple: i frequently boot _the very .config that others use_, 
and see surprising reproducability of bugs that i couldnt trigger 
before. It's standard procedure to just pick up the .config of others to 
eliminate a whole bunch of degrees of freedom for a bug to hide behind - 
and your "it's a pretty standard config" description doesnt really 
achieve that. It probably wont make a real difference, but it's really 
easy for you to send and it's still very useful when one tries to 
eliminate possibilities and when one wants to concentrate on the 
remaining possibilities alone. Thanks again,

	Ingo
