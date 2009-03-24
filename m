Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZCXMDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZCXMDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbZCXMDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:03:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836AbZCXMC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:02:59 -0400
Date: Tue, 24 Mar 2009 13:02:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perfcounters: update documentation
Message-ID: <20090324120244.GA32596@elte.hu>
References: <18886.51820.50701.744446@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18886.51820.50701.744446@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Impact: documentation fix
> 
> This updates the perfcounter documentation to reflect recent changes.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> Ingo, please pull this from the master branch of my perfcounters.git
> repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master
> 
>  Documentation/perf-counters.txt |  268 +++++++++++++++++++++++++++++----------
>  1 files changed, 202 insertions(+), 66 deletions(-)

pulled, thanks Paul!

	Ingo
