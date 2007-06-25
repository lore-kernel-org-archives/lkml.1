Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbXFYKCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbXFYKCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXFYKCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:02:25 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:61514 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbXFYKCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:02:24 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 25 Jun 2007 12:01:57 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Ioan Ionita" <opslynx@gmail.com>
cc: discuss@x86-64.org, "LKML" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [discuss] [1/2] 2.6.22-rc6: known regressions
Message-ID: <20070625100157.GI12212@amd.com>
References: <467F8B35.4010906@googlemail.com>
 <467F8F78.8090700@googlemail.com>
MIME-Version: 1.0
In-Reply-To: <467F8F78.8090700@googlemail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 25 Jun 2007 10:02:12.0840 (UTC)
 FILETIME=[E6D41680:01C7B70F]
X-WSS-ID: 6A614D2D23K1267855-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:48:40AM +0200, Michal Piotrowski wrote:
> x86-64
> 
> Subject    : x86-64 2.6.22-rc2 random segfaults
> References : http://lkml.org/lkml/2007/5/24/275
> Submitter  : Ioan Ionita <opslynx@gmail.com>
> Status     : Unknown

Ioan,

do you have any news regarding this regression? Does it still happen
with the latest 2.6.22-rc5/6 or have you found a way to reproduce this?

Thanks,

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


