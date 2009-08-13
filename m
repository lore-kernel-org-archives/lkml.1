Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZHMKik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZHMKik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZHMKij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:38:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:59866 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZHMKij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:38:39 -0400
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090813085505.GA10671@elte.hu>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1250142522.3587.110.camel@pasglop>
	 <20090813160625B.fujita.tomonori@lab.ntt.co.jp>
	 <20090813074131.GH12143@elte.hu> <1250150981.3587.157.camel@pasglop>
	 <20090813085505.GA10671@elte.hu>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 20:38:20 +1000
Message-Id: <1250159900.24143.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 10:55 +0200, Ingo Molnar wrote:

> > Or we can have the patches in core/iommu and I pull the whole 
> > thing in powerpc-next. [...]
> 
> Ok! We could also stage it a bit (one or two weeks) in a separate 
> branch and allow a rebase, should you find any bugs during testing?

Sounds like a plan.

I'll try to sort that out tomorrow, I can stick them in my -test branch
(which is rebase friendly) for a while too.

Cheers,
Ben.


