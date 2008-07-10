Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYGJSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYGJSiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYGJSiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:38:16 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:28609 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYGJSiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:38:16 -0400
X-BigFish: VPS-35(zz1432R98dR7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3SZR0-04-XMS-01
Date: Thu, 10 Jul 2008 20:37:00 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 14/34] AMD IOMMU: clue initialization code together
Message-ID: <20080710183700.GS14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-15-git-send-email-joerg.roedel@amd.com> <20080709185512.6355159c.akpm@linux-foundation.org> <20080710123747.GK14977@amd.com> <20080710060351.770992cc.akpm@linux-foundation.org> <20080710133136.GQ14977@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080710133136.GQ14977@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 18:37:00.0307 (UTC) FILETIME=[F0944630:01C8E2BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 03:31:36PM +0200, Joerg Roedel wrote:
> 
> Yeah ok, I agree. Thanks for your review and comments. I try to push out
> the updates today.

Ok, I am done with the patches (except the ones that do not only touch
my code). They are not as small as I expected so I will test them over
the night before posting. I everything goes well I send them out
tomorrow morning.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

