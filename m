Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbXH0Pbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbXH0Pbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbXH0Pbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:31:45 -0400
Received: from mail0.lsil.com ([147.145.40.20]:65347 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbXH0Pbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:31:44 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Linux-Kernel MAINTAINERS - LSILOGIC MPT FUSION DRIVERS
Date: Mon, 27 Aug 2007 09:30:55 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70940794@NAMAIL4.ad.lsil.com>
In-Reply-To: <1188000155.32738.183.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux-Kernel MAINTAINERS - LSILOGIC MPT FUSION DRIVERS
Thread-Index: Acfmq0AJyXhA4keVTJGSPr7EnbFUHwCE279A
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Joe Perches" <joe@perches.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Aug 2007 15:30:57.0191 (UTC) FILETIME=[437B7370:01C7E8BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On  Friday, August 24, 2007 6:03 PM,  Joe Perches wrote:
> 
> The MPT driver subsystem block has an invalid
> list address of mpt_linux_developer@lsi.com
> 
> Is there a replacement address?
> 
> LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
> P:	Eric Moore
> M:	Eric.Moore@lsi.com
> M:	support@lsi.com
> L:	mpt_linux_developer@lsi.com
> 


Yes it was changed to DL-MPTFusionLinux@lsi.com.     I had posted a
patch about a month back, along with the changes for all the driver
sources.   You will notice the sources were updated
(driver/message/fusion), I have no idea why MAINTAINERS didn't'.

Eric
