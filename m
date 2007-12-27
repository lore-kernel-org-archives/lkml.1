Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbXL0Eiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbXL0Eiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 23:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXL0Eij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 23:38:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39698 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXL0Eii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 23:38:38 -0500
Message-ID: <47732C41.7000003@linux.vnet.ibm.com>
Date: Thu, 27 Dec 2007 10:08:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
References: <20071224044850.GA11449@linux.vnet.ibm.com> <20071227121108L.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071227121108L.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 24 Dec 2007 10:18:50 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
[snip]

> 
> I might break the IOMMU code. Can you reproduce it easily? If so,
> reverting my IOMMU patches (I've attached a patch to revert them) fix
> the problem?

[snip]


Yes, this patch fixes the problem for me.
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
