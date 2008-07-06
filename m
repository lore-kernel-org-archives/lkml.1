Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbYGFXza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbYGFXza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 19:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbYGFXzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 19:55:22 -0400
Received: from saeurebad.de ([85.214.36.134]:33974 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbYGFXzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 19:55:21 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	<200807062002.46863.rjw@sisk.pl>
	<20080706182648.GE21669@cs181140183.pp.htv.fi>
	<200807062304.07443.rjw@sisk.pl>
	<20080706213214.GH21669@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0807061443420.3016@woody.linux-foundation.org>
	<20080706221932.GJ21669@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0807061524510.3016@woody.linux-foundation.org>
	<20080706230610.GK21669@cs181140183.pp.htv.fi>
Date: Mon, 07 Jul 2008 01:55:15 +0200
In-Reply-To: <20080706230610.GK21669@cs181140183.pp.htv.fi> (Adrian Bunk's
	message of "Mon, 7 Jul 2008 02:06:10 +0300")
Message-ID: <87skumr2jg.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adrian Bunk <bunk@kernel.org> writes:

> On Sun, Jul 06, 2008 at 03:27:30PM -0700, Linus Torvalds wrote:
>> 
>> 
>> On Mon, 7 Jul 2008, Adrian Bunk wrote:
>> >
>> > When did you tell me that maintainers should not or cannot be Cc'ed on 
>> > regression reports?
>> 
>> That is not what I'm complaining about.
>
> That is what I wrote in the part of my email you made this comment on.
>
>> I'm complaining about the fact that you *always* argue against closing 
>> bugreports.
>
> I'm not always against closing bugs, and e.g. during the last years I've
> closed at about 500 bugs in the kernel Bugzilla due to submitters having
> vanished.
>
>> You have argued against it for over a YEAR now. And every single time I 
>> tell you that you are wrong, and exactly *why* you are wrong.
>> 
>> If a reporter doesn't respond to say "it's still open", it needs to be 
>> closed. It doesn't matter one whit whether there has been developer action 
>> on it or not. We cannot keep old reports open - it's a total waste for 
>> developers to even _look_ at anything that is more than roughly a month 
>> old and hasn't been verified to be still be an issue.
>
> We only differ on whether a human should ask this question once before 
> closing a bug or whether regular automated requests are enough.

I prefer being bugged regularly as a reporter.  At the moment I have a
bug at a machine I do not use every day and if I get this email, it
reminds me to test the latest kernel on that machine (or try to
reproduce the bug if it happens in situations not common in my usual
workflow).  Then I report back.

If these remainders weren't, it would be possible that I forget about a
bug and come back to it when it's a real pain to hunt it down by
change-history or when a possible cause for the bug has left the
developers mind a long time ago.

	Hannes
