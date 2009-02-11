Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZBKMky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZBKMky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZBKMko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:40:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZBKMko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:40:44 -0500
Date: Wed, 11 Feb 2009 13:40:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: J K Rai <jk.anurag@yahoo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: Time slice for SCHED_BATCH ( CFS)
Message-ID: <20090211124031.GG16535@elte.hu>
References: <315626.71453.qm@web94713.mail.in2.yahoo.com> <20090211102024.GI20518@elte.hu> <1234348436.23438.119.camel@twins> <303179.28635.qm@web94707.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <303179.28635.qm@web94707.mail.in2.yahoo.com>
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


* J K Rai <jk.anurag@yahoo.com> wrote:

> Thanks,
> 
> I want to do profiling (e.g. on-chip cache related behavior of processes) from 
> user-land and want to study the impact of time-slice and sampling interval on the 
> quality of profile. Hence thought of knowing the time-slice.

btw., how do you do that profiling? How do you measure cache behavior?

	Ingo
