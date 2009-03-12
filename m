Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZCLK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZCLK2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZCLK1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:27:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbZCLK1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:27:05 -0400
Date: Thu, 12 Mar 2009 11:26:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090312102645.GA25792@elte.hu>
References: <200903121453.45163.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903121453.45163.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Phew.  One core patch (the first one), the rest x86-specific.
> 
> This doesn't quite get rid of all the cpumask_t and old cpus functions:
> the rest are either the work_on_cpus patches (which will come separately)
> or require core changes which are in my tree.
> 
> Thanks!
> Rusty.
> 
> The following changes since commit 8851485ba842e892adfa343463ce6b74550bb8b1:    
>   Ingo Molnar (1):                                                              
>         Merge branch 'x86/urgent'                                               
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-x86.git cpus4096

Pulled into tip:cpus4096, thanks Rusty!

	Ingo
