Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZACPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZACPvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 10:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758887AbZACPvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 10:51:05 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:1814 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832AbZACPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:51:04 -0500
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KCWK0J-03-CW0-01
Date: Sat, 3 Jan 2009 16:50:45 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, leo.duran@amd.com,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: amd_iommu.c prealloc_protection_domains should be static
Message-ID: <20090103155044.GA6103@amd.com>
References: <1230567322.26564.16.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1230567322.26564.16.camel@jaswinder.satnam>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Jan 2009 15:50:46.0072 (UTC) FILETIME=[0A968B80:01C96DBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 09:45:22PM +0530, Jaswinder Singh Rajput wrote:
> Impact: cleanup, reduce kernel size a bit, avoid sparse warning
> 
> Fixes sparse warning:
> arch/x86/kernel/amd_iommu.c:1299:6: warning: symbol 'prealloc_protection_domains' was not declared. Should it be static?

Applied, thanks.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

