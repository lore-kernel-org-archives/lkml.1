Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYIIHFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYIIHFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYIIHF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:05:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:34055 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbYIIHF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:05:28 -0400
Date: Tue, 9 Sep 2008 16:04:38 +0900
To: mingo@elte.hu
Cc: steven@uplinklabs.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH] x86: unused variable in dma_alloc_coherent_gfp_flags()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080909065736.GC27747@elte.hu>
References: <1220915951-11434-2-git-send-email-steven@uplinklabs.net>
	<1220915951-11434-3-git-send-email-steven@uplinklabs.net>
	<20080909065736.GC27747@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080909160455J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 08:57:36 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Noonan <steven@uplinklabs.net> wrote:
> 
> > Fixed a warning caused by a badly placed ifdef.
> > 
> > Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> 
> applied to tip/x86/iommu - thanks Steven,

Did you apply the same patch yesterday?

http://lkml.org/lkml/2008/9/8/274
