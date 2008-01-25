Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYAYDwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYAYDwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYAYDwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:52:07 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62942 "EHLO
	outbound8-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbYAYDwG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:52:06 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] PCI: modify SB700 SATA MSI quirk
Date: Fri, 25 Jan 2008 11:48:29 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E501BF905@sshaexmb1.amd.com>
In-Reply-To: <4799591B.5090905@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: modify SB700 SATA MSI quirk
Thread-Index: AchfA3jbYhdcdSeLTIeHVtOfAcNBtgAAVvtg
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
 <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
 <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com>
 <B90463BC30D2E446BA423D888DC85E501BF8F0@sshaexmb1.amd.com>
 <4799591B.5090905@gmail.com>
From: "Shane Huang" <Shane.Huang@amd.com>
To: "Tejun Heo" <htejun@gmail.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 03:48:34.0485 (UTC)
 FILETIME=[28D91650:01C85F05]
X-WSS-ID: 6B87839D2IW8741525-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun:


> You need to merge the above two messages into one patch description.
> 
> After S-O-B, you can put --- and between it and the patch 
> body, you can say things which you wanna mention but don't 
> think should be included in commit message.

OK, I'll have to submit another update patch later.




Thanks
Shane


