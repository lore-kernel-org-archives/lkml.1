Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbZH0Hgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbZH0Hgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZH0Hgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:36:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:54727 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZH0Hgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:36:52 -0400
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090827072208.GA2131@elte.hu>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1250142522.3587.110.camel@pasglop>
	 <20090813160625B.fujita.tomonori@lab.ntt.co.jp>
	 <20090813074131.GH12143@elte.hu> <1250150981.3587.157.camel@pasglop>
	 <20090813085505.GA10671@elte.hu> <1251342735.20467.2.camel@pasglop>
	 <1251343070.20467.3.camel@pasglop>  <20090827072208.GA2131@elte.hu>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 17:36:40 +1000
Message-Id: <1251358600.20467.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 09:22 +0200, Ingo Molnar wrote:
> 
> ah, yes, they are stable/fine. I've put it into a separate branch 
> for you.
> 
> Ben, please pull the latest iommu-for-powerpc git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> iommu-for-powerpc
> 
> And i could pull back the new bits from you once you have the new 
> patches added and are happy with them. [I suspect you dont want the 
> diffstat below in the powerpc tree]
> 
> That was the plan, right?

Sure, no problem. I'll stick that in powerpc-next tomorrow hopefully.

Cheers,
Ben.

