Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbZDBQEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbZDBQEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZDBQEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:04:21 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:43276 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZDBQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:04:20 -0400
Date: Thu, 2 Apr 2009 18:03:44 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mikael Starvik <mikael.starvik@axis.com>, dev-etrax <dev-etrax@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "travis@sgi.com" <travis@sgi.com>
Subject: Re: [PULL] cpumask updates for cris
Message-ID: <20090402160343.GX31562@axis.com>
References: <200903161444.15684.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903161444.15684.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 05:14:15AM +0100, Rusty Russell wrote:
> The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
>   Kyle McMartin (1):
>         parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-cris.git master
> 
> Rusty Russell (3):
>       cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: cris
>       cpumask: Use accessors code.: cris
>       cpumask: use mm_cpumask() wrapper: cris
> 
>  arch/cris/arch-v32/kernel/smp.c |   10 +++++-----
>  arch/cris/arch-v32/mm/tlb.c     |    2 +-
>  arch/cris/kernel/setup.c        |    2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)

Thanks, I've pulled this into the CRIS tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
