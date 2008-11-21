Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYKUR2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYKUR2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbYKUR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:27:47 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:1762 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbYKUR1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:27:45 -0500
X-BigFish: VPS-38(zz1432R98dR936eQ1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KAP1TJ-04-1ZV-01
Date: Fri, 21 Nov 2008 18:27:22 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] DMA-API debugging facility
Message-ID: <20081121172722.GG1386@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227286492.4901.208.camel@macbook.infradead.org> <20081121165722.GD1386@amd.com> <1227287215.4901.213.camel@macbook.infradead.org> <20081121171802.GK733@elte.hu> <20081121172046.GF1386@amd.com> <1227288269.4901.222.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1227288269.4901.222.camel@macbook.infradead.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Nov 2008 17:27:22.0633 (UTC) FILETIME=[69D84F90:01C94BFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 05:24:29PM +0000, David Woodhouse wrote:
> On Fri, 2008-11-21 at 18:20 +0100, Joerg Roedel wrote:
> > Ok, I will move the generic bits to lib/ and include/linux and let
> > architectures decide if they want to use it.
> 
> Once you've done that, I'll try to hook it up on PowerPC to make sure it
> works there.

Ok, cool. Thanks

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

