Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbXLDPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbXLDPLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXLDPK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:10:59 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:17830 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557AbXLDPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:10:58 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Tue, 4 Dec 2007 16:06:52 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86_64: define all _PAGE_* in terms of
 _PAGE_BIT_*
Message-ID: <20071204150652.GJ6945@amd.com>
References: <11966016811565-git-send-email-joerg.roedel@amd.com>
 <11966016814058-git-send-email-joerg.roedel@amd.com>
 <20071204123809.GD27286@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20071204123809.GD27286@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Dec 2007 15:06:53.0188 (UTC)
 FILETIME=[4DAF5440:01C83687]
X-WSS-ID: 6B4BB2BC2IW3683937-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 01:38:09PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +#define _PAGE_PRESENT	(_AC(1,UL)<<_PAGE_BIT_PRESENT)
> 
> please run patches through scripts/checkpatch.pl, it gives:
> 
>   total: 10 errors, 0 warnings, 42 lines checked
> 
> (please send a followup cleanup patch - i picked up your series and this 
> is a minor cleanliness issue)

Sorry, forgot to check the patches before submission. Will cleanup and
resubmit soon.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


