Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbYEERZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbYEERZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYEERZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:25:38 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:32067 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495AbYEERZg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:25:36 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
Date: Mon, 5 May 2008 10:25:33 -0700
In-reply-to: <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
Thread-Index: Acit8rAi6R8bI3OlTTCCa51JHFPCNQA4jVEw
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <monstr@seznam.cz>, <linux-kernel@vger.kernel.org>
Cc: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <john.williams@petalogix.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 05 May 2008 17:25:35.0208 (UTC) FILETIME=[07328E80:01C8AED5]
Message-Id: <20080505172535.9710319B8086@mail101-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think it would be nice if dts files were stored in boot/dts, as on
powerpc, which would reduce confusion.

Steve

> -----Original Message-----
> From: monstr@seznam.cz [mailto:monstr@seznam.cz]
> Sent: Sunday, May 04, 2008 4:41 AM
> To: linux-kernel@vger.kernel.org
> Cc: arnd@arndb.de; linux-arch@vger.kernel.org; Stephen Neuendorffer;
John Linn;
> john.williams@petalogix.com; matthew@wil.cx; will.newton@gmail.com;
drepper@redhat.com; microblaze-
> uclinux@itee.uq.edu.au; grant.likely@secretlab.ca; Michal Simek
> Subject: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
> 
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/platform/generic/system.dts |  137
+++++++++++++++++++++++++++
>  1 files changed, 137 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/platform/generic/system.dts

