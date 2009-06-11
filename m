Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbZFKLfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbZFKLfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZFKLfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:35:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZFKLfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:35:47 -0400
Date: Thu, 11 Jun 2009 13:35:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
Message-ID: <20090611113512.GA6971@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
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


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Linus,
> 
> The following changes since commit 991ec02cdca33b03a132a0cacfe6f0aa0be9aa8d:
>   Linus Torvalds (1):
>         Merge branch 'tracing-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 for-linus

Thanks Pekka for sorting this out - this tree looks nice and it does 
not conflict with anything we have pending. I started testing it on 
6 boxes - if you dont hear from me within a few hours it's all fine.

	Ingo
