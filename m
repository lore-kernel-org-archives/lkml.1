Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYLOP1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYLOP1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 10:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYLOP1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 10:27:10 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:42603 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYLOP1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 10:27:09 -0500
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBXC8S-04-V3K-01
Date: Mon, 15 Dec 2008 16:26:55 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Vrabel <david.vrabel@csr.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] AMD IOMMU: use dev_name instead of self-build print_devid
Message-ID: <20081215152655.GI3407@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com> <1229350685-3816-4-git-send-email-joerg.roedel@amd.com> <494674E2.3090602@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <494674E2.3090602@csr.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 15 Dec 2008 15:26:55.0306 (UTC) FILETIME=[8FEFBAA0:01C95EC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 03:16:50PM +0000, David Vrabel wrote:
> Joerg Roedel wrote:
> > Impact: use generic dev_name instead of own function
>   ^^^^^^
> This has been bugging me for a while.  This word is redundant.

The x86 maintainers want it. I guess it is a grep-pointer or something.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

