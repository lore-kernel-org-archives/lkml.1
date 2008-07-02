Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYGBCpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYGBCpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYGBCo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:44:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:40102 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYGBCo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:44:57 -0400
Date: Wed, 2 Jul 2008 11:37:27 +0900
To: alexisb@us.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, mingo@elte.hu
Subject: Re: [PATCH -mm] fix per-device dma_mapping_ops support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1214949124.6553.9.camel@alexis>
References: <20080612172554X.fujita.tomonori@lab.ntt.co.jp>
	<1214949124.6553.9.camel@alexis>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080702113711Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2008 14:52:04 -0700
Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> Where are we with with this patch-- as well as the needed calgary
> update:

This patch has been in the -mm:

dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch

I hope that the dma-mapping-per-device patchset gets into mainline in
2.6.27.

 
> http://marc.info/?l=linux-kernel&m=121329005131176&w=2
> 
> Are they at a state where they can be picked-up?  If not what is needed
> to progress?

The updated patch to fix the Calgary IOMMU driver looks fine to
me. Andrew, can you put it in the -mm?

Thanks,
