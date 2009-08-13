Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZHMRI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZHMRI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZHMRI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:08:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:52670 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZHMRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:08:28 -0400
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
 failure
From: David Woodhouse <dwmw2@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <3877989d0908130200k6d016a74w1947dc6bcd368a7f@mail.gmail.com>
References: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	 <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
	 <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
	 <1250153373.29180.225.camel@macbook.infradead.org>
	 <3877989d0908130200k6d016a74w1947dc6bcd368a7f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 18:08:18 +0100
Message-Id: <1250183298.29180.853.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 17:00 +0800, Luming Yu wrote:
> Yes the flood of dmar_fault on my HP compaq Dc7800u (my x86_64 linux
> desktop) has been fixed. But I still have an iommu casued boot problem
> on a ia64 box.

Really? Even after http://git.kernel.org/linus/51b89f7a6615 ?]

Fenghua will be very interested if that's true. I'm not -- I just hate
you for having the hardware. :)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

