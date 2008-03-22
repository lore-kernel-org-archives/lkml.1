Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYCVLQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYCVLQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 07:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYCVLQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 07:16:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYCVLQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 07:16:16 -0400
Date: Sat, 22 Mar 2008 12:15:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Message-ID: <20080322111535.GC13264@elte.hu>
References: <200803220259.48534.rjw@sisk.pl> <20080321223315.3e0e042f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321223315.3e0e042f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0265]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > ...
> > 
> > Date		: 2007-11-19 14:43 (124 days old)

btw., this one appears to be an accounting artifact: two regressions 
with similar (same?) symptoms in the same bugzilla. The first regression 
was resolved after 7 days, the second was reopened 10 days ago. (It 
could easily be about the same underlying (hw?) problem, but the 
regression window for users was very small.)

	Ingo
