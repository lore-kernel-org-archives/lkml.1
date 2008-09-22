Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYIVQXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYIVQXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYIVQXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:23:37 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4436 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYIVQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:23:36 -0400
X-BigFish: VPS-32(z1039oz1432R98dR936eQ1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7LUUM-04-0YK-01
Date: Mon, 22 Sep 2008 18:23:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080922162314.GC24392@amd.com>
References: <20080920060059.GA25713@elte.hu> <20080920225705C.fujita.tomonori@lab.ntt.co.jp> <20080922111730.GF5987@elte.hu> <20080923002516R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080923002516R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 16:23:14.0613 (UTC) FILETIME=[83760E50:01C91CCF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 12:25:24AM +0900, FUJITA Tomonori wrote:
> 
> I'm not sure we can because he has a quite different opinion on this,
> he thinks that the IOMMU parameters are unimportant and minor issue.
> 

Stop your personal attacks and come down. I've never said that iommu
parameters are unimportant. The _move_ of the iommu=[no]fullflush to
generic code is a minor issue in my opinion. For the user it changes
nothing. There was an iommu=fullflush parameter before and now there is
also an iommu=fullflush parameter. The only difference is that it now
affects AMD IOMMU too.

> I'm against adding new generic IOMMU parameters without serious
> consideration. Joerg thinks that we can clean up the parameters like
> adding some for 2.6.28, then add some for 2.6.X, then rename some, in
> an ad-hoc way.

Again. Stop your personal attacks.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

