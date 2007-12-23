Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbXLWLMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbXLWLMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 06:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXLWLMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 06:12:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbXLWLMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 06:12:30 -0500
Date: Sun, 23 Dec 2007 12:10:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071223111004.GA2259@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071223110456.GB10818@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223110456.GB10818@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0080]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> > 
> > - This kernel doesn't work on i386!
> > 
> >   It oopses late in boot due to an unrevertable change (e3c1b141) in 
> >   git-x86 which I stared at for a while then I ran out of time and 
> >   gave up.
> 
> hm, the fix for that is in x86.git already - perhaps you got an older 
> copy?

hm, e3c1b141 is already the latest one.

	Ingo
