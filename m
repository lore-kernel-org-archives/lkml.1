Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbXJPKMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbXJPKMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbXJPKMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:12:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbXJPKMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:12:44 -0400
Date: Tue, 16 Oct 2007 12:12:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler updates for v2.6.24
Message-ID: <20071016101239.GA17927@elte.hu>
References: <20071015141723.GA29486@elte.hu> <47148CAC.8060603@mandriva.org> <20071016100848.GA17313@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016100848.GA17313@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Thomas Backlund <tmb@mandriva.org> wrote:
> 
> > How does this one compare to the v22 you released earlier ?
> 
> v22 has most of it included.
> 
> > I'm thinking of backporting any fixes/optimizations to 2.6.22 (and 
> > possibly 2.6.23)
> 
> i have already backported it as v22.1 - will release it within a few 
> days. (once the currently open regressions have been fixed)

i've uploaded what i have at the moment, to:

   http://people.redhat.com/mingo/cfs-scheduler/devel/sched-cfs-v2.6.23.1-v22.1-rc0.patch

	Ingo
