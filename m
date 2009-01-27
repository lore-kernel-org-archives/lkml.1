Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZA0NN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZA0NN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZA0NNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:13:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38470 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZA0NNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:13:50 -0500
Date: Tue, 27 Jan 2009 14:13:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090127131317.GF23121@elte.hu>
References: <20090115183942.GA6325@elte.hu> <200901201328.24605.rusty@rustcorp.com.au> <49756E6E.2060409@kernel.org> <200901271213.18605.rusty@rustcorp.com.au> <497E705B.5000302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E705B.5000302@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Tejun Heo <tj@kernel.org> wrote:

> > Tejun, any chance of you updating the tj-percpu tree? My current 
> > patches are against Linus's tree, and rebasing them on yours involves 
> > some icky merging.
> 
> If Ingo is okay with it, I'm fine with it too.  Unless Ingo objects, 
> I'll do it tomorrow-ish (still big holiday here).

Sure - but please do it as a clean rebase ontop of latest, not as a 
conflict-merge, as i'd expect there to be quite many clashes.

	Ingo
