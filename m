Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZHMIIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZHMIIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZHMIIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:08:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:34723 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbZHMIIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:08:16 -0400
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.org,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <s5h4osc429m.wl%tiwai@suse.de>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1250142522.3587.110.camel@pasglop> <1250146313.3587.113.camel@pasglop>
	 <s5h4osc429m.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 18:07:57 +1000
Message-Id: <1250150877.3587.155.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 09:11 +0200, Takashi Iwai wrote:
> I'm willing to rebase my patches to the generic dma_ops, so feel free
> to pull it first.

I think I'll end up pulling Ingo's iommu branch into powerpc-next to
get Fujita stuff, so if you rebase on top of his stuff, it will come
along just fine.

> It might need to add mmap_coherent op to all platforms when generic
> dma ops is used.  This would be more volume but less hackish than the
> previous version, OTOH :)
> 
Right :-)

Cheers,
Ben.


