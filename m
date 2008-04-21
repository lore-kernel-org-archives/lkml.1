Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbYDUPqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbYDUPqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYDUPq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:46:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbYDUPq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:46:27 -0400
Date: Mon, 21 Apr 2008 17:46:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
Message-ID: <20080421154615.GH18452@elte.hu>
References: <Pine.SGI.3.96.1080415153530.8706317k-100000@fergus.americas.sgi.com> <Pine.SGI.3.96.1080416151620.8706317m-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080416151620.8706317m-100000@fergus.americas.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3303]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Mayer <ajm@sgi.com> wrote:

> Subject: [PATCH] x86_64: Fix build error from FIRST_SYSTEM_VECTOR 
> patch
> 
> From: Alan Mayer <ajm@sgi.com>
> 
> Fixes the build error introduced by my FIRST_SYSTEM_VECTOR patch

thanks, applied.

	Ingo
