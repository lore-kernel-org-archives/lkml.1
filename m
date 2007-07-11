Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXGKHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXGKHvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbXGKHvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:51:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbXGKHvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:51:09 -0400
Date: Wed, 11 Jul 2007 09:50:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ray Lee <ray-lk@madrabbit.org>, Matthew Hawkins <darthmdh@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: swap prefetch (Re: -mm merge plans for 2.6.23)
Message-ID: <20070711075053.GA20094@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <200707102015.44004.kernel@kolivas.org> <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com> <20070710181419.6d1b2f7e.akpm@linux-foundation.org> <b21f8390707101954s3ae69db8vc30287277941cb1f@mail.gmail.com> <4694683B.3060705@yahoo.com.au> <2c0942db0707102247n3b6e5933i9803a2161d6c00b1@mail.gmail.com> <469470A3.5040606@yahoo.com.au> <2c0942db0707102304s3f666eceib454043c716e2178@mail.gmail.com> <46947784.6050100@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46947784.6050100@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Regarding swap prefetching. I'm not going to argue for or against it 
> anymore because I have really stopped following where it is up to, for 
> now. If the code and the results meet the standard that Andrew wants 
> then I don't particularly mind if he merges it.

I have tested it and have read the code, and it looks fine to me. (i've 
reported my test results elsewhere already) We should include this in 
v2.6.23.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
