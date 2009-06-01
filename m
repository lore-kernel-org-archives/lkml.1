Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZFAEt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZFAEt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 00:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZFAEtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 00:49:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45527
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZFAEtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 00:49:09 -0400
Date: Sun, 31 May 2009 21:49:09 -0700 (PDT)
Message-Id: <20090531.214909.210785519.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: reif@earthlink.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sparc: unify dma-mapping_32.h and dma-mapping_64.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090601111831L.fujita.tomonori@lab.ntt.co.jp>
References: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4A1F58E8.3090307@earthlink.net>
	<20090601111831L.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 1 Jun 2009 11:18:38 +0900

> On Thu, 28 May 2009 23:39:20 -0400
> Robert Reif <reif@earthlink.net> wrote:
> 
>> FUJITA Tomonori wrote:
>> > This patchset unifies dma-mapping_32.h and dma-mapping_64.h, that is,
>> > it uses dma-mapping.h instead and removes dma-mapping_32.h and
>> > dma-mapping_64.h.
>> >   
>> I just boot tested this patch set on sparc32 and it works fine.
> 
> Great, thanks a lot!
> 
> David, any comments?

It's simply in my backlog as I've been concentrating exclusively
on networking and have had zero time for Sparc lately.
