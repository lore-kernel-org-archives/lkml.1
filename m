Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbZCaOZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbZCaOZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbZCaOYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:24:54 -0400
Received: from gw.goop.org ([64.81.55.164]:51072 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbZCaOYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:24:54 -0400
Message-ID: <49D227B2.3000807@goop.org>
Date: Tue, 31 Mar 2009 07:24:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] swiotlb: use swiotlb_alloc_boot to allocate emergency
 pool
References: <49D16916.5000103@goop.org> <20090331172554E.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090331172554E.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This is a patch for a tree for dom0? I have no idea what xen-iommu.c
> is doing (I don't know if dom0 support will be merged into mainline or
> not). But the change to lib/swiotlb.c is fine by me.
>   

Yes, sorry, I was just asking about the lib/swiotlb.c change.

Thanks,
    J
