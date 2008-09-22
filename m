Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYIVRXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYIVRXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYIVRXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:23:03 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:63886 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYIVRXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:23:01 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K7LXLP-03-0VK-01
Date: Mon, 22 Sep 2008 19:22:41 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off"
Message-ID: <20080922172241.GE24392@amd.com>
References: <20080922142713.GA24392@amd.com> <20080922235421A.fujita.tomonori@lab.ntt.co.jp> <20080922163109.GD24392@amd.com> <20080923020639U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080923020639U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 17:22:41.0414 (UTC) FILETIME=[D170B260:01C91CD7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 02:07:07AM +0900, FUJITA Tomonori wrote:
> 
> Sure, Ingo's suggestion looks consistent, but these parameters
> interact other parameters. If we are serious about improving the IOMMU
> parameters, we need to spend more time to think about the final
> picture of all the IOMMU parameters that we need.
> 

I am curiously looking forward to your proposal.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

