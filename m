Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbYJSLMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbYJSLMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 07:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYJSLMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 07:12:08 -0400
Received: from 8bytes.org ([88.198.83.132]:34350 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYJSLMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 07:12:07 -0400
Date: Sun, 19 Oct 2008 13:12:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       fenghua.yu@intel.com, tony.luck@intel.com, suresh.b.siddha@intel.com,
       sfr@canb.auug.org.au, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
Message-ID: <20081019111203.GB29705@8bytes.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224343843.6770.1378.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 04:30:43PM +0100, David Woodhouse wrote:
> As previously threatened, I've created an iommu-2.6.git tree:
> 	git://git.infradead.org/iommu-2.6.git
> 	http://git.infradead.org/iommu-2.6.git

Is there a specific reason why IOMMU stuff should go to Linus without
testing them in the x86 tree before? The DMA layer and IOMMU drivers are
an integral component of the architecture and patches for it are best
placed in the architecture tree instead of a seperate one, imho.

Joerg

