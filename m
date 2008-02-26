Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbYBZI3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbYBZI3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbYBZI3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:29:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYBZI33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:29:29 -0500
Date: Tue, 26 Feb 2008 09:29:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: stephane eranian <eranian@googlemail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       ia64 <linux-ia64@vger.kernel.org>
Subject: Re: 2.6.24 new perfmon kernel code base + libpfm + pfmon finally
	available!
Message-ID: <20080226082916.GA9857@elte.hu>
References: <7c86c4470802250900g1eea7a26m1900c4d8ed621dfd@mail.gmail.com> <84144f020802251113m2cede5bbx9044ec1fc6d11f0c@mail.gmail.com> <7c86c4470802251500mafec0dl535591971258de69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470802251500mafec0dl535591971258de69@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> I have done that in the past. I will do this again. But if you look at 
> the patch as it is released, you will see that it is very large. Not 
> that easy to split for LKML review.

If you want a feature merged upstream it is in your basic interest to 
keep it in a tidy, cleanly split up series of patches, with no 
development history in the patches - and frequently post those patches 
to lkml. (it also makes sense tocount the number of times you've posted 
them and make that visible in the postings: so the first series should 
be titled "perform2, v1", the second one "perfmon2, v2" - that way when 
people see "perform2, v25" they'll get a rough picture of the maturity 
of the patchset)

	Ingo
