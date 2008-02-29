Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbYB2ShK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbYB2ShK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYB2Sg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:36:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbYB2Sg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:36:57 -0500
Date: Fri, 29 Feb 2008 19:36:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: ray-lk@madrabbit.org, linux-kernel@vger.kernel.org
Subject: Re: Interactivity issue in 2.6.25-rc3
Message-ID: <20080229183639.GC8258@elte.hu>
References: <20080228184407.GA7117@localhost.ift.unesp.br> <20080228191824.GA20019@elte.hu> <2c0942db0802281154y3176e847g8b9a4091df5cc8af@mail.gmail.com> <20080228210627.GA4337@localhost.ift.unesp.br> <20080229160408.GG27248@elte.hu> <20080229171442.GA5173@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229171442.GA5173@localhost.ift.unesp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carlos R. Mafra <crmafra2@gmail.com> wrote:

> > and obviously, even if you only 'feel' long delays that's too an 
> > anomaly by definition, no matter what the scripts say about it. It 
> > might even be a scheduler anomaly as well: for example if the 
> > scheduler clock has an anomaly - on which the delay statistics are 
> > based too.
> 
> But if the scripts say all 'se.wait_max' are < 40 msecs than it is not 
> CFS' fault, right? Even if it takes 3 seconds for a typed letter to 
> appear in the terminal?

yeah, in 99.9% of the cases it's not the scheduler's fault.

	Ingo
