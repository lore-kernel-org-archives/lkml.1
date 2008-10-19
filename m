Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbYJSVWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbYJSVWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 17:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYJSVWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 17:22:24 -0400
Received: from 8bytes.org ([88.198.83.132]:53944 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYJSVWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 17:22:24 -0400
Date: Sun, 19 Oct 2008 23:22:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
Message-ID: <20081019212222.GH21841@8bytes.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org> <20081019111203.GB29705@8bytes.org> <1224415198.6770.1464.camel@macbook.infradead.org> <20081019124732.GA21115@elte.hu> <1224422474.6770.1475.camel@macbook.infradead.org> <20081019172651.GA19265@elte.hu> <1224438164.6770.1493.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224438164.6770.1493.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 06:42:44PM +0100, David Woodhouse wrote:
> On Sun, 2008-10-19 at 19:26 +0200, Ingo Molnar wrote:

> > it's tip/auto-iommu-next.
> 
> I have no idea what that means.
> 
> I tried 'locate auto-iommu-next' on master.kernel.org, but that doesn't
> seem to find anything -- is it elsewhere?

It means the branch 'auto-iommu-next' in the -tip tree.

> > hm, no patches have been lost that i'm aware of - the last ~10 days of 
> > inbox is not queued up yet because of the merge window - but those 
> > (except for urgent fixes) are v2.6.29 items anyway.
> 
> There were patches outstanding which depended on both the interrupt
> remapping and the KVM work. And which add IA64 support for VT-d.

The x86 maintainers are not responsible for IA64 patches AFAIK. The KVM
work will be merged by Avi.

Joerg
