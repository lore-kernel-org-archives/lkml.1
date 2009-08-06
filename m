Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZHFHgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZHFHgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZHFHgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:36:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55654 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZHFHgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:36:03 -0400
Date: Thu, 6 Aug 2009 09:35:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Valdis.Kletnieks@vt.edu,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf: "Longum est iter per praecepta, breve et efficax per
	exempla"
Message-ID: <20090806073553.GA32074@elte.hu>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org> <20090804195717.GA5998@elte.hu> <16246.1249484030@turing-police.cc.vt.edu> <20090805185334.GA4535@Pilar.aei.mpg.de> <84144f020908060008x34a320e2nc6a6bf8a665e51b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908060008x34a320e2nc6a6bf8a665e51b4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Carlos,
> 
> On Wed, Aug 5, 2009 at 9:53 PM, Carlos R. Mafra<crmafra2@gmail.com> wrote:
> > A few examples of how 'perf' can be used, from an e-mail by
> > Ingo Molnar http://lkml.org/lkml/2009/8/4/346.
> >
> > Signed-off-by: Carlos R. Mafra <crmafra2@gmail.com>
> > ---
> >
> > This "patch" is my way of _suggesting_ some "documentation by examples"
> > of what 'perf' can do to the guys who can really write it :-)
> 
> I was also looking for a perf "cookbook" and Ingo suggested we should
> put this stuff on the kernel.org wiki:
> 
> http://perf.wiki.kernel.org/index.php/Main_Page
> 
> How about just putting the email there?

Would be excellent. Carlos, do you have time to format those 
examples over into the wiki and send a patch with an URL to the 
wiki?

	Ingo
