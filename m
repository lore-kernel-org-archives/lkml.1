Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYIVSeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYIVSeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYIVSef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:34:35 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:48475 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYIVSee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:34:34 -0400
X-BigFish: VPS-23(z1039oz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7M0WX-03-46E-01
Date: Mon, 22 Sep 2008 20:34:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080922183414.GI24392@amd.com>
References: <20080922111730.GF5987@elte.hu> <20080923002516R.fujita.tomonori@lab.ntt.co.jp> <20080922162314.GC24392@amd.com> <20080923015059M.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080923015059M.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 18:34:14.0445 (UTC) FILETIME=[D0493DD0:01C91CE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 01:51:05AM +0900, FUJITA Tomonori wrote:
> The patch that I sent doesn't make any changes for you. GART works as
> before and AMD IOMMU takes a new parameter, fullflush, as you want. It
> does the exact same thing that the first version of your patchset for
> 2.6.28.
> 
> So please let me apply it then we can stop this discussion.

Ok, so it was not nice from me to let Ingo pull this patch without your
ack, I already admitted. To end this discussion and get to productive
discussions, Ingo, please apply this patch. I hope we will work together
on a final solution for the problem.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

