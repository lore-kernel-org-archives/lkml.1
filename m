Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207Ab0A3HgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab0A3HgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 02:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888Ab0A3Hf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 02:35:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0A3Hf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 02:35:58 -0500
Date: Sat, 30 Jan 2010 08:34:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@redhat.com>, eranian@google.com, fweisbec@gmail.com,
       paulus@samba.org, davem@davemloft.net, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 07/10] bitops: Provide compile time HWEIGHT{8,16,32,64}
Message-ID: <20100130073414.GB30472@elte.hu>
References: <20100122155044.391857484@chello.nl>
 <20100122155535.797688466@chello.nl>
 <520f0cf11001290232p38140fb2sa5da1b7f8e2704cc@mail.gmail.com>
 <1264763149.4283.2215.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264763149.4283.2215.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-01-29 at 11:32 +0100, John Kacur wrote:
> > 
> > I like it. Maybe provide a comment that this provides the Hamming weight, 
> > it took me a second to realize what this was.
> 
> its called _H_weight for crying out loud.

I always forget such abbreviations :-/

I think when a single kernel hacker requests a clarifying comment that's 
reason enough to add it. After all he broke through a barrier of laziness to 
write that email ;-)

	Ingo
