Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYCUOpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYCUOpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYCUOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:45:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59808 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbYCUOpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:45:35 -0400
Date: Fri, 21 Mar 2008 15:45:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080321144517.GA1545@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <200803111507.20870.nickpiggin@yahoo.com.au> <e2e108260803210552i4cdef6a5qf8f5076eaac2cf03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260803210552i4cdef6a5qf8f5076eaac2cf03@mail.gmail.com>
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


* Bart Van Assche <bart.vanassche@gmail.com> wrote:

> Is anyone currently working on this 
> (http://bugzilla.kernel.org/show_bug.cgi?id=9991) ? I think this 
> should either be fixed or documented as a known issue.

it should be fixed in latest -git (by commit 985a34bd75cc8c9) - can you 
still see it?

	Ingo
