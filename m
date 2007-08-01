Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbXHAHMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbXHAHMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXHAHMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:12:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbXHAHMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:12:39 -0400
Date: Wed, 1 Aug 2007 09:12:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801071230.GA16375@elte.hu>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Roman,

Thanks for the testing and the feedback, it's much appreciated! :-) On
what platform did you do your tests, and what .config did you use (and
could you please send me your .config)?

Please also send me the output of this script:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

(if the output is too large send it to me privately, or bzip2 -9 it.)

Could you also please send the source code for the "l.c" and "lt.c" apps
you used for your testing so i can have a look. Thanks!

	Ingo
