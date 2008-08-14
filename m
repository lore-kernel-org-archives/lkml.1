Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYHNJYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYHNJYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYHNJYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:24:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYHNJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:24:44 -0400
Date: Thu, 14 Aug 2008 11:24:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       menage@google.com, a.p.zijlstra@chello.nl, vegard.nossum@gmail.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
	(take 4)
Message-ID: <20080814092424.GB18771@elte.hu>
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com> <20080811183122.acd25489.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811183122.acd25489.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

>   Acked-by: Paul Jackson <pj@sgi.com>
> 
> ... based on code reading and comparing with the
> previous version - looks good.  Nice work, Max.
> Thanks.

applied to tip/sched/cpuset, thanks. (will show up in tip/sched/urgent 
as well soon, for v2.6.27 merging.)

	Ingo
