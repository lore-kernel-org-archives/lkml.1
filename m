Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZLJHmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZLJHmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760504AbZLJHmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:42:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760480AbZLJHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:42:08 -0500
Date: Thu, 10 Dec 2009 08:41:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091210074158.GI16874@elte.hu>
References: <1259588232.20516.307.camel@laptop>
 <20091130150314.GA10331@redhat.com>
 <20091130151650.GA24316@elte.hu>
 <20091130152910.GB10331@redhat.com>
 <20091201161132.GA24897@elte.hu>
 <20091201170002.GD10331@redhat.com>
 <20091201170954.GA4699@elte.hu>
 <20091201174534.GE10331@redhat.com>
 <20091201211518.GA32376@elte.hu>
 <20091208215829.GA19793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208215829.GA19793@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> > [...]
> >
> > If the in-kernel gdb stub replaced kgdb functionally you'd hear no 
> > complaints from me.
> 
> Let's leave it as an idea for the future.

We came a full circle - that's the argument. We say overlap, duplication 
and incomplete implementation in this area is a problem. Since the speed 
of development in this area is truly glacial at the moment and the 
practical advantages that i can experience personally (directly as a 
Linux user and indirectly as a maintainer) are miniscule so far, caution 
is warranted IMO. You say there is no problem. We'll have to agree to 
disagree i guess.

	Ingo
