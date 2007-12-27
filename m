Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbXL0EoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbXL0EoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 23:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXL0EoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 23:44:09 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:46996 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXL0EoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 23:44:07 -0500
To: balbir@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <47732C41.7000003@linux.vnet.ibm.com>
References: <20071224044850.GA11449@linux.vnet.ibm.com>
	<20071227121108L.fujita.tomonori@lab.ntt.co.jp>
	<47732C41.7000003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071227134335O.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 27 Dec 2007 13:43:35 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 10:08:25 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 24 Dec 2007 10:18:50 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> [snip]
> 
> > 
> > I might break the IOMMU code. Can you reproduce it easily? If so,
> > reverting my IOMMU patches (I've attached a patch to revert them) fix
> > the problem?
> 
> [snip]
> 
> 
> Yes, this patch fixes the problem for me.

Thanks, so you can reproduce it easily, right?

The problem is that I don't want to revert these changes. I'll see
how these changes cause the problem shortly.
