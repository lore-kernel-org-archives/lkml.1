Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZFACSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZFACSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 22:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZFACSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 22:18:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:50805 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZFACSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 22:18:43 -0400
Date: Mon, 1 Jun 2009 11:18:38 +0900
To: reif@earthlink.net
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sparc: unify dma-mapping_32.h and dma-mapping_64.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A1F58E8.3090307@earthlink.net>
References: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4A1F58E8.3090307@earthlink.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090601111831L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 01 Jun 2009 11:18:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 23:39:20 -0400
Robert Reif <reif@earthlink.net> wrote:

> FUJITA Tomonori wrote:
> > This patchset unifies dma-mapping_32.h and dma-mapping_64.h, that is,
> > it uses dma-mapping.h instead and removes dma-mapping_32.h and
> > dma-mapping_64.h.
> >   
> I just boot tested this patch set on sparc32 and it works fine.

Great, thanks a lot!

David, any comments?
